local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod.PLATINUM_CREST_DAMAGE = 0.025

function mod:platinumCrestRoomClear()
    mod.AnyPlayerDo(function(player)
        if player:HasCollectible(mod.ITEM.COLLECTIBLE.PLATINUM_CREST) then
            local basedata = mod:GetEntityData(player)
            local data = basedata.ffsavedata
            data.PlatinumCrestRoomsCompleted = data.PlatinumCrestRoomsCompleted or 0
            data.PlatinumCrestRoomsCompleted = data.PlatinumCrestRoomsCompleted + 1
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			player:EvaluateItems()
            
            local flash = Isaac.Spawn(1000, EffectVariant.IMPACT, 0, player.Position, Vector.Zero, player):ToEffect()
            flash:FollowParent(player)
            flash.SpriteOffset = Vector(0,-20) * player.SpriteScale
            flash.SpriteScale = player.SpriteScale
            
            sfx:Play(mod.Sounds.PlatinumCrestFeedback,0.75,0,false,0.75 + (math.random() * 0.75))
        end
    end)
end