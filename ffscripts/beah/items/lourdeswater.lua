local mod = FiendFolio
local game = Game()

local directory = "gfx/grid/grid_lourdeswaterangelstatue.anm2"
local directions = {
    [0] = Vector(-1, 0),
    [1] = Vector(0, -1),
    [2] = Vector(1, 0),
    [3] = Vector(0, 1)
}

local otherRockSprites = {
    [-1] = { -- left
        [0] = -1,
        [5] = 3,
        [6] = 3,
    },
    [1] = {
        [1] = -1,
        [5] = 3,
        [7] = 3,
    }, -- right
    [-13] = {
        [2] = -1,
        [4] = 0,
        [5] = 0,
    }, --up
    [13] = {
        [3] = -1,
        [6] = 0,
        [7] = 0,
    }, --down
} 
--from TT, thanks JD sorry JD
--surely FF implements its own version of this? need to look
local adjindexes = {
	[DoorSlot.LEFT0] = -1, 
	[DoorSlot.UP0] = -13, 
	[DoorSlot.RIGHT0] = 1, 
	[DoorSlot.DOWN0] = 13
}

local function NewRoomLogic()
    local level = game:GetLevel()
    local room = game:GetRoom()
    mod.savedata.run = mod.savedata.run or {}
    mod.savedata.run.CoE_rooms = mod.savedata.run.CoE_rooms or {}

    local currRoom = level:GetCurrentRoomDesc ()
    local idx = level:GetCurrentRoomDesc().SafeGridIndex
    if level:GetStartingRoomIndex() == idx
    and currRoom.VisitedCount == 1 then
        mod.savedata.run.CoE_rooms = {}
    end
    if not mod.savedata.run.CoE_rooms[idx] then
        local newData = {}
        
        local stacks = PlayerManager.GetNumCollectibles(mod.ITEM.COLLECTIBLE.LOURDES_WATER)
        local rocks = {}
        for i = 0, room:GetGridSize(), 1 do
            local g = room:GetGridEntity(i)
            if g and g:GetType() == GridEntityType.GRID_ROCK then
                local emptyAdjacent = false
                for ii = 0, 3, 1 do
                    local o_idx = i + adjindexes[ii]
                    if math.abs(adjindexes[ii]) == 13 then
                        o_idx = i + room:GetGridWidth()
                    end
                    local o_g = room:GetGridEntity(o_idx)
                    if room:IsPositionInRoom(room:GetGridPosition(i) + (Vector(40, 40)*directions[ii]), 32) and (not o_g
                    or o_g:GetType() == GridEntityType.GRID_PIT) then
                        emptyAdjacent = true
                    end
                end
                if emptyAdjacent then
                    table.insert(rocks, i)
                end
            end
        end
        mod:Shuffle(rocks)
        for i = 1, stacks, 1 do
            if rocks[i] then
                table.insert(newData, rocks[i])
            end
        end

        mod.savedata.run.CoE_rooms[idx] = newData
    end
    local rCoEdata = mod.savedata.run.CoE_rooms[idx]
    for _, rockIdx in ipairs(rCoEdata) do
        local rock = room:GetGridEntity(rockIdx)
        if not rock or rock.State ~= 1 then
            return
        end

        local sprite = rock:GetSprite()
        rock:GetSprite():Load(directory, true)
        sprite:Play("idle", true)
        sprite:Update()

        for i = 0, 3, 1 do
            local key = adjindexes[i]
            local o_idx = rockIdx + key
            if math.abs(key) == 13 then
                o_idx = rockIdx + room:GetGridWidth()
            end

            local adjRock = room:GetGridEntity(o_idx)
            if adjRock then
                local o_sprite = adjRock:GetSprite()
                if o_sprite:GetAnimation()  =="big" then
                    local newFrame = otherRockSprites[key][o_sprite:GetFrame()]
                    if newFrame then
                        if newFrame == -1 then
                            o_sprite:Play("normal", true)
                        else
                            o_sprite:SetFrame(newFrame)
                        end

                        o_sprite:Update()
                        adjRock:Update()
                    end
                end
            end
        end

        local circle = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.BeahInvisible.Var, 1, rock.Position, Vector.Zero, nil)
        local c_data = mod:GetEntityData(circle)
        c_data.somethingWicked_edithparentRock = rock

        local c_sprite = circle:GetSprite()
        c_sprite:Play("Appear")
    end
end

local radius = 100
local cooldown = 30
local function EffectUpdate(_, effect)
    if effect.SubType ~= 1 then
        return
    end
    local e_sprite = effect:GetSprite()
    local e_data = mod:GetEntityData(effect)
    e_data.sw_standaloneAura = e_data.sw_standaloneAura or (effect.Parent ~= nil and not e_data.somethingWicked_edithparentRock)
    local standalone = e_data.sw_standaloneAura
    local rock = e_data.somethingWicked_edithparentRock
    if (standalone and effect.Parent and effect.Parent:Exists()) or (rock and rock.State == 1) then
        --[[e_data.sw_CoEattackCooldown = e_data.sw_CoEattackCooldown or 0
        if e_data.sw_CoEattackCooldown <= 0 then
            local level = game:GetLevel()
            local stage = level:GetAbsoluteStage()

            local enemies = Isaac.FindInRadius(effect.Position, radius, EntityPartition.ENEMY)
            for _, ent in ipairs(enemies) do
                if ent.Type ~= EntityType.ENTITY_BOMB then
                    if not ent:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) then
                        local veloc = ent.Position - effect.Position
                        veloc = veloc:Normalized():Resized(20)

                        ent:AddEntityFlags(EntityFlag.FLAG_KNOCKED_BACK)
                        ent:AddVelocity(veloc)
                    end

                    ent:TakeDamage(10 + 2 * (stage - 1), 0, EntityRef(effect), 1)
                    ent:SetColor(Color(1, 1, 1, 1, 0.5, 0.5, 0.5), math.floor(cooldown*0.6666), 1, true, false)
                    e_data.sw_CoEattackCooldown = cooldown
                end
            end
        else
            e_data.sw_CoEattackCooldown = e_data.sw_CoEattackCooldown - 1
        end]]

        local players = Isaac.FindInRadius(effect.Position, radius, EntityPartition.PLAYER)
        for _, player in ipairs(players) do
            player = player:ToPlayer()
            player:SetHallowedGroundCountdown(2)
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_TEARFLAG | CacheFlag.CACHE_TEARCOLOR, true)
        end

        if not standalone then            
            local rHelper = e_data.sw_renderHelper
            if e_data.sw_renderHelper == nil then
                e_data.sw_renderHelper = Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.FF.BeahInvisible.Var, 0, effect.Position, Vector.Zero, effect)
                rHelper = e_data.sw_renderHelper
                rHelper.Parent = effect
                local sprite = rHelper:GetSprite()
                sprite:Load(directory, true)
                sprite:ReplaceSpritesheet(0, "blank.png") --blank spritesheet
                sprite:LoadGraphics()
                sprite:Play("idle", true)
            end
        else
            effect.Position = effect.Parent.Position
            effect.Velocity = effect.Parent.Velocity
        end

        if e_sprite:IsFinished("Appear") then
            e_sprite:Play("Idle")
        end
    else
        e_sprite:Play("Disappear")
        if e_sprite:IsFinished("Disappear") then
            effect:Remove()
        end
        
        if e_data.sw_renderHelper then
            e_data.sw_renderHelper:Remove()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, NewRoomLogic)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, EffectUpdate, mod.FF.BeahInvisible.Var)