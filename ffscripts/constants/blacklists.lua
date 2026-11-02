local mod = FiendFolio

--GENERAL ENTITY LISTS----

--Cauldron Blacklist
mod.Cloneless = {
	{13, 0, 250}, --Soundmaker Fly
	{mod.FF.PsiKnight.ID, mod.FF.PsiKnight.Var, 1}, 		--Psionic Knight Brain
	{281}, 				--Swarm
	--{666,4}, 			--Bubble Grimace
	{mod.FFID.Tech}, 	--Technical enemies (Bubbles, tar bubbles, etc)
	{mod.FF.Blazer.ID, mod.FF.Blazer.Var},	--Blazer
	{mod.FF.Psion.ID},						--Psion
	{mod.FF.Cortex.ID, mod.FF.Cortex.Var},	--Cortex
	{mod.FF.LilJon.ID, mod.FF.LilJon.Var},	--Lil Jon
	{mod.FF.ToxicKnight.ID, mod.FF.ToxicKnight.Var, 1},						--Toxic Knight Brain
	{mod.FF.EternalFlickerspirit.ID, mod.FF.EternalFlickerspirit.Var},     --Eternal Flickerspirit
	{mod.FF.Viscerspirit.ID, mod.FF.Viscerspirit.Var},                     --Viscerspirit
	{mod.FF.Specturn.ID, mod.FF.Specturn.Var}, 	--Specturn
	{mod.FF.Observer.ID, mod.FF.Observer.Var}, 	--Observer
	{EntityType.ENTITY_PORTAL},                	--Portals / Lil' Portals
	{EntityType.ENTITY_EVIS, 10},              	--Evis Guts
	{mod.FF.Gravin.ID, mod.FF.Gravin.Var},     	--Gravin
	{mod.FF.Tsarball.ID, mod.FF.Tsarball.Var},	--TsarBall
	{mod.FF.Magnifier.ID, mod.FF.Magnifier.Var},

	{mod.FF.Lurker.ID, mod.FF.Lurker.Var},
	{mod.FF.LurkerCore.ID, mod.FF.LurkerCore.Var},
	{mod.FF.LurkerTooth.ID, mod.FF.LurkerTooth.Var},
	{mod.FF.LurkerStoma.ID, mod.FF.LurkerStoma.Var},
	{mod.FF.LurkerStretch.ID, mod.FF.LurkerStretch.Var},
	{mod.FF.LurkerBrain.ID, mod.FF.LurkerBrain.Var},
	{mod.FF.LurkerCollider.ID, mod.FF.LurkerCollider.Var},
	{mod.FF.LurkerStretchCollider.ID, mod.FF.LurkerStretchCollider.Var},
	{mod.FF.LurkerPsuedoDefault.ID, mod.FF.LurkerPsuedoDefault.Var},
	{mod.FF.LurkerBridgeProj.ID, mod.FF.LurkerBridgeProj.Var},
}

mod.PersistentList = {
	{mod.FF.Congression.ID, 0},
	{mod.FF.Congression.ID, 1},
	{mod.FF.Congression.ID, 2},
	{mod.FF.WombPillar.ID, mod.FF.WombPillar.Var},
	{mod.FF.Onlooker.ID, mod.FF.Onlooker.Var},
	{mod.FF.DangerousDiscGuide.ID, mod.FF.DangerousDiscGuide.Var},
	{mod.FF.Wailer.ID, mod.FF.Wailer.Var},
	{mod.FF.PillarJohn.ID, mod.FF.PillarJohn.Var},
	{mod.FF.Smokin.ID, mod.FF.Smokin.Var},
	{mod.FF.Flamin.ID, mod.FF.Flamin.Var},
	{mod.FF.SuperGrimace.ID, mod.FF.SuperGrimace.Var},
	{mod.FF.PsionicPortal.ID, mod.FF.PsionicPortal.Var},
	{mod.FF.Thwammy.ID, mod.FF.Thwammy.Var},
	{mod.FF.Thwammy.ID, mod.FF.Thwammy.Var},
	--{mod.FF.Grievance.ID, mod.FF.Grievance.Var},
	{mod.FF.AmnioticSac.ID, mod.FF.AmnioticSac.Var},
	{mod.FF.Miscarriage.ID, mod.FF.Miscarriage.Var},
	{mod.FF.HunkOfGunk.ID, mod.FF.HunkOfGunk.Var},
	{mod.FF.GlassEye.ID, mod.FF.GlassEye.Var},
}

--Exceptions to Effigy attachment blacklist, used by only Effigies and their variants specifically
FiendFolio.effigyWhitelist = {
	{44, 0}, --Poky
	FiendFolio.ENT("Poki"),
}

-- Effigy / Eternal Flickerspirit / Viscerspirit attachment blacklist (also includes HidingUnderwaterEnts)
FiendFolio.effigyBlacklist = {
	{13, 0, 250}, --Soundmaker Fly
	{44},		-- Poky/Slide
	{79, 12},	-- Blighted Ovum (Suture)
	{96},		-- Eternal Fly
	{216, 0},	-- Swinger Body (so it connects to the head)
	{216, 10},	-- Swinger Neck
	{EntityType.ENTITY_DARK_ESAU},
	{EntityType.ENTITY_BLOOD_PUPPY},
	{EntityType.ENTITY_FROZEN_ENEMY}, 		-- Uranus Frozen Enemy
	FiendFolio.ENT("Gravefire"),			-- Gravefire
	FiendFolio.ENT("GorgerAss"),			-- Gorger ass
	FiendFolio.ENT("Cortex"),				-- Cortex
	FiendFolio.ENT("PsiKnightBrain"),		-- Psionic Knight Brain
	FiendFolio.ENT("ToxicKnightBrain"),		-- Toxic Knight Brain
	FiendFolio.ENT("EternalFlickerspirit"),	-- Eternal Flickerspirit
	FiendFolio.ENT("Viscerspirit"),      	-- Viscerspirit
	FiendFolio.ENT("DeadFlyOrbital"),		-- Eternal Fly reimplementation
	FiendFolio.ENT("Harletwin"),			-- Harletwin
	FiendFolio.ENT("Effigy"),				-- Effigy
	FiendFolio.ENT("BolaHead"),				-- Bola Skull
	FiendFolio.ENT("BolaNeck"),				-- Bola Neck
	FiendFolio.ENT("FingoreHand"),			-- Fingore Hand
	FiendFolio.ENT("Cuffs"),				-- Cuffs
	FiendFolio.ENT("WarbleTail"),			-- Warble Tail
	FiendFolio.ENT("LonelyKnightBrain"),	-- Lonely Knight Hurtbox
	FiendFolio.ENT("LonelyKnightShell"),	-- Lonely Knight Hitboxes
	FiendFolio.ENT("Specturn"),				-- Specturn
	FiendFolio.ENT("RiftWalkerGfx"), -- Rift Walker (gfx)
	FiendFolio.ENT("KeyFiend"), -- KeyFiend
	FiendFolio.ENT("DungeonLocker"), -- Dungeon Locker
	FiendFolio.ENT("Thrall"), -- Thrall
	FiendFolio.ENT("FerrWaiting"), -- Waiting Entity Helper
	FiendFolio.ENT("EffigyCord"),
	FiendFolio.ENT("HarletwinCord"),
	FiendFolio.ENT("ThrallCord"),
	FiendFolio.ENT("NerviePoint"),
	FiendFolio.ENT("BadBag"),
	FiendFolio.ENT("TheColorRed"),
	FiendFolio.ENT("WhispersController"),
	{mod.FF.Bloomer.ID, mod.FF.Bloomer.Var},
	FiendFolio.ENT("Fogspawn"),
	{FiendFolio.FF.FreeThinkerMask.ID, FiendFolio.FF.FreeThinkerMask.Var, FiendFolio.FF.FreeThinkerMask.Sub},
	FiendFolio.ENT("Level0Fly"),
	FiendFolio.ENT("Congregation"),
}

-- Geigerspirit Blacklist (very similar to above, minus things like other Spirits)
FiendFolio.GeigerspiritBlacklist = {
	{13, 0, 250}, --Soundmaker Fly
	{44},		-- Poky/Slide
	{79, 12},	-- Blighted Ovum (Suture)
	{96},		-- Eternal Fly
	{216, 0},	-- Swinger Body (so it connects to the head)
	{216, 10},	-- Swinger Neck
	{EntityType.ENTITY_DARK_ESAU},
	{EntityType.ENTITY_BLOOD_PUPPY},
	{EntityType.ENTITY_FROZEN_ENEMY}, 		-- Uranus Frozen Enemy
	FiendFolio.ENT("Gravefire"),			-- Gravefire
	FiendFolio.ENT("GorgerAss"),			-- Gorger ass
	FiendFolio.ENT("Cortex"),				-- Cortex
	FiendFolio.ENT("PsiKnightBrain"),		-- Psionic Knight Brain
	FiendFolio.ENT("ToxicKnightBrain"),		-- Toxic Knight Brain
	FiendFolio.ENT("DeadFlyOrbital"),		-- Eternal Fly reimplementation
	FiendFolio.ENT("BolaHead"),				-- Bola Skull
	FiendFolio.ENT("BolaNeck"),				-- Bola Neck
	FiendFolio.ENT("FingoreHand"),			-- Fingore Hand
	FiendFolio.ENT("Cuffs"),				-- Cuffs
	FiendFolio.ENT("WarbleTail"),			-- Warble Tail
	FiendFolio.ENT("LonelyKnightBrain"),	-- Lonely Knight Hurtbox
	FiendFolio.ENT("LonelyKnightShell"),	-- Lonely Knight Hitboxes
	FiendFolio.ENT("Specturn"),				-- Specturn
	FiendFolio.ENT("RiftWalkerGfx"), -- Rift Walker (gfx)
	FiendFolio.ENT("KeyFiend"), -- KeyFiend
	FiendFolio.ENT("DungeonLocker"), -- Dungeon Locker
	FiendFolio.ENT("Thrall"), -- Thrall
	FiendFolio.ENT("FerrWaiting"), -- Waiting Entity Helper
	FiendFolio.ENT("EffigyCord"),
	FiendFolio.ENT("HarletwinCord"),
	FiendFolio.ENT("ThrallCord"),
	FiendFolio.ENT("NerviePoint"),
	FiendFolio.ENT("BadBag"),
	FiendFolio.ENT("TheColorRed"),
	FiendFolio.ENT("WhispersController"),
	{mod.FF.Bloomer.ID, mod.FF.Bloomer.Var},
	FiendFolio.ENT("Fogspawn"),
	{FiendFolio.FF.FreeThinkerMask.ID, FiendFolio.FF.FreeThinkerMask.Var, FiendFolio.FF.FreeThinkerMask.Sub},
	FiendFolio.ENT("Geigerspirit"),
	FiendFolio.ENT("UraniumChunk")
}

----XALUM ENTITY LISTS----

mod.HaemoBlacklist = {
	{EntityType.ENTITY_GLOBIN, -1, -1},
	{EntityType.ENTITY_BLACK_GLOBIN, -1, -1},
	{EntityType.ENTITY_BLOOD_PUPPY, -1, -1},
	{mod.FF.Cortex.ID, mod.FF.Cortex.Var, mod.FF.Cortex.Sub or -1},
	{mod.FF.HaemoGlobin.ID, mod.FF.HaemoGlobin.Var, mod.FF.HaemoGlobin.Sub or -1},
	{mod.FFID.Tech, -1, -1}, -- Type 150: FF Technical Entities
	{EntityType.ENTITY_EVIS, 10, -1}, --Evis Cords

	{mod.FF.Lurker.ID, mod.FF.Lurker.Var, -1},
	{mod.FF.LurkerCore.ID, mod.FF.LurkerCore.Var, -1},
	{mod.FF.LurkerTooth.ID, mod.FF.LurkerTooth.Var, -1},
	{mod.FF.LurkerStoma.ID, mod.FF.LurkerStoma.Var, -1},
	{mod.FF.LurkerStretch.ID, mod.FF.LurkerStretch.Var, -1},
	{mod.FF.LurkerBrain.ID, mod.FF.LurkerBrain.Var, -1},
	{mod.FF.LurkerCollider.ID, mod.FF.LurkerCollider.Var, -1},
	{mod.FF.LurkerStretchCollider.ID, mod.FF.LurkerStretchCollider.Var, -1},
	{mod.FF.LurkerPsuedoDefault.ID, mod.FF.LurkerPsuedoDefault.Var, -1},
	{mod.FF.LurkerBridgeProj.ID, mod.FF.LurkerBridgeProj.Var, -1},

}



----GUWAH ENTITY LISTS----

mod.TommyBlacklist = {
	{mod.FFID.Tech, -1, -1}, --FF Technical Entities
	{mod.FF.FerrWaiting.ID, mod.FF.FerrWaiting.Var, -1}, --Ferrium Waiting Entities
	{mod.FF.BabySpider.ID, mod.FF.BabySpider.Var, -1},
	{mod.FF.Benny.ID, mod.FF.Benny.Var, -1},
	{EntityType.ENTITY_FIREPLACE, -1, -1},
	{EntityType.ENTITY_MOVABLE_TNT, -1, -1},
	{EntityType.ENTITY_EVIS, 10, -1}, --Evis Cords
	{EntityType.ENTITY_BLOOD_PUPPY, -1, -1},
	{EntityType.ENTITY_DARK_ESAU, -1, -1},
	{EntityType.ENTITY_GENERIC_PROP, -1, -1},
	{EntityType.ENTITY_FROZEN_ENEMY, -1, -1},
	{EntityType.ENTITY_SIREN_HELPER, -1, -1},
	{mod.FF.ThrallCord.ID, mod.FF.ThrallCord.Var, mod.FF.ThrallCord.Sub},
	{mod.FF.HarletwinCord.ID, mod.FF.HarletwinCord.Var, mod.FF.HarletwinCord.Sub},
	{mod.FF.EffigyCord.ID, mod.FF.EffigyCord.Var, mod.FF.EffigyCord.Sub},
	{mod.FF.Magnifier.ID, mod.FF.Magnifier.Var, -1},

	{mod.FF.Lurker.ID, mod.FF.Lurker.Var, -1},
	{mod.FF.LurkerCore.ID, mod.FF.LurkerCore.Var, -1},
	{mod.FF.LurkerTooth.ID, mod.FF.LurkerTooth.Var, -1},
	{mod.FF.LurkerStoma.ID, mod.FF.LurkerStoma.Var, -1},
	{mod.FF.LurkerStretch.ID, mod.FF.LurkerStretch.Var, -1},
	{mod.FF.LurkerBrain.ID, mod.FF.LurkerBrain.Var, -1},
	{mod.FF.LurkerCollider.ID, mod.FF.LurkerCollider.Var, -1},
	{mod.FF.LurkerStretchCollider.ID, mod.FF.LurkerStretchCollider.Var, -1},
	{mod.FF.LurkerPsuedoDefault.ID, mod.FF.LurkerPsuedoDefault.Var, -1},
	{mod.FF.LurkerBridgeProj.ID, mod.FF.LurkerBridgeProj.Var, -1},
}

FiendFolio.MothmanBlacklist = {
	{EntityType.ENTITY_FIREPLACE, -1, -1},
	{EntityType.ENTITY_MOVABLE_TNT, -1, -1},
	{EntityType.ENTITY_EVIS, 10, -1}, --Evis Cords
	{EntityType.ENTITY_BLOOD_PUPPY, -1, -1},
	{EntityType.ENTITY_DARK_ESAU, -1, -1},
	{EntityType.ENTITY_GENERIC_PROP, -1, -1},
	{EntityType.ENTITY_FROZEN_ENEMY, -1, -1},
	{EntityType.ENTITY_SIREN_HELPER, -1, -1},
	{mod.FFID.Tech, -1, -1}, --FF Technical Entities
	{mod.FF.FerrWaiting.ID, mod.FF.FerrWaiting.Var, -1}, --Ferrium Waiting Entities
	{mod.FF.ThrallCord.ID, mod.FF.ThrallCord.Var, mod.FF.ThrallCord.Sub},
	{mod.FF.HarletwinCord.ID, mod.FF.HarletwinCord.Var, mod.FF.HarletwinCord.Sub},
	{mod.FF.EffigyCord.ID, mod.FF.EffigyCord.Var, mod.FF.EffigyCord.Sub},

	{mod.FF.Lurker.ID, mod.FF.Lurker.Var, -1},
	{mod.FF.LurkerCore.ID, mod.FF.LurkerCore.Var, -1},
	{mod.FF.LurkerTooth.ID, mod.FF.LurkerTooth.Var, -1},
	{mod.FF.LurkerStoma.ID, mod.FF.LurkerStoma.Var, -1},
	{mod.FF.LurkerStretch.ID, mod.FF.LurkerStretch.Var, -1},
	{mod.FF.LurkerBrain.ID, mod.FF.LurkerBrain.Var, -1},
	{mod.FF.LurkerCollider.ID, mod.FF.LurkerCollider.Var, -1},
	{mod.FF.LurkerStretchCollider.ID, mod.FF.LurkerStretchCollider.Var, -1},
	{mod.FF.LurkerPsuedoDefault.ID, mod.FF.LurkerPsuedoDefault.Var, -1},
	{mod.FF.LurkerBridgeProj.ID, mod.FF.LurkerBridgeProj.Var, -1},
}

FiendFolio.GrimoireBlacklist = {
	{EntityType.ENTITY_FIREPLACE, -1, -1},
	{EntityType.ENTITY_MOVABLE_TNT, -1, -1},
	{EntityType.ENTITY_STONEHEAD, -1, -1}, --Grimaces
	{EntityType.ENTITY_CONSTANT_STONE_SHOOTER, -1, -1},
	{EntityType.ENTITY_BRIMSTONE_HEAD, -1, -1},
	{EntityType.ENTITY_GAPING_MAW, -1, -1},
	{EntityType.ENTITY_BROKEN_GAPING_MAW, -1, -1},
	{EntityType.ENTITY_GRUDGE, -1, -1},
	{EntityType.ENTITY_POKY, -1, -1},
	{EntityType.ENTITY_WALL_HUGGER, -1, -1}, --Also includes Banshee
	{EntityType.ENTITY_BALL_AND_CHAIN, -1, -1},
	{EntityType.ENTITY_EVIS, 10, -1}, --Evis Cords
	{EntityType.ENTITY_BLOOD_PUPPY, -1, -1},
	{EntityType.ENTITY_DARK_ESAU, -1, -1},
	{EntityType.ENTITY_GENERIC_PROP, -1, -1},
	{EntityType.ENTITY_FROZEN_ENEMY, -1, -1},
	{EntityType.ENTITY_SIREN_HELPER, -1, -1},
	{mod.FFID.Tech, -1, -1}, --FF Technical Entities
	{mod.FF.SuperGrimace.ID, mod.FF.SuperGrimace.Var, -1},
	{mod.FF.GlassEye.ID, mod.FF.GlassEye.Var, -1},
	{mod.FF.EyeOfShaggoth.ID, mod.FF.EyeOfShaggoth.Var, -1},
	{mod.FF.Temper.ID, mod.FF.Temper.Var, -1},
	{mod.FF.Congression.ID, mod.FF.Congression.Var, -1},
	{mod.FF.Spook.ID, mod.FF.Spook.Var, -1},
	{mod.FF.FerrWaiting.ID, mod.FF.FerrWaiting.Var, -1}, --Ferrium Waiting Entities
	{mod.FF.ThrallCord.ID, mod.FF.ThrallCord.Var, mod.FF.ThrallCord.Sub},
	{mod.FF.HarletwinCord.ID, mod.FF.HarletwinCord.Var, mod.FF.HarletwinCord.Sub},
	{mod.FF.EffigyCord.ID, mod.FF.EffigyCord.Var, mod.FF.EffigyCord.Sub},
	{mod.FF.Magnifier.ID, mod.FF.Magnifier.Var, -1},

	{mod.FF.Lurker.ID, mod.FF.Lurker.Var, -1},
	{mod.FF.LurkerCore.ID, mod.FF.LurkerCore.Var, -1},
	{mod.FF.LurkerTooth.ID, mod.FF.LurkerTooth.Var, -1},
	{mod.FF.LurkerStoma.ID, mod.FF.LurkerStoma.Var, -1},
	{mod.FF.LurkerStretch.ID, mod.FF.LurkerStretch.Var, -1},
	{mod.FF.LurkerBrain.ID, mod.FF.LurkerBrain.Var, -1},
	{mod.FF.LurkerCollider.ID, mod.FF.LurkerCollider.Var, -1},
	{mod.FF.LurkerStretchCollider.ID, mod.FF.LurkerStretchCollider.Var, -1},
	{mod.FF.LurkerPsuedoDefault.ID, mod.FF.LurkerPsuedoDefault.Var, -1},
	{mod.FF.LurkerBridgeProj.ID, mod.FF.LurkerBridgeProj.Var, -1},
}

