local mod = FiendFolio
local game = Game()

-- Loki's Horns, Mom's Eye, Eye Sore, Bookworm, Angelic Lyre

local TEMP_GUN_MIN_TIMEOUT = 8
local TEMP_GUN_FADEOUT = 4

mod:AddPriorityCallback("PRE_GUN_FIRE", CallbackPriority.EARLY, function(_, gun, player, aim, isHeld)
	local gData = mod:GetEntityData(gun)
	if gData.isTemporaryGun then
		return true
	end
end)

local function SpawnTempGun(player)
	local pData = mod:GetEntityData(player)
	local gun = mod:SpawnFriendGun(player, pData.FriendsRevolver and pData.FriendsRevolver.SubType or nil)
	gun:ClearEntityFlags(EntityFlag.FLAG_PERSISTENT)
	local gData = mod:GetEntityData(gun)
	gData.isTemporaryGun = true
	gun.Timeout = TEMP_GUN_MIN_TIMEOUT
	gun:Update()
	return gun
end

local function GetLokisHornGuns(player)
	local pData = mod:GetEntityData(player)
	
	local guns = {}
	
	local gunIndexes = {}
	
	if player:HasCollectible(CollectibleType.COLLECTIBLE_LOKIS_HORNS) then
		gunIndexes = {1, 2, 3}
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_EYE) then
		gunIndexes = {2}
	end
	
	for _, i in ipairs(gunIndexes) do
		local key = "LokisHornGun" .. i
		if not pData[key] or not pData[key].Ref or not pData[key].Ref:Exists() then
			local gun = SpawnTempGun(player)
			local gData = mod:GetEntityData(gun)
			gData.LokiGunIdx = i
			gData.AngleOffset = i * 90
			pData[key] = EntityPtr(gun)
		end
		table.insert(guns, pData[key].Ref:ToEffect())
	end
	
	return guns
end

local function ShouldTriggerLokisHorns(player)
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_EYE) then
		return mod:RandomFloat() <= 0.5 + (0.1 * player.Luck)
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_LOKIS_HORNS) then
		return mod:RandomFloat() <= 0.25 + (0.05 * player.Luck)
	end
	return false
end

function mod:CheckLokisHornGuns(mainGun, player, aim, ammoUsed, isHeld)
	local pData = mod:GetEntityData(player)

	-- Only trigger off friend's "primary" gun.
	if #ammoUsed == 0 or mod:GetEntityData(mainGun).isTemporaryGun or not pData.FriendsRevolver or mainGun.InitSeed ~= pData.FriendsRevolver.InitSeed then return end

	if ShouldTriggerLokisHorns(player) then
		for _, lokiGun in ipairs(GetLokisHornGuns(player)) do
			local lgData = mod:GetEntityData(lokiGun)
			local correctAim = aim:Rotated(lgData.AngleOffset)
			if mod:GetFriendWeaponType(player) == WeaponType.WEAPON_MONSTROS_LUNGS then
				lgData.monstrosLungLoaded = mod:makeCopiedTable(ammoUsed)
				Isaac.RunCallbackWithParam("GUN_HOLD_RELEASE", lokiGun.SubType, lokiGun, player, correctAim)
			else
				pData.FriendHeldGuns[lokiGun.InitSeed].Ammo = mod:makeCopiedTable(ammoUsed)
				mod:FireGunFriend(lokiGun, correctAim, isHeld)
			end
			lgData.reloadOverride = false
			lgData.PreviousFireFrame = game:GetFrameCount()
			lokiGun.Timeout = TEMP_GUN_MIN_TIMEOUT
		end
	end

	if player:HasCollectible(CollectibleType.COLLECTIBLE_EYE_SORE) and mod:GetFriendWeaponType(player) ~= WeaponType.WEAPON_BRIMSTONE then
		local n = mod:RandomInt(-3,3)  -- This is basically what the game actually does
		for i=1,n do
			local angle = Random() % 360
			local lokiGun = SpawnTempGun(player)
			local lgData = mod:GetEntityData(lokiGun)
			lgData.LockAngle = angle
			pData.FriendHeldGuns[lokiGun.InitSeed].Ammo = mod:makeCopiedTable(ammoUsed)
			mod:FireGunFriend(lokiGun, Vector.FromAngle(angle), isHeld)
			lgData.reloadOverride = false
			lgData.PreviousFireFrame = game:GetFrameCount()
			lokiGun.Timeout = TEMP_GUN_MIN_TIMEOUT
		end
	end
