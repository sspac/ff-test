local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

--[[local beamSprite = Sprite()
beamSprite:Load("gfx/effect_wnic_connector.anm2", true)
beamSprite:Play("Idle", false)

local beamLayer = beamSprite:GetLayer("beam")
beamLayer:SetWrapSMode(1)
beamLayer:SetWrapTMode(0)
local snapBeam = Beam(beamSprite, "beam", false, false)]]

function mod:createMan(player)
    local minisaac = player:AddMinisaac(player.Position, false)
    mod.scheduleForUpdate(function ()
        local sprite = minisaac:GetSprite()
        for i = 1, 2, 1 do
            sprite:ReplaceSpritesheet(i-1, "gfx/familiar/creationofman/adamsheet.png")
        end
        sprite:LoadGraphics()
    end, 0)

    local iseed = minisaac.InitSeed
    local runData = mod:GetEntityData(player).ffsavedata.RunEffects
    runData.creationedMen = runData.creationedMen or {}
    runData.creationedMen[""..iseed] = true


    local others = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.MINISAAC)
    for index, value in ipairs(others) do
        value.HitPoints = value.MaxHitPoints
    end
end

function mod:CreationEnterNewRoom(player)
    if not player:HasCollectible(mod.ITEM.COLLECTIBLE.CREATION_OF_MAN) then
        return
    end
    local room = game:GetRoom()

    local rtype = room:GetType()
    local firstVisit = room:IsFirstVisit() --hoping stageapi doesnt override this
    if rtype == RoomType.ROOM_BOSS and firstVisit then
        mod:createMan(player)
    end
end

mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_PLAYER_POST_START_GREED_WAVE, mod.ITEM.COLLECTIBLE.CREATION_OF_MAN, function(_, player, data, waveNumber, isBossWave)
    if not player:HasCollectible(mod.ITEM.COLLECTIBLE.CREATION_OF_MAN) then
        return
    end
    if isBossWave
    and waveNumber == game:GetGreedBossWaveNum() --Only called on the first boss
    then
        mod:createMan(player)
    end
end)

local function preDMG(_, ent, amount, flags, source, dmgCooldown)
    local p = ent:ToPlayer()
    if not p then
        --[[while true do
            Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ROGUE_PLANET, 0, Vector.Zero, Vector.Zero, nil)
        end]]
        return
    end
    if not p:IsInvincible() and not p:HasInvincibility() and p:GetDamageCooldown() == 0 then
        local tab = mod:GetEntityData(p).ffsavedata.RunEffects.creationedMen
        if not tab then
            return
        end
        --Maus door check I guess?
        if mod:damageIsMausDoor(flags, source) then
            return
        end
        local minisaac = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.MINISAAC)
        for index, value in ipairs(minisaac) do
            local iseed = ""..value.InitSeed
            if tab[iseed] then
                --spawning bishop shield
                local shield = Isaac.Spawn(EntityType.ENTITY_EFFECT, 160, 0, p.Position, Vector.Zero, value)
                shield.Parent = value
                shield.Target = p

                sfx:Play(SoundEffect.SOUND_BISHOP_HIT)
                --[[local render = {
                    start = player.Position,
                    goal = minisaac.Position,
                    duration = beamVisDuration
                }]]
                local fatal = value:TakeDamage(1, flags, source, 0)
                p:SetMinDamageCooldown(fatal and 60 or 15)

                --jank from hell (that i dont need,?)
                --[[local renderqueen = mod.initLoopController()
                local e_data = mod:GetEntityData(renderqueen)

                e_data.creationofmen = e_data.creationofmen or {}
                table.insert(e_data.creationofmen, render)]]

                return false
            end
        end
    end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, CallbackPriority.LATE, preDMG)

local function minisaacDie(_, familiar)
    if familiar.Variant ~= FamiliarVariant.MINISAAC then
        return
    end
    --hp check before doing important stuff, incase this gets called on game exit
    if familiar.HitPoints <= 0 then
        local p = familiar.Player
        if p then
            local runData = mod:GetEntityData(p).ffsavedata.RunEffects
            if runData.creationedMen then
                runData.creationedMen[""..familiar.InitSeed] = nil
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, minisaacDie, EntityType.ENTITY_FAMILIAR)

--called from wnic.lua
--this is not gold status worthy code, sorry
--[[local oset = Vector(0, -8)
function mod.creationOfManRender(effect, e_data)
    if e_data.creationofmen then
        for index, value in ipairs(e_data.creationofmen) do
            snapBeam:Add(Isaac.WorldToScreen(value.start+oset), 1)
            snapBeam:Add(Isaac.WorldToScreen(value.goal), 1)
            snapBeam:Render()
        end
    end
end

--add an effect update also
local function eUpdate()

end
mod:AddEntityCallback()]]