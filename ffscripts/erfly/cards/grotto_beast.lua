local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod.GrottoBeasts = {
	Commons = {
		mod.ENT("Slammer"),	--Slammer
		mod.ENT("Wimpy"),	--Wimpy
		mod.ENT("Stompy"),	--Stompy
		mod.ENT("Dung"),	--Dung
		{mod.FF.Morsel.ID, mod.FF.Morsel.Var, 5},--Morsel
		mod.ENT("Balor"),	--Balor
		mod.ENT("Hover"),	--Hover
		mod.ENT("Benign"),	--Benign
		mod.ENT("Drumstick"),	--Drumstick
		mod.ENT("ButtFly"),	--Butt Fly
		mod.ENT("Slobber"),	--Slobber
		mod.ENT("Bleedy"),	--Bleedy
		mod.ENT("Globlet"),	--Globlet
		mod.ENT("LitterBugToxic"),	--Litterbug Toxic
		mod.ENT("Slim"),	--Slim
		mod.ENT("Spooter"),	--Spooter
		mod.ENT("SuperSpooter"),	--Super Spooter
		mod.ENT("Zingling"),	--Zingling
		mod.ENT("Beeter"),	--Beeter
		mod.ENT("HoneyEye"),	--Honey Eye
		mod.ENT("Spitroast"),	--Spitroast
		mod.ENT("Mayfly"),	--Mayfly
		mod.ENT("Woodburner"),	--Woodburner
		mod.ENT("Wobbles"),	--Wobbles
		mod.ENT("RolyPoly"),	--RolyPoly
		mod.ENT("MilkTooth"),	--MilkTooth
		mod.ENT("Foamy"),	--Foamy
		mod.ENT("CreepyMaggot"),	--Creepy Maggot
		mod.ENT("Sourpatch"),	--Warhead
		mod.ENT("Warhead"),	--Warheady
		mod.ENT("DoomFly"),	--Doomfly
		mod.ENT("Edema"),	--Edema
		mod.ENT("Casualty"),	--Casualty
		mod.ENT("Trailblazer"),	--Trailblazer
		mod.ENT("MrSubHorf"),	--Mr. Sub Horf
		mod.ENT("Calsiketic"),	-- Calsiketic
		mod.ENT("Rabbit"),	-- Rabbit

	},
	Rares = {
		{mod.FF.Slick.ID, mod.FF.Slick.Var, 5},-- Slick
		mod.ENT("PaleSlammer"),	--Smasher
		mod.ENT("SaggingSucker"),	--Sagging Sucker
		mod.ENT("PaleSlim"),	--Pale Slim
		mod.ENT("PaleBleedy"),	--Pale Bleedy
		mod.ENT("Briar"),	--Briar
		mod.ENT("MiniMinMin"),	--Mini-Min
		mod.ENT("Dewdrop"),	--Dewdrop
		mod.ENT("Bubby"),	--Bubby
		-- mod.ENT("Dollop"),	--Dollop
		-- mod.ENT("Peepisser"),	--Peepisser
		mod.ENT("Coloscope"),	--Coloscope
		mod.ENT("Chunky"),	--Chunky
		mod.ENT("Matte"),	-- Matte
		mod.ENT("Squid"),	-- Squid
		mod.ENT("Cappin"),	--Cappin
		mod.ENT("FleshSistern"),	--FleshSistern
		mod.ENT("Shellmet"),	--Shellmet
		mod.ENT("Morvid"),	--Morvid
		mod.ENT("Fingore"),	--Fingore
		mod.ENT("Fishaac"),	--Fishaac
		mod.ENT("TadoKid"),	--TadoKid
		mod.ENT("Sniffle"),	--Sniffle
		mod.ENT("Ragurge"),	--Ragurge
		mod.ENT("Spitum"),	--Spitum
		mod.ENT("Nimbus"),	--Nimbus
		mod.ENT("Dangler"),	--Dangler
		mod.ENT("Berry"),	--Berry
		mod.ENT("PsionLeech"),	--Psleech
		mod.ENT("Slimer"),	--Slimer
		mod.ENT("Redema"),	-- Redema
		mod.ENT("Ignis"),	--Ignis
		-- mod.ENT("Buddybag"),	--Buddybag
		mod.ENT("Seducer"),	-- Seducer
		mod.ENT("Desirer"),	-- Desirer
		mod.ENT("Devourer"),	-- Devourer
		mod.ENT("Ruiner"),	-- Ruiner
		mod.ENT("Indulger"),	-- Indulger
		mod.ENT("RedBony"),	-- Red Bony

	},
	Epics = {
		mod.ENT("Chorister"),	--Chorister
		mod.ENT("Calzone"),	--Calzone
		mod.ENT("Drooler"),	--Drooler
		mod.ENT("Foreseer"),	--Foreseer
		mod.ENT("NakedLooker"),--Looker
		mod.ENT("Pyroclasm"),	--Pyroclasm
		mod.ENT("DryWheeze"),	--Dry Wheeze
		mod.ENT("Hangman"),	--Hangman
		mod.ENT("HolyWobbles"),	--HolyWobbles
		mod.ENT("Sixth"),	--Sixth
		mod.ENT("Kukodemon"),	--Kukodemon
		mod.ENT("SuperShottie"),	--Super Shottie
		mod.ENT("Ghostse"),	--Ghostse
		mod.ENT("Tapeworm"),	--Tapeworm
		mod.ENT("Gorger"),	--Gorger
		mod.ENT("Craterface"),	--Craterface
		mod.ENT("Drooler"),	--Drooler
		mod.ENT("Crosseyes"),	--Crosseyes
		-- mod.ENT("Zephyr"),	-- Zephyr
		mod.ENT("SaggingSpit"),	-- Sagging Spit
		mod.ENT("HolyClotty"),	-- HolyClotty
		--mod.ENT("AntiFiend"),	-- AntiFiend
		mod.ENT("NewYear"),	-- New Year
		mod.ENT("Hyperbole"),	-- Hyperbole
		mod.ENT("SoulSpooter"),	-- Soul Spooter

	},
	Legendaries = {
		--mod.ENT("Battie"),	--Battie
		mod.ENT("GriddleHorn"),	--Griddle
		mod.ENT("Apega"),	--Apega
		mod.ENT("Globwad"),	--Globwad
		mod.ENT("Doomer"),	--Doomer
		-- mod.ENT("Cherub"),	--Cherub
		mod.ENT("SlimShady"),	--Slim Shady
		mod.ENT("Starving"),	--Starving
		mod.ENT("Craig"),	--Craig
		mod.ENT("Brandon"),	-- Brandon
		mod.ENT("Apocalypse"),	-- Apocalypse
		mod.ENT("MsDominator"), -- Ms. Dominator
		mod.ENT("Shader"),	-- Shader
		mod.ENT("Bloast"), -- Bloast
		mod.ENT("Mo"),	-- THE MONSTER
	},
}
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, cardID, player, flags)
	local r = player:GetCardRNG(mod.ITEM.CARD.GROTTO_BEAST)
	local rand = r:RandomInt(14) + 1
	local choiceArray = "Legendaries"
	local HUD = game:GetHUD()
	--print(rand)
	if rand > 8 then
		choiceArray = "Commons"
		--HUD:ShowItemText("Common")
		FiendFolio:trySayAnnouncerLine(mod.Sounds.VACardGrottoBeast, flags, 20)
	elseif rand > 3 then
		choiceArray = "Rares"
		sfx:Play(mod.Sounds.HSTier1,0.6,0,false,1)
		HUD:ShowItemText("Rare!")
		FiendFolio:trySayAnnouncerLine(mod.Sounds.VACardGrottoBeast, flags, 30)
	elseif rand > 1 then
		choiceArray = "Epics"
		sfx:Play(mod.Sounds.HSTier2,0.6,0,false,1)
		HUD:ShowItemText("Epic!")
		FiendFolio:trySayAnnouncerLine(mod.Sounds.VACardGrottoBeast, flags, 30)
	else
		sfx:Play(mod.Sounds.HSTier3,0.6,0,false,1)
		HUD:ShowItemText("Legendary!!!")
		FiendFolio:trySayAnnouncerLine(mod.Sounds.VACardGrottoBeast, flags, 80)
	end

	local monster = mod.GrottoBeasts[choiceArray][r:RandomInt(#mod.GrottoBeasts[choiceArray]) + 1]
	local subT = monster[3] or 0
	local buddy = Isaac.Spawn(monster[1], monster[2], subT, player.Position + RandomVector():Resized(20), nilvector, player):ToNPC()
	buddy:AddCharmed(EntityRef(player), -1)
	buddy.SpawnerEntity = player
	if math.random(5) == 1 then
		sfx:Play(mod.Sounds.SchwingDingALing,1,0,false,1)
		mod:GetEntityData(buddy).sparklyGrottoBeast = true
		for i = 30, 360, 30 do
			local expvec = Vector(0,math.random(10,35)):Rotated(i)
			local sparkle = Isaac.Spawn(1000, 1727, 0, buddy.Position + expvec * 0.1, expvec * 0.3, buddy):ToEffect()
			sparkle.SpriteOffset = Vector(0,-15)
			sparkle:Update()
		end
	end
	buddy:Update()
end, mod.ITEM.CARD.GROTTO_BEAST)