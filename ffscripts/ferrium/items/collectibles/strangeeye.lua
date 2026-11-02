local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local flag = TearFlagsLib.RegisterTearFlag("STRANGE_EYE")

local bal = {
    MenuScale = 1,
    MenuPos = Vector(60, 100),
    MenuLine = Vector(60, -35),
    MenuLineInc = 12,
    MaxLine2 = 75,
    MenuCloseStr = Vector(10, 18),
    MenuCloseX = {39, 9, 20, 30},
    MenuRedCol = {0.75, 0.3, 0.1},
    MenuYelCol = {0.92, 0.68, 0.15},
    MenuGrnCol = {0.4, 0.66, 0.25},
    MenuCountdown = 280,
    Trans = 0.75,

    CalcDamageStart = 5,
}

--just putting it up here for ease of access in num tweaking
--starts at ~1 damage and ends at ~5.8 damage up
local damageUpFunc = function(x)
    return math.sqrt((3*x)+10)-1.5
end

local StrangeInfo = {
    {"Strange", 0, 0.1},
    {"Unremarkable", 25, 0.35},
    {"Scarcely Lethal", 27, 0.7},
    {"Mildly Menacing", 120, 1.2},
    {"Somewhat Threatening", 190},
    {"Uncharitable", 275},
    {"Notably Dangerous", 375},
    {"Sufficiently Lethal", 490},
    {"Truly Feared", 620},
    {"Spectacularly Lethal", 750},
    {"Gore-Spattered", 950},
    {"Wicked Nasty", 1350},
    {"Positively Inhumane", 1800},
    {"Totally Ordinary", 2499},
    {"Face-Melting", 2500},
    {"Rage-Inducing", 4000},
    {"Room Clearing", 7000},
    {"Epic", 10000},
    {"Legendary", 15000},
    {"Australian", 17116},
    {"Grandpa's Own", 20000},
}

--using some stuff from gaper in a jar
function mod:GetStrangeEyeModifier()
    mod.savedata.StrangeEyeKills = mod.savedata.StrangeEyeKills or 0
    local result = {1, "Strange"}
    for key,entry in ipairs(StrangeInfo) do
        if mod.savedata.StrangeEyeKills >= entry[2] then
            result = {key, entry[1]}
        end
    end
    return result
end

function mod:PreStrangeEyeQueueCheck(pickup, collider)
    mod:GetEntityData(pickup).IsStrangeEye = pickup.SubType == mod.ITEM.COLLECTIBLE.STRANGE_EYE
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.PreStrangeEyeQueueCheck, PickupVariant.PICKUP_COLLECTIBLE)

function mod:StrangeEyeQueueCheck(pickup, collider)
    if pickup.SubType ~= 0 or not mod:GetEntityData(pickup).IsStrangeEye then return end
    local player = collider:ToPlayer()
    if not player then return end

    local queuedItem = player.QueuedItem.Item

    if queuedItem and queuedItem:IsCollectible() and queuedItem.ID == mod.ITEM.COLLECTIBLE.STRANGE_EYE then
        mod.savedata.StrangeEyeKills = mod.savedata.StrangeEyeKills or 0
        if mod.savedata.StrangeEyeKills > StrangeInfo[2][2] then
            local name = mod:GetStrangeEyeModifier()[2]
            game:GetHUD():ShowItemText(name .. " Eye", "Level up with kills")
        end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.StrangeEyeQueueCheck, PickupVariant.PICKUP_COLLECTIBLE)

local achieveSprite = Sprite()
achieveSprite:Load("gfx/effects/effect_strange_eye_menu.anm2", true)
achieveSprite:Play("Menu")
achieveSprite:Stop()
achieveSprite.Scale = Vector(bal.MenuScale, bal.MenuScale)

