-- Green Bombs --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local slapVal = 30 --How many frames (30fps) of slap card get added on use
table.insert(mod.nancyCherry, "greenCherry")

local flag = TearFlagsLib.RegisterTearFlag("GREEN_BOMB")
mod.GreenBombsFull = {
	[mod.BombFlagSource.ROCKET] = true,
	[mod.BombFlagSource.BOBS_ROTTEN_HEAD] = true,
	[mod.BombFlagSource.KAMIKAZE] = true,
}
mod.GreenBombsReduction = {
	[mod.BombFlagSource.BOMB] = 2/9,
	[mod.BombFlagSource.DR_FETUS] = 1/2,
	[mod.BombFlagSource.ANARCHISTS_EASY_BAKE] = 2/9,
    [mod.BombFlagSource.MINESWEEPER] = 1/9,
	[mod.BombFlagSource.WRATHFUL_PLUSHIE] = 3/9,
}

function mod:greenBombsFlag(entity, player, sourceFlag)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.GREEN_BOMBS) then
		TearFlagsLib.AddTearFlags(entity, flag)
		if entity.Type == EntityType.ENTITY_BOMB then
			local bomb = entity:ToBomb()
			local countdown = bomb:GetExplosionCountdown()
			local mult = 1
			if not (mod:GetEntityData(entity).FFIsScatter or bomb.Variant == mod.FF.CherryBomb.Var) then
				mult = mod.GreenBombsReduction[sourceFlag] or 1
			end
			local newCountdown = math.ceil(countdown * mult)
			if bomb.Variant == BombVariant.BOMB_TROLL or bomb.Variant == BombVariant.BOMB_SUPERTROLL then
				newCountdown = math.max(newCountdown, 25)
			end
			bomb:SetExplosionCountdown(newCountdown)
		end
	end
end
mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_POLL_BOMBFLAGS, FiendFolio.ITEM.COLLECTIBLE.GREEN_BOMBS, mod.greenBombsFlag)

function mod:greenBombsVariant(bomb, player)
	if player:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.GREEN_BOMBS) then
		local var = bomb.Variant
		if mod:isReplaceableBombVariant(var) then
			if mod:isCopperVariant(var) then
				bomb.Variant = mod.BOMB.GREEN_COPPER
				bomb.Flags = bomb.Flags
			else
				bomb.Variant = mod.BOMB.GREEN
				bomb.Flags = bomb.Flags
			end
		end
	end
end
mod:AddPriorityCollectibleCallback(FiendFolio.CALLBACK.FF_SET_BOMB_VARIANT, 0, FiendFolio.ITEM.COLLECTIBLE.GREEN_BOMBS, mod.greenBombsVariant)

mod:AddCallback(FiendFolio.CALLBACK.FF_POST_BOMBFLAG_EFFECTS, function(_, pos, radius, tearflags, src, radiusMult, player, sourceFlag, tearFlagParams)
	if (sourceFlag == mod.BombFlagSource.BOMB and not mod:GetEntityData(src).FFIsScatter) or mod.GreenBombsFull[sourceFlag] then
		local mult = radius / 75 * radiusMult
		
		--imma be lazy and just reuse the sertraline effect its fine prolly
		FiendFolio.savedata = FiendFolio.savedata or {}
		FiendFolio.savedata.run = FiendFolio.savedata.run or {}
		FiendFolio.savedata.run.slapCardActive = FiendFolio.savedata.run.slapCardActive or 0
		FiendFolio.savedata.run.slapCardActive = FiendFolio.savedata.run.slapCardActive + slapVal * mult
		for k = 0, 1 do
			mod.scheduleForUpdate(function()
				for _, ent in ipairs(Isaac.GetRoomEntities()) do
					local id, var, subt = ent.Type, ent.Variant, ent.SubType
					if mod.slapCardKillers[id] or mod.slapCardKillers[id .. "." .. var] or mod.slapCardKillers[id .. "." .. var .. "." .. subt] then
						if id == 1000 then
							local cloud = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, ent.Position - ent.Velocity, ent.Velocity, ent)
							mod:GetEntityData(cloud).longonly = true
							cloud.SpriteOffset = Vector(0, ent.SpriteOffset.Y * 0.5)
							cloud.SpriteScale = Vector(0.75,0.75) * ent:ToEffect().Scale
							cloud.Color = ent.Color
							cloud:Update()
							ent:Remove()
						else
							ent:Die()
						end
					end
				end
			end, k)
		end
		sfx:Play(mod.Sounds.SlapcardItemActivate, 1, 0, false, mod:RandomInt(130,150,rng)/100)
		game:MakeShockwave(src.Position, 0.035, 0.025, math.floor(10*mult))
	else
		local radius = radius * radiusMult + 10
		for k = 0, 5 do
			mod.scheduleForUpdate(function()
				for _, ent in ipairs(Isaac.GetRoomEntities()) do
					local id, var, subt = ent.Type, ent.Variant, ent.SubType
					if mod.slapCardKillers[id] or mod.slapCardKillers[id .. "." .. var] or mod.slapCardKillers[id .. "." .. var .. "." .. subt] then
						if (ent.Position - pos):Length() < radius + ent.Size then
							if id == 1000 then
								local cloud = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, ent.Position - ent.Velocity, ent.Velocity, ent)
								mod:GetEntityData(cloud).longonly = true
								cloud.SpriteOffset = Vector(0, ent.SpriteOffset.Y * 0.5)
								cloud.SpriteScale = Vector(0.75,0.75) * ent:ToEffect().Scale
								cloud.Color = ent.Color
								cloud:Update()
								ent:Remove()
							else
								ent:Die()
							end
						end
					end
				end
			end, k)
		end
		sfx:Play(mod.Sounds.SlapcardItemActivate, 1, 0, false, mod:RandomInt(130,150,rng)/100)
		game:MakeShockwave(src.Position, 0.025, 0.025, 5)
		
		local splash = Isaac.Spawn(1000, 12, 0, pos, Vector.Zero, src):ToEffect()
		splash.SpriteScale = Vector.One / 60 * 25 * radius / 20
		splash:GetSprite():Load("gfx/enemies/warden/cross.anm2", true)
		splash:GetSprite():Play(anim or "Impact")
		splash:GetSprite():GetLayer(0):SetVisible(false)
		splash:Die()
		splash.Color = Color(1,1,1,0.75,0,0,0,1,1,1,1)
	end
