local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local rollLength = 30
local defaultFilepath = "gfx/characters/costumes/roll"

FiendFolio.howToRollSkinInfo = {}
FiendFolio.howToRollSkinRejects = {}

--playerType: expects what you get in Isaac.GetPlayerTypeByName
--filePath: string for .png filepath, starts in "gfx/characters/costumes"
    -- so "/roll_john" or "_john/roll" are both ways to pass to it
--skinAlts: return true and they'll be looked for
--overrideFFRender: makes mod:howToRollPlayerRender() do nothing, so you can handle it yourself with different animations etc.
    --FiendFolio:AddPlayerHowToRollSupport(MyCoolCharacter, nil, nil, true) is fine for the above
function FiendFolio:AddPlayerHowToRollSupport(playerType, filePath, skinAlts, overrideFFRender)
    if overrideFFRender then
        FiendFolio.howToRollSkinRejects[playerType] = true
    else
        FiendFolio.howToRollSkinInfo[playerType] = {
            FilePath = "gfx/characters/costumes" .. filePath,
            SkinAlts = skinAlts,
        }
    end
end

FiendFolio:AddPlayerHowToRollSupport(PlayerType.PLAYER_BLACKJUDAS, "/roll_shadow")
FiendFolio:AddPlayerHowToRollSupport(PlayerType.PLAYER_JUDAS_B, "/roll_shadow")
FiendFolio:AddPlayerHowToRollSupport(PlayerType.PLAYER_APOLLYON, "_apollyon/roll")
FiendFolio:AddPlayerHowToRollSupport(PlayerType.PLAYER_APOLLYON_B, "_apollyon/roll")
FiendFolio:AddPlayerHowToRollSupport(FiendFolio.PLAYER.FIEND, "_fiend/roll")
FiendFolio:AddPlayerHowToRollSupport(FiendFolio.PLAYER.BIEND, "_biend/roll")
FiendFolio:AddPlayerHowToRollSupport(FiendFolio.PLAYER.CLASSIC_FIEND, "_fiend/roll")
FiendFolio:AddPlayerHowToRollSupport(FiendFolio.PLAYER.GOLEM, "_golem/roll")
FiendFolio:AddPlayerHowToRollSupport(FiendFolio.PLAYER.FRIEND, "_friend/roll")
FiendFolio:AddPlayerHowToRollSupport(FiendFolio.PLAYER.BRIEND, "_friend/roll")

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, id, rng, player, useflags, activeslot)
    local data = mod:GetEntityData(player)
    if not data.howToRolling then
        sfx:Play(mod.Sounds.FishRoll,1,0,false,math.random(90,110)/100)
        data.howToRolling = {}
        data.howToRolling.Timer = 0
        data.howToRolling.StoredColor = player.Color
        player.Color = Color(1,1,1,0)
        data.howToRolling.Vel = player:GetMovementJoystick():Resized(10 * player.MoveSpeed)

		if player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
			player:AddWisp(mod.ITEM.COLLECTIBLE.HOW_TO_ROLL, player.Position)
			local howRollWisps = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, mod.ITEM.COLLECTIBLE.HOW_TO_ROLL)
			local playerWisps = {}
			for _, wisp in ipairs(howRollWisps) do
				local wisp = wisp:ToFamiliar()
				if wisp.Player and wisp.Player.Index == player.Index and wisp.Player.InitSeed == player.InitSeed then
					table.insert(playerWisps, wisp)
				end
			end
			while (#playerWisps > 6) do
				playerWisps[1]:Kill()
				table.remove(playerWisps, 1)
			end
		end
    end
end, mod.ITEM.COLLECTIBLE.HOW_TO_ROLL)

FiendFolio.howToRollPickupBlacklist = {
    [100] = true,
    [340] = true,
    [380] = true,
    [390] = true,
}

function mod:tryEndPlayerHowToRoll(player, data)
    data = data or mod:GetEntityData(player)
    if data.howToRolling then
        player.Color = data.howToRolling.StoredColor or Color(1,1,1,1)
        if data.howToRolling.StoredColl then
            player.EntityCollisionClass = data.howToRolling.StoredColl
        end
        data.howToRolling = nil
    end
end

