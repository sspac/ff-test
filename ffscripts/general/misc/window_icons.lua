local mod = FiendFolio

local WindowIcons = {
    FIEND = "gfx/icon_fiend.ico",
    BIEND = "gfx/icon_biend.ico",
}

function mod:IsFFPlayerType(playerType)
    for _, player in pairs(mod.PLAYER) do
        if playerType == player then
            return true
        end
    end

    return false
end

local wasFFCharacter = false
local oldPlayerType, oldCharacterMenuState
function mod:UpdateWindowIcon(playerType)
    if not mod:IsFFPlayerType(playerType) then
        if wasFFCharacter then
            if MenuManager.GetActiveMenu() == MainMenuType.CHARACTER then
                local selected = CharacterMenu.GetSelectedCharacterMenu()
                if selected == 1 then
                    Isaac.SetIcon(1)
                else
                    Isaac.SetIcon(0)
                end
            else
                Isaac.SetIcon(0)
            end

            wasFFCharacter = false
        end

        oldPlayerType = nil
        oldCharacterMenuState = nil
        return
    end

    wasFFCharacter = true

    if MenuManager.GetActiveMenu() == MainMenuType.CHARACTER and (playerType ~= oldPlayerType or CharacterMenu.GetSelectedCharacterMenu() ~= oldCharacterMenuState) then
        local selected = CharacterMenu.GetSelectedCharacterMenu()
        if selected == 1 then
            Isaac.SetIcon(WindowIcons.BIEND)
        else
            Isaac.SetIcon(WindowIcons.FIEND)
        end

        oldPlayerType = playerType
        oldCharacterMenuState = nil
    end
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER_CHARACTER_SELECT_PAGE, mod.UpdateWindowIcon)

function mod:UpdateWindowIconInGame(player)
    local playerType = player:GetPlayerType()
    if mod:IsFFPlayerType(playerType) then
        local info = EntityConfig.GetPlayer(playerType)
        if info then
            if info:IsTainted() then
                Isaac.SetIcon(WindowIcons.BIEND)
            else
                Isaac.SetIcon(WindowIcons.FIEND)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PLAYER_INIT_POST_LEVEL_INIT_STATS, mod.UpdateWindowIconInGame)