local mod = FiendFolio
local sfx = SFXManager()

function mod:rebellionRockDamage(player, damage, flag, source)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.REBELLION_ROCK) then
		local mult = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.REBELLION_ROCK)
		local secondHandMultiplier = player:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1
		
		local hit = false
		for _,entity in ipairs(Isaac.FindInRadius(player.Position, 100, EntityPartition.ENEMY)) do
			if entity:IsActiveEnemy() and (not mod:isFriend(entity)) then
				mod.AddBruise(entity, player, 200 * secondHandMultiplier, 1, 1)
				mod.scheduleForUpdate(function()
					entity.Velocity = (entity.Position-player.Position):Resized(40)
				end, 1)
				entity:TakeDamage(player.Damage*2*mult, 0, EntityRef(player), 0)
				hit = true
			end
		end
		if hit == true then
			local aura = Isaac.Spawn(1000, 123, 8, player.Position, Vector.Zero, player):ToEffect()
			local color = Color(1, 1, 1, 1, 2, 1, 2.2)
			color:SetColorize(3, 0.5, 4, 0.35)
			aura.Color = color
			aura.SpriteScale = Vector(0.6,0.6)
			sfx:Play(SoundEffect.SOUND_PUNCH, 1, 0, false, 1)
		end
	end
end

-- okay writing this note from a time later, this seems stupid?
--1 is the direction/vector, 2 is the timer, 3 is the original full timer? so 2 and 3 are the same thing
function mod:fakeKnockbackEffect(npc, data)
	if data.fakeKnockbackEffect then
		if npc:HasEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK) or npc:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) then
			data.fakeKnockbackEffect = nil
			data.fakeKnockbackData = {}
		else
			if data.fakeKnockbackData[2] > 0 then
				data.fakeKnockbackData[2] = data.fakeKnockbackData[2]-1
				local vel = data.fakeKnockbackData[1]*(1-(data.fakeKnockbackData[3]-data.fakeKnockbackData[2])/10)
				npc.Velocity = mod:Lerp(npc.Velocity, vel, 0.3)
			else
				data.fakeKnockbackData = {}
				data.fakeKnockbackEffect = nil
			end
			if npc:CollidesWithGrid() then
				data.fakeKnockbackData = {}
				data.fakeKnockbackEffect = nil
			end
		end
	end
end