FiendFolio.GrimoireLowPriority = {
	{EntityType.ENTITY_SHOPKEEPER, -1, -1},
	{mod.FF.EternalFlickerspirit.ID, mod.FF.EternalFlickerspirit.Var, -1},
	{mod.FF.Tombit.ID, mod.FF.Tombit.Var, -1},
}

FiendFolio.NihilistSlowdownList = {
	{mod.FF.Shaker.ID, mod.FF.Shaker.Var, -1, 6},
	{mod.FF.Banshee.ID, mod.FF.Banshee.Var, -1, 6},
	{mod.FF.Ragurge.ID, mod.FF.Ragurge.Var, -1, 6},
	{EntityType.ENTITY_REVENANT, -1, -1, 6},
}

FiendFolio.SkulltistWhitelist = {
	{mod.FF.AtomicGaper.ID,mod.FF.AtomicGaper.Var,-1,false},
	{EntityType.ENTITY_GLOBIN,-1,-1,true,true},
	{EntityType.ENTITY_BOOMFLY,-1,-1,true,true},
	{EntityType.ENTITY_SUCKER,2,-1,true}, --Soul Sucker
	{EntityType.ENTITY_SUCKER,-1,-1,false},
	{EntityType.ENTITY_FULL_FLY,-1,-1,false},
	{EntityType.ENTITY_BLACK_BONY,-1,-1,false,true},
	{EntityType.ENTITY_POOFER,-1,-1,true},
	{EntityType.ENTITY_MIGRAINE,-1,-1,true,true},
	{EntityType.ENTITY_DUKE,-1,-1,true},
	{EntityType.ENTITY_MULLIGAN,-1,-1,true,true},
	{EntityType.ENTITY_NEST,-1,-1,true,true},
	{EntityType.ENTITY_HIVE,-1,-1,true,true},
	{EntityType.ENTITY_PREY,-1,-1,true,true},
	{EntityType.ENTITY_MEMBRAIN,-1,-1,true,true},
	{EntityType.ENTITY_SQUIRT,-1,-1,true,true},
	{EntityType.ENTITY_TICKING_SPIDER,-1,-1,false,true},
	{EntityType.ENTITY_MAW,1,-1,false,true}, --Red Maw
	{EntityType.ENTITY_MRMAW,3,-1,false,true}, --Mr. Red Maw's Head (why is it a seperate entity?)
	{mod.FF.RedHorf.ID,mod.FF.RedHorf.Var,-1,true}, -- Ch1
	{mod.FF.Drumstick.ID,mod.FF.Drumstick.Var,-1,false},
	{mod.FF.ReheatedTickingFly.ID,mod.FF.ReheatedTickingFly.Var,-1,false},
	{mod.FF.FullSpider.ID,mod.FF.FullSpider.Var,-1,false},
	{mod.FF.Coby.ID,mod.FF.Coby.Var,-1,false},
	{mod.FF.Haunted.ID,mod.FF.Haunted.Var,-1,true},
	{mod.FF.Crotchety.ID,mod.FF.Crotchety.Var,-1,true},
	{mod.FF.Dim.ID,mod.FF.Dim.Var,-1,true},
	{mod.FF.Posssessed.ID,mod.FF.Posssessed.Var,-1,true},
	{mod.FF.Marge.ID,mod.FF.Marge.Var,-1,true},
	{mod.FF.Spitroast.ID,mod.FF.Spitroast.Var,-1,true},
	{mod.FF.Spitfire.ID,mod.FF.Spitfire.Var,-1,true},
	{mod.FF.Crisply.ID,mod.FF.Crisply.Var,-1,true},
	{mod.FF.Mullikaboom.ID,mod.FF.Mullikaboom.Var,-1,false},
	{mod.FF.Powderkeg.ID,mod.FF.Powderkeg.Var,-1,false},
	{mod.FF.BigSmoke.ID,mod.FF.BigSmoke.Var,-1,false},
	{mod.FF.Brisket.ID,mod.FF.Brisket.Var,-1,true},
	{mod.FF.Litling.ID,mod.FF.Litling.Var,-1,false},
	{mod.FF.Mayfly.ID,mod.FF.Mayfly.Var,-1,true}, -- Ch1.5
	{mod.FF.Mightfly.ID,mod.FF.Mightfly.Var,-1,true},
	{mod.FF.GoldenMightfly.ID,mod.FF.GoldenMightfly.Var,-1,true},
	{mod.FF.MiniMinMin.ID,mod.FF.MiniMinMin.Var,-1,true},
	{mod.FF.ShittyHorf.ID,mod.FF.ShittyHorf.Var,-1,true},
	{mod.FF.Trashbagger.ID,mod.FF.Trashbagger.Var,mod.FF.Trashbagger.Sub,true},
	{mod.FF.Blubbie.ID,mod.FF.Blubbie.Var,-1,true},
	{mod.FF.Globlet.ID,mod.FF.Globlet.Var,-1,true}, -- Ch2
	{mod.FF.Fathead.ID,mod.FF.Fathead.Var,-1,true},
	{mod.FF.FossilBoomFly.ID,mod.FF.FossilBoomFly.Var,-1,false},
	{mod.FF.Buddybag.ID,mod.FF.Buddybag.Var,-1,true},
	{mod.FF.Warhead.ID,mod.FF.Warhead.Var,-1,true},
	{mod.FF.Bunch.ID,mod.FF.Bunch.Var,-1,true},
	{mod.FF.Grape.ID,mod.FF.Grape.Var,-1,false},
	{mod.FF.MamaPooter.ID,mod.FF.MamaPooter.Var,-1,true},
	{mod.FF.Desirer.ID,mod.FF.Desirer.Var,-1,true},
	{mod.FF.DesirerWaning.ID,mod.FF.DesirerWaning.Var,-1,true},
	{mod.FF.Indulger.ID,mod.FF.Indulger.Var,-1,true},
	{mod.FF.Dribble.ID,mod.FF.Dribble.Var,-1,true},
	{mod.FF.BubbleBat.ID,mod.FF.BubbleBat.Var,-1,true},
	{mod.FF.Puffer.ID,mod.FF.Puffer.Var,-1,true},
	{mod.FF.Panini.ID,mod.FF.Panini.Var,-1,true},
	{mod.FF.Sizzle.ID,mod.FF.Sizzle.Var,-1,true}, -- Ch2.5
	{mod.FF.Blastcore.ID,mod.FF.Blastcore.Var,-1,true},
	{mod.FF.Rufus.ID,mod.FF.Rufus.Var,-1,true},
	{mod.FF.Ossularry.ID,mod.FF.Ossularry.Var,-1,true},
	{mod.FF.AntiFiend.ID,mod.FF.AntiFiend.Var,-1,true},
	{mod.FF.Scoop.ID,mod.FF.Scoop.Var,-1,true}, -- Ch3
	{mod.FF.Sundae.ID,mod.FF.Sundae.Var,-1,true},
	{mod.FF.SoftServe.ID,mod.FF.SoftServe.Var,-1,true},
	{mod.FF.RedBony.ID,mod.FF.RedBony.Var,-1,false},
	{mod.FF.Splodum.ID,mod.FF.Splodum.Var,-1,false},
	{mod.FF.Gravin.ID, mod.FF.Gravin.Var,-1,false},
	{mod.FF.Carrier.ID,mod.FF.Carrier.Var,-1,true},
	{mod.FF.Baro.ID,mod.FF.Baro.Var,-1,true},
	{mod.FF.Calzone.ID,mod.FF.Calzone.Var,-1,true},
	{mod.FF.Squidge.ID,mod.FF.Squidge.Var,-1,false},
	{mod.FF.Gunk.ID,mod.FF.Gunk.Var,-1,false},
	{mod.FF.Punk.ID,mod.FF.Punk.Var,-1,false},
	{mod.FF.Melty.ID,mod.FF.Melty.Var,-1,true},
	{mod.FF.TrashbaggerDank.ID,mod.FF.TrashbaggerDank.Var,mod.FF.TrashbaggerDank.Sub,true},
	{mod.FF.Empath.ID, mod.FF.Empath.Var,-1,true}, -- Ch3.5
	{mod.FF.ManicFly.ID, mod.FF.ManicFly.Var,-1},
	{mod.FF.Temptress.ID,mod.FF.Temptress.Var,-1,true},
	{mod.FF.DreadMaw.ID,mod.FF.DreadMaw.Var,-1,true},
	{mod.FF.Tagbag.ID,mod.FF.Tagbag.Var,-1,true},
	{mod.FF.Berry.ID,mod.FF.Berry.Var,-1,true}, -- Ch4
	{mod.FF.Warble.ID,mod.FF.Warble.Var,-1,true},
	{mod.FF.Glorf.ID,mod.FF.Glorf.Var,-1,true,false,true},
	{mod.FF.Globwad.ID,mod.FF.Globwad.Var,-1,true},
	{mod.FF.Heartbeat.ID,mod.FF.Heartbeat.Var,-1,true},
	{mod.FF.Jammed.ID,mod.FF.Jammed.Var,-1,true},
	{mod.FF.Trickle.ID,mod.FF.Trickle.Var,-1,true},
	{mod.FF.Dogmeat.ID,mod.FF.Dogmeat.Var,-1,true},
	{mod.FF.HeadHoncho.ID,mod.FF.HeadHoncho.Var,-1,true},
	{mod.FF.Facade.ID,mod.FF.Facade.Var,-1,true},
	{mod.FF.Cellulitis.ID,mod.FF.Cellulitis.Var,-1,-1,true,false},
	{mod.FF.Nailhead.ID,mod.FF.Nailhead.Var,-1,true},
	{mod.FF.Mouthful.ID,mod.FF.Mouthful.Var,-1,true},
	{mod.FF.Coconut.ID,mod.FF.Coconut.Var,-1,true}, -- Ch4.5
	{mod.FF.Nematode.ID,mod.FF.Nematode.Var,-1,true},
	{mod.FF.PsionLeech.ID,mod.FF.PsionLeech.Var,-1,false}, -- Ch5
	{mod.FF.Premonition.ID,mod.FF.Premonition.Var,-1,true},
	{mod.FF.SplitEar.ID,mod.FF.SplitEar.Var,-1,true},
	{mod.FF.Cochlea.ID,mod.FF.Cochlea.Var,-1,true},
	{mod.FF.Toad.ID,mod.FF.Toad.Var,-1,true},
	{mod.FF.EarSplitter.ID,mod.FF.EarSplitter.Var,-1,true},
	{mod.FF.Accursed.ID,mod.FF.Accursed.Var,-1,true}, -- Ch7
	{mod.FF.TaintedCraig.ID,mod.FF.TaintedCraig.Var,-1,true},
}

mod.GridLikeEntities = {
	[mod.FF.BucketheadWait.ID.." "..mod.FF.BucketheadWait.Var.." "..mod.FF.BucketheadWait.Sub] = true,
	[mod.FF.CompostBin.ID.." "..mod.FF.CompostBin.Var.." "..-1] = true,
	[mod.FF.SuperTNT.ID.." "..mod.FF.SuperTNT.Var.." "..-1] = true,
	[mod.FF.ClogmoPipe.ID.." "..mod.FF.ClogmoPipe.Var.." "..-1] = true,
	[mod.FF.ClogmoTunnelHori.ID.." "..mod.FF.ClogmoTunnelHori.Var.." "..-1] = true,
	[mod.FF.ClogmoTunnelVerti.ID.." "..mod.FF.ClogmoTunnelVerti.Var.." "..-1] = true,
}

mod.TomaEnemies = {
	{mod.FF.Foetus.ID, mod.FF.Foetus.Var, -1},
	{mod.FF.ConglobberateSmall.ID, mod.FF.ConglobberateSmall.Var, -1},
	{mod.FF.ConglobberateMedium.ID, mod.FF.ConglobberateMedium.Var, -1},
	{mod.FF.ConglobberateLarge.ID, mod.FF.ConglobberateLarge.Var, -1},
	{mod.FF.TomaChunk.ID, mod.FF.TomaChunk.Var, mod.FF.TomaChunk.Sub, -1},
	{mod.FF.Bub.ID, mod.FF.Bub.Var, -1},
	{mod.FF.Molly.ID, mod.FF.Molly.Var, -1},
	{mod.FF.Steralis.ID, mod.FF.Steralis.Var, -1},
	{mod.FF.Nematode.ID, mod.FF.Nematode.Var, -1},
	{mod.FF.Quitter.ID, mod.FF.Quitter.Var, -1},
}

----FERRIUM ENTITY LISTS----

mod.lunksackBlacklist = { --Used for what Lunksack can't target.
	[mod.FF.Cuffs.ID .. " " .. mod.FF.Cuffs.Var] = true, -- Cuffs
	[13 .. " " .. 0 .. " " .. 250] = true,      --Soundmaker Fly
	[35 .. " " .. 10] = true,		--Mr. Maw Neck
	[79 .. " " .. 20] = true,		--Gemini Cord
	[96] = true,			--Eternal Fly
	[216 .. " " .. 10] = true,		--Swinger Neck
	[EntityType.ENTITY_FROZEN_ENEMY] = true, --Uranus Frozen Enemy
	[mod.FF.Gorger.ID .. " " .. mod.FF.Gorger.Var .. " " .. mod.FF.GorgerAss.Sub] = true,	--Gorger ass
	[mod.FF.EternalFlickerspirit.ID .. " " .. mod.FF.EternalFlickerspirit.Var] = true,		--Eternal Flickerspirit
	[mod.FF.Viscerspirit.ID .. " " .. mod.FF.Viscerspirit.Var] = true,      -- Viscerspirit
	[mod.FF.DeadFlyOrbital.ID .. " " .. mod.FF.DeadFlyOrbital.Var] = true,		--Eternal Fly reimplementation
	[mod.FF.Harletwin.ID .. " " .. mod.FF.Harletwin.Var .. " " .. 1] = true,		--Harletwin Ball
	[mod.FF.Effigy.ID .. " " .. mod.FF.Effigy.Var .. " " .. 1] = true,		--Effigy Ball
	[mod.FF.Bola.ID .. " " .. mod.FF.Bola.Var .. " " .. mod.FF.BolaHead.Sub] = true,	--Bola Skull
	[mod.FF.Bola.ID .. " " .. mod.FF.Bola.Var .. " " .. mod.FF.BolaNeck.Sub] = true,	--Bola Neck
	[mod.FF.FingoreHand.ID .. " " .. mod.FF.FingoreHand.Var] = true,	--Fingore Hand
	[mod.FF.WarbleTail.ID .. " " .. mod.FF.WarbleTail.Var .. " " .. mod.FF.WarbleTail.Sub] = true,	--Warble Tail
	[mod.FF.RiftWalkerGfx.ID .. " " .. mod.FF.RiftWalkerGfx.Var .. " " .. mod.FF.RiftWalkerGfx.Sub] = true,	--Rift Walker (gfx)
	[mod.FF.ThrallCord.ID .. " " .. mod.FF.ThrallCord.Var .. " " .. mod.FF.ThrallCord.Sub] = true,	--Thrall Chain
	[mod.FF.Gravefire.ID .. " " .. mod.FF.Gravefire.Var] = true,	--Gravefire
	[mod.FF.Specturn.ID .. " " .. mod.FF.Specturn.Var] = true,	-- Specturn
	[33] = true,	--Fireplaces
	[42] = true,	--Grimaces
	[mod.FF.FerrWaiting.ID .. " " .. mod.FF.FerrWaiting.Var] = true,	--Ferrium's waiting enemies
	[mod.FF.ShirkSpot.ID .. " " .. mod.FF.ShirkSpot.Var] = true,	--Shirk Spots
	[mod.FF.DungeonLocker.ID .. " " .. mod.FF.DungeonLocker.Var] = true, -- Dungeon Locker
	[mod.FF.KeyFiend.ID .. " " .. mod.FF.KeyFiend.Var] = true,	--Key Fiend
	[44] = true, --Pokies/variants (Includes pipes, grates, and etc)
	[mod.FF.Onlooker.ID .. " " .. mod.FF.Onlooker.Var] = true,	--Onlooker
	[mod.FF.FoetusCord.ID .. " " .. mod.FF.FoetusCord.Var .. " " .. mod.FF.FoetusCord.Sub] = true, --Foetus Cord
	[mod.FF.ThrallCord.ID .. " " .. mod.FF.ThrallCord.Var .. " " .. mod.FF.ThrallCord.Sub] = true,	--Thrall Cord
	[mod.FF.Pawn.ID .. " " .. mod.FF.Pawn.Var .. " " .. 10] = true, --King Cord Hitbox
	[mod.FF.MorvidPerched.ID .. " " .. mod.FF.MorvidPerched.Var .. " " .. mod.FF.MorvidPerched.Sub] = true, --Perched Morvids
	[FiendFolio.FFID.Tech] = true,	--Technical Entities, sorry Bubble fans
	[EntityType.ENTITY_EVIS .. " " .. 10] = true, --Evis Guts / other cords
	[mod.FF.PatzerShell.ID .. " " .. mod.FF.PatzerShell.Var] = true, --Patzer Shell
	[mod.FF.GlassEye.ID .. " " .. mod.FF.GlassEye.Var] = true, --Glass Eye
	[mod.FF.EyeOfShaggoth.ID .. " " .. mod.FF.EyeOfShaggoth.Var] = true, --Eye of Shaggoth
	[mod.FF.Lurker.ID .. " " .. mod.FF.Lurker.Var] = true,
	[mod.FF.LurkerCore.ID .. " " .. mod.FF.LurkerCore.Var] = true,
	[mod.FF.LurkerStoma.ID .. " " .. mod.FF.LurkerStoma.Var] = true,
	[mod.FF.LurkerStretch.ID .. " " .. mod.FF.LurkerStretch.Var] = true,
	[mod.FF.LurkerTooth.ID .. " " .. mod.FF.LurkerTooth.Var] = true,
	[mod.FF.LurkerBrain.ID .. " " .. mod.FF.LurkerBrain.Var] = true,
	[mod.FF.LurkerCollider.ID .. " " .. mod.FF.LurkerCollider.Var] = true,
	[mod.FF.LurkerStretchCollider.ID .. " " .. mod.FF.LurkerStretchCollider.Var] = true,
	[mod.FF.LurkerPsuedoDefault.ID .. " " .. mod.FF.LurkerPsuedoDefault.Var] = true,
	[mod.FF.LurkerBridgeProj.ID .. " " .. mod.FF.LurkerBridgeProj.Var] = true,
	[mod.FF.Magnifier.ID .. " " .. mod.FF.Magnifier.Var] = true,
	[EntityType.ENTITY_DARK_ESAU] = true,	--Dark Esau
	[mod.FF.BadBag.ID .. " " .. mod.FF.BadBag.Var] = true,
	[mod.FF.TheColorRed.ID .. " " .. mod.FF.TheColorRed.Var] = true,
	[mod.FF.WarpCultist.ID .. " " .. mod.FF.WarpCultist.Var] = true,
}

