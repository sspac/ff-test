local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, function(_, familiar)
	familiar.IsFollower = true
end, mod.ITEM.FAMILIAR.TIME_IS_MONEY)

local minute = 1800
local smallPenniesPerMinute = 15
local smallPennyStep = minute/smallPenniesPerMinute

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, function(_, familiar)
	local data = mod:GetEntityData(familiar)
	local sprite = familiar:GetSprite()
    
    local expectedPennies = math.floor(game.TimeCounter / smallPennyStep)

    if not data.calculatedCoins then
        data.calculatedCoins = true
        familiar.Coins = expectedPennies
    end

    if not sprite:IsPlaying("Proc") and not sprite:IsPlaying("ProcRare") then
        mod:spritePlay(sprite, "Float")
        if expectedPennies > familiar.Coins then
            if mod:RandomFloat() > 0.1 then
                sprite:Play("Proc", true)
            else
                sprite:Play("ProcRare", true)
            end
            familiar.Coins = familiar.Coins + 1
            mod:AddFractionalCoins(0.1)
        end
    end

	familiar:FollowParent()
end, mod.ITEM.FAMILIAR.TIME_IS_MONEY)