function mod:StrangeEyeRender(player, renderPos)
    if (player:IsExtraAnimationFinished() or player:GetSprite():GetOverlayAnimation() == "HeadDown")
    and player:IsCollectibleCostumeVisible(mod.ITEM.COLLECTIBLE.STRANGE_EYE, "head3") then
        local costumeSprite

        -- Get the costume sprite to use
        for i, desc in pairs( player:GetCostumeSpriteDescs() ) do
            local config = desc:GetItemConfig()

            if config.Type == ItemType.ITEM_PASSIVE and config.ID == mod.ITEM.COLLECTIBLE.STRANGE_EYE then
                costumeSprite = desc:GetSprite()
                break
            end
        end

        if costumeSprite then
            -- Only continue if the current animation has number layers to render
            local numberLayerData = costumeSprite:GetLayerFrameData(1)

            if numberLayerData then
                local headLayer = costumeSprite:GetLayer(0)
                local numberWidth = numberLayerData:GetWidth()

                -- Get the kill count
                local killCount = math.min(999999, mod.savedata.StrangeEyeKills or 0)
                local digitsToRender = #tostring(killCount)

                for digit = 1, digitsToRender do
                    -- Get the current digit of the number
                    local n = 10 ^ digit
                    local n1 = 10 ^ (digit - 1)
                    local number = (killCount % n) / n1
                    number = math.floor(number)

                    -- Set the frame to use
                    local numberLayer = costumeSprite:GetLayer("number" .. digit)
                    numberLayer:SetCropOffset(number * Vector(numberWidth, 0))

                    -- Copy layer data from the head layer
                    numberLayer:SetVisible(headLayer:IsVisible())
                    numberLayer:SetPos(headLayer:GetPos())
                    numberLayer:SetSize(headLayer:GetSize())
                    numberLayer:SetColor(headLayer:GetColor())
                    numberLayer:SetFlipX(headLayer:GetFlipX())
                    numberLayer:SetFlipY(headLayer:GetFlipY())

                    -- Manually render the layer
                    local layerID = numberLayer:GetLayerID()
                    costumeSprite:RenderLayer(layerID, renderPos)
                end
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER_PLAYER_HEAD, mod.StrangeEyeRender)