--What can't be selected to orbit.
mod.specturnBlacklist = {
	[mod.FF.Cuffs.ID .. " " .. mod.FF.Cuffs.Var] = true, -- Cuffs
	[13 .. " " .. 0 .. " " .. 250] = true,      --Soundmaker Fly
	[35 .. " " .. 1] = true,		--Mr. Maw Head
	[35 .. " " .. 1] = true,		--Mr. Maw Head
	[35 .. " " .. 3] = true,		--Mr. Red Maw Head
	[35 .. " " .. 10] = true,		--Mr. Maw Neck
	[79 .. " " .. 20] = true,		--Gemini Cord
	[96] = true,			--Eternal Fly
	[216 .. " " .. 1] = true,		--Swinger Head
	[216 .. " " .. 10] = true,		--Swinger Neck
	[EntityType.ENTITY_FROZEN_ENEMY] = true, --Uranus Frozen Enemy
	[mod.FF.Gorger.ID .. " " .. mod.FF.Gorger.Var .. " " .. mod.FF.GorgerAss.Sub] = true,	--Gorger ass
	[mod.FF.Cortex.ID .. " " .. mod.FF.Cortex.Var] = true,		--Cortex
	[mod.FF.PsiKnight.ID .. " " .. mod.FF.PsiKnight.Var] = true,	--Psionic Knights
	[mod.FF.ToxicKnight.ID .. " " .. mod.FF.ToxicKnight.Var .. " " .. 0] = true,	--Toxic Knight Husk
	[mod.FF.EternalFlickerspirit.ID .. " " .. mod.FF.EternalFlickerspirit.Var] = true,		--Eternal Flickerspirit
	[mod.FF.Viscerspirit.ID .. " " .. mod.FF.Viscerspirit.Var] = true,      -- Viscerspirit
	[mod.FF.DeadFlyOrbital.ID .. " " .. mod.FF.DeadFlyOrbital.Var] = true,		--Eternal Fly reimplementation
	[mod.FF.Harletwin.ID .. " " .. mod.FF.Harletwin.Var .. " " .. 1] = true,		--Harletwin Ball
	[mod.FF.Effigy.ID .. " " .. mod.FF.Effigy.Var .. " " .. 1] = true,		--Effigy Ball
	[mod.FF.Bola.ID .. " " .. mod.FF.Bola.Var .. " " .. mod.FF.BolaHead.Sub] = true,	--Bola Skull
	[mod.FF.Bola.ID .. " " .. mod.FF.Bola.Var .. " " .. mod.FF.BolaNeck.Sub] = true,	--Bola Neck
	[mod.FF.FingoreHand.ID .. " " .. mod.FF.FingoreHand.Var] = true,	--Fingore Hand
	[811] = true,	--Deep Gaper
	[mod.FF.WarbleTail.ID .. " " .. mod.FF.WarbleTail.Var .. " " .. mod.FF.WarbleTail.Sub] = true,	--Warble Tail
	[mod.FF.RiftWalkerGfx.ID .. " " .. mod.FF.RiftWalkerGfx.Var .. " " .. mod.FF.RiftWalkerGfx.Sub] = true,	--Rift Walker (gfx)
	[mod.FF.ThrallCord.ID .. " " .. mod.FF.ThrallCord.Var .. " " .. mod.FF.ThrallCord.Sub] = true,	--Thrall Chain
	[mod.FF.Gravefire.ID .. " " .. mod.FF.Gravefire.Var] = true,	--Gravefire
	[mod.FF.Specturn.ID .. " " .. mod.FF.Specturn.Var] = true,	-- Specturn
	[33] = true,	--Fireplaces
	[42] = true,	--Grimaces
	[mod.FF.FerrWaiting.ID .. " " .. mod.FF.FerrWaiting.Var] = true,	--Ferrium's waiting enemies
	[mod.FF.ShirkSpot.ID .. " " .. mod.FF.ShirkSpot.Var] = true,	--Shirk Spots
	[mod.FF.Shirk.ID .. " " .. mod.FF.Shirk.Var] = true,	--Shirks
	[mod.FF.DungeonLocker.ID .. " " .. mod.FF.DungeonLocker.Var] = true, -- Dungeon Locker
	[mod.FF.KeyFiend.ID .. " " .. mod.FF.KeyFiend.Var] = true,	--Key Fiend
	[17] = true,	--Shopkeepers
	[mod.FF.Sternum.ID .. " " .. mod.FF.Sternum.Var] = true, --Sternum
	[mod.FF.Splodum.ID .. " " .. mod.FF.Splodum.Var] = true, --Splodum
	[mod.FF.Whispers.ID .. " " .. mod.FF.Whispers.Var] = true, --Whispers
	[mod.FF.WhispersController.ID .. " " .. mod.FF.WhispersController.Var] = true, --Whispers Controller
	[EntityType.ENTITY_BOIL] = true, --Vanilla stuff that sets its position constantly.
	[EntityType.ENTITY_TARBOY] = true,
	[EntityType.ENTITY_FRED] = true,
	[EntityType.ENTITY_EYE] = true,
	[EntityType.ENTITY_COD_WORM] = true,
	[EntityType.ENTITY_NERVE_ENDING] = true,
	[EntityType.ENTITY_GRUB] = true,
	[EntityType.ENTITY_WALL_CREEP] = true,
	[EntityType.ENTITY_BLIND_CREEP] = true,
	[EntityType.ENTITY_RAGE_CREEP] = true,
	[EntityType.ENTITY_THE_THING] = true,
	[EntityType.ENTITY_ROUND_WORM] = true,
	[EntityType.ENTITY_ROUNDY] = true,
	[EntityType.ENTITY_ULCER] = true,
	[EntityType.ENTITY_NIGHT_CRAWLER] = true,
	[EntityType.ENTITY_MUSHROOM] = true,
	[EntityType.ENTITY_PORTAL] = true,
	[EntityType.ENTITY_LARRYJR] = true,
	[EntityType.ENTITY_MEGA_MAW] = true,
	[EntityType.ENTITY_BIG_HORN] = true,
	[EntityType.ENTITY_STAIN] = true,
	[EntityType.ENTITY_CHUB] = true,
	[EntityType.ENTITY_GURDY] = true,
	[EntityType.ENTITY_POLYCEPHALUS] = true,
	[EntityType.ENTITY_GATE] = true,
	[EntityType.ENTITY_MOM] = true,
	[EntityType.ENTITY_MOMS_HEART] = true,
	[EntityType.ENTITY_DADDYLONGLEGS] = true,
	[EntityType.ENTITY_MAMA_GURDY] = true,
	[EntityType.ENTITY_MR_FRED] = true,
	[EntityType.ENTITY_HUSH] = true,
	[EntityType.ENTITY_SATAN] = true,
	[EntityType.ENTITY_ISAAC] = true,
	[EntityType.ENTITY_THE_LAMB] = true,
	[260 .. " " .. 0] = true, --The Haunt
	[38 .. " " .. 3] = true, --Wrinkly Babies
	[40] = true, --Guts
	[44] = true, --Pokies/variants (Includes pipes, grates, and etc)
	[52] = true, --Doples
	[56] = true, --Lumps
	[35] = true, --Mr. Maws
	[mod.FF.Unshornz.ID .. " " .. mod.FF.Unshornz.Var] = true,	--Unshornz
	[mod.FF.Onlooker.ID .. " " .. mod.FF.Onlooker.Var] = true,	--Onlooker
	[mod.FF.FoetusCord.ID .. " " .. mod.FF.FoetusCord.Var .. " " .. mod.FF.FoetusCord.Sub] = true, --Foetus Cord
	[mod.FF.ThrallCord.ID .. " " .. mod.FF.ThrallCord.Var .. " " .. mod.FF.ThrallCord.Sub] = true,	--Thrall Cord
	[mod.FF.Pawn.ID .. " " .. mod.FF.Pawn.Var .. " " .. 10] = true, --King Cord Hitbox
	[mod.FF.MorvidPerched.ID .. " " .. mod.FF.MorvidPerched.Var .. " " .. mod.FF.MorvidPerched.Sub] = true, --Perched Morvids
	[FiendFolio.FFID.Tech] = true,	--Technical Entities, sorry Bubble fans
	[EntityType.ENTITY_EVIS .. " " .. 10] = true, --Evis Guts / other cords
	[mod.FF.Lurker.ID .. " " .. mod.FF.Lurker.Var] = true,
	[mod.FF.LurkerCore.ID .. " " .. mod.FF.LurkerCore.Var] = true,
	[mod.FF.LurkerStoma.ID .. " " .. mod.FF.LurkerStoma.Var] = true,
	[mod.FF.LurkerStretch.ID .. " " .. mod.FF.LurkerStretch.Var] = true,
	[mod.FF.LurkerTooth.ID .. " " .. mod.FF.LurkerTooth.Var] = true,
	[mod.FF.LurkerBrain.ID .. " " .. mod.FF.LurkerBrain.Var] = true,
	[mod.FF.LurkerCollider.ID .. " " .. mod.FF.LurkerCollider.Var] = true,
	[mod.FF.LurkerStretchCollider.ID .. " " .. mod.FF.LurkerStretchCollider.Var] = true,
	[mod.FF.LurkerPsuedoDefault.ID .. " " .. mod.FF.LurkerPsuedoDefault.Var] = true,
	[mod.FF.LurkerBridgeProj.ID .. " " .. mod.FF.LurkerBridgeProj.Var] = true,
	[mod.FF.Magnifier.ID .. " " .. mod.FF.Magnifier.Var] = true,
	[EntityType.ENTITY_DARK_ESAU] = true,	--Dark Esau
	[mod.FF.Patzer.ID .. " " .. mod.FF.Patzer.Var] = true, --Patzer
	[mod.FF.PatzerShell.ID .. " " .. mod.FF.PatzerShell.Var] = true, --Patzer Shell
	--[mod.FF.BadBag.ID .. " " .. mod.FF.BadBag.Var] = true,
	[mod.FF.Fogspawn.ID .. " " .. mod.FF.Fogspawn.Var] = true,
}

--What can't be selected as a Specturn Host.
mod.specturnBlacklist2 = {
	[mod.FF.Cuffs.ID .. " " .. mod.FF.Cuffs.Var] = true, -- Cuffs
	[13 .. " " .. 0 .. " " .. 250] = true,      --Soundmaker Fly
	[35 .. " " .. 10] = true,		--Mr. Maw Neck
	[79 .. " " .. 20] = true,		--Gemini Cord
	[96] = true,			--Eternal Fly
	[216 .. " " .. 10] = true,		--Swinger Neck
	[409 .. " " .. 1] = true,		--Rag Mega's Balls
	[EntityType.ENTITY_FROZEN_ENEMY] = true, --Uranus Frozen Enemy
	[mod.FF.Gorger.ID .. " " .. mod.FF.Gorger.Var .. " " .. mod.FF.GorgerAss.Sub] = true,	--Gorger ass
	[mod.FF.Cortex.ID .. " " .. mod.FF.Cortex.Var] = true,		--Cortex
	[mod.FF.PsiKnight.ID .. " " .. mod.FF.PsiKnight.Var .. " " .. 0] = true,	--Psionic Knight Husk
	[mod.FF.ToxicKnight.ID .. " " .. mod.FF.ToxicKnight.Var .. " " .. 0] = true,	--Toxic Knight Husk
	[mod.FF.EternalFlickerspirit.ID .. " " .. mod.FF.EternalFlickerspirit.Var] = true,		--Eternal Flickerspirit
	[mod.FF.Viscerspirit.ID .. " " .. mod.FF.Viscerspirit.Var] = true,      -- Viscerspirit
	[mod.FF.DeadFlyOrbital.ID .. " " .. mod.FF.DeadFlyOrbital.Var] = true,		--Eternal Fly reimplementation
	[mod.FF.Harletwin.ID .. " " .. mod.FF.Harletwin.Var .. " " .. 1] = true,		--Harletwin Ball
	[mod.FF.Effigy.ID .. " " .. mod.FF.Effigy.Var .. " " .. 1] = true,		--Effigy Ball
	[mod.FF.Bola.ID .. " " .. mod.FF.Bola.Var .. " " .. mod.FF.BolaHead.Sub] = true,	--Bola Skull
	[mod.FF.Bola.ID .. " " .. mod.FF.Bola.Var .. " " .. mod.FF.BolaNeck.Sub] = true,	--Bola Neck
	[mod.FF.FingoreHand.ID .. " " .. mod.FF.FingoreHand.Var] = true,	--Fingore Hand
	[mod.FF.KeyFiend.ID .. " " .. mod.FF.KeyFiend.Var] = true,	--Key Fiend
	[mod.FF.DungeonLocker.ID .. " " .. mod.FF.DungeonLocker.Var] = true, -- Dungeon Locker
	[811] = true,	--Deep Gaper
	[mod.FF.WarbleTail.ID .. " " .. mod.FF.WarbleTail.Var .. " " .. mod.FF.WarbleTail.Sub] = true,	--Warble Tail
	[mod.FF.RiftWalkerGfx.ID .. " " .. mod.FF.RiftWalkerGfx.Var .. " " .. mod.FF.RiftWalkerGfx.Sub] = true,	--Rift Walker (gfx)
	[mod.FF.ThrallCord.ID .. " " .. mod.FF.ThrallCord.Var .. " " .. mod.FF.ThrallCord.Sub] = true,	--Thrall Chain
	[mod.FF.Gravefire.ID .. " " .. mod.FF.Gravefire.Var] = true,	--Gravefire
	[mod.FF.Specturn.ID .. " " .. mod.FF.Specturn.Var] = true,	-- Specturn
	[mod.FF.FerrWaiting.ID .. " " .. mod.FF.FerrWaiting.Var] = true,	--Ferrium's waiting enemies
	[mod.FF.Lurker.ID .. " " .. mod.FF.Lurker.Var] = true,
	[mod.FF.LurkerStretch.ID .. " " .. mod.FF.LurkerStretch.Var] = true,
	[mod.FF.LurkerBrain.ID .. " " .. mod.FF.LurkerBrain.Var] = true,
	[mod.FF.LurkerCollider.ID .. " " .. mod.FF.LurkerCollider.Var] = true,
	[mod.FF.LurkerStretchCollider.ID .. " " .. mod.FF.LurkerStretchCollider.Var] = true,
	[mod.FF.LurkerBridgeProj.ID .. " " .. mod.FF.LurkerBridgeProj.Var] = true,
	[mod.FF.Whispers.ID .. " " .. mod.FF.Whispers.Var] = true, --Whispers
	[EntityType.ENTITY_DARK_ESAU] = true,	--Dark Esau
	[mod.FF.PatzerShell.ID .. " " .. mod.FF.PatzerShell.Var] = true, --Patzer Shell
	[mod.FF.BadBag.ID .. " " .. mod.FF.BadBag.Var] = true,
	[792 .. " " .. 1889] = true, -- Retribution Dummy NPC
	[mod.FF.Fogspawn.ID .. " " .. mod.FF.Fogspawn.Var] = true,
	[150 .. " " .. 1000] = true, --Backdrop replacer
}

mod.alfilBlacklist = {
	[mod.FF.Cuffs.ID .. " " .. mod.FF.Cuffs.Var] = true, -- Cuffs
	[13 .. " " .. 0 .. " " .. 250] = true,      --Soundmaker Fly
	[35 .. " " .. 10] = true,		--Mr. Maw Neck
	[79 .. " " .. 20] = true,		--Gemini Cord
	[96] = true,			--Eternal Fly
	[216 .. " " .. 10] = true,		--Swinger Neck
	[EntityType.ENTITY_FROZEN_ENEMY] = true, --Uranus Frozen Enemy
	[mod.FF.Gorger.ID .. " " .. mod.FF.Gorger.Var .. " " .. mod.FF.GorgerAss.Sub] = true,	--Gorger ass
	[mod.FF.EternalFlickerspirit.ID .. " " .. mod.FF.EternalFlickerspirit.Var] = true,		--Eternal Flickerspirit
	[mod.FF.Viscerspirit.ID .. " " .. mod.FF.Viscerspirit.Var] = true,      -- Viscerspirit
	[mod.FF.DeadFlyOrbital.ID .. " " .. mod.FF.DeadFlyOrbital.Var] = true,		--Eternal Fly reimplementation
	[mod.FF.Harletwin.ID .. " " .. mod.FF.Harletwin.Var .. " " .. 1] = true,		--Harletwin Ball
	[mod.FF.Effigy.ID .. " " .. mod.FF.Effigy.Var .. " " .. 1] = true,		--Effigy Ball
	[mod.FF.Bola.ID .. " " .. mod.FF.Bola.Var .. " " .. mod.FF.BolaHead.Sub] = true,	--Bola Skull
	[mod.FF.Bola.ID .. " " .. mod.FF.Bola.Var .. " " .. mod.FF.BolaNeck.Sub] = true,	--Bola Neck
	[mod.FF.FingoreHand.ID .. " " .. mod.FF.FingoreHand.Var] = true,	--Fingore Hand
	[mod.FF.WarbleTail.ID .. " " .. mod.FF.WarbleTail.Var .. " " .. mod.FF.WarbleTail.Sub] = true,	--Warble Tail
	[mod.FF.RiftWalkerGfx.ID .. " " .. mod.FF.RiftWalkerGfx.Var .. " " .. mod.FF.RiftWalkerGfx.Sub] = true,	--Rift Walker (gfx)
	[mod.FF.ThrallCord.ID .. " " .. mod.FF.ThrallCord.Var .. " " .. mod.FF.ThrallCord.Sub] = true,	--Thrall Chain
	[mod.FF.Gravefire.ID .. " " .. mod.FF.Gravefire.Var] = true,	--Gravefire
	[mod.FF.Specturn.ID .. " " .. mod.FF.Specturn.Var] = true,	-- Specturn
	[33] = true,	--Fireplaces
	[42] = true,	--Grimaces
	[202] = true,	--Stone Shooters
	[235] = true, -- Gaping Maws
	[236] = true, -- Broken Gaping Maws
	[302] = true, -- Stoney
	[mod.FF.FerrWaiting.ID .. " " .. mod.FF.FerrWaiting.Var] = true,	--Ferrium's waiting enemies
	[mod.FF.ShirkSpot.ID .. " " .. mod.FF.ShirkSpot.Var] = true,	--Shirk Spots
	[mod.FF.DungeonLocker.ID .. " " .. mod.FF.DungeonLocker.Var] = true, -- Dungeon Locker
	[mod.FF.KeyFiend.ID .. " " .. mod.FF.KeyFiend.Var] = true,	--Key Fiend
	[44] = true, --Pokies/variants (Includes pipes, grates, and etc)
	[mod.FF.Onlooker.ID .. " " .. mod.FF.Onlooker.Var] = true,	--Onlooker
	[mod.FF.FoetusCord.ID .. " " .. mod.FF.FoetusCord.Var .. " " .. mod.FF.FoetusCord.Sub] = true, --Foetus Cord
	[mod.FF.ThrallCord.ID .. " " .. mod.FF.ThrallCord.Var .. " " .. mod.FF.ThrallCord.Sub] = true,	--Thrall Cord
	[mod.FF.Pawn.ID .. " " .. mod.FF.Pawn.Var .. " " .. 10] = true, --King Cord Hitbox
	[mod.FF.MorvidPerched.ID .. " " .. mod.FF.MorvidPerched.Var .. " " .. mod.FF.MorvidPerched.Sub] = true, --Perched Morvids
	[FiendFolio.FFID.Tech] = true,	--Technical Entities, sorry Bubble fans
	[EntityType.ENTITY_EVIS .. " " .. 10] = true, --Evis Guts / other cords
	[mod.FF.PatzerShell.ID .. " " .. mod.FF.PatzerShell.Var] = true, --Patzer Shell
	[mod.FF.GlassEye.ID .. " " .. mod.FF.GlassEye.Var] = true, --Glass Eye
	[mod.FF.EyeOfShaggoth.ID .. " " .. mod.FF.EyeOfShaggoth.Var] = true, --Eye of Shaggoth
	[mod.FF.Lurker.ID .. " " .. mod.FF.Lurker.Var] = true,
	[mod.FF.LurkerCore.ID .. " " .. mod.FF.LurkerCore.Var] = true,
	[mod.FF.LurkerStoma.ID .. " " .. mod.FF.LurkerStoma.Var] = true,
	[mod.FF.LurkerStretch.ID .. " " .. mod.FF.LurkerStretch.Var] = true,
	[mod.FF.LurkerTooth.ID .. " " .. mod.FF.LurkerTooth.Var] = true,
	[mod.FF.LurkerBrain.ID .. " " .. mod.FF.LurkerBrain.Var] = true,
	[mod.FF.LurkerCollider.ID .. " " .. mod.FF.LurkerCollider.Var] = true,
	[mod.FF.LurkerStretchCollider.ID .. " " .. mod.FF.LurkerStretchCollider.Var] = true,
	[mod.FF.LurkerPsuedoDefault.ID .. " " .. mod.FF.LurkerPsuedoDefault.Var] = true,
	[mod.FF.LurkerBridgeProj.ID .. " " .. mod.FF.LurkerBridgeProj.Var] = true,
	[EntityType.ENTITY_DARK_ESAU] = true,	--Dark Esau
	[805] = true, --Bishops
	[mod.FF.Cherubskull.ID .. " " .. mod.FF.Cherubskull.Var] = true,
	[mod.FF.CherubskullChain.ID .. " " .. mod.FF.CherubskullChain.Var] = true,
	[mod.FF.Magnifier.ID .. " " .. mod.FF.Magnifier.Var] = true,
	[212 .. " " .. 0] = true,
	[212 .. " " .. 3] = true,
	[EntityType.ENTITY_DARK_ESAU] = true,	--Dark Esau
	[EntityType.ENTITY_BLOOD_PUPPY] = true,	--Blood Puppy
	[mod.FF.Tombit.ID .. " " .. mod.FF.Tombit.Var] = true,
	[mod.FF.BadBag.ID .. " " .. mod.FF.BadBag.Var] = true,
	[792 .. " " .. 1889] = true, -- Retribution Dummy NPC
	[mod.FF.TheColorRed.ID .. " " .. mod.FF.TheColorRed.Var] = true,
	[mod.FF.SuperGrimace.ID .. " " .. mod.FF.SuperGrimace.Var] = true,
	[mod.FF.Frowny.ID .. " " .. mod.FF.Frowny.Var] = true,
	[mod.FF.BellBoy.ID .. " " .. mod.FF.BellBoy.Var] = true,
	[mod.FF.Fogspawn.ID .. " " .. mod.FF.Fogspawn.Var] = true,
	[893] = true, -- Spike Ball and Chain
	[mod.FF.Enlightened.ID .. " " .. mod.FF.Enlightened.Var .. " " .. mod.FF.Unenlightened.Sub] = true,	-- Unenlightened
	[mod.FF.DungeonMaster.ID .. " " .. mod.FF.DungeonMaster.Var] = true, -- Dungeon Master
}


