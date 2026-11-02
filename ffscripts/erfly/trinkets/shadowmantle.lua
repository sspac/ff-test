local mod = FiendFolio
local sfx = SFXManager()
local game = Game()

local SM_HITS = 6 --How many hits it can tank before breaking
local SM_LASTSTAND = 1 --Hits left to change appearance

local function getGulpedMantles(player)
    local history = player:GetHistory():GetCollectiblesHistory()
    local gulpedMantles = {}
    for i = 1, #history do
        if history[i]:IsTrinket() then
            if mod:GetRealTrinketId(history[i]:GetItemID()) == mod.ITEM.TRINKET.SHADOW_MANTLE then
                table.insert(gulpedMantles, history[i]:GetItemID())
            end
        end
    end
    return gulpedMantles
end

local function tryHandleMantle(player, id, gulped)
    local isGold = mod:IsGoldTrinket(id)
    local successRemoving
    if gulped then
        player:TryRemoveSmeltedTrinket(id)
        successRemoving = true --Just gonna hope it works!
    else
        successRemoving = player:TryRemoveTrinket(id)
    end
    if successRemoving then
        if isGold then
            local newid = id ~ 32768
            if gulped then
                player:AddSmeltedTrinket(newid)
            else
                player:AddTrinket(newid)
            end
        end
    end
    return successRemoving, isGold
end

function mod:shadowMantleHurt(player, flag, source, cooldown)
    local player = player
    if player:GetPlayerType() == mod.PLAYER.BRIEND and mod:IsBriendTwin(player) then
        player = player:GetMainTwin()
    end

    if player:HasTrinket(mod.ITEM.TRINKET.SHADOW_MANTLE) then

        if not mod:isDamageSelfInflicted(flag, source, nil, true)
        and player:GetDamageCooldown() <= 0 then
            local data = mod:GetEntityData(player).ffsavedata.RunEffects
            data.ShadowMantleHitsRemaining = data.ShadowMantleHitsRemaining or SM_HITS
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
                data.ShadowMantleHitsRemaining = data.ShadowMantleHitsRemaining - 0.5
            else
                data.ShadowMantleHitsRemaining = data.ShadowMantleHitsRemaining - 1
            end

            local shadowMantleWasRemoved, dontSpawnMantleTrinket
            if data.ShadowMantleHitsRemaining <= 0 then
                --Code where I figure out what mantles to hurt
                player:FlushQueueItem()
                local t0 = player:GetTrinket(0)
                local t1 = player:GetTrinket(1)
                local gulpedMantles = getGulpedMantles(player)
                local success, wasGold
                if mod:GetRealTrinketId(t0) == mod.ITEM.TRINKET.SHADOW_MANTLE then
                    success, wasGold = tryHandleMantle(player, t0)
                end
                if (not success) and mod:GetRealTrinketId(t1) == mod.ITEM.TRINKET.SHADOW_MANTLE then
                    success, wasGold = tryHandleMantle(player, t1)
                end
                if not success then
                    for i = 1, #gulpedMantles do
                        success = tryHandleMantle(player, gulpedMantles[i], true)
                        if success then
                            break
                        end
                    end
                end
                data.ShadowMantleHitsRemaining = nil

                if success then
                    shadowMantleWasRemoved = true
                    if wasGold then
                        dontSpawnMantleTrinket = true
                    end
                end
            end
            --Block damage
            player:SetMinDamageCooldown(60)
            player:SetColor(Color(0.1,0.1,0.1,0.5), 30, 0, true)
            local poof = Isaac.Spawn(1000, 15, 0, player.Position, Vector.Zero, nil):ToEffect()
            poof:FollowParent(player)
            local poofSprite = poof:GetSprite()
            poof.SpriteOffset = Vector(0, -20) * player.SpriteScale.X
            poof.SpriteScale = poof.SpriteScale * player.SpriteScale.X
            poof.Color = Color(0.1,0.1,0.1,0.5)
            poofSprite:Load("gfx/1000.144_enemy ghost.anm2", true)
            poofSprite:Play("Explosion")

            if shadowMantleWasRemoved then
                if not dontSpawnMantleTrinket then
                    local trinket = Isaac.Spawn(5, 350, mod.ITEM.TRINKET.SHADOW_MANTLE, player.Position, mod:TrueRandomVector():Resized(mod:RandomInt(10, 20)), player):ToPickup()
                    trinket.Timeout = 60
                    trinket.Wait = 100
                    trinket:GetSprite():GetLayer(0):SetCropOffset(Vector(32,0))
                    sfx:Play(mod.Sounds.ShadowMantleMove, 0.75, 0, false, 1)
                end

                sfx:Play(SoundEffect.SOUND_HOLY_MANTLE, 0.5, 0, false, 0.4)
                sfx:Play(SoundEffect.SOUND_MUSHROOM_POOF_2, 0.5, 0, false, 0.4)
                sfx:Play(SoundEffect.SOUND_EXPLOSION_WEAK, 0.7, 0, false, 0.4)
                sfx:Play(SoundEffect.SOUND_PORTAL_SPAWN, 1.25, 0, false, 0.6)
            elseif data.ShadowMantleHitsRemaining == 1 then
                sfx:Play(SoundEffect.SOUND_HOLY_MANTLE, 0.25, 0, false, 0.6)
                sfx:Play(SoundEffect.SOUND_MUSHROOM_POOF_2, 0.35, 0, false, 0.4)
                sfx:Play(SoundEffect.SOUND_PORTAL_SPAWN, 1.25, 0, false, 0.6)
                sfx:Play(SoundEffect.SOUND_MIRROR_EXIT, 0.5, 0, false, 0.8)
            else
                sfx:Play(SoundEffect.SOUND_HOLY_MANTLE, 0.25, 0, false, 0.6)
                sfx:Play(SoundEffect.SOUND_MUSHROOM_POOF_2, 0.35, 0, false, 0.6)
                sfx:Play(SoundEffect.SOUND_PORTAL_SPAWN, 1.25, 0, false, 0.75)
            end

			return false
		end
	end