function mod:StrangeEyeMenuRender()
    if mod:IsNormalRender(true) then
        for i=1,game:GetNumPlayers() do
            local player = Isaac.GetPlayer(i-1)
            local d = mod:GetEntityData(player)

            if d.DisplayingStrangeEyeMenu then
                local a = 1
                if mod:IsActiveRoom() then
                    a = bal.Trans
                    achieveSprite:GetLayer(0):SetColor(Color(1, 1, 1, a))
                elseif achieveSprite:GetLayer(0):GetColor().A == bal.Trans then
                    achieveSprite:GetLayer(0):SetColor(Color(1, 1, 1, 1))
                end
                local pos = bal.MenuPos+bal.MenuLine*bal.MenuScale
                achieveSprite:Render(bal.MenuPos)
                mod.TempestFont:DrawStringScaled("Your Eye has reached", pos.X, pos.Y, bal.MenuScale, bal.MenuScale, KColor(1, 1, 1, a), 0, false)
                local str = "a new rank: "
                local thirdLine
                if #d.StrangeEyeLineSpacing > 1 then
                    str = str .. d.StrangeEyeLineSpacing[1]
                    thirdLine = true
                else
                    str = str .. d.StrangeEyeLineSpacing[1] .. "!"
                end
                mod.TempestFont:DrawStringScaled(str, pos.X, pos.Y+bal.MenuLineInc*bal.MenuScale, bal.MenuScale, bal.MenuScale, KColor(1, 1, 1, a), 0, false)
                if thirdLine then
                    mod.TempestFont:DrawStringScaled(d.StrangeEyeLineSpacing[2] .. "!", pos.X, pos.Y+bal.MenuLineInc*2*bal.MenuScale, bal.MenuScale, bal.MenuScale,
                        KColor(1, 1, 1, a), 0, false)
                end
                local dist = bal.MenuPos.X+bal.MenuCloseStr.X*bal.MenuScale
                local y = bal.MenuPos.Y+bal.MenuCloseStr.Y*bal.MenuScale
                mod.TempestFont:DrawStringScaled("Press [ ", dist, y, bal.MenuScale, bal.MenuScale, KColor(bal.MenuRedCol[1], bal.MenuRedCol[2], bal.MenuRedCol[3], a), 0, false)
                dist = dist+bal.MenuCloseX[1]*bal.MenuScale
                mod.TempestFont:DrawStringScaled("K ", dist, y, bal.MenuScale, bal.MenuScale, KColor(bal.MenuYelCol[1], bal.MenuYelCol[2], bal.MenuYelCol[3], a), 0, false)
                dist = dist+bal.MenuCloseX[2]*bal.MenuScale
                mod.TempestFont:DrawStringScaled("] to ", dist, y, bal.MenuScale, bal.MenuScale, KColor(bal.MenuRedCol[1], bal.MenuRedCol[2], bal.MenuRedCol[3], a), 0, false)
                dist = dist+bal.MenuCloseX[3]*bal.MenuScale
                mod.TempestFont:DrawStringScaled("CLOSE", dist, y, bal.MenuScale, bal.MenuScale, KColor(bal.MenuGrnCol[1], bal.MenuGrnCol[2], bal.MenuGrnCol[3], a), 0, false)
                dist = dist+bal.MenuCloseX[4]*bal.MenuScale
                mod.TempestFont:DrawStringScaled(".", dist, y, bal.MenuScale, bal.MenuScale, KColor(bal.MenuRedCol[1], bal.MenuRedCol[2], bal.MenuRedCol[3], a), 0, false)

                if d.DisplayingStrangeEyeCountdown > 0 then
                    d.DisplayingStrangeEyeCountdown = d.DisplayingStrangeEyeCountdown-1
                else
                    d.DisplayingStrangeEyeMenu = nil
                end
            end
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_HUD_RENDER, mod.ITEM.COLLECTIBLE.STRANGE_EYE, mod.StrangeEyeMenuRender)

local function IsTaintedChar(player)
	return (player:GetPlayerType() == Isaac.GetPlayerTypeByName(player:GetName(), true))
        or (player:GetPlayerType() <= PlayerType.PLAYER_THESOUL_B and player:GetPlayerType() > PlayerType.PLAYER_ESAU)
end

