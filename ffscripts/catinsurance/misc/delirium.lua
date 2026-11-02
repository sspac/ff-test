local mod = FiendFolio

local function enterRandomState(data, rng, states)
    local chosen = rng:RandomInt(1, #states)
    data.state = states[chosen]
end

local function onBuckTransform(delirium, data)
    -- run init code
    data.next_attack = 0
    data.charge_timer = 0
    data.charge_cooldown = 20
    data.rummage_counter = 0
    data.shoot_direction = "ShootDown"
    data.charge_direction = "ChargeDown"

    local states = {
        "attack1",
        "attack2",
        "attack3",
        "rummage"
    }
    enterRandomState(data, delirium:GetDropRNG(), states)
end

local function onGriddleHornTransform(delirium, data)
    data.ad = {--Attacks done
        {"teleport", 0},--Tele
        {"lob", 0},		--Lob
        {"thanos", 0},	--Snap
        {"shoot", 0},	--Shoot
        {"shootmote", 0}--ShootMote
    }
    data.lobcount = 0
    data.init = true
    delirium:GetSprite():Play("Idle", true)

    local states = {
        "idle",
        "shoot",
        "lob",
        "shootmote"
    }
    enterRandomState(data, delirium:GetDropRNG(), states)
end

--[[
    This lets you replace the spritesheet for Delirium.

    [ID] = {
        [BOSS VAR] = {
            Spritesheets = {
                {"GFX FILE PATH", layers to replace, you can put as many as you want, yay},
                {"GFX FILE PATH", you can also put multiple file paths, cool idea!}
            },
            OnTransform = function(delirium, data)
        }
    }
--]]
FiendFolio.DeliriumInfo = {
    [mod.FFID.Boss] = {
        [mod.FF.Buck.Var] = {
            Spritesheets = {
                {"gfx/bosses/delirium/delirious_buck.png", 0, 1}
            },
            OnTransform = onBuckTransform
        },

        [mod.FF.Kingpin.Var] = {
            Spritesheets = {
                {"gfx/bosses/delirium/delirius_kingpin.png", 0}
            }
        },

        [mod.FF.GriddleHorn.Var] = {
            Spritesheets = {
                {"gfx/bosses/delirium/delirious_griddlehorn.png", 0, 1, 2, 3, 4, 5}
            },
            OnTransform = onGriddleHornTransform
        },

        [mod.FF.Battie.Var] = {
            Spritesheets = {
                {"gfx/bosses/delirium/delirious_battie.png", 0, 1, 2, 3, 4}
            },
        }
    },

    [mod.FFID.Mini] = {
        [mod.FF.Honeydrop.Var] = {
            Spritesheets = {
                {"gfx/bosses/delirium/delirious_honeydrop.png", 0, 1, 2}
            }
        }
    }
    
}

---@param delirium EntityDelirium
function mod:PostDeliriumTransform(delirium)
	mod.IsDeliriumRoom = true

    local bossId = delirium.BossType
    local bossVariant = delirium.BossVariant

    -- Load the delirium spritesheet
    local variants = mod.DeliriumInfo[bossId]
    if variants then
        for var, info in pairs(variants) do
            if var == bossVariant then
                local sheets = info.Spritesheets
                local onTransform = info.OnTransform

                if sheets then
                    local sprite = delirium:GetSprite()
                    for _, sheetInfo in ipairs(sheets) do
                        for i, layer in ipairs(sheetInfo) do
                            if i > 1 then
                                sprite:ReplaceSpritesheet(layer, sheetInfo[1])
                            end
                        end
                    end
                    sprite:LoadGraphics()
                end

                if onTransform then
                    onTransform(delirium, mod:GetEntityData(delirium))
                end
            end
        end
    end

    -- Remove spawned Bellas from Honeydrop
	for _, bella in ipairs(Isaac.FindByType(mod.FF.Bella.ID, mod.FF.Bella.Var, -1, false, false)) do
		bella:Remove()
	end
	
    -- Clean up boss data for FF bosses
    local deliriumData = mod:GetEntityData(delirium)
    local dataToClear = {
        "init",
        "initialized",
        "CheckedLJReskin",          -- Rainbow Rag Man
        "spawnedAnotherGuy",        -- Rival Widows
        "snowballin",               -- Grinch Krampus
        "GreenLokiiAnm2Replace",    -- Alien Lokii
        "Black_SisterVis_Init",     -- Black Sister Vis
    }
	for _, key in ipairs(dataToClear) do
        deliriumData[key] = nil
    end
end
mod:AddCallback(DeliriumCallbacks.POST_TRANSFORMATION, mod.PostDeliriumTransform)