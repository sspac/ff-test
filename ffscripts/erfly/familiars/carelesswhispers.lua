local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, f)
    f.IsFollower = true
end, mod.ITEM.FAMILIAR.CARELESS_WHISPERS)

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
	local d = mod:GetEntityData(fam)
	local sprite = fam:GetSprite()

    if d.OrbitChangeCoolDown then
        d.OrbitChangeCoolDown = d.OrbitChangeCoolDown - 1
        if d.OrbitChangeCoolDown <= 0 then
            d.OrbitChangeCoolDown = nil
        end
    end

    fam:FollowParent()

    local player = fam.Player
    local shootInput = player:GetAimDirection()
    d.OrbitalOffset = d.OrbitalOffset or fam:GetDropRNG():RandomInt(360)
    d.OrbitalMode = d.OrbitalMode or 1
    local orbitalAdd = 3
    local TargOrbitalDist = 20
    if shootInput:Length() > 0.5 then
        orbitalAdd = 5
        if not d.OrbitChangeCoolDown then
            if d.OrbitalMode == 1 and shootInput.X < 0 then
                d.OrbitalMode = -1
                d.OrbitChangeCoolDown = 60
            elseif d.OrbitalMode == -1 and shootInput.X > 0 then
                d.OrbitalMode = 1
                d.OrbitChangeCoolDown = 60
            end
        end
        TargOrbitalDist = 80
    end
    d.OrbitalDist = d.OrbitalDist or 1
    d.OrbitalDist = mod:Lerp(d.OrbitalDist, TargOrbitalDist, 0.1)

    d.UsedOrbitalMode = d.UsedOrbitalMode or 0
    d.UsedOrbitalMode = mod:Lerp(d.UsedOrbitalMode, d.OrbitalMode, 0.1)
    orbitalAdd = orbitalAdd * d.UsedOrbitalMode
    d.OrbitalOffset = d.OrbitalOffset + orbitalAdd
    d.OrbitalOffset = d.OrbitalOffset % 360

    mod:spritePlay(sprite, "Appear")

    if not d.whisperFam then
        d.whisperFam = {}
        for i = 1, 3 do
            local whisper = Isaac.Spawn(3, mod.ITEM.FAMILIAR.CARELESS_WHISPER_INDIVIDUAL, 0, fam.Position, Vector.Zero, fam):ToFamiliar()
            whisper.Player = fam.Player
            whisper.Parent = fam
            mod:GetEntityData(whisper).OrbitOffset = i
            if i > 1 then
                local wSprite = whisper:GetSprite()
                wSprite:ReplaceSpritesheet(0, "gfx/familiar/careless whispers/careless_whispers" .. i .. ".png")
                wSprite:ReplaceSpritesheet(1, "gfx/familiar/careless whispers/careless_whispers" .. i .. ".png")
                wSprite:LoadGraphics()
            end
            table.insert(d.whisperFam, whisper)
        end
    end
end, mod.ITEM.FAMILIAR.CARELESS_WHISPERS)

local AimDirs = {
	[Direction.LEFT]         = {Anim = "Side", FlipX = true,  Vec = Vector(-1,0)},
	[Direction.RIGHT]        = {Anim = "Side", FlipX = false, Vec = Vector(1,0)},
	[Direction.UP]           = {Anim = "Up",   FlipX = false, Vec = Vector(0,-1)},
	[Direction.DOWN]         = {Anim = "Down", FlipX = false, Vec = Vector(0,1)},
}

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, fam)
	local d = mod:GetEntityData(fam)
	local sprite = fam:GetSprite()
	local isSirenCharmed, charmer = mod:isSirenCharmed(fam)
	
	if not isSirenCharmed and fam.Parent then
        local famParent = fam.Parent:ToFamiliar()
        if famParent and famParent.Player then
            fam.Player = famParent.Player
        end
	end

    if fam.Parent and fam.Parent:Exists() then
        local p = fam.Parent
        local pd = mod:GetEntityData(p)
        if p.FrameCount > 1 and not pd.OrbitalDist then
            fam:Remove()
            return
        end
        local player = fam.Player
        local shootInput = mod.GetCorrectedFiringInput(player)
        local alphaMult = 1
        local state
        if shootInput:Length() > 0.5 then
            state = "orbiting"
            fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ENEMIES
        else
            state = "idle"
            fam.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            alphaMult = 0.2
        end
		local famcolorize = fam.Color:GetColorize()
        fam.Color = Color(fam.Color.R,fam.Color.G,fam.Color.B,mod:Lerp(fam.Color.A, alphaMult,0.1),fam.Color.RO,fam.Color.GO,fam.Color.BO,famcolorize[1],famcolorize[2],famcolorize[3],famcolorize[4])

        local targPos = p.Position + Vector(pd.OrbitalDist or 1,0):Rotated((pd.OrbitalOffset or 0) + (d.OrbitOffset * 120))
        local vec = (targPos - fam.Position)
        fam.Velocity = mod:Lerp(fam.Velocity, vec, 0.3)

        if state == "idle" then
            sprite:SetFrame("IdleDown", fam.FrameCount % 16)
            fam.FireCooldown = math.max(10, fam.FireCooldown)
        elseif state == "orbiting" then
            if d.shooting then
                sprite:SetFrame(d.shootAnim, fam.FrameCount % 16)
                d.shooting = d.shooting - 1
                if d.shooting <= 0 then
                    d.shooting = nil
                    sprite.FlipX = false
                end
            else
                sprite:SetFrame("Spin", fam.FrameCount % 16)
                if fam.FireCooldown == 0 then
                    local aimDir = player:GetFireDirection()
                    if aimDir ~= Direction.NO_DIRECTION then
                        fam.FireCooldown = 60
                        d.shooting = 10
                        d.shootAnim = "Shoot" .. AimDirs[aimDir].Anim
                        sprite.FlipX = AimDirs[aimDir].FlipX
                        local tearVec = AimDirs[aimDir].Vec
                        for i = 1, (isSirenCharmed and 1) or 3 do
                            local tear = fam:FireProjectile(tearVec)
                            tear.Velocity = tear.Velocity:Rotated(-5 + math.random(10))
                            tear.Velocity = tear.Velocity * (1.6 - (0.2 * i))
                            tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
                            tear.Color = Color(0.5,0.5,0.5,0.5,0.7,0.7,0.7)
                            sfx:Play(SoundEffect.SOUND_BEAST_GHOST_DASH,0.5,0,false,4 + math.random(200)/100)
                        end
                    end
                end
            end
        end
        local mult = player:GetTrinketMultiplier(TrinketType.TRINKET_FORGOTTEN_LULLABY)
        fam.FireCooldown = math.max(0, fam.FireCooldown - (1 + mult))
    else
        fam:Remove()
    end
