local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

function mod:MalachiteEntDamage(npc, amount, flags, source, cooldown)
	if flags & DamageFlag.DAMAGE_CLONES ~= 0 or not npc:ToNPC() then return end
	
    local mult = 0
    for i = 1, game:GetNumPlayers() do
        local player = Isaac.GetPlayer(i - 1)
        if player:HasTrinket(mod.ITEM.ROCK.MALACHITE) then
            mult = mult+mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.MALACHITE)
        end
    end
    if mult > 0 and npc:ToNPC():IsChampion() then
        local multiplier = 1+0.5*mult
        sfx:Play(mod.Sounds.FocusCrystal, 0.4, 0, false, 1)
        local flash = Isaac.Spawn(1000, mod.FF.MalachiteFlash.Var, mod.FF.MalachiteFlash.Sub, npc.Position, Vector.Zero, npc):ToEffect()
        flash.DepthOffset = 20
        flash.SpriteOffset = Vector(0, -16)
        return {Damage = amount*multiplier}
    end
end
mod:AddPriorityTrinketCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, -100, mod.ITEM.ROCK.MALACHITE, mod.MalachiteEntDamage)