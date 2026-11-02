local mod = FiendFolio
local sfx = SFXManager()

local STANDARD_PENNY_SIZE = 12
local DAY_IN_SECONDS = 86400

function mod:pennyThatDoublesInSizeEveryDayBehaviour(penny)
    local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'PennyData', "" .. penny.InitSeed, {})
    local pd = mod:GetEntityData(penny)
    d.PennyStartTime = d.PennyStartTime or os.time()

    local secondsPast = os.difftime(os.time(), d.PennyStartTime)
    --Gets a little funny with medley penny, laggy on the sticky one
    local sizeLimit = 10
    if penny.SubType == mod.PICKUP.COIN.PENNY_THAT_DOUBLES_IN_SIZE_EVERY_DAY then
        sizeLimit = 16
    end
    local days = math.min(math.floor(secondsPast/DAY_IN_SECONDS),sizeLimit)
    local modifier = 2^days
    penny.Size = STANDARD_PENNY_SIZE*modifier
    penny.SpriteScale = Vector(modifier, modifier)
end

function mod:copyPennyThatDoublesSize(penny,newpenny)
    local pd = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'PennyData', "" .. penny.InitSeed, {})
    local npd = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'PennyData', "" .. newpenny.InitSeed, {})
    npd.PennyStartTime = pd.PennyStartTime
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, penny)
    if penny.SubType == mod.PICKUP.COIN.PENNY_THAT_DOUBLES_IN_SIZE_EVERY_DAY then
        mod:pennyThatDoublesInSizeEveryDayBehaviour(penny)
        if penny:GetSprite():IsEventTriggered("DropSound") then
			sfx:Play(SoundEffect.SOUND_PENNYDROP)
		end
    end
end, PickupVariant.PICKUP_COIN)