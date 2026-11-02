local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

local flag = TearFlagsLib.RegisterTearFlag("FOSSIL_BOMB")

function mod:bombSackFossilFlag(entity, player)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.BOMB_SACK_FOSSIL) then
		TearFlagsLib.AddTearFlags(entity, flag)
	end
end
mod:AddTrinketCallback(FiendFolio.CALLBACK.FF_POLL_BOMBFLAGS, FiendFolio.ITEM.ROCK.BOMB_SACK_FOSSIL, mod.bombSackFossilFlag)

mod:AddCallback(FiendFolio.CALLBACK.FF_POST_BOMBFLAG_EFFECTS, function(_, pos, radius, tearflags, src, radiusMult, player, sourceFlag, tearFlagParams)
	local data = mod:GetEntityData(src)
	local frame = game:GetFrameCount()
	if data.lastFrameBombSackFossiled == frame then
		return
	end

	if data.FFIsScatter or sourceFlag == mod.BombFlagSource.LOCUST_OF_WAR then
		local level = game:GetLevel():GetAbsoluteStage()
		local shockwave = Isaac.Spawn(1000, EffectVariant.ROCK_EXPLOSION, 0, src.Position, Vector.Zero, player):ToEffect()
        shockwave.DepthOffset = 50
        for _, enemy in ipairs(Isaac.FindInRadius(src.Position, 25, EntityPartition.ENEMY)) do
			if enemy:IsActiveEnemy() and (not mod:isFriend(enemy)) and enemy:IsVulnerableEnemy() then
				local damage = (player.Damage or 5)+5+2.5*level
				enemy:TakeDamage(damage, 0, EntityRef(shockwave), 0)
			end
		end
		sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1, 0, false, 1)
	else
		local crack = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, 0, src.Position, Vector.Zero, player):ToEffect()
		crack.Parent = player
		crack:SetRadii(20,65)
		crack.Timeout = 10
	end

	data.lastFrameBombSackFossiled = frame
end, flag)