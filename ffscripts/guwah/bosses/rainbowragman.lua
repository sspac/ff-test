local mod = FiendFolio
local game = Game()

local randomFlags = {
    {ProjectileFlags.SMART},
    {ProjectileFlags.GHOST, true},
    {ProjectileFlags.MEGA_WIGGLE, true, mod.ColorWigglyMaggot},
    {ProjectileFlags.SAWTOOTH_WIGGLE, true, mod.ColorPeepPiss},
    {ProjectileFlags.CONTINUUM, true},
    {ProjectileFlags.BLUE_FIRE_SPAWN},
    {ProjectileFlags.BURST, false, mod.ColorDecentlyRed},
    {ProjectileFlags.BOUNCE, true, mod.ColorBishopWhite},
    {ProjectileFlags.BACKSPLIT, true, mod.ColorDecentlyRed},
    {ProjectileFlags.CREEP_BROWN, false, mod.ColorGurdyOrange},
    {"boomerang", true, mod.ColorBlueBlue},
    {"acidic splot", false, mod.ColorSpittyGreen},
}
local randomHeadlessFlags = {1, 2, 6, 7, 10, 12}
local randomEnemies = {
    {EntityType.ENTITY_GAPER}, --Frowning Gaper
    {EntityType.ENTITY_GAPER, 1}, --Gaper
    {EntityType.ENTITY_MULLIGAN}, --Mulligan
    {EntityType.ENTITY_MULLIGAN, 1}, --Mulligoon
    {EntityType.ENTITY_CLOTTY}, --Clotty
    {EntityType.ENTITY_CLOTTY, 1}, --Clot
    {EntityType.ENTITY_SUCKER}, --Sucker
    {EntityType.ENTITY_SUCKER, 3}, --Ink
    {EntityType.ENTITY_SUCKER, 5}, --Bulb
    {EntityType.ENTITY_BOIL}, --Boil
    {EntityType.ENTITY_BOIL, 2}, --Sack
    {EntityType.ENTITY_FLY_L2}, --Level 2 Fly
    {EntityType.ENTITY_SPIDER_L2}, --Level 2 Spider
    {EntityType.ENTITY_SWARM}, --Swarm Flies
    {EntityType.ENTITY_SWARM_SPIDER, 0, 2}, --Swarm Spiders
    {EntityType.ENTITY_HORF}, --Horf
    {EntityType.ENTITY_SKINNY}, --Skinny
    {EntityType.ENTITY_SKINNY, 2}, --Crispy
    {EntityType.ENTITY_FATTY}, --Fatty
    {EntityType.ENTITY_CYCLOPIA}, --Cyclopia
    {EntityType.ENTITY_HOPPER}, --Hopper
    {EntityType.ENTITY_FLAMINGHOPPER}, --Flaming Hopper
    {EntityType.ENTITY_HOPPER, 1}, --Trite
    {EntityType.ENTITY_MINISTRO}, --Ministro
    {EntityType.ENTITY_ROUND_WORM}, --Round Worm
    {EntityType.ENTITY_EMBRYO}, --Embryo
    {mod.FF.Morsel.ID, mod.FF.Morsel.Var, 3}, --Morsels
    {mod.FF.Wimpy.ID, mod.FF.Wimpy.Var}, --Wimpy
    {mod.FF.Pester.ID, mod.FF.Pester.Var}, --Pester
    {mod.FF.Dung.ID, mod.FF.Dung.Var}, --Dung
    {mod.FF.Slim.ID, mod.FF.Slim.Var}, --Slim
    {mod.FF.Loafer.ID, mod.FF.Loafer.Var}, --Loafer
    {mod.FF.RedHorf.ID, mod.FF.RedHorf.Var}, --Red Horf
    {mod.FF.MutantHorf.ID, mod.FF.MutantHorf.Var}, --Mutant Horf
    {mod.FF.Benign.ID, mod.FF.Benign.Var}, --Benign
    {mod.FF.ButtFly.ID, mod.FF.ButtFly.Var}, --Butt Fly
    {mod.FF.Slobber.ID, mod.FF.Slobber.Var}, --Slobber
    {mod.FF.Bleedy.ID, mod.FF.Bleedy.Var}, --Bleeder
    {mod.FF.Casualty.ID, mod.FF.Casualty.Var}, --Casualty
    {mod.FF.Coby.ID, mod.FF.Coby.Var}, --Coby
    {mod.FF.Hover.ID, mod.FF.Hover.Var}, --Hover
    {mod.FF.Yawner.ID, mod.FF.Yawner.Var}, --Yawner
    {mod.FF.DrinkWorm.ID, mod.FF.DrinkWorm.Var}, --Drink Worm
    {mod.FF.Flare.ID, mod.FF.Flare.Var}, --Mr. Flare
    {mod.FF.Wick.ID, mod.FF.Wick.Var}, --Wick
    {mod.FF.Spitroast.ID, mod.FF.Spitroast.Var}, --Spitroast
}

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc:GetBossColorIdx() == mod.FF.RainbowRagMan.IDx then
        local sprite, data, rng = npc:GetSprite(), mod:GetEntityData(npc), npc:GetDropRNG()
        if not data.CheckedLJReskin then
            data.CheckedLJReskin = true
            if LastJudgementSprites then
                if npc.Variant == 1 then
                    sprite:Load("gfx/bosses/champions/ragman/405.001_ragman_rolling_head_lj.anm2", true)
                else
                    sprite:Load("gfx/bosses/champions/ragman/405.000_ragman_lj.anm2", true)
					if npc:ToDelirium() or (npc.SpawnerEntity and npc.SpawnerEntity:ToDelirium()) then
						mod:ReplaceEnemySpritesheet(npc, "gfx/bosses/afterbirthplus/deliriumforms/afterbirth/ragman", 0)
						for i=0, 4 do
							mod:ReplaceEnemySpritesheet(npc, "gfx/bosses/afterbirthplus/deliriumforms/afterbirth/ragman_body", i+1)
						end
					end
                end
            end
        end
        if npc.State == 3 then --Headless
            for _, proj in pairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE)) do
                if proj.SpawnerEntity ~= nil and proj.SpawnerEntity.InitSeed == npc.InitSeed and proj.FrameCount <= 0 then
                    proj = proj:ToProjectile()
                    if proj:HasProjectileFlags(ProjectileFlags.SMART) then
                        local flagData = randomFlags[mod:GetRandomElem(randomHeadlessFlags, rng)]
                        proj:ClearProjectileFlags(ProjectileFlags.SMART)
                        if type(flagData[1]) == "string" then
                            mod:GetEntityData(proj).projType = flagData[1]
                        else
                            proj:AddProjectileFlags(flagData[1])
                            if flagData[1] == ProjectileFlags.BLUE_FIRE_SPAWN then
                                proj.Scale = 1.5
                            end
                        end
                        if flagData[3] then
                            proj.Color = flagData[3]
                        end
                    end
                end
            end

        elseif npc.State == 4 then --Idle
            data.RainbowRandomProjFlag = nil

        elseif npc.State == 8 then --Shooting homing projectiles
            if data.RainbowRandomProjFlag == nil then
                data.RainbowRandomProjFlag = mod:GetRandomElem(randomFlags, rng)
            end
            if sprite:IsEventTriggered("Shoot") then
                --mod:PlaySound(SoundEffect.SOUND_HAPPY_RAINBOW, npc)
                for _, proj in pairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE)) do
                    if proj.SpawnerEntity ~= nil and proj.SpawnerEntity.InitSeed == npc.InitSeed and proj.FrameCount <= 0 then
                        proj = proj:ToProjectile()
                        if proj:HasProjectileFlags(ProjectileFlags.SMART) then
                            local flagData = data.RainbowRandomProjFlag
                            proj:ClearProjectileFlags(ProjectileFlags.SMART)
                            if type(flagData[1]) == "string" then
                                mod:GetEntityData(proj).projType = flagData[1]
                                if flagData[1] == "boomerang" then
                                    proj.Velocity = proj.Velocity * 2
                                    mod:GetEntityData(proj).origpos = npc.Position
                                    --[[proj:GetSprite():Load("gfx/projectiles/boomerang rib big.anm2",true)
			                        proj:GetSprite():Play("spin",false)]]
                                end
                            else
                                proj:AddProjectileFlags(flagData[1])
                                if flagData[1] == ProjectileFlags.BLUE_FIRE_SPAWN or flagData[1] == ProjectileFlags.BACKSPLIT then
                                    proj.Scale = 1.5
                                end
                            end
                            if flagData[2] then
                                proj.FallingAccel = -0.05
                            end
                            if flagData[3] then
                                proj.Color = flagData[3]
                            end
                        end
                    end
                end
            end

        elseif npc.State == 14 then --Revive rags
            if sprite:IsEventTriggered("Revive") then
                mod:PlaySound(SoundEffect.SOUND_HAPPY_RAINBOW, npc)
                ItemOverlay.Show(Giantbook.RAINBOW)
                for _, ragling in pairs(Isaac.FindByType(EntityType.ENTITY_RAGLING, 1)) do
                    if ragling.SpawnerType == EntityType.ENTITY_RAG_MAN and ragling:ToNPC():GetBossColorIdx() == mod.FF.RainbowRagMan.IDx and ragling.Position:Distance(npc.Position) <= 120 and ragling:ToNPC().State == NpcState.STATE_APPEAR_CUSTOM then
                        local enmData = mod:GetRandomElem(randomEnemies, rng)
                        Isaac.Spawn(enmData[1], enmData[2] or 0, enmData[3] or 0, ragling.Position, ragling.Velocity, ragling.SpawnerEntity)
                        ragling:Remove()
                    end
                end
            end
        end
    end
end, EntityType.ENTITY_RAG_MAN)

local randomColors = {Color.Default, mod.ColorRainbowYellow, mod.ColorRainbowGreen, mod.ColorRainbowBlue, mod.ColorRainbowPurple}
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
    if npc.Variant == 1 and npc:GetBossColorIdx() == mod.FF.RainbowRagMan.IDx then
        mod:lastJudgementAutoResprite(npc)
        if npc.State == 8 then
            if npc:GetSprite():IsEventTriggered("Shoot") then
                local color = mod:GetRandomElem(randomColors, rng)
                for _, proj in pairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE)) do
                    if proj.SpawnerEntity ~= nil and proj.SpawnerEntity.InitSeed == npc.InitSeed and proj.FrameCount <= 0 then
                        proj.Color = color
                    end
                end
            end
        end
    end
end, EntityType.ENTITY_RAGLING)