end, mod.ITEM.FAMILIAR.CARELESS_WHISPER_INDIVIDUAL)
	
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, helper)
	if helper.Target and 
	   helper.Target.Type == EntityType.ENTITY_FAMILIAR and 
	   helper.Target.Variant == mod.ITEM.FAMILIAR.CARELESS_WHISPERS 
	then
		if helper.FrameCount == 0 then
			for _,seg in ipairs(mod:GetEntityData(helper.Target).whisperFam) do
				if seg:Exists() and not mod:isSirenCharmed(seg) and helper.Parent and helper.Parent:Exists() then
					local segmenthelper = Isaac.Spawn(EntityType.ENTITY_SIREN_HELPER, 0, 0, seg.Position, Vector.Zero, nil):ToNPC()
					segmenthelper.Parent = helper.Parent
					segmenthelper.Target = seg
					segmenthelper:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					segmenthelper:AddEntityFlags(EntityFlag.FLAG_HIDE_HP_BAR)
					segmenthelper:Update()
					
					seg.Player = helper.Target:ToFamiliar().Player
					seg.Color = Color(1,0.4,0.4,seg.Color.A,0.18,0.04,0.04,0,0,0,0)
				end
			end
		end
		helper.CollisionDamage = 0
		helper.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		helper:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
	end
end, EntityType.ENTITY_SIREN_HELPER)

mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, function(_, helper, collider, low)
	if collider.Type == 1 then
		if helper.Target and 
		   helper.Target.Type == EntityType.ENTITY_FAMILIAR
		then
			if helper.Target.Variant == mod.ITEM.FAMILIAR.CARELESS_WHISPERS then
				return true
			elseif helper.Target.Variant == mod.ITEM.FAMILIAR.CARELESS_WHISPER_INDIVIDUAL and helper.FrameCount < 5 then
				return true
			end
		end
	else
		if helper.Target and 
		   helper.Target.Type == EntityType.ENTITY_FAMILIAR and
		   helper.Target.Variant == mod.ITEM.FAMILIAR.CARELESS_WHISPERS
		then
			return true
		end
	end
end, EntityType.ENTITY_SIREN_HELPER)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, ent, amount, flags, source, countdown)
	if flags ~= flags | DamageFlag.DAMAGE_CLONES and 
	   ent.Target and 
	   ent.Target.Type == EntityType.ENTITY_FAMILIAR and 
	   (ent.Target.Variant == mod.ITEM.FAMILIAR.CARELESS_WHISPERS or ent.Target.Variant == mod.ITEM.FAMILIAR.CARELESS_WHISPER_INDIVIDUAL)
	then
		local whisper = ent.Target and ((ent.Target.Variant == mod.ITEM.FAMILIAR.CARELESS_WHISPER_INDIVIDUAL and ent.Target.Parent) or ent.Target)
		if whisper then
			local _, maincharmer = mod:isSirenCharmed(whisper)
			if maincharmer and (maincharmer.Index ~= ent.Index or maincharmer.InitSeed ~= ent.InitSeed) then
				maincharmer:TakeDamage(amount, flags | DamageFlag.DAMAGE_CLONES, source, countdown)
			end
			
			local segments = mod:GetEntityData(whisper).whisperFam
			for _,segment in ipairs(segments) do
				local _, segmentcharmer = mod:isSirenCharmed(segment)
				if segmentcharmer and (segmentcharmer.Index ~= ent.Index or segmentcharmer.InitSeed ~= ent.InitSeed) then
					segmentcharmer:TakeDamage(amount, flags | DamageFlag.DAMAGE_CLONES, source, countdown)
				end
			end
		end
	end
end, EntityType.ENTITY_SIREN_HELPER)
	
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, helper)
	if helper.Target and 
	   helper.Target.Type == EntityType.ENTITY_FAMILIAR and 
	   helper.Target.Variant == mod.ITEM.FAMILIAR.CARELESS_WHISPER_INDIVIDUAL
	then
		helper.Target.Color = Color(1,1,1,helper.Target.Color.A)
	end
end, EntityType.ENTITY_SIREN_HELPER)