function mod:howToRollActive(player, data)
    if player:GetPlayerType() == mod.PLAYER.BRIEND and mod:IsBriendTwin(player) then return end
    if data.howToRolling then
        if player:CollidesWithGrid() then
            data.howToRolling.Vel = nil
        end
        local lerpVal = (1 - (data.howToRolling.Timer/rollLength)) * 0.25
        if data.howToRolling.Vel then
            player.Velocity = mod:Lerp(player.Velocity, data.howToRolling.Vel, lerpVal)
        else
            player.Velocity = mod:Lerp(player.Velocity, Vector.Zero, lerpVal)
        end

        if data.howToRolling.Timer >= 4 and data.howToRolling.Timer <= 20 then
            if not data.howToRolling.StoredColl then
                data.howToRolling.StoredColl = player.EntityCollisionClass
                player.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                if player:GetPlayerType() == mod.PLAYER.BRIEND then
                    mod:GetBriendTwin(player).EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                end
            end
            if data.howToRolling.heldPickup and data.howToRolling.heldPickup:Exists() and data.howToRolling.heldPickup.EntityCollisionClass >= EntityCollisionClass.ENTCOLL_PLAYEROBJECTS then
                if data.howToRolling.heldPickup.Position:Distance(player.Position) > 50 then
                    data.howToRolling.heldPickup = nil
                else
                    data.howToRolling.heldPickup.Velocity = mod:Lerp(data.howToRolling.heldPickup.Velocity, (player.Position - data.howToRolling.heldPickup.Position), 0.5)
                end
            else
                local pickup = mod.FindClosestEntity(player.Position, 35, 5)
                if pickup and (not pickup:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)) and pickup.EntityCollisionClass >= EntityCollisionClass.ENTCOLL_PLAYEROBJECTS and ((pickup.Variant ~= 100 or (pickup.Variant == 100 and pickup.SubType ~= 0)) and not pickup:ToPickup():IsShopItem()) then
                    if not (FiendFolio.howToRollPickupBlacklist[pickup.Variant]
                    or (pickup.Variant == 20 and pickup.SubType == 6)) then
                        sfx:Play(mod.Sounds.GrappleGrab,0.3,0,false, math.random(150,220)/100)
                        data.howToRolling.heldPickup = pickup
                    end
                end
            end
        else
            data.howToRolling.heldPickup = nil
            if data.howToRolling.StoredColl then
                player.EntityCollisionClass = data.howToRolling.StoredColl
                if player:GetPlayerType() == mod.PLAYER.BRIEND then
                    mod:GetBriendTwin(player).EntityCollisionClass = data.howToRolling.StoredColl
                end
                data.howToRolling.StoredColl = nil

                if player:HasTrinket(mod.ITEM.ROCK.ELECTRUM) then
                    local itemConfig = Isaac:GetItemConfig():GetCollectible(mod.ITEM.COLLECTIBLE.HOW_TO_ROLL)
                    local mult = mod.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.ELECTRUM)
                    local rng = player:GetTrinketRNG(FiendFolio.ITEM.ROCK.ELECTRUM)
                    mod:electrumShock(player, mult, rng, itemConfig, true)
                end
            end
        end

        if player.FrameCount % 2 == 1 and (data.howToRolling.Timer > 18 or data.howToRolling.Timer <= 6) then
            local extravel = (player.Velocity * -0.2):Rotated(-20 + math.random(40))
            local smoke = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, player.Position, extravel, player)
            mod:GetEntityData(smoke).longonly = true
            smoke.SpriteRotation = math.random(360)
            smoke.SpriteOffset = Vector(0,-5)
            smoke.Color = Color(180 / 255, 180 / 255, 180/255,0.15)
            smoke:Update()
        end
        --Timer!
        data.howToRolling.Timer = data.howToRolling.Timer + 1
        if data.howToRolling.Timer >= rollLength then
            mod:tryEndPlayerHowToRoll(player, data)
        end
    end
end

local SkinColorToString = {
    [-1] = "",
    [0] = "_white",
    [1] = "_black",
    [2] = "_blue",
    [3] = "_red",
    [4] = "_green",
    [5] = "_grey",
    [6] = "_shadow",
}