end

function mod:shadowMantleCrop(slot, pos, scale, player, cropOffset)
    if mod:GetRealTrinketId(player:GetTrinket(slot)) == mod.ITEM.TRINKET.SHADOW_MANTLE then
        if slot == 0 or (slot ~= 0 and mod:GetRealTrinketId(player:GetTrinket(0)) ~= mod.ITEM.TRINKET.SHADOW_MANTLE) then
            local data = mod:GetEntityData(player).ffsavedata.RunEffects
            if data.ShadowMantleHitsRemaining and data.ShadowMantleHitsRemaining <= SM_LASTSTAND then
                return {CropOffset = Vector(32,0)}
            end
        end
    end
end

mod:AddTrinketCallback(ModCallbacks.MC_PRE_PLAYERHUD_TRINKET_RENDER, mod.ITEM.TRINKET.SHADOW_MANTLE, mod.shadowMantleCrop)

function mod.shouldRenderShadowMantleIcon(player, playerSlot)
	return player:HasTrinket(mod.ITEM.TRINKET.SHADOW_MANTLE)
end

function mod.onRenderShadowMantleIcon(player, playerSlot, healthIndex, renderInfo)
    mod.ExtraHealthIconSprite:Play("ShadowMantle", true)
    local hits = mod:GetEntityData(player).ffsavedata.RunEffects.ShadowMantleHitsRemaining
    local col = 0
    if hits then
        col = (hits/SM_HITS) * 0.75
        col = -0.75 + col
    end
	mod.ExtraHealthIconSprite.Color = Color(1,1,1,1,col,col,col)
	CustomHealthAPI.Helper.RenderHealth(mod.ExtraHealthIconSprite, player, playerSlot, healthIndex, renderInfo.RenderOffset, renderInfo.TotalHealthRendered, renderInfo.ExtraOffset)
end

CustomHealthAPI.Library.RegisterAfterHealthIcon("SHADOW_MANTLE",
	{SortOrder = -300,
	 ShouldRenderFunc = mod.shouldRenderShadowMantleIcon,
	 OnRenderFunc = mod.onRenderShadowMantleIcon,})