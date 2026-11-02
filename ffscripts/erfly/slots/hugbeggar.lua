local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local hugbeggarvec = {
    ["Left"] = -25,
    ["Right"] = 25
}

local hugbeggarhaters = {
    [FiendFolio.PLAYER.FIEND] = true,
    [FiendFolio.PLAYER.BIEND] = true,
    [FiendFolio.PLAYER.FRIEND] = true,
    [FiendFolio.PLAYER.BRIEND] = true,
}

local function explodeHugBeggar(slot, data, d)
    sfx:Play(mod.Sounds.MadnessSplash, 1, 0, false, 1.3)
    sfx:Play(mod.Sounds.Valvo, 1, 0, false, 1.3)
    sfx:Play(mod.Sounds.MeatySquish, 0.2, 0, false, 1.3)
    local bloodSplat = Isaac.Spawn(1000, 2, 0, slot.Position, nilvector, slot)
    bloodSplat.SpriteScale = bloodSplat.SpriteScale * 0.5
    bloodSplat.SpriteOffset = Vector(0, -5)
    bloodSplat:Update()
    local bloodCloud = Isaac.Spawn(1000, 16, 3, slot.Position, nilvector, slot)
    bloodCloud.SpriteScale = bloodCloud.SpriteScale * 0.5
    bloodCloud.SpriteOffset = Vector(0, -5)
    bloodCloud:Update()
    local bloodCloud2 = Isaac.Spawn(1000, 16, 4, slot.Position, nilvector, slot)
    bloodCloud2.SpriteScale = bloodCloud2.SpriteScale * 0.5
    bloodCloud2.SpriteOffset = Vector(0, -5)
    bloodCloud2:Update()
    for i = 1, 10 do
        local chosenGib = math.random(3) - 1
        local gib = Isaac.Spawn(1000, 5, chosenGib, slot.Position, RandomVector()*math.random(5,50)/10, slot):ToEffect()
        gib:Update()
    end
    if d.DropFunc then
        d.DropFunc()
    end
    slot:Remove()
end

mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, function(_, slot)
    local sprite, d = slot:GetSprite(), mod:GetEntityData(slot)
	local data = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})

    if not data.init then
        data.init = true
        local chance = 90
        if game.Difficulty % 2 == 1 then --Hard
            chance = 30
        end
        if slot:GetDropRNG():RandomInt(chance) == 0 then
            data.MugBeggar = true
            slot.SubType = 1
        end
    end
    if data.left then
        if sprite:IsFinished("Teleport") or sprite:IsFinished("TeleportMug") then
            slot:Remove()
        else
            if d.MugSuccessful then
                mod:spritePlay(sprite, "TeleportMug")
            else
                mod:spritePlay(sprite, "Teleport")
            end
        end
    elseif d.hugee and d.hugee.Player then
        local player = d.hugee.Player
        local hugeeIsMaggyBSkin = player:GetPlayerType() == PlayerType.PLAYER_MAGDALENE_B
        if sprite:IsFinished("Hug" .. d.hugee.Side) and (player.Velocity:Length() > 1)
        or sprite:IsEventTriggered("Grip") and hugeeIsMaggyBSkin then
            data.left = true
            slot.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            mod:fortuneGrubCheck()
            local payoutVar = 10
            if mod.anyPlayerHas(TrinketType.TRINKET_DAEMONS_TAIL, true) then
                local rng = player:GetTrinketRNG(TrinketType.TRINKET_DAEMONS_TAIL)
                if rng:RandomInt(5) ~= 0 then
                    payoutVar = 20 + (rng:RandomInt(3) * 10)
                end
            end
            local payouts = 1
            payouts = payouts + math.ceil(FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.THANK_YOU_FOSSIL))
            for i = 1, payouts do
                local pickup = Isaac.Spawn(5, payoutVar, 0, slot.Position, Vector(0,2):Rotated(-30 + math.random(60)), slot):ToPickup()
                if hugeeIsMaggyBSkin then
                    pickup.Timeout = 60
                end
            end
            sfx:Play(SoundEffect.SOUND_FETUS_JUMP,1,0,false,1)
            if hugeeIsMaggyBSkin then
                explodeHugBeggar(slot, data, d)
            else
                --Mug Beggar
                if data.MugBeggar then
                    if player:GetNumCoins() > 0 then
                        player:AddCoins(-1)
                        sfx:Play(mod.Sounds.CursedPennyNegative)
                        d.MugSuccessful = true
                        if player:HasTrinket(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE) then
                            mod:makeShampooText("GetMugged")
                        end
                    end
                end
            end
        else
            mod:spritePlay(sprite, "Hug" .. d.hugee.Side)
            d.hugTimer = d.hugTimer or 0
            d.hugTimer = d.hugTimer + 1
            if d.hugTimer == 30 then
                if player:HasTrinket(mod.ITEM.TRINKET.THE_SHAMPOO_BOTTLE) then
                    mod:makeShampooText("GetHugged")
                end
            end
        end

        local targpos = slot.Position + Vector(hugbeggarvec[d.hugee.Side], -5)
        local targvec = targpos - player.Position
        player.Velocity = mod:Lerp(player.Velocity, targvec, 0.1)
        player.Position = mod:Lerp(player.Position, targpos, 0.3)
    else
        if data.hasHugged then
            slot:Remove()
        end
        local player = mod:getClosestPlayer(slot.Position, 300)
        if player and player.Position:Distance(slot.Position) < 125 then
            if player:GetPlayerType() ~= mod.PLAYER.FRIEND then
                if sprite:IsPlaying("IdleSad") then
                    mod:spritePlay(sprite, "Happy")
                end
            end
        elseif player and player.Position:Distance(slot.Position) > 150 then
            if sprite:IsPlaying("IdleHappy") then
                mod:spritePlay(sprite, "Sad")
            end
        end

        for _, tear in pairs(Isaac.FindInRadius(slot.Position, 10, EntityPartition.TEAR)) do
            if TearFlagsLib.HasTearFlags(tear, mod.FriendBulletFlags.FRIEND) then
                explodeHugBeggar(slot, data, d)
            end
        end
        if sprite:IsFinished("Happy") then
            mod:spritePlay(sprite, "IdleHappy")
        elseif sprite:IsFinished("Sad") then
            mod:spritePlay(sprite, "IdleSad")
        end
    end

	if not d.DropFunc then
		function d.DropFunc()
			if not d.DidDropFunc then
                d.DidDropFunc = true
                if not data.left then
                    local pickup = Isaac.Spawn(5, 10, 0, slot.Position, Vector(0,2):Rotated(-30 + math.random(60)), slot):ToPickup()
                end
                game:GetLevel():SetStateFlag(LevelStateFlag.STATE_BUM_KILLED, true)
                for _, player in ipairs(Isaac.FindByType(1, 0, -1)) do
                    player = player:ToPlayer()
                    if hugbeggarhaters[player:GetPlayerType()] then
                        player:AnimateHappy()
                    else
                        player:AnimateSad()
                    end
                end
			end
		end
	end

    if data.MugBeggar then
        local layer = sprite:GetLayer(1)
        layer:SetCropOffset(Vector(0,128))
    end

    FiendFolio.OverrideExplosionHack(slot)
end, mod.FF.HugBeggar.Var)

FiendFolio.onMachineTouch(mod.FF.HugBeggar.Var, function(player, slot)
    local sprite, d = slot:GetSprite(), mod:GetEntityData(slot)
	local data = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})
    if not d.hugee then
        local side = "Left"
        if player.Position.X > slot.Position.X then
            side = "Right"
        end
        d.hugee = {Player = player, Side = side}
        data.hasHugged = true
        sfx:Play(SoundEffect.SOUND_FETUS_LAND,1,0,false,1)
        mod:doBethEssenceCheck(player, nil, true)
    end
end)