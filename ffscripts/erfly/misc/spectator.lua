local mod = FiendFolio
local game = Game()

local EscapeValX = 125
local EscapeValY = 100
local RandomOffset = 100
local fadeVal = 0.05

mod:AddPriorityCallback(ModCallbacks.MC_POST_RENDER, -500, function()
    mod.scheduleForUpdate(function()
        if mod.SpectatorTracking then
            local room = game:GetRoom()
            if mod.WaterRenderModes[room:GetRenderMode()] then return end
            if type(mod.SpectatorTracking) == "boolean" then
                mod.SpectatorTracking = {}
                local topLeft = room:GetTopLeftPos()
                topLeft = Vector(math.min(60, topLeft.X), math.min(140, topLeft.Y))
                local botRight = room:GetBottomRightPos()
                botRight = Vector(math.max(580, botRight.X), math.max(420, botRight.Y))
                local VecX, VecY
                if math.random(2) == 1 then
                    VecY = topLeft.Y - RandomOffset + math.random(math.ceil(math.abs(topLeft.Y - botRight.Y) + (RandomOffset * 2)))
                    if math.random(2) == 1 then
                        VecX = topLeft.X - EscapeValX - math.random(RandomOffset)
                    else
                        VecX = botRight.X + EscapeValX + math.random(RandomOffset)
                    end
                else
                    VecX = topLeft.X - RandomOffset + math.random(math.ceil(math.abs(topLeft.X - botRight.X) + (RandomOffset * 2)))
                    if math.random(2) == 1 then
                        VecY = topLeft.Y - EscapeValY - math.random(RandomOffset)
                    else
                        VecY = botRight.Y + EscapeValY + math.random(RandomOffset)
                    end
                end
                mod.SpectatorTracking.Pos = Vector(VecX, VecY)
            end
            local eyeSprite = Sprite()
            eyeSprite:Load(FiendFolio.SpecRender, true)
            local usedFadeVal = FiendFolio.OVERRIDEFADEVAL or fadeVal
            local visualVal = math.min(room:GetFrameCount()/100, usedFadeVal)
            eyeSprite.Color = Color(visualVal,visualVal,visualVal,1)

            local screenPos = room:WorldToScreenPosition(mod.SpectatorTracking.Pos)

            eyeSprite:SetFrame("Base", 0)
            eyeSprite:Render(screenPos)

            local PupilOffset = (Isaac.GetPlayer().Position - mod.SpectatorTracking.Pos):Resized(2)
            eyeSprite:SetFrame("Pupil", 0)
            eyeSprite:Render(screenPos + PupilOffset)

            if mod.SpectatorTracking.BlinkT then
                mod.SpectatorTracking.BlinkT = mod.SpectatorTracking.BlinkT + 1
                if mod.SpectatorTracking.BlinkT >= 50 then
                    mod.SpectatorTracking.BlinkT = nil
                end
            else
                if math.random(200) == 1 then
                    mod.SpectatorTracking.BlinkT = 1
                end
            end

            if mod.SpectatorTracking.BlinkT then
                eyeSprite:SetFrame("Blink", math.floor(mod.SpectatorTracking.BlinkT / 2))
            else
                eyeSprite:SetFrame("Idle", math.floor((Isaac.GetTime() / 32)) % 20)
            end
            eyeSprite:Render(screenPos)
        end
    end, 1, ModCallbacks.MC_POST_GRID_ENTITY_WALL_RENDER)
end)

--[[local blacklist = {
    {LevelStage.STAGE1_1, LevelStage.STAGE1_2, StageType.STAGETYPE_AFTERBIRTH}, --B. Basement
    {LevelStage.STAGE2_1, LevelStage.STAGE2_2, StageType.STAGETYPE_AFTERBIRTH}, --F. Caves
    {LevelStage.STAGE4_1, LevelStage.STAGE4_2, StageType.STAGETYPE_ORIGINAL}, --Womb
    {LevelStage.STAGE4_1, LevelStage.STAGE4_2, StageType.STAGETYPE_WOTL}, --Utero
}]]

mod:AddPriorityCallback(ModCallbacks.MC_POST_NEW_ROOM, -6, function()
    mod.SpectatorTracking = nil
	if (math.random(10000) == 1)
    or (mod:entityValidationTechniqueFour() and math.random(100) == 1)
    then
        local anyPlayerWithAdblocker = mod.anyPlayerHas(mod.ITEM.TRINKET.ADBLOCKER, true, nil, nil, true)
        if anyPlayerWithAdblocker then
            FiendFolio.scheduleForUpdate(function()
                mod:adBlocked()
            end, 1, nil, true)
        else
            if not mod.anyPlayerHas(CollectibleType.COLLECTIBLE_EVIL_CHARM) then
                mod.SpectatorTracking = true
            end
        end
    end
end)