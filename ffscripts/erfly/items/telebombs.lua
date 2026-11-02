local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local flag = TearFlagsLib.RegisterTearFlag("TELE_BOMB")
mod.CanTelebombs = {
	[mod.BombFlagSource.BOMB] = true,
	[mod.BombFlagSource.DR_FETUS] = true,
	[mod.BombFlagSource.KAMIKAZE] = true,
}
mod.TelebombsVariantBlacklist = {
	[BombVariant.BOMB_DECOY] = true,
	[BombVariant.BOMB_TROLL] = true,
	[BombVariant.BOMB_SUPERTROLL] = true,
	[BombVariant.BOMB_GOLDENTROLL] = true,
	[BombVariant.BOMB_THROWABLE] = true,
	[BombVariant.BOMB_ROCKET] = true,
	[BombVariant.BOMB_ROCKET_GIGA] = true,
	[FiendFolio.BOMB.TROLL_COPPER] = true,
}

function mod:telebombsPlayerUpdate(player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.TELEBOMBS) and not mod:IsBriendTwin(player) then
        local data = mod:GetEntityData(player)
        if (not data.telebombMarker) or (data.telebombMarker and not data.telebombMarker:Exists()) then
            local marker = Isaac.Spawn(1000, mod.FF.TelebombsCrosshair.Var, mod.FF.TelebombsCrosshair.Sub, player.Position, nilvector, player)
            marker.Parent = player
            marker:Update()
            data.telebombMarker = marker
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.ITEM.COLLECTIBLE.TELEBOMBS, mod.telebombsPlayerUpdate)

mod.IgnoreTelebombs = false
function mod:handleTelebombBombInit(entity, player, sourceFlag)
	if not mod.IgnoreTelebombs and mod.CanTelebombs[sourceFlag] then
		if entity.Type == EntityType.ENTITY_BOMB then
			if mod.TelebombsVariantBlacklist[entity.Variant] then
				return
			elseif player:HasCollectible(CollectibleType.COLLECTIBLE_ROCKET_IN_A_JAR) and player:GetAimDirection():Length() > 0.3 then
				return
			end
		end
		local data = mod:GetEntityData(player)
		if data.telebombMarker and mod:GetEntityData(data.telebombMarker).isActive then
			player.Position = data.telebombMarker.Position
            player:SetMinDamageCooldown(5)
			player:SetColor(Color(1,1,1,1,1,1,1),3,1,true,false)
			sfx:Play(SoundEffect.SOUND_HELL_PORTAL1,1,0,false,1)
			data.telebombMarker:Remove()
			data.telebombMarker = nil

			for _, entity in pairs(Isaac.FindInRadius(player.Position, 40, EntityPartition.ENEMY)) do
				if not mod:isFriend(entity) then
					entity:TakeDamage(20, 0, EntityRef(player), 0)
				end
			end

			TearFlagsLib.AddTearFlags(entity, flag)
			local bomb = entity:ToBomb()
			if bomb then
				bomb:SetExplosionCountdown(0)
			end
		end
    end
end
mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_POLL_BOMBFLAGS, FiendFolio.ITEM.COLLECTIBLE.TELEBOMBS, mod.handleTelebombBombInit)

function mod:telebombsMarkerUpdate(e)
    local sprite, d, room = e:GetSprite(), mod:GetEntityData(e), game:GetRoom()
    mod:spritePlay(sprite, "Blink")
    e.DepthOffset = -100

    d.HeldPositions = d.HeldPositions or {}
    local posistionDelay = 22
    if e.Parent and e.Parent:ToPlayer():HasCollectible(mod.ITEM.COLLECTIBLE.TELEBOMBS) then
        local p = e.Parent:ToPlayer()
        table.insert(d.HeldPositions, p.Position)

        local isDisabled
        if e.Position:Distance(p.Position) <= 20 then
            isDisabled = true
        end
        if room:GetGridCollisionAtPos(e.Position) > 0 then
            --print(p.GridCollisionClass)
            if p.GridCollisionClass == 5 then
                isDisabled = true
            end
        end

        if isDisabled then
            d.isActive = false
            e.Color = Color(1,1,1,0.2)
        else
            d.isActive = true
            e.Color = Color(1,1,1,1)
        end

        if #d.HeldPositions > posistionDelay then
            table.remove(d.HeldPositions, 1)
        end
        if d.HeldPositions[posistionDelay] then
            --e.Position = d.HeldPositions[10]
            e.Velocity = d.HeldPositions[1] - e.Position
        else
            e.Velocity = e.Velocity * 0.5
        end
    else
        e:Remove()
    end
end