----TAIGA ENTITY LISTS----

-- Prevents enemies from being connected to by Cuffs
mod.CuffsBlacklist = {
	[mod.FF.Cuffs.ID .. " " .. mod.FF.Cuffs.Var] = true, -- Cuffs
	[13 .. " " .. 0 .. " " .. 250] = true,      --Soundmaker Fly
	[35 .. " " .. 1] = true,		--Mr. Maw Head
	[35 .. " " .. 1] = true,		--Mr. Maw Head
	[35 .. " " .. 3] = true,		--Mr. Red Maw Head
	[35 .. " " .. 10] = true,		--Mr. Maw Neck
	[79 .. " " .. 20] = true,		--Gemini Cord
	[96] = true,			--Eternal Fly
	[216 .. " " .. 1] = true,		--Swinger Head
	[216 .. " " .. 10] = true,		--Swinger Neck
	[409 .. " " .. 1] = true,		--Rag Mega's Balls
	[805] = true,					--Bishops
	[EntityType.ENTITY_FROZEN_ENEMY] = true, --Uranus Frozen Enemy
	[mod.FF.Gorger.ID .. " " .. mod.FF.Gorger.Var .. " " .. mod.FF.GorgerAss.Sub] = true,	--Gorger ass
	[mod.FF.Cortex.ID .. " " .. mod.FF.Cortex.Var] = true,		--Cortex
	[mod.FF.PsiKnight.ID .. " " .. mod.FF.PsiKnight.Var .. " " .. 0] = true,	--Psionic Knight Husk
	[mod.FF.ToxicKnight.ID .. " " .. mod.FF.ToxicKnight.Var .. " " .. 0] = true,	--Toxic Knight Husk
	[mod.FF.EternalFlickerspirit.ID .. " " .. mod.FF.EternalFlickerspirit.Var] = true,		--Eternal Flickerspirit
	[mod.FF.Viscerspirit.ID .. " " .. mod.FF.Viscerspirit.Var] = true,      -- Viscerspirit
	[mod.FF.DeadFlyOrbital.ID .. " " .. mod.FF.DeadFlyOrbital.Var] = true,		--Eternal Fly reimplementation
	[mod.FF.Harletwin.ID .. " " .. mod.FF.Harletwin.Var .. " " .. 1] = true,		--Harletwin Ball
	[mod.FF.Effigy.ID .. " " .. mod.FF.Effigy.Var .. " " .. 1] = true,		--Effigy Ball
	[mod.FF.Bola.ID .. " " .. mod.FF.Bola.Var .. " " .. mod.FF.BolaHead.Sub] = true,	--Bola Skull
	[mod.FF.Bola.ID .. " " .. mod.FF.Bola.Var .. " " .. mod.FF.BolaNeck.Sub] = true,	--Bola Neck
	[mod.FF.FingoreHand.ID .. " " .. mod.FF.FingoreHand.Var] = true,	--Fingore Hand
	[mod.FF.KeyFiend.ID .. " " .. mod.FF.KeyFiend.Var] = true,	--Key Fiend
	[mod.FF.DungeonLocker.ID .. " " .. mod.FF.DungeonLocker.Var] = true, -- Dungeon Locker
	[811] = true,	--Deep Gaper
	[mod.FF.WarbleTail.ID .. " " .. mod.FF.WarbleTail.Var .. " " .. mod.FF.WarbleTail.Sub] = true,	--Warble Tail
	[mod.FF.RiftWalkerGfx.ID .. " " .. mod.FF.RiftWalkerGfx.Var .. " " .. mod.FF.RiftWalkerGfx.Sub] = true,	--Rift Walker (gfx)
	[mod.FF.ThrallCord.ID .. " " .. mod.FF.ThrallCord.Var .. " " .. mod.FF.ThrallCord.Sub] = true,	--Thrall Chain
	[mod.FF.Gravefire.ID .. " " .. mod.FF.Gravefire.Var] = true,	--Gravefire
	[mod.FF.Specturn.ID .. " " .. mod.FF.Specturn.Var] = true,	-- Specturn
	[mod.FF.FerrWaiting.ID .. " " .. mod.FF.FerrWaiting.Var] = true,	--Ferrium's waiting enemies
	[mod.FF.Cherubskull.ID .. " " .. mod.FF.Cherubskull.Var] = true,	--Cherubskull (so that it connects to the Hand, neat interaction)
	[mod.FF.Magnifier.ID .. " " .. mod.FF.Magnifier.Var] = true,	--Cherubskull (so that it connects to the Hand, neat interaction)
	[EntityType.ENTITY_DARK_ESAU] = true,	--Dark Esau
	[EntityType.ENTITY_BLOOD_PUPPY] = true,	--Blood Puppy
	[792 .. " " .. 1889] = true, -- Retribution Dummy NPC
	[mod.FF.BadBag.ID .. " " .. mod.FF.BadBag.Var] = true,
	[mod.FF.TheColorRed.ID .. " " .. mod.FF.TheColorRed.Var] = true,
	[mod.FF.Fogspawn.ID .. " " .. mod.FF.Fogspawn.Var] = true,
}

-- Prevents Empath from responding to the deaths of these enemies
mod.EmpathBlacklist = {
	[mod.FF.Cuffs.ID .. " " .. mod.FF.Cuffs.Var] = true, -- Cuffs
	[EntityType.ENTITY_SWINGER .. " " .. 10] = true,		--Swinger Neck
	[EntityType.ENTITY_FROZEN_ENEMY] = true, --Uranus Frozen Enemy
	[mod.FF.Gorger.ID .. " " .. mod.FF.Gorger.Var .. " " .. mod.FF.GorgerAss.Sub] = true,	--Gorger ass
	[mod.FF.Cortex.ID .. " " .. mod.FF.Cortex.Var] = true,		--Cortex
	[mod.FF.PsiKnight.ID .. " " .. mod.FF.PsiKnight.Var .. " " .. 0] = true,	--Psionic Knight Husk
	[mod.FF.ToxicKnight.ID .. " " .. mod.FF.ToxicKnight.Var .. " " .. 0] = true,	--Toxic Knight Husk
	[mod.FF.EternalFlickerspirit.ID .. " " .. mod.FF.EternalFlickerspirit.Var] = true,		--Eternal Flickerspirit
	[mod.FF.Viscerspirit.ID .. " " .. mod.FF.Viscerspirit.Var] = true,      -- Viscerspirit
	[mod.FF.Harletwin.ID .. " " .. mod.FF.Harletwin.Var .. " " .. 1] = true,		--Harletwin Ball
	[mod.FF.Effigy.ID .. " " .. mod.FF.Effigy.Var .. " " .. 1] = true,		--Effigy Ball
	[mod.FF.Bola.ID .. " " .. mod.FF.Bola.Var .. " " .. mod.FF.BolaHead.Sub] = true,	--Bola Skull
	[mod.FF.Bola.ID .. " " .. mod.FF.Bola.Var .. " " .. mod.FF.BolaNeck.Sub] = true,	--Bola Neck
	[mod.FF.FingoreHand.ID .. " " .. mod.FF.FingoreHand.Var] = true,	--Fingore Hand
	[EntityType.ENTITY_MOVABLE_TNT] = true,	--Movable TNT
	[EntityType.ENTITY_FIREPLACE] = true,	--Fireplace
	[EntityType.ENTITY_STONEHEAD] = true, -- Grimace
	[EntityType.ENTITY_POKY] = true, -- Poky
	[EntityType.ENTITY_STONE_EYE] = true, -- Stone Eye
	[EntityType.ENTITY_CONSTANT_STONE_SHOOTER] = true, -- Constant Stone Shooter
	[EntityType.ENTITY_BRIMSTONE_HEAD] = true, -- Brimstone Head
	[EntityType.ENTITY_WALL_HUGGER] = true, -- Wall Hugger
	[EntityType.ENTITY_QUAKE_GRIMACE] = true, -- Quake Grimace
	[EntityType.ENTITY_BOMB_GRIMACE] = true, -- Bomb Grimace
	[EntityType.ENTITY_GRUDGE] = true, -- Grudge
	[EntityType.ENTITY_BOMBDROP] = true, -- Troll Bombs
	[792 .. " " .. 1889] = true, -- Retribution Dummy NPC
}

--What can't be selected to be summoned by the Summoning Circle
mod.SummonsBlacklist = {
	[mod.FF.Cuffs.ID .. " " .. mod.FF.Cuffs.Var] = true, -- Cuffs
	[13 .. " " .. 0 .. " " .. 250] = true,      --Soundmaker Fly
	[35 .. " " .. 10] = true,		--Mr. Maw Neck
	[79 .. " " .. 20] = true,		--Gemini Cord
	[96] = true,			--Eternal Fly
	[216 .. " " .. 10] = true,		--Swinger Neck
	[409 .. " " .. 1] = true,		--Rag Mega's Balls
	[EntityType.ENTITY_FROZEN_ENEMY] = true, --Uranus Frozen Enemy
	[mod.FF.Gorger.ID .. " " .. mod.FF.Gorger.Var .. " " .. mod.FF.GorgerAss.Sub] = true,	--Gorger ass
	[mod.FF.Cortex.ID .. " " .. mod.FF.Cortex.Var] = true,		--Cortex
	[mod.FF.PsiKnight.ID .. " " .. mod.FF.PsiKnight.Var .. " " .. 0] = true,	--Psionic Knight Husk
	[mod.FF.ToxicKnight.ID .. " " .. mod.FF.ToxicKnight.Var .. " " .. 0] = true,	--Toxic Knight Husk
	[mod.FF.EternalFlickerspirit.ID .. " " .. mod.FF.EternalFlickerspirit.Var] = true,		--Eternal Flickerspirit
	[mod.FF.Viscerspirit.ID .. " " .. mod.FF.Viscerspirit.Var] = true,      -- Viscerspirit
	[mod.FF.DeadFlyOrbital.ID .. " " .. mod.FF.DeadFlyOrbital.Var] = true,		--Eternal Fly reimplementation
	[mod.FF.Harletwin.ID .. " " .. mod.FF.Harletwin.Var .. " " .. 1] = true,		--Harletwin Ball
	[mod.FF.Effigy.ID .. " " .. mod.FF.Effigy.Var .. " " .. 1] = true,		--Effigy Ball
	[mod.FF.Bola.ID .. " " .. mod.FF.Bola.Var .. " " .. mod.FF.BolaHead.Sub] = true,	--Bola Skull
	[mod.FF.Bola.ID .. " " .. mod.FF.Bola.Var .. " " .. mod.FF.BolaNeck.Sub] = true,	--Bola Neck
	[mod.FF.FingoreHand.ID .. " " .. mod.FF.FingoreHand.Var] = true,	--Fingore Hand
	[mod.FF.KeyFiend.ID .. " " .. mod.FF.KeyFiend.Var] = true,	--Key Fiend
	[mod.FF.DungeonLocker.ID .. " " .. mod.FF.DungeonLocker.Var] = true, -- Dungeon Locker
	[811] = true,	--Deep Gaper
	[mod.FF.WarbleTail.ID .. " " .. mod.FF.WarbleTail.Var .. " " .. mod.FF.WarbleTail.Sub] = true,	--Warble Tail
	[mod.FF.RiftWalkerGfx.ID .. " " .. mod.FF.RiftWalkerGfx.Var .. " " .. mod.FF.RiftWalkerGfx.Sub] = true,	--Rift Walker (gfx)
	[mod.FF.ThrallCord.ID .. " " .. mod.FF.ThrallCord.Var .. " " .. mod.FF.ThrallCord.Sub] = true,	--Thrall Chain
	[mod.FF.Gravefire.ID .. " " .. mod.FF.Gravefire.Var] = true,	--Gravefire
	[mod.FF.Specturn.ID .. " " .. mod.FF.Specturn.Var] = true,	-- Specturn
	[mod.FF.FerrWaiting.ID .. " " .. mod.FF.FerrWaiting.Var] = true,	--Ferrium's waiting enemies
	[mod.FF.Lurker.ID .. " " .. mod.FF.Lurker.Var] = true,
	[mod.FF.LurkerStretch.ID .. " " .. mod.FF.LurkerStretch.Var] = true,
	[mod.FF.LurkerBrain.ID .. " " .. mod.FF.LurkerBrain.Var] = true,
	[mod.FF.LurkerCollider.ID .. " " .. mod.FF.LurkerCollider.Var] = true,
	[mod.FF.LurkerStretchCollider.ID .. " " .. mod.FF.LurkerStretchCollider.Var] = true,
	[mod.FF.LurkerBridgeProj.ID .. " " .. mod.FF.LurkerBridgeProj.Var] = true,
	[mod.FF.Whispers.ID .. " " .. mod.FF.Whispers.Var] = true, --Whispers
	[EntityType.ENTITY_DARK_ESAU] = true,	--Dark Esau
	[mod.FF.PatzerShell.ID .. " " .. mod.FF.PatzerShell.Var] = true, --Patzer Shell
	[mod.FF.BadBag.ID .. " " .. mod.FF.BadBag.Var] = true,
	[792 .. " " .. 1889] = true, -- Retribution Dummy NPC
	[mod.FF.Fogspawn.ID .. " " .. mod.FF.Fogspawn.Var] = true,
	[FiendFolio.FFID.Tech] = true,	--Technical Entities
	[mod.FF.Looksee.ID .. " " .. mod.FF.Looksee.Var] = true,	--Looksee
	[mod.FF.MorvidPerched.ID .. " " .. mod.FF.MorvidPerched.Var .. " " .. mod.FF.MorvidPerched.Sub] = true,	--Morvid (Perched)
	[mod.FF.Temptress.ID .. " " .. mod.FF.Temptress.Var] = true,	--Temptress
}

--What can be selected to be summoned by the Summoning Circle (overrides blacklist)
mod.SummonsWhitelist = {
	[mod.FF.JawboneCorpse.ID .. " " .. mod.FF.JawboneCorpse.Var] = true, -- Jawbone Corpse
}

-- Basegame grids that Foetus can connect to
mod.FoetusAttachableBasegameGrids = {
	[GridEntityType.GRID_ROCK] = true,
	[GridEntityType.GRID_ROCKB] = true,
	[GridEntityType.GRID_ROCKT] = true,
	[GridEntityType.GRID_ROCK_BOMB] = true,
	[GridEntityType.GRID_ROCK_ALT] = true,
	[GridEntityType.GRID_POOP] = true,
	[GridEntityType.GRID_WALL] = true,
	[GridEntityType.GRID_ROCK_SS] = true,
	[GridEntityType.GRID_PILLAR] = true,
	[GridEntityType.GRID_ROCK_SPIKED] = true,
	[GridEntityType.GRID_ROCK_ALT2] = true,
	[GridEntityType.GRID_ROCK_GOLD] = true,
}

-- StageAPI custom grids that Foetus can connect to (by gridconfig name)
mod.FoetusAttachableCustomGrids = {
	["FFShampoo"] = true,
	["FFBeehive"] = true,
	["FFCursedPoop"] = true,
	["FFPetrifiedPoop"] = true,
	["FFPlatinumPoop"] = true,
	["FFEvilPoop"] = true,
	["FFFlippedBucket"] = true,
	["FFSpiderNest"] = true,
	["FFDogDoo"] = true,
}