function mod:howToRollPlayerRender(player, offset, data)
    if player:GetPlayerType() == mod.PLAYER.BRIEND and mod:IsBriendTwin(player) then return end
    if data.howToRolling then
        local playerType = player:GetPlayerType()
        if not FiendFolio.howToRollSkinRejects[playerType] then
            local sprite = Sprite()
            sprite:Load("gfx/characters/roll.anm2")
            local skinColor = player:GetBodyColor()
            local choiceSheet = SkinColorToString[skinColor]
            if mod.howToRollSkinInfo[playerType] then
                if mod.howToRollSkinInfo[playerType].SkinAlts then
                    sprite:ReplaceSpritesheet(0, mod.howToRollSkinInfo[playerType].FilePath .. choiceSheet .. ".png")
                    sprite:LoadGraphics()
                else
                    sprite:ReplaceSpritesheet(0, mod.howToRollSkinInfo[playerType].FilePath .. ".png")
                    sprite:LoadGraphics()
                end
            elseif not (mod.howToRollSkinInfo[playerType]) then
                sprite:ReplaceSpritesheet(0, defaultFilepath .. choiceSheet .. ".png")
                sprite:LoadGraphics()
            end
            local playerVec = player.Velocity
            if playerVec:Length() < 0.5 then
                playerVec = player:GetMovementVector()
                if playerVec:Length() <= 0.1 then
                    playerVec = Vector(0, 1)
                end
            end
            if playerVec.X < 0 then
                sprite.FlipX = true
            else
                sprite.FlipX = false
            end
            local anim = "side"
            if math.abs(playerVec.X) < math.abs(playerVec.Y) then
                if playerVec.Y > 0 then
                    anim = "front"
                else
                    anim = "back"
                end
            end
            sprite:SetFrame("roll_" .. anim, math.floor(data.howToRolling.Timer / rollLength * 12))
            sprite.Color = data.howToRolling.StoredColor
            sprite.Scale = player.SpriteScale
            local effects = player:GetEffects()
            if effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_MEGA_MUSH) > 0 then
                sprite.Scale = sprite.Scale * 3
            end

            local pos = Isaac.WorldToRenderPosition(player.Position) + offset
            sprite:Render(pos, nilvector, nilvector)
        end
    end
end

mod:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, 200, function(_, player)
    local data = mod:GetEntityData(player)
    if player:GetPlayerType() == mod.PLAYER.BRIEND then
        if not mod:IsBriendTwin(player) then
            data = mod:GetEntityData(player:GetMainTwin())
        end
    end
    if data.howToRolling then
        player.Color = mod.ColorInvisible
    end
end, CacheFlag.CACHE_COLOR)

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.EARLY, function(_, p)
    local player = p:ToPlayer()
    if player:GetPlayerType() == mod.PLAYER.BRIEND then
        if not mod:IsBriendTwin(player) then
            player = player:GetMainTwin()
        end
    end
    local data = mod:GetEntityData(player)
    if data.howToRolling then
        if data.howToRolling.Timer >= 5 and data.howToRolling.Timer <= 20 then
            return false
        end
    end
end, 1)

local deniedInputActions = {
    [ButtonAction.ACTION_SHOOTLEFT] = true,
    [ButtonAction.ACTION_SHOOTRIGHT] = true,
    [ButtonAction.ACTION_SHOOTUP] = true,
    [ButtonAction.ACTION_SHOOTDOWN] = true,
    [ButtonAction.ACTION_ITEM] = true,
    [ButtonAction.ACTION_PILLCARD] = true,
    [ButtonAction.ACTION_DROP] = true,
}

mod:AddPriorityCallback("FF_PLAYER_INPUT_ACTION", -1, function(_, player, data, hook, action)
    if (hook == InputHook.IS_ACTION_TRIGGERED or hook == InputHook.IS_ACTION_PRESSED) and deniedInputActions[action] then
        if data.howToRolling then
            if data.howToRolling.Timer >= 5 and data.howToRolling.Timer <= 20 then
                return false
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local howRollWisps = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, mod.ITEM.COLLECTIBLE.HOW_TO_ROLL)
	for _, wisp in ipairs(howRollWisps) do
		wisp:Remove()
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
	local howRollWisps = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, mod.ITEM.COLLECTIBLE.HOW_TO_ROLL)
	for _, wisp in ipairs(howRollWisps) do
		wisp:Remove()
	end
end)

mod:AddCallback(mod.CALLBACK.FF_POST_TOTEM_LAUNCH, function(_, player, data)
    mod:tryEndPlayerHowToRoll(player, data)
end)