local mod = FiendFolio

local ebbFilepath = "gfx/ui/bosshp_icons/ff/"

local ebbIcons = {
    {
        BossID = mod.FF.Buck,
        Sprite = "buck",
    },
    {
        BossID = mod.FF.Honeydrop,
        Sprite = "honeydrop",
        Conditionals = {
            {
                function(entity)
                    return entity.SubType == 1
                end,
                ebbFilepath .. "honeydrop_red" .. ".png"
            }
        }
    },
    {
        BossID = mod.FF.Battie,
        Sprite = "battie",
        Conditionals = {
            {
                function(entity)
                    return entity.SubType == 1
                end,
                ebbFilepath .. "battie_brown" .. ".png"
            },
            {
                function(entity)
                    return entity.SubType == 2
                end,
                ebbFilepath .. "battie_purple" .. ".png"
            }
        }
    },
    {
        BossID = mod.FF.Buster,
        Sprite = "buster",
    },
    {
        BossID = mod.FF.GriddleHorn,
        Sprite = "griddlehorn",
    },
    {
        BossID = mod.FF.Monsoon,
        Sprite = "monsoon",
        Conditionals = {
            {
                function(entity)
                    return mod:GetEntityData(entity).IsATinyBoy and not (mod:GetEntityData(entity).IsABigBoy or FiendFolio.isBackdrop("Scarred Womb"))
                end,
                ebbFilepath .. "monsoon_small" .. ".png"
            },
            {
                function(entity)
                    return mod:GetEntityData(entity).IsABigBoy and not (mod:GetEntityData(entity).IsATinyBoy or FiendFolio.isBackdrop("Scarred Womb"))
                end,
                ebbFilepath .. "monsoon_big" .. ".png"
            },
            {
                function(entity)
                    return FiendFolio.isBackdrop("Scarred Womb") and not (mod:GetEntityData(entity).IsATinyBoy or mod:GetEntityData(entity).IsABigBoy)
                end,
                ebbFilepath .. "monsoon_blood" .. ".png"
            },
            {
                function(entity)
                    return FiendFolio.isBackdrop("Scarred Womb") and mod:GetEntityData(entity).IsATinyBoy and not mod:GetEntityData(entity).IsABigBoy
                end,
                ebbFilepath .. "monsoon_small_blood" .. ".png"
            },
            {
                function(entity)
                    return FiendFolio.isBackdrop("Scarred Womb") and mod:GetEntityData(entity).IsABigBoy and not mod:GetEntityData(entity).IsATinyBoy
                end,
                ebbFilepath .. "monsoon_big_blood" .. ".png"
            }
        }
    },
    {
        BossID = mod.FF.SunVenus,
        Sprite = "sun_venus",
    },
    {
        BossID = mod.FF.SunEarth,
        Sprite = "sun_earth",
    },
    {
        BossID = mod.FF.SunNeptune,
        Sprite = "sun_neptune",
    },
    {
        BossID = mod.FF.OrgChaser,
        Sprite = "organization1",
        Conditionals = {
            {
                function(entity)
                    return mod:GetEntityData(entity).AwokenPokey
                end,
                ebbFilepath .. "organization" .. "4" .. ".png"
            },
            {
                function(entity)
                    return mod:GetEntityData(entity).AwokenBashful
                end,
                ebbFilepath .. "organization" .. "3" .. ".png"
            },
            {
                function(entity)
                    return mod:GetEntityData(entity).AwokenSpeedy
                end,
                ebbFilepath .. "organization" .. "2" .. ".png"
            },
        }
    },
    {
        BossID = mod.FF.Basco,
        Sprite = "basco",
        Conditionals = {
            {
                function(entity)
                    return mod:GetEntityData(entity).enraged
                end,
                ebbFilepath .. "basco2" .. ".png"
            }
        }
    },
    {
        BossID = mod.FF.Kingpin,
        Sprite = "kingpin"
    },
    {
        BossID = mod.FF.Peeping,
        Sprite = "peeping"
    },
    {
        BossID = mod.FF.Peeping2,
        Sprite = "peeping2"
    },
    {
        BossID = mod.FF.Luncheon,
        Sprite = "luncheon",
    },
    {
        BossID = mod.FF.Pollution,
        Sprite = "pollution",
    },
    {
        BossID = mod.FF.Pollution2,
        Sprite = "pollution2",
    },
    {
        BossID = mod.FF.Meltdown,
        Sprite = "meltdown",
    },
    {
        BossID = mod.FF.Meltdown2,
        Sprite = "meltdown2",
    },
    {
        BossID = mod.FF.Aquagob,
        Sprite = "aquagob"
    },
    {
        BossID = mod.FF.Dusk,
        Sprite = "dusk"
    },
    {
        BossID = mod.FF.Tsar,
        Sprite = "tsar",
        Conditionals = {
            {
                function(entity)
                    return mod:GetEntityData(entity).form == 0 and entity.SubType & 8 > 0
                end,
                ebbFilepath .. "tsar_red.png"
            },
            {
                function(entity)
                    return mod:GetEntityData(entity).form == 1 and entity.SubType & 8 > 0
                end,
                ebbFilepath .. "tsar_green_red.png"
            },
            {
                function(entity)
                    return mod:GetEntityData(entity).form == 2 and entity.SubType & 8 > 0
                end,
                ebbFilepath .. "tsar_yellow_red.png"
            },
            {
                function(entity)
                    return mod:GetEntityData(entity).form == 3 and entity.SubType & 8 > 0
                end,
                ebbFilepath .. "tsar_brown_red.png"
            },
            {
                function(entity)
                    return mod:GetEntityData(entity).form == 1
                end,
                ebbFilepath .. "tsar_green.png"
            },
            {
                function(entity)
                    return mod:GetEntityData(entity).form == 2
                end,
                ebbFilepath .. "tsar_yellow.png"
            },
            {
                function(entity)
                    return mod:GetEntityData(entity).form == 3
                end,
                ebbFilepath .. "tsar_brown.png"
            },
        }
    },
    {
        BossID = mod.FF.Cacamancer,
        Sprite = "cacamancer"
    },
    {
        BossID = mod.FF.Gutso,
        Sprite = "gutso",
        Conditionals = {
            {
                function(entity)
                    return mod:GetEntityData(entity).phase2Began
                end,
                ebbFilepath .. "gutso2" .. ".png"
            }
        }
    },
    {
        BossID = mod.FF.Slinger,
        Sprite = "slinger",
        Conditionals = {
            {
                function(entity)
                    return entity.SubType == 1
                end,
                ebbFilepath .. "slinger_black" .. ".png"
            }
        }
    },
    {
        BossID = mod.FF.MrDead,
        Sprite = "mrdead",
    },
    {
        BossID = mod.FF.WarpZone,
        Sprite = "warpzone"
    },
    {
        BossID = mod.FF.CorruptedLarry,
        Sprite = "corrupted_larry_jr",
        Conditionals = {
            {
                function(entity)
                    return entity.Parent and HPBars.Config.Sorting == "Segments"
                end,
                ebbFilepath .. "corrupted_larry_jr_segment" .. ".png"
            },
            {
                function(entity)
                    return HPBars.Config.Sorting == "Bosses"
                end,
                ebbFilepath .. "corrupted_larry_jr_full" .. ".png"
            }
        }
    },
    {
        BossID = mod.FF.CorruptedContusion,
        Sprite = "corrupted_contusion"
    },
    {
        BossID = mod.FF.CorruptedSuture,
        Sprite = "corrupted_suture"
    },
    {
        BossID = mod.FF.CorruptedMonstro,
        Sprite = "corrupted_monstro"
    },
    {
        BossID = mod.FF.Ghostbuster,
        Sprite = "ghostbuster"
    },
    {
        BossID = mod.FF.WhispersController,
        Sprite = "whispers"
    },
    {
        BossID = mod.FF.Psion,
        Sprite = "psion"
    },
    {
        BossID = mod.FF.Gravedigger,
        Sprite = "gravedigger"
    },
    {
        BossID = mod.FF.Hermit,
        Sprite = "hermit"
    },
    {
        BossID = mod.FF.CacophobiaVenus,
        Sprite = "caco1",
        Size64 = true,
        Conditionals = {
            {
                function(entity)
                    return mod:GetEntityData(entity).Pattern
                end,
                ebbFilepath .. "caco2" .. ".png"
            }
        }
    },
    {
        BossID = mod.FF.Junkstrap,
        Sprite = "junkstrap"
    },
    {
        BossID = mod.FF.Madomme,
        Sprite = "madomme",
        Conditionals = {
            {
                function(entity)
                    return mod:GetEntityData(entity).state == 7 --Only local enums woo
                end,
                ebbFilepath .. "madomme2" .. ".png"
            },
        }
    },
    {
        BossID = mod.FF.Mo,
        Sprite = "default_boss",
        Conditionals = {
            {
                function(entity)
                    return mod:GetEntityData(entity).bossBar == 0
                end,
                "gfx/nothing.png"
            },
            {
                function(entity)
                    return mod:GetEntityData(entity).bossBar == 1
                end,
                ebbFilepath .. "mo" .. ".png"
            },
            {
                function(entity)
                    return mod:GetEntityData(entity).bossBar == 2
                end,
                ebbFilepath .. "moe" .. ".png"
            },
            {
                function(entity)
                    return mod:GetEntityData(entity).bossBar == 3 and entity.SubType == 1
                end,
                "gfx/ui/bosshp_icons/chapter1/monstro_red.png"
            },
            {
                function(entity)
                    return mod:GetEntityData(entity).bossBar == 3 and entity.SubType == 2
                end,
                "gfx/ui/bosshp_icons/chapter1/monstro_grey.png"
            },
            {
                function(entity)
                    return mod:GetEntityData(entity).bossBar == 3 and entity.SubType == 3
                end,
                "gfx/ui/bosshp_icons/chapter1/monstro_mucus.png"
            },
            {
                function(entity)
                    return mod:GetEntityData(entity).bossBar == 3
                end,
                "gfx/ui/bosshp_icons/chapter1/monstro.png"
            },
            {
                function(entity)
                    return mod:GetEntityData(entity).bossBar == 4
                end,
                ebbFilepath .. "myfirstboss" .. ".png"
            },
        }
    },
    {
        BossID = mod.FF.FoozTwinsBall,
        Sprite = "fooztwins"
    },
    {
        BossID = mod.FF.BabyBubbles,
        Sprite = "babybubbles",
        Conditionals = {
            {
                function(entity)
                    return mod:GetEntityData(entity).eyePopped
                end,
                ebbFilepath .. "babybubbles2" .. ".png"
            }
        }
    },
    {
        BossID = mod.FF.Deluge,
        Sprite = "deluge",
        Conditionals = {
            {
                function(entity)
                    return mod:GetEntityData(entity).Phase2BossBarIcon
                end,
                ebbFilepath .. "deluge2" .. ".png"
            }
        }
    },
    {
        BossID = mod.FF.Propaganda,
        Sprite = "propaganda",
        Conditionals = {
            {
                function(entity)
                    return mod:GetEntityData(entity).Phase2BossBarIcon
                end,
                ebbFilepath .. "propaganda2" .. ".png"
            }
        }
    },
    {
        BossID = mod.FF.Amon,
        Sprite = "amon"
    },
}
mod.scheduleForUpdate(function()
    if HPBars then
        if HPBars.BossIgnoreList then
            HPBars.BossIgnoreList[mod.FF.Kingpin.ID .. "." .. mod.FF.Kingpin.Var] = function(entity)
                return entity.Parent ~= nil
            end
            HPBars.BossIgnoreList[mod.FF.DuskHand.ID .. "." .. mod.FF.DuskHand.Var] = function(entity)
                return true
            end
            HPBars.BossIgnoreList[mod.FF.Whispers.ID .. "." .. mod.FF.Whispers.Var] = function(entity)
                return true
            end
            HPBars.BossIgnoreList[mod.FF.OrgChaserBrain.ID .. "." .. mod.FF.OrgChaserBrain.Var] = function(entity)
                if entity.SubType == mod.FF.OrgChaserBrain.Sub then return true end
            end
            HPBars.BossIgnoreList[mod.FF.OrgBashful.ID .. "." .. mod.FF.OrgBashful.Var] = function(entity)
                return true
            end
            HPBars.BossIgnoreList[mod.FF.OrgSpeedy.ID .. "." .. mod.FF.OrgSpeedy.Var] = function(entity)
                return true
            end
            HPBars.BossIgnoreList[mod.FF.OrgPokey.ID .. "." .. mod.FF.OrgPokey.Var] = function(entity)
                return true
            end
            HPBars.BossIgnoreList[mod.FF.Peeping.ID .. "." .. mod.FF.Peeping.Var] = function(entity)
                return mod:GetEntityData(entity).spawnedPhase2
            end
            HPBars.BossIgnoreList[mod.FF.Meltdown.ID .. "." .. mod.FF.Meltdown.Var] = function(entity)
                return mod:GetEntityData(entity).spawnedPhase2
            end
            HPBars.BossIgnoreList[mod.FF.Pollution.ID .. "." .. mod.FF.Pollution.Var] = function(entity)
                return mod:GetEntityData(entity).spawnedPhase2
            end
            HPBars.BossIgnoreList[mod.FF.WarpZone.ID .. "." .. mod.FF.WarpZone.Var] = function(entity)
                return mod:GetEntityData(entity).hiding and mod:GetEntityData(entity).state ~= "Return"
            end
            HPBars.BossIgnoreList[mod.FF.CorruptedContusion.ID .. "." .. mod.FF.CorruptedContusion.Var] = function(entity)
                return mod:GetEntityData(entity).dead
            end
        end
        if HPBars.BossDefinitions then
            for i = 1, #ebbIcons do
                local position
                if ebbIcons[i].BossID then
                    position = ebbIcons[i].BossID.ID .. "." .. ebbIcons[i].BossID.Var
                end
                if position then
                    local anm2Override
                    if ebbIcons[i].Size64 then
                        anm2Override = "gfx/ui/bosshp_icons/bosshp_icon_64px.anm2"
                    end
                    HPBars.BossDefinitions[position] = {
                        sprite = ebbFilepath .. ebbIcons[i].Sprite .. ".png",
                        offset = ebbIcons[i].Offset or Vector.Zero,
                        iconAnm2 = anm2Override,
                    }
                    if ebbIcons[i].Conditionals then
                        HPBars.BossDefinitions[position].conditionalSprites = {}
                        for k = 1, #ebbIcons[i].Conditionals do
                            HPBars.BossDefinitions[position].conditionalSprites[k] = ebbIcons[i].Conditionals[k]
                        end
                    end
                end
            end
            HPBars.BossDefinitions["19.0"].bossColors[mod.FF.LarryGhost.IDx+1] = "_ghost"
            HPBars.BossDefinitions["19.1"].bossColors[mod.FF.HollowFuckedUpAndEvil.IDx+1] = "_possessed"
            HPBars.BossDefinitions["20.0"].bossColors[mod.FF.MucusMonstro.IDx+1] = "_mucus"
            HPBars.BossDefinitions["45.10"].bossColors[mod.FF.FiendMom.Sub] = "_fiend"
            HPBars.BossDefinitions["62.0"].bossColors[mod.FF.TechnoPin.IDx+1] = "_techno"
            HPBars.BossDefinitions["67.1"].bossColors[mod.FF.WineHusk.IDx+1] = "_grape"
            HPBars.BossDefinitions["71.0"].bossColors[mod.FF.BeehiveFistulaBig.IDx+1] = "_beehive"
            HPBars.BossDefinitions["72.0"].bossColors[mod.FF.BeehiveFistulaMedium.IDx+1] = "_beehive"
            --HPBars.BossDefinitions["73.0"].bossColors[mod.FF.BeehiveFistulaSmall.IDx+1] = "_beehive"
            HPBars.BossDefinitions["97.0"].bossColors[mod.FF.YellowMaskOfInfamy.IDx+1] = "_kidney"
            HPBars.BossDefinitions["98.0"].bossColors[mod.FF.KidneyOfInfamy.IDx+1] = "_kidney"
            HPBars.BossDefinitions["100.0"].bossColors[mod.FF.BabyWidowChampion.IDx+1] = "_albino"
            --HPBars.BossDefinitions["100.0"].bossColors[mod.FF.RivalWidowChampion.IDx+1] = "_rival_purple"
            HPBars.BossDefinitions["237.1"].bossColors[mod.FF.MushroomGurgling.IDx+1] = "_mushroom"
            HPBars.BossDefinitions["403.0"].bossColors[mod.FF.RedForsaken.IDx+1] = "_ff_red"
            HPBars.BossDefinitions["405.0"].bossColors[mod.FF.RainbowRagMan.IDx+1] = "_rainbow"

            --Ones that need setup
            HPBars.BossDefinitions["69.0"].bossColors = HPBars.BossDefinitions["69.0"].bossColors or {}
            HPBars.BossDefinitions["69.0"].bossColors[mod.FF.AlienLokiChampion.IDx+1] = "_ff_green"
            HPBars.BossDefinitions["69.1"].bossColors = HPBars.BossDefinitions["69.1"].bossColors or {}
            HPBars.BossDefinitions["69.1"].bossColors[mod.FF.AlienLokiiChampion.IDx+1] = "_ff_green"
            HPBars.BossDefinitions["72.1"].bossColors = HPBars.BossDefinitions["72.1"].bossColors or {}
            HPBars.BossDefinitions["72.1"].bossColors[mod.FF.FuzzyTeratomaMedium.IDx+1] = "_fuzzy"
            HPBars.BossDefinitions["72.1"].conditionalSprites = HPBars.BossDefinitions["72.1"].conditionalSprites or {}
            table.insert(   HPBars.BossDefinitions["72.1"].conditionalSprites,
                            {   function(entity) return (entity:ToNPC():GetBossColorIdx() == mod.FF.CornyTeratomaMedium.IDx and not (mod:CheckStage("Dross", {45}) or mod:CheckStage("Corpse", {34,43,44}))) end,
                                "gfx/ui/bosshp_icons/chapter4/teratoma_medium_corny.png"} )
            table.insert(   HPBars.BossDefinitions["72.1"].conditionalSprites,
                            {   function(entity) return (entity:ToNPC():GetBossColorIdx() == mod.FF.CornyTeratomaMedium.IDx and mod:CheckStage("Corpse", {34,43,44})) end,
                                "gfx/ui/bosshp_icons/chapter4/teratoma_medium_corny_corpse.png"} )
            table.insert(   HPBars.BossDefinitions["72.1"].conditionalSprites,
                            {   function(entity) return (entity:ToNPC():GetBossColorIdx() == mod.FF.CornyTeratomaMedium.IDx and mod:CheckStage("Dross", {45})) end,
                                "gfx/ui/bosshp_icons/chapter4/teratoma_medium_corny_dross.png"} )
            HPBars.BossDefinitions["71.1"].bossColors = HPBars.BossDefinitions["71.1"].bossColors or {}
            HPBars.BossDefinitions["71.1"].bossColors[mod.FF.FuzzyTeratomaBig.IDx+1] = "_fuzzy"
            HPBars.BossDefinitions["71.1"].conditionalSprites = HPBars.BossDefinitions["71.1"].conditionalSprites or {}
            table.insert(   HPBars.BossDefinitions["71.1"].conditionalSprites,
                            {   function(entity) return (entity:ToNPC():GetBossColorIdx() == mod.FF.CornyTeratomaBig.IDx and not (mod:CheckStage("Dross", {45}) or mod:CheckStage("Corpse", {34,43,44}))) end,
                                "gfx/ui/bosshp_icons/chapter4/teratoma_large_corny.png"} )
            table.insert(   HPBars.BossDefinitions["71.1"].conditionalSprites,
                            {   function(entity) return (entity:ToNPC():GetBossColorIdx() == mod.FF.CornyTeratomaBig.IDx and mod:CheckStage("Corpse", {34,43,44})) end,
                                "gfx/ui/bosshp_icons/chapter4/teratoma_large_corny_corpse.png"} )
            table.insert(   HPBars.BossDefinitions["71.1"].conditionalSprites,
                            {   function(entity) return (entity:ToNPC():GetBossColorIdx() == mod.FF.CornyTeratomaBig.IDx and mod:CheckStage("Dross", {45})) end,
                                "gfx/ui/bosshp_icons/chapter4/teratoma_large_corny_dross.png"} )
			HPBars.BossDefinitions["79.2"].bossColors = HPBars.BossDefinitions["79.2"].bossColors or {}
			HPBars.BossDefinitions["79.2"].bossColors[mod.FF.RedBlightedOvum.IDx+1] = "_ff_red"
			HPBars.BossDefinitions["79.2"].bossColors[mod.FF.BlueBlightedOvum.IDx+1] = "_ff_blue"
            HPBars.BossDefinitions["81.1"].bossColors = HPBars.BossDefinitions["81.1"].bossColors or {}
            HPBars.BossDefinitions["81.1"].bossColors[mod.FF.GrinchKrampus.IDx+1] = "_grinch"
            HPBars.BossDefinitions["409.0"].bossColors = HPBars.BossDefinitions["409.0"].bossColors or {}
            HPBars.BossDefinitions["409.0"].bossColors[mod.FF.PinkRagMega.IDx+1] = "_ff_pink"
            HPBars.BossDefinitions["410.0"].bossColors = HPBars.BossDefinitions["410.0"].bossColors or {}
            HPBars.BossDefinitions["410.0"].bossColors[mod.FF.BlackSisterVis.IDx+1] = "_ff_black"
            HPBars.BossDefinitions["411.0"].bossColors = HPBars.BossDefinitions["411.0"].bossColors or {}
            HPBars.BossDefinitions["411.0"].bossColors[mod.FF.RedBigHorn.IDx+1] = "_ff_red"
            HPBars.BossDefinitions["921.0"].bossColors = HPBars.BossDefinitions["921.0"].bossColors or {}
            HPBars.BossDefinitions["921.0"].bossColors[mod.FF.GreenClutch.IDx+1] = "_ff_green"

            HPBars.BossDefinitions["404.0"].conditionalSprites = HPBars.BossDefinitions["404.0"].conditionalSprites or {}
            table.insert(   HPBars.BossDefinitions["404.0"].conditionalSprites,
                            {   function(entity) return mod:GetEntityData(entity).red_champ_variant == 1 end,
                                "gfx/ui/bosshp_icons/chapter1/little_horn_reddy.png"} )
            table.insert(   HPBars.BossDefinitions["404.0"].conditionalSprites,
                            {   function(entity) return mod:GetEntityData(entity).red_champ_variant == 2 end,
                                "gfx/ui/bosshp_icons/chapter1/little_horn_roddy.png"} )
            table.insert(   HPBars.BossDefinitions["404.0"].conditionalSprites,
                            {   function(entity) return mod:GetEntityData(entity).red_champ_variant == 3 end,
                                "gfx/ui/bosshp_icons/chapter1/little_horn_riddy.png"} )

            HPBars.BossDefinitions["100.0"].conditionalSprites = HPBars.BossDefinitions["100.0"].conditionalSprites or {}
            table.insert(   HPBars.BossDefinitions["100.0"].conditionalSprites,
                            {   function(entity) return (entity:ToNPC():GetBossColorIdx() == mod.FF.RivalWidowChampion.IDx and mod:GetEntityData(entity).theOtherGuy) end,
                                "gfx/ui/bosshp_icons/chapter1/widow_rival_orange.png"} )
            table.insert(   HPBars.BossDefinitions["100.0"].conditionalSprites,
                            {   function(entity) return (entity:ToNPC():GetBossColorIdx() == mod.FF.RivalWidowChampion.IDx and not (mod:GetEntityData(entity).theOtherGuy)) end,
                                "gfx/ui/bosshp_icons/chapter1/widow_rival_purple.png"} )

            HPBars.BossDefinitions["921.0"].conditionalSprites = HPBars.BossDefinitions["921.0"].conditionalSprites or {}
            table.insert(   HPBars.BossDefinitions["921.0"].conditionalSprites,
                            {   function(entity) return (entity:ToNPC():GetBossColorIdx() == mod.FF.GreenClutch.IDx and entity:ToNPC().State == 6) end,
                                "gfx/ui/bosshp_icons/altpath/clutch_clicketyclack_ff_green.png"} )

            HPBars.BossDefinitions["908.0"].bossColors = HPBars.BossDefinitions["908.0"].bossColors or {}
            HPBars.BossDefinitions["908.0"].bossColors[mod.FF.GoldenPlum.IDx+1] = "_golden"
            --HAH AHA HA HAHAHA WOFSAUGE
            HPBars.BossDefinitions["73.0"].bossColors = HPBars.BossDefinitions["73.0"].bossColors or {"_grey"}
            HPBars.BossDefinitions["73.0"].bossColors[mod.FF.BeehiveFistulaSmall.IDx+1] = "_beehive"
            HPBars.BossDefinitions["73.1"].bossColors = HPBars.BossDefinitions["72.1"].bossColors or {}
            HPBars.BossDefinitions["73.1"].bossColors[mod.FF.FuzzyTeratomaSmall.IDx+1] = "_fuzzy"
            HPBars.BossDefinitions["73.1"].conditionalSprites = HPBars.BossDefinitions["73.1"].conditionalSprites or {}
            table.insert(   HPBars.BossDefinitions["73.1"].conditionalSprites,
                            {   function(entity) return (entity:ToNPC():GetBossColorIdx() == mod.FF.CornyTeratomaSmall.IDx and not (mod:CheckStage("Dross", {45}) or mod:CheckStage("Corpse", {34,43,44}))) end,
                                "gfx/ui/bosshp_icons/chapter4/teratoma_small_corny.png"} )
            table.insert(   HPBars.BossDefinitions["73.1"].conditionalSprites,
                            {   function(entity) return (entity:ToNPC():GetBossColorIdx() == mod.FF.CornyTeratomaSmall.IDx and mod:CheckStage("Corpse", {34,43,44})) end,
                                "gfx/ui/bosshp_icons/chapter4/teratoma_small_corny_corpse.png"} )
            table.insert(   HPBars.BossDefinitions["73.1"].conditionalSprites,
                            {   function(entity) return (entity:ToNPC():GetBossColorIdx() == mod.FF.CornyTeratomaSmall.IDx and mod:CheckStage("Dross", {45})) end,
                                "gfx/ui/bosshp_icons/chapter4/teratoma_small_corny_dross.png"} )
        end
    end
end, 1, ModCallbacks.MC_INPUT_ACTION, true)