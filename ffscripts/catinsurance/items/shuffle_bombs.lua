local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local ChaosBombs = {}

local ITEM = mod.ITEM.COLLECTIBLE.SHUFFLE_BOMBS
local EFFECT_COUNT = 3

local eggFlag = TearFlagsLib.RegisterTearFlag("CHAOS_EGG_BOMB")
local magnetFlag = TearFlagsLib.RegisterTearFlag("CHAOS_MAGNET_BOMB")
local poopFlag = TearFlagsLib.RegisterTearFlag("CHAOS_POOP_BOMB")
local holyFlag = TearFlagsLib.RegisterTearFlag("CHAOS_HOLY_BOMB")
local babyFlag = TearFlagsLib.RegisterTearFlag("CHAOS_BABY_BOMB")
local iceFlag = TearFlagsLib.RegisterTearFlag("CHAOS_ICE_BOMB")
local flyingFlag = TearFlagsLib.RegisterTearFlag("CHAOS_FLYING_BOMB")
local fortuneFlag = TearFlagsLib.RegisterTearFlag("CHAOS_FORTUNE_BOMB")
local moneyFlag = TearFlagsLib.RegisterTearFlag("CHAOS_MONEY_BOMB")
local bubbleFlag = TearFlagsLib.RegisterTearFlag("CHAOS_BUBBLE_BOMB")

local FLAG_COLORS = {
    ["EGG_BOMBS"]     = Color(0.843, 0.075, 0.192, 1),
    ["MAGNET_BOMBS"]  = Color(0.294, 0.294, 0.294, 1),
    ["POOP_BOMBS"]    = Color(0.541, 0.325, 0.251, 1),
    ["HOLY_BOMBS"]    = Color(0, 1, 1, 1),
    ["BABY_BOMBS"]    = Color(0.89, 0.776, 0.773, 1),
    ["ICE_BOMBS"]     = Color(0.153, 0.62, 0.949, 1),
    ["FLYING_BOMBS"]  = Color(1, 1, 1, 1),
    ["FORTUNE_BOMBS"] = Color(0.596, 0.271, 0.965, 1),
    ["MONEY_BOMBS"]   = Color(1, 0.89, 0, 1),
    ["BUBBLE_BOMBS"]  = Color(0.973, 0.627, 0.886, 1),
}

mod.ReducedEggBombEffect = {
	[mod.BombFlagSource.DR_FETUS] = true,
	[mod.BombFlagSource.EPIC_FETUS] = true,
	[mod.BombFlagSource.ANARCHISTS_EASY_BAKE] = true,
	[mod.BombFlagSource.CLUB_EPIC_FETUS] = true,
    [mod.BombFlagSource.WRATHFUL_PLUSHIE] = true,
}

mod.NoEggBombEffect = {
	[mod.BombFlagSource.LOCUST_OF_WAR] = true,
}

mod.ReducedPoopBombEffect = {
	[mod.BombFlagSource.DR_FETUS] = true,
	[mod.BombFlagSource.EPIC_FETUS] = true,
	[mod.BombFlagSource.LOCUST_OF_WAR] = true,
	[mod.BombFlagSource.ANARCHISTS_EASY_BAKE] = true,
	[mod.BombFlagSource.CLUB_EPIC_FETUS] = true,
}

mod.ReducedHolyBombEffect = {
	[mod.BombFlagSource.LOCUST_OF_WAR] = true,
}

mod.ReducedBabyBombEffect = {
	[mod.BombFlagSource.DR_FETUS] = true,
	[mod.BombFlagSource.EPIC_FETUS] = true,
	[mod.BombFlagSource.ANARCHISTS_EASY_BAKE] = true,
	[mod.BombFlagSource.CLUB_EPIC_FETUS] = true,
    [mod.BombFlagSource.WRATHFUL_PLUSHIE] = true,
}

mod.NoBabyBombEffect = {
	[mod.BombFlagSource.LOCUST_OF_WAR] = true,
}

mod.ReducedIceBombEffect = {
	[mod.BombFlagSource.LOCUST_OF_WAR] = true,
}

mod.ReducedFortuneBombEffect = {
	[mod.BombFlagSource.DR_FETUS] = true,
	[mod.BombFlagSource.EPIC_FETUS] = true,
	[mod.BombFlagSource.LOCUST_OF_WAR] = true,
	[mod.BombFlagSource.ANARCHISTS_EASY_BAKE] = true,
	[mod.BombFlagSource.CLUB_EPIC_FETUS] = true,
}