end, flag)

mod:AddCallback(FiendFolio.CALLBACK.POST_FIRE_CHERRY_BOMB, function(_, bomb, player)
	local data = mod:GetEntityData(bomb)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.GREEN_BOMBS) then
		data.greenCherry = true
		data.timer = 25
		bomb:SetExplosionCountdown(25)
	end
end)

mod:AddCallback(FiendFolio.CALLBACK.POST_CHERRY_BOMB_EXPLODE, function(_, bomb, player)
	local data = mod:GetEntityData(bomb)
	if data.greenCherry then
		local radius = 40
		if data.megaCherry then
			radius = 100
		elseif data.FFIsScatter then
			radius = 20
		end
		radius = radius + 10
		
		local positions = {bomb.Position}
		if data.bomberBoyCherry then
			for i=90,360,90 do
				table.insert(positions, bomb.Position+Vector(0,50):Rotated(i))
			end
		end
		for _, pos in ipairs(positions) do
			for k = 0, 5 do
				mod.scheduleForUpdate(function()
					for _, ent in ipairs(Isaac.GetRoomEntities()) do
						local id, var, subt = ent.Type, ent.Variant, ent.SubType
						if mod.slapCardKillers[id] or mod.slapCardKillers[id .. "." .. var] or mod.slapCardKillers[id .. "." .. var .. "." .. subt] then
							if (ent.Position - pos):Length() < radius + ent.Size then
								if id == 1000 then
									local cloud = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, ent.Position - ent.Velocity, ent.Velocity, ent)
									mod:GetEntityData(cloud).longonly = true
									cloud.SpriteOffset = Vector(0, ent.SpriteOffset.Y * 0.5)
									cloud.SpriteScale = Vector(0.75,0.75) * ent:ToEffect().Scale
									cloud.Color = ent.Color
									cloud:Update()
									ent:Remove()
								else
									ent:Die()
								end
							end
						end
					end
				end, k)
			end
		
			local splash = Isaac.Spawn(1000, 12, 0, pos, Vector.Zero, tear):ToEffect()
			splash.SpriteScale = Vector.One / 60 * 25 * radius / 20
			splash:GetSprite():Load("gfx/enemies/warden/cross.anm2", true)
			splash:GetSprite():Play(anim or "Impact")
			splash:GetSprite():GetLayer(0):SetVisible(false)
			splash:Die()
			splash.Color = Color(1,1,1,0.75,0,0,0,1,1,1,1)
		end
		
		sfx:Play(mod.Sounds.SlapcardItemActivate, 1, 0, false, mod:RandomInt(130,150,rng)/100)
		game:MakeShockwave(bomb.Position, 0.025, 0.025, 5)
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.IMPORTANT, function(_, entity, amount, flags, source, countdown)
	if flags & DamageFlag.DAMAGE_EXPLOSION == 0 or entity.Type ~= EntityType.ENTITY_PLAYER or entity:ToPlayer():HasCollectible(CollectibleType.COLLECTIBLE_PYROMANIAC) then
		return
	end
	
	if source.Entity then
		if TearFlagsLib.HasTearFlags(source.Entity, flag) then
			local spawner = source.Entity.SpawnerEntity
			if spawner and GetPtrHash(spawner) == GetPtrHash(entity) then
				return false
			end
		elseif source.Type == EntityType.ENTITY_FAMILIAR and (source.Variant == FamiliarVariant.BBF or
		                                                      source.Variant == FamiliarVariant.BOBS_BRAIN or
		                                                      source.Variant == FamiliarVariant.BLUE_FLY)
		then
			local spawner = source.Entity:ToFamiliar().Player
			if spawner and spawner:HasCollectible(FiendFolio.ITEM.COLLECTIBLE.GREEN_BOMBS) and GetPtrHash(spawner) == GetPtrHash(entity) then
				return false
			end
		end
	end
end)