local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local dictGrabber = nil
local function newRoom()
    local level = game:GetLevel()
    dictGrabber = level:GetCurrentRoomDesc().SafeGridIndex
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, newRoom)
local function playerUpdate(_, player)
    if player:HasCollectible(mod.ITEM.COLLECTIBLE.MINESWEEPER) then
        mod.savedata.run = mod.savedata.run or {}
        mod.savedata.run.sweeperRooms = mod.savedata.run.sweeperRooms or {}

        if dictGrabber == nil then
            newRoom()
        end
        local t = mod.savedata.run.sweeperRooms[dictGrabber] or {}

        local room = game:GetRoom()
        local gindex = room:GetClampedGridIndex(player.Position+player.Velocity)
        local grid = room:GetGridEntity(gindex)
        if not grid or (grid:GetType() == GridEntityType.GRID_DECORATION or grid:GetType() == GridEntityType.GRID_SPIDERWEB) then
            if t[""..gindex] == nil then
                t[""..gindex] = true

                local rng = player:GetCollectibleRNG(mod.ITEM.COLLECTIBLE.MINESWEEPER)
                local flag = false
                local pos = room:GetGridPosition(gindex)
                if rng:RandomFloat() < 0.16 then
                    flag = true
                    
                    --sourced a bit from anarchist's easy bake because i DONT understand the bomb flag source stuff. That's okay. Thank you Taiga
		            local troll = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_TROLL, 0, pos, Vector.Zero, player):ToBomb()
                    local flags = player:GetBombFlags()
		            troll:AddTearFlags(flags)
                    troll:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)

		            local b_data = mod:GetEntityData(troll)
		            b_data.ffOverrideBombFlagSource = mod.BombFlagSource.ANARCHISTS_EASY_BAKE
                    Isaac.RunCallbackWithParam(FiendFolio.CALLBACK.FF_POLL_BOMBFLAGS, nil, troll, player, mod.BombFlagSource.MINESWEEPER)
                    b_data.HasPolledBombFlags = true
                end

                sfx:Play(SoundEffect.SOUND_BUTTON_PRESS, 0.4)
                local p = mod:beahPoof(pos, 6, Color(1,1,1,0.4))
                p.DepthOffset = -999
                if flag then
                    local s = p:GetSprite()
                    s:Play("Flag", true)
                end

                player:AddCollectibleEffect(mod.ITEM.COLLECTIBLE.MINESWEEPER)
            end
        end
        mod.savedata.run.sweeperRooms[dictGrabber] = t
    end
end
mod:AddCollectibleCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ITEM.COLLECTIBLE.MINESWEEPER, playerUpdate)

local poofDuration = 18
local function popupUpdate(_, effect)
    if effect.SubType ~= mod.FF.Minesweeper.Sub then
        return
    end
    local c = Color.Lerp(Color(1,1,1,0),Color(1,1,1,0.4), 1-((effect.FrameCount/poofDuration)^0.66))
    effect.Color = c
    if effect.FrameCount >= poofDuration then
        effect:Remove()
    end
end
mod:AddEntityCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.FF.Minesweeper.ID, mod.FF.Minesweeper.Var, mod.FF.Minesweeper.Sub, popupUpdate, mod.FF.Minesweeper.Var)