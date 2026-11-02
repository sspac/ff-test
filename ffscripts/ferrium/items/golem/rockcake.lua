local mod = FiendFolio
local sfx = SFXManager()

function mod:rockCakeOnGrind(player)
    if player:HasTrinket(FiendFolio.ITEM.ROCK.ROCK_CAKE) then
		local mult = math.ceil(mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.ROCK_CAKE))
		player:AddHearts(mult)
		sfx:Play(SoundEffect.SOUND_VAMP_GULP, 1, 0, false, 1)
		local poof = Isaac.Spawn(1000, 49, 0, player.Position, Vector.Zero, player):ToEffect()
		poof.SpriteOffset = Vector(0,-40)
		poof:FollowParent(player)
		poof:Update()
	end
end