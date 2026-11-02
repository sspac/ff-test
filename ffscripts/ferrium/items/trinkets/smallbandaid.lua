local mod = FiendFolio
local sfx = SFXManager()

function mod:SmallBandaidRoomClear(player, d)
    if player:HasTrinket(mod.ITEM.TRINKET.SMALL_BANDAID) then
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.SMALL_BANDAID)
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.SMALL_BANDAID)
        if rng:RandomInt(100) < 25*mult then
            local order = CustomHealthAPI.Library.GetHealthInOrder(player, false)
            local convert
            for i=1,#order do
                local heartEntry = order[i]
                for heartType,typeEntry in pairs(heartEntry) do
                    if type(typeEntry) == "table" then
                        local max = CustomHealthAPI.Library.GetInfoOfKey(typeEntry.Key, "MaxHP")
                        if not convert and typeEntry.HP and typeEntry.HP < max and typeEntry.HP > 0 then
                            convert = true
                            CustomHealthAPI.Library.AddHealth(player, typeEntry.Key, 1, true)
                            sfx:Play(SoundEffect.SOUND_VAMP_GULP, 0.6, 0, false, 1)
                            local poof = Isaac.Spawn(1000, 49, 0, player.Position, Vector.Zero, player):ToEffect()
                            poof.SpriteOffset = Vector(0,-40*player.SpriteScale.Y)
                            poof:FollowParent(player)
                            poof.DepthOffset = 50
                            poof:Update()
                            break
                        end
                    end
                end
            end
        end
    end
end