-- Blocks Onlooker lasers from passing through the hitboxes of these entities
-- "grid" : Treats the occupied grid as impassible
-- "entity" : Treats only the hitbox as impassible
FiendFolio.BlocksOnlookerLaser = {
	[42] = "grid", -- All Grimaces
	[44 .. " " .. 0] = "entity", -- Poky
	[44 .. " " .. 1] = "entity", -- Slide
	[201] = "grid", -- Stone Eyes
	[202] = "grid", -- Stone Shooters
	[203] = "grid", -- Brimstone Heads
	[218 .. " " .. 0] = "entity", -- Wall Hugger
	[235] = "grid", -- Gaping Maws
	[236] = "grid", -- Broken Gaping Maws
	[292 .. " " .. 0] = "entity", -- Movable TNT
	[292 .. " " .. 750] = "grid", -- Super TNT
	[292 .. " " .. 751] = "grid", -- Water TNT
	[292 .. " " .. 752] = "grid", -- Composters
	[302] = "entity", -- Stoney
	[804] = "grid", -- Quake Grimace
	[809] = "grid", -- Bomb Grimace
	[852] = "entity", -- Spikeball
	[877] = "entity", -- Grudge
	[FiendFolio.FF.AmnioticSac.ID .. " " .. FiendFolio.FF.AmnioticSac.Var] = "grid", -- Amniotic Sacs
	[FiendFolio.FF.StrikerHead.ID .. " " .. FiendFolio.FF.StrikerHead.Var] = "entity", -- Striker Ball
	[FiendFolio.FF.LurkerTooth.ID .. " " .. FiendFolio.FF.LurkerTooth.Var] = "grid", -- Lurker Tooth segment
	--[FiendFolio.FF.MimeBlock.ID .. " " .. FiendFolio.FF.MimeBlock.Var .. " " .. FiendFolio.FF.MimeBlock.Sub] = "grid", -- Mime Degree block (has hardcoded behaviour to bypass some technical issues
	--[960 .. " " .. 740 .. " " .. 1] = "grid", -- Dead Immurals (has hardcoded behaviour to better match animation)
}

-- Entities that are damaged by Onlooker lasers whilst blocking
FiendFolio.BlockingEntityDamagedByOnlookerLaser = {
	[292 .. " " .. 752 .. " " .. 3] = true, -- Unstable Composters
	[FiendFolio.FF.AmnioticSac.ID .. " " .. FiendFolio.FF.AmnioticSac.Var] = true, -- Amniotic Sacs
}

-- Entities that are damaged by Onlooker lasers without blocking
FiendFolio.EntityDamagedByOnlookerLaser = {
	FiendFolio.ENT("SentryReg"), -- Sentry
}

-- Basegame grid entities that are damaged by Onlooker whilst blocking
FiendFolio.BlockingGridDamagedByOnlookerLaser = {
	-- And this is where I would put Red TNT... ;_;
}



----TAIGA ITEM LISTS----

-- Special wisps that can spawn from Page of Virtues
-- Regular Book of Virtues Wisps: 17% chance
-- Common Wisps: 33% chance
-- Uncommon Wisps: 45% chance
-- Rare Wisps: 5%
mod.PageOfVirtuesWisps = {
	["Common"] = {
		mod.ITEM.COLLECTIBLE.AVGM,
		CollectibleType.COLLECTIBLE_BEAN,
		CollectibleType.COLLECTIBLE_BLACK_HOLE,
		CollectibleType.COLLECTIBLE_BLOOD_RIGHTS,
		CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS,
		CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS,
		CollectibleType.COLLECTIBLE_COMPOST,
		CollectibleType.COLLECTIBLE_CRYSTAL_BALL,
		CollectibleType.COLLECTIBLE_DAMOCLES,
		CollectibleType.COLLECTIBLE_FLUSH,
		mod.ITEM.COLLECTIBLE.HEDONISTS_COOKBOOK,
		CollectibleType.COLLECTIBLE_IV_BAG,
		CollectibleType.COLLECTIBLE_KEEPERS_BOX,
		CollectibleType.COLLECTIBLE_KIDNEY_BEAN,
		CollectibleType.COLLECTIBLE_THE_NAIL,
		CollectibleType.COLLECTIBLE_RAZOR_BLADE,
		mod.ITEM.COLLECTIBLE.RESURRECTION,
		mod.ITEM.COLLECTIBLE.SANGUINE_HOOK,
		CollectibleType.COLLECTIBLE_SCOOPER,
		CollectibleType.COLLECTIBLE_SHARP_KEY,
		mod.ITEM.COLLECTIBLE.TOYBOX,
		CollectibleType.COLLECTIBLE_WE_NEED_TO_GO_DEEPER,
		CollectibleType.COLLECTIBLE_YUCK_HEART,
	},
	["Uncommon"] = {
		CollectibleType.COLLECTIBLE_BEST_FRIEND,
		CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL,
		CollectibleType.COLLECTIBLE_CRACK_THE_SKY,
		CollectibleType.COLLECTIBLE_FREE_LEMONADE,
		CollectibleType.COLLECTIBLE_GAMEKID,
		CollectibleType.COLLECTIBLE_GLASS_CANNON,
		CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS,
		CollectibleType.COLLECTIBLE_LEMON_MISHAP,
		CollectibleType.COLLECTIBLE_MAGIC_SKIN,
		CollectibleType.COLLECTIBLE_MOMS_BRA,
		CollectibleType.COLLECTIBLE_MOMS_PAD,
		CollectibleType.COLLECTIBLE_MONSTER_MANUAL,
		CollectibleType.COLLECTIBLE_MONSTROS_TOOTH,
		CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN,
		CollectibleType.COLLECTIBLE_PINKING_SHEARS,
		CollectibleType.COLLECTIBLE_SCISSORS,
		CollectibleType.COLLECTIBLE_SPIDER_BUTT,
		CollectibleType.COLLECTIBLE_SPRINKLER,
		CollectibleType.COLLECTIBLE_TAMMYS_HEAD,
		CollectibleType.COLLECTIBLE_TELEPATHY_BOOK,
		CollectibleType.COLLECTIBLE_UNDEFINED,
		CollectibleType.COLLECTIBLE_URN_OF_SOULS,
	},
	["Rare"] = {
		CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK,
		mod.ITEM.COLLECTIBLE.BEDTIME_STORY,
		CollectibleType.COLLECTIBLE_BIBLE,
		CollectibleType.COLLECTIBLE_BOBS_ROTTEN_HEAD,
		CollectibleType.COLLECTIBLE_BOX_OF_SPIDERS,
		mod.ITEM.COLLECTIBLE.FIEND_MIX,
		CollectibleType.COLLECTIBLE_GOLDEN_RAZOR,
		CollectibleType.COLLECTIBLE_GUPPYS_HEAD,
		CollectibleType.COLLECTIBLE_HOURGLASS,
		CollectibleType.COLLECTIBLE_MEGA_BEAN,
		CollectibleType.COLLECTIBLE_MEGA_BLAST,
		CollectibleType.COLLECTIBLE_MR_BOOM,
		CollectibleType.COLLECTIBLE_NECRONOMICON,
		CollectibleType.COLLECTIBLE_PAUSE,
		CollectibleType.COLLECTIBLE_PONY,
		CollectibleType.COLLECTIBLE_PRAYER_CARD,
		mod.ITEM.COLLECTIBLE.PURPLE_PUTTY,
		CollectibleType.COLLECTIBLE_SULFUR,
		CollectibleType.COLLECTIBLE_TEAR_DETONATOR,
		CollectibleType.COLLECTIBLE_WHITE_PONY,
	},
}

-- Items that get turned into familiars with Sewing Manual
-- see ffscripts/taiga/trinkets/sewingManual.lua for use
mod.SewingManualWhitelist = {}

----TAIGA STATUS LISTS----

-- Enemies that are blacklisted from basegame's Uranus Freezing status effect
FiendFolio.IceBlacklist = {
	[FiendFolio.FF.BabySpider.ID .. " " .. FiendFolio.FF.BabySpider.Var] = true, -- Baby Spider
	[FiendFolio.FFID.Tech] = true, -- Technical Entities
	[FiendFolio.FF.CordendCord.ID .. " " .. FiendFolio.FF.CordendCord.Var .. " " .. FiendFolio.FF.CordendCord.Sub] = true, -- Cordend Cord
}

-- Enemies that are whitelisted for basegame's Uranus Freezing status effect; goes around FLAG_NO_STATUS_EFFECTS and IceBlacklist
FiendFolio.IceWhitelist = {
	[FiendFolio.FF.NerveCluster.ID .. " " .. FiendFolio.FF.NerveCluster.Var] = true,
	[FiendFolio.FF.PsyEg.ID .. " " .. FiendFolio.FF.PsyEg.Var] = true,
	[FiendFolio.FF.RiderScythe.ID .. " " .. FiendFolio.FF.RiderScythe.Var] = true,
	[FiendFolio.FF.RollingHollowKnight.ID .. " " .. FiendFolio.FF.RollingHollowKnight.Var] = true,
	[FiendFolio.FF.ChainBall.ID .. " " .. FiendFolio.FF.ChainBall.Var] = true,
	[FiendFolio.FF.SpiderProj.ID .. " " .. FiendFolio.FF.SpiderProj.Var] = true,
}

-- Prevents enemies from being affected by FF's status effects
mod.FFStatusBlacklist = {
	[79 .. " " .. 20] = true, -- Gemini (cord segments)
	[216 .. " " .. 10] = true, -- Swinger (neck)
	[951 .. " " .. 42] = true, -- Ultra Death (heads)
	[mod.FF.HarletwinCord.ID .. " " .. mod.FF.HarletwinCord.Var .. " " .. mod.FF.HarletwinCord.Sub] = true, -- Harletwin (cord segments)
	[mod.FF.EffigyCord.ID .. " " .. mod.FF.EffigyCord.Var .. " " .. mod.FF.EffigyCord.Sub] = true, -- Effigy (cord segments)
	[EntityType.ENTITY_EVIS .. " " .. 10] = true, -- Evis Guts / Sewing Rope / etc.
	[mod.FF.StrikerHead.ID .. " " .. mod.FF.StrikerHead.Var .. " " .. mod.FF.StrikerHead.Sub] = true, -- Striker Ball
}

-- Prevents enemies from being affected by FF's Berserk status effect
mod.BerserkBlacklist = {
	[EntityType.ENTITY_MOMS_HAND] = true,	--Mom's Hand
	[EntityType.ENTITY_MOMS_DEAD_HAND] = true,	--Mom's Dead Hand
	[mod.FF.Ransacked.ID .. " " .. mod.FF.Ransacked.Var] = true,	--Ransacked
}

-- Enemies that are blacklisted from FF's Martyr status effect
FiendFolio.MartyrBlacklist = {
	[EntityType.ENTITY_BLOOD_PUPPY] = true, -- Blood Puppy
	[EntityType.ENTITY_VIS .. " " .. 22] = true, -- Chubber Projectile
	[FiendFolio.FF.BabySpider.ID .. " " .. FiendFolio.FF.BabySpider.Var] = true, -- Baby Spider
	[FiendFolio.FFID.Tech] = true, -- Technical Entities
	[FiendFolio.FF.CordendCord.ID .. " " .. FiendFolio.FF.CordendCord.Var .. " " .. FiendFolio.FF.CordendCord.Sub] = true, -- Cordend Cord
}

-- Enemies that are whitelisted for FF's Martyr status effect; goes around FLAG_NO_STATUS_EFFECTS and MartyrBlacklist
FiendFolio.MartyrWhitelist = {
	[FiendFolio.FF.Patzer.ID .. " " .. FiendFolio.FF.Patzer.Var] = true,
	[FiendFolio.FF.Sackboy.ID .. " " .. FiendFolio.FF.Sackboy.Var] = true,
	[FiendFolio.FF.NerveCluster.ID .. " " .. FiendFolio.FF.NerveCluster.Var] = true,
	[FiendFolio.FF.PsyEg.ID .. " " .. FiendFolio.FF.PsyEg.Var] = true,
	[FiendFolio.FF.RiderScythe.ID .. " " .. FiendFolio.FF.RiderScythe.Var] = true,
	[FiendFolio.FF.RollingHollowKnight.ID .. " " .. FiendFolio.FF.RollingHollowKnight.Var] = true,
	[FiendFolio.FF.ChainBall.ID .. " " .. FiendFolio.FF.ChainBall.Var] = true,
	[FiendFolio.FF.SpiderProj.ID .. " " .. FiendFolio.FF.SpiderProj.Var] = true,
}

-- Entities that are blacklisted from being tracked for the Nursing status effect
FiendFolio.NursingSpawnBlacklist = {
	[EntityType.ENTITY_EFFECT .. " " .. EffectVariant.DIRT_PILE] = true, -- Dirtpile
	[EntityType.ENTITY_EFFECT .. " " .. EffectVariant.POOF01] = true, -- Appear Poof
	[EntityType.ENTITY_EFFECT .. " " .. EffectVariant.CREEP_WHITE] = true, -- White Creep
	[EntityType.ENTITY_EFFECT .. " " .. EffectVariant.CREEP_BLACK] = true, -- Black Creep
	[EntityType.ENTITY_EFFECT .. " " .. EffectVariant.CREEP_BROWN] = true, -- Brown Creep
	[EntityType.ENTITY_EFFECT .. " " .. EffectVariant.CREEP_SLIPPERY_BROWN] = true, -- Slippery Brown Creep
}



----TAIGA TECHNICAL LISTS----

-- Entities that will not share HP when linked by Cuffs / cannot be affected by FF's Sewn status effect
FiendFolio.HPSharingBlacklist = {
	[EntityType.ENTITY_PICKUP] = true, -- Pickups
	[33] = true, -- Fireplace
	[42] = true, -- Grimace
	[44] = true, -- Poky
	[201] = true, -- Stone Eye
	[202] = true, -- Constant Stone Shooter
	[203] = true, -- Brimstone Head
	[218] = true, -- Wall Hugger
	[804] = true, -- Quake Grimace
	[809] = true, -- Bomb Grimace
	[877] = true, -- Grudge
	[FiendFolio.FF.Cordend.ID .. " " .. FiendFolio.FF.Cordend.Var] = true, -- Cordend
	[FiendFolio.FF.CurseOfTheGateKeySpawner.ID .. " " .. FiendFolio.FF.CurseOfTheGateKeySpawner.Var] = true, -- Curse of the Gate Key (spawner)
}

-- List of custom segmented enemies
FiendFolio.SegmentedEnemies = {
	[FiendFolio.FF.ToxicKnight.ID .. " " .. FiendFolio.FF.ToxicKnight.Var] = true, -- Toxic Knight
	[FiendFolio.FF.PsiKnight.ID .. " " .. FiendFolio.FF.PsiKnight.Var] = true, -- Psionic Knight
	[FiendFolio.FF.Fingore.ID .. " " .. FiendFolio.FF.Fingore.Var] = true, -- Fingore (body)
	[FiendFolio.FF.FingoreHand.ID .. " " .. FiendFolio.FF.FingoreHand.Var] = true, -- Fingore (hand)
	[FiendFolio.FF.Centipede.ID .. " " .. FiendFolio.FF.Centipede.Var] = true, -- Centipede
	[FiendFolio.FF.CentipedeAngy.ID .. " " .. FiendFolio.FF.CentipedeAngy.Var] = true, -- Angy Centipede
	[FiendFolio.FF.Weaver.ID .. " " .. FiendFolio.FF.Weaver.Var] = true, -- Weaver
	[FiendFolio.FF.WeaverSr.ID .. " " .. FiendFolio.FF.WeaverSr.Var] = true, -- Weaver Sr.
	[FiendFolio.FF.DreadWeaver.ID .. " " .. FiendFolio.FF.DreadWeaver.Var] = true, -- Dread Weaver
	[FiendFolio.FF.Thread.ID .. " " .. FiendFolio.FF.Thread.Var] = true, -- Thread
	[FiendFolio.FF.Archer.ID .. " " .. FiendFolio.FF.Archer.Var] = true, -- Archer
	[FiendFolio.FF.Strand.ID .. " " .. FiendFolio.FF.Strand.Var] = true, -- Strand
	[FiendFolio.FF.Diagetic.ID .. " " .. FiendFolio.FF.Diagetic.Var] = true, -- Diagetic
	[FiendFolio.FF.Ossularry.ID .. " " .. FiendFolio.FF.Ossularry.Var] = true, -- Ossularry
	[FiendFolio.FF.Gorger.ID .. " " .. FiendFolio.FF.Gorger.Var] = true, -- Gorger
	[FiendFolio.FF.Kingpin.ID .. " " .. FiendFolio.FF.Kingpin.Var] = true, -- Kingpin
	[FiendFolio.FF.Dusk.ID .. " " .. FiendFolio.FF.Dusk.Var] = true, -- Dusk
	[FiendFolio.FF.DuskHand.ID .. " " .. FiendFolio.FF.DuskHand.Var] = true, -- Dusk (hand)
	[FiendFolio.FF.Tapeworm.ID .. " " .. FiendFolio.FF.Tapeworm.Var] = true, -- Tapeworm
	[FiendFolio.FF.RotspinCore.ID .. " " .. FiendFolio.FF.RotspinCore.Var] = true, -- Rotspin (body)
	[FiendFolio.FF.RotspinMoon.ID .. " " .. FiendFolio.FF.RotspinMoon.Var] = true, -- Rotspin (head)
	[FiendFolio.FF.HollowKnight.ID .. " " .. FiendFolio.FF.HollowKnight.Var] = true, -- Hollow Knight (body)
	[FiendFolio.FF.Cortex.ID .. " " .. FiendFolio.FF.Cortex.Var] = true, -- Hollow Knight (brain)
	[FiendFolio.FF.RollingHollowKnight.ID .. " " .. FiendFolio.FF.RollingHollowKnight.Var] = true, -- Hollow Knight (sanic)
	[FiendFolio.FF.Bola.ID .. " " .. FiendFolio.FF.Bola.Var .. " " .. 0] = true, -- Bola (body)
	[FiendFolio.FF.BolaHead.ID .. " " .. FiendFolio.FF.BolaHead.Var .. " " .. FiendFolio.FF.BolaHead.Sub] = true, -- Bola (head)
	[FiendFolio.FF.MrBones.ID .. " " .. FiendFolio.FF.MrBones.Var] = true, -- Mr. Bones
	[FiendFolio.FF.MrGob.ID .. " " .. FiendFolio.FF.MrGob.Var] = true, -- Mr. Gob
	[FiendFolio.FF.Prick.ID .. " " .. FiendFolio.FF.Prick.Var] = true, -- Prick
	[FiendFolio.FF.Cordend.ID .. " " .. FiendFolio.FF.Cordend.Var] = true, -- Cordend
	[FiendFolio.FF.Warble.ID .. " " .. FiendFolio.FF.Warble.Var] = true, -- Warble
	[FiendFolio.FF.LonelyKnight.ID .. " " .. FiendFolio.FF.LonelyKnight.Var] = true, -- Lonely Knight (body)
	[FiendFolio.FF.LonelyKnightBrain.ID .. " " .. FiendFolio.FF.LonelyKnightBrain.Var] = true, -- Lonely Knight (brain)
	[FiendFolio.FF.LonelyKnightShell.ID .. " " .. FiendFolio.FF.LonelyKnightShell.Var] = true, -- Lonely Knight (shell)
	[FiendFolio.FF.Foetus.ID .. " " .. FiendFolio.FF.Foetus.Var .. " " .. FiendFolio.FF.Foetus.Sub] = true, -- Foetus
	[FiendFolio.FF.FoetusBaby.ID .. " " .. FiendFolio.FF.FoetusBaby.Var .. " " .. FiendFolio.FF.FoetusBaby.Sub] = true, -- Foetu
	[FiendFolio.FF.CorruptedLarry.ID .. " " .. FiendFolio.FF.CorruptedLarry.Var] = true, -- Corrupted Larry
	[FiendFolio.FF.Trailblazer.ID .. " " .. FiendFolio.FF.Trailblazer.Var] = true, -- Trailblazer
	[FiendFolio.FF.FoozTwinRed.ID .. " " .. FiendFolio.FF.FoozTwinRed.Var] = true, -- Fooz Twins
	[FiendFolio.FF.FoozTwinsBall.ID .. " " .. FiendFolio.FF.FoozTwinsBall.Var] = true, -- Fooz Twins' Ball
}

-- List of basegame segmented enemies
mod.BasegameSegmentedEnemies = {
	[35 .. " " .. 0] = true, -- Mr. Maw (body)
	[35 .. " " .. 1] = true, -- Mr. Maw (head)
	[35 .. " " .. 2] = true, -- Mr. Red Maw (body)
	[35 .. " " .. 3] = true, -- Mr. Red Maw (head)
	[89] = true, -- Buttlicker
	[216 .. " " .. 0] = true, -- Swinger (body)
	[216 .. " " .. 1] = true, -- Swinger (head)
	[239] = true, -- Grub
	[244 .. " " .. 2] = true, -- Tainted Round Worm

	[19 .. " " .. 0] = true, -- Larry Jr.
	[19 .. " " .. 1] = true, -- The Hollow
	[19 .. " " .. 2] = true, -- Tuff Twins
	[19 .. " " .. 3] = true, -- The Shell
	[28 .. " " .. 0] = true, -- Chub
	[28 .. " " .. 1] = true, -- C.H.A.D.
	[28 .. " " .. 2] = true, -- The Carrion Queen
	[62 .. " " .. 0] = true, -- Pin
	[62 .. " " .. 1] = true, -- Scolex
	[62 .. " " .. 2] = true, -- The Frail
	[62 .. " " .. 3] = true, -- Wormwood
	[79 .. " " .. 0] = true, -- Gemini
	[79 .. " " .. 1] = true, -- Steven
	[79 .. " " .. 10] = true, -- Gemini (baby)
	[79 .. " " .. 11] = true, -- Steven (baby)
	[92 .. " " .. 0] = true, -- Heart
	[92 .. " " .. 1] = true, -- 1/2 Heart
	[93 .. " " .. 0] = true, -- Mask
	[93 .. " " .. 1] = true, -- Mask II
	[97] = true, -- Mask of Infamy
	[98] = true, -- Heart of Infamy
	[266] = true, -- Mama Gurdy
	[912 .. " " .. 0 .. " " .. 0] = true, -- Mother (phase one)
	[912 .. " " .. 0 .. " " .. 2] = true, -- Mother (left arm)
	[912 .. " " .. 0 .. " " .. 3] = true, -- Mother (right arm)
	[918 .. " " .. 0] = true, -- Turdlet
}

-- Main segment of custom segmented enemies
FiendFolio.MainSegment = {
	[FiendFolio.FF.ToxicKnightHusk.ID .. " " .. FiendFolio.FF.ToxicKnightHusk.Var .. " " .. FiendFolio.FF.ToxicKnightHusk.Sub] = true, -- Toxic Knight (body)
	[FiendFolio.FF.PsiKnightHusk.ID .. " " .. FiendFolio.FF.PsiKnightHusk.Var .. " " .. FiendFolio.FF.PsiKnightHusk.Sub] = true, -- Psionic Knight (body)
	[FiendFolio.FF.Fingore.ID .. " " .. FiendFolio.FF.Fingore.Var] = true, -- Fingore (body)
	[FiendFolio.FF.Centipede.ID .. " " .. FiendFolio.FF.Centipede.Var .. " " .. 0] = true, -- Centipede (head)
	[FiendFolio.FF.CentipedeAngy.ID .. " " .. FiendFolio.FF.CentipedeAngy.Var .. " " .. 0] = true, -- Angy Centipede (head)
	[FiendFolio.FF.Weaver.ID .. " " .. FiendFolio.FF.Weaver.Var .. " " .. 0] = true, -- Weaver (head)
	[FiendFolio.FF.WeaverSr.ID .. " " .. FiendFolio.FF.WeaverSr.Var .. " " .. 0] = true, -- Weaver Sr. (head)
	[FiendFolio.FF.DreadWeaver.ID .. " " .. FiendFolio.FF.DreadWeaver.Var .. " " .. 0] = true, -- Dread Weaver (head)
	[FiendFolio.FF.Thread.ID .. " " .. FiendFolio.FF.Thread.Var .. " " .. 0] = true, -- Thread (head)
	[FiendFolio.FF.Archer.ID .. " " .. FiendFolio.FF.Archer.Var .. " " .. 0] = true, -- Archer (head)
	[FiendFolio.FF.Strand.ID .. " " .. FiendFolio.FF.Strand.Var .. " " .. 0] = true, -- Strand (head)
	[FiendFolio.FF.Diagetic.ID .. " " .. FiendFolio.FF.Diagetic.Var .. " " .. 0] = true, -- Diagetic (head)
	[FiendFolio.FF.Ossularry.ID .. " " .. FiendFolio.FF.Ossularry.Var .. " " .. 0] = true, -- Ossularry
	[FiendFolio.FF.Gorger.ID .. " " .. FiendFolio.FF.Gorger.Var .. " " .. 0] = true, -- Gorger (head)
	--[FiendFolio.FF.Kingpin.ID .. " " .. FiendFolio.FF.Kingpin.Var] = true, -- Kingpin is weird
	[FiendFolio.FF.Dusk.ID .. " " .. FiendFolio.FF.Dusk.Var] = true, -- Dusk (head)
	--[FiendFolio.FF.Tapeworm.ID .. " " .. FiendFolio.FF.Tapeworm.Var] = true, -- Tapeworms are weird
	[FiendFolio.FF.RotspinCore.ID .. " " .. FiendFolio.FF.RotspinCore.Var] = true, -- Rotspin (body)
	[FiendFolio.FF.HollowKnight.ID .. " " .. FiendFolio.FF.HollowKnight.Var] = true, -- Hollow Knight (body)
	[FiendFolio.FF.Bola.ID .. " " .. FiendFolio.FF.Bola.Var .. " " .. 0] = true, -- Bola (body)
	--[FiendFolio.FF.MrBones.ID .. " " .. FiendFolio.FF.MrBones.Var] = true, -- Mr. Bones is weird
	[FiendFolio.FF.MrGob.ID .. " " .. FiendFolio.FF.MrGob.Var .. " " .. 0] = true, -- Mr. Gob (body)
	--[FiendFolio.FF.Prick.ID .. " " .. FiendFolio.FF.Prick.Var] = true, -- Prick is weird
	[FiendFolio.FF.Cordend.ID .. " " .. FiendFolio.FF.Cordend.Var .. " " .. 0] = true, -- Cordend (main half)
	--[FiendFolio.FF.Warble.ID .. " " .. FiendFolio.FF.Warble.Var] = true, -- Warble is weird
	[FiendFolio.FF.LonelyKnight.ID .. " " .. FiendFolio.FF.LonelyKnight.Var] = true, -- Lonely Knight (body)
	[FiendFolio.FF.Foetus.ID .. " " .. FiendFolio.FF.Foetus.Var .. " " .. FiendFolio.FF.Foetus.Sub] = true, -- Foetus
	[FiendFolio.FF.FoozTwinsBall.ID .. " " .. FiendFolio.FF.FoozTwinsBall.Var] = true, -- Fooz Twins' Ball
}

-- Main segment of basegame segmented enemies
mod.BasegameMainSegment = {
	[35 .. " " .. 1] = true, -- Mr. Maw (head)
	[35 .. " " .. 3] = true, -- Mr. Red Maw (head)
	[92 .. " " .. 0] = true, -- Heart
	[92 .. " " .. 1] = true, -- 1/2 Heart
	[216 .. " " .. 0] = true, -- Swinger (body)
	[244 .. " " .. 2 .. " " .. 0] = true, -- Tainted Round Worm (head)

	[79 .. " " .. 0] = true, -- Gemini
	[79 .. " " .. 1] = true, -- Steven
	[97] = true, -- Mask of Infamy
	[266 .. " " .. 0] = true, -- Mama Gurdy (body)
	[912 .. " " .. 0 .. " " .. 0] = true, -- Mother (phase one)

--	[89] = true, -- Buttlicker is weird
--	[239] = true, -- Grub is weird

--	[19 .. " " .. 0] = true, -- Larry Jr. is weird
--	[19 .. " " .. 1] = true, -- The Hollow is weird
--	[19 .. " " .. 2] = true, -- Tuff Twins is weird
--	[19 .. " " .. 3] = true, -- The Shell is weird
--	[28 .. " " .. 0] = true, -- Chub is weird
--	[28 .. " " .. 1] = true, -- C.H.A.D. is weird
--	[28 .. " " .. 2] = true, -- The Carrion Queen is weird
--	[62 .. " " .. 0] = true, -- Pin is weird
--	[62 .. " " .. 1] = true, -- Scolex is weird
--	[62 .. " " .. 2] = true, -- The Frail is weird
--	[62 .. " " .. 3] = true, -- Wormwood is weird
--	[918 .. " " .. 0] = true, -- Turdlet is weird
}

-- Treats segments as separate entities for Uranus freezing, Dr. Shambles healing, Hemorrhaging DoT, etc.
-- For custom segmented enemies/bosses like Rotspin, Kingpin, etc.
FiendFolio.ReducedSyncSegments = {
	[FiendFolio.FF.Ossularry.ID .. " " .. FiendFolio.FF.Ossularry.Var] = true, -- Ossularry
	[FiendFolio.FF.Kingpin.ID .. " " .. FiendFolio.FF.Kingpin.Var] = true, -- Kingpin
	[FiendFolio.FF.Dusk.ID .. " " .. FiendFolio.FF.Dusk.Var] = true, -- Dusk
	[FiendFolio.FF.DuskHand.ID .. " " .. FiendFolio.FF.DuskHand.Var] = true, -- Dusk (hand)
	[FiendFolio.FF.Tapeworm.ID .. " " .. FiendFolio.FF.Tapeworm.Var] = true, -- Tapeworm
	[FiendFolio.FF.RotspinCore.ID .. " " .. FiendFolio.FF.RotspinCore.Var] = true, -- Rotspin (body)
	[FiendFolio.FF.RotspinMoon.ID .. " " .. FiendFolio.FF.RotspinMoon.Var] = true, -- Rotspin (head)
	[FiendFolio.FF.MrBones.ID .. " " .. FiendFolio.FF.MrBones.Var] = true, -- Mr. Bones
	[FiendFolio.FF.MrGob.ID .. " " .. FiendFolio.FF.MrGob.Var] = true, -- Mr. Gob
	[FiendFolio.FF.Prick.ID .. " " .. FiendFolio.FF.Prick.Var] = true, -- Prick
	[FiendFolio.FF.Foetus.ID .. " " .. FiendFolio.FF.Foetus.Var .. " " .. FiendFolio.FF.Foetus.Sub] = true, -- Foetus
	[FiendFolio.FF.FoetusBaby.ID .. " " .. FiendFolio.FF.FoetusBaby.Var .. " " .. FiendFolio.FF.FoetusBaby.Sub] = true, -- Foetu
}

-- Treats segments as separate entities for Uranus freezing, Dr. Shambles healing, Hemorrhaging DoT, etc.
-- For basegame segmented enemies/bosses like Larry Jr., Gemini, etc.
mod.BasegameReducedSyncSegments = {
	[35 .. " " .. 0] = true, -- Mr. Maw (body)
	[35 .. " " .. 1] = true, -- Mr. Maw (head)
	[35 .. " " .. 2] = true, -- Mr. Red Maw (body)
	[35 .. " " .. 3] = true, -- Mr. Red Maw (head)
	[89] = true, -- Buttlicker
	[216 .. " " .. 0] = true, -- Swinger (body)
	[216 .. " " .. 1] = true, -- Swinger (head)

	[19 .. " " .. 0] = true, -- Larry Jr.
	[19 .. " " .. 1] = true, -- The Hollow
	[19 .. " " .. 2] = true, -- Tuff Twins
	[19 .. " " .. 3] = true, -- The Shell
	[79 .. " " .. 0] = true, -- Gemini
	[79 .. " " .. 1] = true, -- Steven
	[79 .. " " .. 10] = true, -- Gemini (baby)
	[79 .. " " .. 11] = true, -- Steven (baby)
	[92 .. " " .. 0] = true, -- Heart
	[92 .. " " .. 1] = true, -- 1/2 Heart
	[93 .. " " .. 0] = true, -- Mask
	[93 .. " " .. 1] = true, -- Mask II
	[97] = true, -- Mask of Infamy
	[98] = true, -- Heart of Infamy
}

---- SBODY ITEM LIST ----

-- AZURITE SPINDOWN --

ffAzuriteSpindownList = {									--ffBlacklistAzurite(table) for modded trinkets. true for single trinkets, table for multi-state trinkets
	[TrinketType.TRINKET_POLAROID_OBSOLETE] = true,
	[mod.ITEM.TRINKET.HALF_VESSEL] = {[mod.ITEM.TRINKET.EXTRA_VESSEL]=true},
	[mod.ITEM.TRINKET.FULL_VESSEL] = {[mod.ITEM.TRINKET.HALF_VESSEL]=true, [mod.ITEM.TRINKET.EXTRA_VESSEL]=true},
	[FiendFolio.ITEM.ROCK.VESSEL_ROCK] = true,
	[FiendFolio.ITEM.ROCK.FULL_VESSEL_ROCK] = {[FiendFolio.ITEM.ROCK.HALF_VESSEL_ROCK]=true, [FiendFolio.ITEM.ROCK.VESSEL_ROCK]=true},
	[FiendFolio.ITEM.ROCK.DAMAGED_SAND_CASTLE] = {[FiendFolio.ITEM.ROCK.SAND_CASTLE]=true},
	[FiendFolio.ITEM.ROCK.BROKEN_SAND_CASTLE] = {[FiendFolio.ITEM.ROCK.SAND_CASTLE]=true, [FiendFolio.ITEM.ROCK.DAMAGED_SAND_CASTLE]=true},
	[mod.ITEM.TRINKET.TATTERED_FROG_PUPPET] = true,
	[mod.ITEM.TRINKET.SEWING_MANUAL_2_USE] = {[mod.ITEM.TRINKET.SEWING_MANUAL_3_USE]=true},
	[mod.ITEM.TRINKET.SEWING_MANUAL_1_USE] = {[mod.ITEM.TRINKET.SEWING_MANUAL_2_USE]=true, [mod.ITEM.TRINKET.SEWING_MANUAL_3_USE]=true},
	--[FiendFolio.ITEM.ROCK.UNOBTAINIUM] = true,			--mf is so unobtainable that its hardcoded on azurite's code

	-- Achievement Trackers copied directly from the achievement tracker id table in ffscripts.achievements, so that I don't eventually forgot to add one here too
}

-- GENERAL TRINKET BLACKLIST --
mod.TrinketPoolBlacklist = {
	[mod.ITEM.TRINKET.HALF_VESSEL] = true,
	[mod.ITEM.TRINKET.FULL_VESSEL] = true,
	[mod.ITEM.TRINKET.TATTERED_FROG_PUPPET] = true,
	[mod.ITEM.TRINKET.SHATTERED_CURSED_URN] = true,
	[FiendFolio.ITEM.ROCK.UNOBTAINIUM] = true,
	[mod.ITEM.TRINKET.PROJECTILE_TRINKET] = true,
	[mod.ITEM.TRINKET.ONE_OF_YOUR_BOMBS] = true,
	[mod.ITEM.TRINKET.SEWING_MANUAL_2_USE] = true,
	[mod.ITEM.TRINKET.SEWING_MANUAL_1_USE] = true,
	[mod.ITEM.TRINKET.BENT_PENNY] = true,
	[mod.ITEM.TRINKET.TROLL_PENNY] = true,
	[mod.ITEM.TRINKET.AIRBAG_PENNY] = true,
	[mod.ITEM.TRINKET.MICRO_PENNY] = true,
	[mod.ITEM.TRINKET.MAP_PENNY] = true,
	[mod.ITEM.TRINKET.PRETTY_PENNY] = true,
	[mod.ITEM.TRINKET.FACEBOOK_PENNY] = true,
	[mod.ITEM.TRINKET.CHARITABLE_PENNY] = true,
	[mod.ITEM.TRINKET.DEVIOUS_PENNY] = true,
	[mod.ITEM.TRINKET.SWITCH_PENNY] = true,
	[mod.ITEM.TRINKET.POOP_PENNY] = true,
	[mod.ITEM.TRINKET.SLIPPERY_PENNY] = true,
	[mod.ITEM.TRINKET.CANADIAN_PENNY] = true,
	[mod.ITEM.TRINKET.ALPHA_PENNY] = true,
	[mod.ITEM.TRINKET.STONE_PENNY] = true,
	[mod.ITEM.TRINKET.RED_PENNY] = true,
	[mod.ITEM.TRINKET.PUCK_PENNY] = true,
	[mod.ITEM.TRINKET.PRISM_PENNY] = true,
	[mod.ITEM.TRINKET.BERRY_PENNY] = true,
	[mod.ITEM.TRINKET.CALCIUM_PENNY] = true,
	[mod.ITEM.TRINKET.DOG_PENNY] = true,
	[mod.ITEM.TRINKET.DADS_LOST_PENNY] = true,
	[mod.ITEM.TRINKET.LOADED_PENNY] = true,
	[mod.ITEM.TRINKET.SUNDIAL_PENNY] = true,
	[mod.ITEM.TRINKET.BRAZILIAN_PENNY] = true,
}

--Threes card converters

--Stuff passed here will be skipped over by the jack cards when converting
FiendFolio.DenyJackofDiamonds = {
	[mod.PICKUP.COIN.CURSED] = true,
	[mod.PICKUP.COIN.GOLDENCURSED] = true,
}

FiendFolio.DenyJackofClubs = {
	[BombSubType.BOMB_GIGA]					= true,
	[FiendFolio.PICKUP.BOMB.COPPER]			= true,
	[FiendFolio.PICKUP.BOMB.DOUBLE_COPPER]	= true,
}

FiendFolio.DenyMisprintedJackofClubs = {
	[BombSubType.BOMB_TROLL]		= true,
	[BombSubType.BOMB_SUPERTROLL]	= true,
	[BombSubType.BOMB_GOLDENTROLL]	= true,
	[BombSubType.BOMB_GIGA]			= true,
}

FiendFolio.ClearCaseBlacklist = {
	[CollectibleType.COLLECTIBLE_BOBS_ROTTEN_HEAD] = true,
	[CollectibleType.COLLECTIBLE_SHOOP_DA_WHOOP] = true,
	[CollectibleType.COLLECTIBLE_CANDLE] = true,
	[CollectibleType.COLLECTIBLE_CLEAR_RUNE] = true,
	[CollectibleType.COLLECTIBLE_BLANK_CARD] = true,
	[CollectibleType.COLLECTIBLE_RED_CANDLE] = true,
	[CollectibleType.COLLECTIBLE_THE_JAR] = true,
	[CollectibleType.COLLECTIBLE_BOOMERANG] = true,
	[CollectibleType.COLLECTIBLE_GLASS_CANNON] = true,
	[CollectibleType.COLLECTIBLE_FRIEND_BALL] = true,
	[CollectibleType.COLLECTIBLE_BROKEN_GLASS_CANNON] = true,
	[CollectibleType.COLLECTIBLE_VOID] = true,
	[CollectibleType.COLLECTIBLE_BLACK_HOLE] = true,
	[CollectibleType.COLLECTIBLE_SHARP_KEY] = true,
	[CollectibleType.COLLECTIBLE_ERASER] = true,
	[mod.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_1] = true,
	[mod.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_2] = true,
	[mod.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_3] = true,
	[mod.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_4] = true,
	[mod.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_5] = true,
	[mod.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_6] = true,
	[mod.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_8] = true,
	[mod.ITEM.COLLECTIBLE.PERFECTLY_GENERIC_OBJECT_12] = true,
	[mod.ITEM.COLLECTIBLE.OLD_TESTAMENT] = true,
}

-- ERFLY BLACKLISTS

--Item stuff

--List of entities flower crown won't try to get rid of
FiendFolio.BlackListedFlowerCrowns = {
	[EntityType.ENTITY_STONEHEAD] = true,
	[EntityType.ENTITY_WALL_HUGGER] = true,
	[mod.FF.EternalFlickerspirit.ID .. " " .. mod.FF.EternalFlickerspirit.Var] = true,
	[mod.FF.Viscerspirit.ID .. " " .. mod.FF.Viscerspirit.Var] = true,
	[EntityType.ENTITY_BLOOD_PUPPY] = true,
	[EntityType.ENTITY_DARK_ESAU] = true, --These two just in case
	[792 .. " " .. 1888] = true, --Cactus Collider, just in case
	[EntityType.ENTITY_POLTY] = true,
	[mod.FF.DungeonMaster.ID .. " " .. mod.FF.DungeonMaster.Var] = true,
}

--Curse of the veil stuff

--Whitelist for pickup variants to be affected by curse of the veil
FiendFolio.VeiledPickupsWhitelist = {
    --Default
    PickupVariant.PICKUP_HEART,
    PickupVariant.PICKUP_COIN,
    PickupVariant.PICKUP_KEY,
    PickupVariant.PICKUP_BOMB,
    PickupVariant.PICKUP_THROWABLEBOMB,
    PickupVariant.PICKUP_POOP,
    PickupVariant.PICKUP_GRAB_BAG,
    PickupVariant.PICKUP_PILL,
    PickupVariant.PICKUP_LIL_BATTERY,
    PickupVariant.PICKUP_TAROTCARD,
    PickupVariant.PICKUP_TRINKET,

    --Fiend Folio
    FiendFolio.PICKUP.VARIANT.FIEND_MINION_CLASSIC,
    FiendFolio.PICKUP.VARIANT.HALF_BLACK_HEART,
    FiendFolio.PICKUP.VARIANT.BLENDED_BLACK_HEART,
    FiendFolio.PICKUP.VARIANT.IMMORAL_HEART,
    FiendFolio.PICKUP.VARIANT.HALF_IMMORAL_HEART,
    FiendFolio.PICKUP.VARIANT.BLENDED_IMMORAL_HEART,
    FiendFolio.PICKUP.VARIANT.MORBID_HEART,
    FiendFolio.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART,
    FiendFolio.PICKUP.VARIANT.THIRD_MORBID_HEART,
    FiendFolio.PICKUP.VARIANT.BOMB_HEART,
    FiendFolio.PICKUP.VARIANT.HALF_BOMB_HEART,
    FiendFolio.PICKUP.VARIANT.FOOLS_GOLD_HEART,
    FiendFolio.PICKUP.VARIANT.STEVEN_HEART,
    FiendFolio.PICKUP.VARIANT.PRISM_SHARD,
    FiendFolio.PICKUP.VARIANT.TOKEN,
    FiendFolio.PICKUP.VARIANT.VIRTUOUS_BATTERY,
    FiendFolio.PICKUP.VARIANT.POTATO_BATTERY,
    FiendFolio.PICKUP.VARIANT.CURSED_BATTERY,
    FiendFolio.PICKUP.VARIANT.FFSACK,
    FiendFolio.PICKUP.VARIANT.SWEET_RED_BERRY,
    FiendFolio.PICKUP.VARIANT.PUZZLE_KEY,
    FiendFolio.PICKUP.VARIANT.GATECURSE_KEY,
    FiendFolio.PICKUP.VARIANT.SOUL_SHARD,
    FiendFolio.PICKUP.VARIANT.SPARE_ERASER,
	FiendFolio.PICKUP.VARIANT.BRIEND_BIRTHRIGHT_GUN,
}

--Same dealio but for chests
FiendFolio.VeiledChestsWhitelist = {
	--Default
	PickupVariant.PICKUP_CHEST,
	PickupVariant.PICKUP_BOMBCHEST,
	PickupVariant.PICKUP_SPIKEDCHEST,
	PickupVariant.PICKUP_ETERNALCHEST,
	PickupVariant.PICKUP_MIMICCHEST,
	PickupVariant.PICKUP_OLDCHEST,
	PickupVariant.PICKUP_WOODENCHEST,
	PickupVariant.PICKUP_MEGACHEST,
	PickupVariant.PICKUP_HAUNTEDCHEST,
	PickupVariant.PICKUP_LOCKEDCHEST,
	PickupVariant.PICKUP_REDCHEST,
	PickupVariant.PICKUP_MOMSCHEST,

	--Fiend Folio
	FiendFolio.PICKUP.VARIANT.SHOP_CHEST,
	FiendFolio.PICKUP.VARIANT.DIRE_CHEST,
	FiendFolio.PICKUP.VARIANT.GLASS_CHEST,
	FiendFolio.PICKUP.VARIANT.ENGINE_CHEST,
}

--Used to override the animations for curse of the veil on a specific pickup
-- (For example, the curse but it can play a new pickup's unique animation)
-- (Main use on Fiend Folio's side is for animation names that clash)
FiendFolio.OverrideMysteryPickup = {
	--Unique anims
    [PickupVariant.PICKUP_TRINKET] = {
        [mod.ITEM.ROCK.GRIMACE_ROCK6] = "gfx/items/pick ups/mystery_pickup_2.anm2",
        [mod.ITEM.ROCK.GRIMACE_ROCK7] = "gfx/items/pick ups/mystery_pickup_2.anm2",
        [mod.ITEM.ROCK.GRIMACE_ROCK10] = "gfx/items/pick ups/mystery_pickup_2.anm2",
    },
	[PickupVariant.PICKUP_MEGACHEST] = "gfx/items/slots/mystery_chest_mega.anm2",
	[FiendFolio.PICKUP.VARIANT.ENGINE_CHEST] = "gfx/items/slots/mystery_chest_engine.anm2",
	[FiendFolio.PICKUP.VARIANT.PUZZLE_KEY] = "gfx/items/pick ups/mystery_key.anm2",
	[FiendFolio.PICKUP.VARIANT.GATECURSE_KEY] = "gfx/items/pick ups/mystery_key.anm2",

	--Chests that hurt when touched
	[PickupVariant.PICKUP_SPIKEDCHEST] = "gfx/items/slots/mystery_chest_dangerous.anm2",
	[PickupVariant.PICKUP_MIMICCHEST] = "gfx/items/slots/mystery_chest_dangerous.anm2",
	[FiendFolio.PICKUP.VARIANT.DIRE_CHEST] = "gfx/items/slots/mystery_chest_dangerous.anm2",

	--Pickups that hurt you when picked up
	[PickupVariant.PICKUP_KEY] = {
		[FiendFolio.PICKUP.KEY.SPICY] = "gfx/items/pick ups/mysterypickup_dangerous.anm2",
		[FiendFolio.PICKUP.KEY.SUPERSPICY] = "gfx/items/pick ups/mysterypickup_dangerous.anm2",
		[FiendFolio.PICKUP.KEY.CHARGEDSPICY] = "gfx/items/pick ups/mysterypickup_dangerous.anm2",
		[FiendFolio.PICKUP.KEY.SPICY_BOX] = "gfx/items/pick ups/mysterypickup_dangerous.anm2",
		[FiendFolio.PICKUP.KEY.SUPERSPICY_BOX] = "gfx/items/pick ups/mysterypickup_dangerous.anm2",
		[FiendFolio.PICKUP.KEY.CHARGEDSPICY_BOX] = "gfx/items/pick ups/mysterypickup_dangerous.anm2",
		[FiendFolio.PICKUP.KEY.SPICY_PERM] = "gfx/items/pick ups/mysterypickup_dangerous.anm2",
		[FiendFolio.PICKUP.KEY.SUPERSPICY_PERM] = "gfx/items/pick ups/mysterypickup_dangerous.anm2",
		[FiendFolio.PICKUP.KEY.CHARGEDSPICY_PERM] = "gfx/items/pick ups/mysterypickup_dangerous.anm2",
	},
	[PickupVariant.PICKUP_COIN] = {
		[FiendFolio.PICKUP.COIN.CURSED] = "gfx/items/pick ups/mysterypickup_dangerous.anm2",
		[FiendFolio.PICKUP.COIN.GOLDENCURSED] = "gfx/items/pick ups/mysterypickup_dangerous.anm2",
		[FiendFolio.PICKUP.COIN.MEDLEY_STICKY] = "gfx/items/pick ups/mysterypickup_dangerous.anm2",
		[FiendFolio.PICKUP.COIN.MEDLEY] = "gfx/items/pick ups/mysterypickup_dangerous.anm2",
	},
	[PickupVariant.PICKUP_LIL_BATTERY] = {
		[BatterySubType.BATTERY_GOLDEN] = "gfx/items/pick ups/mysterypickup_dangerous.anm2",
	},
}

--Used to blacklist the appearance of curse of the veil on a specific pickup
FiendFolio.BlacklistMysteryPickup = {
    [PickupVariant.PICKUP_TRINKET] = {
        [mod.ITEM.ROCK.DOGROCK_ROCK] = true,
    },
	[FiendFolio.PICKUP.VARIANT.SHOP_CHEST] = {
		[2] = true,
		[3] = true,
		[4] = true,
		[5] = true,
	}
}

--For special cases. bool function(pickup) expected in them
FiendFolio.BlacklistMysteryHighPriorityChecks = {}
FiendFolio.BlacklistMysteryLowPriorityChecks = {}

--Sounds to check for and stop when a curse of the veil pickup plays the dropsound
FiendFolio.BlacklistMysterPickupDropSounds = {
	SoundEffect.SOUND_MEAT_FEET_SLOW0,
    SoundEffect.SOUND_PENNYDROP,
    SoundEffect.SOUND_NICKELDROP,
    SoundEffect.SOUND_DIMEDROP,
    SoundEffect.SOUND_KEY_DROP0,
    SoundEffect.SOUND_FETUS_LAND,
    --SoundEffect.SOUND_CHEST_DROP,
    SoundEffect.SOUND_FETUS_JUMP,
    SoundEffect.SOUND_SCAMPER,
    SoundEffect.SOUND_GOLD_HEART_DROP,
    SoundEffect.SOUND_BONE_DROP,
    mod.Sounds.FiendHeartDrop,
    SoundEffect.SOUND_ANIMAL_SQUISH,
	mod.Sounds.LandSoft,
	SoundEffect.SOUND_MUSHROOM_POOF,
	SoundEffect.SOUND_DEATH_BURST_SMALL,
	SoundEffect.SOUND_SCYTHE_BREAK,
	FiendFolio.TempSoundEnums.ButterLand,
	FiendFolio.Sounds.TimeFcukPlayerLand,
}

FiendFolio.VeilChestClearAnimations = {
	["Open"] = true,
	["OpenNothing"] = true,
	["Shatter"] = true,
	["ShatterFade"] = true,
}

-- These trinkets will be converted to normal trinkets if they show up golden or blasphemous!
-- FiendFolio.SpecialTrinketBlacklist = {}

--Dad items, used for Dad Transformation
FiendFolio.DadItems = {
    CollectibleType.COLLECTIBLE_DADS_KEY,
    CollectibleType.COLLECTIBLE_DADS_LOST_COIN,
    CollectibleType.COLLECTIBLE_DADS_RING,
    --CollectibleType.COLLECTIBLE_DADS_NOTE, --Nah
    FiendFolio.ITEM.COLLECTIBLE.DADS_WALLET,
    FiendFolio.ITEM.COLLECTIBLE.DADS_POSTICHE,
    FiendFolio.ITEM.COLLECTIBLE.DADS_DIP,
    FiendFolio.ITEM.COLLECTIBLE.DADS_BATTERY,
    FiendFolio.ITEM.COLLECTIBLE.DADS_HALF,
    FiendFolio.ITEM.COLLECTIBLE.DADS_SHORTS,
}

--Truth table used in the achievement check
FiendFolio.DadItemsTruth = {
	[CollectibleType.COLLECTIBLE_DADS_KEY] = true,
	[CollectibleType.COLLECTIBLE_DADS_LOST_COIN] = true,
	[CollectibleType.COLLECTIBLE_DADS_RING] = true,
	[FiendFolio.ITEM.COLLECTIBLE.DADS_WALLET] = true,
	[FiendFolio.ITEM.COLLECTIBLE.DADS_POSTICHE] = true,
	[FiendFolio.ITEM.COLLECTIBLE.DADS_DIP] = true,
	[FiendFolio.ITEM.COLLECTIBLE.DADS_BATTERY] = true,
	[FiendFolio.ITEM.COLLECTIBLE.DADS_HALF] = true,
	[FiendFolio.ITEM.COLLECTIBLE.DADS_SHORTS] = true,
}

--Items used for Time Fcuk'd Transformation
--Steven, Time Fcuk and time themed items
FiendFolio.TimeFcukItems = {
	CollectibleType.COLLECTIBLE_STEVEN,
	CollectibleType.COLLECTIBLE_HOURGLASS,
	CollectibleType.COLLECTIBLE_LITTLE_STEVEN,
	CollectibleType.COLLECTIBLE_STOP_WATCH,
	CollectibleType.COLLECTIBLE_BROKEN_WATCH,
	CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS,
	CollectibleType.COLLECTIBLE_MULTIDIMENSIONAL_BABY,
	CollectibleType.COLLECTIBLE_PAUSE,
	FiendFolio.ITEM.COLLECTIBLE.TIME_ITSELF,
	FiendFolio.ITEM.COLLECTIBLE.PARALLEL_BOMBS,
	FiendFolio.ITEM.COLLECTIBLE.STEVEN_SANDWICH,
	FiendFolio.ITEM.COLLECTIBLE.YCUK_HEART,
	FiendFolio.ITEM.COLLECTIBLE.STEVENS_HAT,
}

--Kalu items for kalu transformation
FiendFolio.KaluItems = {
	mod.ITEM.COLLECTIBLE.KALU,
	mod.ITEM.COLLECTIBLE.KALUS_EYE,
	mod.ITEM.COLLECTIBLE.KALUS_HARVESTED_NOSE,
	mod.ITEM.COLLECTIBLE.KALUS_HEAD,
	mod.ITEM.COLLECTIBLE.KALUS_HEART,
	mod.ITEM.COLLECTIBLE.KALUS_TAIL,
	mod.ITEM.COLLECTIBLE.KALUS_WICKED_PAW,
}
FiendFolio.KaluTrinkets = {
	mod.ITEM.TRINKET.KALUS_CLAW,
	mod.ITEM.TRINKET.KALUS_TONGUE,
}
mod:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, function()
	if TheFuture then
		table.insert(FiendFolio.TimeFcukItems, TheFuture.Items.IronCart)
	end
end)
if ModReloadDetector.ModsLoaded then
	if TheFuture then
		table.insert(FiendFolio.TimeFcukItems, TheFuture.Items.IronCart)
	end
end

--List of all consumable active items used for the Corruption unlock
FiendFolio.ConsumableActiveItems = {
	[CollectibleType.COLLECTIBLE_FORGET_ME_NOW] = true,
	[CollectibleType.COLLECTIBLE_BLUE_BOX] = true,
	[CollectibleType.COLLECTIBLE_DIPLOPIA] = true,
	[CollectibleType.COLLECTIBLE_PLAN_C] = true,
	[CollectibleType.COLLECTIBLE_MAMA_MEGA] = true,
	[CollectibleType.COLLECTIBLE_EDENS_SOUL] = true,
	[CollectibleType.COLLECTIBLE_MYSTERY_GIFT] = true,
	[CollectibleType.COLLECTIBLE_SACRIFICIAL_ALTAR] = true,
	[CollectibleType.COLLECTIBLE_DAMOCLES] = true,
	[CollectibleType.COLLECTIBLE_ALABASTER_BOX] = true,
	[CollectibleType.COLLECTIBLE_GENESIS] = true,
	[CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE] = true,
	[CollectibleType.COLLECTIBLE_R_KEY] = true,
	[FiendFolio.ITEM.COLLECTIBLE.CONTRABAND] = true,
	[FiendFolio.ITEM.COLLECTIBLE.WRONG_WARP] = true,
	[FiendFolio.ITEM.COLLECTIBLE.RAT_POISON] = true,
	[FiendFolio.ITEM.COLLECTIBLE.ERRORS_CRAZY_SLOTS] = true,
	[FiendFolio.ITEM.COLLECTIBLE.MAMMONITE_CODEX] = true,
	[FiendFolio.ITEM.COLLECTIBLE.TOYBOX] = true,
}

--List of all zodiac items, includes vanilla stuff and zodiac, used for zodiac beggar
FiendFolio.ZodiacItems = {
	CollectibleType.COLLECTIBLE_ZODIAC,
	CollectibleType.COLLECTIBLE_TAURUS,
	CollectibleType.COLLECTIBLE_ARIES,
	CollectibleType.COLLECTIBLE_CANCER,
	CollectibleType.COLLECTIBLE_LEO,
	CollectibleType.COLLECTIBLE_VIRGO,
	CollectibleType.COLLECTIBLE_LIBRA,
	CollectibleType.COLLECTIBLE_SCORPIO,
	CollectibleType.COLLECTIBLE_SAGITTARIUS,
	CollectibleType.COLLECTIBLE_CAPRICORN,
	CollectibleType.COLLECTIBLE_AQUARIUS,
	CollectibleType.COLLECTIBLE_PISCES,
	CollectibleType.COLLECTIBLE_GEMINI,
	mod.ITEM.COLLECTIBLE.OPHIUCHUS,
	mod.ITEM.COLLECTIBLE.MUSCA,
	mod.ITEM.COLLECTIBLE.CETUS,
}

--List of all planetarium items, includes vanilla stuff, used for zodiac beggar and monas hieroglyphica (it doesn't allow itself)
FiendFolio.PlanetariumItems = {
	CollectibleType.COLLECTIBLE_SOL,
	CollectibleType.COLLECTIBLE_LUNA,
	CollectibleType.COLLECTIBLE_MERCURIUS,
	CollectibleType.COLLECTIBLE_VENUS,
	CollectibleType.COLLECTIBLE_TERRA,
	CollectibleType.COLLECTIBLE_MARS,
	CollectibleType.COLLECTIBLE_JUPITER,
	CollectibleType.COLLECTIBLE_SATURNUS,
	CollectibleType.COLLECTIBLE_URANUS,
	CollectibleType.COLLECTIBLE_NEPTUNUS,
	CollectibleType.COLLECTIBLE_PLUTO,
	mod.ITEM.COLLECTIBLE.DEIMOS,
	mod.ITEM.COLLECTIBLE.MONAS_HIEROGLYPHICA,
	mod.ITEM.COLLECTIBLE.NYX,
	mod.ITEM.COLLECTIBLE.GANYMEDE,
	mod.ITEM.COLLECTIBLE.PLANET_X,
	mod.ITEM.COLLECTIBLE.GKUNHOMDIMA,
}

--Whitelist of familiars that Googly Eyes can apply to (Automatically applies to familiars without offensive tag)
--If you give a table, you can set the general eye positions (Vector Offset, Eye Width). Setting it to false will blacklist it instead.
--Default height is -31 and width is 10
--I DIDNT WANT TO MAKE A BLACKLIST ITEM AGAIN AAAAAGH I FORGOT OFFENSIVE TAG WAS FOR TAINTED LOST MOSTLY
FiendFolio.GooglyEyesWhitelist = {
	[FamiliarVariant.PEEPER] = {Vector(0, -36)},
	[FamiliarVariant.BOMB_BAG] = true,
	[FamiliarVariant.SACK_OF_PENNIES] = true,
	[FamiliarVariant.LITTLE_CHAD] = {Vector(0, -35)},
	[FamiliarVariant.BUM_FRIEND] = true,
	[FamiliarVariant.KEY_PIECE_1] = {Vector(-4, -25)},
	[FamiliarVariant.KEY_PIECE_2] = {Vector(4, -25)},
	[FamiliarVariant.KEY_FULL] = {Vector(0, -25), 13},
	[FamiliarVariant.FOREVER_ALONE] = true,
	[FamiliarVariant.DISTANT_ADMIRATION] = true,
	[FamiliarVariant.DEAD_CAT] = {Vector(0, -20), 8},
	[FamiliarVariant.GUPPYS_HAIRBALL] = {Vector(0, -24)},
	[FamiliarVariant.ONE_UP] = {Vector(0, -20)},
	[FamiliarVariant.JUICY_SACK] = {Vector(0, -26)},
	[FamiliarVariant.HEADLESS_BABY] = true,
	[FamiliarVariant.MYSTERY_SACK] = true,
	[FamiliarVariant.BBF] = {Vector(0, -22)},
	[FamiliarVariant.DARK_BUM] = true,
	[FamiliarVariant.BIG_FAN] = {Vector(0, -25)},
	[FamiliarVariant.SISSY_LONGLEGS] = {Vector(0, -25), 6},
	[FamiliarVariant.PUNCHING_BAG] = {Vector(0, -28)},
	[FamiliarVariant.SAMSONS_CHAINS] = {Vector(0, -15)},
	[FamiliarVariant.LIL_CHEST] = {Vector(0, -24)},
	[FamiliarVariant.FRIEND_ZONE] = true,
	[FamiliarVariant.LOST_FLY] = true,
	[FamiliarVariant.CHARGED_BABY] = true,
	[FamiliarVariant.KEY_BUM] = true,
	[FamiliarVariant.RUNE_BAG] = true,
	[FamiliarVariant.GB_BUG] = true,
	[FamiliarVariant.SPIDER_MOD] = {Vector(0, -10)},
	[FamiliarVariant.OBSESSED_FAN] = true,
	[FamiliarVariant.MULTIDIMENSIONAL_BABY] = true,
	[FamiliarVariant.SUPER_BUM] = true,
	[FamiliarVariant.TONSIL] = true,
	[FamiliarVariant.DEPRESSION] = true,
	[FamiliarVariant.SHADE] = true,
	[FamiliarVariant.KING_BABY] = {Vector(0, -28)},
	[FamiliarVariant.YO_LISTEN] = {Vector(0, -14)},
	[FamiliarVariant.ACID_BABY] = true,
	[FamiliarVariant.SPIDER_BABY] = {Vector(0, -10)},
	[FamiliarVariant.SACK_OF_SACKS] = true,
	[FamiliarVariant.PEEPER_2] = {Vector(0, -36)},
	[FamiliarVariant.KNIFE_PIECE_1] = true,
	[FamiliarVariant.KNIFE_PIECE_2] = true,
	[FamiliarVariant.TINYTOMA_2] = {Vector(0,-25)},
	[FamiliarVariant.PASCHAL_CANDLE] = true,
	[FamiliarVariant.STITCHES] = true,
	[FamiliarVariant.LIL_PORTAL] = {Vector(0,-14)},
	[FamiliarVariant.WORM_FRIEND] = true,
	[FamiliarVariant.STAR_OF_BETHLEHEM] = true,
	[FamiliarVariant.CUBE_BABY] = true,
	[FamiliarVariant.UMBILICAL_BABY] = false,
	[FamiliarVariant.VANISHING_TWIN] = true,
	[FiendFolio.ITEM.FAMILIAR.DICE_BAG] = true,
	[FiendFolio.ITEM.FAMILIAR.LIL_FIEND] = true,
	[FiendFolio.ITEM.FAMILIAR.MERN_1] = true,
	[FiendFolio.ITEM.FAMILIAR.GRABBER .. " " .. 0] = {Vector(0,-21)},
	[FiendFolio.ITEM.FAMILIAR.GORGON] = true,
	[FiendFolio.ITEM.FAMILIAR.PETROCK] = {Vector(0, -11), 13},
	[FiendFolio.ITEM.FAMILIAR.BABY_ORB] = {Vector(0,-20), 9},
	[FiendFolio.ITEM.FAMILIAR.GREG] = {Vector(0,-29), 8},
	[FiendFolio.ITEM.FAMILIAR.ORANGE_BOOM_FLY] = {Vector(0,-27)},
	[FiendFolio.ITEM.FAMILIAR.ROBOBABY3] = true,
	[FiendFolio.ITEM.FAMILIAR.STAR_SAPPHIRE_GEM] = true,
	[FiendFolio.ITEM.FAMILIAR.SUNSHARD_FAMILIAR] = true,
	[FiendFolio.ITEM.FAMILIAR.TIGERS_EYE] = true,
	[FiendFolio.ITEM.FAMILIAR.SACK_OF_SPICY] = true,
	[FiendFolio.ITEM.FAMILIAR.REDHAND] = true,
	[FiendFolio.ITEM.FAMILIAR.D3] = true,
	[FiendFolio.ITEM.FAMILIAR.CLUTCHS_CURSE] = true,
	[FiendFolio.ITEM.FAMILIAR.PET_PEEVE] = {Vector(0, -17)},
	[FiendFolio.ITEM.FAMILIAR.BAG_OF_BOBBIES] = true,
	[FiendFolio.ITEM.FAMILIAR.TOKEN_BAG] = true,
	--[FiendFolio.ITEM.FAMILIAR.STONEY_GAPER] = true,
	[FiendFolio.ITEM.FAMILIAR.D5] = true,
	[FiendFolio.ITEM.FAMILIAR.TIME_IS_MONEY] = {Vector(0,-23), 12},
	[FiendFolio.ITEM.FAMILIAR.SWEET_RED_BRAMBLE] = {Vector(0,-25)},
	[FiendFolio.ITEM.FAMILIAR.RAINCLOUD] = {Vector(0,-38)},
	--[FiendFolio.ITEM.FAMILIAR.SNAGS] = true,
	[FiendFolio.ITEM.FAMILIAR.PLASMA_BALL] = {Vector(0,-19)},
	[FiendFolio.ITEM.FAMILIAR.APOTHEOSIS_ORBITAL] = true,
	[FiendFolio.ITEM.FAMILIAR.THE_SUN] = true,
	[FiendFolio.ITEM.FAMILIAR.PLANET_X] = true,
	[FiendFolio.ITEM.FAMILIAR.BABY_BELL] = true,
	[FiendFolio.ITEM.FAMILIAR.BLACK_CANDELABRA] = true,
	[FiendFolio.ITEM.FAMILIAR.DEVILSKNIFE] = true,
	[FiendFolio.ITEM.FAMILIAR.CRY_BABY] = true,
	[FiendFolio.ITEM.FAMILIAR.WHITE_RABBIT] = true,
	[FiendFolio.ITEM.FAMILIAR.DEVILS_HARVEST] = {Vector(0,-14)},
	[FiendFolio.ITEM.FAMILIAR.RED] = {Vector(0,-20)},
	[FiendFolio.ITEM.FAMILIAR.SKIBIDI_BABY] = {Vector(0,-24), 9},
}

-- Similar but not identical to the list above
-- Creep-leaving familiars may not technically deal damage to enemies but I think they count as Combat-Familiars
mod.NonCombatFamiliars = {
	-- Sacks (and Little C.H.A.D.)
	[FamiliarVariant.BOMB_BAG] = true,
	[FamiliarVariant.SACK_OF_PENNIES] = true,
	[FamiliarVariant.MYSTERY_SACK] = true,
	[FamiliarVariant.LIL_CHEST] = true,
	[FamiliarVariant.RUNE_BAG] = true,
	[FamiliarVariant.SACK_OF_SACKS] = true,
	[FamiliarVariant.RELIC] = true,
	[FamiliarVariant.LITTLE_CHAD] = true,
	[FiendFolio.ITEM.FAMILIAR.DICE_BAG] = true,
	[FiendFolio.ITEM.FAMILIAR.SACK_OF_SPICY] = true,
	[FiendFolio.ITEM.FAMILIAR.TOKEN_BAG] = true,

	-- Bums
	[FamiliarVariant.BUM_FRIEND] = true,
	[FamiliarVariant.DARK_BUM] = true,
	[FamiliarVariant.KEY_BUM] = true,
	[FamiliarVariant.SUPER_BUM] = true,

	-- Purely Decorative
	[FamiliarVariant.DEAD_CAT] = true,
	[FamiliarVariant.ONE_UP] = true,
	[FamiliarVariant.PASCHAL_CANDLE] = true,
	[FamiliarVariant.VANISHING_TWIN] = true,
	[FiendFolio.ITEM.FAMILIAR.TIME_IS_MONEY] = true,
	[FiendFolio.ITEM.FAMILIAR.BLACK_CANDELABRA] = true,
	[FiendFolio.ITEM.FAMILIAR.DEVILS_HARVEST] = true,
	[FiendFolio.ITEM.FAMILIAR.RED] = true,

	-- Utility Familiars
	[FamiliarVariant.YO_LISTEN] = true,
	[FamiliarVariant.LIL_PORTAL] = true,
	[FamiliarVariant.ITEM_WISP] = true,
	[FiendFolio.ITEM.FAMILIAR.PETROCK] = true,
	[FiendFolio.ITEM.FAMILIAR.BLUE_KEYGHOST] = true,
	[FiendFolio.ITEM.FAMILIAR.GREEN_KEYGHOST] = true,
	[FiendFolio.ITEM.FAMILIAR.RED_KEYGHOST] = true,
	[FiendFolio.ITEM.FAMILIAR.BOSS_KEYGHOST] = true,
	[FiendFolio.ITEM.FAMILIAR.COINGHOST] = true,

	-- Destroyed on Damage
	[FamiliarVariant.MILK] = true,
	[FamiliarVariant.HALLOWED_GROUND] = true,

	-- Other
	[FamiliarVariant.KEY_PIECE_1] = true,
	[FamiliarVariant.KEY_PIECE_2] = true,
	[FamiliarVariant.KEY_FULL] = true,
	[FamiliarVariant.KNIFE_PIECE_1] = true,
	[FamiliarVariant.KNIFE_PIECE_2] = true,
	[FamiliarVariant.ISAACS_HEART] = true,
	[FamiliarVariant.DAMOCLES] = true,
	[FamiliarVariant.BLOOD_OATH] = true,
	[FamiliarVariant.LOST_SOUL] = true,
	[FamiliarVariant.FORGOTTEN_BODY] = true,
	[FiendFolio.ITEM.FAMILIAR.SWEET_RED_BRAMBLE] = true,
	[FiendFolio.ITEM.FAMILIAR.WHITE_RABBIT] = true,
	[FiendFolio.ITEM.FAMILIAR.WORMHOLE_ROCK_PORTAL] = true,
	[FiendFolio.ITEM.FAMILIAR.FF_BOOK_HELPER] = true,
	[FiendFolio.ITEM.FAMILIAR.INABA_SATELLITE] = true,
	[FiendFolio.ITEM.FAMILIAR.MYSTERIOUS_STRANGER] = true,
}

--Used by deck box + soul extraction bum
mod.OffensiveCards = { -- Used for spawning from enemies, NOT for filtering what can go in the box
	-- Vanilla
	Card.CARD_MAGICIAN,
	Card.CARD_HIGH_PRIESTESS,
	Card.CARD_EMPRESS,
	-- Card.CARD_CHARIOT, -- Don't love the invincibility, too defensive
	Card.CARD_STRENGTH,
	Card.CARD_DEATH,
	Card.CARD_DEVIL,
	Card.CARD_TOWER,
	Card.CARD_REVERSE_STRENGTH,
	Card.CARD_EMERGENCY_CONTACT,

	-- FiendFolio
	mod.ITEM.CARD.PLUS_3_FIREBALLS,
	mod.ITEM.CARD.IMPLOSION,
	mod.ITEM.CARD.CALLING_CARD,
	mod.ITEM.CARD.GROTTO_BEAST,
	mod.ITEM.CARD.CARDJITSU_SOCCER,
	mod.ITEM.CARD.CARDJITSU_FLOORING_UPGRADE,
	mod.ITEM.CARD.MISPRINTED_GISH,
	mod.ITEM.CARD.ENERGY_GRASS,
	mod.ITEM.CARD.ENERGY_FIRE,
	mod.ITEM.CARD.ENERGY_WATER,
	mod.ITEM.CARD.ENERGY_LIGHTNING,
	mod.ITEM.CARD.ENERGY_FIGHTING,
	mod.ITEM.CARD.ENERGY_PSYCHIC,
	mod.ITEM.CARD.ENERGY_COLORLESS,
	mod.ITEM.CARD.ENERGY_DARKNESS,
	mod.ITEM.CARD.ENERGY_METAL,
	mod.ITEM.CARD.ENERGY_DRAGON,
	mod.ITEM.CARD.ENERGY_FAIRY,
	mod.ITEM.CARD.TWO_OF_SWORDS,
	mod.ITEM.CARD.THREE_OF_SWORDS,
	mod.ITEM.CARD.MISPRINTED_JACK_OF_CLUBS,
	mod.ITEM.CARD.THE_INVISIBLE_MOON,
	mod.ITEM.CARD.ABERRANT_TOWER,
	mod.ITEM.CARD.FRIENDLY_FIRE,
	mod.ITEM.CARD.TRIBUNAL_OF_GOOD_AND_EVIL,
	mod.ITEM.CARD.DANCE_OF_USURPATION,
	mod.ITEM.CARD.HAUNTED_HOUSE,
	mod.ITEM.CARD.ELF_SONG,
}

-- Champion blacklist
FiendFolio.BlacklistedChampions = {
	{mod.FF.Anemone.ID, mod.FF.Anemone.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.Cherub.ID, mod.FF.Cherub.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.Glorf.ID, mod.FF.Glorf.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.Coconut.ID, mod.FF.Coconut.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.Fishy.ID, mod.FF.Fishy.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.Catfish.ID, mod.FF.Catfish.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.Squid.ID, mod.FF.Squid.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.Bub.ID, mod.FF.Bub.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.Shirk.ID, mod.FF.Shirk.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.Rotdrink.ID, mod.FF.Rotdrink.Var, -1,
		{[ChampionColor.DARK_RED] = true,
		[ChampionColor.PULSE_GREEN] = true,}
	},
	{mod.FF.Kukodemon.ID, mod.FF.Kukodemon.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.MazeRunner.ID, mod.FF.MazeRunner.Var, -1,
		{[ChampionColor.DARK_RED] = true,
		[ChampionColor.PULSE_GREEN] = true,}
	},
	{mod.FF.ShockCollar.ID, mod.FF.ShockCollar.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.Puffer.ID, mod.FF.Puffer.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.Dolphin.ID, mod.FF.Dolphin.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.Madhat.ID, mod.FF.Madhat.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.Floaty.ID, mod.FF.Floaty.Var, mod.FF.Floaty.Sub,
		{[ChampionColor.PULSE_GREEN] = true,}
	},
	{mod.FF.Bunch.ID, mod.FF.Bunch.Var, -1,
		{[ChampionColor.DARK_RED] = true,
		[ChampionColor.PULSE_GREEN] = true,}
	},
	{mod.FF.FlagpoleHead.ID, mod.FF.FlagpoleHead.Var, -1,
		{[ChampionColor.GREEN] = true,}
	},
	{mod.FF.LittleBoy.ID, mod.FF.LittleBoy.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.ManAtArms.ID, mod.FF.ManAtArms.Var, -1,
		{[ChampionColor.DARK_RED] = true,
		[ChampionColor.CAMO] = true}
	},
	{mod.FF.Elephant.ID, mod.FF.Elephant.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.ElephantJr.ID, mod.FF.ElephantJr.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.SplitEar.ID, mod.FF.SplitEar.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.EarSplitter.ID, mod.FF.EarSplitter.Var, -1,
		{[ChampionColor.DARK_RED] = true,
		[ChampionColor.TRANSPARENT] = true,}
	},
	{mod.FF.ErodedHost.ID, mod.FF.ErodedHost.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.Smidgen.ID, mod.FF.Smidgen.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.ErodedSmidgen.ID, mod.FF.ErodedSmidgen.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.Tittle.ID, mod.FF.Tittle.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.SludgeHost.ID, mod.FF.SludgeHost.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.Cappin.ID, mod.FF.Cappin.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.Haunted.ID, mod.FF.Haunted.Var, -1,
		{[ChampionColor.DARK_RED] = true,
		[ChampionColor.PULSE_GREEN] = true}
	},
	{mod.FF.Crisply.ID, mod.FF.Crisply.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.Dim.ID, mod.FF.Dim.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.DimGhost.ID, mod.FF.DimGhost.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{mod.FF.Trashbagger.ID, mod.FF.Trashbagger.Var, -1,
		{[ChampionColor.DARK_RED] = true}
	},
	{EntityType.ENTITY_CLICKETY_CLACK, 0, -1,
		{[ChampionColor.PULSE_RED] = true}
	},
	{mod.FF.ClicketyChar.ID, mod.FF.ClicketyChar.Var, -1,
		{[ChampionColor.WHITE] = true,
		[ChampionColor.PULSE_RED] = true}
	},
	{mod.FF.Panini.ID, mod.FF.Panini.Var, mod.FF.Panini.Sub,
		{[ChampionColor.PULSE_GREEN] = true}
	},
	{mod.FF.Tinkle.ID, mod.FF.Tinkle.Var, -1,
		{[ChampionColor.DARK_RED] = true,
		[ChampionColor.PULSE_GREEN] = true,}
	},
	{mod.FF.Toadsie.ID, mod.FF.Toadsie.Var, -1,
		{
			[ChampionColor.GREEN] = true,
			[ChampionColor.PURPLE] = true,
			[ChampionColor.DARK_RED] = true,
			[ChampionColor.PULSE_GREEN] = true,
			[ChampionColor.PULSE_GREY] = true,
			[ChampionColor.PULSE_RED] = true,
			[ChampionColor.KING] = true,
			[ChampionColor.DEATH] = true,
			[ChampionColor.RAINBOW] = true,
		},
	},
	{mod.FF.Soothsayer.ID, mod.FF.Soothsayer.Var, -1,
		{	
			[ChampionColor.YELLOW] = true,
			[ChampionColor.TRANSPARENT] = true,
			[ChampionColor.FLICKER] = true,
			[ChampionColor.CAMO] = true,
			[ChampionColor.PULSE_GREEN] = true,
			[ChampionColor.TINY] = true,
			[ChampionColor.RAINBOW] = true,
		}
	},
	{mod.FF.Slim.ID, mod.FF.Slim.Var, -1,
		{[ChampionColor.PULSE_GREEN] = true,}
	},
	{mod.FF.PaleSlim.ID, mod.FF.PaleSlim.Var, -1,
		{[ChampionColor.PULSE_GREEN] = true,}
	},
	{mod.FF.Grim.ID, mod.FF.Grim.Var, -1,
		{[ChampionColor.PULSE_GREEN] = true,}
	},
	{EntityType.ENTITY_VIS_FATTY, 1, -1,
		{	
			[ChampionColor.YELLOW] = true,
			[ChampionColor.TINY] = true,
			[ChampionColor.RAINBOW] = true,
		}
	},
}

-- Steven's Hat blacklist
mod.StevensHatBlacklist = {
	-- Pickups variants
	Pickups = {
		-- Vanilla
		[ PickupVariant.PICKUP_THROWABLEBOMB ] = true,
		[ PickupVariant.PICKUP_COLLECTIBLE ] = true,
		[ PickupVariant.PICKUP_BROKEN_SHOVEL ] = true,
		[ PickupVariant.PICKUP_SHOPITEM ] = true,
		[ PickupVariant.PICKUP_BIGCHEST ] = true,
		[ PickupVariant.PICKUP_TROPHY ] = true,
		[ PickupVariant.PICKUP_BED ] = true,

		-- FF
		[ mod.PICKUP.VARIANT.PUZZLE_KEY ] = true,
		[ mod.PICKUP.VARIANT.GATECURSE_KEY ] = true,
		[ mod.PICKUP.VARIANT.ANNOYING_WHITE_RABBIT_IDLE ] = true,
	},

	-- Slot variants
	Slots = {
		[ SlotVariant.HOME_CLOSET_PLAYER ] = true,
	},
}

-- Infestation 0
mod.NonEnemyNpcTypes = {
	[17] = true,	-- Shopkeeper
	[33] = true, 	-- Fireplace
	[42] = true, 	-- Grimaces
	[44] = true,	-- Poky
	[202] = true,	-- Constant Stone Shooter
	[292] = true,	-- Pushable TNT
	[951] = true,	-- Beast Background Elements
	[960] = true, 	-- Furniture
	[963] = true,	-- Frozen Enemy
	[965] = true,	-- Minecart
	[966] = true,	-- Siren Helper
	[967] = true,	-- Hornfel Door
}