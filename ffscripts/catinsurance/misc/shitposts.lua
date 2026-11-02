local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local function getRoomName()
    local roomDescriptorData = game:GetLevel():GetCurrentRoomDesc().Data
    local text = ""

    local cacophobia = Isaac.FindByType(mod.FF.CacophobiaVenus.ID, mod.FF.CacophobiaVenus.Var)[1]

    if cacophobia and mod:GetEntityData(cacophobia).Pattern then
        text = mod:GetEntityData(cacophobia).Pattern.PatternName
    else
        local currentRoom = StageAPI.GetCurrentRoom()
        if currentRoom and currentRoom.Layout then
            text = text .. tostring(currentRoom.Layout.Variant) .. " " .. currentRoom.Layout.Name
        else
            local useVar = roomDescriptorData.Variant
            if useVar >= 17000 and useVar <= 21000 then
                useVar = useVar - 17000
                text = "(FF) "
            end

            text = text .. tostring(useVar) .. " " .. roomDescriptorData.Name
        end
    end

    return text
end

local oldLevel
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function ()
    if mod.ShowRoomNames ~= 5 then
        return
    end

    local room = game:GetRoom()
    if oldLevel ~= game:GetLevel():GetAbsoluteStage() then
        if game:GetLevel():GetStartingRoomIndex() == game:GetLevel():GetCurrentRoomIndex() then
            oldLevel = game:GetLevel():GetAbsoluteStage()
            Isaac.CreateTimer(function ()

                sfx:Play(mod.Sounds.WoahNewFloor, 1.3)
            end, 30, 1, true)
            sfx:Play(mod.Sounds.WoahJingle, 0.7)
            game:GetHUD():ShowItemText("A new floor!", "\"" .. game:GetLevel():GetName() .. "\"", false)
        end
        return
    end

    oldLevel = game:GetLevel():GetAbsoluteStage()

    if room:GetFrameCount() == 2 and room:IsFirstVisit() and game:GetLevel():GetStartingRoomIndex() ~= game:GetLevel():GetCurrentRoomIndex() then
        Isaac.CreateTimer(function ()
            sfx:Play(mod.Sounds.WoahNewRoom, 1.3)
        end, 30, 1, true)
        sfx:Play(mod.Sounds.WoahJingle, 0.7)
        game:GetHUD():ShowItemText("A new room!", "\"" .. getRoomName() .. "\"", false)
    end
end)

mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function ()
    oldLevel = nil
end)