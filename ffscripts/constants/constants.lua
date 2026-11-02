local mod = FiendFolio

--Most important one out the way first
FiendFolio.CountingChannelWorldRecords = {
	Canon = {
		Regular 		= 1076,
		Hardcore 		= 523,
	},
	Additional = {
		Lettering 		= 332, --T************
		Impossible 		= 331,
	},
	Retired = {
		UltraKaizo 		= 1001,
		Base64			= 1, --A (never got off the ground)
		Whale			= 110,
		Base36 			= 261, -- 79
	}
}

FiendFolio.Developers = {"fiend", "amy", "balgor", "budj", "blorengerhymes", "bustin blotch", "cadence (ciirulean)", "cake", "catinsurance", "cometz", "connor", "deadinfinity", "erfly", "ferrium" ,"foxgirlyuri (maria)","funkengine","guillotine-21", "gummy", "guwahavel", "happyhead", "hippocrunchy", "jd", "jerb", "jm2k (julia)", "jordy", "junebeah", "minichibis", "narillia", "notyoursagittarius", "oilyspoily", "orisghost", "oroshibu", "peas", "peribot", "pixl", "pixelplz", "pkpseudo", "poyo", "redrachis", "renren", "sadly just al", "sbody2", "sin", "snakeblock", "sunil_b", "taigatreant", "thx", "titaniumgrunt7 (vermin)", "xalum"}

FiendFolio.CanadianExchangeRate = 1.40

--Colours
FiendFolio.ColorNormal = 		Color(1,1,1,1,0,0,0)
FiendFolio.ColorInvisible = 	Color(1,1,1,0,0,0,0)
--Please use DankBlackReal its so much better
FiendFolio.ColorDankBlack = 	Color(0.1,0.4,0.4,1,0,0,0)
FiendFolio.ColorPsy = 			Color(0.4,0.4,0.4,1,66 / 255,13 / 255,102 / 255)
FiendFolio.ColorPsy2 = 			Color(0.6,0.6,0.6,0.7,66 / 255,13 / 255,102 / 255)
FiendFolio.ColorPsy3 = 			Color(0.6,0.6,0.6,0.7,96 / 255,33 / 255,152 / 255)
FiendFolio.ColorPsyGrape = 		Color(0.2,0.2,0.2,1,66 / 255,13 / 255,102 / 255)
FiendFolio.ColorPsyGrape2 = 	Color(0.35,0.35,0.35,1,66 / 255,13 / 255,102 / 255)
FiendFolio.ColorGutbuster =		Color(0.37,0.37,0.4,1,0,0,0)
FiendFolio.ColorKrassBlaster =	Color(0.36,0.34,0.32,1,0,0,0)
FiendFolio.ColorDopeHead =		Color(67/255,67/255,67/255,1)
FiendFolio.ColorFishfreak =		Color(99/255,99/255,99/255,1,0,0,0)
FiendFolio.ColorPiss =			Color(1,7,0.4,1,0,0,0)
FiendFolio.ColorSoy =			Color(1.2,1,0.7,1,0,0,0)
FiendFolio.ColorSoyRedOffst =	Color(1,8.5,8.5,1,0,40 / 255,30 / 255)
FiendFolio.ColorPoop = 			Color(0,0,0,1,55 / 255,35 / 255,30 / 255)
FiendFolio.ColorChili = 		Color(0,0,0,1,80 / 255,35 / 255,30 / 255)
FiendFolio.ColorBrowniePoop = 	Color(0,0,0,1,0.6,0.4,0)
FiendFolio.ColorFadedBrowniePoop = Color(0,0,0,0.25,0.6,0.4,0)
FiendFolio.ColorGhostly =		Color(0,0,0,0.3,204 / 255,204 / 255,204 / 255)
FiendFolio.ColorCharred = 		Color(0.1,0.1,0.1,1,0,0,0)
FiendFolio.ColorFireJuicy = 	Color(0,0,0,1,1,0.5,0)
FiendFolio.ColorIpecac = 		Color(0.6,3,1,1,0,0,0)
FiendFolio.ColorSpittyGreen = 	Color(0.8,1,0.6,1,0.2,0.4,0)
	FiendFolio.ColorSpittyGreen:SetColorize(1,1,1,1)
FiendFolio.ColorWaterPeople = 	Color(0,0,0,0.15,91 / 255,229 / 255,220 / 255);
FiendFolio.ColorPoopyPeople = 	Color(0,0,0,0.15,144 / 255,155 / 255,102 / 255);
FiendFolio.ColorModernOuroborosShitty = Color(0,0,0,1,0.324117,0.304271,0.249231);
FiendFolio.ColorDemonBlack = 	Color(0.1,0,0,1,0,0,0)
FiendFolio.ColorRockGibs =		Color(140/255, 123/255, 123/255, 1, 0, 0, 0)
FiendFolio.ColorKickDrumsAndRedWine = Color(0.5,0,0,1,0,0,0)
	FiendFolio.ColorKickDrumsAndRedWine:SetColorize(5,0,2,1)
FiendFolio.ColorBishopWhite = Color(1, 1, 1, 1, 0.15, 0.15, 0.2)
	FiendFolio.ColorBishopWhite:SetColorize(2,2,2,1)
FiendFolio.ColorRadiationExplosion = Color(1,1,1,1)
	FiendFolio.ColorRadiationExplosion:SetColorize(0.4,2,0.5,1)

--Good Colours
FiendFolio.ColorIpecacProper = Color(1,1,1,1,0,0,0)
	FiendFolio.ColorIpecacProper:SetColorize(0.7, 2, 0.7, 1)
FiendFolio.ColorIpecacDross = Color(1,1,1,1,0,0,0)
	FiendFolio.ColorIpecacDross:SetColorize(1.3, 1.8, 0.5, 1)
FiendFolio.ColorPissGood = Color(1,1,1,1,0,0,0)
	FiendFolio.ColorPissGood:SetColorize(2.5, 1.9, 0.5, 1)
FiendFolio.ColorPiss2 = Color(1,1,1,1,0,0,0)
	FiendFolio.ColorPiss2:SetColorize(3.5, 1.9, 0.5, 1)
FiendFolio.ColorModernOuroboros = Color(1,1,1,1,0,0,0)
	FiendFolio.ColorModernOuroboros:SetColorize(0.54,0.51,0.42, 1)
FiendFolio.ColorMinMinFire = Color(1,1,1,1,0.3,0.25,0.05)
	FiendFolio.ColorMinMinFire:SetColorize(1, 0.8, 0.1, 1)
FiendFolio.ColorDrossWater = Color(0.2,1,0.1,1,0,0,0)
	FiendFolio.ColorDrossWater:SetColorize(1,0.7,1,0.7)
FiendFolio.ColorDankBlackReal = Color(1,1,1,1,0,0,0)
	FiendFolio.ColorDankBlackReal:SetColorize(1,1,1,1)
	FiendFolio.ColorDankBlackReal:SetTint(0.5,0.5,0.5,1)
FiendFolio.ColorDankBlackFake = Color(1,1,1,0,0,0,0)
	FiendFolio.ColorDankBlackFake:SetColorize(1,1,1,1)
	FiendFolio.ColorDankBlackFake:SetTint(0.5,0.5,0.5,0)
FiendFolio.ColorNastyFunny = Color(1,2,1,0.5)
	FiendFolio.ColorNastyFunny:SetColorize(0.6,0.7,0.6,1)
FiendFolio.DarkerWeird = Color(1,1,1)
	FiendFolio.DarkerWeird:SetColorize(0.6,0.6,0.6,1)
FiendFolio.ColorChinaYellow = Color(1,1,1,1,0.4,0.3,0.1)
	FiendFolio.ColorChinaYellow:SetColorize(0.95,0.8,0.3,1)
FiendFolio.ColorGrandpaWhiskey = Color(3.5,3.5,3.5,0.75,0,0,0)
	FiendFolio.ColorGrandpaWhiskey:SetColorize(229/255, 138/255, 2/255, 1)
FiendFolio.ColorGrandpaWhiskeyTear = Color(1,1,1,1,0,0,0)
	FiendFolio.ColorGrandpaWhiskeyTear:SetColorize(229/255, 138/255, 2/255, 1)
FiendFolio.ColorLeperRed = Color(1,1,1,1,0.3,0,0)
FiendFolio.ColorPrankCookieDoom = Color(0.30, 0.30, 0.30, 1.0, 10/255, -25/255, -25/255)
	FiendFolio.ColorPrankCookieDoom:SetColorize(0.75, 0.5, 0.5, 1.0)
FiendFolio.ColorFireballFormulaPurple = Color(1,1,1,1,0.3,0,1)
FiendFolio.ColorGunslingersGritPurple = Color(1,1,1,1,0.05,0,0.4)
FiendFolio.ColorGritWavePurple = Color(1,1,1, 1)
	FiendFolio.ColorGritWavePurple:SetColorize(160/255, 0, 240/255, 1)
FiendFolio.ColorShadow = Color(1, 1, 1, 0.4, -1, -1, -1)

--Guwah Colors :]
FiendFolio.ColorCrackleOrange = Color(1,1,1,1,1,0.3,0)
FiendFolio.ColorHoneyYellow = Color(1,1,1,1,0.7,0.4,0)
	FiendFolio.ColorHoneyYellow:SetColorize(1,1,1,1)
FiendFolio.ColorPeepPiss = Color(1,1,1,1,0.235,0.235,0)
	FiendFolio.ColorPeepPiss:SetColorize(1,1,0,1)
FiendFolio.ColorLemonYellow = Color(1,1,1,1,0.235,0.235,0)
	FiendFolio.ColorLemonYellow:SetColorize(3,2,1,1)
FiendFolio.ColorCarrotOrange = Color(1,1,1,1,0.5,0.3,0)
	FiendFolio.ColorCarrotOrange:SetColorize(2,1,1,1)
FiendFolio.ColorSoyCreep = Color(1,1,1,1,0.8,0.7,0.5)
FiendFolio.ColorWebWhite = Color(1,1,1,1,0.7,0.7,0.7)
	FiendFolio.ColorWebWhite:SetColorize(1,1,1,1)
FiendFolio.ColorPureWhite = Color(1,1,1,1,1,1,1)
	FiendFolio.ColorPureWhite:SetColorize(1,1,1,1)
FiendFolio.ColorPureWhitePale = Color(1,1,1,0.1,1,1,1)
	FiendFolio.ColorPureWhitePale:SetColorize(1,1,1,0.1)
FiendFolio.ColorPsy3ForMe = Color(0.6,0.6,0.6,1,96/255,33/255,152/255)
FiendFolio.ColorMinMinFireJuicier = Color(1,1,1,1,0.6,0.5,0.05)
	FiendFolio.ColorMinMinFireJuicier:SetColorize(1, 0.8, 0.1, 1)
FiendFolio.ColorCandleWax = Color(1,1,1,1,0.8,0.7,0.5)
	FiendFolio.ColorCandleWax:SetColorize(1,1,1,1)
FiendFolio.ColorRottenGreen = Color(0.8,0.8,0.8)
	FiendFolio.ColorRottenGreen:SetColorize(1,1.5,0.5,1)
FiendFolio.ColorShadyBlack = Color(0,0,0,1)
FiendFolio.ColorShadyRed = Color(-1,-1,-1,1,1,0,0)
FiendFolio.ColorCorpseGreen = Color(1,1,1,1)
	FiendFolio.ColorCorpseGreen:SetColorize(2,2,1,1)
FiendFolio.ColorCorpseGreen2 = Color(1,1,1,1)
	FiendFolio.ColorCorpseGreen2:SetColorize(0.6,1,0.3,1)
FiendFolio.ColorArcanePink = Color(1,1,1,1,0.4,0,0.4)
	FiendFolio.ColorArcanePink:SetColorize(1,1,1,1)
FiendFolio.ColorArcanePinkA = Color(1,1,1,0.6,0.4,0,0.4)
	FiendFolio.ColorArcanePinkA:SetColorize(1,1,1,1)
FiendFolio.ColorMausPurple = Color(1,1,1,1,0.3,0,0.6)
	FiendFolio.ColorMausPurple:SetColorize(1,1,1,1)
FiendFolio.ColorTelePurple = Color(1,1,1,1,0.6,0.2,0.8)
	FiendFolio.ColorTelePurple:SetColorize(1,1,1,1)
FiendFolio.ColorDarkPurple = Color(0.5,0.5,1,1,0.15,0,0.4)
	FiendFolio.ColorDarkPurple:SetColorize(1,1,1,1)
FiendFolio.ColorDarkPurpleLarrikin = Color(1,0.5,1,1,0,0,0)
	FiendFolio.ColorDarkPurpleLarrikin:SetColorize(0.8,0.6,1.1,1)
FiendFolio.ColorDarkPurpleGrape = Color(1,1,1,1,0.35,0,0.35)
	FiendFolio.ColorDarkPurpleGrape:SetColorize(1,0.5,1,1)
FiendFolio.ColorDarkerPurpleGrape = Color(1,1,1,1,0.5,0,0.5)
	FiendFolio.ColorDarkerPurpleGrape:SetColorize(0.35,0.35,0.35,1)
FiendFolio.ColorGurdyOrange = Color(0.5,0.5,0.5,1,0.6,0.4,0.16)
FiendFolio.ColorGreyscale = Color(1,1,1)
	FiendFolio.ColorGreyscale:SetColorize(1,1,1,1)
FiendFolio.ColorGreyscaleLight = Color(1,1,1,1,0.1,0.1,0.1)
	FiendFolio.ColorGreyscaleLight:SetColorize(1,1,1,1)
FiendFolio.ColorGreyscaleLightLaser = Color(1,1,1,1,0.6,0.6,0.6)
	FiendFolio.ColorGreyscaleLightLaser:SetColorize(1,1,1,1)
FiendFolio.ColorGreyscaleDarkLaser = Color(1,1,1,1,0.3,0.3,0.3)
	FiendFolio.ColorGreyscaleDarkLaser:SetColorize(1,1,1,1)
FiendFolio.ColorGreyscaleDark = Color(1,1,1,1,-0.3,-0.3,-0.3)
	FiendFolio.ColorGreyscaleDark:SetColorize(1,1,1,1)
FiendFolio.ColorSolidWater = Color(0,0,0,1,0.85,0.9,1)
FiendFolio.ColorLessSolidWater = Color(0,0,0,0.5,0.85,0.9,1)
FiendFolio.ColorMysteriousLiquid = Color(1,1,1,1,0,0,0)
	FiendFolio.ColorMysteriousLiquid:SetColorize(0.5, 2.5, 0.5, 1)
FiendFolio.ColorPlatinum = Color(1,1,1)
	FiendFolio.ColorPlatinum:SetColorize(4,4,4,1)
FiendFolio.ColorGolden = Color(1,1,1)
	FiendFolio.ColorGolden:SetColorize(4,2.5,1,1)
FiendFolio.ColorRoseGold = Color(1,0.8,0.8)
	FiendFolio.ColorRoseGold:SetColorize(10,1,1,1)
FiendFolio.ColorRoseGold2 = Color(1,1,1)
	FiendFolio.ColorRoseGold2:SetColorize(10,2.5,2.5,1)
FiendFolio.ColorSortaRed = Color(1,1,1,1,0.1,0,0)
FiendFolio.ColorModeratelyRed = Color(1,1,1,1,0.25,0,0)
FiendFolio.ColorDecentlyRed = Color(1,1,1,1,0.5,0,0)
FiendFolio.ColorBetterRedThanDead = Color(0,0,0,1,1,0.2,0.2)
	FiendFolio.ColorBetterRedThanDead:SetColorize(1,1,1,1)
FiendFolio.ColorWigglyMaggot = Color(1,1,1,1,0,0,0)
	FiendFolio.ColorWigglyMaggot:SetColorize(4,3,3,1)
FiendFolio.ColorStinkyCheese = Color(1,1,1,1,0.65,0.8,0.5)
	FiendFolio.ColorStinkyCheese:SetColorize(1,1,1,1)
FiendFolio.ColorBobsGreen = Color(0.2,0.5,0.2,1,0,0.3,0)
FiendFolio.ColorLegoOrange = Color(1,1,1,1,0.3,0.15,0.05)
	FiendFolio.ColorLegoOrange:SetColorize(1, 0.6, 0.1, 1)
FiendFolio.ColorMultidimensional = Color(-1,-1,-1,1,0.8,0.8,0.8)
	FiendFolio.ColorMultidimensional:SetColorize(1,1,1,1)
FiendFolio.ColorDullGray = Color(0,0,0,1,0.1,0.1,0.1)
FiendFolio.ColorRedPoop = Color(0.6,0.15,0.2)
FiendFolio.ColorRedNo3 = Color(1,0.2,0.25)
FiendFolio.ColorGravefireGreen = Color(0.6,1,0.6,1,0,0.6,0.1)
	FiendFolio.ColorGravefireGreen:SetColorize(1,1,1,1)
FiendFolio.ColorGrilled = Color(0,0,0,1,0.141,0.121,0.109)
FiendFolio.ColorConfusion = Color(0.5,0.5,0.5,1,0.157,0.157,0.157)
FiendFolio.ColorGehennaFire = Color(2,2,2,1,0,-1,-1)
FiendFolio.ColorGehennaFire2 = Color(2,2,2,1,0.8,0,-0.5)
FiendFolio.ColorToxicFart = Color(1,1,1,1,50 / 255,100 / 255,25 / 255)
	FiendFolio.ColorToxicFart:SetColorize(1,1,1,1)
FiendFolio.ColorButterFart = Color(1,1,0,1,100 / 255,50 / 255,30 / 255)
	FiendFolio.ColorButterFart:SetColorize(1,1,1,1)
FiendFolio.ColorGehennaFire2A = Color(2,2,2,0.6,0.8,0,-0.5)
FiendFolio.ColorVenomGreen = Color(1,1,1,1,0.2,0.6,0)
	FiendFolio.ColorVenomGreen:SetColorize(1,1,1,1)
FiendFolio.ColorGurgleGibs = Color(0.5,0.5,0.5,1,-0.2,0.5,0.2)
FiendFolio.ColorElectricYellow = Color(0.8,1,1,1,0.8,1)
FiendFolio.ColorElectricYellowA = Color(0.8,1,1,0.7,0.8,1)
FiendFolio.ColorCraigTears = Color(1,1,0.5,1,0.4,0.3,0.1)
	FiendFolio.ColorCraigTears:SetColorize(1,1,0,1)
FiendFolio.ColorFiendGuts = Color(0.3,0.5,1,1,0.35,0.15,0.35)
	FiendFolio.ColorFiendGuts:SetColorize(1,1,2,1)
FiendFolio.ColorAshGibs = Color(0,0,0,0.3,0.82,0.82,0.8)
FiendFolio.ColorFireyFade = Color(1,1,1,1,1,0.514,0.004)
	FiendFolio.ColorFireyFade:SetTint(0,0,0,1.1)
FiendFolio.ColorBulbSplat = Color(0,0,0,0.6,0.7,0.7,0)
FiendFolio.ColorSkeletalFiend = Color(1,1,1)
	FiendFolio.ColorSkeletalFiend:SetColorize(103/255,88/255,119/255,1)
FiendFolio.ColorFunkyBlue = Color(1,1,1,1)
	FiendFolio.ColorFunkyBlue:SetColorize(0.6,0.3,1,1)
FiendFolio.ColorFunkyRed = Color(1,1,1,1)
	FiendFolio.ColorFunkyRed:SetColorize(1,0.3,0.3,1)
FiendFolio.ColorTwitchyGibs = Color(1,1,1,1)
	FiendFolio.ColorTwitchyGibs:SetColorize(0.63,0.85,0.32,1)
FiendFolio.ColorPoisonMind = Color(0,1,0,1,0,0.2,0)
FiendFolio.ColorRainbowYellow = Color(1,1,1)
	FiendFolio.ColorRainbowYellow:SetColorize(2,1.5,0.5,1)
FiendFolio.ColorRainbowGreen = Color(1,1,1)
	FiendFolio.ColorRainbowGreen:SetColorize(0.5,1.5,0.5,1)
FiendFolio.ColorRainbowBlue = Color(1,1,1)
	FiendFolio.ColorRainbowBlue:SetColorize(0.5,0.5,1.5,1)
FiendFolio.ColorRainbowPurple = Color(1,1,1)
	FiendFolio.ColorRainbowPurple:SetColorize(1.25,0.5,1.5,1)
FiendFolio.ColorBlueBlue = Color(1,1,1,1,0,0.1,0.3)
	FiendFolio.ColorBlueBlue:SetColorize(0.5,0.5,1,1)
FiendFolio.ColorCyanGuts = Color(0.5,1,1,1)
    FiendFolio.ColorCyanGuts:SetColorize(2,3,3,1.25)
FiendFolio.ColorHotPink = Color(1,1,1,1)
	FiendFolio.ColorHotPink:SetColorize(3.0,0.5,2.0,1)


--Hate this
FiendFolio.ColorDebuffProj1 = Color(0.2,0.2,0.2,1)
FiendFolio.ColorDebuffProj2 = Color(0.2,0.2,0.2,1)
FiendFolio.ColorDebuffProj3 = Color(0.5,0.5,0.5,1)
FiendFolio.ColorDebuffProj4 = Color(1,1,1,1)
FiendFolio.ColorDebuffProj1:SetColorize(0.27,0.16,0.02,1)
FiendFolio.ColorDebuffProj2:SetColorize(0.1,0.1,0.1,1)
FiendFolio.ColorDebuffProj3:SetColorize(0.27,0.05,0.27,1)
FiendFolio.ColorDebuffProj4:SetColorize(0.53,0.53,0.53,1)

FiendFolio.duskDebuffCols = {
	FiendFolio.ColorDebuffProj1,
	FiendFolio.ColorDebuffProj2,
	FiendFolio.ColorDebuffProj3,
	FiendFolio.ColorDebuffProj4,
}
--Why can't I just do Color():SetColorize()
--For some god forsaken reason it does not work

FiendFolio.ColorDriedPaint1 = Color(1,1,1,1)
FiendFolio.ColorDriedPaint2 = Color(1,1,1,1)
FiendFolio.ColorDriedPaint3 = Color(1,1,1,1)
FiendFolio.ColorDriedPaint4 = Color(1,1,1,1)
FiendFolio.ColorDriedPaint1:SetColorize(1,248/255,102/255,1)
FiendFolio.ColorDriedPaint2:SetColorize(1,0,0,1)
FiendFolio.ColorDriedPaint3:SetColorize(51/255,120/255,169/255,1)
FiendFolio.ColorDriedPaint4:SetColorize(137/255,0,156/255,1)
FiendFolio.ColorDriedPaintRare = Color(1,1,1,1)
FiendFolio.ColorDriedPaintRare:SetColorize(0,226/255,51/255,1)

FiendFolio.ColorEyeOfProvidenceTear = Color(1,1,1,1,0.5,0.5,0.1)
FiendFolio.ColorWNICTear = Color(0.2,0.8,0.3,0.7,0,0.3, 0.05)
FiendFolio.ColorDarknessTear = Color(0.9,0.9,0.9,1,0,0.0, 0.0,1,1,1,1)
FiendFolio.ColorPalinopsiaTear = Color(0,0,0,1,1,1,1)

FiendFolio.ColorSoapsuds = Color(1.5, 1.5, 1.5, 1)
FiendFolio.ColorSoapsudsLaser = Color(1.5, 1.5, 1.5, 1, 0.7, 0.7, 0.7)

FiendFolio.damageFlashColor = Color(0.5, 0.5, 0.5, 1.0, 200/255, 0/255, 0/255)

FiendFolio.rancidtable = {EffectVariant.TINY_FLY, EffectVariant.TINY_FLY, EffectVariant.TINY_FLY, EffectVariant.TINY_FLY, EffectVariant.TINY_BUG, EffectVariant.TINY_BUG, EffectVariant.WALL_BUG, EffectVariant.BEETLE}
FiendFolio.bugtable = {EffectVariant.TINY_FLY, EffectVariant.TINY_FLY, EffectVariant.TINY_FLY, EffectVariant.TINY_BUG, EffectVariant.WALL_BUG, EffectVariant.BEETLE}
FiendFolio.pooplerancidtable = {EffectVariant.TINY_FLY, EffectVariant.TINY_FLY, EffectVariant.TINY_FLY, EffectVariant.TINY_FLY, EffectVariant.WORM, EffectVariant.WORM, EffectVariant.WORM, EffectVariant.BEETLE}
FiendFolio.bubbles = {0,0,0,0,1,1,1,2,2,3}

FiendFolio.Music = {
	BossTheme = Isaac.GetMusicIdByName("FiendFolioBoss"),
	BossOverJingle = Isaac.GetMusicIdByName("FiendFolioBossOverJingle"),
	BossAppear = Isaac.GetMusicIdByName("FiendFolioBossAppear"),
	HorsemanTheme = Isaac.GetMusicIdByName("FiendFolioHorseman"),
	HorsemanOverJingle = Isaac.GetMusicIdByName("FiendFolioHorsemanOverJingle"),
	HorsemanAppear = Isaac.GetMusicIdByName("FiendFolioHorsemanAppear"),
	RetroRoom = Isaac.GetMusicIdByName("FiendFolioRetroRoom"),
	CrawlSpace = Isaac.GetMusicIdByName("FiendFolioCrawlSpace"),
	BlackMarket = Isaac.GetMusicIdByName("FiendFolioBlackMarket"),
	AltBossTheme = Isaac.GetMusicIdByName("FiendFolioAltBoss"),
	AltBossOverJingle = Isaac.GetMusicIdByName("FiendFolioAltBossOverJingle"),
	AltBossAppear = Isaac.GetMusicIdByName("FiendFolioAltBossAppear"),
	BossOver = Isaac.GetMusicIdByName("FiendFolioBossOver"),
	DevilsHarvestGameOver = Isaac.GetMusicIdByName("DevilsHarvestGameOver"),
	MinibossTheme = Isaac.GetMusicIdByName("FiendFolioMiniboss"),
	MinibossOverJingle = Isaac.GetMusicIdByName("FiendFolioMinibossOverJingle"),
	Saloon = Isaac.GetMusicIdByName("FiendFolioSaloon"),
	PronounPalaceHeadline = Isaac.GetMusicIdByName("FiendFolioPronounPalaceHeadline"),
	PlenaNavitasRemix = Isaac.GetMusicIdByName("FiendFolioPlenaNavitasRemix"),
	DrollCall = Isaac.GetMusicIdByName("FiendFolioDrollCall"),

	Venus1 = Isaac.GetMusicIdByName("FiendFolioVenus1"),
	Venus3 = Isaac.GetMusicIdByName("FiendFolioVenus3"),
	Venus4 = Isaac.GetMusicIdByName("FiendFolioVenus4"),
	Venus5 = Isaac.GetMusicIdByName("FiendFolioVenus5"),
	Venus6 = Isaac.GetMusicIdByName("FiendFolioVenus6"),
	Venus7 = Isaac.GetMusicIdByName("FiendFolioVenus7"),
	Venus8 = Isaac.GetMusicIdByName("FiendFolioVenus8"),
	Cacophobia1 = Isaac.GetMusicIdByName("FiendFolioCacophobia1"),
	Cacophobia2 = Isaac.GetMusicIdByName("FiendFolioCacophobia2"),
	Cacophobia3 = Isaac.GetMusicIdByName("FiendFolioCacophobia3"),
	Cacophobia4 = Isaac.GetMusicIdByName("FiendFolioCacophobia4"),
	Cacophobia5 = Isaac.GetMusicIdByName("FiendFolioCacophobia5"),
	TheField = Isaac.GetMusicIdByName("FiendFolioTheField"),

	Skinless = Isaac.GetMusicIdByName("Skinless (Skinless)"),

	FriendGameOver01 = Isaac.GetMusicIdByName("FriendGameOver01"),
	FriendGameOver02 = Isaac.GetMusicIdByName("FriendGameOver02"),
	FriendGameOver03 = Isaac.GetMusicIdByName("FriendGameOver03"),
	FriendGameOver04 = Isaac.GetMusicIdByName("FriendGameOver04"),
}

FiendFolio.Backdrops = {
	SALOON = Isaac.GetBackdropIdByName("MilkSaloon"),
	FIENDS_LAIR = Isaac.GetBackdropIdByName("FiendsLair"),
	BIG_HORNS_LAIR = Isaac.GetBackdropIdByName("BigHornsLair"),
	CRYSTAL_CAVES = Isaac.GetBackdropIdByName("CrystalCaves"),
}

FiendFolio.SpecialRooms = {
	Saloon = {
		RoomType = RoomType.ROOM_ISAACS,
		SubType = 160,
	},
}

FiendFolio.Sounds = {
SplashSmall = Isaac.GetSoundIdByName("SplashSmall"),
SplashLarge = Isaac.GetSoundIdByName("SplashLarge"),
SplashLargePlonkless = Isaac.GetSoundIdByName("SplashLargePlonkless"),
Slurp = Isaac.GetSoundIdByName("Slurp"),
MukChargeUp = Isaac.GetSoundIdByName("MukChargeUp"),
MukCharge = Isaac.GetSoundIdByName("MukCharge"),
MukLaugh = Isaac.GetSoundIdByName("MukLaugh"),
MukVomit = Isaac.GetSoundIdByName("MukVomit"),
TemperAnger = Isaac.GetSoundIdByName("TemperAnger"),
TemperCharge = Isaac.GetSoundIdByName("TemperCharge"),
EpicTwinkle = Isaac.GetSoundIdByName("EpicTwinkle"),
EpicTwinkleV = Isaac.GetSoundIdByName("EpicTwinkleV"),
InsectSwarmLoop = Isaac.GetSoundIdByName("InsectSwarmLoop"),
LightningFlyBuzzLoop = Isaac.GetSoundIdByName("LightningFlyBuzzLoop"),
NimbusSigh = Isaac.GetSoundIdByName("NimbusSigh"),
NimbusShoot = Isaac.GetSoundIdByName("NimbusShoot"),
Tada = Isaac.GetSoundIdByName("Tada"),
WingFlap = Isaac.GetSoundIdByName("WingFlap"),
Skid = Isaac.GetSoundIdByName("Skid"),
FlashShakeyKidRoar = Isaac.GetSoundIdByName("FlashShakeyKidRoar"),
MonsterYellFlash = Isaac.GetSoundIdByName("MonsterYellFlash"),
Foresee = Isaac.GetSoundIdByName("Foresee"),
ForeseerClap = Isaac.GetSoundIdByName("ForeseerClap"),
Ricochet = Isaac.GetSoundIdByName("Ricochet"),
Lighter = Isaac.GetSoundIdByName("Lighter"),
Uke = Isaac.GetSoundIdByName("Uke"),
CoughRasp = Isaac.GetSoundIdByName("CoughRasp"),
FireballLand = Isaac.GetSoundIdByName("FireballLand"),
FireballLaunch = Isaac.GetSoundIdByName("FireballLaunch"),
MagicStrike = Isaac.GetSoundIdByName("MagicStrike"),
teleport = Isaac.GetSoundIdByName("teleport"),
fingersnap = Isaac.GetSoundIdByName("fingersnap"),
FireLight = Isaac.GetSoundIdByName("FireLight"),
FireFizzle = Isaac.GetSoundIdByName("FireFizzle"),
Baloon = Isaac.GetSoundIdByName("Baloon"),
BaloonShort = Isaac.GetSoundIdByName("BaloonShort"),
BaloonBounce = Isaac.GetSoundIdByName("BaloonBounce"),
LandSoft = Isaac.GetSoundIdByName("LandSoft"),
WateryBarf = Isaac.GetSoundIdByName("WateryBarf"),
WateryBarfShort = Isaac.GetSoundIdByName("WateryBarfShort"),
WateryBurble = Isaac.GetSoundIdByName("WateryBurble"),
BathtubFart = Isaac.GetSoundIdByName("BathtubFart"),
FrogHurgle = Isaac.GetSoundIdByName("FrogHurgle"),
FrogHurgleShort = Isaac.GetSoundIdByName("FrogHurgleShort"),
FrogShoot = Isaac.GetSoundIdByName("FrogShoot"),
SniffleShoot = Isaac.GetSoundIdByName("SniffleShoot"),
SniffleShootOldShort = Isaac.GetSoundIdByName("SniffleShootOldShort"),
FriedStart = Isaac.GetSoundIdByName("FriedStart"),
FriedLoop = Isaac.GetSoundIdByName("FriedLoop"),
FriedEnd = Isaac.GetSoundIdByName("FriedEnd"),
CrosseyeAppear = Isaac.GetSoundIdByName("CrosseyeAppear"),
CrosseyeShootLoop = Isaac.GetSoundIdByName("CrosseyeShootLoop"),
PsionBubble = Isaac.GetSoundIdByName("PsionBubble"),
PsionBubbleBreak = Isaac.GetSoundIdByName("PsionBubbleBreak"),
PsionDeath = Isaac.GetSoundIdByName("PsionDeath"),
PsionLeech = Isaac.GetSoundIdByName("PsionLeech"),
PsionRedirectLoop = Isaac.GetSoundIdByName("PsionRedirectLoop"),
PsionShoot = Isaac.GetSoundIdByName("PsionShoot"),
PsionSummon = Isaac.GetSoundIdByName("PsionSummon"),
PsionTaunt = Isaac.GetSoundIdByName("PsionTaunt"),
TapStart = Isaac.GetSoundIdByName("TapStart"),
TapTap = Isaac.GetSoundIdByName("TapTap"),
TapLoop = Isaac.GetSoundIdByName("TapLoop"),
TapEnd = Isaac.GetSoundIdByName("TapEnd"),
TapHoney01 = Isaac.GetSoundIdByName("TapHoney01"),
TapHoney02 = Isaac.GetSoundIdByName("TapHoney02"),
GnawfulNoises = Isaac.GetSoundIdByName("GnawfulNoises"),
GnawfulBite = Isaac.GetSoundIdByName("GnawfulBite"),
ShotgunBlast = Isaac.GetSoundIdByName("ShotgunBlast"),
LezSuck = Isaac.GetSoundIdByName("LezSuck"),
LezSwallow = Isaac.GetSoundIdByName("LezSwallow"),
LezEffectGet = Isaac.GetSoundIdByName("LezEffectGet"),
EpicPunch = Isaac.GetSoundIdByName("EpicPunch"),
ChainSnap = Isaac.GetSoundIdByName("ChainSnap"),
ShiScream = Isaac.GetSoundIdByName("ShiScream"),
Circus = Isaac.GetSoundIdByName("circus"),
CursedPennyNeutral = Isaac.GetSoundIdByName("CursedPennyNeutral"),
CursedPennyPositive = Isaac.GetSoundIdByName("CursedPennyPositive"),
CursedPennyPositiveSuper = Isaac.GetSoundIdByName("CursedPennyPositiveSuper"),
CursedPennyPositiveMega = Isaac.GetSoundIdByName("CursedPennyPositiveMega"),
CursedPennyNegative = Isaac.GetSoundIdByName("CursedPennyNegative"),
CursedPennyNegativeSuper = Isaac.GetSoundIdByName("CursedPennyNegativeSuper"),
CursedPennyNegativeMega = Isaac.GetSoundIdByName("CursedPennyNegativeMega"),
OverwatchOverwatch = Isaac.GetSoundIdByName("OverwatchOverwatch"),
GutbusterRun = Isaac.GetSoundIdByName("GutbusterRun"),
GriddleScream = Isaac.GetSoundIdByName("GriddleScream"),
GriddleDeath = Isaac.GetSoundIdByName("GriddleDeath"),
BuckAppear1 = Isaac.GetSoundIdByName("BuckAppear1"),
BuckAppear2 = Isaac.GetSoundIdByName("BuckAppear2"),
BuckCharge = Isaac.GetSoundIdByName("BuckCharge"),
BuckDeath1 = Isaac.GetSoundIdByName("BuckDeath1"),
BuckDeath2 = Isaac.GetSoundIdByName("BuckDeath2"),
BuckDeath3 = Isaac.GetSoundIdByName("BuckDeath3"),
BuckHeadRecover = Isaac.GetSoundIdByName("BuckHeadRecover"),
BuckRummage = Isaac.GetSoundIdByName("BuckRummage"),
BuckShoot = Isaac.GetSoundIdByName("BuckShoot"),
BuckSpit = Isaac.GetSoundIdByName("BuckSpit"),
BuckVictory = Isaac.GetSoundIdByName("BuckVictory"),
Baba = Isaac.GetSoundIdByName("Baba"),
Valvo = Isaac.GetSoundIdByName("Valvo"),
VerminAgony = Isaac.GetSoundIdByName("VerminAgony"),
VerminBreak = Isaac.GetSoundIdByName("VerminBreak"),
VerminGibs = Isaac.GetSoundIdByName("VerminGibs"),
VerminImpact = Isaac.GetSoundIdByName("VerminImpact"),
SteamTrain = Isaac.GetSoundIdByName("SteamTrain"),
SteamTrainWhistle = Isaac.GetSoundIdByName("SteamTrainWhistle"),
SpitumShoot = Isaac.GetSoundIdByName("SpitumShoot"),
SpitumCharge = Isaac.GetSoundIdByName("SpitumCharge"),
RolyPolyRoll = Isaac.GetSoundIdByName("RolyPolyRoll"),
Waterboom = Isaac.GetSoundIdByName("Waterboom"),
BascoBlast = Isaac.GetSoundIdByName("BascoBlast"),
WormScoot = Isaac.GetSoundIdByName("WormScoot"),
WormsReload = Isaac.GetSoundIdByName("WormsReload"),
LuncheonVom = Isaac.GetSoundIdByName("LuncheonVom"),
CartoonSlurp = Isaac.GetSoundIdByName("CartoonSlurp"),
CronchyWorms = Isaac.GetSoundIdByName("CronchyWorms"),
GhostHiding = Isaac.GetSoundIdByName("GhostHiding"),
GhostAngered = Isaac.GetSoundIdByName("GhostAngered"),
GhostAppear = Isaac.GetSoundIdByName("GhostAppear"),
GhostCalm = Isaac.GetSoundIdByName("GhostCalm"),
Hoot6 = Isaac.GetSoundIdByName("Hoot6"),
Bouja = Isaac.GetSoundIdByName("Bouja"),
PiperAttack = Isaac.GetSoundIdByName("PiperAttack"),
DripSuck = Isaac.GetSoundIdByName("DripSuck"),
FurnaceStart = Isaac.GetSoundIdByName("FurnaceStart"),
FurnaceLoop = Isaac.GetSoundIdByName("FurnaceLoop"),
FurnaceEnd = Isaac.GetSoundIdByName("FurnaceEnd"),
GraterEmege = Isaac.GetSoundIdByName("GraterEmege"),
GraterBurrow = Isaac.GetSoundIdByName("GraterBurrow"),
GraterShake = Isaac.GetSoundIdByName("GraterShake"),
GraterShakeShort = Isaac.GetSoundIdByName("GraterShakeShort"),
WardenCharge = Isaac.GetSoundIdByName("WardenCharge"),
WardenAttack = Isaac.GetSoundIdByName("WardenAttack"),
WardenHit = Isaac.GetSoundIdByName("WardenHit"),
StretchEye = Isaac.GetSoundIdByName("StretchEye"),
WhipCrack = Isaac.GetSoundIdByName("WhipCrack"),
--Pollution stuff started here man look at this
HorseGoWhee = Isaac.GetSoundIdByName("HorseGoWhee"),
BingBingWahoo = Isaac.GetSoundIdByName("BingBingWahoo"),
LoopingBike = Isaac.GetSoundIdByName("LoopingBike"),
CarIgnition = Isaac.GetSoundIdByName("CarIgnition"),
SlowMotor = Isaac.GetSoundIdByName("SlowMotor"),
SkateboardJump = Isaac.GetSoundIdByName("SkateboardJump"),
SkateboardLand = Isaac.GetSoundIdByName("SkateboardLand"),
SkidShort = Isaac.GetSoundIdByName("SkidShort"),
SkidUltraShort = Isaac.GetSoundIdByName("SkidUltraShort"),
PollutionLaugh = Isaac.GetSoundIdByName("PollutionLaugh"),
PollutionSpit = Isaac.GetSoundIdByName("PollutionSpit"),
PollutionSmirk = Isaac.GetSoundIdByName("PollutionSmirk"),
PollutionCharge = Isaac.GetSoundIdByName("PollutionCharge"),
PollutionVom = Isaac.GetSoundIdByName("PollutionVom"),
PollutionWins = Isaac.GetSoundIdByName("PollutionWins"),
PollutionWins2 = Isaac.GetSoundIdByName("PollutionWins2"),
WormSplode = Isaac.GetSoundIdByName("WormSplode"),
------------------------------------------------------
LookerShoot = Isaac.GetSoundIdByName("LookerShoot"),
LookerCharge = Isaac.GetSoundIdByName("LookerCharge"),
LookerBreak = Isaac.GetSoundIdByName("LookerBreak"),
--Buster is another insane one, happy went nuts dude!
BusterBurpskyEnd = Isaac.GetSoundIdByName("BusterBurpskyEnd"),
BusterBurpskyShoot = Isaac.GetSoundIdByName("BusterBurpskyShoot"),
BusterBurpskyCharge = Isaac.GetSoundIdByName("BusterBurpskyCharge"),
BusterBurpSpawn = Isaac.GetSoundIdByName("BusterBurpSpawn"),
BusterChargeStart = Isaac.GetSoundIdByName("BusterChargeStart"),
BusterChargeStart2 = Isaac.GetSoundIdByName("BusterChargeStart2"),
BusterChargeEnd1 = Isaac.GetSoundIdByName("BusterChargeEnd1"),
BusterChargeEnd2 = Isaac.GetSoundIdByName("BusterChargeEnd2"),
BusterChargeLoop = Isaac.GetSoundIdByName("BusterChargeLoop"),
BusterChargeLoop2 = Isaac.GetSoundIdByName("BusterChargeLoop2"),
BusterDeth = Isaac.GetSoundIdByName("BusterDeth"),
BusterDethBeep = Isaac.GetSoundIdByName("BusterDethBeep"),
BusterEatChew = Isaac.GetSoundIdByName("BusterEatChew"),
BusterEatStart = Isaac.GetSoundIdByName("BusterEatStart"),
BusterHotShriekScream = Isaac.GetSoundIdByName("BusterHotShriekScream"),
BusterHotShriekStart = Isaac.GetSoundIdByName("BusterHotShriekStart"),
BusterSnicker = Isaac.GetSoundIdByName("BusterSnicker"),
BusterSpitoomAttack = Isaac.GetSoundIdByName("BusterSpitoomAttack"),
BusterSpitoomCharge = Isaac.GetSoundIdByName("BusterSpitoomCharge"),
BusterVictory = Isaac.GetSoundIdByName("BusterVictory"),
BusterWalkChewLoop = Isaac.GetSoundIdByName("BusterWalkChewLoop"),
BusterWhistle = Isaac.GetSoundIdByName("BusterWhistle"),
------------------------------------------------------
DrShambleHeal = Isaac.GetSoundIdByName("DrShambleHeal"),
BatBaseballHit = Isaac.GetSoundIdByName("BatBaseballHit"),
FishRoll = Isaac.GetSoundIdByName("FishRoll"),
FishRollVA = Isaac.GetSoundIdByName("FishRollVA"),
FishAppearVA = Isaac.GetSoundIdByName("FishAppearVA"),
FishHurtVA = Isaac.GetSoundIdByName("FishHurtVA"),
SlideWhistle = Isaac.GetSoundIdByName("SlideWhistle"),
WatcherEyeShoot = Isaac.GetSoundIdByName("WatcherEyeShoot"),
WatcherShootStart = Isaac.GetSoundIdByName("WatcherShootStart"),
WatcherShootEnd = Isaac.GetSoundIdByName("WatcherShootEnd"),
WatcherTeliInStart = Isaac.GetSoundIdByName("WatcherTeliInStart"),
WatcherTeliInEnd = Isaac.GetSoundIdByName("WatcherTeliInEnd"),
WatcherTeliOutStart = Isaac.GetSoundIdByName("WatcherTeliOutStart"),
WatcherTeliOutEnd = Isaac.GetSoundIdByName("WatcherTeliOutEnd"),
GravediggerDig = Isaac.GetSoundIdByName("GravediggerDig"),
GravediggerDigUp = Isaac.GetSoundIdByName("GravediggerDigUp"),
CisternAttack = Isaac.GetSoundIdByName("CisternAttack"),
CisternWhimper = Isaac.GetSoundIdByName("CisternWhimper"),
SpeedyStart = Isaac.GetSoundIdByName("SpeedyStart"),
SpeedyChargeStart = Isaac.GetSoundIdByName("SpeedyChargeStart"),
SpeedyChargeBash = Isaac.GetSoundIdByName("SpeedyChargeBash"),
SpeedySmugass = Isaac.GetSoundIdByName("SpeedySmugass"),
BashfulSpotted = Isaac.GetSoundIdByName("BashfulSpotted"),
PokeyCrazy = Isaac.GetSoundIdByName("PokeyCrazy"),
PokeyCalm = Isaac.GetSoundIdByName("PokeyCalm"),
ChaserPickup = Isaac.GetSoundIdByName("ChaserPickup"),
ChaserLaunch = Isaac.GetSoundIdByName("ChaserLaunch"),
ChaserWhimper = Isaac.GetSoundIdByName("ChaserWhimper"),
GhostFizzle = Isaac.GetSoundIdByName("GhostFizzle"),
Archvile = Isaac.GetSoundIdByName("Archvile"),
FlashBaby = Isaac.GetSoundIdByName("FlashBaby"),
ChoriSing = Isaac.GetSoundIdByName("ChoriSing"),
Monch = Isaac.GetSoundIdByName("Monch"),
FiendFolioBook = Isaac.GetSoundIdByName("FiendFolioBook"),
BeeBuzz = Isaac.GetSoundIdByName("BeeBuzz"),
BeeBuzzPrep = Isaac.GetSoundIdByName("BeeBuzzPrep"),
BeeBuzzDown = Isaac.GetSoundIdByName("BeeBuzzDown"),
Burpie = Isaac.GetSoundIdByName("Burpie"),
WaterSwish = Isaac.GetSoundIdByName("WaterSwish"),
GlobGulp = Isaac.GetSoundIdByName("GlobGulp"),
GlobSwallow = Isaac.GetSoundIdByName("GlobSwallow"),
GlobSurprise = Isaac.GetSoundIdByName("GlobSurprise"),
BubbleLaunch = Isaac.GetSoundIdByName("BubbleLaunch"),
ArcaneFizzle = Isaac.GetSoundIdByName("ArcaneFizzle"),
LightningImpact = Isaac.GetSoundIdByName("LightningImpact"),
ClothRip = Isaac.GetSoundIdByName("ClothRip"),
CobWeb = Isaac.GetSoundIdByName("CobWeb"),
TearFireFuckYouRevv = Isaac.GetSoundIdByName("TearFireFuckYouRevv"),
FlashDevilCard = Isaac.GetSoundIdByName("FlashDevilCard"),
FlashSatanBlast = Isaac.GetSoundIdByName("FlashSatanBlast"),
FlashSatanHurt = Isaac.GetSoundIdByName("FlashSatanHurt"),
FlashSatanSpit1 = Isaac.GetSoundIdByName("FlashSatanSpit1"),
FlashSatanSpit2 = Isaac.GetSoundIdByName("FlashSatanSpit2"),
FlashSatanCharge = Isaac.GetSoundIdByName("FlashSatanCharge"),
PinballFlipper = Isaac.GetSoundIdByName("PinballFlipper"),
PinballHit = Isaac.GetSoundIdByName("PinballHit"),
TwistedCuteGrunt = Isaac.GetSoundIdByName("TwistedCuteGrunt"),
FiendHurt = Isaac.GetSoundIdByName("FiendHurt"),
FiendDies = Isaac.GetSoundIdByName("FiendDies"),
FriendHurt = Isaac.GetSoundIdByName("FriendHurt"),
FriendDies = Isaac.GetSoundIdByName("FriendDies"),
FlashZap = Isaac.GetSoundIdByName("FlashZap"),
PHSwordSwing = Isaac.GetSoundIdByName("PHSwordSwing"),
PHSwordHit = Isaac.GetSoundIdByName("PHSwordHit"),
ImpSodaCrit = Isaac.GetSoundIdByName("ImpSodaCrit"),
CritShoot = Isaac.GetSoundIdByName("CritShoot"),
FunnyBonk = Isaac.GetSoundIdByName("FunnyBonk"),
Nuke = Isaac.GetSoundIdByName("Nuke"),
Boink = Isaac.GetSoundIdByName("Boink"),
MetalDrop = Isaac.GetSoundIdByName("MetalDrop"),
RiseUp = Isaac.GetSoundIdByName("RiseUp"),
ShottieShot = Isaac.GetSoundIdByName("ShottieShot"),
ShottieFlak = Isaac.GetSoundIdByName("ShottieFlak"),
ShottieReload = Isaac.GetSoundIdByName("ShottieReload"),
Plorp = Isaac.GetSoundIdByName("Plorp"),
MDP1_DashEnd = Isaac.GetSoundIdByName("MDP1_DashEnd"),
MDP1_DashStartGrah = Isaac.GetSoundIdByName("MDP1_DashStartGrah"),
MDP1_DashStartScream = Isaac.GetSoundIdByName("MDP1_DashStartScream"),
MDP1_DashStartStart = Isaac.GetSoundIdByName("MDP1_DashStartStart"),
MDP1_Flinch = Isaac.GetSoundIdByName("MDP1_Flinch"),
MDP1_HitHorseScream = Isaac.GetSoundIdByName("MDP1_HitHorseScream"),
MDP1_HitHorseStart = Isaac.GetSoundIdByName("MDP1_HitHorseStart"),
MDP1_TNT_1 = Isaac.GetSoundIdByName("MDP1_TNT_1"),
MDP1_TNT_2 = Isaac.GetSoundIdByName("MDP1_TNT_2"),
MDP1_TNT_3 = Isaac.GetSoundIdByName("MDP1_TNT_3"),
MDP1_TransGrr = Isaac.GetSoundIdByName("MDP1_TransGrr"),
MDP1_TransitionStrangle = Isaac.GetSoundIdByName("MDP1_TransitionStrangle"),
MDP1_TransThrow = Isaac.GetSoundIdByName("MDP1_TransThrow"),
MDP2_Appear = Isaac.GetSoundIdByName("MDP2_Appear"),
MDP2_Death = Isaac.GetSoundIdByName("MDP2_Death"),
MDP2_PickupOhboy = Isaac.GetSoundIdByName("MDP2_PickupOhboy"),
MDP2_PickupPickup = Isaac.GetSoundIdByName("MDP2_PickupPickup"),
MDP2_PickupScream = Isaac.GetSoundIdByName("MDP2_PickupScream"),
MDP2_PickupStrain = Isaac.GetSoundIdByName("MDP2_PickupStrain"),
MDP2_Throw = Isaac.GetSoundIdByName("MDP2_Throw"),
MDP2_ThrowStrain = Isaac.GetSoundIdByName("MDP2_ThrowStrain"),
FartFrog1 = Isaac.GetSoundIdByName("FartFrog1"),
FartFrog2 = Isaac.GetSoundIdByName("FartFrog2"),
FartFrog3 = Isaac.GetSoundIdByName("FartFrog3"),
FartFrog4 = Isaac.GetSoundIdByName("FartFrog4"),
DichromaticGraze = Isaac.GetSoundIdByName("DichromaticGraze"),
MarioWarp = Isaac.GetSoundIdByName("MarioWarp"),
MeatBoyLaser = Isaac.GetSoundIdByName("MeatBoyLaser"),
SchwingDingALing = Isaac.GetSoundIdByName("SchwingDingALing"),
HSTier1 = Isaac.GetSoundIdByName("HSTier1"),
HSTier2 = Isaac.GetSoundIdByName("HSTier2"),
HSTier3 = Isaac.GetSoundIdByName("HSTier3"),
AGShoot = Isaac.GetSoundIdByName("AGShoot"),
AGOugh = Isaac.GetSoundIdByName("AGOugh"),
AGJump = Isaac.GetSoundIdByName("AGJump"),
AGWheeze = Isaac.GetSoundIdByName("AGWheeze"),
FlashMuffledRoar = Isaac.GetSoundIdByName("FlashMuffledRoar"),
Dusk1 = Isaac.GetSoundIdByName("Dusk1"),
Dusk2 = Isaac.GetSoundIdByName("Dusk2"),
Dusk3 = Isaac.GetSoundIdByName("Dusk3"),
Dusk4 = Isaac.GetSoundIdByName("Dusk4"),
Dusk5 = Isaac.GetSoundIdByName("Dusk5"),
DuskDeath = Isaac.GetSoundIdByName("DuskDeath"),
DuskScream = Isaac.GetSoundIdByName("DuskScream"),
DuskSpin1 = Isaac.GetSoundIdByName("DuskSpin1"),
DuskSpin2 = Isaac.GetSoundIdByName("DuskSpin2"),
DuskSpin3 = Isaac.GetSoundIdByName("DuskSpin3"),
DuskIntroScream = Isaac.GetSoundIdByName("DuskIntroScream"),
DuskShoot = Isaac.GetSoundIdByName("DuskShoot"),
DuskDumbass = Isaac.GetSoundIdByName("DuskDumbass"),
CrunchyEddy = Isaac.GetSoundIdByName("CrunchyEddy"),
StatusProjectile1 = Isaac.GetSoundIdByName("StatusProjectile1"),
StatusProjectile2 = Isaac.GetSoundIdByName("StatusProjectile2"),
StatusProjectile3 = Isaac.GetSoundIdByName("StatusProjectile3"),
PunchBuildup = Isaac.GetSoundIdByName("PunchBuildup"),
Tsar = Isaac.GetSoundIdByName("Tsar"),
TsarBurp = Isaac.GetSoundIdByName("TsarBurp"),
TsarCough = Isaac.GetSoundIdByName("TsarCough"),
TsarEmerge = Isaac.GetSoundIdByName("TsarEmerge"),
TsarGrateEnter = Isaac.GetSoundIdByName("TsarGrateEnter"),
TsarKalu = Isaac.GetSoundIdByName("TsarKalu"),
TsarYouOkayThereBuddyCanWeGetYouSomethingToDrink = Isaac.GetSoundIdByName("TsarYouOkayThereBuddyCanWeGetYouSomethingToDrink"),
TsarDie = Isaac.GetSoundIdByName("TsarDie"),
TsarJump = Isaac.GetSoundIdByName("TsarJump"),
Kalu = Isaac.GetSoundIdByName("Kalu"),
RipcordIdle = Isaac.GetSoundIdByName("RipcordIdle"),
RipcordReveal = Isaac.GetSoundIdByName("RipcordReveal"),
RipcordShitting = Isaac.GetSoundIdByName("RipcordShitting"),
RipcordPop = Isaac.GetSoundIdByName("RipcordPop"),
CardDraw = Isaac.GetSoundIdByName("CardDraw"),
CardFlip = Isaac.GetSoundIdByName("CardFlip"),
CardMove = Isaac.GetSoundIdByName("CardMove"),
ChipPull = Isaac.GetSoundIdByName("ChipPull"),
PokerBoyLaugh = Isaac.GetSoundIdByName("PokerBoyLaugh"),
PokerBoyYell = Isaac.GetSoundIdByName("PokerBoyYell"),
ClapSong = Isaac.GetSoundIdByName("ClapSong"),
ClapPickup = Isaac.GetSoundIdByName("ClapPickup"),
DogmaScreamNoBaby = Isaac.GetSoundIdByName("DogmaScreamNoBaby"),
FemurBreaker = Isaac.GetSoundIdByName("FemurBreaker"),
GhostBoof = Isaac.GetSoundIdByName("GhostBoof"),
MeatyBurst = Isaac.GetSoundIdByName("MeatyBurst"),
MeatySquish = Isaac.GetSoundIdByName("MeatySquish"),
LightSwitch = Isaac.GetSoundIdByName("LightSwitch"),
SniperRifleFire = Isaac.GetSoundIdByName("SniperRifleFire"),
GunDraw = Isaac.GetSoundIdByName("GunDraw"),
CleaverThrow = Isaac.GetSoundIdByName("CleaverThrow"),
CleaverHit = Isaac.GetSoundIdByName("CleaverHit"),
CleaverHitWorld = Isaac.GetSoundIdByName("CleaverHitWorld"),
GrappleGrab = Isaac.GetSoundIdByName("GrappleGrab"),
FunnyHello = Isaac.GetSoundIdByName("FunnyHello"),
BabyGasp = Isaac.GetSoundIdByName("BabyGasp"),
CatSqueal = Isaac.GetSoundIdByName("CatSqueal"),
MamaDoll = Isaac.GetSoundIdByName("MamaDoll"),
MonkeyScream = Isaac.GetSoundIdByName("MonkeyScream"),
Orangutan = Isaac.GetSoundIdByName("Orangutan"),
Subaluwa = Isaac.GetSoundIdByName("Subaluwa"),
EpicHorn = Isaac.GetSoundIdByName("EpicHorn"),
WolfWhistle = Isaac.GetSoundIdByName("WolfWhistle"),
YodelGoofy = Isaac.GetSoundIdByName("YodelGoofy"),
EENEHit = Isaac.GetSoundIdByName("EENEHit"),
EENEHitWacky = Isaac.GetSoundIdByName("EENEHitWacky"),
EENEHitEnd = Isaac.GetSoundIdByName("EENEHitEnd"),
BrownedBoowomp = Isaac.GetSoundIdByName("BrownedBoowomp"),
BrownedYippee = Isaac.GetSoundIdByName("BrownedYippee"),
BrownedBoing = Isaac.GetSoundIdByName("BrownedBoing"),
SourceMeatSoft = Isaac.GetSoundIdByName("SourceMeatSoft"),
MadnessDeath = Isaac.GetSoundIdByName("MadnessDeath"),
MadnessPunch = Isaac.GetSoundIdByName("MadnessPunch"),
MadnessSplash = Isaac.GetSoundIdByName("MadnessSplash"),
Crow = Isaac.GetSoundIdByName("Crow"),
DoomProc = Isaac.GetSoundIdByName("Doomed Proc"),
Piano1 = Isaac.GetSoundIdByName("Piano1"),
Piano2 = Isaac.GetSoundIdByName("Piano2"),
Piano3 = Isaac.GetSoundIdByName("Piano3"),
CustomBerserkTick = Isaac.GetSoundIdByName("Berserk Tick custom"),
FiendHeartDrop = Isaac.GetSoundIdByName("Fiend Heart Drop"),
FiendHeartPickup = Isaac.GetSoundIdByName("Fiend Heart Pickup"),
FiendHeartPickupRare = Isaac.GetSoundIdByName("Fiend Heart Pickup Rare"),
MurasaWarp = Isaac.GetSoundIdByName("MurasaWarp"),
AnchorCrash = Isaac.GetSoundIdByName("AnchorCrash"),
AnchorSpawn = Isaac.GetSoundIdByName("AnchorSpawn"),
MurasaSparkle = Isaac.GetSoundIdByName("MurasaSparkle"),
MurasaDamaged = Isaac.GetSoundIdByName("MurasaDamaged"),
MurasaDeath = Isaac.GetSoundIdByName("MurasaDeath"),
MurasaFire = Isaac.GetSoundIdByName("MurasaFire"),
MurasaSpell = Isaac.GetSoundIdByName("MurasaSpell"),
MurasaTimeout = Isaac.GetSoundIdByName("MurasaTimeout"),
PunisherGroan = Isaac.GetSoundIdByName("PunisherGroan"),
ZealotLockOn = Isaac.GetSoundIdByName("ZealotLockOn"),
ZealotBoom = Isaac.GetSoundIdByName("ZealotBoom"),
ZealotHum = Isaac.GetSoundIdByName("ZealotHum"),
ZealotFade = Isaac.GetSoundIdByName("ZealotFade"),
Blaargh = Isaac.GetSoundIdByName("Blaargh"),
CartoonGulp = Isaac.GetSoundIdByName("CartoonGulp"),
FlamethrowerLoop = Isaac.GetSoundIdByName("FlamethrowerLoop"),
PipeClunk1 = Isaac.GetSoundIdByName("PipeClunk1"),
PipeClunk2 = Isaac.GetSoundIdByName("PipeClunk2"),
PipeShift = Isaac.GetSoundIdByName("PipeShift"),
Anvil = Isaac.GetSoundIdByName("Anvil"),
YgoCard = Isaac.GetSoundIdByName("YgoCard"),
BucketClang = Isaac.GetSoundIdByName("BucketClang"),
BucketKick = Isaac.GetSoundIdByName("BucketKick"),
PeeLong1 = Isaac.GetSoundIdByName("PeeLong1"),
PeeLong2 = Isaac.GetSoundIdByName("PeeLong2"),
StolasScreech = Isaac.GetSoundIdByName("StolasScreech"),
PvZBucket = Isaac.GetSoundIdByName("pvzBucket"),
DrillStart = Isaac.GetSoundIdByName("DrillStart"),
DrillLoop = Isaac.GetSoundIdByName("DrillLoop"),
DrillStop = Isaac.GetSoundIdByName("DrillStop"),
DungeonMasterGrunt = Isaac.GetSoundIdByName("DungeonMasterGrunt"),
DungeonMasterSwipe = Isaac.GetSoundIdByName("DungeonMasterSwipe"),
DungeonMasterDeath = Isaac.GetSoundIdByName("DungeonMasterDead"),
Caca1 = Isaac.GetSoundIdByName("Caca1"),
Caca2 = Isaac.GetSoundIdByName("Caca2"),
Caca3 = Isaac.GetSoundIdByName("Caca3"),
Caca4 = Isaac.GetSoundIdByName("Caca4"),
Caca5 = Isaac.GetSoundIdByName("Caca5"),
Caca6 = Isaac.GetSoundIdByName("Caca6"),
Caca7 = Isaac.GetSoundIdByName("Caca7"),
CacaDeath = Isaac.GetSoundIdByName("CacaDeath"),
CacaIDKLOL = Isaac.GetSoundIdByName("CacaIDKLOL"),
CrowdCheer = Isaac.GetSoundIdByName("CrowdCheer"),
RobotRock = Isaac.GetSoundIdByName("robotRock"),
DolphinLaugh = Isaac.GetSoundIdByName("DolphinLaugh"),
Melatonin = Isaac.GetSoundIdByName("Melatonin"),
FossilObtain = Isaac.GetSoundIdByName("fossilObtain"),
FocusCrystal = Isaac.GetSoundIdByName("focusCrystal"),
CrocaIdle = Isaac.GetSoundIdByName("CrocaIdle"),
CrocaCharge = Isaac.GetSoundIdByName("CrocaCharge"),
AceVenturaLaugh = Isaac.GetSoundIdByName("AceVenturaLaugh"),
AceVenturaLaughShort = Isaac.GetSoundIdByName("AceVenturaLaughShort"),
TBRing = Isaac.GetSoundIdByName("TBRing"),
TBPickup = Isaac.GetSoundIdByName("TBPickup"),
TBBen = Isaac.GetSoundIdByName("TBBen"),
TBYes = Isaac.GetSoundIdByName("TBYes"),
TBNo = Isaac.GetSoundIdByName("TBNo"),
TBHeartyLaugh = Isaac.GetSoundIdByName("TBHeartyLaugh"),
TBHeartyLaughShort = Isaac.GetSoundIdByName("TBHeartyLaughShort"),
TBEurgh = Isaac.GetSoundIdByName("TBEurgh"),
TBHangup = Isaac.GetSoundIdByName("TBHangup"),
DirePayout = Isaac.GetSoundIdByName("DirePayout"),
ChildAngryRoarButGood = Isaac.GetSoundIdByName("ChildAngryRoarButGood"),
SawAttach = Isaac.GetSoundIdByName("SawAttach"),
SawAmbient = Isaac.GetSoundIdByName("SawAmbient"),
SawImpact = Isaac.GetSoundIdByName("SawImpact"),
MinionSoundscape = Isaac.GetSoundIdByName("MinionSoundscape"),
DeadEyeBurst = Isaac.GetSoundIdByName("DeadEyeBurst"),
BertranStep = Isaac.GetSoundIdByName("BertranStep"),
BertranSlap = Isaac.GetSoundIdByName("BertranSlap"),
PitchforkHit = Isaac.GetSoundIdByName("PitchforkHit"),
GodheadTearsCopy = Isaac.GetSoundIdByName("GodheadTearsCopy"),
FunnyFart = Isaac.GetSoundIdByName("FunnyFart"),
SadBear = Isaac.GetSoundIdByName("SadBear"),
RMGasp = Isaac.GetSoundIdByName("RMGasp"),
BookShut = Isaac.GetSoundIdByName("BookShut"),
PageTurning = Isaac.GetSoundIdByName("PageTurning"),
PaperDeath = Isaac.GetSoundIdByName("PaperDeath"),
WarpZonePortal = Isaac.GetSoundIdByName("warpZonePortal"),
WarpZonePhase = Isaac.GetSoundIdByName("warpZonePhase"),
WarpZoneMeatBoy = Isaac.GetSoundIdByName("warpZoneMeatBoy"),
FootballPunt = Isaac.GetSoundIdByName("footballPunt"),
GolemHurt = Isaac.GetSoundIdByName("golemHurt"),
GolemDeath = Isaac.GetSoundIdByName("golemDeath"),
AmethystBreak = Isaac.GetSoundIdByName("AmethystBreak"),
CameraFlash = Isaac.GetSoundIdByName("CameraFlash"),
CameraPrime = Isaac.GetSoundIdByName("CameraPrime"),
CameraMiss = Isaac.GetSoundIdByName("CameraMiss"),
AxeThrow = Isaac.GetSoundIdByName("AxeThrow"),
BrownHorn = Isaac.GetSoundIdByName("BrownHorn"),
BrownHornLong = Isaac.GetSoundIdByName("BrownHornLong"),
SizzleExtinguish = Isaac.GetSoundIdByName("SizzleExtinguish"),
FlowerCrown = Isaac.GetSoundIdByName("FlowerCrown"),
SussyOpen = Isaac.GetSoundIdByName("SussyOpen"),
SussyClose = Isaac.GetSoundIdByName("SussyClose"),
MetalStepLight = Isaac.GetSoundIdByName("MetalStepLight"),
MetalStepHeavy = Isaac.GetSoundIdByName("MetalStepHeavy"),
Dogrock = Isaac.GetSoundIdByName("Dogrock"),
TennisHit = Isaac.GetSoundIdByName("TennisHit"),
RubberRockBounce = Isaac.GetSoundIdByName("RubberRockBounce"),
KirbyInhale = Isaac.GetSoundIdByName("KirbyInhale"),
RecordScratch = Isaac.GetSoundIdByName("RecordScratch"),
KettleWhistle = Isaac.GetSoundIdByName("KettleWhistle"),
LipSmack = Isaac.GetSoundIdByName("LipSmack"),
SqueakyRotate = Isaac.GetSoundIdByName("SqueakyRotate"),
DeepThump = Isaac.GetSoundIdByName("DeepThump"),
GasHissShort = Isaac.GetSoundIdByName("GasHissShort"),
GolemDoorOpen = Isaac.GetSoundIdByName("GolemDoorOpen"),
GolemDoorClose = Isaac.GetSoundIdByName("GolemDoorClose"),
GoldenSlotPolymorph = Isaac.GetSoundIdByName("GoldenSlotPolymorph"),
GoldenSlotBuzz = Isaac.GetSoundIdByName("GoldenSlotBuzz"),
GoldenSlotTele = Isaac.GetSoundIdByName("GoldenSlotTele"),
GoldenSlotPayout = Isaac.GetSoundIdByName("GoldenSlotPayout"),
DevilDaggerGemTing = Isaac.GetSoundIdByName("DevilDaggerGemTing"),
DevilDaggerGemCollect = Isaac.GetSoundIdByName("DevilDaggerGemCollect"),
DevilDaggerGemCollect2 = Isaac.GetSoundIdByName("DevilDaggerGemCollect2"),
DevilDaggerLevelUp1 = Isaac.GetSoundIdByName("DevilDaggerLevelUp1"),
DevilDaggerLevelUp2 = Isaac.GetSoundIdByName("DevilDaggerLevelUp2"),
DevilDaggerLevelUp3 = Isaac.GetSoundIdByName("DevilDaggerLevelUp3"),
NitroActive = Isaac.GetSoundIdByName("NitroActive"),
NitroExpired = Isaac.GetSoundIdByName("NitroExpired"),
DevilsAbacusCount = Isaac.GetSoundIdByName("DevilsAbacusCount"),
BiendHurt = Isaac.GetSoundIdByName("BiendHurt"),
BiendFreakingDies = Isaac.GetSoundIdByName("BiendFreakingDies"),
BlackMoonIntro = Isaac.GetSoundIdByName("BlackMoonIntro"),
BlackMoonLoop = Isaac.GetSoundIdByName("BlackMoonLoop"),
BlackMoonEnd = Isaac.GetSoundIdByName("BlackMoonEnd"),
InfinityVoltPlugin = Isaac.GetSoundIdByName("InfinityVoltPlugin"),
InfinityVoltPlugout = Isaac.GetSoundIdByName("InfinityVoltPlugout"),
GrinnerGiggle = Isaac.GetSoundIdByName("GrinnerGiggle"),
DelinquentPee = Isaac.GetSoundIdByName("DelinquentPee"),
DelinquentPeeEnd = Isaac.GetSoundIdByName("DelinquentPeeEnd"),
AngelicHarpStrum = Isaac.GetSoundIdByName("AngelicHarpStrum"),
EnergyPsychic = Isaac.GetSoundIdByName("EnergyPsychic"),
EnergyFairy = Isaac.GetSoundIdByName("EnergyFairy"),
EnergyMetal = Isaac.GetSoundIdByName("EnergyMetal"),
D2Toss = Isaac.GetSoundIdByName("D2Toss"),
D2Land = Isaac.GetSoundIdByName("D2Land"),
ShootRifle = Isaac.GetSoundIdByName("ShootRifle"),
DelinquentHuh = Isaac.GetSoundIdByName("DelinquentHuh"),
DelinquentCry = Isaac.GetSoundIdByName("DelinquentCry"),
DadsDipDeath = Isaac.GetSoundIdByName("DadsDipDeath"),
MimeBlockRelocate = Isaac.GetSoundIdByName("MimeBlockRelocate"),
SoulOfFiendVO = Isaac.GetSoundIdByName("SoulOfFiendVO"),
SmashStrike = Isaac.GetSoundIdByName("SmashStrike"),
SmashHitWeak = Isaac.GetSoundIdByName("SmashHitWeak"),
SmashHitHeavy = Isaac.GetSoundIdByName("SmashHitHeavy"),
SmashHitShocking = Isaac.GetSoundIdByName("SmashHitShocking"),
SmashHitFatal = Isaac.GetSoundIdByName("SmashHitFatal"),
SmashHitAudience = Isaac.GetSoundIdByName("SmashHitAudience"),
TheShittiestGulpSoundEver = Isaac.GetSoundIdByName("TheShittiestGulpSoundEver"),
OnlyfanBwop = Isaac.GetSoundIdByName("OnlyfanBwop"),
LurkerIdle = Isaac.GetSoundIdByName("LurkerIdle"),
LurkerCharge = Isaac.GetSoundIdByName("LurkerCharge"),
LurkerSpit = Isaac.GetSoundIdByName("LurkerSpit"),
LurkerDie = Isaac.GetSoundIdByName("LurkerDie"),
GoldenButtonPress = Isaac.GetSoundIdByName("GoldenButtonPress"),
ExcelsiorShoot = Isaac.GetSoundIdByName("ExcelsiorShoot"),
ExcelsiorBoom = Isaac.GetSoundIdByName("ExcelsiorBoom"),
SpankyDeath = Isaac.GetSoundIdByName("AngryBirdsPigDeath"),
SpankyShoot = Isaac.GetSoundIdByName("AngryBirdsPigSound"),
CopperBombSizzle = Isaac.GetSoundIdByName("CopperBombSizzle"),
CopperBombSuccess = Isaac.GetSoundIdByName("CopperBombSuccess"),
CopperBombPickup = Isaac.GetSoundIdByName("CopperBombPickup"),
RMetalCombo11 = Isaac.GetSoundIdByName("RMetalCombo11"),
RMetalCombo12 = Isaac.GetSoundIdByName("RMetalCombo12"),
RMetalCombo13 = Isaac.GetSoundIdByName("RMetalCombo13"),
RMetalCombo1Miss = Isaac.GetSoundIdByName("RMetalCombo1Miss"),
RMetalCombo21 = Isaac.GetSoundIdByName("RMetalCombo21"),
RMetalCombo22 = Isaac.GetSoundIdByName("RMetalCombo22"),
RMetalCombo23 = Isaac.GetSoundIdByName("RMetalCombo23"),
RMetalCombo2Miss = Isaac.GetSoundIdByName("RMetalCombo2Miss"),
RMetalMetronome = Isaac.GetSoundIdByName("RMetalMetronome"),
FingerSnapCool = Isaac.GetSoundIdByName("FingerSnapCool"),
MidarizerGoldify = Isaac.GetSoundIdByName("MidarizerGoldify"),
MidarizerPayout = Isaac.GetSoundIdByName("MidarizerPayout"),
SweetpussPickup = Isaac.GetSoundIdByName("SweetpussPickup"),
SweetpussRummage = Isaac.GetSoundIdByName("SweetpussRummage"),
SweetpussFossilmagicBuildup = Isaac.GetSoundIdByName("SweetpussFossilmagicBuildup"),
SweetpussFossilmagicPayout = Isaac.GetSoundIdByName("SweetpussFossilmagicPayout"),
HedonistChant = Isaac.GetSoundIdByName("HedonistChant"),
HedonistMmm = Isaac.GetSoundIdByName("HedonistMmm"),
OrangeJuiceA100Percent = Isaac.GetSoundIdByName("OrangeJuiceA100Percent"),
OrangeJuiceABonusu = Isaac.GetSoundIdByName("OrangeJuiceABonusu"),
OrangeJuiceACard = Isaac.GetSoundIdByName("OrangeJuiceACard"),
OrangeJuiceADrop = Isaac.GetSoundIdByName("OrangeJuiceADrop"),
OrangeJuiceAEncounter = Isaac.GetSoundIdByName("OrangeJuiceAEncounter"),
OrangeJuiceAEncounterWin = Isaac.GetSoundIdByName("OrangeJuiceAEncounterWin"),
OrangeJuiceCard = Isaac.GetSoundIdByName("OrangeJuiceCard"),
OrangeJuiceChapterStart = Isaac.GetSoundIdByName("OrangeJuiceChapterStart"),
OrangeJuiceDrop = Isaac.GetSoundIdByName("OrangeJuiceDrop"),
OrangeJuiceEncounter = Isaac.GetSoundIdByName("OrangeJuiceEncounter"),
OrangeJuiceExplode = Isaac.GetSoundIdByName("OrangeJuiceExplode"),
OrangeJuiceHeal = Isaac.GetSoundIdByName("OrangeJuiceHeal"),
OrangeJuiceStar = Isaac.GetSoundIdByName("OrangeJuiceStar"),
OrangeJuiceWarp = Isaac.GetSoundIdByName("OrangeJuiceWarp"),
OrangeJuiceHit = Isaac.GetSoundIdByName("OrangeJuiceHit"),
BombCollarTrigger = Isaac.GetSoundIdByName("BombCollarTrigger"),
TwinklePass = Isaac.GetSoundIdByName("TwinklePass"),
RockyCrush = Isaac.GetSoundIdByName("RockyCrush"),
OverclockOn = Isaac.GetSoundIdByName("OverclockOn"),
OverclockOff = Isaac.GetSoundIdByName("OverclockOff"),
BusterGhostCallEmissionsScream = Isaac.GetSoundIdByName("BusterGhostCallEmissionsScream"),
BusterGhostCallEmissionsStart = Isaac.GetSoundIdByName("BusterGhostCallEmissionsStart"),
BusterGhostChaseStart = Isaac.GetSoundIdByName("BusterGhostChaseStart"),
BusterGhostDashBlink = Isaac.GetSoundIdByName("BusterGhostDashBlink"),
BusterGhostDashStart = Isaac.GetSoundIdByName("BusterGhostDashStart"),
BusterGhostDeath = Isaac.GetSoundIdByName("BusterGhostDeath"),
BusterGhostDriftPrep = Isaac.GetSoundIdByName("BusterGhostDriftPrep"),
BusterGhostDriftShoot = Isaac.GetSoundIdByName("BusterGhostDriftShoot"),
BusterGhostDriftStart = Isaac.GetSoundIdByName("BusterGhostDriftStart"),
BusterGhostSuckEnd = Isaac.GetSoundIdByName("BusterGhostSuckEnd"),
BusterGhostSuckLoop = Isaac.GetSoundIdByName("BusterGhostSuckLoop"),
BusterGhostSuckShoot = Isaac.GetSoundIdByName("BusterGhostSuckShoot"),
BusterGhostSuckStart = Isaac.GetSoundIdByName("BusterGhostSuckStart"),
BusterGhostVictory = Isaac.GetSoundIdByName("BusterGhostVictory"),
BusterGhostSkid1 = Isaac.GetSoundIdByName("BusterGhostSkid1"),
BusterGhostSkid2 = Isaac.GetSoundIdByName("BusterGhostSkid2"),
BusterGhostSnicker1 = Isaac.GetSoundIdByName("BusterGhostSnicker1"),
BusterGhostSnicker2 = Isaac.GetSoundIdByName("BusterGhostSnicker2"),
WarpZoneBackground = Isaac.GetSoundIdByName("WarpZoneBackground"),
WarpZoneBarf = Isaac.GetSoundIdByName("WarpZoneBarf"),
WarpZoneChaosCardFall = Isaac.GetSoundIdByName("WarpZoneChaosCardFall"),
WarpZoneChaosCardUnfall = Isaac.GetSoundIdByName("WarpZoneChaosCardUnfall"),
WarpZoneChew = Isaac.GetSoundIdByName("WarpZoneChew"),
WarpZoneDeath = Isaac.GetSoundIdByName("WarpZoneDeath"),
WarpZoneGasp = Isaac.GetSoundIdByName("WarpZoneGasp"),
WarpZoneGrunt = Isaac.GetSoundIdByName("WarpZoneGrunt"),
WarpZoneHurt = Isaac.GetSoundIdByName("WarpZoneHurt"),
WarpZoneLaugh = Isaac.GetSoundIdByName("WarpZoneLaugh"),
WarpZonePrepare = Isaac.GetSoundIdByName("WarpZonePrepare"),
WarpZoneRoar = Isaac.GetSoundIdByName("WarpZoneRoar"),
WarpZoneSmile = Isaac.GetSoundIdByName("WarpZoneSmile"),
WarpZoneSpinEnd = Isaac.GetSoundIdByName("WarpZoneSpinEnd"),
WarpZoneSpinStart = Isaac.GetSoundIdByName("WarpZoneSpinStart"),
WarpZoneSpinning = Isaac.GetSoundIdByName("WarpZoneSpinning"),
WarpZoneSpit = Isaac.GetSoundIdByName("WarpZoneSpit"),
CContusionYell = Isaac.GetSoundIdByName("CContusionYell"),
CContusionWakeUp = Isaac.GetSoundIdByName("CContusionWakeUp"),
CLarryBarf = Isaac.GetSoundIdByName("CLarryBarf"),
CLarryGulp = Isaac.GetSoundIdByName("CLarryGulp"),
CLarryCharge = Isaac.GetSoundIdByName("CLarryCharge"),
CMonstroRoar = Isaac.GetSoundIdByName("CMonstroRoar"),
CMonstroShoot = Isaac.GetSoundIdByName("CMonstroShoot"),
CMonstroBarf = Isaac.GetSoundIdByName("CMonstroBarf"),
CMonstroStomp = Isaac.GetSoundIdByName("CMonstroStomp"),
CMonstroGrunt = Isaac.GetSoundIdByName("CMonstroGrunt"),
CSutureShoot = Isaac.GetSoundIdByName("CSutureShoot"),
CSutureGrunt = Isaac.GetSoundIdByName("CSutureGrunt"),
CSutureTel = Isaac.GetSoundIdByName("CSutureTel"),
TreasureDisc = Isaac.GetSoundIdByName("TreasureDisc"),
ShopDisc = Isaac.GetSoundIdByName("ShopDisc"),
BossDisc = Isaac.GetSoundIdByName("BossDisc"),
SecretDisc = Isaac.GetSoundIdByName("SecretDisc"),
DevilDisc = Isaac.GetSoundIdByName("DevilDisc"),
AngelDisc = Isaac.GetSoundIdByName("AngelDisc"),
PlanetariumDisc = Isaac.GetSoundIdByName("PlanetariumDisc"),
BrokenDisc = Isaac.GetSoundIdByName("BrokenDisc"),
TaintedTreasureDisc = Isaac.GetSoundIdByName("TaintedTreasureDisc"),
GrazerShoot = Isaac.GetSoundIdByName("GrazerShoot"),
GrazerDie = Isaac.GetSoundIdByName("GrazerDie"),
VenusBackToFight = Isaac.GetSoundIdByName("VenusBackToFight"),
VenusToBlack = Isaac.GetSoundIdByName("VenusToBlack"),
SuperShottieOpen = Isaac.GetSoundIdByName("SuperShottieOpen"),
SuperShottieClose = Isaac.GetSoundIdByName("SuperShottieClose"),
SuperShottiePreBlast = Isaac.GetSoundIdByName("SuperShottiePreBlast"),
SuperShottieBlast = Isaac.GetSoundIdByName("SuperShottieBlast"),
SuperShottieReload = Isaac.GetSoundIdByName("SuperShottieReload"),
SuperShottieChainLoop = Isaac.GetSoundIdByName("SuperShottieChainLoop"),
RefereeWhistle = Isaac.GetSoundIdByName("RefereeWhistle"),
RefereeWhistleQuick = Isaac.GetSoundIdByName("RefereeWhistleQuick"),
LegoStudPickup = Isaac.GetSoundIdByName("LegoStudPickup"),
EdemaBounce = Isaac.GetSoundIdByName("EdemaBounce"),
IrisSpit = Isaac.GetSoundIdByName("IrisSpit"),
ChompDash = Isaac.GetSoundIdByName("ChompDash"),
WailerGrow = Isaac.GetSoundIdByName("WailerGrow"),
CraigJump = Isaac.GetSoundIdByName("CraigJump"),
CraigLaser = Isaac.GetSoundIdByName("CraigLaser"),
FrayedAlert = Isaac.GetSoundIdByName("FrayedAlert"),
ClipSnap = Isaac.GetSoundIdByName("ClipSnap"),
TemptressEmerge = Isaac.GetSoundIdByName("TemptressEmerge"),
TemptressAttack = Isaac.GetSoundIdByName("TemptressAttack"),
TemptressChase = Isaac.GetSoundIdByName("TemptressChase"),
TemptressDeath = Isaac.GetSoundIdByName("TemptressDeath"),
ChorusWhisper = Isaac.GetSoundIdByName("ChorusWhisper"),
LaideronnetteHurt = Isaac.GetSoundIdByName("LaideronnetteHurt"),
LaideronnetteDeath = Isaac.GetSoundIdByName("LaideronnetteDeath"),
LegoClick = Isaac.GetSoundIdByName("LegoClick"),
BeaconSlurp = Isaac.GetSoundIdByName("BeaconSlurp"),
Geiger = Isaac.GetSoundIdByName("Geiger"),
NewYearFall = Isaac.GetSoundIdByName("NewYearFall"),
NewYearJump = Isaac.GetSoundIdByName("NewYearJump"),
NewYearLand = Isaac.GetSoundIdByName("NewYearLand"),
NewYearTell = Isaac.GetSoundIdByName("NewYearTell"),
ManAtArmsExpose = Isaac.GetSoundIdByName("ManAtArmsExpose"),
ManAtArmsFall = Isaac.GetSoundIdByName("ManAtArmsFall"),
StevenUniverseFusion = Isaac.GetSoundIdByName("StevenUniverseFusion"),
WomanRevealer = Isaac.GetSoundIdByName("RealWomanAudio"),
ElectricShock = Isaac.GetSoundIdByName("ElectricShock"),
ShockerCharge = Isaac.GetSoundIdByName("ShockerCharge"),
SpyVsSpyLaugh = Isaac.GetSoundIdByName("SpyVsSpyLaugh"),
SpyVsSpyLaughEvil = Isaac.GetSoundIdByName("SpyVsSpyLaughEvil"),
BeastBrimStart = Isaac.GetSoundIdByName("BeastBrimStart"),
BeastBrimLoop = Isaac.GetSoundIdByName("BeastBrimLoop"),
BeastBrimEnd = Isaac.GetSoundIdByName("BeastBrimEnd"),
CraigHurt = Isaac.GetSoundIdByName("CraigHurt"),
CraigDeath = Isaac.GetSoundIdByName("CraigDeath"),
TheShampooBottleColon = Isaac.GetSoundIdByName("ShampooTalk"),
TheShampooBottleSmelt = Isaac.GetSoundIdByName("ShampooSmelt"),
TheShampooBottleAppear = Isaac.GetSoundIdByName("ShampooAppear"),
MadommeAppear = Isaac.GetSoundIdByName("MadommeAppear"),
MadommeBrimstoneOrb = Isaac.GetSoundIdByName("MadommeBrimstoneOrb"),
MadommeDashEnd = Isaac.GetSoundIdByName("MadommeDashEnd"),
MadommeDashStart = Isaac.GetSoundIdByName("MadommeDashStart"),
MadommeDeath = Isaac.GetSoundIdByName("MadommeDeath"),
MadommeInvisChuckle = Isaac.GetSoundIdByName("MadommeInvisChuckle"),
MadommeInvisGrimmace = Isaac.GetSoundIdByName("MadommeInvisGrimmace"),
MadommeLegCrossL = Isaac.GetSoundIdByName("MadommeLegCrossL"),
MadommeLegCrossR = Isaac.GetSoundIdByName("MadommeLegCrossR"),
MadommeSpitEnd = Isaac.GetSoundIdByName("MadommeSpitEnd"),
MadommeSpitReady = Isaac.GetSoundIdByName("MadommeSpitReady"),
MadommeSpit = Isaac.GetSoundIdByName("MadommeSpit"),
MadommeThrowEnd = Isaac.GetSoundIdByName("MadommeThrowEnd"),
MadommeThrowStart = Isaac.GetSoundIdByName("MadommeThrowStart"),
MadommeTransition = Isaac.GetSoundIdByName("MadommeTransition"),
MadommeUntransition = Isaac.GetSoundIdByName("MadommeUntransition"),
BombToken = Isaac.GetSoundIdByName("BombTokenDamage"),
ZoomAway = Isaac.GetSoundIdByName("ZoomAway"),
BellBoy = Isaac.GetSoundIdByName("BellBoy"),
PikminThrow = Isaac.GetSoundIdByName("PikminThrow"),
PikminCall = Isaac.GetSoundIdByName("PikminCall"),
PikminLift = Isaac.GetSoundIdByName("PikminLift"),
PikminPluckVoice = Isaac.GetSoundIdByName("PikminPluckVoice"),
PikminPluckSound = Isaac.GetSoundIdByName("PikminPluckSound"),
EarthboundBox = Isaac.GetSoundIdByName("EarthboundBox"),
UtilityPoleBoxOpen = Isaac.GetSoundIdByName("UtilityPoleBoxOpen"),
UtilityPolePetCrow = Isaac.GetSoundIdByName("UtilityPolePetCrow"),
D5WoodImpact = Isaac.GetSoundIdByName("D5WoodImpact"),
D5CreepPuddle = Isaac.GetSoundIdByName("D5CreepPuddle"),
D5DoublePower = Isaac.GetSoundIdByName("D5DoublePower"),
GaperInAJarCollect = Isaac.GetSoundIdByName("GaperInAJarCollect"),
InscryptionBoneTokenLow = Isaac.GetSoundIdByName("InscryptionBoneTokenLow"),
InscryptionBoneTokenHigh = Isaac.GetSoundIdByName("InscryptionBoneTokenHigh"),
MtnDewHiss = Isaac.GetSoundIdByName("MtnDewHiss"),
IceIX = Isaac.GetSoundIdByName("IceIX"),
HeyFellas = Isaac.GetSoundIdByName("HeyFellas"),
ClownHornHonk = Isaac.GetSoundIdByName("ClownHornHonk"),
KaluSlash = Isaac.GetSoundIdByName("KaluSlash"),
RaymondGrunt = Isaac.GetSoundIdByName("RaymondGrunt"),
RaymondCharge = Isaac.GetSoundIdByName("RaymondCharge"),
RaymondThunder = Isaac.GetSoundIdByName("RaymondThunder"),
RaymondDeath = Isaac.GetSoundIdByName("RaymondDeath"),
RaymondIgnite = Isaac.GetSoundIdByName("RaymondIgnite"),
RaymondTeleport = Isaac.GetSoundIdByName("RaymondTeleport"),
YOURPCISBURNING = Isaac.GetSoundIdByName("YOURPCISBURNING"),
PotatoCannon = Isaac.GetSoundIdByName("PotatoCannon"),
DelugeShot = Isaac.GetSoundIdByName("DelugeShot"),
DelugeChargeWarn = Isaac.GetSoundIdByName("DelugeChargeWarn"),
DelugeLand = Isaac.GetSoundIdByName("DelugeLand"),
DelugeSpinWarn = Isaac.GetSoundIdByName("DelugeSpinWarn"),
DelugeSpinEnd = Isaac.GetSoundIdByName("DelugeSpinEnd"),
DelugeLaugh = Isaac.GetSoundIdByName("DelugeLaugh"),
FoozTwinsKick = Isaac.GetSoundIdByName("FoozTwinsKick"),
FoozTwinsCyclone = Isaac.GetSoundIdByName("FoozTwinsCyclone"),
FoozTwinsCycloneBallHit = Isaac.GetSoundIdByName("FoozTwinsCycloneBallHit"),
FoozTwinsRoll = Isaac.GetSoundIdByName("FoozTwinsRoll"),
FoozTwinsAppear = Isaac.GetSoundIdByName("FoozTwinsAppear"),
FoozTwinsDeath = Isaac.GetSoundIdByName("FoozTwinsDeath"),
FoozTwinsImpact = Isaac.GetSoundIdByName("FoozTwinsImpact"),
PropagandaAmbient = Isaac.GetSoundIdByName("PropagandaAmbient"),
PropagandaDeath = Isaac.GetSoundIdByName("PropagandaDeath"),
PropagandaBrainGroan = Isaac.GetSoundIdByName("PropagandaBrainGroan"),
PropagandaBrainLaugh = Isaac.GetSoundIdByName("PropagandaBrainLaugh"),
PropagandaBrainRoar = Isaac.GetSoundIdByName("PropagandaBrainRoar"),
PropagandaBrainSpawn = Isaac.GetSoundIdByName("PropagandaBrainSpawn"),
PropagandaMachiWhimper = Isaac.GetSoundIdByName("PropagandaMachiWhimper"),
PropagandaMachiMoan = Isaac.GetSoundIdByName("PropagandaMachiMoan"),
PropagandaNarcAppear = Isaac.GetSoundIdByName("PropagandaNarcAppear"),
PropagandaNarcCharge = Isaac.GetSoundIdByName("PropagandaNarcCharge"),
PropagandaNarcThroatClear = Isaac.GetSoundIdByName("PropagandaNarcThroatClear"),
PropagandaNarcFeedback = Isaac.GetSoundIdByName("PropagandaNarcFeedback"),
PropagandaNarcMegaphone = Isaac.GetSoundIdByName("PropagandaNarcMegaphone"),
PropagandaPsychoAppear = Isaac.GetSoundIdByName("PropagandaPsychoAppear"),
PropagandaPsychoGroan = Isaac.GetSoundIdByName("PropagandaPsychoGroan"),
PropagandaPsychoToss = Isaac.GetSoundIdByName("PropagandaPsychoToss"),
PropagandaDrumroll = Isaac.GetSoundIdByName("PropagandaDrumroll"),
PropagandaDrumrollLoop = Isaac.GetSoundIdByName("PropagandaDrumrollLoop"),
PropagandaCymbal = Isaac.GetSoundIdByName("PropagandaCymbal"),
PropagandaHorse = Isaac.GetSoundIdByName("PropagandaHorse"),
PropagandaPhaseTrans = Isaac.GetSoundIdByName("PropagandaPhaseTrans"),
PropagandaEnrage = Isaac.GetSoundIdByName("PropagandaEnrage"),
PropagandaDeco = Isaac.GetSoundIdByName("PropagandaDeco"),
PropagandaKillLaugh = Isaac.GetSoundIdByName("PropagandaKillLaugh"),
PropagandaKillLaugh2 = Isaac.GetSoundIdByName("PropagandaKillLaugh2"),
BabyBubblesAppear = Isaac.GetSoundIdByName("BabyBubblesAppear"),
BabyBubblesBlowTearsStart = Isaac.GetSoundIdByName("BabyBubblesBlowTearsStart"),
BabyBubblesBlowTearsShoot = Isaac.GetSoundIdByName("BabyBubblesBlowTearsShoot"),
BabyBubblesSpawnBubble = Isaac.GetSoundIdByName("BabyBubblesSpawnBubble"),
BabyBubblesSpawnBubbleLong = Isaac.GetSoundIdByName("BabyBubblesSpawnBubbleLong"),
BabyBubblesDeath = Isaac.GetSoundIdByName("BabyBubblesDeath"),
BabyBubblesEmergeAttack = Isaac.GetSoundIdByName("BabyBubblesEmergeAttack"),
BabyBubblesEyeBlow = Isaac.GetSoundIdByName("BabyBubblesEyeBlow"),
BabyBubblesSwim = Isaac.GetSoundIdByName("BabyBubblesSwim"),
BabyBubblesPhaseTransition = Isaac.GetSoundIdByName("BabyBubblesPhaseTransition"),
BabyBubblesPhaseTransitionScream = Isaac.GetSoundIdByName("BabyBubblesPhaseTransitionScream"),
BabyBubblesPump = Isaac.GetSoundIdByName("BabyBubblesPump"),
BabyBubblesReemerge = Isaac.GetSoundIdByName("BabyBubblesReemerge"),
BabyBubblesScream = Isaac.GetSoundIdByName("BabyBubblesScream"),
BabyBubblesSubmerge = Isaac.GetSoundIdByName("BabyBubblesSubmerge"),
BabyBubblesSentryAppear = Isaac.GetSoundIdByName("BabyBubblesSentryAppear"),
BabyBubblesSentryShoot = Isaac.GetSoundIdByName("BabyBubblesSentryShoot"),
BabyBubblesSplash = Isaac.GetSoundIdByName("BabyBubblesSplash"),
BabyBubblesPlop = Isaac.GetSoundIdByName("BabyBubblesPlop"),
BabyBubblesBubbleBounce = Isaac.GetSoundIdByName("BabyBubblesBubbleBounce"),
FogspawnCharge = Isaac.GetSoundIdByName("FogspawnCharge"),
FogspawnStart = Isaac.GetSoundIdByName("FogspawnStart"),
FogspawnEnd = Isaac.GetSoundIdByName("FogspawnEnd"),
FogspawnDie = Isaac.GetSoundIdByName("FogspawnDie"),
BatonPass = Isaac.GetSoundIdByName("BatonPass"),
RabbitDoor = Isaac.GetSoundIdByName("RabbitDoor"),
RabbitHorn = Isaac.GetSoundIdByName("RabbitHorn"),
GobyCommon = Isaac.GetSoundIdByName("GobyCommon"),
GobyRare = Isaac.GetSoundIdByName("GobyRare"),
GobySuperSpecialAwesome = Isaac.GetSoundIdByName("GobySuperSpecialAwesome"),
HappySquirrel = Isaac.GetSoundIdByName("HappySquirrel"),
CarWheel = Isaac.GetSoundIdByName("CarWheel"),
PlasticCrunch = Isaac.GetSoundIdByName("PlasticCrunch"),
AnimeShine = Isaac.GetSoundIdByName("AnimeShine"),
ShuffleTimeActivate = Isaac.GetSoundIdByName("ShuffleTimeActivate"),
SodaOpen = Isaac.GetSoundIdByName("Soda Open"),
SodaRecharge = Isaac.GetSoundIdByName("Soda Recharge"),
SodaElectricity = Isaac.GetSoundIdByName("Soda Electricity"),
PlushLamb = Isaac.GetSoundIdByName("Plush Lamb"),
WrenchShoot = Isaac.GetSoundIdByName("WrenchShoot"),
WrenchHit = Isaac.GetSoundIdByName("WrenchHit"),
Level0FlyHit = Isaac.GetSoundIdByName("Level 0 Fly Hit"),
Level0FlyDeath = Isaac.GetSoundIdByName("Level 0 Fly Death"),
Level0FlySwarm = Isaac.GetSoundIdByName("Level 0 Fly Swarm"),
LockBreak1Copy = Isaac.GetSoundIdByName("LockBreak1Copy"),
QueensFruitBurst = Isaac.GetSoundIdByName("QueensFruitBurst"),
QueensFruitExtra = Isaac.GetSoundIdByName("QueensFruitExtra"),
TF2Achievement = Isaac.GetSoundIdByName("TF2Achievement"),
SoapsudsClean = Isaac.GetSoundIdByName("SoapsudsClean"),
ShadowverseHeal = Isaac.GetSoundIdByName("ShadowverseHeal"),
ShadowverseSlash1 = Isaac.GetSoundIdByName("ShadowverseSlash1"),
ShadowverseSlash2 = Isaac.GetSoundIdByName("ShadowverseSlash2"),
FraudulentFungusPickup = Isaac.GetSoundIdByName("FraudulentFungusPickup"),
GizmoBootsFlight = Isaac.GetSoundIdByName("Gizmo Boots Flight"),
MilkGulp = Isaac.GetSoundIdByName("Milk Gulp"),
MilkSigh = Isaac.GetSoundIdByName("Milk Sigh"),
SmallBell = Isaac.GetSoundIdByName("Small Bell"),
RadicalEmbryoRoll  = Isaac.GetSoundIdByName("Embryo Skateboard Roll"),
RadicalEmbryoOllie = Isaac.GetSoundIdByName("Embryo Skateboard Ollie"),
RadicalEmbryoLand  = Isaac.GetSoundIdByName("Embryo Skateboard Land"),
RadicalEmbryoGrind = Isaac.GetSoundIdByName("Embryo Skateboard Grind"),
EmbryoSniff = Isaac.GetSoundIdByName("Embryo Sniff"),
PlatinumCrestFeedback = Isaac.GetSoundIdByName("PlatinumCrestFeedback"),
WoahNewRoom = Isaac.GetSoundIdByName("Woah Room"),
WoahNewFloor = Isaac.GetSoundIdByName("Woah Descended"),
WoahJingle = Isaac.GetSoundIdByName("Woah Jingle"),
InabaHurt = Isaac.GetSoundIdByName("InabaHurt"),
MigraineModeOn = Isaac.GetSoundIdByName("MigraineModeOn"),
MigraineModeOff = Isaac.GetSoundIdByName("MigraineModeOff"),
MigraineModeWarning = Isaac.GetSoundIdByName("MigraineModeWarning"),
CollectInabaPower = Isaac.GetSoundIdByName("CollectInabaPower"),
InabaPowerLevelUp = Isaac.GetSoundIdByName("InabaPowerLevelUp"),
SlapcardItemActivate = Isaac.GetSoundIdByName("SlapcardItemActivate"),
BoundlessDoorTransition = Isaac.GetSoundIdByName("BoundlessDoorTransition"),
CryBabyTantrum = Isaac.GetSoundIdByName("Cry Baby Tantrum"),
MysteriousStrangerAppears = Isaac.GetSoundIdByName("MysteriousStrangerAppears"),
MysteriousStrangerLeaves = Isaac.GetSoundIdByName("MysteriousStrangerLeaves"),
ShadowMantleMove = Isaac.GetSoundIdByName("ShadowMantleMove"),
StevenTransformationTeleport = Isaac.GetSoundIdByName("StevenTransformationTeleport"),
TimeFcukPlayerLand = Isaac.GetSoundIdByName("TimeFcukPlayerLand"),
TimeFcukTalkie = Isaac.GetSoundIdByName("TimeFcukTalkie"),
JukeboxRoll = Isaac.GetSoundIdByName("JukeboxRoll"),
JukeboxRollEnd = Isaac.GetSoundIdByName("JukeboxRollEnd"),
FriendlyLaugh = Isaac.GetSoundIdByName("FriendlyLaugh"),
BuddyHolly = Isaac.GetSoundIdByName("BuddyHolly"),
AmonWindLoop = Isaac.GetSoundIdByName("AmonWindLoop"),
BadToTheBone = Isaac.GetSoundIdByName("BadToTheBone"),
WarHornOn = Isaac.GetSoundIdByName("The War Horn"),
WarHornOff = Isaac.GetSoundIdByName("The War Horn Off"),
MiImpHurt = Isaac.GetSoundIdByName("MiImpHurt"),
MiImpDead = Isaac.GetSoundIdByName("MiImpDead"),
SpookingOfIsaacGaper = Isaac.GetSoundIdByName("SpookingOfIsaacGaper"),
CopperWrench = Isaac.GetSoundIdByName("CopperWrench"),

--Friend Guns
AmbassadorFire = Isaac.GetSoundIdByName("AmbassadorFire"),
SplattershotJrFire = Isaac.GetSoundIdByName("SplattershotJrFire"),
SilencedPistolFire = Isaac.GetSoundIdByName("SilencedPistolFire"),
AirzookaFire = Isaac.GetSoundIdByName("AirzookaFire"),
RighteousBisonFire = Isaac.GetSoundIdByName("RighteousBisonFire"),
AirbisonFire = Isaac.GetSoundIdByName("AirbisonFire"),
MinisharkFire = Isaac.GetSoundIdByName("MinisharkFire"),
GrenadeLauncherFire = Isaac.GetSoundIdByName("GrenadeLauncherFire"),
GrenadeLauncherFireCrit = Isaac.GetSoundIdByName("GrenadeLauncherFireCrit"),
GrenadeLauncherReloadStart = Isaac.GetSoundIdByName("GrenadeLauncherReloadStart"),
GrenadeLauncherReload = Isaac.GetSoundIdByName("GrenadeLauncherReload"),
GrenadeLauncherReloadEnd = Isaac.GetSoundIdByName("GrenadeLauncherReloadEnd"),
AmmoWarning = Isaac.GetSoundIdByName("AmmoWarning"),
BulletImpact = Isaac.GetSoundIdByName("BulletImpact"),
MinigunFireLoop = Isaac.GetSoundIdByName("MinigunFireLoop"),
MinigunFireCritLoop = Isaac.GetSoundIdByName("MinigunFireCritLoop"),
MinigunSpinLoop = Isaac.GetSoundIdByName("MinigunSpinLoop"),
MinigunWindDown = Isaac.GetSoundIdByName("MinigunWindDown"),
MinigunWindUp = Isaac.GetSoundIdByName("MinigunWindUp"),
NTPistolShoot = Isaac.GetSoundIdByName("NTPistolShoot"),
NTPistolSwap = Isaac.GetSoundIdByName("NTPistolSwap"),
BeggarbazookaReload = Isaac.GetSoundIdByName("BeggarbazookaReload"),

--Friend Guns 2
RevolverShoot = Isaac.GetSoundIdByName("RevolverShoot"),
RevolverReload = Isaac.GetSoundIdByName("RevolverReload"),
RevolverReloadFinish = Isaac.GetSoundIdByName("RevolverReloadFinish"),
ShotgunShoot = Isaac.GetSoundIdByName("ShotgunShoot"),
ShotgunReload = Isaac.GetSoundIdByName("ShotgunReload"),
ShotgunReloadFinish = Isaac.GetSoundIdByName("ShotgunReloadFinish"),
WatergunShoot = Isaac.GetSoundIdByName("WatergunShoot"),
WatergunReload = Isaac.GetSoundIdByName("WatergunReload"),
WatergunReloadFinish = Isaac.GetSoundIdByName("WatergunReloadFinish"),
SMGShoot = Isaac.GetSoundIdByName("SMGShoot"),
SMGReloadFinish = Isaac.GetSoundIdByName("SMGReloadFinish"),
MagnumShoot = Isaac.GetSoundIdByName("MagnumShoot"),
LauncherShoot = Isaac.GetSoundIdByName("LauncherShoot"),
LauncherReloadStart = Isaac.GetSoundIdByName("LauncherReloadStart"),
LauncherReload = Isaac.GetSoundIdByName("LauncherReload"),
LauncherReloadFinish = Isaac.GetSoundIdByName("LauncherReloadFinish"),
FlareShoot = Isaac.GetSoundIdByName("FlareShoot"),
FlareReloadFinish = Isaac.GetSoundIdByName("FlareReloadFinish"),
GarandPing = Isaac.GetSoundIdByName("GarandPing"),
HandcannonShoot = Isaac.GetSoundIdByName("HandcannonShoot"),

--IDPD (im sorry for this)
IDPDPortal = Isaac.GetSoundIdByName("IDPDPortal"),
IDPDExplosion = Isaac.GetSoundIdByName("IDPDExplosion"),
IDPDGrenadePrime = Isaac.GetSoundIdByName("IDPDGrenadePrime"),
IDPDGrenadeBeep = Isaac.GetSoundIdByName("IDPDGrenadeBeep"),
IDPDGunFire = Isaac.GetSoundIdByName("IDPDGunFire"),
IDPDThrowGrenade = Isaac.GetSoundIdByName("IDPDThrowGrenade"),
IDPDShieldDeflect = Isaac.GetSoundIdByName("IDPDShieldDeflect"),

IDPDGruntAppearMale = Isaac.GetSoundIdByName("IDPDGruntAppearMale"),
IDPDGruntHurtMale = Isaac.GetSoundIdByName("IDPDGruntHurtMale"),
IDPDGruntDeathMale = Isaac.GetSoundIdByName("IDPDGruntDeathMale"),
IDPDGruntAppearFemale = Isaac.GetSoundIdByName("IDPDGruntAppearFemale"),
IDPDGruntHurtFemale = Isaac.GetSoundIdByName("IDPDGruntHurtFemale"),
IDPDGruntDeathFemale = Isaac.GetSoundIdByName("IDPDGruntDeathFemale"),

IDPDInspectorAppearMale = Isaac.GetSoundIdByName("IDPDInspectorAppearMale"),
IDPDInspectorHurtMale = Isaac.GetSoundIdByName("IDPDInspectorHurtMale"),
IDPDInspectorDeathMale = Isaac.GetSoundIdByName("IDPDInspectorDeathMale"),
IDPDInspectorTeleStartMale = Isaac.GetSoundIdByName("IDPDInspectorTeleStartMale"),
IDPDInspectorTeleEndMale = Isaac.GetSoundIdByName("IDPDInspectorTeleEndMale"),
IDPDInspectorAppearFemale = Isaac.GetSoundIdByName("IDPDInspectorAppearFemale"),
IDPDInspectorHurtFemale = Isaac.GetSoundIdByName("IDPDInspectorHurtFemale"),
IDPDInspectorDeathFemale = Isaac.GetSoundIdByName("IDPDInspectorDeathFemale"),
IDPDInspectorTeleStartFemale = Isaac.GetSoundIdByName("IDPDInspectorTeleStartFemale"),
IDPDInspectorTeleEndFemale = Isaac.GetSoundIdByName("IDPDInspectorTeleEndFemale"),

IDPDShielderAppearMale = Isaac.GetSoundIdByName("IDPDShielderAppearMale"),
IDPDShielderHurtMale = Isaac.GetSoundIdByName("IDPDShielderHurtMale"),
IDPDShielderDeathMale = Isaac.GetSoundIdByName("IDPDShielderDeathMale"),
IDPDShielderShieldMale = Isaac.GetSoundIdByName("IDPDShielderShieldMale"),
IDPDShielderAppearFemale = Isaac.GetSoundIdByName("IDPDShielderAppearFemale"),
IDPDShielderHurtFemale = Isaac.GetSoundIdByName("IDPDShielderHurtFemale"),
IDPDShielderDeathFemale = Isaac.GetSoundIdByName("IDPDShielderDeathFemale"),
IDPDShielderShieldFemale = Isaac.GetSoundIdByName("IDPDShielderShieldFemale"),

--Voiceover lines
VAWoohooMyDogKalu = Isaac.GetSoundIdByName("VAWOOHOOMYDOGKALU"),
VAPillClairvoyance = Isaac.GetSoundIdByName("VAPillClairvoyance"),
VAPillCyanide = Isaac.GetSoundIdByName("VAPillCyanide"),
VAPillEpidermolysis = Isaac.GetSoundIdByName("VAPillEpidermolysis"),
VAPillFishOil = Isaac.GetSoundIdByName("VAPillFishOil"),
VAPillHaemorrhoids = Isaac.GetSoundIdByName("VAPillHaemorrhoids"),
VAPillHolyShit = Isaac.GetSoundIdByName("VAPillHolyShit"),
VAPillLemonJuice = Isaac.GetSoundIdByName("VAPillLemonJuice"),
VAPillMelatonin = Isaac.GetSoundIdByName("VAPillMelatonin"),
VAPillRainbowPill = Isaac.GetSoundIdByName("VAPillRainbowPill"),
VAPillSpiderUnboxing = Isaac.GetSoundIdByName("VAPillSpiderUnboxing"),
VAPillBrimstone = Isaac.GetSoundIdByName("VAPillBrimstone"),
VAPillMorningAfter = Isaac.GetSoundIdByName("VAPillMorningAfter"),
VAPillSertraline = Isaac.GetSoundIdByName("VAPillSertraline"),
VAPillHorseClairvoyance = Isaac.GetSoundIdByName("VAPillHorseClairvoyance"),
VAPillHorseCyanide = Isaac.GetSoundIdByName("VAPillHorseCyanide"),
VAPillHorseEpidermolysis = Isaac.GetSoundIdByName("VAPillHorseEpidermolysis"),
VAPillHorseFishOil = Isaac.GetSoundIdByName("VAPillHorseFishOil"),
VAPillHorseHaemorrhoids = Isaac.GetSoundIdByName("VAPillHorseHaemorrhoids"),
VAPillHorseHolyShit = Isaac.GetSoundIdByName("VAPillHorseHolyShit"),
VAPillHorseLemonJuice = Isaac.GetSoundIdByName("VAPillHorseLemonJuice"),
VAPillHorseMelatonin = Isaac.GetSoundIdByName("VAPillHorseMelatonin"),
VAPillHorseSpiderUnboxing = Isaac.GetSoundIdByName("VAPillHorseSpiderUnboxing"),
VAPillHorseBrimstone = Isaac.GetSoundIdByName("VAPillHorseBrimstone"),
VAPillHorseMorningAfter = Isaac.GetSoundIdByName("VAPillHorseMorningAfter"),
VAPillHorseSertraline = Isaac.GetSoundIdByName("VAPillHorseSertraline"),
VACardThreeFireballs = Isaac.GetSoundIdByName("VACardThreeFireballs"),
VACardThreeFireballsBiend = Isaac.GetSoundIdByName("VACardThreeFireballsBiend"),
VACardCallingCard = Isaac.GetSoundIdByName("VACardCallingCard"),
VACardDarkHole = Isaac.GetSoundIdByName("VACardDarkHole"),
VACardDefuse = Isaac.GetSoundIdByName("VACardDefuse"),
VACardDownloadFailure = Isaac.GetSoundIdByName("VACardDownloadFailure"),
VACardDownloadFailureRare = Isaac.GetSoundIdByName("VACardDownloadFailureRare"),
VACardFlipCard = Isaac.GetSoundIdByName("VACardFlipCard"),
VACardGiftCard = Isaac.GetSoundIdByName("VACardGiftCard"),
VACardGrottoBeast = Isaac.GetSoundIdByName("VACardGrottoBeast"),
VACardImplosion = Isaac.GetSoundIdByName("VACardImplosion"),
VACardMisprintedGish = Isaac.GetSoundIdByName("VACardMisprintedGish"),
VACardPlagueofDecay = Isaac.GetSoundIdByName("VACardPlagueofDecay"),
VACardPotofGreed = Isaac.GetSoundIdByName("VACardPotofGreed"),
VACardPotofGreedRare = Isaac.GetSoundIdByName("VACardPotofGreedRare"),
VACardSealofOrichalcos = Isaac.GetSoundIdByName("VACardSealofOrichalcos"),
VACardSkipCard = Isaac.GetSoundIdByName("VACardSkipCard"),
VACardSmallContraband = Isaac.GetSoundIdByName("VACardSmallContraband"),
VACardHappySquirrel = Isaac.GetSoundIdByName("VACardHappySquirrel"),
VACardInvisibleMoon = Isaac.GetSoundIdByName("VACardInvisibleMoon"),
VACardDestinyBoard = Isaac.GetSoundIdByName("VACardDestinyBoard"),
VACardNekoNyan = Isaac.GetSoundIdByName("VACardNekoNyan"),
VACardRedactedTriangle = Isaac.GetSoundIdByName("VACardRedactedTriangle"),
VACardRescueCat = Isaac.GetSoundIdByName("VACardRescueCat"),
VACardEyeOfTruth = Isaac.GetSoundIdByName("VACardEyeOfTruth"),
VACardPlayingAceCups = Isaac.GetSoundIdByName("VACardPlayingAceCups"),
VACardPlayingAcePentacles = Isaac.GetSoundIdByName("VACardPlayingAcePentacles"),
VACardPlayingAceSwords = Isaac.GetSoundIdByName("VACardPlayingAceSwords"),
VACardPlayingAceWands = Isaac.GetSoundIdByName("VACardPlayingAceWands"),
VACardPlayingJackClubs = Isaac.GetSoundIdByName("VACardPlayingJackClubs"),
VACardPlayingJackDiamonds = Isaac.GetSoundIdByName("VACardPlayingJackDiamonds"),
VACardPlayingJackHearts = Isaac.GetSoundIdByName("VACardPlayingJackHearts"),
VACardPlayingJackSpades = Isaac.GetSoundIdByName("VACardPlayingJackSpades"),
VACardPlayingKingClubs = Isaac.GetSoundIdByName("VACardPlayingKingClubs"),
VACardPlayingKingClubsReverse = Isaac.GetSoundIdByName("VACardPlayingKingClubsReverse"),
VACardPlayingKingCups = Isaac.GetSoundIdByName("VACardPlayingKingCups"),
VACardPlayingKingDiamonds = Isaac.GetSoundIdByName("VACardPlayingKingDiamonds"),
VACardPlayingKingPentacles = Isaac.GetSoundIdByName("VACardPlayingKingPentacles"),
VACardPlayingKingPentaclesReverse = Isaac.GetSoundIdByName("VACardPlayingKingPentaclesReverse"),
VACardPlayingKingSpades = Isaac.GetSoundIdByName("VACardPlayingKingSpades"),
VACardPlayingKingSwords = Isaac.GetSoundIdByName("VACardPlayingKingSwords"),
VACardPlayingKingWands = Isaac.GetSoundIdByName("VACardPlayingKingWands"),
VACardPlayingQueenClubs = Isaac.GetSoundIdByName("VACardPlayingQueenClubs"),
VACardPlayingQueenDiamonds = Isaac.GetSoundIdByName("VACardPlayingQueenDiamonds"),
VACardPlayingQueenSpades = Isaac.GetSoundIdByName("VACardPlayingQueenSpades"),
VACardPlayingThirteenStars = Isaac.GetSoundIdByName("VACardPlayingThirteenStars"),
VACardPlayingThirteenStarsRare = Isaac.GetSoundIdByName("VACardPlayingThirteenStarsRare"),
VACardPlayingThreeClubs = Isaac.GetSoundIdByName("VACardPlayingThreeClubs"),
VACardPlayingThreeCups = Isaac.GetSoundIdByName("VACardPlayingThreeCups"),
VACardPlayingThreeDiamonds = Isaac.GetSoundIdByName("VACardPlayingThreeDiamonds"),
VACardPlayingThreeHearts = Isaac.GetSoundIdByName("VACardPlayingThreeHearts"),
VACardPlayingThreePentacles = Isaac.GetSoundIdByName("VACardPlayingThreePentacles"),
VACardPlayingThreeSpades = Isaac.GetSoundIdByName("VACardPlayingThreeSpades"),
VACardPlayingThreeSwords = Isaac.GetSoundIdByName("VACardPlayingThreeSwords"),
VACardPlayingThreeWands = Isaac.GetSoundIdByName("VACardPlayingThreeWands"),
VACardPlayingTwoCups = Isaac.GetSoundIdByName("VACardPlayingTwoCups"),
VACardPlayingTwoPentacles = Isaac.GetSoundIdByName("VACardPlayingTwoPentacles"),
VACardPlayingTwoSwords = Isaac.GetSoundIdByName("VACardPlayingTwoSwords"),
VACardPlayingTwoWands = Isaac.GetSoundIdByName("VACardPlayingTwoWands"),
VACardEnergyColorless = Isaac.GetSoundIdByName("VACardEnergyColorless"),
VACardEnergyDarkness = Isaac.GetSoundIdByName("VACardEnergyDarkness"),
VACardEnergyDragon = Isaac.GetSoundIdByName("VACardEnergyDragon"),
VACardEnergyFairy = Isaac.GetSoundIdByName("VACardEnergyFairy"),
VACardEnergyFighting = Isaac.GetSoundIdByName("VACardEnergyFighting"),
VACardEnergyFire = Isaac.GetSoundIdByName("VACardEnergyFire"),
VACardEnergyGrass = Isaac.GetSoundIdByName("VACardEnergyGrass"),
VACardEnergyLightning = Isaac.GetSoundIdByName("VACardEnergyLightning"),
VACardEnergyMetal = Isaac.GetSoundIdByName("VACardEnergyMetal"),
VACardEnergyPsychic = Isaac.GetSoundIdByName("VACardEnergyPsychic"),
VACardEnergyTrainer = Isaac.GetSoundIdByName("VACardEnergyTrainer"),
VACardEnergyWater = Isaac.GetSoundIdByName("VACardEnergyWater"),
VACardJitsuFlooringUpgrade = Isaac.GetSoundIdByName("VACardJitsuFlooringUpgrade"),
VACardJitsuAC3000 = Isaac.GetSoundIdByName("VACardJitsuAC3000"),
VACardJitsuSoccer = Isaac.GetSoundIdByName("VACardJitsuSoccer"),
VACardShadowverseTribunalOfGoodAndEvil = Isaac.GetSoundIdByName("VACardShadowverseTribunalOfGoodAndEvil"),
VACardShadowverseDraconicFervor = Isaac.GetSoundIdByName("VACardShadowverseDraconicFervor"),
VACardShadowverseDanceOfUsurpation = Isaac.GetSoundIdByName("VACardShadowverseDanceOfUsurpation"),
VACardShadowverseHauntedHouse = Isaac.GetSoundIdByName("VACardShadowverseHauntedHouse"),
VACardShadowverseDireBond = Isaac.GetSoundIdByName("VACardShadowverseDireBond"),
VACardShadowverseElfSong = Isaac.GetSoundIdByName("VACardShadowverseElfSong"),
VACardSlayTheSpireCreativeAI = Isaac.GetSoundIdByName("VACardSlayTheSpireCreativeAI"),
VACardSlayTheSpireNeighborsFromHell = Isaac.GetSoundIdByName("VACardSlayTheSpireNeighborsFromHell"),
VACardSlayTheSpireCorruption = Isaac.GetSoundIdByName("VACardSlayTheSpireCorruption"),
VACardSlayTheSpireBlasphemy = Isaac.GetSoundIdByName("VACardSlayTheSpireBlasphemy"),
VACardOrangeJuiceCloudOfSeagulls = Isaac.GetSoundIdByName("VACardOrangeJuiceCloudOfSeagulls"),
VACardOrangeJuiceDarkSideOfBusiness = Isaac.GetSoundIdByName("VACardOrangeJuiceDarkSideOfBusiness"),
VACardOrangeJuiceIndiscriminateFireSupport = Isaac.GetSoundIdByName("VACardOrangeJuiceIndiscriminateFireSupport"),
VACardOrangeJuiceComingBackStronger = Isaac.GetSoundIdByName("VACardOrangeJuiceComingBackStronger"),
VACardOrangeJuiceSereneHush = Isaac.GetSoundIdByName("VACardOrangeJuiceSereneHush"),
VACardOrangeJuiceMixPhenomenon = Isaac.GetSoundIdByName("VACardOrangeJuiceMixPhenomenon"),
VACardOrangeJuiceJonathanRush = Isaac.GetSoundIdByName("VACardOrangeJuiceJonathanRush"),
VACardOrangeJuiceWindyEnchantment = Isaac.GetSoundIdByName("VACardOrangeJuiceWindyEnchantment"),
VACardOrangeJuiceHindenpeater = Isaac.GetSoundIdByName("VACardOrangeJuiceHindenpeater"),
VACardOrangeJuiceHindenpeaterRare = Isaac.GetSoundIdByName("VACardOrangeJuiceHindenpeaterRare"),
VACardOrangeJuiceNicePresent = Isaac.GetSoundIdByName("VACardOrangeJuiceNicePresent"),
VARuneAnsus = Isaac.GetSoundIdByName("VARuneAnsus"),
VARuneSoulChina = Isaac.GetSoundIdByName("VARuneSoulChina"),
VARuneSoulCraig = Isaac.GetSoundIdByName("VARuneSoulCraig"),
VARuneSoulFend = Isaac.GetSoundIdByName("VARuneSoulFend"),
VARuneSoulFiend = Isaac.GetSoundIdByName("VARuneSoulFiend"),
VARuneSoulFient = Isaac.GetSoundIdByName("VARuneSoulFient"),
VARuneSoulFriend = Isaac.GetSoundIdByName("VARuneSoulFriend"),
VARuneSoulFrond = Isaac.GetSoundIdByName("VARuneSoulFrond"),
VARuneSoulGolem = Isaac.GetSoundIdByName("VARuneSoulGolem"),
VARuneSoulMi = Isaac.GetSoundIdByName("VARuneSoulMi"),
VARuneSoulPete = Isaac.GetSoundIdByName("VARuneSoulPete"),
VARuneSoulRandom = Isaac.GetSoundIdByName("VARuneSoulRandom"),
VARuneSoulSlippy = Isaac.GetSoundIdByName("VARuneSoulSlippy"),
VARuneSoulFortuneTeller = Isaac.GetSoundIdByName("VARuneSoulFortuneTeller"),
VARuneSoulSkeletalFiend = Isaac.GetSoundIdByName("VARuneSoulSkeletalFiend"),
VAObjectBattleCarrier = Isaac.GetSoundIdByName("VAObjectBattleCarrier"),
VAObjectBlankLetterTile = Isaac.GetSoundIdByName("VAObjectBlankLetterTile"),
VAObjectBrickSeperator = Isaac.GetSoundIdByName("VAObjectBrickSeperator"),
VAObjectChristmasCracker = Isaac.GetSoundIdByName("VAObjectChristmasCracker"),
VAObjectCoolPhoto = Isaac.GetSoundIdByName("VAObjectCoolPhoto"),
VAObjectCorrodedBattery = Isaac.GetSoundIdByName("VAObjectCorrodedBattery"),
VAObjectEternalDiceShard = Isaac.GetSoundIdByName("VAObjectEternalDiceShard"),
VAObjectFriendFigure = Isaac.GetSoundIdByName("VAObjectFriendFigure"),
VAObjectGamePiece = Isaac.GetSoundIdByName("VAObjectGamePiece"),
VAObjectGreenHouse = Isaac.GetSoundIdByName("VAObjectGreenHouse"),
VAObjectHorsePushPop = Isaac.GetSoundIdByName("VAObjectHorsePushPop"),
VAObjectLegoStud = Isaac.GetSoundIdByName("VAObjectLegoStud"),
VAObjectLoveLetter = Isaac.GetSoundIdByName("VAObjectLoveLetter"),
VAObjectPuzzlePiece = Isaac.GetSoundIdByName("VAObjectPuzzlePiece"),
VAObjectSorry = Isaac.GetSoundIdByName("VAObjectSorry"),
VAObjectStorageBattery = Isaac.GetSoundIdByName("VAObjectStorageBattery"),
VAObjectTopHat = Isaac.GetSoundIdByName("VAObjectTopHat"),
VAObjectPinkCow = Isaac.GetSoundIdByName("VAObjectPinkCow"),
VAObjectYellowCar = Isaac.GetSoundIdByName("VAObjectYellowCar"),
VAObjectLuckyDuck = Isaac.GetSoundIdByName("VAObjectLuckyDuck"),
VAObjectComicalRoundGlasses = Isaac.GetSoundIdByName("VAObjectComicalRoundGlasses"),
VAObjectEggSack = Isaac.GetSoundIdByName("VAObjectEggSack"),
VAObjectDiscAngel = Isaac.GetSoundIdByName("VAObjectDiscAngel"),
VAObjectDiscBoss = Isaac.GetSoundIdByName("VAObjectDiscBoss"),
VAObjectDiscBroken = Isaac.GetSoundIdByName("VAObjectDiscBroken"),
VAObjectDiscChaos = Isaac.GetSoundIdByName("VAObjectDiscChaos"),
VAObjectDiscDevil = Isaac.GetSoundIdByName("VAObjectDiscDevil"),
VAObjectDiscPlanetarium = Isaac.GetSoundIdByName("VAObjectDiscPlanetarium"),
VAObjectDiscSecret = Isaac.GetSoundIdByName("VAObjectDiscSecret"),
VAObjectDiscShop = Isaac.GetSoundIdByName("VAObjectDiscShop"),
VAObjectDiscTainted = Isaac.GetSoundIdByName("VAObjectDiscTainted"),
VAObjectDiscTreasure = Isaac.GetSoundIdByName("VAObjectDiscTreasure"),
VAObjectDiscTrinket = Isaac.GetSoundIdByName("VAObjectDiscTrinket"),
VAObjectGlassDiceAzuriteSpindown = Isaac.GetSoundIdByName("VAObjectGlassDiceAzuriteSpindown"),
VAObjectGlassDice2 = Isaac.GetSoundIdByName("VAObjectGlassDice2"),
VAObjectGlassDice4 = Isaac.GetSoundIdByName("VAObjectGlassDice4"),
VAObjectGlassDice6 = Isaac.GetSoundIdByName("VAObjectGlassDice6"),
VAObjectGlassDice8 = Isaac.GetSoundIdByName("VAObjectGlassDice8"),
VAObjectGlassDice10 = Isaac.GetSoundIdByName("VAObjectGlassDice10"),
VAObjectGlassDice12 = Isaac.GetSoundIdByName("VAObjectGlassDice12"),
VAObjectGlassDice20 = Isaac.GetSoundIdByName("VAObjectGlassDice20"),
VAObjectGlassDice100 = Isaac.GetSoundIdByName("VAObjectGlassDice100"),
VAObjectGlassDiceSpindown = Isaac.GetSoundIdByName("VAObjectGlassDiceSpindown"),
VAKalu = Isaac.GetSoundIdByName("VAKalu"),
}

FiendFolio.TempSoundEnums = {
	ChubbyFire = 849,
	EpicFetus  = 855,
	ButterDrop = 901,
	ButterLand = 902,
	PrideLaser = 903,
	D6Roll 	   = 910,
}

FiendFolio.challenges = {
dadsHomePlus = Isaac.GetChallengeIdByName("[FF] Dad's Home+"),
theRealJon = Isaac.GetChallengeIdByName("[FF] The Real Jon"),
dirtyBubble = Isaac.GetChallengeIdByName("[FF] Dirty Bubble Challenge"),
frogMode = Isaac.GetChallengeIdByName("[FF] Frog Mode"),
handsOn = Isaac.GetChallengeIdByName("[FFBonus!] Hands On"),
isaacRebuilt = Isaac.GetChallengeIdByName("[FF] Isaac Rebuilt"),
brickByBrick = Isaac.GetChallengeIdByName("[FF] Brick By Brick"),
towerOffense = Isaac.GetChallengeIdByName("[FF] Tower Offense"),
chinaShop = Isaac.GetChallengeIdByName("[FF] Handle With Care"),
theGauntlet = Isaac.GetChallengeIdByName("[FF] The Gauntlet"),
catchTheseHands = Isaac.GetChallengeIdByName("[FF] Mr. Hands"),
noOffense = Isaac.GetChallengeIdByName("[FF] No Offense"),
embryosAkimbo = Isaac.GetChallengeIdByName("[FF] Embryos Akimbo"),
craigChallenge = Isaac.GetChallengeIdByName("[FF] Craig's Challenge"),
allYouCanEat = Isaac.GetChallengeIdByName("[FFBonus!] Punkychunk Challenge"),
blursed = Isaac.GetChallengeIdByName("[FF] Blursed"),
allowEnemyReplacements = Isaac.GetChallengeIdByName("[FF] Allow Enemy Replacements"),
penIsland = Isaac.GetChallengeIdByName("[FF] Pen Island"),
babySensory = Isaac.GetChallengeIdByName("[FF] Baby Sensory"),
cursedIfItWasGood = Isaac.GetChallengeIdByName("[FF] Boss Makes a Dollar"),
devilsHarvest = Isaac.GetChallengeIdByName("[FF] The Devil's Harvest"),
imperishableNight = Isaac.GetChallengeIdByName("[FF] Imperishable Night"),
magnaFarta = Isaac.GetChallengeIdByName("[FF] Magna Farta"),
}

FiendFolio.curses = {
impCurse = Isaac.GetCurseIdByName("Curse of the Imp!"),
stoneCurse = Isaac.GetCurseIdByName("Curse of the Stone!"),
sunCurse = Isaac.GetCurseIdByName("Curse of the Sun!"),
swineCurse = Isaac.GetCurseIdByName("Curse of the Swine!"),
ghostCurse = Isaac.GetCurseIdByName("Curse of the Ghost!"),
scytheCurse = Isaac.GetCurseIdByName("Curse of the Scythe!"),
masterCurse = Isaac.GetCurseIdByName("Curse of the Master!"),
dynamoCurse = Isaac.GetCurseIdByName("Curse of the Dynamo!"),
lunacyCurse = Isaac.GetCurseIdByName("Curse of Lunacy!"),
--fungusCurse = Isaac.GetCurseIdByName("Curse of the Fungus!"),
veilCurse = Isaac.GetCurseIdByName("Curse of the Veil!"),
gateCurse = Isaac.GetCurseIdByName("Curse of the Gate!")
}

FiendFolio.SunCurses = {
	FiendFolio.curses.impCurse,
	FiendFolio.curses.stoneCurse,
	FiendFolio.curses.sunCurse,
	FiendFolio.curses.swineCurse,
	FiendFolio.curses.ghostCurse,
	FiendFolio.curses.scytheCurse,
	FiendFolio.curses.masterCurse,
	FiendFolio.curses.dynamoCurse,
	FiendFolio.curses.lunacyCurse,
	--FiendFolio.curses.fungusCurse,
}


FiendFolio.FFID = {
Snake = 	108,
Oro = 		112,
Ferrium =   114,
Ferrium2 =  115,
Taiga = 	120,
Sbody =		124,
Dead = 		130,
Guill = 	140,
Tech = 		150,
Erfly = 	160,
Julia = 	170,
Boss = 		180,
Grid =		183,
Poop =		184,
JD = 		195,
Hippo = 	197,
GuwahJoke = 333,
Cake = 		369,
Guwah = 	450,
Guwah2 =	451,
Pixel = 	570,
Vermin = 	610,
Connor = 	617,
Mini = 		666,
Cat = 		734,
Xalum = 	750,
Blor =      132,
Effect = 	1960,

--Individual enemies (should probably change later)
Congression =	709,
Slammer = 		151,
SquareFly = 	152,
Sniffle = 		153,
Snagger = 		154,
Weaver = 		155,
Craterface = 	156,
Psion = 		159,
}

FiendFolio.FF = {
-- Tear Variants
ChubberTear =			{ID = 2, Var = Isaac.GetEntityVariantByName("Chubber Tear")},
PocketRockitTear =		{ID = 2, Var = Isaac.GetEntityVariantByName("Pocket Rock-it Tear")},

-- Slot Variants
PokerTable = 			{ID = 6, Var = Isaac.GetEntityVariantByName("Poker Table")},
Blacksmith = 			{ID = 6, Var = Isaac.GetEntityVariantByName("Blacksmith")},
ZodiacBeggar = 			{ID = 6, Var = Isaac.GetEntityVariantByName("Zodiac Beggar")},
RobotTeller = 			{ID = 6, Var = Isaac.GetEntityVariantByName("Robot Teller")},
EvilBeggar = 			{ID = 6, Var = Isaac.GetEntityVariantByName("Evil Beggar")},
FakeBeggar = 			{ID = 6, Var = Isaac.GetEntityVariantByName("Fake Beggar")},
Dealer = 				{ID = 6, Var = Isaac.GetEntityVariantByName("Dealer")},
CellGame =				{ID = 6, Var = Isaac.GetEntityVariantByName("Cell Game")},
HugBeggar =				{ID = 6, Var = Isaac.GetEntityVariantByName("Hug Beggar")},
CosplayBeggar =			{ID = 6, Var = Isaac.GetEntityVariantByName("Cosplay Beggar")},
PhoneBooth =			{ID = 6, Var = Isaac.GetEntityVariantByName("Phone Booth")},
GoldenSlotMachine =		{ID = 6, Var = Isaac.GetEntityVariantByName("Golden Slot Machine")},
Jukebox =				{ID = 6, Var = Isaac.GetEntityVariantByName("Jukebox")},
VendingMachine =		{ID = 6, Var = Isaac.GetEntityVariantByName("Vending Machine (Vanilla)")},
VendingMachineFF =		{ID = 6, Var = Isaac.GetEntityVariantByName("Vending Machine (Fiend Folio)")},
MiningMachine =			{ID = 6, Var = Isaac.GetEntityVariantByName("Mining Machine")},
BismuthBeggar =			{ID = 6, Var = Isaac.GetEntityVariantByName("Bismuth Beggar")},
UnfinishedGolem =		{ID = 6, Var = Isaac.GetEntityVariantByName("Unfinished Golem")},
Sourpuss =				{ID = 6, Var = Isaac.GetEntityVariantByName("Sourpuss")},
GeodeGolem =			{ID = 6, Var = Isaac.GetEntityVariantByName("Geode Golem")},
Babi =					{ID = 6, Var = 1025 --[[Isaac.GetEntityVariantByName("Babi")]]}, --Babi might easily get used by somethin' else
Midarizer =				{ID = 6, Var = Isaac.GetEntityVariantByName("Midarizer")},
Sweetpuss =				{ID = 6, Var = Isaac.GetEntityVariantByName("Sweetpuss")},
DiceDispenser =			{ID = 6, Var = Isaac.GetEntityVariantByName("Dice Dispenser")},
PennyPress =			{ID = 6, Var = Isaac.GetEntityVariantByName("Penny Press")},
GridRestock =			{ID = 6, Var = Isaac.GetEntityVariantByName("Grid Restock Machine")},
MilkMachine =			{ID = 6, Var = Isaac.GetEntityVariantByName("Milk Machine")},
MilkFlavorContainer =	{ID = 6, Var = Isaac.GetEntityVariantByName("MM Flavor Container")},
MilkQualityModulator =	{ID = 6, Var = Isaac.GetEntityVariantByName("MM Quality Modulator")},

--Gaper variants
BigHead = 				{ID = 10, Var = 160},
PsychicGaper = 			{ID = 10, Var = 161},
WallGaper = 			{ID = 10, Var = 162},
PennyGaper = 			{ID = 10, Var = 163},

--Mulligan variants
Facade = 				{ID = 16, Var = 960},

--Shopkeeper variants
FFShopkeeper = 			{ID = 17, Var = 700},
CustomMoter = 			{ID = 18, Var = mod.FFID.Ferrium},
DrownedAttackFly = 		{ID = 18, Var = 960},

--Larry Jr. variants
LarryGhost = 			{ID = 19, Var = 0, IDx = Isaac.GetBossColorIdxByName("FF Ghost Larry")},
HollowFuckedUpAndEvil = {ID = 19, Var = 1, IDx = Isaac.GetBossColorIdxByName("FF Fucked Up and Evil Hollow")},

--Monstro variants
MucusMonstro = 			{ID = 20, Var = 0, IDx = Isaac.GetBossColorIdxByName("FF Mucus Monstro")},

--Maggot variants
Nimbus = 				{ID = 21, Var = 666},
CreepyMaggot = 			{ID = 21, Var = 750},
RolyPoly = 				{ID = 21, Var = 960},
Isopoly = 				{ID = 21, Var = 960, Sub = 2},
PsiKnight = 			{ID = 21, Var = 961},
PsiKnightHusk = 		{ID = 21, Var = 961, Sub = 0},
PsiKnightBrain = 		{ID = 21, Var = 961, Sub = 1},

--Hive variants
Cistern = 				{ID = 22, Var = 666},

--Charger variants
Sternum = 				{ID = 23, Var = 960},
Splodum = 				{ID = 23, Var = 961},
ReheatedCharger = 		{ID = 23, Var = 1700},

--Boom fly variants
PsychoFly =				{ID = 25, Var = 920},
DoomFly = 				{ID = 25, Var = 960},
GBF = 					{ID = 25, Var = 961},
Warhead = 				{ID = 25, Var = 962},
Drainer = 				{ID = 25, Var = 963},

--Host variants
ReheatedHost1 =			{ID = 27, Var = 0, Sub = 710},
ReheatedHost2 =			{ID = 27, Var = 0, Sub = 711},
ReheatedHost3 =			{ID = 27, Var = 0, Sub = 712},

--Hopper variants
Tot = 					{ID = 29, Var = 960},
Spinneretch = 			{ID = 29, Var = 961},
SourpatchHead = 		{ID = 29, Var = 962, Sub = 0},
SourpatchHeadSeptic = 	{ID = 29, Var = 962, Sub = 1},
Gobhopper =				{ID = 29, Var = 1, Sub = 170},
Bombmuncher = 			{ID = 29, Var = 1, Sub = 5},

--Sack variants
StickySack = 			{ID = 30, Var = 960},

--Grimace variants
Wetstone = 				{ID = 42, Var = 960},
Cauldron = 				{ID = 42, Var = 961},
Furnace = 				{ID = 42, Var = 962},
SensoryGrimace = 		{ID = 42, Var = 963},
Casted =				{ID = 42, Var = 964},

--Poky variants (fake)
ArteryM = 				{ID = 44, Var = 960},
ArteryS = 				{ID = 44, Var = 961},
Graterhole = 			{ID = 44, Var = 980},
Vein = 					{ID = 44, Var = 962},
PipeSeptic = 			{ID = 44, Var = 1710},
PipeSewer = 			{ID = 44, Var = 1711},
PipeSludge = 			{ID = 44, Var = 1712},
PipeSphincter = 		{ID = 44, Var = 1713},
PipeSplit = 			{ID = 44, Var = 1714},
--Poky Variants (Tsar)
BigPipe = 				{ID = 44, Var = 1810},
BigGrate = 				{ID = 44, Var = 1820},

--Mom champ
FiendMom = 				{ID = 45, Var = 0, Sub = 96, IDx = Isaac.GetBossColorIdxByName("FF Fiendish Mom")},

--Para-Bite variants
HungryParabite = 		{ID = 58, Var = 960},

--Spit variants
Spitroast = 			{ID = 61, Var = 960},
Spitfire = 				{ID = 61, Var = 961},

--Pin variants
TechnoPin =				{ID = 62, Var = 0, IDx = Isaac.GetBossColorIdxByName("FF Technopin")},
DreadPin =				{ID = 62, Var = 0, Sub = 114},

--Duke variants
WineHusk =				{ID = 67, Var = 1, IDx = Isaac.GetBossColorIdxByName("FF Wine Husk")},

--Loki variants
AlienLokiChampion =		{ID = 69, Var = 0, IDx = Isaac.GetBossColorIdxByName("FF Alien Loki")},

--Lokii variants
AlienLokiiChampion =	{ID = 69, Var = 1, IDx = Isaac.GetBossColorIdxByName("FF Alien Lokii")},

--Fistula variants
BeehiveFistulaBig =		{ID = 71, Var = 0, IDx = Isaac.GetBossColorIdxByName("FF Beehive Fistula")},
BeehiveFistulaMedium =	{ID = 72, Var = 0, IDx = Isaac.GetBossColorIdxByName("FF Beehive Fistula")},
BeehiveFistulaSmall =	{ID = 73, Var = 0, IDx = Isaac.GetBossColorIdxByName("FF Beehive Fistula")},

--Teratoma variants
FuzzyTeratomaBig =		{ID = 71, Var = 1, IDx = Isaac.GetBossColorIdxByName("FF Fuzzy Teratoma")},
FuzzyTeratomaMedium =	{ID = 72, Var = 1, IDx = Isaac.GetBossColorIdxByName("FF Fuzzy Teratoma")},
FuzzyTeratomaSmall =	{ID = 73, Var = 1, IDx = Isaac.GetBossColorIdxByName("FF Fuzzy Teratoma")},
CornyTeratomaBig =		{ID = 71, Var = 1, IDx = Isaac.GetBossColorIdxByName("FF Corny Teratoma")},
CornyTeratomaMedium =	{ID = 72, Var = 1, IDx = Isaac.GetBossColorIdxByName("FF Corny Teratoma")},
CornyTeratomaSmall =	{ID = 73, Var = 1, IDx = Isaac.GetBossColorIdxByName("FF Corny Teratoma")},

--Blastocyst variants
MegaEmbryo =			{ID = 77, Var = Isaac.GetEntityVariantByName("Mega Embryo")},

--Steven variants
--AngrySteven =			{ID = 79, Var = 1, IDx = Isaac.GetBossColorIdxByName("FF Angry Steven")},
--AngryStevenBaby =		{ID = 79, Var = 11, IDx = Isaac.GetBossColorIdxByName("FF Angry Steven")},

--Blighted Ovum variants
RedBlightedOvum =		{ID = 79, Var = 2, IDx = Isaac.GetBossColorIdxByName("FF Red Blighted Ovum")},
RedBlightedOvumBaby =	{ID = 79, Var = 12, IDx = Isaac.GetBossColorIdxByName("FF Red Blighted Ovum")},
BlueBlightedOvum =		{ID = 79, Var = 2, IDx = Isaac.GetBossColorIdxByName("FF Blue Blighted Ovum")},
BlueBlightedOvumBaby =	{ID = 79, Var = 12, IDx = Isaac.GetBossColorIdxByName("FF Blue Blighted Ovum")},

--Krampus variants
GrinchKrampus =			{ID = 81, Var = 1, IDx = Isaac.GetBossColorIdxByName("FF Grinch Krampus")},

--Spider variants
Spooter = 				{ID = 85, Var = 960},
SuperSpooter = 			{ID = 85, Var = 961},
BabySpider = 			{ID = 85, Var = 962},
MegaSpooter = 			{ID = 85, Var = 963},
LitterBug = 			{ID = 85, Var = 964},
LitterBugToxic =		{ID = 85, Var = 965},
LitterBugCharmed =		{ID = 85, Var = 966},
LitterBugBruising =		{ID = 85, Var = 967},

--Gurgle variants
ReheatedGurgle =		{ID = 87, Var = 710},

--Walking sacks
WalkingStickySack = 	{ID = 88, Var = 960},
StumblingStickySack = 	{ID = 88, Var = 961},

--Mask of Infamy variants
YellowMaskOfInfamy =	{ID = 97, Var = 0, IDx = Isaac.GetBossColorIdxByName("FF Kidney of Infamy")},

--Heart of Infamy variants
KidneyOfInfamy =		{ID = 98, Var = 0, IDx = Isaac.GetBossColorIdxByName("FF Kidney of Infamy")},

--Widow variants
BabyWidowChampion = 	{ID = 100, Var = 0, IDx = Isaac.GetBossColorIdxByName("FF Albino Widow")},
RivalWidowChampion = 	{ID = 100, Var = 0, IDx = Isaac.GetBossColorIdxByName("FF Rival Widow")},

--Crazy long legs variants
Gutbuster = 			{ID = 207, Var = 960},
KrassBlaster = 			{ID = 207, Var = 961},

--Fatty variants
DankFatty = 			{ID = 208, Var = 960},
Squidge = 				{ID = 208, Var = 960},
Tubby = 				{ID = 208, Var = 961},
Mouthful = 				{ID = 208, Var = 962},
BigSmoke = 				{ID = 208, Var = 963},

--Lvl 2 flies
ReheatedIckyFly = 		{ID = 214, Var = 710},
ReheatedBobbyFly = 		{ID = 214, Var = 711},
ReheatedFly = 			{ID = 214, Var = 712},
ReheatedSackyFly = 		{ID = 214, Var = 713},
ReheatedChompyFly = 	{ID = 214, Var = 714},
ReheatedTickingFly = 	{ID = 214, Var = 715},

--Lvl 2 spiders
FullSpider = 			{ID = 215, Var = 710},
ReheatedBobbySpider = 	{ID = 215, Var = 711},
ReheatedSpider = 		{ID = 215, Var = 712},
ReheatedSackySpider = 	{ID = 215, Var = 713},
ReheatedIckySpider = 	{ID = 215, Var = 714},
ReheatedChompySpider = 	{ID = 215, Var = 715},

--Black Maw variants
BlackMawHapyHed = 		{ID = 225, Var = 66},

--Bonies
Crepitus = 				{ID = 227, Var = 666},
MrBones = 				{ID = 227, Var = 667},
Posssessed = 			{ID = 227, Var = 750},
HollowKnight = 			{ID = 227, Var = 960},
Powderkeg = 			{ID = 227, Var = 961},

--One tooth
Jawbone = 				{ID = 234, Var = 960},

--Gurgling variants
MushroomGurgling = 		{ID = EntityType.ENTITY_GURGLING, Var = 1, IDx = Isaac.GetBossColorIdxByName("FF Mushroom Gurgling")},

--Wall creeps
Fried = 				{ID = 240, Var = 700},
OgreCreep = 			{ID = 240, Var = 701},
ReheatedIckyCreep = 	{ID = 240, Var = 710},
ReheatedTechyCreep =	{ID = 240, Var = 711},

--Round Worms
BoneWorm =				{ID = 244, Var = 960},
BonerWorm =				{ID = 244, Var = 960, Sub = 10},
BoneWormWait =			{ID = 244, Var = 960, Sub = 95},

--Fat bats
BubbleBat =				{ID = 258, Var = 960},
Ribbone =				{ID = 258, Var = 961},

--Cage
LilCage =				{ID = 265, Var = 160},

--Cyclopias
ReheatedCyclopia =		{ID = 284, Var = 710},

--Movable TNT variants
SuperTNT =				{ID = 292, Var = 750},
WaterTNT =				{ID = 292, Var = 751},
CompostBin =			{ID = 292, Var = 752},
CompostBinButtery =		{ID = 292, Var = 752, Sub = 0},
CompostBinGassy =		{ID = 292, Var = 752, Sub = 1},
CompostBinScented =		{ID = 292, Var = 752, Sub = 2},
CompostBinUnstable =	{ID = 292, Var = 752, Sub = 3},

--Forsaken variants
RedForsaken = 			{ID = 403, Var = 0, IDx = Isaac.GetBossColorIdxByName("FF Red Forsaken")},

--Little Horn Champion
RedLittleHorn = 		{ID = 404, Var = 0, IDx = Isaac.GetBossColorIdxByName("FF Red Little Horn")},

--Rag Man Champion
RainbowRagMan = 		{ID = EntityType.ENTITY_RAG_MAN, Var = 0, IDx = Isaac.GetBossColorIdxByName("FF Rainbow Rag Man")},

--Rag Mega Champion
PinkRagMega = 			{ID = EntityType.ENTITY_RAG_MEGA, Var = 0, IDx = Isaac.GetBossColorIdxByName("FF Pink Rag Mega")},

--Sisters Vis Champion
BlackSisterVis = 		{ID = EntityType.ENTITY_SISTERS_VIS, Var = 0, IDx = Isaac.GetBossColorIdxByName("FF Black Sister Vis")},

--Rig Horn Champion
RedBigHorn = 			{ID = EntityType.ENTITY_BIG_HORN, Var = 0, IDx = Isaac.GetBossColorIdxByName("FF Red Big Horn")},

--Prey variants
Smogger =				{ID = 817, Var = 140},
Cushion =				{ID = 817, Var = 170},

--Clickety Clack
ClicketyClash = 		{ID = 889, Var = 750},

--Siren testing helper
SirenTester =			{ID = EntityType.ENTITY_SIREN, Var = 0, Sub = 960},

--Golden Plum Champion
GoldenPlum = 			{ID = 908, Var = 0, IDx = Isaac.GetBossColorIdxByName("FF Golden Plum")},

--Green Clutch Champion
GreenClutch = 			{ID = 921, Var = 0, IDx = Isaac.GetBossColorIdxByName("FF Clutch Green")},

--Vermin
Dangler =				{ID = FiendFolio.FFID.Vermin, Var = 0},

--Cake
Trashbagger = 			{ID = FiendFolio.FFID.Cake,  Var = 10},
TrashbaggerDank = 		{ID = FiendFolio.FFID.Cake,  Var = 10, Sub = 1},
Stomy = 				{ID = FiendFolio.FFID.Cake,  Var = 10, Sub = 2},
Pipeneck = 				{ID = FiendFolio.FFID.Cake,  Var = 11},
Cappin = 				{ID = FiendFolio.FFID.Cake,  Var = 12},
Shottie =  				{ID = FiendFolio.FFID.Cake,  Var = 13},
Shi =  					{ID = FiendFolio.FFID.Cake,  Var = 14},

--Minichibis
SoftServe = 			{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Soft Serve")},
Sundae = 				{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Sundae")},
Scoop = 				{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Scoop")},
Load = 					{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Load")},
CornLoad = 				{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Corn Load")},
Baro = 					{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Baro")},
Chorister = 			{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Chorister")},
Foamy = 				{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Foamy")},
Fathead = 				{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Fathead")},
Skuzz = 				{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Skuzz")},
Ransacked = 			{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Ransacked")},
Skuzzball = 			{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Skuzzball")},
SkuzzballSmall = 		{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Skuzzball (Small)")},
Boiler = 				{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Boiler")},
DrinkWorm = 			{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Drink Worm")},
DrunkWorm = 			{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Drunk Worm")},
Wobbles = 				{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Wobbles")},
SludgeHost = 			{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Sludge Host")},
Creepterum = 			{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Creepterum")},
Curdle = 				{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Curdle")},
CurdleNaked = 			{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Curdle (Naked)")},
Calzone = 				{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Calzone")},
Panini = 				{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Calzone"), Sub = 1},
Breadbin = 				{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Breadbin")},
Honeydrop = 			{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Honeydrop")},
Bella = 				{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Bella")},
Marge = 				{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Marge")},
Heiress = 				{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Heiress")},
Patzer = 				{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Patzer")},
PatzerShell = 			{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Patzer Shell")},
DopeHead = 			{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Dope's Head")},

--Julia enemy that just didn't get moved over
Congression = 			{ID = FiendFolio.FFID.Congression},
CongressionE = 			{ID = FiendFolio.FFID.Congression, Var = 0},
CongressionW = 			{ID = FiendFolio.FFID.Congression, Var = 1},

--Xalum
Banshee = 				{ID = 218, Var = 750},
Possessed = 			{ID = 227, Var = 750},
PossessedCorpse = 		{ID = FiendFolio.FFID.Xalum, Var = 10},
Moaner = 				{ID = FiendFolio.FFID.Xalum, Var = 20},
Unpawtunate = 			{ID = FiendFolio.FFID.Xalum, Var = 30},
UnpawtunateSkull = 		{ID = FiendFolio.FFID.Xalum, Var = 40},
MamaPooter = 			{ID = FiendFolio.FFID.Xalum, Var = 50},
Gravedigger = 			{ID = FiendFolio.FFID.Xalum, Var = 60},
Gravefire = 			{ID = FiendFolio.FFID.Xalum, Var = 70},
Sackboy = 				{ID = FiendFolio.FFID.Xalum, Var = 80},
Gnawful = 				{ID = FiendFolio.FFID.Xalum, Var = 90},
Ragurge = 				{ID = FiendFolio.FFID.Xalum, Var = 100},
Wick = 					{ID = FiendFolio.FFID.Xalum, Var = 110},
CustomCards = 			{ID = FiendFolio.FFID.Xalum, Var = 118},
GlassDice = 			{ID = FiendFolio.FFID.Xalum, Var = 119},
Cracker = 				{ID = FiendFolio.FFID.Xalum, Var = 140},
Nuchal = 				{ID = FiendFolio.FFID.Xalum, Var = 150},
NuchalDetached = 		{ID = FiendFolio.FFID.Xalum, Var = 151},
NuchalCord = 			{ID = FiendFolio.FFID.Xalum, Var = 152},
Ossularry = 			{ID = FiendFolio.FFID.Xalum, Var = 160},
RotspinCore = 			{ID = FiendFolio.FFID.Xalum, Var = 170},
RotspinMoon = 			{ID = FiendFolio.FFID.Xalum, Var = 171},
RotspinChain = 			{ID = 1000, Var = 1747},
Spoilie = 				{ID = FiendFolio.FFID.Xalum, Var = 172},
ConglobberateSmall =	{ID = FiendFolio.FFID.Xalum, Var = 180},
ConglobberateMedium =	{ID = FiendFolio.FFID.Xalum, Var = 181},
ConglobberateLarge =	{ID = FiendFolio.FFID.Xalum, Var = 182},
TomaChunk =				{ID = 310, Var = 1, Sub = 2302}, -- Very much just a Leper Flesh with extra gunk
Strobila = 				{ID = 41, Var = 750},
Globwad =				{ID = 208, Var = 750},
LonelyKnight =			{ID = FiendFolio.FFID.Xalum, Var = 190},
LonelyKnightBrain =		{ID = FiendFolio.FFID.Xalum, Var = 191},
LonelyKnightShell =		{ID = FiendFolio.FFID.Xalum, Var = 192},
CaveSpider = 			{ID = 215, Var = 2305},
Ripcord = 				{ID = FiendFolio.FFID.Xalum, Var = 200},
BeadFly = 				{ID = FiendFolio.FFID.Xalum, Var = 201},
BeadFlyChain = 			{ID = 1000, Var = 1980, Sub = 0},
RipcordRingGib =		{ID = 1000, Var = 1980, Sub = 1},
BeadFlyOutline = 		{ID = 1000, Var = 1980, Sub = 2},
Spoop =					{ID = FiendFolio.FFID.Xalum, Var = 210},
SpoopTrail =			{ID = 1000, Var = 1980, Sub = 10},
SpoopOutline =			{ID = 1000, Var = 1980, Sub = 11},
Croca = 				{ID = FiendFolio.FFID.Xalum, Var = 220},
Haemo =					{ID = FiendFolio.FFID.Xalum, Var = 230},
HaemoGlobin =			{ID = FiendFolio.FFID.Xalum, Var = 231},
Chops =					{ID = FiendFolio.FFID.Xalum, Var = 240},
ChopsRibProjectile = 	{ID = 9, Var = Isaac.GetEntityVariantByName("Chops Rib Projectile")},
Knot =					{ID = FiendFolio.FFID.Xalum, Var = 250},
SuperShottie =			{ID = FiendFolio.FFID.Xalum, Var = 280},
SuperShottieHook =		{ID = FiendFolio.FFID.Xalum, Var = 281},
HardlightAfterimage = 	{ID = FiendFolio.FFID.Xalum, Var = Isaac.GetEntityVariantByName("Hardlight Afterimage")},
Retcon =				{ID = FiendFolio.FFID.Xalum, Var = Isaac.GetEntityVariantByName("Retcon")},

-- Lurker Pieces
Lurker = 				{ID = FiendFolio.FFID.Xalum, Var = 260},
LurkerCore =			{ID = FiendFolio.FFID.Xalum, Var = 261},
LurkerTooth =			{ID = FiendFolio.FFID.Xalum, Var = 262},
LurkerStoma =			{ID = FiendFolio.FFID.Xalum, Var = 263},
LurkerStretch =			{ID = FiendFolio.FFID.Xalum, Var = 264},

-- Lurker Technical Entities
LurkerBrain = 			{ID = FiendFolio.FFID.Xalum, Var = 270},
LurkerCollider =		{ID = FiendFolio.FFID.Xalum, Var = 271},
LurkerStretchCollider =	{ID = FiendFolio.FFID.Xalum, Var = 272},
LurkerPsuedoDefault =	{ID = FiendFolio.FFID.Xalum, Var = 273},
LurkerBridgeProj =		{ID = FiendFolio.FFID.Xalum, Var = 274},
LurkerCord =			{ID = 1000, Var = 1980, Sub = 20},

-- Risk's Reward
PsionicPortal = 		{ID = 1000, Var = 1980, Sub = 30},
PortalCollectible =		{ID = 1000, Var = 1980, Sub = 31},

--Beah Technical
BeahInvisible =			{ID = 1000, Var = 2761, Sub = 0},
ItemPopup = 			{ID = 1000, Var = 2763, Sub = 0},

--Glitchcity
GlitchcityTile = 		{ID = 1000, Var = 2761, Sub = 3},
GlitchPoof =			{ID = 1000, Var = 2762, Sub = 2},

--Dis Item Indicator
DisWisp =				{ID = 1000, Var = 2762, Sub = 0},
--Ganymede Tear Explode
GanymedePoof =			{ID = 1000, Var = 2762, Sub = 1},
--YAAIIII Tear Popup
YAAIPopup =				{ID = 1000, Var = 2762, Sub = 3},
--Darkness arm vfx
DarknessPopup =			{ID = 1000, Var = 2762, Sub = 4},
--Cross neckalce
CrossNecklace =			{ID = 1000, Var = 2762, Sub = 5},
--Minesweeper tle
Minesweeper =			{ID = 1000, Var = 2762, Sub = 6},
--Kalu Slash
KaluSlash =				{ID = 1000, Var = 2762, Sub = 7},
--Magic Bullet
MagicBulletCircle =		{ID = 1000, Var = Isaac.GetEntityVariantByName("Magic Bullet Marker"), Sub = 0},
--Ice IX
IceIXBlast =			{ID = 1000, Var = Isaac.GetEntityVariantByName("Ice IX Blast"), Sub = 0},


-- Massive Amethyst
Amethyst =				{ID = 6, Var = Isaac.GetEntityVariantByName("Massive Amethyst Cluster")},
FloatingAmethyst =		{ID = 6, Var = Isaac.GetEntityVariantByName("Floating Massive Amethyst Cluster")},

-- Rockballs
RockBallMines =			{ID = 915, Var = 1, Sub = 744},
RockBallMinesLava =		{ID = 915, Var = 1, Sub = 752},
RockBallAshpit =		{ID = 915, Var = 1, Sub = 760},
RockBallAshpitLava =	{ID = 915, Var = 1, Sub = 768},
RockBallGold =			{ID = 915, Var = 1, Sub = 776},
RockBallTumbleweed =	{ID = 915, Var = 1, Sub = 784},
RockBallFootball =		{ID = 915, Var = 1, Sub = 792},

--Snakeblock
WombPillar = 			{ID = FiendFolio.FFID.Snake, Var = 110},
Watcher = 				{ID = FiendFolio.FFID.Snake, Var = 111},
WatcherEye = 			{ID = FiendFolio.FFID.Snake, Var = 112},
Mistmonger = 			{ID = FiendFolio.FFID.Snake, Var = 113},
Cordend = 				{ID = FiendFolio.FFID.Snake, Var = 114},
CordendHalf = 			{ID = FiendFolio.FFID.Snake, Var = 114, Sub = 1},
CordendCord = 			{ID = FiendFolio.FFID.Snake, Var = 114, Sub = 2},
Guflush = 				{ID = FiendFolio.FFID.Snake, Var = 115},
Rancor =				{ID = FiendFolio.FFID.Snake, Var = 116},
CancerBoy =				{ID = FiendFolio.FFID.Snake, Var = 117},
EyeOfShaggoth =			{ID = FiendFolio.FFID.Snake, Var = 118},
Amoeba =				{ID = FiendFolio.FFID.Snake, Var = 119},

--Oro stuff
Valvo = 				{ID = FiendFolio.FFID.Oro, Var = 0},
Sombra = 				{ID = FiendFolio.FFID.Oro, Var = 1},

--Taiga
Onlooker = 				{ID = FiendFolio.FFID.Taiga, Var = 222},
Punted = 				{ID = FiendFolio.FFID.Taiga, Var = 223},
Cuffs = 				{ID = FiendFolio.FFID.Taiga, Var = 224},
Empath = 				{ID = FiendFolio.FFID.Taiga, Var = 225},
ManicFly = 				{ID = FiendFolio.FFID.Taiga, Var = 226},
Warble = 				{ID = FiendFolio.FFID.Taiga, Var = 227},
WarbleTail = 			{ID = FiendFolio.FFID.Taiga, Var = 227, Sub = 10},
RiftWalker = 			{ID = FiendFolio.FFID.Taiga, Var = 228},
RiftWalkerGfx = 		{ID = FiendFolio.FFID.Taiga, Var = 228, Sub = 10},
Fishfreak = 			{ID = FiendFolio.FFID.Taiga, Var = 229},
FishfreakPile = 		{ID = FiendFolio.FFID.Taiga, Var = 229, Sub = 1},
King = 					{ID = FiendFolio.FFID.Taiga, Var = 230},
Pawn = 					{ID = FiendFolio.FFID.Taiga, Var = 231},
Foetus = 				{ID = FiendFolio.FFID.Taiga, Var = 232, Sub = 0},
FoetusBaby = 			{ID = FiendFolio.FFID.Taiga, Var = 232, Sub = 1},
FoetusCord = 			{ID = FiendFolio.FFID.Taiga, Var = 232, Sub = 10},
Anemone = 				{ID = FiendFolio.FFID.Taiga, Var = 233},
Oralopede = 			{ID = FiendFolio.FFID.Taiga, Var = 234},
Oralid = 				{ID = FiendFolio.FFID.Taiga, Var = 235},
Thrall = 				{ID = FiendFolio.FFID.Taiga, Var = 236},
ThrallCord = 			{ID = FiendFolio.FFID.Taiga, Var = 236, Sub = 1},
ClicketyChar = 			{ID = FiendFolio.FFID.Taiga, Var = 238},

--Sbody
Punisher = 				{ID = FiendFolio.FFID.Sbody, Var = 0},

--Dead
Magleech = 				{ID = FiendFolio.FFID.Dead, Var = 10},
Myiasis = 				{ID = FiendFolio.FFID.Dead, Var = 20},
MyiasisProj = 			{ID = FiendFolio.FFID.Dead, Var = 21},
Viscerspirit = 			{ID = FiendFolio.FFID.Dead, Var = 30},
Morvid =				{ID = FiendFolio.FFID.Dead, Var = 40},
MorvidPerched =			{ID = FiendFolio.FFID.Dead, Var = 40, Sub = 1},
Hooligan =				{ID = FiendFolio.FFID.Dead, Var = 50},
GlassEye = 				{ID = FiendFolio.FFID.Dead, Var = 60},
Tagbag = 				{ID = FiendFolio.FFID.Dead, Var = 70},
Sleeper =				{ID = FiendFolio.FFID.Dead, Var = 80}, -- sorry erf i stole your enemy,
NightTerrors = 			{ID = FiendFolio.FFID.Dead, Var = 81},

--Guwah
Zealot = 				{ID = FiendFolio.FFID.Guwah, Var = 0},
Skulltist = 			{ID = FiendFolio.FFID.Guwah, Var = 1},
RingLeader = 			{ID = FiendFolio.FFID.Guwah, Var = 2},
Cherub = 				{ID = FiendFolio.FFID.Guwah, Var = 3},
Glorf = 				{ID = FiendFolio.FFID.Guwah, Var = 4},
Thumper = 				{ID = FiendFolio.FFID.Guwah, Var = 5},
Nubert = 					{ID = FiendFolio.FFID.Guwah, Var = 5, Sub = 1},
Coconut = 				{ID = FiendFolio.FFID.Guwah, Var = 6},
Ashtray = 				{ID = FiendFolio.FFID.Guwah, Var = 7},
Clogmo = 				{ID = FiendFolio.FFID.Guwah, Var = 8},
Fishy = 				{ID = FiendFolio.FFID.Guwah, Var = 9},
Necrotic =					{ID = FiendFolio.FFID.Guwah, Var = 9, Sub = 1},
Fish =						{ID = FiendFolio.FFID.Guwah, Var = 9, Sub = 2},
Catfish =				{ID = FiendFolio.FFID.Guwah, Var = 10},
Squid =					{ID = FiendFolio.FFID.Guwah, Var = 11},
Bub =					{ID = FiendFolio.FFID.Guwah, Var = 12},
Shirk = 				{ID = FiendFolio.FFID.Guwah, Var = 13},
Roasty = 				{ID = FiendFolio.FFID.Guwah, Var = 14},
Lurch = 				{ID = FiendFolio.FFID.Guwah, Var = 15},
Rotdrink = 				{ID = FiendFolio.FFID.Guwah, Var = 16},
Rotskull = 					{ID = FiendFolio.FFID.Guwah, Var = 16, Sub = 1},
Kukodemon = 			{ID = FiendFolio.FFID.Guwah, Var = 17},
MazeRunner = 			{ID = FiendFolio.FFID.Guwah, Var = 18},
MazeRunnerRed = 			{ID = FiendFolio.FFID.Guwah, Var = 18, Sub = 1},
Bunkter = 				{ID = FiendFolio.FFID.Guwah, Var = 19},
Weeper = 				{ID = FiendFolio.FFID.Guwah, Var = 20},
ShockCollar = 			{ID = FiendFolio.FFID.Guwah, Var = 21},
Cathy = 				{ID = FiendFolio.FFID.Guwah, Var = 22},
ShotFly = 				{ID = FiendFolio.FFID.Guwah, Var = 23},
Shoter = 				{ID = FiendFolio.FFID.Guwah, Var = 24},
Nihilist = 				{ID = FiendFolio.FFID.Guwah, Var = 25},
MolarSystem = 			{ID = FiendFolio.FFID.Guwah, Var = 26},
Puffer = 				{ID = FiendFolio.FFID.Guwah, Var = 27},
Dolphin = 				{ID = FiendFolio.FFID.Guwah, Var = 28},
Madhat = 				{ID = FiendFolio.FFID.Guwah, Var = 29},
Grimoire = 				{ID = FiendFolio.FFID.Guwah, Var = 30},
Ztewie = 				{ID = FiendFolio.FFID.Guwah, Var = 31},
Marlin = 				{ID = FiendFolio.FFID.Guwah, Var = 32},
Tricko = 				{ID = FiendFolio.FFID.Guwah, Var = 33},
Dollop = 				{ID = FiendFolio.FFID.Guwah, Var = 34},
Apega = 				{ID = FiendFolio.FFID.Guwah, Var = 35},
Steralis = 				{ID = FiendFolio.FFID.Guwah, Var = 36},
Dogrock = 				{ID = FiendFolio.FFID.Guwah, Var = 37},
Mothman = 				{ID = FiendFolio.FFID.Guwah, Var = 38},
Quitter = 				{ID = FiendFolio.FFID.Guwah, Var = 39},
Rufus = 				{ID = FiendFolio.FFID.Guwah, Var = 40},
Toothache = 			{ID = FiendFolio.FFID.Guwah, Var = 41},
Aleya = 				{ID = FiendFolio.FFID.Guwah, Var = 42},
Chunky = 				{ID = FiendFolio.FFID.Guwah, Var = 43},
GrilledChunky = 			{ID = FiendFolio.FFID.Guwah, Var = 43, Sub = 1},
ButtFly = 				{ID = FiendFolio.FFID.Guwah, Var = 44},
Sponge = 				{ID = FiendFolio.FFID.Guwah, Var = 45},
Hermit = 				{ID = FiendFolio.FFID.Guwah, Var = 46},
DungeonMaster = 		{ID = FiendFolio.FFID.Guwah, Var = 1500},
Observer = 				{ID = FiendFolio.FFID.Guwah, Var = 1510},

Briar =					{ID = FiendFolio.FFID.Guwah2, Var = 0},
Grazer =				{ID = FiendFolio.FFID.Guwah2, Var = 10},
Plexus = 				{ID = FiendFolio.FFID.Guwah2, Var = 20},
Nervie =					{ID = FiendFolio.FFID.Guwah2, Var = 21},
NerviePoint = 				{ID = FiendFolio.FFID.Guwah2, Var = 22},
InfectedMushroom =		{ID = FiendFolio.FFID.Guwah2, Var = 30},
Coalby =				{ID = FiendFolio.FFID.Guwah2, Var = 40},
Coupile =					{ID = FiendFolio.FFID.Guwah2, Var = 41},
Cairn =						{ID = FiendFolio.FFID.Guwah2, Var = 42},
CoalscoopCoal =				{ID = FiendFolio.FFID.Guwah2, Var = 43},
Blare =					{ID = FiendFolio.FFID.Guwah2, Var = 50},
Potluck =				{ID = FiendFolio.FFID.Guwah2, Var = 60},
Casualty =				{ID = FiendFolio.FFID.Guwah2, Var = 70},
ShrunkenHead =			{ID = FiendFolio.FFID.Guwah2, Var = 80},
Premonition =			{ID = FiendFolio.FFID.Guwah2, Var = 81},
Apocalypse =			{ID = FiendFolio.FFID.Guwah2, Var = 82},
Dim =					{ID = FiendFolio.FFID.Guwah2, Var = 90},
DimGhost =					{ID = FiendFolio.FFID.Guwah2, Var = 91},
Trailblazer =			{ID = FiendFolio.FFID.Guwah2, Var = 100},
TrailblazerFlameSegment =	{ID = FiendFolio.FFID.Guwah2, Var = 100, Sub = 1},
Gamper =				{ID = FiendFolio.FFID.Guwah2, Var = 110},
GamperGuts =				{ID = FiendFolio.FFID.Guwah2, Var = 111},
Wailer =				{ID = FiendFolio.FFID.Guwah2, Var = 120},
Speleo =				{ID = FiendFolio.FFID.Guwah2, Var = 130},
Craig =					{ID = FiendFolio.FFID.Guwah2, Var = 140},
TaintedCraig =				{ID = FiendFolio.FFID.Guwah2, Var = 141},
Chili =					{ID = FiendFolio.FFID.Guwah2, Var = 150},
Litling =				{ID = FiendFolio.FFID.Guwah2, Var = 151},
Nailhead =				{ID = FiendFolio.FFID.Guwah2, Var = 160},
Vacuole =				{ID = FiendFolio.FFID.Guwah2, Var = 170},
FrayedNerve =			{ID = FiendFolio.FFID.Guwah2, Var = 180},
Contestant =			{ID = FiendFolio.FFID.Guwah2, Var = 190},
SkitterSkull =			{ID = FiendFolio.FFID.Guwah2, Var = 200},
Wasty =					{ID = FiendFolio.FFID.Guwah2, Var = 210},
Temptress =				{ID = FiendFolio.FFID.Guwah2, Var = 220},
Dumptruck =				{ID = FiendFolio.FFID.Guwah2, Var = 230},
PillarJohn =			{ID = FiendFolio.FFID.Guwah2, Var = 240},
LittleJohn =				{ID = FiendFolio.FFID.Guwah2, Var = 241},
PillarJohnQuake =			{ID = FiendFolio.FFID.Guwah2, Var = 242},
LittleJohnPoint =			{ID = FiendFolio.FFID.Guwah2, Var = 243},
Zephyr =				{ID = FiendFolio.FFID.Guwah2, Var = 250},
FlagpoleHead =			{ID = FiendFolio.FFID.Guwah2, Var = 260},
FlagpoleBody =				{ID = FiendFolio.FFID.Guwah2, Var = 261},
FireFly =				{ID = FiendFolio.FFID.Guwah2, Var = 270},
Clod =					{ID = FiendFolio.FFID.Guwah2, Var = 280},
AntiFiend =				{ID = FiendFolio.FFID.Guwah2, Var = 290},
Ghastly =				{ID = FiendFolio.FFID.Guwah2, Var = 300},
BellBoy =				{ID = FiendFolio.FFID.Guwah2, Var = 310},
Mirage =				{ID = FiendFolio.FFID.Guwah2, Var = 320},
MirageClone =				{ID = FiendFolio.FFID.Guwah2, Var = 320, Sub = 2},
Buddybag =				{ID = FiendFolio.FFID.Guwah2, Var = 330},
Suave =					{ID = FiendFolio.FFID.Guwah2, Var = 340},
Urbane =					{ID = FiendFolio.FFID.Guwah2, Var = 341},
Cheeky =				{ID = FiendFolio.FFID.Guwah2, Var = 350},
Rashy =					{ID = FiendFolio.FFID.Guwah2, Var = 351},
Kriegsheld =			{ID = FiendFolio.FFID.Guwah2, Var = 360},
Rosie =					{ID = FiendFolio.FFID.Guwah2, Var = 370},
AtomicGaper =			{ID = FiendFolio.FFID.Guwah2, Var = 380},
Soothsayer =			{ID = FiendFolio.FFID.Guwah2, Var = 390},
FalseIdol =				{ID = FiendFolio.FFID.Guwah2, Var = 400},

Drumstick =				{ID = EntityType.ENTITY_CLOTTY, Var = 450},
HolyDrumstick =			{ID = EntityType.ENTITY_CLOTTY, Var = 451},
Retch =					{ID = EntityType.ENTITY_MAGGOT, Var = 450},
Droolie =				{ID = EntityType.ENTITY_BOOMFLY, Var = 450},
Mightfly =				{ID = EntityType.ENTITY_BOOMFLY, Var = 451},
GoldenMightfly =		{ID = EntityType.ENTITY_BOOMFLY, Var = 452},
Posie =					{ID = EntityType.ENTITY_BOOMFLY, Var = 453},
Hostlet =				{ID = EntityType.ENTITY_HOST, Var = 0, Sub = 250},
RedHostlet =			{ID = EntityType.ENTITY_HOST, Var = 1, Sub = 251},
Imperialist =			{ID = EntityType.ENTITY_HOPPER, Var = 1, Sub = 450},
DrownedSpitty =			{ID = EntityType.ENTITY_SPITTY, Var = 450},
AleyaFirePlace =		{ID = EntityType.ENTITY_FIREPLACE, Var = 3, Sub = 4},
Mayfly = 				{ID = EntityType.ENTITY_SUCKER, Var = 450},
Hyperbole = 			{ID = EntityType.ENTITY_SUCKER, Var = 460},
Partyball = 			{ID = EntityType.ENTITY_SUCKER, Var = 470},
GutKnight = 			{ID = EntityType.ENTITY_KNIGHT, Var = 450},
Jammed =				{ID = EntityType.ENTITY_NEST, Var = 450},
RedJammed =				{ID = EntityType.ENTITY_NEST, Var = 450, Sub = 1},
Molargan =				{ID = EntityType.ENTITY_NEST, Var = 451},
Tommy =				    {ID = EntityType.ENTITY_BABY_LONG_LEGS, Var = 450},
Benny =				    {ID = EntityType.ENTITY_CRAZY_LONG_LEGS, Var = 450},
Cherubskull =			{ID = EntityType.ENTITY_DEATHS_HEAD, Var = 450},
Astroskull =			{ID = EntityType.ENTITY_DEATHS_HEAD, Var = 451},
RedBony =		    	{ID = EntityType.ENTITY_BONY, Var = 450},
ArcaneCreep =		    {ID = EntityType.ENTITY_WALL_CREEP, Var = 450},
ConjoinedCreep =		{ID = EntityType.ENTITY_WALL_CREEP, Var = 451},
CarveCreep =			{ID = EntityType.ENTITY_WALL_CREEP, Var = 452},
DrownedConjoinedSpitty ={ID = EntityType.ENTITY_CONJOINED_SPITTY, Var = 450},
Blubbie =				{ID = EntityType.ENTITY_DUKIE, Var = 450},
Skullshroom =			{ID = EntityType.ENTITY_MUSHROOM, Var = 450},
Molly = 				{ID = EntityType.ENTITY_LEPER, Var = 450},
GoldenFlyBomb = 		{ID = EntityType.ENTITY_FLY_BOMB, Var = 450},
Blasted = 				{ID = EntityType.ENTITY_MOLE, Var = 450},
BambooCutter = 			{ID = EntityType.ENTITY_WHIPPER, Var = 450},
Thresher = 				{ID = EntityType.ENTITY_WHIPPER, Var = 451},
FleshSistern = 			{ID = EntityType.ENTITY_FLESH_MAIDEN, Var = 450},
Techneedle = 			{ID = EntityType.ENTITY_NEEDLE, Var = 450},

IDPDGrunt =				{ID = FiendFolio.FFID.GuwahJoke, Var = 0},
IDPDInspector =			{ID = FiendFolio.FFID.GuwahJoke, Var = 1},
IDPDShielder =			{ID = FiendFolio.FFID.GuwahJoke, Var = 2},
IDPDGrenade =			{ID = FiendFolio.FFID.GuwahJoke, Var = 3},

TheTerribleOni =		{ID = FiendFolio.FFID.GuwahJoke, Var = 10},
HomonculusLoxodontus =	{ID = FiendFolio.FFID.GuwahJoke, Var = 20},

Trihorf =				{ID = EntityType.ENTITY_HORF, Var = 333},
ThumbsUpFly =  			{ID = EntityType.ENTITY_FLY, Var = 333},
TaintedSpit = 			{ID = EntityType.ENTITY_SUCKER, Var = 7, Sub = 333},
GoldenSpider = 			{ID = EntityType.ENTITY_SPIDER, Var = 333},
SlothsHead =			{ID = EntityType.ENTITY_BLACK_GLOBIN_HEAD, Var = 333},
FlyWHGALB =				{ID = EntityType.ENTITY_ARMYFLY, Var = FiendFolio.FFID.GuwahJoke},

ClogmoPipe =			{ID = 44, Var = 4000},
ClogmoTunnelHori =		{ID = 44, Var = 4001},
ClogmoTunnelVerti =		{ID = 44, Var = 4002},
LurchGuts = 			{ID = EntityType.ENTITY_EVIS, Var = 10, Sub = 450},
ZtewieCord = 			{ID = EntityType.ENTITY_EVIS, Var = 10, Sub = 451},

LemonMishapEnemy =		{ID = 1000, Var = EffectVariant.CREEP_YELLOW, Sub = 450},
ZealotCrosshair =		{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 0},
ZealotBeam = 			{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 1},
DungeonLock = 			{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 2},
LargeWaterRipple = 		{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 3},
SlimShadyNova = 		{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 4},
BunkterTrash = 			{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 5},
NihilistAura = 			{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 6},
GrimoireFlame = 		{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 7},
PaperGib = 				{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 8},
ShadowShield = 			{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 9},
DummyEffect = 			{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 10},
FlyingDrip = 			{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 11},
FlyingOralid = 			{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 12},
CherubskullChain = 		{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 13},
FlyingSpicyDip = 		{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 14},
ReverseBloodPoof = 		{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 15},
CustomTracer = 			{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 16},
ThumperPeg = 			{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 17},
BriarStingerPoof = 		{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 18},
InfectedGrowth = 		{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 19},
InfectedRing = 			{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 20},
TemporarySpikes = 		{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 21},
PigskinTarget = 		{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 22},
GamperChain = 			{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 23},
NailheadNail = 			{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 24},
TemptressHole =			{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 25},
ZephyrLightning =		{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 26},
AntiFiendWisp =			{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 27},
GhastlyClone =			{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 28},
BulbPlant =				{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 29},
PartyOrb =				{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 30},
DungeonMasterTarget =	{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 31},
CharacterControls =		{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 32},
FalseIdolAfterimage =	{ID = 1000, Var = FiendFolio.FFID.Guwah, Sub = 33},

IDPDPortal =			{ID = 1000, Var = FiendFolio.FFID.GuwahJoke, Sub = 0},
IDPDExplosion =			{ID = 1000, Var = FiendFolio.FFID.GuwahJoke, Sub = 1},
IDPDParticle =			{ID = 1000, Var = FiendFolio.FFID.GuwahJoke, Sub = 2},
IDPDSlugPoof =			{ID = 1000, Var = FiendFolio.FFID.GuwahJoke, Sub = 3},
IDPDGun =				{ID = 1000, Var = FiendFolio.FFID.GuwahJoke, Sub = 4},
IDPDCorpse =			{ID = 1000, Var = FiendFolio.FFID.GuwahJoke, Sub = 5},

FireworkRocket =		{ID = 2, Var = 932},

BriarThistle =			{ID = 9, Var = Isaac.GetEntityVariantByName("Briar Thistle Projectile")},
BriarStinger = 			{ID = 9, Var = Isaac.GetEntityVariantByName("Briar Stinger Projectile")},
FrogProjectile = 		{ID = 9, Var = Isaac.GetEntityVariantByName("Frog Projectile")},
FrogProjectileBlood = 	{ID = 9, Var = Isaac.GetEntityVariantByName("Frog Blood Projectile")},
BetterCoinProjectile = 	{ID = 9, Var = Isaac.GetEntityVariantByName("Better Coin Projectile")},
AntiFiendProjectile = 	{ID = 9, Var = Isaac.GetEntityVariantByName("Anti Fiend Fireball Projectile")},
IDPDProjectile = 		{ID = 9, Var = Isaac.GetEntityVariantByName("IDPD Projectile")},
IDPDSlugProjectile = 	{ID = 9, Var = Isaac.GetEntityVariantByName("IDPD Slug Projectile")},

NothingEffect = 		{ID = 1000, Var = Isaac.GetEntityVariantByName("Effect that is nothing")},

--JD
Volt =					{ID = FiendFolio.FFID.JD, Var = 30},
PepperStatue =			{ID = FiendFolio.FFID.JD, Var = 40},
Peon =					{ID = FiendFolio.FFID.JD, Var = 50},
Larrikin =				{ID = FiendFolio.FFID.JD, Var = 60},
FogStalker =			{ID = FiendFolio.FFID.JD, Var = 70},
Necorn =				{ID = FiendFolio.FFID.JD, Var = 80},

--Sunil
Tinkle = 				{ID = 61, Var = 700},
HorseFly = 				{ID = 61, Var = 701},

--Hippo
FlashMaiden = 			{ID = FiendFolio.FFID.Hippo, Var = 800},
Necornier = 			{ID = FiendFolio.FFID.Hippo, Var = 801},
HolyGlobin = 			{ID = FiendFolio.FFID.Hippo, Var = 802},
Paladin = 				{ID = FiendFolio.FFID.Hippo, Var = 806},
PaladinReg = 			{ID = FiendFolio.FFID.Hippo, Var = 806, Sub = 0},
PaladinWait = 			{ID = FiendFolio.FFID.Hippo, Var = 806, Sub = 1},

PaladinSlash = 			{ID = 1000, Var = 6430, Sub = 0},

--Blor
SplitEar =              {ID = FiendFolio.FFID.Blor, Var = 10},
EarSplitter =			{ID = FiendFolio.FFID.Blor, Var = 11},
EarSplitterBlade =		{ID = FiendFolio.FFID.Blor, Var = 12},

--Ferrium
Benign =				{ID = FiendFolio.FFID.Ferrium, Var = 0},
Dewdrop =				{ID = FiendFolio.FFID.Ferrium, Var = 1},
Connipshit = 			{ID = FiendFolio.FFID.Ferrium, Var = 2},
Tango =					{ID = FiendFolio.FFID.Ferrium, Var = 3},
Bellow =				{ID = FiendFolio.FFID.Ferrium, Var = 4},
Floodface =				{ID = FiendFolio.FFID.Ferrium, Var = 5},
Frowny = 				{ID = FiendFolio.FFID.Ferrium, Var = 6},
Psystalk =				{ID = FiendFolio.FFID.Ferrium, Var = 7},
Crucible =				{ID = FiendFolio.FFID.Ferrium, Var = 8},
Fount = 				{ID = FiendFolio.FFID.Ferrium, Var = 9},
Drillbit =				{ID = FiendFolio.FFID.Ferrium, Var = 10},
Minimoon =				{ID = FiendFolio.FFID.Ferrium, Var = 11},
Bladder =				{ID = FiendFolio.FFID.Ferrium, Var = 12},
Heartbeat =				{ID = FiendFolio.FFID.Ferrium, Var = 13},
Ignis =					{ID = FiendFolio.FFID.Ferrium, Var = 14},
Globlet =				{ID = FiendFolio.FFID.Ferrium, Var = 15},
Crotchety =				{ID = FiendFolio.FFID.Ferrium, Var = 16},
Gabber = 				{ID = FiendFolio.FFID.Ferrium, Var = 17},
Stalagnaught =			{ID = FiendFolio.FFID.Ferrium, Var = 18},
AntiGolem =				{ID = FiendFolio.FFID.Ferrium, Var = 19},
Torment =				{ID = FiendFolio.FFID.Ferrium, Var = 20},
Zissuru =				{ID = FiendFolio.FFID.Ferrium, Var = 21},
Wheezer =				{ID = FiendFolio.FFID.Ferrium, Var = 22},
Gritty =				{ID = FiendFolio.FFID.Ferrium, Var = 23},
Psyclopia =				{ID = FiendFolio.FFID.Ferrium, Var = 24},
Peepisser =				{ID = FiendFolio.FFID.Ferrium, Var = 25},
Brood =					{ID = FiendFolio.FFID.Ferrium, Var = 26},
Alderman = 				{ID = FiendFolio.FFID.Ferrium, Var = 27},
Unshornz =				{ID = FiendFolio.FFID.Ferrium, Var = 28},
DreadMaw =				{ID = FiendFolio.FFID.Ferrium, Var = 29},
--BlueMaw =				{ID = FiendFolio.FFID.Ferrium, Var = 30},
Specturn =				{ID = FiendFolio.FFID.Ferrium2, Var = 0},
Quaker =				{ID = FiendFolio.FFID.Ferrium, Var = 31},
Shaker =				{ID = FiendFolio.FFID.Ferrium, Var = 32},
Brisket =				{ID = FiendFolio.FFID.Ferrium, Var = 33},
Accursed =				{ID = FiendFolio.FFID.Ferrium, Var = 34},
Murmur =				{ID = FiendFolio.FFID.Ferrium, Var = 35},
Shellmet =				{ID = FiendFolio.FFID.Ferrium, Var = 36},
Nematode =				{ID = FiendFolio.FFID.Ferrium, Var = 37},
G_Host =				{ID = FiendFolio.FFID.Ferrium, Var = 38, Sub = 0},
G_HostSkull =			{ID = FiendFolio.FFID.Ferrium, Var = 38, Sub = 1},
Skullcap =				{ID = FiendFolio.FFID.Ferrium, Var = 39},
Chummer = 				{ID = FiendFolio.FFID.Ferrium, Var = 40},
Hangman =				{ID = FiendFolio.FFID.Ferrium, Var = 41},
Slimer =				{ID = FiendFolio.FFID.Ferrium, Var = 42},
Fracture =				{ID = FiendFolio.FFID.Ferrium, Var = 43},
CongaSkuzz =			{ID = FiendFolio.FFID.Ferrium, Var = 44},
RingSkuzz =				{ID = FiendFolio.FFID.Ferrium, Var = 45},
FlailerBody =			{ID = FiendFolio.FFID.Ferrium, Var = 46, Sub = 0},
FlailerHead =			{ID = FiendFolio.FFID.Ferrium, Var = 46, Sub = 1},
Mite = 					{ID = FiendFolio.FFID.Ferrium, Var = 47},
HolyWobbles = 			{ID = FiendFolio.FFID.Ferrium, Var = 48},
Firewhirl = 			{ID = FiendFolio.FFID.Ferrium, Var = 49},
Whale =					{ID = FiendFolio.FFID.Ferrium, Var = 50, Sub = 0},
WhaleGuts =				{ID = FiendFolio.FFID.Ferrium, Var = 50, Sub = 1},
WhaleCord =				{ID = EntityType.ENTITY_EVIS, Var = 10, Sub = 114},
Clam =					{ID = FiendFolio.FFID.Ferrium, Var = 51},
Lunksack =				{ID = FiendFolio.FFID.Ferrium, Var = 52},
Coloscope =				{ID = FiendFolio.FFID.Ferrium, Var = 53},
Putrefatty =			{ID = FiendFolio.FFID.Ferrium, Var = 54},
Musk = 					{ID = FiendFolio.FFID.Ferrium, Var = 55},
Spanky =				{ID = FiendFolio.FFID.Ferrium, Var = 56},
Spiroll =				{ID = FiendFolio.FFID.Ferrium, Var = 57},
Thwammy =				{ID = FiendFolio.FFID.Ferrium, Var = 58},
Acolyte =				{ID = FiendFolio.FFID.Ferrium, Var = 59},
Edema =					{ID = FiendFolio.FFID.Ferrium2, Var = 130},
Redema =				{ID = FiendFolio.FFID.Ferrium2, Var = 140},
ForgottenFetus =		{ID = FiendFolio.FFID.Ferrium, Var = 62},
LilAl =					{ID = FiendFolio.FFID.Ferrium, Var = 63},
ForgottenFetusCord =	{ID = EntityType.ENTITY_EVIS, Var = 10, Sub = 115},
ForgottenFetusHitbox =	{ID = FiendFolio.FFID.Ferrium, Var = 64},
Anode =					{ID = FiendFolio.FFID.Ferrium, Var = 65},
Chorus =				{ID = FiendFolio.FFID.Ferrium, Var = 66},
Laideronnette = 		{ID = FiendFolio.FFID.Ferrium, Var = 67},
Cubert =				{ID = FiendFolio.FFID.Ferrium, Var = 68},
BadBag =				{ID = FiendFolio.FFID.Ferrium, Var = 69},
TheColorRed =			{ID = FiendFolio.FFID.Ferrium, Var = 70},
Jugular =				{ID = FiendFolio.FFID.Ferrium, Var = 75},
Puffball =				{ID = FiendFolio.FFID.Ferrium, Var = 76},
Cochlea =				{ID = FiendFolio.FFID.Ferrium, Var = 77},
Shader =				{ID = FiendFolio.FFID.Ferrium, Var = 78},
Toad =					{ID = FiendFolio.FFID.Ferrium, Var = 79},
Devourer =				{ID = FiendFolio.FFID.Ferrium, Var = 80},
Indulger =				{ID = FiendFolio.FFID.Ferrium, Var = 81},
Ruiner =				{ID = FiendFolio.FFID.Ferrium, Var = 82},
Calsiketic =			{ID = FiendFolio.FFID.Ferrium, Var = 83},
LevelPooFly =			{ID = FiendFolio.FFID.Ferrium, Var = 84},
Bloomer =				{ID = FiendFolio.FFID.Ferrium, Var = 85},
BloomerCord =			{ID = EntityType.ENTITY_EVIS, Var = 10, Sub = 116},
SweetRedVine = 			{ID = EntityType.ENTITY_EVIS, Var = 10, Sub = 117},
Excluder =				{ID = FiendFolio.FFID.Ferrium, Var = 86},
FishingLine = 			{ID = EntityType.ENTITY_EVIS, Var = 10, Sub = 118},
Fogspawn =				{ID = FiendFolio.FFID.Ferrium, Var = 87},
Writhe =				{ID = FiendFolio.FFID.Ferrium, Var = 88},
Meatsack =				{ID = FiendFolio.FFID.Ferrium, Var = 89},
Soulmate =				{ID = FiendFolio.FFID.Ferrium, Var = 90},
Soulmite =				{ID = FiendFolio.FFID.Ferrium, Var = 91},
Rabbit =				{ID = FiendFolio.FFID.Ferrium, Var = 92},
FreeThinker =			{ID = FiendFolio.FFID.Ferrium, Var = 93},
FreeThinkerMask =		{ID = FiendFolio.FFID.Ferrium, Var = 93, Sub = 1},
StrandLine = 			{ID = EntityType.ENTITY_EVIS, Var = 10, Sub = 119},
Compass =				{ID = FiendFolio.FFID.Ferrium, Var = 94},

ScowlCreep =			{ID = EntityType.ENTITY_WALL_CREEP, Var = FiendFolio.FFID.Ferrium},
Cellulitis =			{ID = EntityType.ENTITY_MEMBRAIN, Var = FiendFolio.FFID.Ferrium},
Floaty =				{ID = EntityType.ENTITY_SUB_HORF, Var = 0, Sub = FiendFolio.FFID.Ferrium},
PsychoKnight = 			{ID = EntityType.ENTITY_KNIGHT, Var = FiendFolio.FFID.Ferrium},
SeaCucumber =			{ID = EntityType.ENTITY_MAGGOT, Var = FiendFolio.FFID.Ferrium},
ScopeCreep =			{ID = EntityType.ENTITY_WALL_CREEP, Var = FiendFolio.FFID.Ferrium+1},
Grievance =				{ID = EntityType.ENTITY_GRUDGE, Var = FiendFolio.FFID.Ferrium},
Alfil =					{ID = EntityType.ENTITY_MAGGOT, Var = FiendFolio.FFID.Ferrium+1},
ShineSpit =				{ID = EntityType.ENTITY_SUCKER, Var = FiendFolio.FFID.Ferrium},
Stiffany =				{ID = EntityType.ENTITY_MAGGOT, Var = FiendFolio.FFID.Ferrium+2},
SoulSpooter =			{ID = EntityType.ENTITY_SPIDER_L2, Var = FiendFolio.FFID.Ferrium},
Hazy =		    		{ID = EntityType.ENTITY_BONY, Var = FiendFolio.FFID.Ferrium},

Mouse =					{ID = FiendFolio.FFID.Ferrium, Var = 1000},
Murasa =				{ID = FiendFolio.FFID.Ferrium, Var = 1001},
MurasaAnchor =			{ID = FiendFolio.FFID.Ferrium, Var = 1002},
K3Miku =				{ID = FiendFolio.FFID.Ferrium, Var = 1003},
FerrWaiting =			{ID = FiendFolio.FFID.Ferrium, Var = 1004},
PeeBucket = 			{ID = FiendFolio.FFID.Ferrium, Var = 1005},
BuriedFossilCrack =		{ID = FiendFolio.FFID.Ferrium, Var = 1006, Sub = 0},
ChummerPathfinder = 	{ID = FiendFolio.FFID.Ferrium, Var = 1007},
ShadyHost = 			{ID = FiendFolio.FFID.Ferrium, Var = 1008},
MawMr =					{ID = FiendFolio.FFID.Ferrium, Var = 1009, Sub = 0},
MawMrBody =				{ID = FiendFolio.FFID.Ferrium, Var = 1009, Sub = 1},
MrPsychicMaw =			{ID = FiendFolio.FFID.Ferrium, Var = 1010, Sub = 0},
MrPsychicMawHead =		{ID = FiendFolio.FFID.Ferrium, Var = 1010, Sub = 1},
PsychicGusher =			{ID = FiendFolio.FFID.Ferrium, Var = 1010, Sub = 2},
Kablammer =				{ID = FiendFolio.FFID.Ferrium, Var = 1011},
BendyPeashooter =		{ID = FiendFolio.FFID.Ferrium, Var = 1012},

TangoAfterimage =       {ID = 1000, Var = 1750, Sub = 0},
TangoAfterimage2 =		{ID = 1000, Var = 1750, Sub = 1},
MurasaAnchorTrail = 	{ID = 1000, Var = 1750, Sub = 2},
MurasaEffects =			{ID = 1000, Var = 1750, Sub = 3},
PissDroplets =			{ID = 1000, Var = 1750, Sub = 4},
RoseQuartzShield =		{ID = 1000, Var = 1750, Sub = 5},
SaltLampAura =			{ID = 1000, Var = 1750, Sub = 6},
FocusCrystalRing =		{ID = 1000, Var = 1750, Sub = 7},
FocusCrystalPoof =		{ID = 1000, Var = 1750, Sub = 8},
MaxFossilGhost =        {ID = 1000, Var = 1750, Sub = 9},
ChaosCardLeftover =		{ID = 1000, Var = 1750, Sub = 10},
WarpZoneParticle =      {ID = 1000, Var = 1750, Sub = 11},
CharmHearts =			{ID = 1000, Var = 1750, Sub = 12},
GuardedGarnetShield =	{ID = 1000, Var = 1750, Sub = 13},
ShadowlessRock =		{ID = 9, Var = 9, Sub = FiendFolio.FFID.Ferrium},
ShadowlessRockShadow =	{ID = 1000, Var = 1750, Sub = 14},
ShadowlessGridProjectile = {ID = 9, Var = 8, Sub = FiendFolio.FFID.Ferrium},
SilentBloodProj =		{ID = 9, Var = 8, Sub = FiendFolio.FFID.Ferrium+1},
SilentRockProj =		{ID = 9, Var = 8, Sub = FiendFolio.FFID.Ferrium+2},
AstropulvisGhost = 		{ID = 1000, Var = 1750, Sub = 15},
HolyWobblesBeam = 		{ID = 1000, Var = 1750, Sub = 16},
LunksackNeedle = 		{ID = 1000, Var = 1750, Sub = 17},
AnodeBeam =				{ID = 1000, Var = 175, Sub = 115},
ChorusAfterimage =		{ID = 1000, Var = 1750, Sub = 18},
MoonbeamTarget = 		{ID = 1000, Var = 1750, Sub = 19},
MoonbeamLight = 		{ID = 1000, Var = 1750, Sub = 20},
WomanIndicator =		{ID = 1000, Var = 1750, Sub = 21},
GenericAfterimage = 	{ID = 1000, Var = 1750, Sub = 22},
TheColorRedSplash =		{ID = 1000, Var = 1750, Sub = 23},
BloodthirstyBlade =		{ID = 1000, Var = 1750, Sub = 24},
WhiteTrailEffect =		{ID = 1000, Var = 1750, Sub = 25},
MalachiteFlash =		{ID = 1000, Var = 1750, Sub = 26},
ChaoticCarving =		{ID = 1000, Var = 1750, Sub = 27},
CerberusOrbExplosion =	{ID = 1000, Var = 1750, Sub = 28},
StrandSack =			{ID = 1000, Var = 1750, Sub = 29},
BulletHellTarget =		{ID = 1000, Var = 1750, Sub = 30},
QueensFruitHandler =	{ID = 1000, Var = 1750, Sub = 31},
QueensFruitSplash =		{ID = 1000, Var = 1750, Sub = 32},
DarkBargainFakeItem =	{ID = 1000, Var = 1750, Sub = 33},
InfuserTiles =			{ID = 1000, Var = 1750, Sub = 34},
GooglyEyesEffect =		{ID = 1000, Var = 1750, Sub = 35},
RaildriverCrack =		{ID = 1000, Var = 1750, Sub = 36},
SweetRedDirt =			{ID = 1000, Var = 1750, Sub = 37},
ToadFearWisps =			{ID = 1000, Var = 1750, Sub = 38},

FogspawnCloud =			{ID = 1000, Var = 1762},
FogspawnCloudPersistent={ID = 1000, Var = 1763},

CherryBomb = 			{ID = 4, Var = FiendFolio.FFID.Ferrium},

--Guill
HoneyEye = 				{ID = FiendFolio.FFID.Guill, Var = 0},

-- Connor
HoneyFox = 				{ID = FiendFolio.FFID.Connor, Var = Isaac.GetEntityVariantByName("HoneyFox")},
HoneyFoxWorm = 			{ID = FiendFolio.FFID.Connor, Var = Isaac.GetEntityVariantByName("HoneyFox (Worm)")},
Beacon = 				{ID = FiendFolio.FFID.Connor, Var = Isaac.GetEntityVariantByName("Beacon")},
NewYear = 				{ID = FiendFolio.FFID.Connor, Var = Isaac.GetEntityVariantByName("New Year")},
Kawasaki = 				{ID = FiendFolio.FFID.Connor, Var = Isaac.GetEntityVariantByName("Kawasaki")},
LittleBoy = 			{ID = Isaac.GetEntityTypeByName("Little Boy"), Var = Isaac.GetEntityVariantByName("Little Boy")},
ManAtArms = 			{ID = Isaac.GetEntityTypeByName("Man-at-Arms"), Var = Isaac.GetEntityVariantByName("Man-at-Arms")},
ManAtArmsChain = 		{ID = Isaac.GetEntityTypeByName("Man-at-Arms Chain"), Var = Isaac.GetEntityVariantByName("Man-at-Arms Chain")},
ManAtArmsBall = 		{ID = Isaac.GetEntityTypeByName("Man-at-Arms Ball"), Var = Isaac.GetEntityVariantByName("Man-at-Arms Ball")},
Beetle =				{ID = FiendFolio.FFID.Connor, Var = Isaac.GetEntityVariantByName("Beetle (FF)")},
Brandon =				{ID = FiendFolio.FFID.Connor, Var = Isaac.GetEntityVariantByName("Brandon")},
FosterFly =				{ID = Isaac.GetEntityTypeByName("Foster Fly"), Var = Isaac.GetEntityVariantByName("Foster Fly"), Sub = FiendFolio.FFID.Connor},
Desolator =				{ID = FiendFolio.FFID.Connor, Var = Isaac.GetEntityVariantByName("Desolator")},
Elephant =				{ID = FiendFolio.FFID.Connor, Var = Isaac.GetEntityVariantByName("Elephant")},
ElephantJr =			{ID = FiendFolio.FFID.Connor, Var = Isaac.GetEntityVariantByName("Elephant Jr")},
UraniumSpider =			{ID = EntityType.ENTITY_ROCK_SPIDER, Var = 0, Sub = FiendFolio.FFID.Connor},
FlamingUraniumSpider =	{ID = EntityType.ENTITY_ROCK_SPIDER, Var = 2, Sub = FiendFolio.FFID.Connor},
UraniumChunk =			{ID = FiendFolio.FFID.Connor, Var = Isaac.GetEntityVariantByName("Uranium Chunk")},
Flux =					{ID = FiendFolio.FFID.Connor, Var = Isaac.GetEntityVariantByName("Flux")},
RadioactiveFireJet =	{ID = EntityType.ENTITY_EFFECT, Var = Isaac.GetEntityVariantByName("Radioactive Fire Jet"), Sub = FiendFolio.FFID.Connor},
RadioactiveFireWave =	{ID = EntityType.ENTITY_EFFECT, Var = Isaac.GetEntityVariantByName("Radioactive Fire Wave"), Sub = FiendFolio.FFID.Connor},
HalfLifeHead =			{ID = EntityType.ENTITY_DEATHS_HEAD, Var = FiendFolio.FFID.Connor},
MeltdownsHead =			{ID = EntityType.ENTITY_DEATHS_HEAD, Var = 4, Sub = FiendFolio.FFID.Connor},
MeltdownsHead2 =		{ID = EntityType.ENTITY_DEATHS_HEAD, Var = 4, Sub = FiendFolio.FFID.Connor+1},
NyxBladeRift =			{ID = 1000, Var = Isaac.GetEntityVariantByName("Nyx Blade Rift")},
GaperInAJarProjectile =	{ID = EntityType.ENTITY_PROJECTILE, Var = Isaac.GetEntityVariantByName("Gaper in a Jar Projectile")},

--Technical
TarBubble = 			{ID = FiendFolio.FFID.Tech, Var = 0, Sub = 0},
SpiderEgg = 			{ID = FiendFolio.FFID.Tech, Var = 0, Sub = 1},
Bubble = 				{ID = FiendFolio.FFID.Tech, Var = 1},
BubbleTiny = 			{ID = FiendFolio.FFID.Tech, Var = 1, Sub = 0},
BubbleSmall = 			{ID = FiendFolio.FFID.Tech, Var = 1, Sub = 1},
BubbleMed = 			{ID = FiendFolio.FFID.Tech, Var = 1, Sub = 2},
BubbleLarge = 			{ID = FiendFolio.FFID.Tech, Var = 1, Sub = 3},
BubbleFly = 			{ID = FiendFolio.FFID.Tech, Var = 1, Sub = 4},
BubbleSpider = 			{ID = FiendFolio.FFID.Tech, Var = 1, Sub = 5},
BubbleExplosive = 		{ID = FiendFolio.FFID.Tech, Var = 1, Sub = 6},
BubbleWaterySmall = 	{ID = FiendFolio.FFID.Tech, Var = 1, Sub = 7},
BubbleWateryMed = 		{ID = FiendFolio.FFID.Tech, Var = 1, Sub = 8},
BubbleWateryLarge = 	{ID = FiendFolio.FFID.Tech, Var = 1, Sub = 9},
BubbleLeper = 			{ID = FiendFolio.FFID.Tech, Var = 1, Sub = 12},
BubbleLargeLeper = 		{ID = FiendFolio.FFID.Tech, Var = 1, Sub = 14},
BubbleStream = 			{ID = FiendFolio.FFID.Tech, Var = 1, Sub = 13},
BubbleBloodyStream = 	{ID = FiendFolio.FFID.Tech, Var = 1, Sub = 15},
BubbleProvidence = 		{ID = FiendFolio.FFID.Tech, Var = 1, Sub = 16},
BubbleBrimstone = 		{ID = FiendFolio.FFID.Tech, Var = 1, Sub = 17},
FlyBundle = 			{ID = FiendFolio.FFID.Tech, Var = 2},
FlyBundleSwarm = 		{ID = FiendFolio.FFID.Tech, Var = 2, Sub = 0},
FlyBundleRing = 		{ID = FiendFolio.FFID.Tech, Var = 2, Sub = 1},
NimbusCloud = 			{ID = FiendFolio.FFID.Tech, Var = 3},
JawboneCorpse = 		{ID = FiendFolio.FFID.Tech, Var = 4},
BoneRocket = 			{ID = FiendFolio.FFID.Tech, Var = 5},
StingerProj = 			{ID = FiendFolio.FFID.Tech, Var = 6},
StingerProjHoming =		{ID = FiendFolio.FFID.Tech, Var = 6, Sub = 1},
StingerProjBeebee =		{ID = FiendFolio.FFID.Tech, Var = 6, Sub = 2},
SporeProjectile = 		{ID = FiendFolio.FFID.Tech, Var = 7},
NerveCluster = 			{ID = FiendFolio.FFID.Tech, Var = 8},
FlyingMaggot = 			{ID = FiendFolio.FFID.Tech, Var = 9},
FlyingMaggotNormal = 	{ID = FiendFolio.FFID.Tech, Var = 9, Sub = 0},
FlyingMaggotCharger = 	{ID = FiendFolio.FFID.Tech, Var = 9, Sub = 1},
FlyingMaggotSpity = 	{ID = FiendFolio.FFID.Tech, Var = 9, Sub = 2},
FlyingMaggotCreepy = 	{ID = FiendFolio.FFID.Tech, Var = 9, Sub = 3},
FlyingMaggotDank = 		{ID = FiendFolio.FFID.Tech, Var = 9, Sub = 4},
WaitingSpider = 		{ID = FiendFolio.FFID.Tech, Var = 10},
WaitingSpiderTicking = 	{ID = FiendFolio.FFID.Tech, Var = 10, Sub = 1},
WaitingSpiderBLL = 		{ID = FiendFolio.FFID.Tech, Var = 10, Sub = 2},
WaitingSpiderSBLL = 	{ID = FiendFolio.FFID.Tech, Var = 10, Sub = 3},
WaitingSpiderCLL = 		{ID = FiendFolio.FFID.Tech, Var = 10, Sub = 4},
WaitingSpiderSCLL = 	{ID = FiendFolio.FFID.Tech, Var = 10, Sub = 5},
WaitingSpiderFull = 	{ID = FiendFolio.FFID.Tech, Var = 10, Sub = 6},
WaitingDemon = 			{ID = FiendFolio.FFID.Tech, Var = 10}, --Yeah I'm lazy
WaitingDemonNull = 		{ID = FiendFolio.FFID.Tech, Var = 10, Sub = 7},
WaitingDemonBK =		{ID = FiendFolio.FFID.Tech, Var = 10, Sub = 8},
WaitingDemonBG = 		{ID = FiendFolio.FFID.Tech, Var = 10, Sub = 9},
WaitingDemonDoomer = 	{ID = FiendFolio.FFID.Tech, Var = 10, Sub = 10},
WaitingDemonLoki = 		{ID = FiendFolio.FFID.Tech, Var = 10, Sub = 11},
WaitingDemonImp = 		{ID = FiendFolio.FFID.Tech, Var = 10, Sub = 12},
WaitingDemonSpooter = 	{ID = FiendFolio.FFID.Tech, Var = 10, Sub = 13},
WaitingDemonTiyanak = 	{ID = FiendFolio.FFID.Tech, Var = 10, Sub = 14},
RiderScythe = 			{ID = FiendFolio.FFID.Tech, Var = 11},
RollingHollowKnight = 	{ID = FiendFolio.FFID.Tech, Var = 12},
WardenStar = 			{ID = FiendFolio.FFID.Tech, Var = 13},
WardenStarAbs = 		{ID = FiendFolio.FFID.Tech, Var = 13, Sub = 0},
TechnicianProj = 		{ID = FiendFolio.FFID.Tech, Var = 13, Sub = 10},
OwlStar = 				{ID = FiendFolio.FFID.Tech, Var = 13, Sub = 20},
Gary = 					{ID = FiendFolio.FFID.Tech, Var = 14},
GarySpecial = 			{ID = FiendFolio.FFID.Tech, Var = 14, Sub = 1716},
FloatingSpore = 		{ID = FiendFolio.FFID.Tech, Var = 15},
WaitingWorm = 			{ID = FiendFolio.FFID.Tech, Var = 16},
WaitingWormRound = 		{ID = FiendFolio.FFID.Tech, Var = 16, Sub = 1},
WaitingWormNightcrawl = {ID = FiendFolio.FFID.Tech, Var = 16, Sub = 2},
WaitingWormUlcer = 		{ID = FiendFolio.FFID.Tech, Var = 16, Sub = 3},
WaitingWormRoundy = 	{ID = FiendFolio.FFID.Tech, Var = 16, Sub = 4},
WaitingWormTube = 		{ID = FiendFolio.FFID.Tech, Var = 16, Sub = 5},
WaitingWormParabite = 	{ID = FiendFolio.FFID.Tech, Var = 16, Sub = 6},
WaitingWormSParabite = 	{ID = FiendFolio.FFID.Tech, Var = 16, Sub = 7},
WaitingWormBone = 		{ID = FiendFolio.FFID.Tech, Var = 16, Sub = 8},
WaitingWormDrink = 		{ID = FiendFolio.FFID.Tech, Var = 16, Sub = 9},
WaitingWormLump = 		{ID = FiendFolio.FFID.Tech, Var = 16, Sub = 10},
WaitingWormFred = 		{ID = FiendFolio.FFID.Tech, Var = 16, Sub = 11},
WaitingWormWeaver = 	{ID = FiendFolio.FFID.Tech, Var = 16, Sub = 12},
WaitingWormWeaverSR = 	{ID = FiendFolio.FFID.Tech, Var = 16, Sub = 13},
WaitingWormPin = 		{ID = FiendFolio.FFID.Tech, Var = 16, Sub = 14},
WaitingWormScolex = 	{ID = FiendFolio.FFID.Tech, Var = 16, Sub = 15},
WaitingWormFrail = 		{ID = FiendFolio.FFID.Tech, Var = 16, Sub = 16},
WaitingWormKingpin = 	{ID = FiendFolio.FFID.Tech, Var = 16, Sub = 17},
WaitingWormBunker = 	{ID = FiendFolio.FFID.Tech, Var = 16, Sub = 18},
WaitingWormDrunk = 		{ID = FiendFolio.FFID.Tech, Var = 16, Sub = 19},
MegaHemo = 				{ID = FiendFolio.FFID.Tech, Var = 17},
ThrownHorse = 			{ID = FiendFolio.FFID.Tech, Var = 18},
BoneCross = 			{ID = FiendFolio.FFID.Tech, Var = 19},
ChainBall = 			{ID = FiendFolio.FFID.Tech, Var = 20},
SternumRib = 			{ID = FiendFolio.FFID.Tech, Var = 21},
KeyProjectile = 		{ID = 9, Var = Isaac.GetEntityVariantByName("Key Projectile")},
PsyEg = 				{ID = FiendFolio.FFID.Tech, Var = 23},
AmnioticSac = 			{ID = FiendFolio.FFID.Tech, Var = 24},
AmnioticSacEmmpty = 	{ID = FiendFolio.FFID.Tech, Var = 24, Sub = 0},
AmnioticSacRandom = 	{ID = FiendFolio.FFID.Tech, Var = 24, Sub = 1},
AmnioticSacNeonate = 	{ID = FiendFolio.FFID.Tech, Var = 24, Sub = 2},
AmnioticSacBaby = 		{ID = FiendFolio.FFID.Tech, Var = 24, Sub = 3},
AmnioticSacEmbryo = 	{ID = FiendFolio.FFID.Tech, Var = 24, Sub = 4},
DavyCrockett = 			{ID = FiendFolio.FFID.Tech, Var = 25},
NuclearWaste = 			{ID = FiendFolio.FFID.Tech, Var = 26},
SpiderProj = 			{ID = FiendFolio.FFID.Tech, Var = 27},
QuackMine = 			{ID = FiendFolio.FFID.Tech, Var = 28},
SkullShot = 			{ID = FiendFolio.FFID.Tech, Var = 29},
Miscarriage = 			{ID = FiendFolio.FFID.Tech, Var = 30},
DangerousDisc = 		{ID = FiendFolio.FFID.Tech, Var = 31},
DangerousDiscGuide = 	{ID = FiendFolio.FFID.Tech, Var = 32},
DebuffProjectile = 		{ID = 9, Var = Isaac.GetEntityVariantByName("Debuff Projectile")},
DebuffProjectileConf = 	{ID = 9, Var = Isaac.GetEntityVariantByName("Debuff Projectile"), Sub = 1},
DebuffProjectileDark = 	{ID = 9, Var = Isaac.GetEntityVariantByName("Debuff Projectile"), Sub = 2},
DebuffProjectileFear = 	{ID = 9, Var = Isaac.GetEntityVariantByName("Debuff Projectile"), Sub = 3},
DebuffProjectileSlow = 	{ID = 9, Var = Isaac.GetEntityVariantByName("Debuff Projectile"), Sub = 4},
HitcherPitchfork = 		{ID = FiendFolio.FFID.Tech, Var = 35},
Hitbox = 				{ID = FiendFolio.FFID.Tech, Var = 36},
MemberCardRelocator =	{ID = FiendFolio.FFID.Tech, Var = 37},
FriendFireball =		{ID = FiendFolio.FFID.Tech, Var = 38, Sub = 0},
HunkOfGunk =			{ID = FiendFolio.FFID.Tech, Var = 39},
DriedPaintMonster =		{ID = FiendFolio.FFID.Tech, Var = 40},
DelugeHelper =			{ID = FiendFolio.FFID.Tech, Var = 41},
CurseOfTheGateKeySpawner = 		{ID = FiendFolio.FFID.Tech, Var = 42},
FFChampionVanillaBossSpawner =  {ID = FiendFolio.FFID.Tech, Var = 43},
GhostLarrySpawner = 	{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 0},
FuckedUpandEvilHollowSpawner = 	{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 1},
MucusMonstroSpawner =	{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 2},
WineHuskSpawner = 		{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 3},
AlienLokiSpawner = 		{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 4},
AlienLokiiSpawner = 	{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 5},
BeehiveFistulaBigSpawner = 		{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 6},
BeehiveFistulaMediumSpawner = 	{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 7},
BeehiveFistulaSmallSpawner = 	{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 8},
FuzzyTeratomaBigSpawner = 		{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 9},
FuzzyTeratomaMediumSpawner = 	{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 10},
FuzzyTeratomaSmallSpawner = 	{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 11},
GrinchKrampusSpawner = 	{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 12},
KidneyOfInfamyMaskSpawner =   	{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 13},
KidneyOfInfamyHeartSpawner = 	{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 14},
AlbinoWidowSpawner = 	{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 15},
RedForsakenSpawner = 	{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 16},
RedLittleHornSpawner = 	{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 17},
GoldenBabyPlumSpawner = {ID = FiendFolio.FFID.Tech, Var = 43, Sub = 18},
RainbowRagManSpawner = 	{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 19},
RedBigHornSpawner = 	{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 20},
PinkRagMegaSpawner = 	{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 21},
BlackSisterVisSpawner = {ID = FiendFolio.FFID.Tech, Var = 43, Sub = 22},
RivalWidowSpawner = 	{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 23},
CornyTeratomaBigSpawner = 	{ID = FiendFolio.FFID.Tech, Var = 43, Sub = 24},
CornyTeratomaMediumSpawner ={ID = FiendFolio.FFID.Tech, Var = 43, Sub = 25},
CornyTeratomaSmallSpawner = {ID = FiendFolio.FFID.Tech, Var = 43, Sub = 26},
MushroomGurglingSpawner = {ID = FiendFolio.FFID.Tech, Var = 43, Sub = 27},
BigHornBigBomb = 		{ID = FiendFolio.FFID.Tech, Var = 50},
BlastedMine = 			{ID = FiendFolio.FFID.Tech, Var = 450},
ShirkSpot = 			{ID = FiendFolio.FFID.Tech, Var = 451},
DungeonLocker = 		{ID = FiendFolio.FFID.Tech, Var = 452},
LurchGutTip = 			{ID = FiendFolio.FFID.Tech, Var = 453},
MolarOrbital =			{ID = FiendFolio.FFID.Tech, Var = 454},
KeyFiend = 				{ID = FiendFolio.FFID.Tech, Var = 455},
RedKeyFiend =			{ID = FiendFolio.FFID.Tech, Var = 455, Sub = 1},
BlueKeyFiend =			{ID = FiendFolio.FFID.Tech, Var = 455, Sub = 2},
GreenKeyFiend =			{ID = FiendFolio.FFID.Tech, Var = 455, Sub = 3},
ZtewieStinger = 		{ID = FiendFolio.FFID.Tech, Var = 456},
CherubskullHand = 		{ID = FiendFolio.FFID.Tech, Var = 457},
LilJunkie = 			{ID = FiendFolio.FFID.Tech, Var = 458},
ScrewProjectile = 		{ID = FiendFolio.FFID.Tech, Var = 459},
DoorCloser =          	{ID = FiendFolio.FFID.Tech, Var = 460},

BackdropReplacer = 		{ID = FiendFolio.FFID.Tech, Var = 1000},
RamblepointRed = 		{ID = FiendFolio.FFID.Tech, Var = 1001},
RamblepointBlue = 		{ID = FiendFolio.FFID.Tech, Var = 1002},
SummonsMaker =          {ID = FiendFolio.FFID.Tech, Var = 1003},

--Erfly stuff
Slammer = 				{ID = FiendFolio.FFID.Slammer, Var = 0},
Wimpy = 				{ID = FiendFolio.FFID.Slammer, Var = 1},
StoneySlammer = 		{ID = FiendFolio.FFID.Slammer, Var = 2},
StoneySlammerCrazy = 	{ID = FiendFolio.FFID.Slammer, Var = 3},
PaleSlammer = 			{ID = FiendFolio.FFID.Slammer, Var = 4},
Smasher = 				{ID = FiendFolio.FFID.Slammer, Var = 4},
Smore = 				{ID = FiendFolio.FFID.Slammer, Var = 5},
SmoreSeptic = 			{ID = FiendFolio.FFID.Slammer, Var = 6},
Stompy = 				{ID = FiendFolio.FFID.Slammer, Var = 7},
Doomer = 				{ID = FiendFolio.FFID.Slammer, Var = 8},
Marzy = 				{ID = FiendFolio.FFID.Slammer, Var = 9},
Flinty = 				{ID = FiendFolio.FFID.Slammer, Var = 10},
SquareFly = 			{ID = FiendFolio.FFID.SquareFly},
SquareFlyCW = 			{ID = FiendFolio.FFID.SquareFly, Var = 0},
SquareFlyACW = 			{ID = FiendFolio.FFID.SquareFly, Var = 1},
Sniffle = 				{ID = FiendFolio.FFID.Sniffle, Var = 0},
DryWheeze = 			{ID = FiendFolio.FFID.Sniffle, Var = 10},
Snagger = 				{ID = FiendFolio.FFID.Snagger, Var = 0},
Weaver = 				{ID = FiendFolio.FFID.Weaver, Var = 0},
WeaverSr = 				{ID = FiendFolio.FFID.Weaver, Var = 1},
DreadWeaver = 			{ID = FiendFolio.FFID.Weaver, Var = 2},
Thread = 				{ID = FiendFolio.FFID.Weaver, Var = 3},
Archer = 				{ID = FiendFolio.FFID.Weaver, Var = 4},
Diagetic = 				{ID = FiendFolio.FFID.Weaver, Var = 5},
Strand = 				{ID = FiendFolio.FFID.Weaver, Var = 6},
Craterface = 			{ID = FiendFolio.FFID.Craterface, Var = 0},
Drooler = 				{ID = FiendFolio.FFID.Craterface, Var = 69},
Blazer = 				{ID = FiendFolio.FFID.Craterface, Var = 666},
Psion = 				{ID = FiendFolio.FFID.Psion, Var = 0},

--Jokes
MotherOrb = 			{ID = FiendFolio.FFID.Erfly, Var = 1000},
Jackson = 				{ID = FiendFolio.FFID.Erfly, Var = 1001},
Freezer = 				{ID = FiendFolio.FFID.Erfly, Var = 1002},
Peat =	 				{ID = FiendFolio.FFID.Erfly, Var = 1003},
Horse =	 				{ID = FiendFolio.FFID.Erfly, Var = 1004},
StableHorse =	 		{ID = FiendFolio.FFID.Erfly, Var = 1005},
StablePony =	 		{ID = FiendFolio.FFID.Erfly, Var = 1006},
StableTainted =	 		{ID = FiendFolio.FFID.Erfly, Var = 1007},
ReheatedBeserker =		{ID = FiendFolio.FFID.Erfly, Var = 1710},
IsaacReheated =			{ID = FiendFolio.FFID.Erfly, Var = 1711},
Mern =					{ID = FiendFolio.FFID.Erfly, Var = 1712},
SpiderNicalis =			{ID = FiendFolio.FFID.Erfly, Var = 1713},
BabaIsEnemy =			{ID = FiendFolio.FFID.Erfly, Var = 1715},
FishNuclearThrone =		{ID = FiendFolio.FFID.Erfly, Var = 1716},
Crudemate =				{ID = FiendFolio.FFID.Erfly, Var = 1717},
Carrot =				{ID = FiendFolio.FFID.Erfly, Var = 1718},
Firecracker =			{ID = FiendFolio.FFID.Erfly, Var = 1719},

--Melon
Fatshroom =				{ID = FiendFolio.FFID.Erfly, Var = 2000},
ShroomLeaper =			{ID = FiendFolio.FFID.Erfly, Var = 2001},
Berry =					{ID = FiendFolio.FFID.Erfly, Var = 2002},
SpicyDip =				{ID = FiendFolio.FFID.Erfly, Var = 2003},

--Regular
Poople = 				{ID = FiendFolio.FFID.Erfly, Var = 0},
Dung = 					{ID = FiendFolio.FFID.Erfly, Var = 10},
Meatwad = 				{ID = FiendFolio.FFID.Erfly, Var = 30},
Slag = 					{ID = FiendFolio.FFID.Erfly, Var = 31},
Pox = 					{ID = FiendFolio.FFID.Erfly, Var = 32},
Haunch = 				{ID = FiendFolio.FFID.Erfly, Var = 33},
Outlier = 				{ID = FiendFolio.FFID.Erfly, Var = 34},
GrilledMeatwad = 		{ID = FiendFolio.FFID.Erfly, Var = 35},
Offal = 				{ID = FiendFolio.FFID.Erfly, Var = 40},
OffalReg = 				{ID = FiendFolio.FFID.Erfly, Var = 40, Sub = 0},
OffalWait = 			{ID = FiendFolio.FFID.Erfly, Var = 40, Sub = 1},
DriedOffal = 			{ID = FiendFolio.FFID.Erfly, Var = 41},
DriedOffalWait = 		{ID = FiendFolio.FFID.Erfly, Var = 41, Sub = 1},
Morsel = 				{ID = FiendFolio.FFID.Erfly, Var = 50},
Morsel1 = 				{ID = FiendFolio.FFID.Erfly, Var = 50, Sub = 0},
Morsel2 = 				{ID = FiendFolio.FFID.Erfly, Var = 50, Sub = 2},
Morsel3 = 				{ID = FiendFolio.FFID.Erfly, Var = 50, Sub = 3},
Morsel4 = 				{ID = FiendFolio.FFID.Erfly, Var = 50, Sub = 4},
Morsel5 = 				{ID = FiendFolio.FFID.Erfly, Var = 50, Sub = 5},
Morsel6 = 				{ID = FiendFolio.FFID.Erfly, Var = 50, Sub = 6},
Morsel7 = 				{ID = FiendFolio.FFID.Erfly, Var = 50, Sub = 7},
Morsel8 = 				{ID = FiendFolio.FFID.Erfly, Var = 50, Sub = 8},
Morsel9 = 				{ID = FiendFolio.FFID.Erfly, Var = 50, Sub = 9},
Morsel10 = 				{ID = FiendFolio.FFID.Erfly, Var = 50, Sub = 10},
Falafel = 				{ID = FiendFolio.FFID.Erfly, Var = 51},
Cancerlet =				{ID = FiendFolio.FFID.Erfly, Var = 51, Sub = 1},
Slick = 				{ID = FiendFolio.FFID.Erfly, Var = 52},
Stump =					{ID = FiendFolio.FFID.Erfly, Var = 53},
Frog = 					{ID = FiendFolio.FFID.Erfly, Var = 60},
MotorNeuron = 			{ID = FiendFolio.FFID.Erfly, Var = 70},
Dweller = 				{ID = FiendFolio.FFID.Erfly, Var = 80},
DwellerNormal = 		{ID = FiendFolio.FFID.Erfly, Var = 80, Sub = 0},
DwellerInnerEye = 		{ID = FiendFolio.FFID.Erfly, Var = 80, Sub = 2},
DwellerSpoonBender = 	{ID = FiendFolio.FFID.Erfly, Var = 80, Sub = 3},
DwellerNumberOne = 		{ID = FiendFolio.FFID.Erfly, Var = 80, Sub = 6},
DwellerBrotherBobby = 	{ID = FiendFolio.FFID.Erfly, Var = 80, Sub = 8},
DwellerTechnology = 	{ID = FiendFolio.FFID.Erfly, Var = 80, Sub = 68},
DwellerPolyphemus = 	{ID = FiendFolio.FFID.Erfly, Var = 80, Sub = 169},
DwellerCricketsBody = 	{ID = FiendFolio.FFID.Erfly, Var = 80, Sub = 224},
DwellerCursedEye = 		{ID = FiendFolio.FFID.Erfly, Var = 80, Sub = 316},
DwellerSoyMilk = 		{ID = FiendFolio.FFID.Erfly, Var = 80, Sub = 330},
DwellerEuthanasia = 	{ID = FiendFolio.FFID.Erfly, Var = 80, Sub = 496},
DwellerRandom = 		{ID = FiendFolio.FFID.Erfly, Var = 80, Sub = 1000},
DwellerBrother = 		{ID = FiendFolio.FFID.Erfly, Var = 81},
Resident = 				{ID = FiendFolio.FFID.Erfly, Var = 82},
ResidentRandom = 		{ID = FiendFolio.FFID.Erfly, Var = 82, Sub = 999}, --For some reason using 1000 made it turn into a Dweller??? shitty ass game
ResidentIPad = 			{ID = FiendFolio.FFID.Erfly, Var = 82, Sub = 1001},
ResidentAVGM = 			{ID = FiendFolio.FFID.Erfly, Var = 82, Sub = 1002},
ResidentBody = 			{ID = FiendFolio.FFID.Erfly, Var = 83},
TDweller = 				{ID = FiendFolio.FFID.Erfly, Var = 85},
TDwellerBrother = 		{ID = FiendFolio.FFID.Erfly, Var = 86},
Warty = 				{ID = FiendFolio.FFID.Erfly, Var = 90},
Gunk = 					{ID = FiendFolio.FFID.Erfly, Var = 100},
Punk = 					{ID = FiendFolio.FFID.Erfly, Var = 101},
Gleek = 				{ID = FiendFolio.FFID.Erfly, Var = 110},
Ribeye = 				{ID = FiendFolio.FFID.Erfly, Var = 120},
Cortex = 				{ID = FiendFolio.FFID.Erfly, Var = 130},
Gorger = 				{ID = FiendFolio.FFID.Erfly, Var = 140},
GorgerAss = 			{ID = FiendFolio.FFID.Erfly, Var = 140, Sub = 10},
Drop =	 				{ID = FiendFolio.FFID.Erfly, Var = 150},
Dribble = 				{ID = FiendFolio.FFID.Erfly, Var = 151},
Spark = 				{ID = FiendFolio.FFID.Erfly, Var = 152},
Glob = 					{ID = FiendFolio.FFID.Erfly, Var = 153},
Sizzle = 				{ID = FiendFolio.FFID.Erfly, Var = 154},
Fossil = 				{ID = FiendFolio.FFID.Erfly, Var = 160},
Sentry = 				{ID = FiendFolio.FFID.Erfly, Var = 161},
SentryReg = 			{ID = FiendFolio.FFID.Erfly, Var = 161, Sub = 0},
SentryShell = 			{ID = FiendFolio.FFID.Erfly, Var = 161, Sub = 1},
Mold = 					{ID = FiendFolio.FFID.Erfly, Var = 162},
Balor = 				{ID = FiendFolio.FFID.Erfly, Var = 170},
Eyesore = 				{ID = FiendFolio.FFID.Erfly, Var = 171},
Gander = 				{ID = FiendFolio.FFID.Erfly, Var = 172},
Beeter = 				{ID = FiendFolio.FFID.Erfly, Var = 180},
LilJon = 				{ID = FiendFolio.FFID.Erfly, Var = 190},
EliteJon = 				{ID = FiendFolio.FFID.Erfly, Var = 190, Sub = 1},
Crosseyes = 			{ID = FiendFolio.FFID.Erfly, Var = 200},
TadoKid = 				{ID = FiendFolio.FFID.Erfly, Var = 210},
ToxicKnight = 			{ID = FiendFolio.FFID.Erfly, Var = 220},
ToxicKnightHusk = 		{ID = FiendFolio.FFID.Erfly, Var = 220, Sub = 0},
ToxicKnightBrain = 		{ID = FiendFolio.FFID.Erfly, Var = 220, Sub = 1},
FloatingToxicKnight = 	{ID = FiendFolio.FFID.Erfly, Var = 221},
Haunted = 				{ID = FiendFolio.FFID.Erfly, Var = 230},
Yawner = 				{ID = FiendFolio.FFID.Erfly, Var = 231},
Fishface = 				{ID = FiendFolio.FFID.Erfly, Var = 240},
FishfaceReg = 			{ID = FiendFolio.FFID.Erfly, Var = 240, Sub = 0},
FishfaceWait = 			{ID = FiendFolio.FFID.Erfly, Var = 240, Sub = 1},
FishfaceShiny = 		{ID = FiendFolio.FFID.Erfly, Var = 241},
BubbleBaby = 			{ID = FiendFolio.FFID.Erfly, Var = 250},
Spitum = 				{ID = FiendFolio.FFID.Erfly, Var = 260},
Ghostse = 				{ID = FiendFolio.FFID.Erfly, Var = 270},
GhostseEasy = 			{ID = FiendFolio.FFID.Erfly, Var = 271},
GhostseSeptic = 		{ID = FiendFolio.FFID.Erfly, Var = 272},
Flare = 				{ID = FiendFolio.FFID.Erfly, Var = 280},
Crisply = 				{ID = FiendFolio.FFID.Erfly, Var = 281},
Incisor = 				{ID = FiendFolio.FFID.Erfly, Var = 290},
Starving = 				{ID = FiendFolio.FFID.Erfly, Var = 300},
Woodburner = 			{ID = FiendFolio.FFID.Erfly, Var = 310},
WoodburnerEasy = 		{ID = FiendFolio.FFID.Erfly, Var = 311},
MilkTooth = 			{ID = FiendFolio.FFID.Erfly, Var = 320},
Squire = 				{ID = FiendFolio.FFID.Erfly, Var = 330},
Foreseer = 				{ID = FiendFolio.FFID.Erfly, Var = 340},
PsionLeech = 			{ID = FiendFolio.FFID.Erfly, Var = 341},
Fumegeist = 			{ID = FiendFolio.FFID.Erfly, Var = 350},
Mote = 					{ID = FiendFolio.FFID.Erfly, Var = 351},
Sourpatch = 			{ID = FiendFolio.FFID.Erfly, Var = 360, Sub = 0},
SourpatchSeptic =		{ID = FiendFolio.FFID.Erfly, Var = 360, Sub = 1},
SourpatchBody = 		{ID = FiendFolio.FFID.Erfly, Var = 361, Sub = 0},
SourpatchBodySeptic = 	{ID = FiendFolio.FFID.Erfly, Var = 361, Sub = 1},
BloodCell = 			{ID = FiendFolio.FFID.Erfly, Var = 370},
BloodCellAir = 			{ID = FiendFolio.FFID.Erfly, Var = 371},
Madclaw = 				{ID = FiendFolio.FFID.Erfly, Var = 380},
MadclawReg = 			{ID = FiendFolio.FFID.Erfly, Var = 380, Sub = 0},
MadclawHide = 			{ID = FiendFolio.FFID.Erfly, Var = 380, Sub = 1},
HeadHoncho = 			{ID = FiendFolio.FFID.Erfly, Var = 390},
Colonel = 				{ID = FiendFolio.FFID.Erfly, Var = 400, Sub = 0},
ColonelOld = 			{ID = FiendFolio.FFID.Erfly, Var = 400, Sub = 200},
Zingling = 				{ID = FiendFolio.FFID.Erfly, Var = 401},
Zingy = 				{ID = FiendFolio.FFID.Erfly, Var = 402},
Globulon = 				{ID = FiendFolio.FFID.Erfly, Var = 410},
Primemind = 			{ID = FiendFolio.FFID.Erfly, Var = 420}, --Weed dude
Charlie = 				{ID = FiendFolio.FFID.Erfly, Var = 430},
Sooty = 				{ID = FiendFolio.FFID.Erfly, Var = 431},
SmokinOld = 			{ID = FiendFolio.FFID.Erfly, Var = 440},
Smokin = 				{ID = FiendFolio.FFID.Erfly, Var = 441},
Flamin = 				{ID = FiendFolio.FFID.Erfly, Var = 442},
FlaminChain = 			{ID = FiendFolio.FFID.Erfly, Var = 443},
Flickerspirit = 		{ID = FiendFolio.FFID.Erfly, Var = 450},
EternalFlickerspirit = 	{ID = FiendFolio.FFID.Erfly, Var = 451},
DeadFly = 				{ID = FiendFolio.FFID.Erfly, Var = 460},
DeadFlyOrbital =		{ID = FiendFolio.FFID.Erfly, Var = 461},
Dogmeat =				{ID = FiendFolio.FFID.Erfly, Var = 470},
Brooter =				{ID = FiendFolio.FFID.Erfly, Var = 480},
Tap =					{ID = FiendFolio.FFID.Erfly, Var = 490},
Tallboi =				{ID = FiendFolio.FFID.Erfly, Var = 500},
Shitling =				{ID = FiendFolio.FFID.Erfly, Var = 501},
ReallyTallboi =			{ID = FiendFolio.FFID.Erfly, Var = 505},
Peepling =				{ID = FiendFolio.FFID.Erfly, Var = 510},
Harletwin =				{ID = FiendFolio.FFID.Erfly, Var = 520, Sub = 0},
HarletwinCord =			{ID = FiendFolio.FFID.Erfly, Var = 520, Sub = 1},
Effigy =				{ID = FiendFolio.FFID.Erfly, Var = 521, Sub = 0},
EffigyCord =			{ID = FiendFolio.FFID.Erfly, Var = 521, Sub = 1},
Gis =					{ID = FiendFolio.FFID.Erfly, Var = 530},
Centipede =				{ID = FiendFolio.FFID.Erfly, Var = 540},
CentipedeAngy =			{ID = FiendFolio.FFID.Erfly, Var = 541},
Mullikaboom =			{ID = FiendFolio.FFID.Erfly, Var = 550},
Poobottle =				{ID = FiendFolio.FFID.Erfly, Var = 560},
Drainfly =				{ID = FiendFolio.FFID.Erfly, Var = 561},
Grater =				{ID = FiendFolio.FFID.Erfly, Var = 570},
Tombit =				{ID = FiendFolio.FFID.Erfly, Var = 580},
Gravin =				{ID = FiendFolio.FFID.Erfly, Var = 581},
Homer =					{ID = FiendFolio.FFID.Erfly, Var = 590},
Gishle =				{ID = FiendFolio.FFID.Erfly, Var = 600},
Hover =					{ID = FiendFolio.FFID.Erfly, Var = 610},
SaggingSucker =			{ID = FiendFolio.FFID.Erfly, Var = 620},
SaggingSpit =			{ID = FiendFolio.FFID.Erfly, Var = 621},
RedHorf =				{ID = FiendFolio.FFID.Erfly, Var = 630},
ShittyHorf =			{ID = FiendFolio.FFID.Erfly, Var = 631},
Zapbladder =			{ID = FiendFolio.FFID.Erfly, Var = 640},
Wire =					{ID = FiendFolio.FFID.Erfly, Var = 641},
Piper =					{ID = FiendFolio.FFID.Erfly, Var = 650},
ScytheRider =			{ID = FiendFolio.FFID.Erfly, Var = 660},
PitchforkHitcher =		{ID = FiendFolio.FFID.Erfly, Var = 661},
Reaper =				{ID = FiendFolio.FFID.Erfly, Var = 666},
MsDominator =			{ID = FiendFolio.FFID.Erfly, Var = 670},
Dominated =				{ID = FiendFolio.FFID.Erfly, Var = 671},
FossilBoomFly =			{ID = FiendFolio.FFID.Erfly, Var = 680},
Stingler =				{ID = FiendFolio.FFID.Erfly, Var = 681},
Trickle =				{ID = FiendFolio.FFID.Erfly, Var = 682},
TrickleFly =			{ID = FiendFolio.FFID.Erfly, Var = 682, Sub = 0},
TrickleSpider =			{ID = FiendFolio.FFID.Erfly, Var = 682, Sub = 1},
Bunch =					{ID = FiendFolio.FFID.Erfly, Var = 683, Sub = 0},
Grape =					{ID = FiendFolio.FFID.Erfly, Var = 683, Sub = 1},
Fishaac =				{ID = FiendFolio.FFID.Erfly, Var = 690},
Bumbler =				{ID = FiendFolio.FFID.Erfly, Var = 700},
Buckshot =				{ID = FiendFolio.FFID.Erfly, Var = 701},
Menace =				{ID = FiendFolio.FFID.Erfly, Var = 710},
ThousandEyes =			{ID = FiendFolio.FFID.Erfly, Var = 711},
ThousandEyesNorm =		{ID = FiendFolio.FFID.Erfly, Var = 711, Sub = 0},
ThousandEyesCharge =	{ID = FiendFolio.FFID.Erfly, Var = 711, Sub = 1},
ThousandEyesLook =		{ID = FiendFolio.FFID.Erfly, Var = 711, Sub = 2},
ThousandEyesWait =		{ID = FiendFolio.FFID.Erfly, Var = 711, Sub = 10},
Warden =				{ID = FiendFolio.FFID.Erfly, Var = 720},
ErodedHost =			{ID = FiendFolio.FFID.Erfly, Var = 730},
ErodedHostSkull =		{ID = FiendFolio.FFID.Erfly, Var = 730, Sub = 0},
ErodedHostBroke =		{ID = FiendFolio.FFID.Erfly, Var = 730, Sub = 1},
ErodedHostNaked =		{ID = FiendFolio.FFID.Erfly, Var = 730, Sub = 2},
Immural =				{ID = FiendFolio.FFID.Erfly, Var = 740},
ImmuralDead =			{ID = FiendFolio.FFID.Erfly, Var = 740, Sub = 1},
Shiitake =				{ID = FiendFolio.FFID.Erfly, Var = 750},
Bowler =				{ID = FiendFolio.FFID.Erfly, Var = 760, Sub = 0},
Loafer =				{ID = FiendFolio.FFID.Erfly, Var = 760, Sub = 1},
BowlerHead =			{ID = FiendFolio.FFID.Erfly, Var = 760, Sub = 2},
Striker =				{ID = FiendFolio.FFID.Erfly, Var = 761, Sub = 0},
PaleLoafer =			{ID = FiendFolio.FFID.Erfly, Var = 761, Sub = 1},
StrikerHead =			{ID = FiendFolio.FFID.Erfly, Var = 761, Sub = 2},
BowlerSeptic =			{ID = FiendFolio.FFID.Erfly, Var = 769, Sub = 0},
LoaferSeptic =			{ID = FiendFolio.FFID.Erfly, Var = 769, Sub = 1},
BowlerHeadSeptic =		{ID = FiendFolio.FFID.Erfly, Var = 769, Sub = 2},
MrHorf =				{ID = FiendFolio.FFID.Erfly, Var = 770},
MrHorfHead =			{ID = FiendFolio.FFID.Erfly, Var = 771},
MrRedHorf =				{ID = FiendFolio.FFID.Erfly, Var = 772},
MrRedHorfHead =			{ID = FiendFolio.FFID.Erfly, Var = 773},
MrGurgle =				{ID = FiendFolio.FFID.Erfly, Var = 774},
MrGurgleHead =			{ID = FiendFolio.FFID.Erfly, Var = 775},
MrSubHorf =				{ID = FiendFolio.FFID.Erfly, Var = 776},
Cordify =				{ID = FiendFolio.FFID.Erfly, Var = 780},
Spook =					{ID = FiendFolio.FFID.Erfly, Var = 790},
UteroPillar =			{ID = FiendFolio.FFID.Erfly, Var = 800},
Organelle =				{ID = FiendFolio.FFID.Erfly, Var = 801},
Honeydrip =				{ID = FiendFolio.FFID.Erfly, Var = 810},
Slim =					{ID = FiendFolio.FFID.Erfly, Var = 820, Sub = 0},
Limb =					{ID = FiendFolio.FFID.Erfly, Var = 820, Sub = 2},
PaleSlim =				{ID = FiendFolio.FFID.Erfly, Var = 821, Sub = 0},
Jim =					{ID = FiendFolio.FFID.Erfly, Var = 821, Sub = 1},
PaleLimb =				{ID = FiendFolio.FFID.Erfly, Var = 821, Sub = 2},
SlimShady =				{ID = FiendFolio.FFID.Erfly, Var = 822, Sub = 0},
RedHand =				{ID = FiendFolio.FFID.Erfly, Var = 822, Sub = 2},
Grim =					{ID = FiendFolio.FFID.Erfly, Var = 823, Sub = 0},
Limbone =				{ID = FiendFolio.FFID.Erfly, Var = 823, Sub = 2},
Pester =				{ID = FiendFolio.FFID.Erfly, Var = 830},
RamblinEvilMushroom =	{ID = FiendFolio.FFID.Erfly, Var = 840},
Bola =					{ID = FiendFolio.FFID.Erfly, Var = 850},
BolaHead =				{ID = FiendFolio.FFID.Erfly, Var = 850, Sub = 1},
BolaNeck =				{ID = FiendFolio.FFID.Erfly, Var = 850, Sub = 2},
Smidgen =				{ID = FiendFolio.FFID.Erfly, Var = 860},
RedSmidgen =			{ID = FiendFolio.FFID.Erfly, Var = 861},
ErodedSmidgen =			{ID = FiendFolio.FFID.Erfly, Var = 862},
ErodedSmidgenSkull =	{ID = FiendFolio.FFID.Erfly, Var = 862, Sub = 0},
ErodedSmidgenNaked =	{ID = FiendFolio.FFID.Erfly, Var = 862, Sub = 1},
Tittle =				{ID = FiendFolio.FFID.Erfly, Var = 863},
Looker =				{ID = FiendFolio.FFID.Erfly, Var = 870},
ArmouredLooker =		{ID = FiendFolio.FFID.Erfly, Var = 870, Sub = 0},
NakedLooker =			{ID = FiendFolio.FFID.Erfly, Var = 870, Sub = 1},
Peekaboo =				{ID = FiendFolio.FFID.Erfly, Var = 880},
PeekabooEye =			{ID = FiendFolio.FFID.Erfly, Var = 881},
RingOfRingFlies =		{ID = FiendFolio.FFID.Erfly, Var = 888},
DrShambles =			{ID = FiendFolio.FFID.Erfly, Var = 890},
InnerEye =				{ID = FiendFolio.FFID.Erfly, Var = 900},
Enlightened =			{ID = FiendFolio.FFID.Erfly, Var = 901, Sub = 0},
Unenlightened =			{ID = FiendFolio.FFID.Erfly, Var = 901, Sub = 1},
MrGob =					{ID = FiendFolio.FFID.Erfly, Var = 910},
Gob =					{ID = FiendFolio.FFID.Erfly, Var = 911},
Globscraper =			{ID = FiendFolio.FFID.Erfly, Var = 920},
Globscraper4 =			{ID = FiendFolio.FFID.Erfly, Var = 920, Sub = 0},
Globscraper3 =			{ID = FiendFolio.FFID.Erfly, Var = 920, Sub = 1},
Globscraper2 =			{ID = FiendFolio.FFID.Erfly, Var = 920, Sub = 2},
Globscraper1 =			{ID = FiendFolio.FFID.Erfly, Var = 920, Sub = 3},
GlobscraperSlide =		{ID = FiendFolio.FFID.Erfly, Var = 920, Sub = 10},
Foe =					{ID = FiendFolio.FFID.Erfly, Var = 930},
Psihunter =				{ID = FiendFolio.FFID.Erfly, Var = 940},
Psiling =				{ID = FiendFolio.FFID.Erfly, Var = 941},
Umbra =					{ID = FiendFolio.FFID.Erfly, Var = 950},
UmbraNormal =			{ID = FiendFolio.FFID.Erfly, Var = 950, Sub = 0},
UmbraBlistered =		{ID = FiendFolio.FFID.Erfly, Var = 950, Sub = 1},
Eclipse =				{ID = FiendFolio.FFID.Erfly, Var = 951},
Seeker =				{ID = FiendFolio.FFID.Erfly, Var = 960},
CWord =					{ID = FiendFolio.FFID.Erfly, Var = 970},
Neonate =				{ID = FiendFolio.FFID.Erfly, Var = 971},
Flanks =				{ID = FiendFolio.FFID.Erfly, Var = 980},
Carrier =				{ID = FiendFolio.FFID.Erfly, Var = 990},
Quack =					{ID = FiendFolio.FFID.Erfly, Var = 1010},
Lipoma =				{ID = FiendFolio.FFID.Erfly, Var = 1020},
NannyLongLegs =			{ID = FiendFolio.FFID.Erfly, Var = 1040},
Coby =					{ID = FiendFolio.FFID.Erfly, Var = 1050},
Rook =					{ID = FiendFolio.FFID.Erfly, Var = 1060},
Fingore =				{ID = FiendFolio.FFID.Erfly, Var = 1070},
FingoreHand =			{ID = FiendFolio.FFID.Erfly, Var = 1071},
MiniMinMin =			{ID = FiendFolio.FFID.Erfly, Var = 1080},
Gutter =				{ID = FiendFolio.FFID.Erfly, Var = 1090},
Sixth =					{ID = FiendFolio.FFID.Erfly, Var = 1100},
Residuum =				{ID = FiendFolio.FFID.Erfly, Var = 1110},
Technician =			{ID = FiendFolio.FFID.Erfly, Var = 1120},
Looksee =				{ID = FiendFolio.FFID.Erfly, Var = 1130},
Clergy =				{ID = FiendFolio.FFID.Erfly, Var = 1140},
Stolas =				{ID = FiendFolio.FFID.Erfly, Var = 1150},
Deathany =				{ID = FiendFolio.FFID.Erfly, Var = 1160},
Bull =					{ID = FiendFolio.FFID.Erfly, Var = 1170},
Geyser =				{ID = FiendFolio.FFID.Erfly, Var = 1180},
SuperGrimace =			{ID = FiendFolio.FFID.Erfly, Var = 1200},
Magnifier =				{ID = FiendFolio.FFID.Erfly, Var = 1205},
MagGaper =				{ID = FiendFolio.FFID.Erfly, Var = 1210},
PaleGaper =				{ID = FiendFolio.FFID.Erfly, Var = 1215},
Aper =					{ID = FiendFolio.FFID.Erfly, Var = 1220},
Matte =					{ID = FiendFolio.FFID.Erfly, Var = 1230},
BunkerWorm =			{ID = FiendFolio.FFID.Erfly, Var = 1240},
Buckethead =			{ID = FiendFolio.FFID.Erfly, Var = 1250},
BucketheadWait =		{ID = FiendFolio.FFID.Erfly, Var = 1250, Sub = 1},
Bubby =					{ID = FiendFolio.FFID.Erfly, Var = 1260},
Discy =					{ID = FiendFolio.FFID.Erfly, Var = 1270},
DiscyOnly =				{ID = FiendFolio.FFID.Erfly, Var = 1270, Sub = 0},
Nobody =				{ID = FiendFolio.FFID.Erfly, Var = 1270, Sub = 1},
Beebee =				{ID = FiendFolio.FFID.Erfly, Var = 1280},
Delinquent =			{ID = FiendFolio.FFID.Erfly, Var = 1290},
Grinner =				{ID = FiendFolio.FFID.Erfly, Var = 1300},
MobileMushroom =		{ID = FiendFolio.FFID.Erfly, Var = 1310}, --Old name for Mushroom Man
Onlyfan =				{ID = FiendFolio.FFID.Erfly, Var = 1320},
--Nothing here
Desirer =				{ID = FiendFolio.FFID.Erfly, Var = 1340},
DesirerWaning =			{ID = FiendFolio.FFID.Erfly, Var = 1341},
DesirerDiminished =		{ID = FiendFolio.FFID.Erfly, Var = 1342},
Seducer =				{ID = FiendFolio.FFID.Erfly, Var = 1343},
Buoy =					{ID = FiendFolio.FFID.Erfly, Var = 1350},
PaleHorf =				{ID = FiendFolio.FFID.Erfly, Var = 1360},
MagHorf =				{ID = FiendFolio.FFID.Erfly, Var = 1361},
PaleClotty =			{ID = FiendFolio.FFID.Erfly, Var = 1370},
MagClotty =				{ID = FiendFolio.FFID.Erfly, Var = 1371},
HolyClotty =			{ID = FiendFolio.FFID.Erfly, Var = 1380},
Receptor =				{ID = FiendFolio.FFID.Erfly, Var = 1390},
Galgalim =				{ID = FiendFolio.FFID.Erfly, Var = 1400},
Bloast =				{ID = FiendFolio.FFID.Erfly, Var = 1410},
BloastEye =				{ID = FiendFolio.FFID.Erfly, Var = 1411},
RagMini =				{ID = FiendFolio.FFID.Erfly, Var = 1420},
PinkRagMini =			{ID = FiendFolio.FFID.Erfly, Var = 1421},

--Ported Guill ones
Slobber =				{ID = FiendFolio.FFID.Erfly, Var = 2100},
Bleedy =				{ID = FiendFolio.FFID.Erfly, Var = 2101},
PaleBleedy =			{ID = FiendFolio.FFID.Erfly, Var = 2102},

--Julia enemies
Temper =				{ID = FiendFolio.FFID.Julia, Var = Isaac.GetEntityVariantByName("Temper")},
Spinny =				{ID = FiendFolio.FFID.Julia, Var = Isaac.GetEntityVariantByName("Spinny")},
Dizzy =					{ID = FiendFolio.FFID.Julia, Var = Isaac.GetEntityVariantByName("Dizzy")},
LightningFly =			{ID = FiendFolio.FFID.Julia, Var = Isaac.GetEntityVariantByName("Lightning Fly")},
Blot =					{ID = FiendFolio.FFID.Julia, Var = Isaac.GetEntityVariantByName("Blot")},
Melty =					{ID = FiendFolio.FFID.Julia, Var = Isaac.GetEntityVariantByName("Melty")},
Pitcher =				{ID = FiendFolio.FFID.Julia, Var = Isaac.GetEntityVariantByName("Pitcher")},
MutantHorf =			{ID = FiendFolio.FFID.Julia, Var = Isaac.GetEntityVariantByName("Mutant Horf")},
Phoenix = 				{ID = FiendFolio.FFID.Julia, Var = Isaac.GetEntityVariantByName("Phoenix")},
PhoenixUnignited =		{ID = FiendFolio.FFID.Julia, Var = Isaac.GetEntityVariantByName("Phoenix"), Sub = 0},
PhoenixCorpse =			{ID = FiendFolio.FFID.Julia, Var = Isaac.GetEntityVariantByName("Phoenix"), Sub = 1},
PhoenixIgnited =		{ID = FiendFolio.FFID.Julia, Var = Isaac.GetEntityVariantByName("Phoenix"), Sub = 2},
Pyroclasm =				{ID = FiendFolio.FFID.Julia, Var = Isaac.GetEntityVariantByName("Pyroclasm")},
Prick =					{ID = FiendFolio.FFID.Julia, Var = Isaac.GetEntityVariantByName("Prick")},
PrickDefault =			{ID = FiendFolio.FFID.Julia, Var = Isaac.GetEntityVariantByName("Prick"), Sub = 999999},
Blastcore = 			{ID = FiendFolio.FFID.Julia, Var = Isaac.GetEntityVariantByName("Blastcore")},
Skipper =				{ID = FiendFolio.FFID.Julia, Var = Isaac.GetEntityVariantByName("Skipper")},

-- catinsurance enemies
Level0Fly =				{ID = FiendFolio.FFID.Cat, 		Var = Isaac.GetEntityVariantByName("Level 0 Fly")},
AberratedPixel = 		{ID = EntityType.ENTITY_EFFECT, Var = Isaac.GetEntityVariantByName("Aberrated Pixel")},
WarpCultist = 			{ID = FiendFolio.FFID.Cat, 		Var = Isaac.GetEntityVariantByName("Warp Cultist")},
Klutz =					{ID = FiendFolio.FFID.Cat, 		Var = Isaac.GetEntityVariantByName("Klutz")},
Geigerspirit =			{ID = FiendFolio.FFID.Cat, 		Var = Isaac.GetEntityVariantByName("Geigerspirit")},
Binary =				{ID = FiendFolio.FFID.Cat, 		Var = Isaac.GetEntityVariantByName("Binary")},
BinaryRed =				{ID = FiendFolio.FFID.Cat, 		Var = Isaac.GetEntityVariantByName("Binary"), Sub = 0},
BinaryBlue =			{ID = FiendFolio.FFID.Cat, 		Var = Isaac.GetEntityVariantByName("Binary"), Sub = 1},
Congregation =			{ID = FiendFolio.FFID.Cat, 		Var = Isaac.GetEntityVariantByName("Congregation")},
Cacapillar =			{ID = FiendFolio.FFID.Cat, 		Var = Isaac.GetEntityVariantByName("Cacapillar")},
Turducken =				{ID = FiendFolio.FFID.Cat, 		Var = Isaac.GetEntityVariantByName("Turducken")},
Peepy =					{ID = FiendFolio.FFID.Cat, 		Var = Isaac.GetEntityVariantByName("Peepy")}, -- I <3 Peepy
Dang = 					{ID = FiendFolio.FFID.Cat, 		Var = Isaac.GetEntityVariantByName("Dang")},
DangCornHazard =		{ID = FiendFolio.FFID.Cat, 		Var = Isaac.GetEntityVariantByName("Dang Corn (Hazard)")},
DangCornProjectile = 	{ID = EntityType.ENTITY_PROJECTILE, Var = Isaac.GetEntityVariantByName("Dang Corn (Projectile)")},
FlamingMinecart =		{ID = EntityType.ENTITY_MINECART, Var = Isaac.GetEntityVariantByName("Flaming Minecart")},

-- Pixie's foes
Poki = 					{ID = EntityType.ENTITY_POKY, Var = Isaac.GetEntityVariantByName("Poki"), Sub = Isaac.GetEntitySubTypeByName("Poki")},
Angler = 				{ID = FiendFolio.FFID.Pixel,  Var = Isaac.GetEntityVariantByName("Angler"), ElectricityVar = Isaac.GetEntityVariantByName("Angler Electricity")},
Tiyanak = 				{ID = FiendFolio.FFID.Pixel,  Var = Isaac.GetEntityVariantByName("Tiyanak")},
Toadsie = 				{ID = FiendFolio.FFID.Pixel,  Var = Isaac.GetEntityVariantByName("Toadsie")},
NonBinary = 			{ID = FiendFolio.FFID.Pixel,  Var = Isaac.GetEntityVariantByName("Non-binary"), HeadSub = Isaac.GetEntitySubTypeByName("Non-binary Head")},
Cheekadee = 			{ID = FiendFolio.FFID.Pixel,  Var = Isaac.GetEntityVariantByName("Cheekadee")},
Murder = 				{ID = FiendFolio.FFID.Pixel,  Var = Isaac.GetEntityVariantByName("Murder")},
FriendWantedPoster = 	{ID = FiendFolio.FFID.Pixel,  Var = Isaac.GetEntityVariantByName("Friend Wanted Poster")},

-- Blastulation quarantine
Blastulation = {
	ProgressText = Isaac.GetEntityVariantByName("Blastulation Progress Text"),

	-- Common
	Isaac = Isaac.GetEntityVariantByName("Isaac Embryo"),
	Sucker = Isaac.GetEntityVariantByName("Sucker Embryo"),
	Swarm = Isaac.GetEntityVariantByName("Swarm Embryo"),
	Burning = Isaac.GetEntityVariantByName("Burning Embryo"),
	Host = {
		Variant = Isaac.GetEntityVariantByName("Host Embryo"),
		SubTypes = {
			Regular = Isaac.GetEntitySubTypeByName("Host Embryo"),
			Red 	= Isaac.GetEntitySubTypeByName("Red Host Embryo"),
		},
	},
	Chubber = Isaac.GetEntityVariantByName("Chubber Embryo"),
	Walking = Isaac.GetEntityVariantByName("Walking Embryo"),
	Drowned = Isaac.GetEntityVariantByName("Drowned Embryo"),
	Rock = {
		Variant = Isaac.GetEntityVariantByName("Rock Embryo"),
		SubTypes = {
			Rock = Isaac.GetEntitySubTypeByName("Rock Embryo"),
			Coal = Isaac.GetEntitySubTypeByName("Coal Embryo"),
		},
	},
	Throwable = Isaac.GetEntityVariantByName("Throwable Embryo"),
	Mr = {
		Variant = Isaac.GetEntityVariantByName("Mr. Embryo"),
		SubTypes = {
			Attached = Isaac.GetEntitySubTypeByName("Mr. Embryo"),
			Detached = Isaac.GetEntitySubTypeByName("Mr. Embryo (detached)"),
		},
	},
	Pale = {
		Variant = Isaac.GetEntityVariantByName("Pale Embryo"),
		SubTypes = {
			Pale 	 = Isaac.GetEntitySubTypeByName("Pale Embryo"),
			Headless = Isaac.GetEntitySubTypeByName("Headless Embryo"),
		},
	},
	Dank = Isaac.GetEntityVariantByName("Dank Embryo"),
	Blastocyst = {
		Variant = Isaac.GetEntityVariantByName("Blastocyst Embryo"),
		SubTypes = {
			Big   = Isaac.GetEntitySubTypeByName("Blastocyst Embryo"),
			Small = Isaac.GetEntitySubTypeByName("Embryo Embryo"),
		},
	},
	Scarred = Isaac.GetEntityVariantByName("Scarred Embryo"),
	Blue = Isaac.GetEntityVariantByName("Blue Embryo"),
	Angelic = Isaac.GetEntityVariantByName("Angelic Embryo"),
	Steven = Isaac.GetEntityVariantByName("Steven Embryo"),
	Sketch = Isaac.GetEntityVariantByName("Sketch Embryo"),
	Radical = Isaac.GetEntityVariantByName("Radical Embryo"),
	Embrrryo = Isaac.GetEntityVariantByName("Embrrryo"),
	Mishap = {
		Variant = Isaac.GetEntityVariantByName("Embryo Mishap"),
		SubTypes = {
			Lemon = Isaac.GetEntitySubTypeByName("Embryo Mishap"),
			Lime  = Isaac.GetEntitySubTypeByName("Embryo Mishap (lime)"),
		},
	},
	Embryobot = Isaac.GetEntityVariantByName("Embryobot"),
	Guillotine = {
		Variant = Isaac.GetEntityVariantByName("Guillotine Embryo"),
		SubTypes = {
			Body = Isaac.GetEntitySubTypeByName("Guillotine Embryo"),
			Head = Isaac.GetEntitySubTypeByName("Guillotine Embryo Head"),
		},
	},
	Prism = Isaac.GetEntityVariantByName("Prism Embryo"),
	Jelly = Isaac.GetEntityVariantByName("Jelly Embryo"),
	FortuneTeller = Isaac.GetEntityVariantByName("Fortune Teller Embryo"),
	Champion = Isaac.GetEntityVariantByName("Champion Embryo"),
	Sniffing = Isaac.GetEntityVariantByName("Sniffing Embryo"),
	IceCream = Isaac.GetEntityVariantByName("Ice Cream Embryo"),

	-- Special
	Gagger = Isaac.GetEntityVariantByName("Gagger Embryo"),
		BloodDonationMachineProjectile = Isaac.GetEntityVariantByName("Blood Donation Machine Projectile"),
	Heart = Isaac.GetEntityVariantByName("Heart Embryo"),
	Embrainyo = Isaac.GetEntityVariantByName("Embrainyo"),
	Grudge = Isaac.GetEntityVariantByName("Grudge Embryo"),
	Peeping = Isaac.GetEntityVariantByName("Peeping Embryo"),
		PeepingCordHelper = Isaac.GetEntitySubTypeByName("Peeping Embryo Cord Helper"),
	Level2 = Isaac.GetEntityVariantByName("Level 2 Embryo"),
	Shady = Isaac.GetEntityVariantByName("Shady Embryo"),
	Tainted = Isaac.GetEntityVariantByName("Tainted Embryo"),
	Skinless = Isaac.GetEntityVariantByName("Embryo (Skinless)"),
	Dr = Isaac.GetEntityVariantByName("Dr. Embryo"),
},

--Bosses (and related)
Buck =					{ID = FiendFolio.FFID.Boss, Var = 0},
Lez =					{ID = FiendFolio.FFID.Boss, Var = 1, Sub = 0},
Battie =				{ID = FiendFolio.FFID.Boss, Var = 10},
Buster =				{ID = FiendFolio.FFID.Boss, Var = 20},
Commission =			{ID = FiendFolio.FFID.Boss, Var = 21},
GriddleHorn =			{ID = FiendFolio.FFID.Boss, Var = 30},
Monsoon =				{ID = FiendFolio.FFID.Boss, Var = 40},
SunBody =				{ID = FiendFolio.FFID.Boss, Var = 50},
SunVenus =				{ID = FiendFolio.FFID.Boss, Var = 51},
SunEarth =				{ID = FiendFolio.FFID.Boss, Var = 52},
SunNeptune =			{ID = FiendFolio.FFID.Boss, Var = 53},
SunMoon =				{ID = FiendFolio.FFID.Boss, Var = 54},
SunSpike =				{ID = FiendFolio.FFID.Boss, Var = 55},
OrgChaser =				{ID = FiendFolio.FFID.Boss, Var = 60},
OrgChaserBrain =		{ID = FiendFolio.FFID.Boss, Var = 60, Sub = 1},
OrgBashful =			{ID = FiendFolio.FFID.Boss, Var = 61},
OrgBashfulCorpse =		{ID = FiendFolio.FFID.Boss, Var = 61, Sub = 1},
OrgSpeedy =				{ID = FiendFolio.FFID.Boss, Var = 62},
OrgPokey =				{ID = FiendFolio.FFID.Boss, Var = 63},
OrgPokeyCorpse =		{ID = FiendFolio.FFID.Boss, Var = 63, Sub = 1},
Basco =					{ID = FiendFolio.FFID.Boss, Var = 70},
BascoFood =				{ID = FiendFolio.FFID.Boss, Var = 71},
Kingpin =				{ID = FiendFolio.FFID.Boss, Var = 80},
Peeping =				{ID = FiendFolio.FFID.Boss, Var = 90},
Peeping2 =				{ID = FiendFolio.FFID.Boss, Var = 91},
Peepstalk =				{ID = FiendFolio.FFID.Boss, Var = 92},
Peepee =				{ID = FiendFolio.FFID.Boss, Var = 93},
Luncheon =				{ID = FiendFolio.FFID.Boss, Var = 100},
Tapeworm =				{ID = FiendFolio.FFID.Boss, Var = 101},
TapewormEgg =			{ID = FiendFolio.FFID.Boss, Var = 102},
WormBall =				{ID = FiendFolio.FFID.Boss, Var = 103},
Pollution =				{ID = FiendFolio.FFID.Boss, Var = 110},
Pollution2 =			{ID = FiendFolio.FFID.Boss, Var = 111},
Meltdown =				{ID = FiendFolio.FFID.Boss, Var = 120},
Meltdown2 =				{ID = FiendFolio.FFID.Boss, Var = 121},
FakeHorse =				{ID = FiendFolio.FFID.Boss, Var = 122},
Deluge =				{ID = FiendFolio.FFID.Boss, Var = 130},
Propaganda =			{ID = FiendFolio.FFID.Boss, Var = 140},
Imperialism =			{ID = FiendFolio.FFID.Boss, Var = 150},
Aquagob =				{ID = FiendFolio.FFID.Boss, Var = 160},
Aquabab =				{ID = FiendFolio.FFID.Boss, Var = 161},
Dusk =					{ID = FiendFolio.FFID.Boss, Var = 170},
DuskHand =				{ID = FiendFolio.FFID.Boss, Var = 171},
DuskHandL =				{ID = FiendFolio.FFID.Boss, Var = 171, Sub = 1},
DuskHandR =				{ID = FiendFolio.FFID.Boss, Var = 171, Sub = 2},

Tsar = 					{ID = FiendFolio.FFID.Boss, Var = 180},
Tsarball = 				{ID = FiendFolio.FFID.Boss, Var = 181},

Cacamancer = 			{ID = FiendFolio.FFID.Boss, Var = 190},
CacaSplurt = 			{ID = FiendFolio.FFID.Boss, Var = 191},

Gutso =					{ID = FiendFolio.FFID.Boss, Var = 200},

Slinger =				{ID = FiendFolio.FFID.Boss, Var = 210, Sub = 0},
SlingerBlack =			{ID = FiendFolio.FFID.Boss, Var = 210, Sub = 1},
SlingerTooth =			{ID = FiendFolio.FFID.Boss, Var = 211},
SlingerHead =			{ID = FiendFolio.FFID.Boss, Var = 212},
ThrownOralid =			{ID = 85, Var = 1821},
DetatchedShadow =		{ID = 1000, Var = 1980, Sub = 12},
Stringshot =			{ID = 1000, Var = 1980, Sub = 13},

MrDead = 				{ID = FiendFolio.FFID.Boss, Var = 220},
MrDeadsEye = 			{ID = FiendFolio.FFID.Boss, Var = 221},
BonyProjectile =		{ID = 1000, Var = 1980, Sub = 14},
DeadGeyser =			{ID = 1000, Var = 1980, Sub = 15},

WarpZone =				{ID = FiendFolio.FFID.Boss, Var = 230},
CorruptedMonstro =		{ID = FiendFolio.FFID.Boss, Var = 231},
CorruptedLarry =		{ID = FiendFolio.FFID.Boss, Var = 232},
CorruptedContusion =	{ID = FiendFolio.FFID.Boss, Var = 233},
CorruptedSuture =		{ID = FiendFolio.FFID.Boss, Var = 234},
PaleGusher =			{ID = FiendFolio.FFID.Boss, Var = 235},
KinetiAura =			{ID = 1000, Var = 175, Sub = FiendFolio.FFID.Ferrium},

Ghostbuster =			{ID = FiendFolio.FFID.Boss, Var = 240},
Emmission =				{ID = FiendFolio.FFID.Boss, Var = 241},
CongressingEmmission =	{ID = FiendFolio.FFID.Boss, Var = 242},
EmmissionProjectile =	{ID = FiendFolio.FFID.Boss, Var = 243},
EmmissionDeathHitbox =	{ID = FiendFolio.FFID.Boss, Var = 244},

WhispersController =	{ID = FiendFolio.FFID.Boss, Var = 250},
Whispers =				{ID = FiendFolio.FFID.Boss, Var = 251},
WhispersMarker =		{ID = FiendFolio.FFID.Boss, Var = 252},

-- cacophobiaspawner
CacophobiaVenus = 		{ID = FiendFolio.FFID.Boss, Var = 260},
CacophobiaRenderer =	{ID = 1000, Var = 1959},

Junkstrap = 			{ID = FiendFolio.FFID.Boss, Var = 280},
DopeHeadProjectile = 	{ID = FiendFolio.FFID.Mini, Var = Isaac.GetEntityVariantByName("Dope's Head Projectile")},
TrashbagProjectile = 	{ID = 9, Var = Isaac.GetEntityVariantByName("Trashbag Projectile")},
PigskinProjectile = 	{ID = 9, Var = Isaac.GetEntityVariantByName("Pigskin Projectile")},
LetterProjectile = 		{ID = 9, Var = Isaac.GetEntityVariantByName("Letter Projectile")},

Madomme	=				{ID = FiendFolio.FFID.Boss, Var = Isaac.GetEntityVariantByName("Madomme")},
MadommeSkull =			{ID = FiendFolio.FFID.Boss, Var = Isaac.GetEntityVariantByName("Madomme's Skull")},
MadommeBallgag =		{ID = FiendFolio.FFID.Boss, Var = Isaac.GetEntityVariantByName("Ballgag Projectile")},
MadommeDashBall =		{ID = FiendFolio.FFID.Boss, Var = Isaac.GetEntityVariantByName("Madomme Dash Ball")},
MadommeBrimstoneBall =	{ID = FiendFolio.FFID.Boss, Var = Isaac.GetEntityVariantByName("Madomme Brimstone Ball")},
Gimp =					{ID = FiendFolio.FFID.Boss, Var = Isaac.GetEntityVariantByName("G-Imp")},
Castle =				{ID = FiendFolio.FFID.Boss, Var = Isaac.GetEntityVariantByName("Castle")},
Gloria =				{ID = FiendFolio.FFID.Boss, Var = Isaac.GetEntityVariantByName("Gloria")},
MadommeHorse =			{ID = FiendFolio.FFID.Boss, Var = Isaac.GetEntityVariantByName("Horse (Madomme)")},
Champ =					{ID = FiendFolio.FFID.Boss, Var = Isaac.GetEntityVariantByName("Champ")},
MadommeWaveMarker =		{ID = 1000, Var = Isaac.GetEntityVariantByName("Madomme Spawner")},

Idolator =				{ID = FiendFolio.FFID.Boss, Var = 290},
IdolatorSloth =			{ID = FiendFolio.FFID.Boss, Var = 290, Sub = 1},
IdolatorLust =			{ID = FiendFolio.FFID.Boss, Var = 290, Sub = 2},
IdolatorWrath =			{ID = FiendFolio.FFID.Boss, Var = 290, Sub = 3},
IdolatorGluttony =		{ID = FiendFolio.FFID.Boss, Var = 290, Sub = 4},
IdolatorGreed =			{ID = FiendFolio.FFID.Boss, Var = 290, Sub = 5},
IdolatorEnvy =			{ID = FiendFolio.FFID.Boss, Var = 290, Sub = 6},
IdolatorPride =			{ID = FiendFolio.FFID.Boss, Var = 290, Sub = 7},
IdolatorGhost =			{ID = FiendFolio.FFID.Boss, Var = 291},
IdolatorPrideBomb =		{ID = FiendFolio.FFID.Boss, Var = 292},
IdolatorEnvyHead =		{ID = FiendFolio.FFID.Boss, Var = 293},

FoozTwinRed = 			{ID = FiendFolio.FFID.Boss, Var = 300, Sub = 0},
FoozTwinWhite = 		{ID = FiendFolio.FFID.Boss, Var = 300, Sub = 1},
FoozTwinsBall = 		{ID = FiendFolio.FFID.Boss, Var = 301},
FoozTwinsBewm =         {ID = FiendFolio.FFID.Boss, Var = 302}, -- these only exist for boss rush why does that not support subtypes ugh
FoozTwinsBoom =         {ID = FiendFolio.FFID.Boss, Var = 303},

Raymond	= 				{ID = FiendFolio.FFID.Boss, Var = 310},

Mo =    				{ID = FiendFolio.FFID.Boss, Var = 327}, --Enjoy this consistent variable name, it's the only one you will get

BabyBubbles = 			{ID = FiendFolio.FFID.Boss, Var = 340},
BabyBubblesPipe = 		{ID = FiendFolio.FFID.Boss, Var = 341},

Amon =					{ID = FiendFolio.FFID.Boss, Var = 350},
AmonCorpse =			{ID = 42,					Var = 786},
AmonArm =				{ID = 834,					Var = 786},
BreathsHead =			{ID = FiendFolio.FFID.Boss, Var = 351},
AmonHole =				{ID = 1000, Var = Isaac.GetEntityVariantByName("Amon Hole")},
AmonArmHole =			{ID = 1000, Var = Isaac.GetEntityVariantByName("Amon Arm Hole")},
AshypitSkin =			{ID = 1000, Var = Isaac.GetEntityVariantByName("Ashypit Skin")},
AmonFireball =			{ID = 9, 	Var = Isaac.GetEntityVariantByName("Amon Fireball")},
AmonFireballPoof =		{ID = 1000, Var = Isaac.GetEntityVariantByName("Amon Fireball Poof")},
Ashpile =				{ID = 1000, Var = Isaac.GetEntityVariantByName("Amon Ashpile"),						Sub = 0},
AshpileSmall =			{ID = 1000, Var = Isaac.GetEntityVariantByName("Amon Ashpile (Small)"),				Sub = 1},
AshpileMedium =			{ID = 1000, Var = Isaac.GetEntityVariantByName("Amon Ashpile (Medium)"),			Sub = 2},
AshpileBig =			{ID = 1000, Var = Isaac.GetEntityVariantByName("Amon Ashpile (Big)"),				Sub = 3},
AshpileSpider =			{ID = 1000, Var = Isaac.GetEntityVariantByName("Amon Ashpile (Spider)"),			Sub = 4},
AshpileFly =			{ID = 1000, Var = Isaac.GetEntityVariantByName("Amon Ashpile (Fly)"),				Sub = 5},
AshpileClickety =		{ID = 1000, Var = Isaac.GetEntityVariantByName("Amon Ashpile (Clickety Clack)"),	Sub = 6},
AshpileBigBony =		{ID = 1000, Var = Isaac.GetEntityVariantByName("Amon Ashpile (Big Bony)"),			Sub = 7},
DustOverlay =			{ID = 1000, Var = Isaac.GetEntityVariantByName("Amon Dust Overlay")},

BlueHorf =				{ID = FiendFolio.FFID.Boss, Var = 1000},
DukeOfDemons =			{ID = FiendFolio.FFID.Boss, Var = 1010},
DukesDemon =			{ID = FiendFolio.FFID.Boss, Var = 1011},

FFGridSpawner =			{ID = 983},
FFPoopSpawner =			{ID = 984},

RevIceHazardMorsel = 	{ID = 481, Var = 160},
RevIceHazardSlammer = 	{ID = 481, Var = 161},

--Effects
SootyTearPoof = 		{ID = 1000, Var = 1722, Sub = 0},
SootyTear2Poof = 		{ID = 1000, Var = 1722, Sub = 1},

GolemSubwayHint = 		{ID = 1000, Var = 1990},

--Friend's Guns
FriendsRevolver =       {ID = 1000, Var = 1759, Sub = 0},
RocketteDragoonGun = 	{ID = 1000, Var = 1760, Sub = 0},
RaildriverGun =		 	{ID = 1000, Var = 1760, Sub = 1},
GrandpasGatlingGun =	{ID = 1000, Var = 1760, Sub = 2},
FriendUnlockGun =		{ID = 1000, Var = 1760, Sub = 3},

MuzzleFlash =       	{ID = 1000, Var = 1761, Sub = 0},
FriendCasing =			{ID = 1000, Var = 1761, Sub = 1},

--Tainted Friend bounty stuff
BountyGun = 			{ID = 1000, Var = Isaac.GetEntityVariantByName("Bounty Gun")},
BountyBullet = 			{ID = 9, 	Var = Isaac.GetEntityVariantByName("Bounty Bullet"), BuckshotSub = 1},

--Fend's Mop
FendMop =				{ID = 1000, Var = 1950, Sub = 0},

--New same id one
DummyRopeTarget = 		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 0},
SlippyFart = 			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 10},
LyreParticle = 			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 11},
FFWhiteSmoke = 			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 12},
PsychicRing = 			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 13},
LoveHeart = 			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 14},
SecretGhost = 			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 15},
FairyWeapon = 			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 16},
MetalSlash = 			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 17},
ChirumiruFlash = 		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 20},
MimeBlock = 			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 21},
RidiculousMetalNote = 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 22},
PizzaBox = 				{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 23},
MeltdownFlash = 		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 24},
OrangeJuiceTile = 		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 25},
DuskFog = 				{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 30},
DuskHandAfterimage = 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 31},
FakeDusk = 				{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 32},
FakeBloodpoof = 		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 33},
DuskArm = 				{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 34},
SurpriseDeathAnim = 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 35},
PokerWager = 			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 40},
ClutchFamiliarTail = 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 41},
KalusVisage = 			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 42},
NilPastaEnd = 			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 43},
WhiteSquareEffect = 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 44},
GrabbersFriend = 		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 45},
GrapplingHook = 		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 50},
SanguineHook =	 		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 51},
SanguineHookSmall =		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 52},
SwallowedM90Gun = 		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 60},
GolemsAssaultRifle = 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 61},
GolemsARBulletCase = 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 62},
LilFriendsRevolver = 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 63},
JusticeAxeProjectile = 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 64},
BigMegaSplash = 		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 70},
DeadVermin = 			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 71},
OnlyfanAfterimage = 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 72},
FFKnifeSwipe =	 		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 80},
UtilityPoleCrow =	 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 81},
UtilityPoleHeart =	 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 82},
DyingMiniMin =	 		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 90},
TechnicianProjEf =	 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 100},
LookseeHand =		 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 110},
OwlStarMinor =		 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 120},
PlayerRainCloud =		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 125},
BallOfMalice =		 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 130},
BallOfMinion =		 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 131},
MaliceMinionGhost =		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 132},
IsaacSmonking =		 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 140},
CacaWhirlpool =		 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 150},
AwesomePointingArrow =	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 160},
SomethingThatFades =	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 161},
Dogboard =				{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 170},
LittlePhone =			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 180},
CameraFlash =			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 190},
AxeProjectile =			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 200},
AxeProjectileAfter =	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 201},
TelebombsCrosshair =	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 210},
DevilsDagger =			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 220},
DevilsDaggerGem =		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 221},
NitroStatus =			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 230},
InfinityVoltEnd =   	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 250},
AtlasBoulder =   		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 251},
Radiation =				{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 252},
ManAtArmsChainEffect =	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 253},
TwinkleAura =   		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 254},
BolemsClub =   			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 255},
CurseOfTheGatePedestal = {ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 256},
IsaacsRoll =   			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 260},
PropagandaFortune =   	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 261},
PropagandaSpotlight =   {ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 262},
SoapsudBubble =   		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 263},
FlameParticle =			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 264},
HKTechDot =				{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 265},
HKBrimstoneSwirl =		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 266},
HKFloatingKnife =		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 267},
HKEpicFetusTarget =		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 268},
HKFloatingSword =		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 269},
HKFloatingRevolver =	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 270},
FriendUnlock =			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 271},
ShadowClusterCreep =	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 272},
ShadowClusterSpike =	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 273},
ShadowClusterBlood = 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 274},
GoldenSpikesSparkles =	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 275},
GleamAura =				{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 276},
OrichalcosSeal =		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 277},
BouncingBall =			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 278},
CryBabyScream =			{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 279},
LilInabaSatellite = 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 280},
CrushingAnxiety = 		{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 285},
SoulExtractionDust = 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 286},
GritWave 			= 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 287},
LilInabaPowerItem 	= 	{ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 288},
MouseControlsIndicator= {ID = 1000, Var = FiendFolio.FFID.Effect, Sub = 289},


--Other old effects
EvilExplosion =			{ID = 1000, Var = 7012, Sub = 0},
FriendExplosion =		{ID = 1000, Var = 7012, Sub = 114},
FriendExplosionB =		{ID = 1000, Var = 7012, Sub = 115},

-- Custom Event Triggers
CustomEventTrigger = 		{ID = 1000, Var = 1970, Sub = 0},

EventTriggerEnemyGroup0 =	{ID = 1000, Var = 1970, Sub = 0},
EventTriggerEnemyGroup1 =	{ID = 1000, Var = 1970, Sub = 1},
EventTriggerEnemyGroup2 =	{ID = 1000, Var = 1970, Sub = 2},
EventTriggerEnemyGroup3 =	{ID = 1000, Var = 1970, Sub = 3},

EventTriggerEnemyAll0 =		{ID = 1000, Var = 1970, Sub = 10},
EventTriggerEnemyAll1 =		{ID = 1000, Var = 1970, Sub = 11},
EventTriggerEnemyAll2 =		{ID = 1000, Var = 1970, Sub = 12},
EventTriggerEnemyAll3 =		{ID = 1000, Var = 1970, Sub = 13},
}

FiendFolio.Effects = {
SootyTearPoof = {1722, 0},
SootyTear2Poof = {1722, 1},

}
--something wicked holdover, not sure if this is the appropriate place to put this but this definitely feels right
FiendFolio.ItemPopupSubtypes = {
    STANDARD = 1,
    MOVE_TO_PLAYER = 11,
    DIS_FUNNY_MOMENTS = 12,
    STANDALONE_WITH_VEL = 13,
	BEGGAR_GIVE = 14,
}

FiendFolio.StatusEffectColors = {
	Atrophy = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255),
	Berserk = Color(1.0, 0.3, 0.3, 1.0, 0/255, 0/255, 0/255),
	BerserkFlash = Color(1.0, 0.0, 0.0, 1.0, 100/255, 0/255, 0/255),
	Bleed = Color(1.0, 0.7, 0.7, 1.0, 70/255, 0/255, 0/255),
	Blind = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255),
	Bloated = Color(1.0, 1.0, 1.0, 1.0, 0/255, 70/255, 90/255),
	BruiseLvl1 = Color(0.7, 0.7, 0.7, 1.0, 40/255, 0/255, 40/255),
	BruiseLvl2 = Color(0.65, 0.6, 0.65, 1.0, 40/255, 0/255, 40/255),
	BruiseLvl3 = Color(0.6, 0.5, 0.6, 1.0, 40/255, 0/255, 40/255),
	BruiseLvl4 = Color(0.55, 0.4, 0.55, 1.0, 40/255, 0/255, 40/255),
	BruiseLvl5 = Color(0.5, 0.3, 0.5, 1.0, 40/255, 0/255, 40/255),
	Doom = Color(0.40, 0.35, 0.35, 1.0, -25/255, -35/255, -35/255),
	Hidden = Color(1, 1, 1, 0),
	Martyr = Color(0.7, 0.7, 0.7, 0.6, 70/255, 120/255, 140/255),
	MartyrFlash = Color(1.0, 1.0, 1.0, 1.0, 105/255, 180/255, 210/255),
	Nursing = Color(0.75, 2.0, 0.75, 1.0, 0/255, 60/255, 0/255),
	NursingFlash = Color(0.75, 2.0, 0.75, 1.0, 50/255, 150/255, 50/255),
	NursingSpawn = Color(1.0, 1.0, 1.0, 1.0, 0/255, 60/255, 0/255, 0, 5, 0, 0.33),
	NursingSpawnFlash = Color(1.0, 1.0, 1.0, 1.0, 50/255, 150/255, 50/255, 0, 5, 0, 0.33),
	NursingHealFlash = Color(0.5, 0.5, 0.5, 1.0, 0/255, 200/255, 0/255),
	NursingHealFade = Color(1, 1, 1, 1, 64/255, 128/255, 64/255),
	Mugged = Color(0.75, 0.55, 0.33, 1.0, 55/255, 40/255, 25/255),
	Overloaded = Color(1.2, 1.2, 0.8, 1.0, 40/255, 40/255, 0/255),
	Sewn = Color(1.0, 1.0, 1.0, 1.0, 40/255, 25/255, 0/255),
	Sleep = Color(0.25, 0.2, 0.6, 1.0, 20/255, 20/255, 40/255),
	Sweaty = Color(1.0, 1.0, 1.0, 1.0, 0/255, 0/255, 0/255),
	Pacified = Color(1.0, 0.8, 0.8, 1.0, 70/255, 25/255, 25/255),
	PacifiedFlash = Color(1.0, 0.8, 0.8, 1.0, 150/255, 50/255, 50/255),
	Festering = Color(0.75, 0.85, 0.4, 1, 0.10, 0.15, 0, 0.15, 0.2, 0, 0.3),
	Soulful = Color(0.7357, 0.8586, 0.9289, 1, 35/255, 45/255, 60/255, 0.6283, 0.8338, 0.9924, 0.2),
	Sentenced = Color(1.0, 0.64, 0.5, 1.0, 0.35, 0.05, 0),
}

FiendFolio.StatusEffectVariables = {
	BossStatusResistanceFrameCount = 240, -- same as basegame
	BerserkAnimAndMoveSpeedMultiplier = 1.25,
	BerserkDamageReceivedMultiplier = 2,
	BerserkDamageGivenMultiplier = 2,
	BerserkDamageGivenFlat = -2,
	BerserkDamageAgainstPlayer = 0,
	BerserkTargetTime = 60,
	BerserkBossTimeout = 60,
	BleedDamageTickRate = 30,
	BleedDamagePercentage = 1,
	BleedCreepTickRate = 10,
	BleedCreepTimeout = 45,
	BleedCreepDamagePercentage = 1/14,
	BleedTearChance = 0.25,
	BleedTearDamagePercentage = 0.66,
	BleedTearEntityVelocityInheritance = 0.33,
	BleedTearVelocityBase = 2,
	BleedTearVelocityScale = 2,
	BloatedHomingRadius = 100,
	BloatedHomingFriction = 0.85,
	BloatedHomingTargetFriction = 0.50,
	BloatedHomingStrength = 0.01,
	BloatedHomingTearFriction = 0.90,
	BloatedHomingTearStrength = 0.01,
	BloatedBoomerangFriction = 0.85,
	BloatedBoomerangTargetFriction = 0.50,
	BloatedBoomerangStrength = 0.005,
	BloatedBoomerangTearFriction = 0.975,
	BloatedBoomerangTearStrength = 0.005,
	DoomCountdownCooldown = 5,
	ExcommunicatedDamageExtraRadius = 20,
	ExcommunicatedDamageMinRadius = 80,
	ExcommunicatedShortDuration = 30,
	ExcommunicatedBaseDamage = 7.5,
	ExcommunicatedFloorAdditiveDamage = 0.5,
	ExcommunicatedTelefragDamageMultiplier = 2.5,
	ExcommunicatedWarningDuration = 15,
	MartyrAuraScalePerSize = 1/30,
	OverloadedLaserCooldown = 3,
	OverloadedLaserDistance = 100,
	OverloadedMaxSpriteOffset = 2.5,
	OverloadedPassChance = 0.1,
	SleepAwakenDamageMultiplier = 2,
}

--Creep spawning enemies
FiendFolio.creepLeavingEnemies = {
{32, 0},		--Brain
{40, 1},		--Scarred Guts
{237, 0},		--Gurgling
{279, 0},		--Black Globin's Head
{301, 0},		--Poison Mind
{307, 0},		--Tar Boy
FiendFolio.ENT("SoftServe"), 		--Soft Serve
FiendFolio.ENT("Sundae"), 		--Sundae
FiendFolio.ENT("Scoop"), 		--Scoop
FiendFolio.ENT("CornLoad"), 		--Little Load
FiendFolio.ENT("Poople"), 		--Poople
FiendFolio.ENT("Pox"), 		--Pox
FiendFolio.ENT("Gleek"),		--Gleek
FiendFolio.ENT("Cortex"),		--Cortex
FiendFolio.ENT("Balor"),		--Balor
FiendFolio.ENT("Eyesore"),		--Eyesore
FiendFolio.ENT("Organelle"),		--Organelles
}

FiendFolio.AllFlies = {
    [EntityType.ENTITY_FLY] = true,
    [EntityType.ENTITY_POOTER] = true,
    [EntityType.ENTITY_ATTACKFLY] = true,
    [EntityType.ENTITY_BOOMFLY] = true,
    [EntityType.ENTITY_SUCKER] = true,
    [EntityType.ENTITY_SWARMER] = true,
    [EntityType.ENTITY_FLY_L2] = true,
    [EntityType.ENTITY_RING_OF_FLIES] = true,
    [EntityType.ENTITY_FULL_FLY] = true,
    [EntityType.ENTITY_DART_FLY] = true,
    [EntityType.ENTITY_DUKIE] = true,
    [EntityType.ENTITY_HUSH_FLY] = true,
    [EntityType.ENTITY_HUSH_FLY] = true,
    [EntityType.ENTITY_WILLO] = true,
    [EntityType.ENTITY_FLY_BOMB] = true,
    [EntityType.ENTITY_WILLO_L2] = true,
    [EntityType.ENTITY_ARMYFLY] = true,
    [FiendFolio.FF.ReheatedIckyFly.ID .. " " .. FiendFolio.FF.ReheatedIckyFly.Var] = true,
    [FiendFolio.FF.ReheatedBobbyFly.ID .. " " .. FiendFolio.FF.ReheatedBobbyFly.Var] = true,
    [FiendFolio.FF.ReheatedFly.ID .. " " .. FiendFolio.FF.ReheatedFly.Var] = true,
    [FiendFolio.FF.ReheatedSackyFly.ID .. " " .. FiendFolio.FF.ReheatedSackyFly.Var] = true,
    [FiendFolio.FF.ReheatedChompyFly.ID .. " " .. FiendFolio.FF.ReheatedChompyFly.Var] = true,
    [FiendFolio.FF.ReheatedTickingFly.ID .. " " .. FiendFolio.FF.ReheatedTickingFly.Var] = true,
    [FiendFolio.FF.BeadFly.ID .. " " .. FiendFolio.FF.BeadFly.Var] = true,
    [FiendFolio.FF.ManicFly.ID .. " " .. FiendFolio.FF.ManicFly.Var] = true,
    [FiendFolio.FF.Warble.ID .. " " .. FiendFolio.FF.Warble.Var] = true,
    [FiendFolio.FF.RingLeader.ID .. " " .. FiendFolio.FF.RingLeader.Var] = true,
    [FiendFolio.FF.ShotFly.ID .. " " .. FiendFolio.FF.ShotFly.Var] = true,
    [FiendFolio.FF.Brood.ID .. " " .. FiendFolio.FF.Brood.Var] = true,
    [FiendFolio.FF.SquareFly.ID] = true,
    [FiendFolio.FF.Beeter.ID .. " " .. FiendFolio.FF.Beeter.Var] = true,
    [FiendFolio.FF.Colonel.ID .. " " .. FiendFolio.FF.Colonel.Var] = true,
    [FiendFolio.FF.Zingling.ID .. " " .. FiendFolio.FF.Zingling.Var] = true,
    [FiendFolio.FF.Zingy.ID .. " " .. FiendFolio.FF.Zingy.Var] = true,
    [FiendFolio.FF.Flickerspirit.ID .. " " .. FiendFolio.FF.Flickerspirit.Var] = true,
    [FiendFolio.FF.DeadFly.ID .. " " .. FiendFolio.FF.DeadFly.Var] = true,
    [FiendFolio.FF.Brooter.ID .. " " .. FiendFolio.FF.Brooter.Var] = true,
    [FiendFolio.FF.Poobottle.ID .. " " .. FiendFolio.FF.Poobottle.Var] = true,
    [FiendFolio.FF.Drainfly.ID .. " " .. FiendFolio.FF.Drainfly.Var] = true,
    [FiendFolio.FF.Homer.ID .. " " .. FiendFolio.FF.Homer.Var] = true,
    [FiendFolio.FF.Hover.ID .. " " .. FiendFolio.FF.Hover.Var] = true,
    [FiendFolio.FF.SaggingSucker.ID .. " " .. FiendFolio.FF.SaggingSucker.Var] = true,
    [FiendFolio.FF.FossilBoomFly.ID .. " " .. FiendFolio.FF.FossilBoomFly.Var] = true,
    [FiendFolio.FF.Stingler.ID .. " " .. FiendFolio.FF.Stingler.Var] = true,
    [FiendFolio.FF.Trickle.ID .. " " .. FiendFolio.FF.Trickle.Var] = true,
    [FiendFolio.FF.Bunch.ID .. " " .. FiendFolio.FF.Bunch.Var] = true,
    [FiendFolio.FF.Bumbler.ID .. " " .. FiendFolio.FF.Bumbler.Var] = true,
    [FiendFolio.FF.Honeydrip.ID .. " " .. FiendFolio.FF.Honeydrip.Var] = true,
    [FiendFolio.FF.RingOfRingFlies.ID .. " " .. FiendFolio.FF.RingOfRingFlies.Var] = true,
    [FiendFolio.FF.LightningFly.ID .. " " .. FiendFolio.FF.LightningFly.Var] = true,

}

--Ensures these play the insect swarm sound
FiendFolio.customFlies = {
FiendFolio.ENT("SquareFly"),		--Square Fly
FiendFolio.ENT("Beeter"),	--Beeter
FiendFolio.ENT("RingOfRingFlies"),	--Mega Ring Fly
FiendFolio.ENT("LightningFly"),	--Lightning Fly
FiendFolio.ENT("ManicFly"),	--Manic Fly
FiendFolio.ENT("Warble"),	--Warble
FiendFolio.ENT("Bead Fly"),
}

--Enemies prioritised by Starving
FiendFolio.StarvingPriorities = {
{53, 0}, -- Dople
{53, 1}, -- Evil Twin
{92, 0}, -- Heart
{231, 0}, -- Nerve ending
{231, 1}, -- Nerve ending 2
{310, 0}, -- Lepers
FiendFolio.ENT("NerveCluster"), -- Nerve Clusters
}

--Starving blacklist
FiendFolio.StarvingRidleys = {
--{208, 962}, -- Mouthful
{93, 0}, -- Mask
--{221, 0}, -- Cod worm
{224, 0}, -- Oob
{EntityType.ENTITY_BLOOD_PUPPY},
FiendFolio.ENT("Congression"), -- Congression
FiendFolio.ENT("Onlooker"), -- Onlooker
FiendFolio.ENT("FlyBundle"), -- Fly Bundle
FiendFolio.ENT("NimbusCloud"), -- Nimbus Cloud
FiendFolio.ENT("Craterface"), -- Craterface
FiendFolio.ENT("Drooler"), -- Drooler
FiendFolio.ENT("Blazer"), -- Blazer
FiendFolio.ENT("MotorNeuron"), -- Motor Neuron
FiendFolio.ENT("LilJon"), -- Lil' Jon
FiendFolio.ENT("Incisor"), -- Incisor (they feed him)
FiendFolio.ENT("Starving"), -- Other starvings
FiendFolio.ENT("EternalFlickerspirit"),	--Eternal Flickerspirit
FiendFolio.ENT("Viscerspirit"), --Viscerspirit
FiendFolio.ENT("Dogmeat"), -- Dogmeat
FiendFolio.ENT("Immural"), -- Immural
FiendFolio.ENT("Cuffs"), -- Cuffs
FiendFolio.ENT("WarbleTail"), -- Warble Tail
FiendFolio.ENT("RiftWalkerGfx"), -- Rift Walker (gfx)
FiendFolio.ENT("WombPillar"),
FiendFolio.ENT("UteroPillar"),
{44},
{792, 1889} -- Retribution Dummy NPC
}

--Enemies that reside in pits (or the walls of a crawlspace)
FiendFolio.PitEnemies = {
{311, 10},	--Mr. Mine
FiendFolio.ENT("Unpawtunate"),	--Unpawtunate
FiendFolio.ENT("Frog"),	--Frog
FiendFolio.ENT("Ribeye"),	--Ribeye
FiendFolio.ENT("Fossil"),	--Fossil
FiendFolio.ENT("Centipede"),	--Centipede
FiendFolio.ENT("ThousandEyes"),	--Thousand Eyes
}

--Enemies that reside in pots
FiendFolio.PotEnemies = {
FiendFolio.ENT("Tap"),
}

--Bat themed enemies in the FiendFolio, used by Battie
FiendFolio.BatEnemies = {
{234},	--One tooth, Jawbone
{258},	--Fat bat, Bubble bat, Ribbone
FiendFolio.ENT("Foamy"), --Foamy
FiendFolio.ENT("MilkTooth") -- Baby Bat
}

FiendFolio.Character = {Name1 = "Cudi", Name2 = "Crazy"}

--Maggot themed enemies in the FiendFolio
FiendFolio.MaggotEnemies = {
{21, 0},	--Maggot
{21, 750},	--Creepy Maggot
{21, 960},	--Roly Poly (ye basically)
{23},		--Charger, Drowned Charger, Dank Charger, Sternum
{31},		--Spitty
{243},		--Conjoined Spitty
}

--Fishfaces
FiendFolio.HidingUnderwaterEnts = {
FiendFolio.ENT("Gutbuster"),	--Gutbuster
FiendFolio.ENT("KrassBlaster"),	--Krass Blaster
FiendFolio.ENT("PsiKnightBrain"),	--Psionic Knight Brain
{56, 0, 95}, 	--lump
{58, 0, 95}, --parabite
{58, 1, 95}, --scarred parabite
{59, 0, 95}, 	--fred
{93},			--Masks
{206, 0, 95},	--Baby Long Legs
{206, 1, 95},	--Small Baby Long Legs
{207, 0, 95},	--Crazy Long Legs
{207, 1, 95},	--Small Crazy Long Legs
{EntityType.ENTITY_DEATHS_HEAD},
{215, 0, 95},	--Lvl2 Spiders
{215, 710, 95},	--Full Spiders
{244, 0, 95}, --round worm
{244, 1, 95}, --tube worm
FiendFolio.ENT("BoneWormWait"), --boneworm
{250, 0, 95},	--Ticking Spiders
{255, 0, 95}, --nightcrawler
{289, 0, 95}, --ulcer
{276, 0, 95}, --roundy
{666, 100, 95}, --drink worm
{677, 56241},	--Revelations Wandering Soul (wtf this is a familiar not an enemy??????)
{792, 1888},	--Cactus Collider
{EntityType.ENTITY_DARK_ESAU},
{EntityType.ENTITY_BLOOD_PUPPY},
{925, 541},	--Rev Skitterpill
{925, 542},	--Rev Skitterpill
{925, 543},	--Rev Skitterpill
FiendFolio.ENT("WaitingSpider"),		--Spiders
FiendFolio.ENT("WaitingWorm"),		--Hiding Worms
FiendFolio.ENT("OffalWait"),	--Hiding Offal
FiendFolio.ENT("DriedOffalWait"), --Hiding Dried Offal
FiendFolio.ENT("Cortex"),		--Cortex
FiendFolio.ENT("GorgerAss"), --Gorger Ass
FiendFolio.ENT("FishfaceWait"),	--Hiding Fishface
FiendFolio.ENT("MadclawHide"),	--Hiding Madclaw
FiendFolio.ENT("ToxicKnightBrain"),	--Toxic Knight Brain
FiendFolio.ENT("EternalFlickerspirit"),		--Eternal Flickerspirit
FiendFolio.ENT("Viscerspirit"),      --Viscerspirit
FiendFolio.ENT("Organelle"),		--Organelle
FiendFolio.ENT("BolaHead"),	--Bola Skull
FiendFolio.ENT("BolaNeck"),	--Bola Neck
FiendFolio.ENT("Eclipse"),		--Eclipse
FiendFolio.ENT("PhoenixCorpse"), --Phoenix Corpse
FiendFolio.ENT("PhoenixIgnited"), --revived phoenix
FiendFolio.ENT("MorvidPerched"),
FiendFolio.ENT("ThousandEyesWait"),
FiendFolio.ENT("BucketheadWait"),
FiendFolio.ENT("Steralis"),
FiendFolio.ENT("DimGhost"),
FiendFolio.ENT("Gamper"),
}

--Weird enemy blacklist
FiendFolio.BadEnts = {
{33},		--Fireplace
{42},		--All grimaces
{79, 12},	-- Blighted Ovum (Suture)
{93},		--Masks
{96},		--Eternal Fly
{218},		--Wall huggers
{291},		--Pitfall
{302},		--Stoney
{409, 1},	--Purple Ball
FiendFolio.ENT("PatzerShell"), --Patzer Shell (this SHOULD help maybe)
{677, 56241},--Revelations Wandering Soul (wtf this is a familiar not an enemy??????)
FiendFolio.ENT("Gravefire"),	--Gravefire
{792, 1888},--Cactus Collider
{792, 1889}, -- Retribution Dummy NPC
{EntityType.ENTITY_DARK_ESAU},
{EntityType.ENTITY_BLOOD_PUPPY},
FiendFolio.ENT("Mistmonger"),	--Mistmonger
FiendFolio.ENT("Onlooker"), --Onlooker
{925, 541},	--Rev Skitterpill
{925, 542},	--Rev Skitterpill
{925, 543},	--Rev Skitterpill
{FiendFolio.FFID.Tech},		--Technical ents
FiendFolio.ENT("FerrWaiting"), --Waiting helper for Ferrium enemies
FiendFolio.ENT("Blazer"),	--Blazer
FiendFolio.ENT("LilJon"),	--L'il Jon
FiendFolio.ENT("DeadFlyOrbital"),	--Eternal Fly reimplementation
FiendFolio.ENT("Tombit"),	--Tombit
FiendFolio.ENT("Gravin"),	--Gravin
FiendFolio.ENT("UteroPillar"),	--Utero Pillar
FiendFolio.ENT("Eclipse"),	--Eclipse
{EntityType.ENTITY_FROZEN_ENEMY}, --Uranus Frozen Enemy
FiendFolio.ENT("Cuffs"), -- Cuffs
FiendFolio.ENT("SentryShell"),
FiendFolio.ENT("LonelyKnightBrain"),	-- Lonely Knight Hurtbox
FiendFolio.ENT("LonelyKnightShell"),	-- Lonely Knight Hitboxes
FiendFolio.ENT("WarbleTail"),	-- Warble (tail)
FiendFolio.ENT("RiftWalkerGfx"), -- Rift Walker (gfx)
FiendFolio.ENT("Specturn"),     -- Specturn
FiendFolio.ENT("ChummerPathfinder"), -- Chummer's pathfinder
FiendFolio.ENT("BadBag"),
FiendFolio.ENT("TheColorRed"),
FiendFolio.ENT("WhispersController"),
{617,0}, --Samael lost soul
{617,1}, --Samael fragment portal
{617,2}, --Samael deals
{617,3}, --Samael dummy ent
}
--Psion / Cauldron's exclusive blacklist
FiendFolio.SpecialBadEnts = {
FiendFolio.ENT("Psion"),		--Psion
FiendFolio.ENT("Gravedigger"),	--Gravedigger
FiendFolio.ENT("Psihunter"),	--Psihunter
}

-- enemies that :IsVulnerableEnemy() returns false for, but can still be killed
FiendFolio.NotReallyInvulnerableEnemies = { -- there goes deadinfinity making silly long variable names again!
	-- BASE GAME
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_HOST, 0)] = true, -- variants > 0 not invulnerable
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_ROUND_WORM, 0)] = true, -- don't include waiting!!!
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_ROUND_WORM, 1)] = true, -- tube worm
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_NIGHT_CRAWLER, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_MOBILE_HOST, 0)] = true, -- flesh host is separate id
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_ULCER, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_PARA_BITE, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_PARA_BITE, 1)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_COD_WORM, 0)] = true,
	[FiendFolio.GET_ENT_KEY(311, 0)] = true, -- mr. mine (KILBURN!!!!)
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_WIZOOB, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_RED_GHOST, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_MOMS_HAND, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_MOMS_DEAD_HAND, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_LUMP, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_FRED, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_TARBOY, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_FAT_SACK, 0)] = true, -- they can jump!
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_TICKING_SPIDER, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_SPIDER_L2, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_SPIDER, 0)] = true, -- when thrown by another npc
	-- bosses
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_MONSTRO, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_MONSTRO2, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_MONSTRO2, 1)] = true, -- gish
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_WIDOW, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_WIDOW, 1)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_PIN, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_PIN, 1)] = true, -- scolex
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_PIN, 2)] = true, -- frail
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_LITTLE_HORN, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_POLYCEPHALUS, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_STAIN, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_MEGA_FATTY, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_BIG_HORN, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_RAG_MEGA, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_MATRIARCH, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_LOKI, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_LOKI, 1)] = true, -- lokii
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_BLASTOCYST_BIG, 0)] = true, -- i'm not actually sure if blastocyst jumps over shots but eh
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_BLASTOCYST_MEDIUM, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_BLASTOCYST_SMALL, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_MR_FRED, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_DADDYLONGLEGS, 0)] = true,
	[FiendFolio.GET_ENT_KEY(EntityType.ENTITY_DADDYLONGLEGS, 1)] = true, -- triachnid

	-- FIENDFOLIO
	[FiendFolio.ENT_KEY("Slammer")] = true,
	[FiendFolio.ENT_KEY("Wimpy")] = true,
	[FiendFolio.ENT_KEY("PaleSlammer")] = true,
	[FiendFolio.ENT_KEY("Smore")] = true,
	[FiendFolio.ENT_KEY("SmoreSeptic")] = true, -- septic slammer (s'eptic)
	[FiendFolio.ENT_KEY("Cracker")] = true, -- Cracker
	[FiendFolio.ENT_KEY("Unpawtunate")] = true, -- unpawtunate
	[FiendFolio.ENT_KEY("Ribeye")] = true, -- ribeye
	[FiendFolio.ENT_KEY("Frog")] = true, -- frog
	[FiendFolio.ENT_KEY("BoneWorm")] = true, -- boneworm
	[FiendFolio.ENT_KEY("Weaver")] = true, -- weaver
	[FiendFolio.ENT_KEY("WeaverSr")] = true, -- weaver sr
	[FiendFolio.ENT_KEY("DreadWeaver")] = true, -- dread weaver
	[FiendFolio.ENT_KEY("Smidgen")] = true, -- smidgen
	[FiendFolio.ENT_KEY("Poobottle")] = true, -- poobottle
	[FiendFolio.ENT_KEY("Drainfly")] = true, -- drainfly
	[FiendFolio.ENT_KEY("FullSpider")] = true, -- full spider
	[FiendFolio.ENT_KEY("ReheatedBobbySpider")] = true, -- next 5 are reheated spiders
	[FiendFolio.ENT_KEY("ReheatedSpider")] = true,
	[FiendFolio.ENT_KEY("ReheatedSackySpider")] = true,
	[FiendFolio.ENT_KEY("ReheatedIckySpider")] = true,
	[FiendFolio.ENT_KEY("ReheatedChompySpider")] = true,
	[FiendFolio.ENT_KEY("Grater")] = true, -- grater
	[FiendFolio.ENT_KEY("Bola")] = true, -- bola
	[FiendFolio.ENT_KEY("Sombra")] = true, -- sombra
	[FiendFolio.ENT_KEY("MsDominator")] = true, -- ms. dominator
	[FiendFolio.ENT_KEY("FishfaceReg")] = true, -- fishface (not waiting)
	[FiendFolio.ENT_KEY("MadclawReg")] = true, -- madclaw (not waiting)
	[FiendFolio.ENT_KEY("OffalReg")] = true, -- offal (not waiting)
	[FiendFolio.ENT_KEY("Drop")] = true, -- drip
	[FiendFolio.ENT_KEY("LightningFly")] = true, -- lightning fly
	[FiendFolio.ENT_KEY("Centipede")] = true, -- centipede
	[FiendFolio.ENT_KEY("Fishaac")] = true, -- fishaac
	[FiendFolio.ENT_KEY("Menace")] = true, -- menace
	[FiendFolio.ENT_KEY("SludgeHost")] = true, -- sludge host
	[FiendFolio.ENT_KEY("Skuzz")] = true, -- skuzz
	[FiendFolio.ENT_KEY("Skuzzball")] = true, -- skuzzball
	[FiendFolio.ENT_KEY("SkuzzballSmall")] = true, -- skuzzball (small)
	[FiendFolio.ENT_KEY("Skullcap")] = true,
	[FiendFolio.ENT_KEY("Slimer")] = true,
	[FiendFolio.ENT_KEY("Doomer")] = true,
	[FiendFolio.ENT_KEY("Marzy")] = true,
	[FiendFolio.ENT_KEY("Stompy")] = true,
	[FiendFolio.ENT_KEY("Flinty")] = true,
	[FiendFolio.ENT_KEY("Quaker")] = true,
	[FiendFolio.ENT_KEY("Rancor")] = true,
	[FiendFolio.ENT_KEY("Shaker")] = true,
	-- bosses
	[FiendFolio.ENT_KEY("GriddleHorn")] = true, -- griddle horn
	[FiendFolio.ENT_KEY("Monsoon")] = true, -- monsoon
	[FiendFolio.ENT_KEY("Luncheon")] = true, -- luncheon
	[FiendFolio.ENT_KEY("Kingpin")] = true, -- kingpin
}

FiendFolio.RootedEnemies = { -- vulnerable enemies that reset their positions constantly
	[EntityType.ENTITY_BOIL] = true,
	[EntityType.ENTITY_TARBOY] = true,
	[EntityType.ENTITY_PARA_BITE] = true,
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
	[EntityType.ENTITY_CORN_MINE] = true,
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
	[EntityType.ENTITY_THE_HAUNT] = true,
}

--Currently unused enum table for bubble variants
FiendFolio.Bubble = {
RANDOM = -1,
TINY = 0,
SMALL = 1,
MEDIUM = 2,
LARGE = 3,
FLY = 4,
SPIDER = 5,
EXPLOSIVE = 6
}

-- the table used to generate fiend folio enemies from a portal, table is built off of room:GetBackdropType()
FiendFolio.portalreplacementrandompool = {1,2,3,4,5,6,7,8,9,10,11,12,14,15}
FiendFolio.portalreplacement = {
	[1] = { -- Basement
		{EntityType.ENTITY_GAPER, 1, 0},
		{EntityType.ENTITY_GUSHER, 0, 0},
		{EntityType.ENTITY_SKINNY, 0, 0},
		{EntityType.ENTITY_FATTY, 0, 0},
		{EntityType.ENTITY_POOTER, 0, 0},
		{EntityType.ENTITY_POOTER, 1, 0},
		{EntityType.ENTITY_ROUND_WORM, 0, 0},
		{EntityType.ENTITY_ATTACKFLY, 0, 0},
		{EntityType.ENTITY_MOTER, 0, 0},
		{EntityType.ENTITY_CLOTTY, 0, 0},
		{EntityType.ENTITY_HOPPER, 0, 0},
		{EntityType.ENTITY_MULLIGAN, 0, 0},
		{EntityType.ENTITY_DIP, 0, 0},
		{EntityType.ENTITY_HORF, 0, 0},
		{EntityType.ENTITY_CYCLOPIA, 0, 0},
		{EntityType.ENTITY_MINISTRO, 0, 0},
		{EntityType.ENTITY_FLY_L2, 0, 0},
		FiendFolio.ENT("Dung"),
		FiendFolio.ENT("Slammer"),
		FiendFolio.ENT("Wimpy"),
		FiendFolio.ENT("Pester"),
		FiendFolio.ENT("Casualty"),
		FiendFolio.ENT("Slim"),
		FiendFolio.ENT("Loafer"),
		FiendFolio.ENT("Drumstick"),
		FiendFolio.ENT("ButtFly"),
		FiendFolio.ENT("ShotFly"),
		FiendFolio.ENT("Shoter"),
		FiendFolio.ENT("Slobber"),
		FiendFolio.ENT("MutantHorf"),
		FiendFolio.ENT("RedHorf"),
		{FiendFolio.FF.Morsel.ID, FiendFolio.FF.Morsel.Var, 2},
	},
	[2] = { -- Cellar
		{EntityType.ENTITY_GAPER, 0, 0},
		{EntityType.ENTITY_GUSHER, 1, 0},
		{EntityType.ENTITY_MULLIGAN, 1, 0},
		{EntityType.ENTITY_SKINNY, 0, 0},
		{EntityType.ENTITY_FATTY, 0, 0},
		{EntityType.ENTITY_HOPPER, 1, 0},
		{EntityType.ENTITY_SPIDER, 0, 0},
		{EntityType.ENTITY_BIGSPIDER, 0, 0},
		{EntityType.ENTITY_ROUND_WORM, 0, 0},
		{EntityType.ENTITY_DIP, 0, 0},
		{EntityType.ENTITY_HORF, 0, 0},
		{EntityType.ENTITY_CYCLOPIA, 0, 0},
		{EntityType.ENTITY_SPIDER_L2, 0, 0},
		{EntityType.ENTITY_WALKINGBOIL, 2, 0},
		{EntityType.ENTITY_SWARM_SPIDER, 2, 0},
		FiendFolio.ENT("Skuzz"),
		FiendFolio.ENT("WalkingStickySack"),
		FiendFolio.ENT("Coby"),
		FiendFolio.ENT("Spooter"),
		FiendFolio.ENT("SuperSpooter"),
		FiendFolio.ENT("Beeter"),
		FiendFolio.ENT("Zingling"),
		FiendFolio.ENT("Hover"),
		FiendFolio.ENT("HoneyEye"),
		FiendFolio.ENT("Stingler"),
		FiendFolio.ENT("Receptor"),
		FiendFolio.ENT("Haunted"),
		FiendFolio.ENT("Yawner"),
		FiendFolio.ENT("Crotchety"),
		FiendFolio.ENT("Dim"),
		{FiendFolio.FF.Spoop.ID, FiendFolio.FF.Spoop.Var, 5},
	},
	[3] = { -- Burning Basement
		{EntityType.ENTITY_GAPER, 2, 0},
		{EntityType.ENTITY_GUSHER, 0, 0},
		{EntityType.ENTITY_SKINNY, 2, 0},
		{EntityType.ENTITY_FATTY, 2, 0},
		{EntityType.ENTITY_POOTER, 0, 0},
		{EntityType.ENTITY_POOTER, 1, 0},
		{EntityType.ENTITY_ROUND_WORM, 0, 0},
		{EntityType.ENTITY_CLOTTY, 3, 0},
		{EntityType.ENTITY_FLAMINGHOPPER, 0, 0},
		{EntityType.ENTITY_CYCLOPIA, 0, 0},
		FiendFolio.ENT("Spitroast"),
		FiendFolio.ENT("S'More"),
		FiendFolio.ENT("Mote"),
		FiendFolio.ENT("Powderkeg"),
		FiendFolio.ENT("Woodburner"),
		FiendFolio.ENT("Wick"),
		FiendFolio.ENT("Flare"),
		FiendFolio.ENT("Spark"),
		FiendFolio.ENT("Charlie"),
		FiendFolio.ENT("Trailblazer"),
		FiendFolio.ENT("Litling"),
	},
	[4] = { -- Caves
		{EntityType.ENTITY_ONE_TOOTH, 0, 0},
		{EntityType.ENTITY_FAT_BAT, 0, 0},
		{EntityType.ENTITY_SKINNY, 1, 0},
		{EntityType.ENTITY_FATTY, 1, 0},
		{EntityType.ENTITY_SUCKER, 0, 0},
		{EntityType.ENTITY_MAW, 0, 0},
		{EntityType.ENTITY_CHARGER, 0, 0},
		{EntityType.ENTITY_MAGGOT, 0, 0},
		{EntityType.ENTITY_BOOMFLY, 0, 0},
		{EntityType.ENTITY_HIVE, 0, 0},
		{EntityType.ENTITY_WALKINGBOIL, 0, 0},
		{EntityType.ENTITY_NIGHT_CRAWLER, 0, 0},
		FiendFolio.ENT("Foamy"),
		FiendFolio.ENT("MilkTooth"),
		FiendFolio.ENT("Scoop"),
		FiendFolio.ENT("Balor"),
		FiendFolio.ENT("RamblinEvilMushroom"),
		FiendFolio.ENT("Smidgen"),
		FiendFolio.ENT("Fathead"),
		FiendFolio.ENT("Wobbles"),
		FiendFolio.ENT("Weaver"),
		FiendFolio.ENT("Globlet"),
		FiendFolio.ENT("PaleSlim"),
		FiendFolio.ENT("FossilBoomFly"),
		FiendFolio.ENT("Tallboi"),
		FiendFolio.ENT("RolyPoly"),
		FiendFolio.ENT("Fishaac"),
		{FiendFolio.FF.Dweller.ID, FiendFolio.FF.Dweller.Var, 1000},
		{FiendFolio.FF.Slick.ID, FiendFolio.FF.Slick.Var, 2},
	},
	[5] = { -- Catacombs
		{EntityType.ENTITY_VIS, 2, 0},
		{EntityType.ENTITY_CRAZY_LONG_LEGS, 1, 0},
		{EntityType.ENTITY_GURGLE, 0, 0},
		{EntityType.ENTITY_FATTY, 1, 0},
		{EntityType.ENTITY_SUCKER, 1, 0},
		{EntityType.ENTITY_MAW, 1, 0},
		{EntityType.ENTITY_SPITTY, 0, 0},
		{EntityType.ENTITY_BOOMFLY, 1, 0},
		{EntityType.ENTITY_NEST, 0, 0},
		{EntityType.ENTITY_WALKINGBOIL, 1, 0},
		{EntityType.ENTITY_KEEPER, 0, 0},
		{EntityType.ENTITY_BUTTLICKER, 0, 0},
		FiendFolio.ENT("Sniffle"),
		FiendFolio.ENT("TadoKid"),
		FiendFolio.ENT("Tot"),
		FiendFolio.ENT("Sackboy"),
		FiendFolio.ENT("Sourpatch"),
		FiendFolio.ENT("Warhead"),
		FiendFolio.ENT("Spitum"),
		FiendFolio.ENT("CreepyMaggot"),
		FiendFolio.ENT("Carrot"),
		FiendFolio.ENT("Mothman"),
		FiendFolio.ENT("Grape"),
		FiendFolio.ENT("Ragurge"),
		FiendFolio.ENT("Stingler"),
		FiendFolio.ENT("DesirerWaning"),
		FiendFolio.ENT("Devourer"),
		FiendFolio.ENT("RedSmidgen"),
		--{FiendFolio.FF.ShrunkenHead.ID, FiendFolio.FF.ShrunkenHead.Var, 3},
	},
	[6] = { -- Flooded Caves
		{EntityType.ENTITY_SKINNY, 1, 0},
		{EntityType.ENTITY_FATTY, 1, 0},
		{EntityType.ENTITY_CHARGER, 1, 0},
		{EntityType.ENTITY_BOOMFLY, 2, 0},
		{EntityType.ENTITY_ROUND_WORM, 1, 0},
		FiendFolio.ENT("Fishface"),
		FiendFolio.ENT("BubbleBat"),
		FiendFolio.ENT("Nimbus"),
		FiendFolio.ENT("BubbleBaby"),
		FiendFolio.ENT("Cistern"),
		FiendFolio.ENT("Globulon"),
		FiendFolio.ENT("Offal"),
		FiendFolio.ENT("Drop"),
		FiendFolio.ENT("LightningFly"),
		FiendFolio.ENT("Volt"),
		FiendFolio.ENT("ErodedSmidgen"),
		FiendFolio.ENT("Madclaw"),
		FiendFolio.ENT("Aquabab"),
		FiendFolio.ENT("Isopoly"),
		FiendFolio.ENT("Floodface"),
		FiendFolio.ENT("Puffer"),
		FiendFolio.ENT("Squid"),
		FiendFolio.ENT("DrownedSpitty"),
	},
	[7] = { -- Depths
		{EntityType.ENTITY_GLOBIN, 0, 0},
		{EntityType.ENTITY_BABY, 0, 0},
		{EntityType.ENTITY_LEAPER, 0, 0},
		{EntityType.ENTITY_KNIGHT, 0, 0},
		{EntityType.ENTITY_FAT_SACK, 0, 0},
		{EntityType.ENTITY_TUMOR, 0, 0},
		{EntityType.ENTITY_GUTS, 0, 0},
		{EntityType.ENTITY_SQUIRT, 0, 0},
		FiendFolio.ENT("Sundae"),
		FiendFolio.ENT("Ghostse"),
		FiendFolio.ENT("Gnawful"),
		FiendFolio.ENT("CornLoad"),
		FiendFolio.ENT("HollowKnight"),
		FiendFolio.ENT("Squire"),
		FiendFolio.ENT("Smasher"),
		FiendFolio.ENT("ThousandEyes"),
		FiendFolio.ENT("Peekaboo"),
		FiendFolio.ENT("PaleLoafer"),
		FiendFolio.ENT("Flanks"),
		FiendFolio.ENT("PaleBleeder"),
	},
	[8] = { -- Necropolis
		{EntityType.ENTITY_GLOBIN, 0, 0},
		{EntityType.ENTITY_BONY, 0, 0},
		{EntityType.ENTITY_BABY, 0, 0},
		{EntityType.ENTITY_LEAPER, 0, 0},
		{EntityType.ENTITY_FLOATING_KNIGHT, 0, 0},
		{EntityType.ENTITY_FAT_SACK, 0, 0},
		{EntityType.ENTITY_DEATHS_HEAD, 0, 0},
		{EntityType.ENTITY_HANGER, 0, 0},
		FiendFolio.ENT("DoomFly"), -- Doom Fly
		FiendFolio.ENT("Jawbone"),
		FiendFolio.ENT("Sternum"),
		FiendFolio.ENT("Splodum"),
		FiendFolio.ENT("ToxicKnight"),
		FiendFolio.ENT("Crepitus"),
		FiendFolio.ENT("BoneWorm"),
		FiendFolio.ENT("Spinny"),
		FiendFolio.ENT("Carrier"),
		FiendFolio.ENT("Fracture"),
		FiendFolio.ENT("Desirer"),
		FiendFolio.ENT("Indulger"),
		FiendFolio.ENT("Possessed"),
	},
	[9] = { -- Dank Depths
		{EntityType.ENTITY_GLOBIN, 2, 0},
		{EntityType.ENTITY_LEAPER, 1, 0},
		{EntityType.ENTITY_GUTS, 2, 0},
		{EntityType.ENTITY_SQUIRT, 1, 0},
		{EntityType.ENTITY_CLOTTY, 1, 0},
		{EntityType.ENTITY_CHARGER, 2, 0},
		{EntityType.ENTITY_BUTT_SLICKER, 0, 0},
		{EntityType.ENTITY_DEATHS_HEAD, 1, 0},
		FiendFolio.ENT("Squidge"),
		FiendFolio.ENT("Melty"),
		FiendFolio.ENT("Pitcher"),
		FiendFolio.ENT("Gunk"),
		FiendFolio.ENT("Guflush"),
		FiendFolio.ENT("LitterBug"),
		FiendFolio.ENT("TrashbaggerDank"),
		FiendFolio.ENT("SkuzzballSmall"),
		FiendFolio.ENT("Gobhopper"),
		FiendFolio.ENT("Gis"),
		FiendFolio.ENT("Piper"),
		FiendFolio.ENT("Slimer"),
	},
	[10] = { -- Womb
		{EntityType.ENTITY_LEECH, 0, 0},
		{EntityType.ENTITY_LUMP, 0, 0},
		{EntityType.ENTITY_PARA_BITE, 0, 0},
		{EntityType.ENTITY_FRED, 0, 0},
		{EntityType.ENTITY_FLESH_MOBILE_HOST, 0, 0},
		{EntityType.ENTITY_GLOBIN, 1, 0},
		FiendFolio.ENT("Drooler"),
		FiendFolio.ENT("Chunky"),
		FiendFolio.ENT("MotorNeuron"),
		FiendFolio.ENT("Berry"),
		FiendFolio.ENT("RedBony"),
		FiendFolio.ENT("Glorf"),
		FiendFolio.ENT("Neonate"),
		FiendFolio.ENT("Warble"),
		FiendFolio.ENT("Strobila"),
		FiendFolio.ENT("Chops"),
		FiendFolio.ENT("Toothache"),
		FiendFolio.ENT("Magleech"),
		FiendFolio.ENT("Retch"),
	},
	[11] = { -- Utero
		{EntityType.ENTITY_GUTS, 0, 0},
		{EntityType.ENTITY_BRAIN, 0, 0},
		{EntityType.ENTITY_LEECH, 0, 0},
		{EntityType.ENTITY_MEATBALL, 0, 0},
		{EntityType.ENTITY_PEEPER_FATTY, 0, 0},
		{EntityType.ENTITY_GLOBIN, 1, 0},
		FiendFolio.ENT("Valvo"),
		FiendFolio.ENT("Peepling"),
		FiendFolio.ENT("SaggingSucker"),
		FiendFolio.ENT("Tittle"),
		FiendFolio.ENT("TrickleFly"),
		FiendFolio.ENT("Minimoon"),
		FiendFolio.ENT("Heartbeat"),
		FiendFolio.ENT("Stiffany"),
		FiendFolio.ENT("NuchalDetached"),
		FiendFolio.ENT("Nuchal"),
		FiendFolio.ENT("Punted"),
		FiendFolio.ENT("Amoeba"),
	},
	[12] = { -- Scarred Womb
		{EntityType.ENTITY_GUTS, 1, 0},
		{EntityType.ENTITY_LUMP, 0, 0},
		{EntityType.ENTITY_PARA_BITE, 1, 0},
		{EntityType.ENTITY_FRED, 0, 0},
		{EntityType.ENTITY_LEPER, 0, 2},
		{EntityType.ENTITY_FISTULOID, 0, 0},
		FiendFolio.ENT("Facade"),
		FiendFolio.ENT("Incisor"),
		FiendFolio.ENT("Mouthful"),
		FiendFolio.ENT("Starving"),
		FiendFolio.ENT("Gleek"),
		FiendFolio.ENT("Brooter"),
		FiendFolio.ENT("Curdle"),
		FiendFolio.ENT("Myiasis"),
		FiendFolio.ENT("Lipoma"),
		FiendFolio.ENT("Nailhead"),
		FiendFolio.ENT("Vacuole"),
		FiendFolio.ENT("Bloomer"),
		{FiendFolio.FF.Contestant.ID, FiendFolio.FF.Contestant.Var, 1},
	},
	[14] = { -- Sheol
		{EntityType.ENTITY_LEECH, 1, 0},
		{EntityType.ENTITY_NULLS, 0, 0},
		{EntityType.ENTITY_BLACK_BONY, 0, 0},
		{EntityType.ENTITY_BLACK_GLOBIN_BODY, 0, 0},
		{EntityType.ENTITY_BLACK_GLOBIN_HEAD, 0, 0},
		FiendFolio.ENT("Crosseyes"),
		FiendFolio.ENT("Foreseer"),
		FiendFolio.ENT("PsiKnight"),
		FiendFolio.ENT("PsionLeech"),
		FiendFolio.ENT("Psiling"),
		FiendFolio.ENT("Dominated"),
		FiendFolio.ENT("UmbraBlistered"),
		FiendFolio.ENT("Thrall"),
		FiendFolio.ENT("SoulSpooter"),
		FiendFolio.ENT("Imperialist"),
		FiendFolio.ENT("SplitEar"),
		FiendFolio.ENT("Cochlea"),
		FiendFolio.ENT("Premonition"),
		FiendFolio.ENT("Toad"),
	},
	[15] = { -- Cathedral
		{EntityType.ENTITY_LEECH, 2, 0},
		{EntityType.ENTITY_WIZOOB, 0, 0},
		{EntityType.ENTITY_THE_HAUNT, 10, 0},
		{EntityType.ENTITY_BABY, 1, 0},
		{EntityType.ENTITY_CLOTTY, 2, 0},
		{EntityType.ENTITY_MAW, 2, 0},
		FiendFolio.ENT("Chorister"),
		FiendFolio.ENT("Effigy"),
		FiendFolio.ENT("Dangler"),
		FiendFolio.ENT("Primemind"),
		FiendFolio.ENT("ArmouredLooker"),
		FiendFolio.ENT("Cherub"),
		FiendFolio.ENT("Enlightened"),
		FiendFolio.ENT("HolyClotty"),
		FiendFolio.ENT("HolyDrumstick"),
		FiendFolio.ENT("Ghastly"),
		{FiendFolio.FF.Cherubskull.ID, FiendFolio.FF.Cherubskull.Var, 5},
	},
	[31] = { --Downpour
		{EntityType.ENTITY_CLOTTY, 0, 0},
		{EntityType.ENTITY_BUBBLES, 0, 0},
		{EntityType.ENTITY_WRAITH, 0, 0},
		{EntityType.ENTITY_SMALL_LEECH, 0, 0},
		{EntityType.ENTITY_BLURB, 0, 0},
		{EntityType.ENTITY_PREY, 0, 0},
		{EntityType.ENTITY_WILLO, 0, 0},
		{EntityType.ENTITY_WILLO_L2, 0, 0},
		{EntityType.ENTITY_STRIDER, 0, 0},
		{EntityType.ENTITY_POLTY, 0, 0},
		{EntityType.ENTITY_BLOATY, 0, 0},
		FiendFolio.ENT("Buckethead"),
		FiendFolio.ENT("MrSubHorf"),
		FiendFolio.ENT("Mayfly"),
		FiendFolio.ENT("Mightfly"),
		FiendFolio.ENT("Dewdrop"),
		FiendFolio.ENT("MiniMin"),
		FiendFolio.ENT("Bubby"),
		FiendFolio.ENT("RiftWalker"),
		FiendFolio.ENT("FogStalker"),
		FiendFolio.ENT("Buoy"),
		FiendFolio.ENT("Skipper"),
	},
	[45] = { --Dross
		{EntityType.ENTITY_CLOGGY, 0, 0},
		{EntityType.ENTITY_BUBBLES, 0, 0},
		{EntityType.ENTITY_WRAITH, 0, 0},
		{EntityType.ENTITY_SMALL_LEECH, 0, 0},
		{EntityType.ENTITY_BLURB, 0, 0},
		{EntityType.ENTITY_PREY, 0, 0},
		{EntityType.ENTITY_DRIP, 0, 0},
		{EntityType.ENTITY_DIP, 3, 0},
		{EntityType.ENTITY_FARTIGAN, 0, 0},
		{EntityType.ENTITY_DUMP, 0, 0},
		{EntityType.ENTITY_DUMP, 1, 0},
		FiendFolio.ENT("Buckethead"),
		FiendFolio.ENT("MrSubHorf"),
		FiendFolio.ENT("Mayfly"),
		FiendFolio.ENT("Mightfly"),
		FiendFolio.ENT("Dollop"),
		FiendFolio.ENT("Residuum"),
		FiendFolio.ENT("Pipeneck"),
		FiendFolio.ENT("Shottie"),
		FiendFolio.ENT("Wasty"),
		FiendFolio.ENT("Stomy"),
		FiendFolio.ENT("Delinquent"),
		FiendFolio.ENT("Cathy"),
		FiendFolio.ENT("Fishy"),
	},
	[32] = { --Mines
		{EntityType.ENTITY_FLY_BOMB, 0, 0},
		{EntityType.ENTITY_ROCK_SPIDER, 0, 0},
		{EntityType.ENTITY_ROCK_SPIDER, 2, 0},
		{EntityType.ENTITY_BOOMFLY, 3, 0},
		{EntityType.ENTITY_GURGLE, 0, 0},
		{EntityType.ENTITY_BOUNCER, 0, 0},
		{EntityType.ENTITY_QUAKEY, 0, 0},
		{EntityType.ENTITY_GYRO, 0, 0},
		{EntityType.ENTITY_FACELESS, 0, 0},
		{EntityType.ENTITY_MOLE, 0, 0},
		{EntityType.ENTITY_PON, 0, 0},
		FiendFolio.ENT("Coalby"),
		FiendFolio.ENT("Cappin"),
		FiendFolio.ENT("Glob"),
		FiendFolio.ENT("Grazer"),
		FiendFolio.ENT("Technician"),
		FiendFolio.ENT("ShockCollar"),
		FiendFolio.ENT("Quaker"),
		FiendFolio.ENT("Spanky"),
	},
	[46] = { --Ashpit
		{EntityType.ENTITY_ROCK_SPIDER, 0, 0},
		{EntityType.ENTITY_BOOMFLY, 3, 0},
		{EntityType.ENTITY_GURGLE, 1, 0},
		{EntityType.ENTITY_BOOMFLY, 4, 0},
		{EntityType.ENTITY_BIG_BONY, 0, 0},
		{EntityType.ENTITY_FLESH_MAIDEN, 0, 0},
		{EntityType.ENTITY_DEATHS_HEAD, 4, 0},
		{EntityType.ENTITY_CLICKETY_CLACK, 0, 0},
		{EntityType.ENTITY_CHARGER, 3, 0},
		FiendFolio.ENT("Coalby"),
		FiendFolio.ENT("Cappin"),
		FiendFolio.ENT("FleshSistern"),
		FiendFolio.ENT("Shellmet"),
		FiendFolio.ENT("DryWheeze"),
		FiendFolio.ENT("Marlin"),
		FiendFolio.ENT("Fishfreak"),
		FiendFolio.ENT("SkitterSkull"),
		FiendFolio.ENT("Hangman"),
		FiendFolio.ENT("Blasted"),
		FiendFolio.ENT("LittleBoy"),
		FiendFolio.ENT("FosterFly"),
		FiendFolio.ENT("UraniumSpider"),
		FiendFolio.ENT("Briar"),
		--{FiendFolio.FF.Ztewie.ID, FiendFolio.FF.Ztewie.Var, 3},
	},
	[33] = { --Mausoleum
		{EntityType.ENTITY_BABY_BEGOTTEN, 0, 0},
		{EntityType.ENTITY_WHIPPER, 0, 0},
		{EntityType.ENTITY_WHIPPER, 1, 0},
		{EntityType.ENTITY_REVENANT, 0, 0},
		{EntityType.ENTITY_VIS_FATTY, 1, 0},
		{EntityType.ENTITY_KNIGHT, 2, 0},
		{EntityType.ENTITY_CANDLER, 0, 0},
		{EntityType.ENTITY_POLTY, 1, 0},
		FiendFolio.ENT("Acolyte"),
		FiendFolio.ENT("Skulltist"),
		FiendFolio.ENT("Psyclopia"),
		FiendFolio.ENT("Peon"),
		FiendFolio.ENT("Shaker"),
		FiendFolio.ENT("Clergy"),
		FiendFolio.ENT("PsychoKnight"),
		FiendFolio.ENT("Sixth"),
		FiendFolio.ENT("Morvid"),
		FiendFolio.ENT("PsychoFly"),
		FiendFolio.ENT("Madhat"),
		FiendFolio.ENT("Empath"),
	},
	[40] = {
		{EntityType.ENTITY_BABY_BEGOTTEN, 0, 0},
		{EntityType.ENTITY_WHIPPER, 0, 0},
		{EntityType.ENTITY_WHIPPER, 1, 0},
		{EntityType.ENTITY_REVENANT, 0, 0},
		{EntityType.ENTITY_VIS_FATTY, 1, 0},
		{EntityType.ENTITY_KNIGHT, 2, 0},
		{EntityType.ENTITY_CANDLER, 0, 0},
		{EntityType.ENTITY_POLTY, 1, 0},
		FiendFolio.ENT("Acolyte"),
		FiendFolio.ENT("Skulltist"),
		FiendFolio.ENT("Psyclopia"),
		FiendFolio.ENT("Peon"),
		FiendFolio.ENT("Shaker"),
		FiendFolio.ENT("Clergy"),
		FiendFolio.ENT("PsychoKnight"),
		FiendFolio.ENT("Sixth"),
		FiendFolio.ENT("Morvid"),
		FiendFolio.ENT("PsychoFly"),
		FiendFolio.ENT("Madhat"),
		FiendFolio.ENT("Empath"),
	},
	[41] = {
		{EntityType.ENTITY_BABY_BEGOTTEN, 0, 0},
		{EntityType.ENTITY_WHIPPER, 0, 0},
		{EntityType.ENTITY_WHIPPER, 1, 0},
		{EntityType.ENTITY_REVENANT, 0, 0},
		{EntityType.ENTITY_VIS_FATTY, 1, 0},
		{EntityType.ENTITY_KNIGHT, 2, 0},
		{EntityType.ENTITY_CANDLER, 0, 0},
		{EntityType.ENTITY_POLTY, 1, 0},
		FiendFolio.ENT("Acolyte"),
		FiendFolio.ENT("Skulltist"),
		FiendFolio.ENT("Psyclopia"),
		FiendFolio.ENT("Peon"),
		FiendFolio.ENT("Shaker"),
		FiendFolio.ENT("Clergy"),
		FiendFolio.ENT("PsychoKnight"),
		FiendFolio.ENT("Sixth"),
		FiendFolio.ENT("Morvid"),
		FiendFolio.ENT("PsychoFly"),
		FiendFolio.ENT("Madhat"),
		FiendFolio.ENT("Empath"),
	},
	[42] = {
		{EntityType.ENTITY_BABY_BEGOTTEN, 0, 0},
		{EntityType.ENTITY_WHIPPER, 0, 0},
		{EntityType.ENTITY_WHIPPER, 1, 0},
		{EntityType.ENTITY_REVENANT, 0, 0},
		{EntityType.ENTITY_VIS_FATTY, 1, 0},
		{EntityType.ENTITY_KNIGHT, 2, 0},
		{EntityType.ENTITY_CANDLER, 0, 0},
		{EntityType.ENTITY_POLTY, 1, 0},
		FiendFolio.ENT("Acolyte"),
		FiendFolio.ENT("Skulltist"),
		FiendFolio.ENT("Psyclopia"),
		FiendFolio.ENT("Peon"),
		FiendFolio.ENT("Shaker"),
		FiendFolio.ENT("Clergy"),
		FiendFolio.ENT("PsychoKnight"),
		FiendFolio.ENT("Sixth"),
		FiendFolio.ENT("Morvid"),
		FiendFolio.ENT("PsychoFly"),
		FiendFolio.ENT("Madhat"),
		FiendFolio.ENT("Empath"),
	},
	[47] = { --Gehenna
		{EntityType.ENTITY_BABY_BEGOTTEN, 0, 0},
		{EntityType.ENTITY_WHIPPER, 0, 0},
		{EntityType.ENTITY_WHIPPER, 1, 0},
		{EntityType.ENTITY_REVENANT, 0, 0},
		{EntityType.ENTITY_VIS_FATTY, 1, 0},
		{EntityType.ENTITY_GOAT, 0, 0},
		{EntityType.ENTITY_CULTIST, 1, 0},
		{EntityType.ENTITY_KNIGHT, 4, 0},
		FiendFolio.ENT("Acolyte"),
		FiendFolio.ENT("Skulltist"),
		FiendFolio.ENT("ManicFly"),
		FiendFolio.ENT("Bull"),
		FiendFolio.ENT("SuperShottie"),
		FiendFolio.ENT("Nobody"),
		FiendFolio.ENT("Tagbag"),
		FiendFolio.ENT("Gabber"),
		FiendFolio.ENT("Kukodemon"),
		FiendFolio.ENT("NewYear"),
	},
	[34] = { --Corpse
		{EntityType.ENTITY_BABY, 3, 0},
		{EntityType.ENTITY_UNBORN, 0, 0},
		{EntityType.ENTITY_SMALL_MAGGOT, 0, 0},
		{EntityType.ENTITY_BOOMFLY, 5, 0},
		{EntityType.ENTITY_SUCKER, 4, 0},
		{EntityType.ENTITY_GAPER, 3, 0},
		{EntityType.ENTITY_TWITCHY, 0, 0},
		{EntityType.ENTITY_GAPER_L2, 2, 0},
		{EntityType.ENTITY_CYST, 0, 0},
		{EntityType.ENTITY_FLOATING_HOST, 0, 0},
		{EntityType.ENTITY_EVIS, 0, 0},
		{EntityType.ENTITY_CHARGER_L2, 0, 0},
		FiendFolio.ENT("Marzy"),
		FiendFolio.ENT("Rotdrink"),
		FiendFolio.ENT("Spoilie"),
		FiendFolio.ENT("SaggingSpit"),
		FiendFolio.ENT("Droolie"),
		FiendFolio.ENT("GutKnight"),
		FiendFolio.ENT("Fingore"),
		FiendFolio.ENT("Putrefatty"),
		FiendFolio.ENT("CancerBoy"),
		FiendFolio.ENT("Brandon"),
		FiendFolio.ENT("ConglobberateMedium"),
		FiendFolio.ENT("Oralid"),
		FiendFolio.ENT("Quitter"),
		FiendFolio.ENT("Benny"),
		{FiendFolio.FF.Bub.ID, FiendFolio.FF.Bub.Var, 6},
		{FiendFolio.FF.Molly.ID, FiendFolio.FF.Molly.Var, 2},
	},
	[43] = {
		{EntityType.ENTITY_BABY, 3, 0},
		{EntityType.ENTITY_UNBORN, 0, 0},
		{EntityType.ENTITY_SMALL_MAGGOT, 0, 0},
		{EntityType.ENTITY_BOOMFLY, 5, 0},
		{EntityType.ENTITY_SUCKER, 4, 0},
		{EntityType.ENTITY_GAPER, 3, 0},
		{EntityType.ENTITY_TWITCHY, 0, 0},
		{EntityType.ENTITY_GAPER_L2, 2, 0},
		{EntityType.ENTITY_CYST, 0, 0},
		{EntityType.ENTITY_FLOATING_HOST, 0, 0},
		{EntityType.ENTITY_EVIS, 0, 0},
		{EntityType.ENTITY_CHARGER_L2, 0, 0},
		FiendFolio.ENT("Marzy"),
		FiendFolio.ENT("Rotdrink"),
		FiendFolio.ENT("Spoilie"),
		FiendFolio.ENT("SaggingSpit"),
		FiendFolio.ENT("Droolie"),
		FiendFolio.ENT("GutKnight"),
		FiendFolio.ENT("Fingore"),
		FiendFolio.ENT("Putrefatty"),
		FiendFolio.ENT("CancerBoy"),
		FiendFolio.ENT("Brandon"),
		FiendFolio.ENT("ConglobberateMedium"),
		FiendFolio.ENT("Oralid"),
		FiendFolio.ENT("Quitter"),
		FiendFolio.ENT("Benny"),
		{FiendFolio.FF.Bub.ID, FiendFolio.FF.Bub.Var, 6},
		{FiendFolio.FF.Molly.ID, FiendFolio.FF.Molly.Var, 2},
	},
	[44] = {
		{EntityType.ENTITY_BABY, 3, 0},
		{EntityType.ENTITY_UNBORN, 0, 0},
		{EntityType.ENTITY_SMALL_MAGGOT, 0, 0},
		{EntityType.ENTITY_BOOMFLY, 5, 0},
		{EntityType.ENTITY_SUCKER, 4, 0},
		{EntityType.ENTITY_GAPER, 3, 0},
		{EntityType.ENTITY_TWITCHY, 0, 0},
		{EntityType.ENTITY_GAPER_L2, 2, 0},
		{EntityType.ENTITY_CYST, 0, 0},
		{EntityType.ENTITY_FLOATING_HOST, 0, 0},
		{EntityType.ENTITY_EVIS, 0, 0},
		{EntityType.ENTITY_CHARGER_L2, 0, 0},
		FiendFolio.ENT("Marzy"),
		FiendFolio.ENT("Rotdrink"),
		FiendFolio.ENT("Spoilie"),
		FiendFolio.ENT("SaggingSpit"),
		FiendFolio.ENT("Droolie"),
		FiendFolio.ENT("GutKnight"),
		FiendFolio.ENT("Fingore"),
		FiendFolio.ENT("Putrefatty"),
		FiendFolio.ENT("CancerBoy"),
		FiendFolio.ENT("Brandon"),
		FiendFolio.ENT("ConglobberateMedium"),
		FiendFolio.ENT("Oralid"),
		FiendFolio.ENT("Quitter"),
		FiendFolio.ENT("Benny"),
		{FiendFolio.FF.Bub.ID, FiendFolio.FF.Bub.Var, 6},
		{FiendFolio.FF.Molly.ID, FiendFolio.FF.Molly.Var, 2},
	},
}

-- Table for random Lil Portal spawns
FiendFolio.lilportalreplacement = {
	[1] = { -- Flying and Landbound
		FiendFolio.ENT("Spitroast"),
		FiendFolio.ENT("Mayfly"),
		--FiendFolio.ENT("Grape"),
		FiendFolio.ENT("Beeter"),
		FiendFolio.ENT("ShotFly"),
		FiendFolio.ENT("Shoter"),
		FiendFolio.ENT("LightningFly"),
		FiendFolio.ENT("Skuzz"),
		FiendFolio.ENT("Beetle"),
	},
	[2] = { -- Only Flying
		FiendFolio.ENT("Spitroast"),
		FiendFolio.ENT("Mayfly"),
		--FiendFolio.ENT("Grape"),
		FiendFolio.ENT("Beeter"),
		FiendFolio.ENT("ShotFly"),
		FiendFolio.ENT("Shoter"),
		FiendFolio.ENT("LightningFly"),
	},
	[3] = { -- Full Spider, kinda rare
		FiendFolio.ENT("FullSpider"),
	},
}

--Might not change this since portals won't be in greed mode anymore
--keeping for legacy reasons
FiendFolio.greedportalreplacement = {
	[1] = { --basement
		{960, 10, 0}, -- dung
		{960, 770, 0}, --mr horf
		{960, 772, 0}, --mr redhorf
		{960, 820, 0}, --slim
		{960, 830, 0}, --pester
		{960, 50, 3}, --morsel
		{960, 50, 4}, --morsel
		{960, 180, 0}, --beeter
		{960, 230, 0}, --haunted
		{960, 610, 0}, --hover
		{960, 310, 0}, --woodburner
		{61, 960, 0}, --spitroast
		{960, 351, 0}, --mote
		{960, 430, 0}, --charlie
		{960, 431, 0}, --sootie
		{208, 963, 0}, --big smoke
		{960, 550, 0}, --mulikaboom
		{951, 0, 0}, --slammer
		{951, 1, 0}, --wimpy
		{951, 5, 0}, --smore
	},
	[2] = { --caves
		{666, 40, 0}, -- foamy
		{960, 610, 0}, --hover
		{960, 230, 0}, --haunted
		{960, 170, 0}, --balor
		{960, 171, 0}, --eyesore
		{666, 50, 0}, --fathead
		{960, 690, 0}, --fishaac
		{960, 80, 1000}, --dweller
		{953, 0, 0}, --sniffle
		{960, 210, 0}, --tadokid
		{29, 961, 0}, --spinneretch
		{750, 80, 0}, --sackboy
		{960, 360, 0}, --sourpatch
		{750, 100, 0}, --ragurge
		{21, 666, 0}, --nimbus
		{666, 1, 0}, --sundae
		{666, 2, 0}, --scoop
		{25, 962, 0}, --warhead
		{960, 681, 0}, --stingler
		{960, 2001, 0}, --cordycep
	},
	[3] = { --depths
		{666, 0, 0}, --soft serve
		{666, 1, 0}, --sundae
		{951, 4, 0}, --pale slammer
		{960, 80, 1000}, --dweller
		{960, 270, 0}, --ghostse
		{25, 960, 0}, --doom fly
		{960, 660, 0}, --scythe rider
		{23, 961, 0}, --splodum
		{227, 750, 0}, --posessed
		{227, 666, 0}, --crepitus
		{750, 140, 0}, --bone slammer
		{666, 150, 0}, --calzone
		{610, 0, 0}, --dangler
		{208, 960, 0}, --squidge
		{960, 100, 0}, --gunk
		{970, 50, 0}, --melty
		{970, 60, 0}, --pitcher
		{960, 650, 0}, --piper
		{808, 115, 0}, --guflush
		{666, 81, 0}, --skuzz
	},
	[4] = { --womb
		{666, 150, 0}, --calzone
	},
	[5] = { --sheol
		{666, 80, 0}, --skuzz
		{960, 660, 0}, --scythe rider
	},
	[6] = { --shop
		{610, 0, 0}, --dangler
	},
}

--a blot animation variant is the spritesheet's file name without the monster_blot_ and without the extension
FiendFolio.blotAnimationVariants = {
	{
		name = "default",
		weight = 25
	},
	{
		name = "ash",
		weight = 25
	},
	{
		name = "bones",
		weight = 5
	},
	{
		name = "corn",
		weight = 20
	},
	{
		name = "mouth",
		weight = 20
	},
	{
		name = "skin",
		weight = 15
	},
	{
		name = "tall",
		weight = 10
	},
	{
		name = "teeth",
		weight = 15
	},
	{
		name = "vanilla",
		weight = 10
	},
	{
		name = "gish",
		weight = 20
	},
	--[[{
		name = "hole",
		weight = 20
	}]]--
}

FiendFolio["Spec" .. "Render"] = "gfx/bosses/cacophobia/caco_eye.anm2"

FiendFolio.entityNameFromTV = { -- Name tags disabled for now, the tables haven't been updated!!
	--[[
	[16] = {
		[960] = "Facade",
	},
	[21] = {
		[666] = "Nimbus",
		[750] = "Creepy Maggot",
		[960] = "Roly Poly",
		[961] = "Psionic Knight",
	},
	[22] = {
		[666] = "Cistern",
	},
	[23] = {
		[960] = "Sternum",
		[961] = "Splodum",
		[1700] = "Reheated Charger",
	},
	[25] = {
		[960] = "Doom Fly",
		[961] = "Golden Boom Fly",
		[962] = "Warhead",
		[963] = "Drainer",
	},
	[27] = {
		[710] = "Reheated Host",
		[711] = "Reheated Host",
		[712] = "Reheated Host",
	},
	[29] = {
		[960] = "Tot",
		[961] = "Spinneretch",
		[962] = "Sourpatch Head",
	},
	[30] = {
		[960] = "Sticky Sack",
	},
	[42] = {
		[960] = "Wetstone",
		[961] = "Cauldron",
		[962] = "Furnace",
	},
	[44] = {
		[1710] = "Septic Pipe",
		[1711] = "Sewer Pipe",
		[1712] = "Sludge Pipe",
		[1713] = "Sphincter",
		[1714] = "Split Pipe",
	},
	[61] = {
		[960] = "Spitroast",
	},
	[85] = {
		[960] = "Spooter",
		[961] = "Super Spooter",
		[962] = "Baby Spider",
	},
	[87] = {
		[710] = "Reheated Gurgle",
	},
	[88] = {
		[960] = "Walking Sticky Sack",
	},
	[207] = {
		[960] = "Gutbuster",
	},
	[208] = {
		[960] = "Squidge",
		[961] = "Tubby",
		[962] = "Mouthful",
		[963] = "Big Smoke",
	},
	[214] = {
		[710] = "Icky Fly",
		[711] = "Bobby Fly",
		[712] = "Reheated Fly",
		[713] = "Sacky Fly",
		[714] = "Chompy Fly",
		[715] = "Ticking Fly",
	},
	[215] = {
		[710] = "Full Spider",
		[711] = "Bobby Spider",
		[712] = "Reheated Spider",
		[713] = "Sacky Spider",
		[714] = "Icky pider",
		[715] = "Chompy Spider",
	},
	[217] = {
		[960] = "Spark",
	},
	[218] = {
		[750] = "Banshee",
	},
	[227] = {
		[666] = "Crepitus",
		[667] = "Mr. Bones",
		[750] = "Possessed",
		[960] = "Hollow Knight",
		[961] = "Powderkeg",
	},
	[234] = {
		[960] = "Jawbone",
	},
	[240] = {
		[700] = "Fried",
		[701] = "Ogre Creep",
		[710] = "Icky Creep",
		[711] = "Techy Creep",
	},
	[244] = {
		[960] = "Bone Worm",
	},
	[258] = {
		[960] = "Bubble Bat",
		[961] = "Ribbone",
	},
	[284] = {
		[710] = "Reheated Cyclopia",
	},
	[666] = {
		[0] = "Soft Serve",
		[1] = "Sundae",
		[2] = "Scoop",
		[10] = "Load",
		[11] = "Corn Load",
		[20] = "Baro",
		[30] = "Chorister",
		[40] = "Foamy",
		[50] = "Fathead",
		[60] = "Skuzz",
		[70] = "Ransacked",
		[80] = "Skuzzball",
		[81] = "Skuzzball (Small)",
		[90] = "Boiler",
		[100] = "Drink Worm",
		[110] = "Wobbles",
		[120] = "Sludge Host",
		[130] = "Creepterum",
		[131] = "Corposlave",
		[140] = "Curdle",
		[141] = "Curdle",
		[150] = "Calzone",
		[180] = "Marge",
		[200] = "Patzer",
	},
	[610] = {
		[0] = "Dangler",
	},
	[709] = {
		[0] = "Congression",
		[1] = "Congression",
	},
	[750] = {
		[10] = "Possessed",
		[20] = "Moaner",
		[30] = "Unpawtunate",
		[40] = "Unpawtunate Skull",
		[50] = "Mama Pooter",
		[60] = "Gravedigger",
		[70] = "Gravefire",
		[80] = "Sackboy",
		[90] = "Gnawful",
		[100] = "Ragurge",
		[110] = "Wick",
		[130] = "Infected Mushroom",
		[140] = "Cracker",
		[150] = "Nuchal",
		[151] = "Nuchal",
		[152] = "Nuchal Cord",
	},
	[808] = {
		[110] = "Womb Pillar",
		[111] = "Watcher",
		[112] = "Watcher's Eye",
		[113] = "Mistmonger",
		[114] = "Cordend",
		[115] = "Guflush",
	},
	[812] = {
		[0] = "Valvo",
		[1] = "Sombra",
	},
	[920] = {
		[222] = "Onlooker",
	},
	[940] = {
		[0] = "Honey Eye",
	},
	[951] = {
		[0] = "Slammer",
		[1] = "Wimpy",
		[2] = "Stoney Slammer",
		[3] = "Crazy Stoney Slammer",
		[4] = "Smasher",
		[5] = "S'More",
		[6] = "S'Eptic",
	},
	[952] = {
		[0] = "Square Fly",
		[1] = "Square Fly",
	},
	[953] = {
		[0] = "Sniffle",
	},
	[954] = {
		[0] = "Snagger",
	},
	[955] = {
		[0] = "Weaver",
		[1] = "Weaver Sr.",
		[1] = "Dread Weaver",
		[1] = "Thread"
	},
	[956] = {
		[0] = "Craterface",
		[69] = "Drooler",
		[666] = "Blazer",
	},
	[959] = {
		[0] = "Psion",
	},
	[960] = {
		[0] = "Poople",
		[10] = "Dung",
		[20] = "Nerve",
		[30] = "Meatwad",
		[31] = "Slag",
		[32] = "Pox",
		[33] = "Haunch",
		[40] = "Offal",
		[50] = "Morsel",
		[60] = "Frog",
		[70] = "Motor Neuron",
		[80] = "Dweller",
		[81] = "Dweller Brother",
		[90] = "Warty",
		[100] = "Gunk",
		[101] = "Punk",
		[110] = "Gleek",
		[120] = "Ribeye",
		[130] = "Cortex",
		[140] = "Gorger",
		[150] = "Drip",
		[151] = "Dribble",
		[160] = "Fossil",
		[161] = "Sentry",
		[170] = "Balor",
		[171] = "Eyesore",
		[172] = "Gander",
		[180] = "Beeter",
		[190] = "Lil' Jon",
		[200] = "Crosseyes",
		[210] = "Tado Kid",
		[220] = "Toxic Knight",
		[230] = "Haunted",
		[231] = "Yawner",
		[240] = "Fishface",
		[241] = "* Fishface *",
		[250] = "Bubble Blowing Double Baby",
		[260] = "Spitum",
		[270] = "Ghostse",
		[271] = "Ghostse (Easy Mode)",
		[280] = "Mr. Flare",
		[281] = "Mr. Crisply",
		[290] = "Incisor",
		[300] = "Starving",
		[310] = "Woodburner",
		[311] = "Woodburner (Easy Mode)",
		[320] = "Milk Tooth",
		[330] = "Squire",
		[340] = "Foreseer",
		[341] = "Psionic Leech",
		[350] = "Fumegeist",
		[351] = "Mote",
		[360] = "Sourpatch",
		[361] = "Sourpatch Body",
		[370] = "Mobile Blood Cell",
		[371] = "Spinning Blood Cell",
		[380] = "Madclaw",
		[390] = "Head Honcho",
		[400] = "Colonel",
		[401] = "Zingling",
		[410] = "Globulon",
		[420] = "Primemind",
		[430] = "Charlie",
		[431] = "Sooty",
		[440] = "Ultimate Smokin",
		[441] = "Smokin",
		[442] = "Flamin",
		[450] = "Flickerspirit",
		[451] = "Eternal Flickerspirit",
		[460] = "Deadfly",
		[470] = "Dogmeat",
		[480] = "Brooter",
		[490] = "Tap",
		[500] = "Tall Boi",
		[501] = "Shitling",
		[510] = "Peepling",
		[520] = "Harletwin",
		[521] = "Effigy",
		[530] = "Gis",
		[540] = "Centipede",
		[550] = "Mullikaboom",
		[560] = "Poobottle",
		[570] = "Grater",
		[580] = "Tombit",
		[581] = "Gravin",
		[590] = "Homer",
		[600] = "Gishle",
		[610] = "Hover",
		[620] = "Sagging Sucker",
		[630] = "Red Horf",
		[640] = "Zapbladder",
		[641] = "Wire",
		[650] = "Piper",
		[660] = "Scythe Rider",
		[670] = "Ms. Dominator",
		[671] = "Dominated",
		[680] = "Fossilized Boom Fly",
		[681] = "Stingler",
		[682] = "Trickle",
		[683] = "Trickle",
		[690] = "Fishaac",
		[700] = "Bumbler",
		[710] = "Menace",
		[711] = "Thousand Eyes",
		[720] = "Warden",
		[730] = "Eroded Host",
		[740] = "Immural",
		[750] = "Shiitake",
		[760] = "Bowler",
		[769] = "Septic Bowler",
		[770] = "Mr. Horf",
		[772] = "Mr. Red Horf",
		[780] = "Cordify",
		[790] = "Spook",
		[800] = "Utero Pillar",
		[801] = "Organelle",
		[810] = "Honeydrip",
		[820] = "Slim",
		[821] = "Pale Slim",
		[830] = "Pester",
		[840] = "Ramblin' Evil Mushroom",
		[850] = "Bola",
		[860] = "Smidgen",
		[861] = "Red Smidgen",
		[870] = "Looker",
		[880] = "Peek-a-boo",
		[881] = "Peek-a-boo's Eye",
		[888] = "Ring of Ring Flies",
		[890] = "Dr. Shambles",
		[900] = "Inner Eye",
		[901] = "Enlightened",
		[910] = "Mr. Gob",
		[911] = "Gob",
		[920] = "Globscraper",
		[930] = "Foe",
		[940] = "Psi Hunter",
		[950] = "Umbra",
		[951] = "Eclipse",
		[960] = "Seeker",
		[970] = "C Word",
		[971] = "Neonate",
		[1000] = "Mother Orb",
		[1001] = "Jackson",
		[1002] = "The Freezer",
		[1003] = "Peat",
		[1710] = "Beserker",
		[1711] = "Binding of Isaac: Reheated",
		[1713] = "Spider (Nicalis)",
		[1715] = "Baba",
		[2000] = "Splattercap",
		[2001] = "Cordycep",
		[2002] = "Berry",
		[2003] = "Spicy Dip",
	},
	[970] = {
		[0] = "Temper",
		[10] = "Spinny",
		[30] = "Lightning Fly",
		[40] = "Blot",
		[50] = "Melty",
		[60] = "Pitcher",
		[70] = "Mutant Horf",
	},]]
}


--VERY IMPORTANT INFORMATION
FiendFolio.Nonmale = {
	{ID = FiendFolio.ENT("Mo"), Affliction = "idk"}, --IMPORTANTE trust trust XD

--Base Game Things (For Sapphic Sapphire)
	{ID = {EntityType.ENTITY_GAPER, 2}, Affliction = "Woman"}, --Flaming Gaper
	{ID = {EntityType.ENTITY_GAPER, 3, 5}, Affliction = "Woman"}, --Jawless Rotten Gaper (Because maria said the perfect woman doesn't talk back)
	{ID = {EntityType.ENTITY_GUSHER}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_POOTER, 1}, Affliction = "Woman"}, --Super Pooter
	{ID = {EntityType.ENTITY_CLOTTY, 3}, Affliction = "Woman"}, --Grilled clotty
	{ID = {EntityType.ENTITY_MULLIGAN, 0}, Affliction = "Woman"}, --Mulligan
	{ID = {EntityType.ENTITY_MULLIGAN, 2}, Affliction = "Woman"}, --Mulliboom
	{ID = {EntityType.ENTITY_HIVE}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_CHARGER, 3}, Affliction = "Woman"}, --Carrion Princess
	{ID = {EntityType.ENTITY_GLOBIN, 1}, Affliction = "Woman"},	--Gazing Globin
	{ID = {EntityType.ENTITY_BOOMFLY, 1}, Affliction = "Woman"}, --Red Boom Fly
	{ID = {EntityType.ENTITY_HOST, 1}, Affliction = "Woman"}, --Red Host
	{ID = {EntityType.ENTITY_HOST, 3}, Affliction = "Woman"}, --Hard Host
	{ID = {EntityType.ENTITY_CHUB, 0}, Affliction = "Woman"}, --Chub
	{ID = {EntityType.ENTITY_CHUB, 2}, Affliction = "Woman"}, --Carrion Queen
	{ID = {EntityType.ENTITY_HOPPER, 2}, Affliction = "Woman"}, --Eggy
	{ID = {EntityType.ENTITY_BOIL}, Affliction = "Non-Binary"},
	{ID = {EntityType.ENTITY_SPITY}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_BABY, 1, 1}, Affliction = "Woman"}, --Small angelic baby
	{ID = {EntityType.ENTITY_GURDY}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_VIS, 3}, Affliction = "Woman"}, --Scarred double vis
	{ID = {EntityType.ENTITY_GUTS, 0, 1}, Affliction = "Woman"}, --Left aimed guts
	{ID = {EntityType.ENTITY_GUTS, 1, 3}, Affliction = "Woman"}, --Right aimed scarred guts
	{ID = {EntityType.ENTITY_KNIGHT, 1}, Affliction = "Isaac"}, --Selfless Knight
	{ID = {EntityType.ENTITY_STONEHEAD, 0}, Affliction = "Non-Binary"}, --Grimace
	{ID = {EntityType.ENTITY_MOM}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_LUST}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_ENVY}, Affliction = "Non-Binary"},
	{ID = {EntityType.ENTITY_LEECH}, Affliction = "Intersex"},
	{ID = {EntityType.ENTITY_MEMBRAIN}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_SUCKER, 4}, Affliction = "Woman"}, --Mama Fly
	{ID = {EntityType.ENTITY_PIN, 1}, Affliction = "Woman"}, --Scolex
	{ID = {EntityType.ENTITY_PIN, 3}, Affliction = "Intersex"}, --Wormwood
	{ID = {EntityType.ENTITY_MOMS_HEART}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_SPIDER}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_GURGLE, 1}, Affliction = "Woman"}, --Crackle
	{ID = {EntityType.ENTITY_SWARMER}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_HEART}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_MASK}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_BIGSPIDER}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_MASK_OF_INFAMY}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_HEART_OF_INFAMY}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_GURDY_JR}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_WIDOW}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_NEST}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_BABY_LONG_LEGS}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_CRAZY_LONG_LEGS, 0}, Affliction = "Woman"}, -- Big Crazy
	{ID = {EntityType.ENTITY_MOMS_HAND}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_BONY, 1}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_GURGLING, 0}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_GURGLING, 1}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_SPLASHER}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_WALL_CREEP}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_RAGE_CREEP}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_BLIND_CREEP}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_CONJOINED_SPITTY}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_MAMA_GURDY}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_BLACK_GLOBIN_BODY}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_MOMS_DEAD_HAND}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_BLISTER}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_SISTERS_VIS}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_MATRIARCH}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_WILLO}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_SMALL_LEECH}, Affliction = "Intersex"},
	{ID = {EntityType.ENTITY_DEEP_GAPER, 0, 6}, Affliction = "Woman"}, --With leech
	{ID = {EntityType.ENTITY_PREY}, Affliction = "Woman"}, --Only cos mulligan, no other intent here
	{ID = {EntityType.ENTITY_BLASTER}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_BOUNCER}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_FIRE_WORM}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_NECRO}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_CANDLER}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_WHIPPER, 2}, Affliction = "Woman"}, --Flagellant
	{ID = {EntityType.ENTITY_PEEPER_FATTY}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_WILLO_L2}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_REVENANT, 0}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_ADULT_LEECH}, Affliction = "Intersex"},
	{ID = {EntityType.ENTITY_GRUDGE}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_BUTT_SLICKER}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_FLESH_MAIDEN}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_CULTIST}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_VIS_FATTY}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_BALL_AND_CHAIN}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_REAP_CREEP}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_VISAGE, 0}, Affliction = "Woman"}, --nOT THE MASK
	{ID = {EntityType.ENTITY_SIREN}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_BABY_PLUM}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_MOTHER}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_MIN_MIN}, Affliction = "Woman"},
	{ID = {EntityType.ENTITY_COLOSTOMIA}, Affliction = "Woman"},

	{ID = FiendFolio.ENT("Facade"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Spinneretch"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("CreepyMaggot"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Mouthful"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Honeydrop"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Heiress"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Unpawtunate"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("MamaPooter"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Gravedigger"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Spooter"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("DreadWeaver"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Madclaw"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Zingling"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Zingy"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Hover"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("ErodedHost"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("RedSmidgen"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("MsDominator"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Dominated"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("ThousandEyes"), Affliction = "Non-Binary"},
	{ID = FiendFolio.ENT("Warden"), Affliction = "Non-Binary"},
	{ID = FiendFolio.ENT("Lez"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Battie"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("SunBody"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("OrgBashful"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("MotherOrb"), Affliction = "Entity"},
	{ID = FiendFolio.ENT("Load"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Panini"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Marge"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("PatzerShell"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Shi"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("DrunkWorm"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("WombPillar"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Doomer"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Ren"), Affliction = "Female"}, --Maria told me to add this
	{ID = FiendFolio.ENT("Croca"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Beebee"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Onlyfan"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Madomme"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Champ"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Gloria"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Deluge"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Angler"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Level0Fly"), Affliction = "Non-Binary"},
	{ID = FiendFolio.ENT("BinaryRed"), Affliction = "Woman"}, -- NOT BINARY BLUE (blue is for BOYS only)
	{ID = FiendFolio.ENT("NonBinary"), Affliction = "Non-Binary"}, -- who would've guessed
	{ID = FiendFolio.ENT("FlashMaiden"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("CacophobiaVenus"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Idolator"), Affliction = "Genderfluid"},
	{ID = FiendFolio.ENT("BabyBubbles"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Rosie"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Posie"), Affliction = "Woman"},
	{ID = FiendFolio.ENT("Temptress"), Affliction = "Woman"},
}

FiendFolio.LGBTQIA = {
	{ID = {EntityType.ENTITY_FLAMINGHOPPER}, Affliction = "Gay"},
	{ID = {EntityType.ENTITY_BUTTLICKER}, Affliction = "Gay"},
	{ID = {EntityType.ENTITY_FATTY, 2}, Affliction = "Gay"}, --Flaming Fatty
	{ID = {EntityType.ENTITY_SKINNY, 2}, Affliction = "Gay"}, --Crispy
	{ID = {EntityType.ENTITY_GYRO, 1}, Affliction = "Gay"}, --Grilled Gyro
	{ID = {EntityType.ENTITY_RAINMAKER}, Affliction = "Gay"},

	{ID = FiendFolio.ENT("Cauldron"), Affliction = "Bi"}, --Cauldron
	{ID = FiendFolio.ENT("BabySpider"), Affliction = "Gay"}, --Baby Spider
	{ID = FiendFolio.ENT("Ransacked"), Affliction = "Gay"}, --Ransacked
	{ID = FiendFolio.ENT("DrinkWorm"), Affliction = "Gay"}, --Drink Worm
	{ID = FiendFolio.ENT("Honeydrop"), Affliction = "Trans"}, --Honeydrop
	{ID = FiendFolio.ENT("Heiress"), Affliction = "Trans"}, --Heiress
	{ID = FiendFolio.ENT("Marge"), Affliction = "Trans"}, --Marge
	{ID = FiendFolio.ENT("Watcher"), Affliction = "Triangle"}, --Watcher
	{ID = FiendFolio.ENT("Ghostse"), Affliction = "Aro"}, --Ghostse
	{ID = FiendFolio.ENT("Woodburner"), Affliction = "Gay"}, --Woodburner
	{ID = FiendFolio.ENT("Foreseer"), Affliction = "Ace"}, --Foreseer
	{ID = FiendFolio.ENT("Drainfly"), Affliction = "Trans"}, --Drainfly
	{ID = FiendFolio.ENT("MsDominator"), Affliction = "Gay"}, --Ms. Dominator
	{ID = FiendFolio.ENT("Dominated"), Affliction = "Gay"}, --Dominated
	{ID = FiendFolio.ENT("DrShambles"), Affliction = "Gay"}, --Dr. Shambles
	{ID = FiendFolio.ENT("OrgChaser"), Affliction = "Ace"}, --Chaser
	{ID = FiendFolio.ENT("Buck"), Affliction = "Pan"}, --Buck
	{ID = FiendFolio.ENT("Pollution"), Affliction = "Gay"}, --Pollution
	{ID = FiendFolio.ENT("Pollution2"), Affliction = "Gay"}, --Pollution (Horsemode)
	{ID = FiendFolio.ENT("Tango"), Affliction = "Gay"},
	{ID = FiendFolio.ENT("Onlyfan"), Affliction = "Gay"},
	{ID = FiendFolio.ENT("Champ"), Affliction = "Trans"},
	{ID = FiendFolio.ENT("RedBony"), Affliction = "Toxic Yaoi"},
	{ID = FiendFolio.ENT("Klutz"), Affliction = "Gay"},
	{ID = FiendFolio.ENT("GriddleHorn"), Affliction = "Gay"},
	{ID = FiendFolio.ENT("Rosie"), Affliction = "Gay"},
	{ID = FiendFolio.ENT("Propaganda"), Affliction = "Polycule"},
}

FiendFolio.Outlier = {
{ID = {EntityType.ENTITY_HOPPER, 3}, Affliction = "Minichibis"}, --Tainted Hopper
{ID = {EntityType.ENTITY_CLUTCH}, Affliction = "Irish"},
{ID = FiendFolio.ENT("Scoop"), Affliction = "Rapper"}, --Scoop
{ID = FiendFolio.ENT("Unpawtunate"), Affliction = "Deviantart User"}, --Unpawtunate
{ID = FiendFolio.ENT("Gravedigger"), Affliction = "Catholic"}, --Gravedigger
{ID = FiendFolio.ENT("Watcher"), Affliction = "Nuclear Throne"}, --Watcher
{ID = FiendFolio.ENT("Punk"), Affliction = "Redditor"}, --Punk
{ID = FiendFolio.ENT("ToxicKnight"), Affliction = "Surfer"}, --Toxic Knight
{ID = FiendFolio.ENT("FossilBoomFly"), Affliction = "Homophobic"}, --Fossilized Boom Fly
{ID = FiendFolio.ENT("Shiitake"), Affliction = "Plants VS Zombies"}, --Shiitake
{ID = FiendFolio.ENT("RamblinEvilMushroom"), Affliction = "Mother 2"}, --Ramblin' Evil Mushroom
{ID = FiendFolio.ENT("Looker"), Affliction = "Eldritch"}, --Looker
{ID = FiendFolio.ENT("Peekaboo"), Affliction = "Italian"}, --Peekaboo
{ID = FiendFolio.ENT("DrShambles"), Affliction = "Homophobic"}, --Dr. Shambles
{ID = FiendFolio.ENT("Umbra"), Affliction = "Swinger"}, --Umbra
{ID = FiendFolio.ENT("FishNuclearThrone"), Affliction = "Ex-cop"}, --Fish
{ID = FiendFolio.ENT("Lez"), Affliction = "Piss Drinker"}, --Lez
{ID = FiendFolio.ENT("Outlier"), Affliction = "Outlier"}, --Outlier
{ID = FiendFolio.ENT("Cathy"), Affliction = "Challenge Pisser"}, --Cathy
{ID = FiendFolio.ENT("SuperShottie"), Affliction = "FPS Player"}, --Super Shottie
{ID = FiendFolio.ENT("Acolyte"), Affliction = "Nail Biter"}, --Acolyte
{ID = FiendFolio.ENT("GriddleHorn"), Affliction = "Homophobic"},
}

--Empty Tables
FiendFolio.creepSpawnerCount = {1}
FiendFolio.countCustomFlies = 0
FiendFolio.fireEntities = {}
FiendFolio.smokingMulliganLocations = {}
FiendFolio.useDirtSprites = 1
FiendFolio.persistentTable = {}

FiendFolio.RequiresRocktops = {
	[GridEntityType.GRID_ROCK] = true,
	[GridEntityType.GRID_ROCK_ALT] = true,
	[GridEntityType.GRID_ROCK_BOMB] = true,
	[GridEntityType.GRID_ROCKT] = true,
	[GridEntityType.GRID_ROCK_SS] = true,
	[GridEntityType.GRID_ROCK_SPIKED] = true,
	[GridEntityType.GRID_ROCK_GOLD] = true,
	[GridEntityType.GRID_ROCK_ALT2] = true,
}

FiendFolio.TrashbaggerTable = {3,5,3,5,3,5,3,5,1,1,--[[9,]]}
FiendFolio.TrashbaggerFlies = {18,18,18,281,281,450,450,256,868,}

FiendFolio.backdropRockSpritesheets = {
	[1] = "gfx/grid/rocks_basement.png",
	[2] = "gfx/grid/rocks_cellar.png",
	[3] = "gfx/grid/rocks_burningbasement.png",
	[4] = "gfx/grid/rocks_caves.png",
	[5] = "gfx/grid/rocks_catacombs.png",
	[6] = "gfx/grid/rocks_drownedcaves.png",
	[7] = "gfx/grid/rocks_depths_custom.png",
	[8] = "gfx/grid/rocks_necropolis.png",
	[9] = "gfx/grid/rocks_dankdepths.png",
	[10] = "gfx/grid/rocks_womb.png",
	[11] = "gfx/grid/rocks_utero.png",
	[12] = "gfx/grid/rocks_scarredwomb.png",
	[13] = "gfx/grid/rocks_bluewomb.png",
	[14] = "gfx/grid/rocks_sheol.png",
	[15] = "gfx/grid/rocks_cathedral.png",
	[16] = "gfx/grid/rocks_darkroom.png",
	[17] = "gfx/grid/rocks_chest.png",
	[19] = "gfx/grid/rocks_cellar.png", --Library
	[20] = "gfx/grid/rocks_shop.png",
	[21] = "gfx/grid/rocks_cellar.png", --Bedroom
	[22] = "gfx/grid/rocks_cellar.png", --Dirty Bedroom
	[23] = "gfx/grid/rocks_secret.png",
	[24] = "gfx/grid/rocks_dice.png",
	[25] = "gfx/grid/rocks_arcade.png",
	[26] = "gfx/grid/rocks_error-1.png.png",
	[27] = "gfx/grid/rocks_bluewomb.png",
	[28] = "gfx/grid/rocks_shop.png",
	[30] = "gfx/grid/rocks_depths.png", --Sacrifice Room
	[31] = "gfx/grid/rocks_downpour_entrance.png", --This is downpour, but I'm using entrance since this is mainly for grid projectiles
	[32] = "gfx/grid/rocks_secretroom.png", --Mines
	[33] = "gfx/grid/rocks_mausoleum.png",
	[34] = "gfx/grid/rocks_corpse.png",
	[35] = "gfx/grid/rocks_cathedral.png", --Planetarium
	[36] = "gfx/grid/rocks_downpour_entrance.png",
	[37] = "gfx/grid/rocks_secretroom.png", --Mines entrance
	[38] = "gfx/grid/rocks_mausoleum.png",
	[39] = "gfx/grid/rocks_corpseentrance.png",
	[40] = "gfx/grid/rocks_mausoleum.png",
	[41] = "gfx/grid/rocks_mausoleumb.png",
	[42] = "gfx/grid/rocks_mausoleum.png", --Not sure what Mausoleum 4 is.
	[43] = "gfx/grid/rocks_corpse2.png",
	[44] = "gfx/grid/rocks_corpse3.png",
	[45] = "gfx/grid/rocks_dross.png",
	[46] = "gfx/grid/rocks_ashpit.png",
	[47] = "gfx/grid/rocks_gehenna.png",
}