function mod:ShowStrangeEyePopup(player, data)
    -- for testing with debug console
    player = player or Isaac.GetPlayer(0)
    data = data or mod:GetEntityData(player)

    local modifier = mod:GetStrangeEyeModifier()
    local result = modifier[2]
    local letsGo = {result}
    local prefix = (IsTaintedChar(player) and "tainted_") or ""
    --print(prefix, IsTaintedChar(player))
    local playerName = player:GetName()
    playerName = FiendFolio.StrangeEyePlayerTypeToFilename[player:GetPlayerType()] or playerName
    local name = string.lower(prefix .. playerName) --Linux safety check
    local check = "gfx/effects/strangeeyebackground/" .. name .. "_full.png"
    achieveSprite:ReplaceSpritesheet(3, check, true)
    if achieveSprite:GetLayer(3):GetSpritesheetPath() == check then
    else
        achieveSprite:ReplaceSpritesheet(2, "gfx/effects/strangeeyebackground/_default.png", true)
    end

    achieveSprite:ReplaceSpritesheet(1, player:GetSprite():GetLayer(0):GetSpritesheetPath(), true)

    local filename = "gfx/effects/strangeeyebackground/" .. name ..".png"
    achieveSprite:ReplaceSpritesheet(2, filename, true)
    if achieveSprite:GetLayer(2):GetSpritesheetPath() == filename then
    else
        achieveSprite:ReplaceSpritesheet(2, "gfx/effects/strangeeyebackground/_default.png", true)
    end

    --[[if player:GetPlayerType() == FiendFolio.PLAYER.FRIEND then
        achieveSprite:ReplaceSpritesheet(2, "gfx/effects/effect_strange_eye_backdrop_friend.png", true)
    else
        achieveSprite:ReplaceSpritesheet(2, "gfx/effects/effect_strange_eye_backdrop.png", true)
    end]]
    sfx:Play(mod.Sounds.TF2Achievement, 0.6, 0, false, 1)
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE, true)
    data.DisplayingStrangeEyeMenu = true
    data.DisplayingStrangeEyeCountdown = bal.MenuCountdown
    if mod.TempestFont:GetStringWidth(result) > bal.MaxLine2 then
        local sendThis = {}
        local backup = ""
        local backupStep = 1
        local weCanGo = true
        local step = 1
        while weCanGo do
            local char = result:sub(step, step)
            if (char == " " and step ~= 1) or step == #result then
                if step >= #result then
                    step = step+1
                end
                local check = result:sub(1, step-1)
                if mod.TempestFont:GetStringWidth(check) > bal.MaxLine2 then
                    table.insert(sendThis, backup)
                    table.insert(sendThis, result:sub(backupStep+1, #result))
                    weCanGo = false
                else
                    backup = check
                    backupStep = step
                end
                if step >= #result then
                    step = step-1
                end
            end
            step = step+1
            if step > #result then
                weCanGo = false
            end
        end
        letsGo = sendThis
    end
    data.StrangeEyeLineSpacing = letsGo
end

--Because of Localisation Strings and such
FiendFolio.StrangeEyePlayerTypeToFilename = {
    [PlayerType.PLAYER_ISAAC]           = "isaac",
    [PlayerType.PLAYER_ISAAC_B]         = "isaac",
    [PlayerType.PLAYER_MAGDALENE]       = "magdalene",
    [PlayerType.PLAYER_MAGDALENE_B]     = "magdalene",
    [PlayerType.PLAYER_CAIN]            = "cain",
    [PlayerType.PLAYER_CAIN_B]          = "cain",
    [PlayerType.PLAYER_JUDAS]           = "judas",
    [PlayerType.PLAYER_JUDAS_B]         = "judas",
    [PlayerType.PLAYER_BLACKJUDAS]      = "judas",
    [PlayerType.PLAYER_BLUEBABY]        = "blue baby",
    [PlayerType.PLAYER_BLUEBABY_B]      = "blue baby",
    [PlayerType.PLAYER_EVE]             = "eve",
    [PlayerType.PLAYER_EVE_B]           = "eve",
    [PlayerType.PLAYER_SAMSON]          = "samson",
    [PlayerType.PLAYER_SAMSON_B]        = "samson",
    [PlayerType.PLAYER_AZAZEL]          = "azazel",
    [PlayerType.PLAYER_AZAZEL_B]        = "azazel",
    [PlayerType.PLAYER_LAZARUS]         = "lazarus",
    [PlayerType.PLAYER_LAZARUS2]        = "lazarus",
    [PlayerType.PLAYER_LAZARUS_B]       = "lazarus",
    [PlayerType.PLAYER_LAZARUS2_B]      = "lazarus",
    [PlayerType.PLAYER_EDEN]            = "eden",
    [PlayerType.PLAYER_EDEN_B]          = "eden",
    [PlayerType.PLAYER_THELOST]         = "the lost",
    [PlayerType.PLAYER_THELOST_B]       = "the lost",
    [PlayerType.PLAYER_LILITH]          = "lilith",
    [PlayerType.PLAYER_LILITH_B]        = "lilith",
    [PlayerType.PLAYER_KEEPER]          = "keeper",
    [PlayerType.PLAYER_KEEPER_B]        = "keeper",
    [PlayerType.PLAYER_APOLLYON]        = "apollyon",
    [PlayerType.PLAYER_APOLLYON_B]      = "apollyon",
    [PlayerType.PLAYER_THEFORGOTTEN]    = "the forgotten",
    [PlayerType.PLAYER_THEFORGOTTEN_B]  = "the forgotten",
    [PlayerType.PLAYER_THESOUL]         = "the soul",
    [PlayerType.PLAYER_THESOUL_B]       = "the soul",
    [PlayerType.PLAYER_BETHANY]         = "bethany",
    [PlayerType.PLAYER_BETHANY_B]       = "bethany",
    [PlayerType.PLAYER_JACOB]           = "jacob",
    [PlayerType.PLAYER_JACOB_B]         = "jacob",
    [PlayerType.PLAYER_JACOB2_B]        = "jacob",
    [PlayerType.PLAYER_ESAU]            = "esau",
}

function mod:StrangeEyeKill(entity, source)
    if source and source.Entity then
        source = source.Entity

        -- Get the player from the source
        local spawner = source.SpawnerEntity
        local player = source:ToPlayer() or (spawner and spawner:ToPlayer())

        if player and player:HasCollectible(mod.ITEM.COLLECTIBLE.STRANGE_EYE) then
            local entityData = mod:GetEntityData(entity)

            if entity:IsEnemy() and entity:IsDead() and not entityData.StrangeEyeCounted
            and not (entity.Type == mod.FFID.Tech and entity.Variant > 999) then
                -- Increment the counter
                local mult = player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.STRANGE_EYE)
                mod.savedata.StrangeEyeKills = (mod.savedata.StrangeEyeKills or 0) + mult
                entityData.StrangeEyeCounted = true

                -- Show the pop-up when reaching a new status
                mod.savedata.StrangeEyeStatus = mod.savedata.StrangeEyeStatus or 1
                local modifier = mod:GetStrangeEyeModifier()

                if mod.savedata.StrangeEyeStatus and mod.savedata.StrangeEyeStatus ~= modifier[1] then
                    local playerData = mod:GetEntityData(player)
                    mod:ShowStrangeEyePopup(player, playerData)
                end
                mod.savedata.StrangeEyeStatus = modifier[1]
            end
        end
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.ITEM.COLLECTIBLE.STRANGE_EYE, mod.StrangeEyeKill)

