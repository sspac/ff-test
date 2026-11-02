local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local function updateActiveReceptor(friendCheck, npc)
    local closest
    if npc then
        closest = {npc, 99999}
    elseif friendCheck then
        closest = {mod.mainReceptorFriend, 99999}
    else
        closest = {mod.mainReceptor, 99999}
    end
    for _, receptor in pairs(Isaac.FindByType(mod.FF.Receptor.ID, mod.FF.Receptor.Var, -1)) do
        if (friendCheck and mod:isFriend(receptor)) or ((not friendCheck) and (not mod:isFriend(receptor))) then
            receptor = receptor:ToNPC()
            local targ = receptor:GetPlayerTarget()
            if receptor.Pathfinder:HasPathToPos(targ.Position, false) then
                local dist = targ.Position:Distance(receptor.Position)
                if dist < closest[2] then
                    closest = {receptor, dist}
                end
            end
        end
    end
    local new
    if friendCheck then
        if (not mod.mainReceptorFriend) or (mod.mainReceptorFriend and mod.mainReceptorFriend.InitSeed ~= closest[1].InitSeed) then
            new = true
        end
        mod.mainReceptorFriend = closest[1]
    else
        if (not mod.mainReceptor) or (mod.mainReceptor and mod.mainReceptor.InitSeed ~= closest[1].InitSeed) then
            new = true
        end
        mod.mainReceptor = closest[1]
    end
    if new then
        sfx:Play(mod.Sounds.FrayedAlert, 0.1, 0, false, mod:RandomInt(120,150)/100)
        sfx:Play(mod.Sounds.DevilDaggerGemCollect, 0.3, 0, false, mod:RandomInt(150,250)/100)
        sfx:Play(mod.Sounds.Foresee, 0.3, 0, false, mod:RandomInt(200,300)/100)
        local flash = Isaac.Spawn(1000, 1960, 20, closest[1].Position, Vector.Zero, closest[1]):ToEffect()
        flash:FollowParent(closest[1])
        flash.SpriteScale = flash.SpriteScale * 0.075
        flash.SpriteOffset = Vector(0, -20)
        flash.Color = Color(179/255,0,0,1)
        flash.DepthOffset = 100
        for i = 1, 5 do
            flash:Update()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function(_)
    mod.mainReceptor = nil
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if mod.mainReceptor or mod.mainReceptorFriend then
        local room = game:GetRoom()
        if room:GetFrameCount() % 10 == 0 then
            if mod.mainReceptor then
                updateActiveReceptor()
            end
            if mod.mainReceptorFriend then
                updateActiveReceptor(true)
            end
        end
    end
end)

function mod:receptorUpdate(npc)
	local sprite = npc:GetSprite()
	local path = npc.Pathfinder
	local d = mod:GetEntityData(npc)
	local target = npc:GetPlayerTarget()
	local targetpos = mod:randomConfuse(npc, target.Position)
	local r = npc:GetDropRNG()

    if not d.init then
		sprite:SetFrame("WalkVert", 0)
        sprite:PlayOverlay("HeadIdle")
		d.init = true
	elseif d.init then
		npc.StateFrame = npc.StateFrame + 1
	end

    if npc.FrameCount < 1 then return end

    if (not mod.mainReceptor) or mod.mainReceptor and not mod.mainReceptor:Exists() then
        updateActiveReceptor(mod:isFriend(npc), npc)
    end

    local checker = mod.mainReceptor
    if mod:isFriend(npc) then
        checker = mod.mainReceptorFriend
    end

    if checker then
        if checker.InitSeed == npc.InitSeed then
            sprite:PlayOverlay("HeadActive")
            if mod:isScare(npc) then
                local targetvel = (targetpos - npc.Position):Resized(-5)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvel,0.25)
            elseif game:GetRoom():CheckLine(npc.Position,targetpos,0,1,false,false) then
                local targetvel = (targetpos - npc.Position):Resized(4)
                npc.Velocity = mod:Lerp(npc.Velocity, targetvel,0.25)
            else
                path:FindGridPath(targetpos, 0.6, 900, true)
            end
        else
            sprite:PlayOverlay("HeadIdle")
            local lerpVal = 0.75
            if npc:CollidesWithGrid() then
                lerpVal = 0.25
            end
            npc.Velocity = mod:Lerp(npc.Velocity, checker.Velocity, lerpVal)
        end
    else
        npc.Velocity = npc.Velocity * 0.9
    end

    if npc.Velocity:Length() > 0.1 then
		npc:AnimWalkFrame("WalkHori","WalkVert",0)
	else
		sprite:SetFrame("WalkVert", 0)
	end
end