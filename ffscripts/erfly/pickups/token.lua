local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local validPickupAnimations = {
    ["Collect"] = true,
    ["PlayerPickupSparkle"] = true,
}

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	local sprite = pickup:GetSprite()
    local d = mod:GetEntityData(pickup)
    d.isPickupAToken = true
	if sprite:IsFinished("Appear") then
		sprite:Play("Idle", false)
	end
	if sprite:IsPlaying("Collect") and sprite:GetFrame() == 5 then
		pickup:Remove()
	end
	if sprite:IsEventTriggered("DropSound") then
		sfx:Play(SoundEffect.SOUND_PENNYDROP, 1, 0, false, 1.0)
	end

    CustomHealthAPI.Helper.CustomPickupMagnetoCheck(pickup)

    if sprite:IsPlaying("Idle") and mod.anyPlayerHas(CollectibleType.COLLECTIBLE_GUPPYS_EYE) then
        local dist = Game():GetNearestPlayer(pickup.Position).Position:Distance(pickup.Position)
        d.Alpha = d.Alpha or 0
        d.Alpha = mod:Lerp(d.Alpha, 0.8, 0.1)
    else
        d.Alpha = 0
    end
end, mod.PICKUP.VARIANT.TOKEN)

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, pickup, collider, low)
	if collider.Type == 1 then
		collider = collider:ToPlayer()

		if pickup:IsShopItem() and pickup.Price > collider:GetNumCoins() then
			Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, low)
			return true
        else
            local d = mod:GetEntityData(pickup)
            d.isPickupAToken = true

            if pickup:GetSprite():WasEventTriggered("DropSound") or pickup:GetSprite():IsPlaying("Idle") then
                local savedata = FiendFolio.savedata.run
                if savedata.CurrentTokenValue then
                    --print(pickup:GetSprite():GetAnimation())
                    pickup.Variant = savedata.CurrentTokenValue[1] or 20
                    pickup.SubType = savedata.CurrentTokenValue[2] or 1
                    if REPENTOGON then
						if low then
							pickup:ForceCollide(collider, true)
						else
							collider:ForceCollide(pickup, true)
						end
						pickup.Variant = mod.PICKUP.VARIANT.TOKEN
						pickup.SubType = 0
						Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, low)
						return true
					else
						pickup:AddEntityFlags(EntityFlag.FLAG_NO_QUERY)
						mod.scheduleForUpdate(function()
							--print(pickup.Variant, pickup.SubType)
							if not validPickupAnimations[pickup:GetSprite():GetAnimation()] then
								pickup.Variant = mod.PICKUP.VARIANT.TOKEN
								pickup.SubType = 0
								pickup:ClearEntityFlags(EntityFlag.FLAG_NO_QUERY)
								collider:GetSprite():Play("Idle", false)
							end
						end, 2)
						Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, low)
						return true
					end
                else
                    sfx:Play(mod.Sounds.CursedPennyNeutral, 1, 0, false, 1)
                    pickup:GetSprite():Play("Collect")
                    pickup.Velocity = Vector.Zero
                    pickup.EntityCollisionClass = 0
                    if pickup:IsShopItem() then
                        collider:AddCoins(-1 * pickup.Price)
                    end
                    if pickup.OptionsPickupIndex ~= 0 then
                        local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
                        for _, entity in ipairs(pickups) do
                            if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
                                (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
                            then
                                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, nilvector, nil)
                                entity:Remove()
                            end
                        end
                    end
                    Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, low)
                    return true
                end
                
            end
        end
    else
        Isaac.RunCallbackWithParam(ModCallbacks.MC_POST_PICKUP_COLLISION, pickup.Variant, pickup, collider, low)
        return true
    end
end, mod.PICKUP.VARIANT.TOKEN)

mod:AddPriorityCallback(ModCallbacks.MC_TRY_ADD_TO_BAG_OF_CRAFTING, CallbackPriority.IMPORTANT, function(_, player, pickup, craftingPickups)
    local savedata = FiendFolio.savedata.run
    if savedata.CurrentTokenValue and savedata.CurrentTokenValue[1] ~= mod.PICKUP.VARIANT.TOKEN then
        pickup.Variant = savedata.CurrentTokenValue[1] or 20
        pickup.SubType = savedata.CurrentTokenValue[2] or 1
        player:TryAddToBagOfCrafting(pickup)
        pickup.Variant = mod.PICKUP.VARIANT.TOKEN
        pickup.SubType = 0
        return false
    end
end, mod.PICKUP.VARIANT.TOKEN)

