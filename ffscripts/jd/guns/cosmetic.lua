local mod = FiendFolio
local sfx = SFXManager()

FiendFolio.AddItemPickupCallback(function(player)
	mod.UpdateDuelWinner()
end, nil, CollectibleType.COLLECTIBLE_TRISAGION)

-- C Stack Overflow?!?!?!?!
-- mod:AddCallback("PRE_GUN_REPLACE", function()
-- 	mod.UpdateDuelWinner()
-- end, CollectibleType.COLLECTIBLE_TRISAGION)

mod:AddCallback("PRE_GUN_FIRE_SOUND", function(_, gun, player)
	if FiendFolio.DuelWinner == 0 then
		sfx:Play(mod.Sounds.AirzookaFire, 0.6, 0, false, mod:RandomInt(110,140,gun:GetDropRNG())/100)
	elseif FiendFolio.DuelWinner == 1 then
		sfx:Play(mod.Sounds.RighteousBisonFire, 0.4, 0, false, mod:RandomInt(95,105,gun:GetDropRNG())/100)
	elseif FiendFolio.DuelWinner == 2 then
		sfx:Play(mod.Sounds.AirbisonFire, 0.6, 0, false, mod:RandomInt(110,140,gun:GetDropRNG())/100)
	end
    return true
end, CollectibleType.COLLECTIBLE_TRISAGION)

mod:AddCallback("POST_GUN_REPLACE", function(_, gun, player)
	if FiendFolio.DuelWinner == 2 then
		local heart = Isaac.Spawn(1000, mod.FF.LoveHeart.Var, mod.FF.LoveHeart.Sub, gun.Position, Vector.Zero, gun):ToEffect()
		local firework = Isaac.Spawn(1000, EffectVariant.FIREWORKS, 0, gun.Position, Vector.Zero, gun):ToEffect()
		firework:SetTimeout(30)
		firework:FollowParent(gun)
		sfx:Play(SoundEffect.SOUND_HAPPY_RAINBOW)
	end
end, CollectibleType.COLLECTIBLE_TRISAGION)

mod:AddCallback("GUN_RELOAD_SHOT", function(_, gun, player)
	if gun.SubType == CollectibleType.COLLECTIBLE_TRISAGION and FiendFolio.DuelWinner ~= 1 then
        local smoke = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, gun.Position, (gun.Position-player.Position):Resized(3)+mod:TrueRandomVector():Resized(1), gun):ToEffect()
		mod:GetEntityData(smoke).longonly = true
		smoke.Color = Color(0.8,0.8,1,0.4,0,0,0)
    end
end)

function mod.UpdateDuelWinner()
	local gun = "gfx/effects/guns/"
	if FiendFolio.DuelWinner == 0 then
		mod.FriendGunInfo[CollectibleType.COLLECTIBLE_TRISAGION] = {ReplaceSprite = gun .. "airzooka.png", GoldenSprite = gun .. "airzooka_golden.png", Priority = 0, Casing = "None", NoMuzzle = true, SpriteType = "Nothing"} -- JD
	elseif FiendFolio.DuelWinner == 1 then
		mod.FriendGunInfo[CollectibleType.COLLECTIBLE_TRISAGION] = {ReplaceSprite = gun .. "righteousbison.png", GoldenSprite = gun .. "righteousbison_golden.png", Priority = 0, Casing = "Battery", NoMuzzle = true, SpriteType = "Nothing"} -- Guwah
	elseif FiendFolio.DuelWinner == 2 then
		mod.FriendGunInfo[CollectibleType.COLLECTIBLE_TRISAGION] = {ReplaceSprite = gun .. "airbison.png", GoldenSprite = gun .. "airbison_golden.png", Priority = 0, Casing = "Battery", NoMuzzle = true, SpriteType = "Nothing"} -- LOVE <3
	end
	
	for i, player in pairs(mod:GetAllPlayers()) do
		if mod:IsAnyFriend(player) and player:HasCollectible(CollectibleType.COLLECTIBLE_TRISAGION) then
			mod:CheckAgainstCurrentGun(player, CollectibleType.COLLECTIBLE_TRISAGION)
		end
	end
end