end
mod:AddCallback("POST_GUN_FIRE", mod.CheckLokisHornGuns)

mod:AddCallback("PRE_GUN_UPDATE", function(_, gun, player)
	local pData = mod:GetEntityData(player)
	local gData = mod:GetEntityData(gun)

	if gData.isTemporaryGun then
		gData.reloadOverride = false
	end
end)

mod:AddCallback("POST_GUN_UPDATE", function(_, gun, player)
	local pData = mod:GetEntityData(player)
	local gData = mod:GetEntityData(gun)

	if gData.isTemporaryGun then
		gData.reloadOffset = 1.0
		if gun:GetSprite():GetAnimation() == "BeginReload" then
			gun:GetSprite():SetFrame(0)
		elseif gun:GetSprite():GetAnimation() == "Shoot" then
			gun.Timeout = TEMP_GUN_MIN_TIMEOUT
		end
		if gun.Timeout <= 0 then
			local triggerMultishotUpdate = (gData.MultishotOffset ~= nil)
			if gData.LokiGunIdx then
				pData["LokisHornGun" .. gData.LokiGunIdx] = nil
			end
			pData.FriendHeldGuns[gun.InitSeed] = nil
			gun:Remove()
			if triggerMultishotUpdate then
				mod:UpdateMultishotGuns(player)
			end
		end
	else
		local ammo = pData.FriendHeldGuns[gun.InitSeed].Ammo
		gData.LokiLastAmmo = ammo[#ammo] or gData.LokiLastAmmo
	end
end)

mod:AddPriorityCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, CallbackPriority.LATE, function(_, e)
	if mod:GetEntityData(e).isTemporaryGun then
		local n = math.max(math.min(1.0, e.Timeout / TEMP_GUN_FADEOUT), 0)
		e.Color = Color(e.Color.R, e.Color.G, e.Color.B, e.Color.A * n, e.Color.RO, e.Color.GO, e.Color.BO)
	end
end, mod.FF.FriendsRevolver.Var)

-- Use temp guns to create blue Angelic Lyre's triple shot effect
function mod:HandleBlueLyreGuns(gun, player, aim, ammoUsed, isHeld)
	local gunData = mod:GetEntityData(gun)
	local pData = mod:GetEntityData(player)

	if ((pData.FriendsRevolver and gun.InitSeed == pData.FriendsRevolver.InitSeed) or gunData.isFriendMultishotGun)
			and (player:HasCollectible(mod.ITEM.COLLECTIBLE.ANGELIC_LYRE_B) or (player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and pData.ffsavedata.VoidedLyre == 1))
			and pData.BlueLyreShot == 2 and #ammoUsed > 0 then
		for _, i in ipairs({-1, 1}) do
			local key = "FriendBlueLyreGun"..i
			local gun = gunData[key]
			if not gun or not gun.Ref or not gun.Ref:Exists() then
				gun = SpawnTempGun(player)
				gunData[key] = EntityPtr(gun)
			else
				gun = gun.Ref
			end
			local newGunData = mod:GetEntityData(gun)
			newGunData.AngleOffset = gunData.AngleOffset
			newGunData.MultishotOffset = gunData.MultishotOffset + Vector(-12, i*8)
			pData.FriendHeldGuns[gun.InitSeed].Ammo = mod:makeCopiedTable(ammoUsed)
			mod:FireGunFriend(gun, aim, isHeld)
			newGunData.reloadOverride = false
			newGunData.PreviousFireFrame = game:GetFrameCount()
		end
	end
end
