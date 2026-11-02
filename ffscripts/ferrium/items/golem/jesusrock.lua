local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

function mod:playerCurrentlyDying(player, sprite)
    local str = sprite:GetAnimation()
    if str:sub(-5) == "Death" then -- and player:GetHearts() <= 0 then
        return true
    end
end

local function GETMEUP(player, data)
    local mult = mod.GetGolemTrinketPower(player, mod.ITEM.ROCK.JESUS_ROCK)
    local hearts = player:GetMaxHearts()
    if hearts > 0 then
        player:AddHearts(-1)
    else
        player:AddSoulHearts(-1)
    end

    if mult > 2 then --okay these thresholds are arbitrary but idc, stuff like henge rock goes weird otherwise
        player:UseActiveItem(CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS, UseFlag.USE_NOANIM, -1)
    end
    if mult > 1.5 then
        player:AddHearts(99)
        player:AddSoulHearts(99)
    elseif mult > 0.8 then
        if hearts > 0 then
            player:AddHearts(12)
            if 12-hearts > 0 then
                player:AddSoulHearts(12-hearts)
            end
        else
            player:AddSoulHearts(12)
        end
    else
        if hearts > 0 then
            player:AddHearts(4)
            if 4-hearts > 0 then
                player:AddSoulHearts(4-hearts)
            end
        else
            player:AddSoulHearts(4)
        end
    end
    sfx:Play(SoundEffect.SOUND_HOLY, 1, 0, false, 1)

	local trueMult = player:GetTrinketMultiplier(mod.ITEM.ROCK.JESUS_ROCK)
	for i=1,trueMult do
		player:TryRemoveTrinket(mod.ITEM.ROCK.JESUS_ROCK)
	end
end

-- Called from `ffscripts/revives.lua`
function mod.TryJesusRockRevive(player, data, effs)
	if player:HasTrinket(mod.ITEM.ROCK.JESUS_ROCK) then
		player:Revive()

		GETMEUP(player, data)
		player:SetMinDamageCooldown(120)

		local holdSprite = Sprite()
		holdSprite:Load("gfx/005.350_trinket.anm2", true)
		holdSprite:ReplaceSpritesheet(0, "gfx/items/trinkets/golem/trinket_jesusrock.png")
		holdSprite:LoadGraphics()
		holdSprite:Play("Idle", true)
		player:AnimatePickup(holdSprite, true)
	end
end