FiendFolio.TokenBlacklist = {
    [PickupVariant.PICKUP_COLLECTIBLE] = true,
    [PickupVariant.PICKUP_BROKEN_SHOVEL] = true,
    [PickupVariant.PICKUP_BIGCHEST] = true,
    [PickupVariant.PICKUP_TROPHY] = true,
    [PickupVariant.PICKUP_BED] = true,
}

mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.EARLY, function(_, pickup, collider)
    if collider.Type == 1 then
        if not (mod:GetEntityData(pickup).isPickupAToken or FiendFolio.TokenBlacklist[pickup.Variant]) then
            local possiblePickup = {pickup.Variant, pickup.SubType}
            mod.scheduleForUpdate(function()
                --print(pickup:GetSprite():GetAnimation(), pickup.Visible, pickup:IsShopItem(), pickup.State, pickup:Exists(), collider:ToPlayer():CanPickupItem())
                if validPickupAnimations[pickup:GetSprite():GetAnimation()] --Normal nice pickup shit
                or (pickup:IsShopItem() and not pickup:Exists()) --Of course shop items make it awkward
                then
                    if pickup.Variant ~= mod.PICKUP.VARIANT.TOKEN then
                        FiendFolio.savedata.run.CurrentTokenValue = {possiblePickup[1] or pickup.Variant, possiblePickup[2] or pickup.SubType, pickup:GetSprite():GetFilename()}
                        --Achievement tracking
                        if not mod.LastApprovedPickup or (mod.LastApprovedPickup and mod.LastApprovedPickup ~= GetPtrHash(pickup)) then
                            mod.LastApprovedPickup = GetPtrHash(pickup)
                            FiendFolio.savedata.totalPickupsPickedUp = FiendFolio.savedata.totalPickupsPickedUp or 0
                            FiendFolio.savedata.totalPickupsPickedUp = FiendFolio.savedata.totalPickupsPickedUp + 1
                            --print(FiendFolio.savedata.totalPickupsPickedUp)
                            if FiendFolio.savedata.totalPickupsPickedUp >= 1000 then
                                if not FiendFolio.ACHIEVEMENT.TOKEN:IsUnlocked(true) then
                                    FiendFolio.ACHIEVEMENT.TOKEN:Unlock()
                                end
                            end
                        end
                    end
                end
            end, 0)
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_ADD_TO_BAG_OF_CRAFTING, function(_, player, pickup, craftingPickups)
    if pickup.Variant ~= mod.PICKUP.VARIANT.TOKEN and not mod:GetEntityData(pickup).isPickupAToken and not FiendFolio.TokenBlacklist[pickup.Variant] and pickup:IsDead() then
        FiendFolio.savedata.run.CurrentTokenValue = {pickup.Variant, pickup.SubType, pickup:GetSprite():GetFilename()}
    end
end)

--Prevent duplication of Jera runes
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_,card,player)
    local tokenToDelete = Isaac.FindByType(5,mod.PICKUP.VARIANT.TOKEN)
    for  _, v in pairs(tokenToDelete) do
        if v.FrameCount == 0 then
            v:Remove()
        end
    end
end, Card.RUNE_JERA)

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, function(_, pickup)
    if pickup.Variant == mod.PICKUP.VARIANT.TOKEN or mod:GetEntityData(pickup).isPickupAToken then
        if mod:GetEntityData(pickup).Alpha and mod:GetEntityData(pickup).Alpha > 0 then
            if mod.WaterRenderModes[game:GetRoom():GetRenderMode()] then return end
            if pickup:GetSprite():IsPlaying("Collect") then return end
            local savedata = FiendFolio.savedata.run
            if not savedata.CurrentTokenValue then return end
            local icon = Sprite()
            icon:Load(savedata.CurrentTokenValue[3], true)
            if savedata.CurrentTokenValue[1] == 350 then
                icon:ReplaceSpritesheet(0, Isaac.GetItemConfig():GetTrinket(savedata.CurrentTokenValue[2]).GfxFileName)
                icon:LoadGraphics()
            end
            icon:SetFrame("Idle", 0)

            icon.Color = Color(icon.Color.R, icon.Color.G, icon.Color.B, mod:GetEntityData(pickup).Alpha or 0, icon.Color.RO, icon.Color.GO, icon.Color.BO)
            icon.Scale = Vector(0.5, 0.5)
            local offset = Vector.Zero
            if savedata.CurrentTokenValue[1] == 20 then
                offset = Vector(0, -3)
            end
            local renderPos = Isaac.WorldToScreen(pickup.Position + offset)
            icon:Render(renderPos, Vector.Zero, Vector.Zero)
        end
    end
end)