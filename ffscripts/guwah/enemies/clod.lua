local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local bal = {
    moveSpeed = 3.5,
    clodEnterChance = 0.5,
    posOffset = 2,
    baseOffset = -20,
}

mod.ClodWormData = {
    [EntityType.ENTITY_ROUND_WORM.." "..0] = {"gfx/monsters/rebirth/monster_244_roundworm", 1, bal.baseOffset}, --Round Worm
    [EntityType.ENTITY_ROUND_WORM.." "..1] = {"gfx/monsters/afterbirthplus/tubeworm", 1, bal.baseOffset}, --Tube Worm
    [EntityType.ENTITY_ROUND_WORM.." "..2] = {"gfx/monsters/repentance/ultra/round_worm_dirt", 1, -18}, --Tainted Round Worm
    [EntityType.ENTITY_ROUND_WORM.." "..3] = {"gfx/monsters/repentance/ultra/tube_worm", 1, bal.baseOffset}, --Tainted Tube Worm
    [EntityType.ENTITY_ROUND_WORM.." "..1873] = {"gfx/monsters/retribution/monster_pinhead", 1, bal.baseOffset}, --Pinhead
    [EntityType.ENTITY_NIGHT_CRAWLER.." "..0] = {"gfx/monsters/rebirth/monster_255_nightcrawler", 1, bal.baseOffset}, --Nightcrawler
    [EntityType.ENTITY_NIGHT_CRAWLER.." "..1873] = {"gfx/monsters/retribution/monster_pinprick", 1, bal.baseOffset}, --Pinprick
    [mod.FF.BoneWorm.ID.." "..mod.FF.BoneWorm.Var] = {"gfx/enemies/boneworm/boneworm", 1, bal.baseOffset}, --Bone Worm
    [mod.FF.DrinkWorm.ID.." "..mod.FF.DrinkWorm.Var] = {"gfx/enemies/drinkworm/drink_worm", 1, bal.baseOffset}, --Drink Worm
    [mod.FF.DrunkWorm.ID.." "..mod.FF.DrunkWorm.Var] = {"gfx/enemies/drunkworm/drunkworm", 1, bal.baseOffset}, --Drunk Worm
}

function mod:AddClodWormData(t, v, sheet, dirtLayer, offset, dieIfClodDies)
    mod.ClodWormData[t.." "..v] = {sheet, dirtLayer or 1, offset or bal.baseOffset, dieIfClodDies}
end

local function LoadDirtSheet(npc, sprite)
    local entry = mod.ClodWormData[npc.Type.." "..npc.Variant]
    if entry then
        if entry[1] and entry[2] then
            mod:ReplaceEnemySpritesheet(npc, entry[1], entry[2])
        end
        npc.SpriteOffset = Vector.Zero
    end
end

local function UnloadDirtSheet(npc, sprite, offfsetScale)
    offfsetScale = offfsetScale or 1
    local entry = mod.ClodWormData[npc.Type.." "..npc.Variant]
    if entry then
        if entry[1] and entry[2] then
            mod:ReplaceEnemySpritesheet(npc, "gfx/nothing", entry[2])
        end
        npc.SpriteOffset = Vector(0, (entry[3] * offfsetScale) - bal.posOffset)
    end
end

local function HandleWormCollision(npc, data)
    if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_NONE then
        data.ClodRestoreColl = npc.EntityCollisionClass 
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    end
end

function mod:EnterClod(npc, sprite, data, clod)
    HandleWormCollision(npc, data)
    mod:GetEntityData(clod).WormClaimed = true
    clod.Child = npc
    data.ClodParent = clod
    UnloadDirtSheet(npc, sprite, clod:ToNPC().Scale)
end

function mod:ExitClod(npc, sprite, data)
    if data.ClodRestoreColl then
        npc.EntityCollisionClass = data.ClodRestoreColl
        data.ClodRestoreColl = nil
    end
    if data.ClodParent and data.ClodParent:Exists() then
        mod:GetEntityData(data.ClodParent).WormClaimed = false
    end
    data.ClodParent = nil
    LoadDirtSheet(npc, sprite)
end

function mod:TryEnterClod(npc, sprite, data, filter)
    local clod 
    filter = filter or function(ent) return not mod:GetEntityData(ent).WormClaimed end
    if npc:GetDropRNG():RandomFloat() <= bal.clodEnterChance then
        clod = mod:GetRandomThing(mod.FF.Clod.ID,mod.FF.Clod.Var,-1,filter)
    end
    if data.ClodParent then
        mod:ExitClod(npc, sprite, data)
    end
    if clod then
        mod:EnterClod(npc, sprite, data, clod)
        return true
    end
end

function mod:ClodAI(npc, sprite, data)
    local rng = npc:GetDropRNG()
    if not data.Init then
        npc.SplatColor = mod.ColorPoop
        data.Init = true
    end
    if npc.Velocity:Length() >= 0.1 then
        mod:SpritePlay(sprite, "Move")
    else
        mod:SpritePlay(sprite, "Idle")
    end
    mod:ChasePlayer(npc, bal.moveSpeed)
    if npc.FrameCount > 0 and rng:RandomFloat() <= 0.025 then
        local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, npc.Position + (RandomVector() * mod:RandomInt(0,15,rng)), Vector.Zero, npc):ToEffect()
        splat.Color = npc.SplatColor
        splat.Scale = mod:RandomInt(30,75,rng) * 0.01
        splat:Update()
    end
    if data.WormClaimed and not (npc.Child and not mod:isStatusCorpse(npc.Child)) then
        data.WormClaimed = false
    end
end

function mod:ClodColl(npc, collider)
    if mod.ClodWormData[collider.Type.." "..collider.Variant] then
        return true
    end 
end

function mod:RoundWormClodLogic(npc)
    if mod.ClodWormData[npc.Type.." "..npc.Variant] then
        local sprite = npc:GetSprite()
        local data = mod:GetEntityData(npc)
        
        if npc.State == 4 then
            mod:TryEnterClod(npc, sprite, data)
        end
        mod:InsideClodUpdate(npc, sprite, data)
    end
end

function mod:InsideClodUpdate(npc, sprite, data)
    if data.ClodParent then
        if mod:IsReallyDead(data.ClodParent) then
            mod:ExitClod(npc, sprite, data)
            local entry = mod.ClodWormData[npc.Type.." "..npc.Variant]
            if entry and entry[4] then
                npc:Kill()
            end
        else
            HandleWormCollision(npc, data)

            npc.TargetPosition = data.ClodParent.Position + Vector(0,bal.posOffset)
            npc.Velocity = npc.TargetPosition - npc.Position
            if npc.Index < data.ClodParent.Index then
                npc.Velocity = npc.Velocity + data.ClodParent.Velocity
            end
            return true
        end
    end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.RoundWormClodLogic, EntityType.ENTITY_ROUND_WORM)
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.RoundWormClodLogic, EntityType.ENTITY_NIGHT_CRAWLER)