function mod:StrangeEyeTearHitParams(player, tearparams, weapontype, damagescale, teardisplacement, source)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.STRANGE_EYE) then
		-- same exact rules as blood clot
		if teardisplacement < 0 or
		   ((not player:HasWeaponType(WeaponType.WEAPON_TEARS) or (source and source.Type ~= EntityType.ENTITY_PLAYER) or 
		     player:GetPlayerType() == PlayerType.PLAYER_CAIN or player:GetPlayerType() == PlayerType.PLAYER_CAIN_B or 
		     player:HasCollectible(CollectibleType.COLLECTIBLE_LEAD_PENCIL) or player:HasCollectible(CollectibleType.COLLECTIBLE_CURSED_EYE) or 
		     player:HasCollectible(CollectibleType.COLLECTIBLE_STAPLER)) and player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.STRANGE_EYE):RandomInt(2) == 0)
		then
			mod.savedata.StrangeEyeStatus = mod.savedata.StrangeEyeStatus or 1
			local entry = StrangeInfo[mod.savedata.StrangeEyeStatus]
			local up = 0
			if entry and entry[3] then
				up = entry[3]
			else
				up = damageUpFunc(mod.savedata.StrangeEyeStatus-bal.CalcDamageStart)
			end
			local origDamage, origScale = tearparams.TearDamage, tearparams.TearScale
			tearparams.TearDamage = tearparams.TearDamage + up
			tearparams.TearScale = origScale * (mod:getTearParamsScale(player, tearparams.TearDamage, tearparams.TearFlags) / mod:getTearParamsScale(player, origDamage, tearparams.TearFlags))
		end
	end
end
mod:AddPriorityCollectibleCallback(ModCallbacks.MC_EVALUATE_TEAR_HIT_PARAMS, CallbackPriority.EARLY, mod.ITEM.COLLECTIBLE.STRANGE_EYE, mod.StrangeEyeTearHitParams)