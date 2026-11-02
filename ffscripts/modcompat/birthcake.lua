local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local subwaySurfersSprite = Sprite()
subwaySurfersSprite:Load("gfx/items/trinkets/birthcake/surfers/surfers.anm2", true)

local function cakePath(string)
	return {SpritePath = "gfx/items/trinkets/birthcake/" .. string .. ".png"}
end

function mod:registerBirthcakes()
	if not BirthcakeRebaked then return end

	BirthcakeRebaked.API:AddBirthcakePickupText(mod.PLAYER.FIEND, "Imaginary friends")
	BirthcakeRebaked.API:AddBirthcakeSprite(mod.PLAYER.FIEND, cakePath("fiend"))

	BirthcakeRebaked.API:AddTaintedBirthcakePickupText(mod.PLAYER.BIEND, "Hollow hostility", mod.PLAYER.FIEND, "Tainted Fiend's", "The Bastard's")
	BirthcakeRebaked.API:AddBirthcakeSprite(mod.PLAYER.BIEND, cakePath("fiendb"))

	BirthcakeRebaked.API:AddBirthcakePickupText(mod.PLAYER.GOLEM, "Favored minerals")
	BirthcakeRebaked.API:AddBirthcakeSprite(mod.PLAYER.GOLEM, cakePath("golem"))

	BirthcakeRebaked.API:AddTaintedBirthcakePickupText(mod.PLAYER.BOLEM, "First to crumble", mod.PLAYER.GOLEM, "Tainted Golem's", "The Artisan's")
	BirthcakeRebaked.API:AddBirthcakeSprite(mod.PLAYER.BOLEM, cakePath("golemb"))

	BirthcakeRebaked.API:AddBirthcakePickupText(mod.PLAYER.FRIEND, "Extra chamber")
	BirthcakeRebaked.API:AddBirthcakeSprite(mod.PLAYER.FRIEND, cakePath("friend"))

	BirthcakeRebaked.API:AddTaintedBirthcakePickupText(mod.PLAYER.BRIEND, "Double action", mod.PLAYER.FRIEND, "Tainted Friend's", "The Wanted's")
	BirthcakeRebaked.API:AddBirthcakeSprite(mod.PLAYER.BRIEND, cakePath("friendb"))

	BirthcakeRebaked.API:AddBirthcakePickupText(mod.PLAYER.INABA, "Paranoia up")
	BirthcakeRebaked.API:AddBirthcakeSprite(mod.PLAYER.INABA, cakePath("inaba"))

	BirthcakeRebaked.API:AddTaintedBirthcakePickupText(mod.PLAYER.BINABA, "Mind razor", mod.PLAYER.INABA, "Tainted Inaba's", "The Euthymic's")
	BirthcakeRebaked.API:AddBirthcakeSprite(mod.PLAYER.BINABA, cakePath("inabab"))

	BirthcakeRebaked.API:AddBirthcakePickupText(mod.PLAYER.SLIPPY, "Rumblier tummy")
	BirthcakeRebaked.API:AddBirthcakeSprite(mod.PLAYER.SLIPPY, cakePath("slippy"))

	BirthcakeRebaked.API:AddBirthcakePickupText(mod.PLAYER.CHINA, "Routine repairs")
	BirthcakeRebaked.API:AddBirthcakeSprite(mod.PLAYER.CHINA, cakePath("china"))

	BirthcakeRebaked.API:AddBirthcakePickupText(mod.PLAYER.CRAIG, "Ambient charge")
	BirthcakeRebaked.API:AddBirthcakeSprite(mod.PLAYER.CRAIG, cakePath("craig"))

	BirthcakeRebaked.API:AddBirthcakePickupText(mod.PLAYER.CLASSIC_FIEND, "Hotter fireballs")
	BirthcakeRebaked.API:AddBirthcakeSprite(mod.PLAYER.CLASSIC_FIEND, cakePath("classic fiend"))

	BirthcakeRebaked.API:AddBirthcakePickupText(mod.PLAYER.IMAGE, "Attention span up")
	BirthcakeRebaked.API:AddBirthcakeSprite(mod.PLAYER.IMAGE, cakePath("image"))

	BirthcakeRebaked.API:AddBirthcakePickupText(mod.PLAYER.SKELETAL_FIEND, "Homing bones", "The Skeletal Fiend's")
	BirthcakeRebaked.API:AddBirthcakeSprite(mod.PLAYER.SKELETAL_FIEND, cakePath("the skeletal fiend"))

	BirthcakeRebaked.API:AddBirthcakePickupText(mod.PLAYER.FIENT, "Buzz kill")
	BirthcakeRebaked.API:AddBirthcakeSprite(mod.PLAYER.FIENT, cakePath("fient"))

	--BirthcakeRebaked.API:AddBirthcakePickupText(mod.PLAYER.FEND, "___")
	BirthcakeRebaked.API:AddBirthcakeSprite(mod.PLAYER.FEND, cakePath("fend"))

	BirthcakeRebaked.API:AddBirthcakePickupText(mod.PLAYER.MI, "Paper cuts")
	BirthcakeRebaked.API:AddBirthcakeSprite(mod.PLAYER.MI, cakePath("mi"))

	BirthcakeRebaked.API:AddBirthcakePickupText(mod.PLAYER.FROND, "Explosive boils")
	BirthcakeRebaked.API:AddBirthcakeSprite(mod.PLAYER.FROND, cakePath("frond"))

	BirthcakeRebaked.API:AddBirthcakePickupText(mod.PLAYER.FREEZERJR, "Freeze rate up")
	BirthcakeRebaked.API:AddBirthcakeSprite(mod.PLAYER.FREEZERJR, cakePath("freezerjr"))

	BirthcakeRebaked.API:AddBirthcakePickupText(mod.PLAYER.PEAT, "Hey beter", "Peat's Exploding Cup")
	BirthcakeRebaked.API:AddBirthcakeSprite(mod.PLAYER.PEAT, cakePath("peat"))

	--EID, oh boy
	--BirthcakeRebaked.API:AddEIDDescription(playerType, desc)

	-- small patch make things nicer for image and briend birthcakes
	-- for image, i need to render over the birthcake and that the callback doesnt return everything i need
	-- for briend, rendering is broken because she is treated like a twin-based character when she shouldnt be, and the second gun's birthcake needs to not render
	if mod.OrigBirthcakeRenderFunc == nil then
		mod.OrigBirthcakeRenderFunc = HudHelper.HUD_ELEMENTS[HudHelper.HUDType.TRINKET_ID][BirthcakeRebaked.Birthcake.ID].OnRender
	end
	if mod.OrigHudHelperLayoutFunc == nil then
		mod.OrigHudHelperLayoutFunc = HudHelper.Utils.GetHUDLayout
	end

	local function tryGetPlayerFromPtr(entityPtr)
		if entityPtr
			and entityPtr.Ref
			and entityPtr.Ref:ToPlayer()
		then
			local player = entityPtr.Ref:ToPlayer()
			if player
				and player:Exists()
				and player.Variant == 0
			then
				return player
			end
		end
	end

	function HudHelper.Utils.GetHUDLayout(playerHUDIndex)
		local hudLayout = mod.OrigHudHelperLayoutFunc(playerHUDIndex)
		local hudPlayer = HudHelper.HUDPlayers[playerHUDIndex][1]
		local player = tryGetPlayerFromPtr(hudPlayer)
		if player and player:GetPlayerType() == mod.PLAYER.BRIEND and hudLayout == HudHelper.HUDLayout.P1_MAIN_TWIN then
			hudLayout = HudHelper.HUDLayout.P1
		end
		return hudLayout
	end

	HudHelper.RegisterHUDElement({
		ItemID = BirthcakeRebaked.Birthcake.ID,
		OnRender = function(player, playerHUDIndex, hudLayout, pos, alpha, scale, trinketID, slot)
			if player:GetPlayerType() == mod.PLAYER.BRIEND then
				if not mod:IsBriendTwin(player) then
					mod.OrigBirthcakeRenderFunc(player, playerHUDIndex, hudLayout, pos, alpha, scale, trinketID, slot)
				end
			else
				mod.OrigBirthcakeRenderFunc(player, playerHUDIndex, hudLayout, pos, alpha, scale, trinketID, slot)
			end
			if player:GetPlayerType() == mod.PLAYER.IMAGE then
				subwaySurfersSprite:SetFrame("Idle", Game():GetFrameCount() % 84)
				subwaySurfersSprite.Scale = Vector(scale, scale)
				subwaySurfersSprite:Render(pos)
			end
		end
	}, HudHelper.HUDType.TRINKET_ID)

	mod:AddTrinketCallback(ModCallbacks.MC_POST_PLAYER_NEW_LEVEL, BirthcakeRebaked.Birthcake.ID, function(_, player, fromPlayerUpdate, postLevelInitFinished)
		if postLevelInitFinished then
			local _, birthcakeMult = mod:playerHasBirthcake(player)
			player:AddBrokenHearts(-1 * birthcakeMult)

			local notif = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, nilvector, nil):ToEffect()
			notif.DepthOffset = 1.0
			notif.SpriteOffset = Vector(0, -40)
			notif:Update()
			sfx:Play(SoundEffect.SOUND_VAMP_GULP)
		end
	end, mod.PLAYER.CHINA)

	FiendFolio.GolemTrinketWhitelist[BirthcakeRebaked.Birthcake.ID] = 2
	mod:AddCallback(BirthcakeRebaked.ModCallbacks.POST_BIRTHCAKE_PICKUP_INIT, function(_, _, sprite)
		if PlayerManager.AnyoneIsPlayerType(FiendFolio.PLAYER.GOLEM) then
			sprite:ReplaceSpritesheet(0, "gfx/items/trinkets/birthcake/golem.png")
			sprite:LoadGraphics()
		elseif PlayerManager.AnyoneIsPlayerType(FiendFolio.PLAYER.BOLEM) then
			sprite:ReplaceSpritesheet(0, "gfx/items/trinkets/birthcake/golemb.png")
			sprite:LoadGraphics()
		end
	end)

	mod:AddTrinketCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, BirthcakeRebaked.Birthcake.ID, function(_, player, tearparams)
		tearparams.TearFlags = tearparams.TearFlags | TearFlags.TEAR_BURN
	end, FiendFolio.PLAYER.CLASSIC_FIEND)
