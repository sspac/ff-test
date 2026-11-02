local mod = FiendFolio
local sfx = SFXManager()

local flag = TearFlagsLib.RegisterTearFlag("BOMB_TOKEN")

if REPENTOGON.MeetsVersion("1.1.2") then
function mod:bombTokenDamage(pos, damage, radius, linecheck, source, tearflags, damageflags, damagesource)
	if source and source.Type == EntityType.ENTITY_BOMB and TearFlagsLib.HasTearFlags(source, flag) then
		local bomb = source:ToBomb()
		local mult = TearFlagsLib.GetTearFlagParams(source, flag).Mult or 1
		
		local bonus
		if bomb.IsFetus then
			bonus = damage*mult*0.25
		else
			bonus = 50*mult
		end
		
		if bonus > 90 then
            sfx:Play(mod.Sounds.BombToken, 1, 0, false, 1)
        else
            sfx:Play(mod.Sounds.BombToken, 0.5, 0, false, 1)
        end
		return {Damage = damage+bonus}
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_BOMB_DAMAGE, mod.bombTokenDamage)
end

function mod:bombTokenPostFireBomb(player, bomb) --rockets are not bombs
    if player and player:HasTrinket(FiendFolio.ITEM.TRINKET.BOMB_TOKEN) then
        local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.BOMB_TOKEN)
		TearFlagsLib.AddTearFlags(bomb, flag)
		TearFlagsLib.SetTearFlagParams(bomb, flag, {Mult = mult})
	end
end

mod:AddPriorityTrinketCallback(ModCallbacks.MC_POST_PLAYER_USE_BOMB, CallbackPriority.EARLY, FiendFolio.ITEM.TRINKET.BOMB_TOKEN, mod.bombTokenPostFireBomb)
mod:AddPriorityTrinketCallback(ModCallbacks.MC_POST_FIRE_BOMB, CallbackPriority.EARLY, FiendFolio.ITEM.TRINKET.BOMB_TOKEN, function(_, bomb)
	mod:bombTokenPostFireBomb(TearFlagsLib.GetTearPlayer(bomb), bomb)
end)

function mod:BombTokenOnAdd()
    sfx:Play(mod.Sounds.Tada, 1, 0, false, 1)
end