mod.ReducedMoneyBombEffect = {
	[mod.BombFlagSource.DR_FETUS] = true,
	[mod.BombFlagSource.EPIC_FETUS] = true,
	[mod.BombFlagSource.ANARCHISTS_EASY_BAKE] = true,
	[mod.BombFlagSource.CLUB_EPIC_FETUS] = true,
    [mod.BombFlagSource.WRATHFUL_PLUSHIE] = true,
}

mod.NoMoneyBombEffect = {
	[mod.BombFlagSource.LOCUST_OF_WAR] = true,
}

mod.ReducedBubbleBombEffect = {
	[mod.BombFlagSource.LOCUST_OF_WAR] = true,
}

-- Spawn a random blue buggy
---@param player EntityPlayer
function ChaosBombs:EggExplosion(pos, radius, tearflags, src, radiusMult, player, sourceFlag, tearFlagParams)
	if mod.NoEggBombEffect[sourceFlag] or (mod.ReducedEggBombEffect[sourceFlag] and game:GetRoom():IsClear()) or mod:GetEntityData(src).FFIsScatter then return end

    local rng = player:GetCollectibleRNG(ITEM)
    local count = 1
    if not mod.ReducedEggBombEffect[sourceFlag] then
        count = rng:RandomInt(3, 5)
    end
    
    for _ = 1, count do
        local choice = rng:RandomInt(4)
        
        -- Blue fly
        if choice == 0 then
            player:AddBlueFlies(1, src.Position, player)
        elseif choice == 1 then
            player:AddBlueSpider(src.Position)
        elseif choice == 2 then
            mod.ThrowFriendlySkuzz(player, RandomVector() * 5, src.Position)
        else
            mod:ThrowBlueBeetle(player, src.Position, RandomVector() * 5)
        end
    end
end
mod:AddCallback(FiendFolio.CALLBACK.FF_POST_BOMBFLAG_EFFECTS, ChaosBombs.EggExplosion, eggFlag)

-- Spawn a poop tile and butter bean fart
function ChaosBombs:PoopExplosion(pos, radius, tearflags, src, radiusMult, player, sourceFlag, tearFlagParams)
    local isReduced = mod.ReducedPoopBombEffect[sourceFlag] or mod:GetEntityData(src).FFIsScatter
	local room = game:GetRoom()
    local clamped = room:FindFreeTilePosition(src.Position, 40)
    game:ButterBeanFart(src.Position, 120 * radiusMult, player, false, not isReduced)
	local fartCloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, src.Position, Vector(0,0), player)
	local fartSprite = fartCloud:GetSprite()
	fartSprite.Color = Color(1.8, 0.7, 1.5, 1.0)
	fartSprite.Scale = Vector(radiusMult,radiusMult)
    sfx:Play(SoundEffect.SOUND_FART)
    if isReduced then return end
	mod.scheduleForUpdate(function()
		game:GetRoom():SpawnGridEntity(room:GetGridIndex(clamped), GridEntityType.GRID_POOP)
	end, 3)
end
mod:AddCallback(FiendFolio.CALLBACK.FF_POST_BOMBFLAG_EFFECTS, ChaosBombs.PoopExplosion, poopFlag)

-- Holy beams on explosion
function ChaosBombs:HolyExplosion(pos, radius, tearflags, src, radiusMult, player, sourceFlag, tearFlagParams)
    local rng = player:GetCollectibleRNG(ITEM)
	local count = ((mod.ReducedHolyBombEffect[sourceFlag] or mod:GetEntityData(src).FFIsScatter) and 1) or 5
    for i = 1, count do
        Isaac.CreateTimer(function ()
            local direction = RandomVector():Resized(rng:RandomInt(40, 160))
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 1, direction + src.Position, Vector.Zero, player)
        end, i * 2, 1, false)
    end
end
mod:AddCallback(FiendFolio.CALLBACK.FF_POST_BOMBFLAG_EFFECTS, ChaosBombs.HolyExplosion, holyFlag)