end
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, mod.registerBirthcakes)
if ModReloadDetector.ModsLoaded then mod:registerBirthcakes() end

function mod:playerHasBirthcake(player)
    if BirthcakeRebaked then
        if player:HasTrinket(BirthcakeRebaked.Birthcake.ID) then
			return true, player:GetTrinketMultiplier(BirthcakeRebaked.Birthcake.ID)
		else
			return false, 0
		end
	else
		return false, 0
	end
end

local MI_BIRTHCAKEFLAG = TearFlagsLib.RegisterTearFlag("MI_BIRTHCAKE")

function mod:birthcakeGeneric(entity, player, weaponFlag)
	if BirthcakeRebaked then
		if mod:playerHasBirthcake(player) then
			if player:GetPlayerType() == FiendFolio.PLAYER.MI then
				TearFlagsLib.AddTearFlags(entity, MI_BIRTHCAKEFLAG)
			end
		end
	end
end
mod:AddCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, mod.birthcakeGeneric)
mod:AddCallback(TearFlagsLib.Callback.POLL_CHANCELESS_TEARFLAGS, mod.birthcakeGeneric)

function mod:applyMiBirthcake(entity, player, source)
	if not (entity:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) or entity:HasEntityFlags(EntityFlag.FLAG_BLEED_OUT)) then
		entity:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)
		entity:SetColor(Color(3,0.75,0.75,1,0,0,0),1,2,false,false)
		for i = 1, 7 do
			mod.scheduleForUpdate(function()
				if entity and entity:Exists() then
					entity:SetColor(Color(3 - ((i/8)^3) * 2, 0.75 + ((i/8)^3) * 0.25, 0.75 + ((i/8)^3) * 0.25, 1, 0, 0, 0), 1, 2, false, false)
				end
			end, i+1)
		end
		mod:makeEnemyGib(entity)
	end
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyMiBirthcake, MI_BIRTHCAKEFLAG)