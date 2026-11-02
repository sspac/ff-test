local mod = FiendFolio
local flag = TearFlagsLib.RegisterTearFlag("PALINSOPIA")

local invisibleSubtype = 21

local function UpdateTears(_, tear)

    local td = mod:GetEntityData(tear)
    local ghostBehind = td.PalinopsiaHandler

    if not ghostBehind then
        local player = TearFlagsLib.GetTearPlayer(tear)
        ghostBehind = Isaac.Spawn(mod.FF.BeahInvisible.ID, mod.FF.BeahInvisible.Var, invisibleSubtype, tear.Position, Vector.Zero, player)
        td.PalinopsiaHandler = ghostBehind
        local gd = mod:GetEntityData(ghostBehind)
        gd.p_damageZones = gd.p_damageZones or {}
        gd.p_killSwitch = tear.Index
        
    end
    local gd = mod:GetEntityData(ghostBehind)

    gd.P_Die = 0

    if tear.FrameCount % 3 == 1 then
        local sprite = tear:GetSprite()
        mod:hiddenBroadcastEnemy(tear, sprite, true)
    end

    if tear.FrameCount % 7 == 1 then
        local player = TearFlagsLib.GetTearPlayer(tear)
        table.insert(gd.p_damageZones, {pos = tear.Position, rad = tear.Size*0.94, dmg = 0.2*player.Damage})
    end
end

local function tearFlagComplex(_, entity, player, wflag)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.PALINSOPIA) then
        TearFlagsLib.AddTearFlags(entity, flag)
        if entity.Type == EntityType.ENTITY_TEAR then
            mod:AddToTearUpdateList("ff_palinsopia", entity, UpdateTears)
        end
    end
end
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, mod.ITEM.COLLECTIBLE.PALINSOPIA, 			    tearFlagComplex)
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, mod.ITEM.COLLECTIBLE.PALINSOPIA, 	tearFlagComplex)

function mod.handlePalinsopiaD3(entity)
    if entity.Type == EntityType.ENTITY_TEAR then
        mod:AddToTearUpdateList("ff_palinsopia", entity, UpdateTears)
    end
end

mod:AddEntityCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.FF.BeahInvisible.ID, mod.FF.BeahInvisible.Var, invisibleSubtype, function (_, effect)
	if effect.SubType == 21 then
        local gd = mod:GetEntityData(effect)
        if effect.FrameCount % 2 == 0 then
            local hit = {}

            for index, value in ipairs(gd.p_damageZones) do
				if value.timeout then
					value.timeout = value.timeout - 1
				end
				
				if value.timeout == nil or value.timeout > 0 then
					if not value.capsule then
						local capsule = Capsule(value.pos, Vector.One, 0, value.rad)
						value.capsule = capsule
					end
					
					local raw_e = Isaac.FindInCapsule(value.capsule, EntityPartition.ENEMY)

					for _, enemy in ipairs(raw_e) do
						if not enemy:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) and hit[GetPtrHash(enemy)] == nil then
							--print(effect.FrameCount)
							hit[GetPtrHash(enemy)] = true
							enemy:TakeDamage(value.dmg, 0, EntityRef(effect.SpawnerEntity), 0)
						end
					end
                end
            end
        end
        

        gd.P_Die = gd.P_Die + 1
        if gd.P_Die == 13 then
            mod:hiddenKillSignal(gd.p_killSwitch)
            effect:Remove()
        end
    end
end, mod.FF.BeahInvisible.Var)

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.PALINSOPIA] = {
	BodyColor = Color(1,1,1,1,132.221/255,10.699/255,7.442/255,0.372,0.735,0.743,1),
	EyeAColor = Color(1,1,1,1,-71.927/255,-71.927/255,-71.927/255,1.100,1.100,1.100,1),
	EyeBColor = Color(1,1,1,1,-71.927/255,-71.927/255,-71.927/255,1.100,1.100,1.100,1)}
	
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	TearFlagsLib.AddTearFlags(tear, flag)
    mod:AddToTearUpdateList("ff_palinsopia", tear, UpdateTears)
end, FiendFolio.ITEM.COLLECTIBLE.PALINSOPIA)