-- Spawn 2 minisaacs
---@param player EntityPlayer
function ChaosBombs:BabyExplosion(pos, radius, tearflags, src, radiusMult, player, sourceFlag, tearFlagParams)
    if mod.NoBabyBombEffect[sourceFlag] or mod:GetEntityData(src).FFIsScatter then
		return
	end
	if mod.ReducedBabyBombEffect[sourceFlag] then
        local rng = player:GetCollectibleRNG(ITEM)
        if game:GetRoom():IsClear() or rng:RandomFloat() < 0.8 then
            return
        end
    end
    for _ = 1, 2 do
        player:AddMinisaac(src.Position, true)
    end
end
mod:AddCallback(FiendFolio.CALLBACK.FF_POST_BOMBFLAG_EFFECTS, ChaosBombs.BabyExplosion, babyFlag)

-- Shoot a ring of ice tears on explosion
function ChaosBombs:IceExplosion(pos, radius, tearflags, src, radiusMult, player, sourceFlag, tearFlagParams)
    local count, offset = 8, 0
	if mod.ReducedIceBombEffect[sourceFlag] or mod:GetEntityData(src).FFIsScatter then
		count = 3
		offset = math.random(360)
	end
	for i = 1, count do
        local angle = 360 / count * i + offset
        local speed = 16
        local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.ICE, 0, src.Position, Vector.FromAngle(angle):Resized(speed), player):ToTear()
        tear:AddTearFlags(TearFlags.TEAR_ICE)
    end

    sfx:Play(SoundEffect.SOUND_FREEZE_SHATTER)
end
mod:AddCallback(FiendFolio.CALLBACK.FF_POST_BOMBFLAG_EFFECTS, ChaosBombs.IceExplosion, iceFlag)

-- Show a fortune on explosion (obligatory wacky)
function ChaosBombs:FortuneExplosion(pos, radius, tearflags, src, radiusMult, player, sourceFlag, tearFlagParams)
	if mod:GetEntityData(src).FFIsScatter then
		return
	end
    if mod.ReducedFortuneBombEffect[sourceFlag] then
        local rng = player:GetCollectibleRNG(ITEM)
        if rng:RandomFloat() < 0.66 then
            return
        end
    end

    mod:ShowFortune()
end
mod:AddCallback(FiendFolio.CALLBACK.FF_POST_BOMBFLAG_EFFECTS, ChaosBombs.FortuneExplosion, fortuneFlag)

function ChaosBombs:MoneyExplosion(pos, radius, tearflags, src, radiusMult, player, sourceFlag, tearFlagParams)
    if mod.NoMoneyBombEffect[sourceFlag] or mod:GetEntityData(src).FFIsScatter then
		return
	end
	if mod.ReducedMoneyBombEffect[sourceFlag] then
        local rng = player:GetCollectibleRNG(ITEM)
        if rng:RandomFloat() < 0.95 then
            return
        end
    end


    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, src.Position, Vector.Zero, player)
end
mod:AddCallback(FiendFolio.CALLBACK.FF_POST_BOMBFLAG_EFFECTS, ChaosBombs.MoneyExplosion, moneyFlag)

-- Shoot bubbles in 9 directions.
function ChaosBombs:BubbleExplosion(pos, radius, tearflags, src, radiusMult, player, sourceFlag, tearFlagParams)
    if mod.IsActiveRoom() then
		local count, offset = 9, 0
		if mod.ReducedBubbleBombEffect[sourceFlag] or mod:GetEntityData(src).FFIsScatter then
			count = 1
			offset = math.random(360)
		end
        for i = 1, count do
            local angle = 360 / count * i + offset
            local bubble = mod.ShootBubble(player, mod.FF.BubbleSmall.Sub, src.Position, Vector.FromAngle(angle) * 4)
            bubble:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
        end
    end
end
mod:AddCallback(FiendFolio.CALLBACK.FF_POST_BOMBFLAG_EFFECTS, ChaosBombs.BubbleExplosion, bubbleFlag)

-- Fly towards enemies
---@param bomb EntityBomb
function mod:ChaosBombsFlyingPassive(player, bomb)
    if bomb.FrameCount == 0 then
        bomb.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		mod:GetEntityData(bomb).chaosHadHomingBefore = bomb:HasTearFlags(TearFlags.TEAR_HOMING)
        bomb:AddTearFlags(TearFlags.TEAR_HOMING)
        bomb:SetExplosionCountdown(bomb:GetExplosionCountdown() + 15)
    end
end

function mod.handleFlyingBombD3(entity)
	if entity.Type == EntityType.ENTITY_BOMB then
		local bomb = entity:ToBomb()
		bomb.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		mod:GetEntityData(bomb).chaosHadHomingBefore = bomb:HasTearFlags(TearFlags.TEAR_HOMING)
        bomb:AddTearFlags(TearFlags.TEAR_HOMING)
        bomb:SetExplosionCountdown(bomb:GetExplosionCountdown() + 15)
	end
end

-- Strange attractor passive
function mod:ChaosBombsMagnetPassive(player, bomb)
    game:UpdateStrangeAttractor(bomb.Position, 15)

    if bomb.FrameCount % 5 == 0 then
        local dust = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DUST_CLOUD, 0, bomb.Position, Vector(mod:RandomFloat(-3.75, 3.75), -5), nil):ToEffect()
        dust.SpriteScale = Vector.One * 0.5
        dust.Timeout = 10
        dust.LifeSpan = 10
        dust.DepthOffset = -10000
        dust:Update()
    end
end

-- Summon slippery creep passively
function mod:ChaosBombsIcePassive(player, bomb)
    if bomb.FrameCount % 6 == 0 then
        local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 0, bomb.Position, Vector.Zero, player):ToEffect()
        local c = Color(1, 1, 1, 1, 0, 0.75, 1)
        creep.Timeout = 30
        creep.Color = c
        creep:Update()
    end
end

-- Summon bubbles randomly.
function mod:ChaosBombsBubblePassive(player, bomb)
    if bomb.FrameCount % 7 == 0 and mod.IsActiveRoom() and not mod:GetEntityData(bomb).FFIsScatter then
        local bubble = mod.ShootBubble(player, mod.FF.BubbleSmall.Sub, bomb.Position, RandomVector() * 4)
        bubble:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
    end
end

----------------------------------------------------------------------------------------------------------------------------------

local ON_PASSIVE = {
    [magnetFlag] = mod.ChaosBombsMagnetPassive,
    [iceFlag] = mod.ChaosBombsIcePassive,
    [flyingFlag] = mod.ChaosBombsFlyingPassive,
    [bubbleFlag] = mod.ChaosBombsBubblePassive,
}

-- turns out savedata doesnt really like saving tearflagslib bitsetinfinity to file so here we are
local NAME_TO_BITSET = {
    ["EGG_BOMBS"] = eggFlag,
    ["MAGNET_BOMBS"] = magnetFlag,
    ["POOP_BOMBS"] = poopFlag,
    ["HOLY_BOMBS"] = holyFlag,
    ["BABY_BOMBS"] = babyFlag,
    ["ICE_BOMBS"] = iceFlag,
    ["FLYING_BOMBS"] = flyingFlag,
    ["FORTUNE_BOMBS"] = fortuneFlag,
    ["MONEY_BOMBS"] = moneyFlag,
    ["BUBBLE_BOMBS"] = bubbleFlag
}

---@param player EntityPlayer
function ChaosBombs:RandomizeEffects(_, _, _, _, _, player)
    local saveData = mod:GetEntityData(player).ffsavedata
    saveData.ChaosBombEffects = {}

    local effects = {
        "EGG_BOMBS",
        "MAGNET_BOMBS",
        "POOP_BOMBS",
        "HOLY_BOMBS",
        "BABY_BOMBS",
        "ICE_BOMBS",
        "FLYING_BOMBS",
        "FORTUNE_BOMBS",
        "MONEY_BOMBS",
        "BUBBLE_BOMBS"
    }
    
    local rng = player:GetCollectibleRNG(ITEM)
    for _ = 1, EFFECT_COUNT do
        local choice = rng:RandomInt(1, #effects)
        table.insert(saveData.ChaosBombEffects, table.remove(effects, choice))
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, ChaosBombs.RandomizeEffects, ITEM)

function mod:ChaosBombsRandomizeEffects()
    for _, player in ipairs(PlayerManager.GetPlayers()) do
        if player:HasCollectible(ITEM) then
            ChaosBombs:RandomizeEffects(nil, nil, nil, nil, nil, player)
        end
    end
end

function mod:chaosBombsFlag(entity, player)
	if player:HasCollectible(ITEM) then
        local data = mod:GetEntityData(player).ffsavedata.ChaosBombEffects
        if not data then return end
		
        for _, flag in ipairs(data) do
			TearFlagsLib.AddTearFlags(entity, NAME_TO_BITSET[flag])
		end
		
		local bomb = entity:ToBomb()
		if bomb then
			ChaosBombs:TriggerPassiveBomb(bomb, player, true)
		end
	end
end
mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_POLL_BOMBFLAGS, ITEM, mod.chaosBombsFlag)

local Anm2RandomOffsets = {
    { Middle = -3, Top = 0 },
    { Middle = -3, Top = -1 },
    { Middle = -2, Top = 1 },
    { Middle = -2, Top = 0 },
    { Middle = 2, Top = -1 },
    { Middle = 2, Top = 0 },
    { Middle = 3, Top = 0 },
    { Middle = 3, Top = 1 },
}

function mod:shuffleBombsVariant(bomb, player, sourceFlag)
	--if mod.CanShuffle[sourceFlag] and player:HasCollectible(ITEM) then
    local var = bomb.Variant
    if mod:isReplaceableBombVariant(var) then
        if mod:isCopperVariant(var) then
            bomb.Variant = mod.BOMB.SHUFFLE_COPPER
            bomb.Flags = bomb.Flags
        else
            bomb.Variant = mod.BOMB.SHUFFLE
            bomb.Flags = bomb.Flags
        end
    end
	--end
end
mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_SET_BOMB_VARIANT, FiendFolio.ITEM.COLLECTIBLE.SHUFFLE_BOMBS, mod.shuffleBombsVariant)

mod:AddCallback(ModCallbacks.MC_POST_BOMB_INIT, function(_, bomb)
    mod.scheduleForUpdate(function()
        if bomb.Variant == mod.BOMB.SHUFFLE or bomb.Variant == mod.BOMB.SHUFFLE_COPPER then
            local shuffleRNG = (bomb.InitSeed % 8) + 1
            local offset = Anm2RandomOffsets[shuffleRNG]
            local sprite = bomb:GetSprite()
            sprite:GetLayer(1):SetCropOffset(Vector(offset.Middle, 0))
            sprite:GetLayer(4):SetCropOffset(Vector(offset.Middle, 0))
            sprite:GetLayer(2):SetCropOffset(Vector(offset.Top, 0))
            sprite:GetLayer(5):SetCropOffset(Vector(offset.Top, 0))
            sprite:GetLayer(6):SetCropOffset(Vector(offset.Top, 0))
            if bomb.Variant == mod.BOMB.SHUFFLE_COPPER then
                sprite:GetLayer(8):SetCropOffset(Vector(offset.Middle, 0))
                sprite:GetLayer(11):SetCropOffset(Vector(offset.Middle, 0))
                sprite:GetLayer(9):SetCropOffset(Vector(offset.Top, 0))
                sprite:GetLayer(12):SetCropOffset(Vector(offset.Top, 0))
            end
            if not (bomb:HasTearFlags(TearFlags.TEAR_GOLDEN_BOMB) or bomb.Variant == mod.BOMB.SHUFFLE_COPPER) then
                local saveData
                if bomb.SpawnerEntity.Type == EntityType.ENTITY_PLAYER then
                    saveData = mod:GetEntityData(bomb.SpawnerEntity).ffsavedata
                    if saveData and saveData.ChaosBombEffects then
                        saveData = saveData.ChaosBombEffects
                        local colorOrder = ({ {1, 2, 3}, {1, 3, 2}, {2, 1, 3}, {2, 3, 1}, {3, 1, 2}, {3, 2, 1} })[(bomb.InitSeed % 6) + 1]      -- lmao
                        for i, c in ipairs(colorOrder) do
                            sprite:GetLayer(2 + i):SetColor(FLAG_COLORS[saveData[c]])
                        end
                    end
                end
            end
        end
    end, 0, ModCallbacks.MC_POST_RENDER)
end)


---@param bomb EntityBomb
function ChaosBombs:TriggerPassiveBomb(bomb, player, force)
	local frame = game:GetFrameCount()
	local bombdata = mod:GetEntityData(bomb)
	if not force and bombdata.lastFrameChaosBombPassive == frame then return end

	local player = player
    for flag, func in pairs(ON_PASSIVE) do
		if TearFlagsLib.HasTearFlags(bomb, flag) then
			player = player or (bomb.SpawnerEntity and bomb.SpawnerEntity:ToPlayer())
            ON_PASSIVE[flag](self, player, bomb)
        end
    end
	
	bombdata.lastFrameChaosBombPassive = frame
end

mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, ChaosBombs.TriggerPassiveBomb)