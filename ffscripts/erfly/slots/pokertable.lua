local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

--Poker table

FiendFolio.onMachineTouch(160, function(player, slot)
    local sprite, gd = slot:GetSprite(), mod:GetEntityData(slot)

    if gd.state == "wagering" then
		local playing = true
		local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})
		for i = 1, #gd.wagers do
			if mod:GetEntityData(gd.wagers[i]).wagered or mod:GetEntityData(gd.wagers[i]).wagering then
				playing = true
				local choice = mod:GetEntityData(gd.wagers[i]).Visual
				if choice == "Coin" then
					if player:GetNumCoins() >= 1 then
						local removed = (math.min(player:GetNumCoins(), mod:GetEntityData(gd.wagers[i]).wagerCount))
						player:AddCoins(-removed)
						playing = true
						d.coinWager = removed
						d.totalstakes = d.totalstakes or 0
						d.totalstakes = d.totalstakes + removed
					else
						mod:GetEntityData(gd.wagers[i]).wagered = nil
						mod:GetEntityData(gd.wagers[i]).wagering = nil
						mod:GetEntityData(gd.wagers[i]).wagerCount = nil
					end
				elseif choice == "Key" then
					if player:GetNumKeys() >= 1 then
						local removed = (math.min(player:GetNumKeys(), mod:GetEntityData(gd.wagers[i]).wagerCount))
						player:AddKeys(-removed)
						playing = true
						d.keyWager = removed
						d.totalstakes = d.totalstakes or 0
						d.totalstakes = d.totalstakes + removed
					else
						mod:GetEntityData(gd.wagers[i]).wagered = nil
						mod:GetEntityData(gd.wagers[i]).wagering = nil
						mod:GetEntityData(gd.wagers[i]).wagerCount = nil
					end
				elseif choice == "Bomb" then
					if player:GetNumBombs() >= 1 then
						local removed = (math.min(player:GetNumBombs(), mod:GetEntityData(gd.wagers[i]).wagerCount))
						player:AddBombs(-removed)
						playing = true
						d.bombWager = removed
						d.totalstakes = d.totalstakes or 0
						d.totalstakes = d.totalstakes + removed
					else
						mod:GetEntityData(gd.wagers[i]).wagered = nil
						mod:GetEntityData(gd.wagers[i]).wagering = nil
						mod:GetEntityData(gd.wagers[i]).wagerCount = nil
					end
				end
			end
		end

		if playing then
			if d.givenGoldenWatch then
				d.totalstakes = d.totalstakes or 0
				d.totalstakes = d.totalstakes + 49
			end
			gd.state = "playhand"
			gd.feelinSmug = nil
			gd.fearinglife = nil
			mod:spritePlay(sprite, "Play")
			slot.SubType = mod.pokerTableStates.Playing
		end
    end
end)

function mod:pokerTablePayout(slot)
	local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})
	local player = Isaac.GetPlayer(0)
	for i = 1, game:GetNumPlayers() do
		local player = Isaac.GetPlayer(i - 1)
		player:AnimateHappy()
	end
	local gd = mod:GetEntityData(slot)
	for i = 1, #gd.wagers do
		gd.wagers[i].Color = Color(0.2, 1, 0.2, 1)
	end
	if d.coinWager then
		player:AddCoins(d.coinWager * 2)
		d.coinWager = nil
	end
	if d.keyWager then
		player:AddKeys(d.keyWager * 2)
		d.keyWager = nil
	end
	if d.bombWager then
		player:AddBombs(d.bombWager * 2)
		d.bombWager = nil
	end
end

mod.pokerTableStates = {
	Idle = 0,
	Smug = 1,
	Playing = 2,
	Payout = 3,
	Leaving = 4,
	DoneLeaving = 5,
}

mod.pokerTableDropTable = {
	TrinketType.TRINKET_ACE_SPADES,
	TrinketType.TRINKET_ACE_SPADES, --Doubling up on these cause of the jokers, for the time being.
	TrinketType.TRINKET_POKER_CHIP,
	TrinketType.TRINKET_POKER_CHIP,
	FiendFolio.ITEM.TRINKET.GLUTTONOUS_JOKER,
	FiendFolio.ITEM.TRINKET.WRATHFUL_JOKER,
	FiendFolio.ITEM.TRINKET.GREEDY_JOKER,
	FiendFolio.ITEM.TRINKET.LUSTY_JOKER,
}

mod.pokerTableCollectibles = {
	CollectibleType.COLLECTIBLE_BLANK_CARD,
	mod.ITEM.COLLECTIBLE.CLEAR_CASE,
}

local function runIterativeCallback(callbackID, you, him)
	for _, callback in pairs(Isaac.GetCallbacks(callbackID)) do
		local r1, r2 = callback.Function(callback.Mod, you, him)
		you = r1 or you
		him = r2 or him
	end

	return you, him
end

local function determinPokerTableWinner(slot, gd, d, reenteringroom)
	local HisChances = 1
	local YourChances = 1
	if reenteringroom then
		HisChances = HisChances + 2
	end

	--Increase his chance to cheat as he loses
	d.losses = d.losses or 0
	HisChances = HisChances + d.losses

	--Better win chance items (no joke here ig)
	if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_LUCKY_FOOT) then
		YourChances = YourChances + 1
	end
	--Cheater Vision
	if PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_XRAY_VISION) or PlayerManager.AnyoneHasCollectible(CollectibleType.COLLECTIBLE_GUPPYS_EYE) then
		YourChances = YourChances + 2
	end
	--A hidden ace up your sleeve
	if PlayerManager.AnyoneHasTrinket(TrinketType.TRINKET_ACE_SPADES) then
		YourChances = YourChances + 1
	end
	--Only at the start...
	if PlayerManager.AnyoneHasCollectible(mod.ITEM.COLLECTIBLE.BEGINNERS_LUCK) then
		YourChances = YourChances + 1
		HisChances = HisChances + (d.losses * 1)
	end

	local newYourChances, newHisChances = runIterativeCallback(mod.CALLBACK.GET_POKER_TABLE_ODDS_PRE_MULTIPLIERS, YourChances, HisChances)
	YourChances = newYourChances or YourChances
	HisChances = newHisChances or HisChances

	if PlayerManager.AnyoneHasCollectible(mod.ITEM.COLLECTIBLE.PAK_CHOI) then
		YourChances = YourChances * 1.09 ^ PlayerManager.GetNumCollectibles(mod.ITEM.COLLECTIBLE.PAK_CHOI)
	end

	local newYourChances, newHisChances = runIterativeCallback(mod.CALLBACK.GET_POKER_TABLE_ODDS_POST_MULTIPLIERS, YourChances, HisChances)
	YourChances = newYourChances or YourChances
	HisChances = newHisChances or HisChances

	local Weight = YourChances + HisChances
	local Roll = slot:GetDropRNG():RandomFloat() * Weight
	--print(YourChances, HisChances)
	--print(Roll)
	--Works like a ratio, so if the chances are 2:3 he'll win just that lil bit more.
	if Roll > YourChances then
		gd.state = "LOSER"
		slot.SubType = mod.pokerTableStates.Smug
		d.coinWager = nil
		d.keyWager = nil
		d.bombWager = nil
	else
		d.losses = d.losses or 0
		d.losses = d.losses + 1
		if d.losses >= 3 or d.givenGoldenWatch then
			gd.state = "screwyouguysimgoinhome"
			slot.SubType = mod.pokerTableStates.Leaving

			if not mod.ACHIEVEMENT["52_DECK"]:IsUnlocked(true) then
				mod.ACHIEVEMENT["52_DECK"]:Unlock()
			end
		else
			gd.state = "shityouwon"
			slot.SubType = mod.pokerTableStates.Payout
		end
	end
end

local function runningAwayGift(slot, d)
	local rng = slot:GetDropRNG()
	d.totalstakes = d.totalstakes or 0
	if d.totalstakes >= 90 then
		local choice = rng:RandomInt(6)
		--2-4 Cards
		if choice <= 2 then
			for i = 1, rng:RandomInt(3) + 2 do
				local card = mod.GetWeightedUnlockedCard(mod.Deck52DropTable, rng)
				local pick = Isaac.Spawn(5, 300, card, slot.Position, RandomVector() * math.random(30,40)/10, slot)
				pick:Update()
			end
		elseif choice <= 3 then
			local pick = Isaac.Spawn(5, 666, 11, slot.Position, nilvector, slot)
			pick:Update()
		elseif choice <= 4 then
			local trink = mod.pokerTableDropTable[rng:RandomInt(#mod.pokerTableDropTable) + 1]
			local pick = Isaac.Spawn(5, 350, trink, slot.Position, nilvector, slot)
			pick:Update()
		elseif choice <= 5 then
			local itemchoice = mod.pokerTableCollectibles[rng:RandomInt(#mod.pokerTableCollectibles) + 1]
			local pick = Isaac.Spawn(5, 100, itemchoice, slot.Position, nilvector, slot)
			pick:Update()
		end
	elseif d.totalstakes >= 50 then
		local choice = rng:RandomInt(5)
		--1-3 Cards
		if choice <= 2 then
			for i = 1, rng:RandomInt(3) + 1 do
				local card = mod.GetWeightedUnlockedCard(mod.Deck52DropTable, rng)
				local pick = Isaac.Spawn(5, 300, card, slot.Position, RandomVector() * math.random(30,40)/10, slot)
				pick:Update()
			end
		elseif choice <= 3 then
			local pick = Isaac.Spawn(5, 666, 11, slot.Position, nilvector, slot)
			pick:Update()
		elseif choice <= 4 then
			local trink = mod.pokerTableDropTable[rng:RandomInt(#mod.pokerTableDropTable) + 1]
			local pick = Isaac.Spawn(5, 350, trink, slot.Position, nilvector, slot)
			pick:Update()
		end
	elseif d.totalstakes >= 10 then
		--Random pickup or two
		local choice = rng:RandomInt(5)
		if choice <= 2 then
			for i = 1, rng:RandomInt(2) + 1 do
				local pick = Isaac.Spawn(5, 20 + (rng:RandomInt(3) * 10), 0, slot.Position, RandomVector() * math.random(30,40)/10, slot)
				pick:Update()
			end
		--Or drop a random card
		elseif choice <= 3 then
			local card = mod.GetWeightedUnlockedCard(mod.Deck52DropTable, rng)
			local pick = Isaac.Spawn(5, 300, card, slot.Position, nilvector, slot)
			pick:Update()
		else
			local pick = Isaac.Spawn(5, 300, Card.CARD_RULES, slot.Position, nilvector, slot)
			pick:Update()
		end
	else
		local pick = Isaac.Spawn(5, 20 + (rng:RandomInt(3) * 10), 0, slot.Position, nilvector, slot)
		pick:Update()
	end
end

mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, function(_, slot)
    local sprite, gd, subt = slot:GetSprite(), mod:GetEntityData(slot), slot.SubType
	local d = FiendFolio.getFieldInit(FiendFolio.savedata, 'run', 'level', 'SlotData', tostring(slot.InitSeed), {})

	--print(d.totalstakes)

	if not gd.init then
		--slot.SpriteOffset = Vector(0, -12)
		gd.init = true

		gd.wagers = {}
		for i = -1, 1 do
			local wager = Isaac.Spawn(mod.FF.PokerWager.ID, mod.FF.PokerWager.Var, mod.FF.PokerWager.Sub, slot.Position + slot.SpriteOffset, nilvector, slot)
			local wd = mod:GetEntityData(wager)
			wd.choiceBet = i
			wager.Parent = slot
			wager:Update()

			table.insert(gd.wagers, wager)
		end

		if subt == mod.pokerTableStates.Leaving then
			gd.state = "screwyouguysimgoinhome"
		elseif subt == mod.pokerTableStates.DoneLeaving then
			slot:Remove()
		elseif subt == mod.pokerTableStates.Playing then
			determinPokerTableWinner(slot, gd, d, true)
		elseif subt == mod.pokerTableStates.Payout then
			gd.state = "shityouwon"
		else
			if subt == mod.pokerTableStates.Smug then
				gd.feelinSmug = true
			end
			gd.state = "idle"
		end
	end

	local smugness = ""
	if gd.feelinSmug then
		smugness = "Smug"
	end

	if gd.state == "idle" then
		local closeBomb = mod.FindClosestEntity(slot.Position, 85, 4)
		if closeBomb then
			if not gd.feelinSmug then
				gd.fearinglife = true
				gd.feelinSmug = true
			end
		end
		if gd.fearinglife then
			if sprite:IsFinished("ItsOverBegin") then
				gd.fearinglife = false
				gd.feelinSmug = true
			else
				mod:spritePlay(sprite, "ItsOverBegin")
			end
		else
			mod:spritePlay(sprite, "Idle" .. smugness)
		end
		for i = 1, #gd.wagers do
			if mod:GetEntityData(gd.wagers[i]).wagering or mod:GetEntityData(gd.wagers[i]).wagered or d.givenGoldenWatch then
				gd.state = "wagering"
				mod:spritePlay(sprite, "WageringBegin" .. smugness)
			end
		end
	elseif gd.state == "wagering" then
		if not sprite:IsPlaying("WageringBegin" .. smugness) then
			mod:spritePlay(sprite, "WageringLoop")
		end
	elseif gd.state == "playhand" then
		if sprite:IsFinished("Play") then
			determinPokerTableWinner(slot, gd, d)
		elseif sprite:IsEventTriggered("Chips") then
			sfx:Play(mod.Sounds.ChipPull, 1, 0, false, math.random(150,160)/100)
		elseif sprite:IsEventTriggered("Cards") then
			sfx:Play(mod.Sounds.CardDraw, 0.5, 0, false, 1.4)
		elseif sprite:IsEventTriggered("Tap") then
			sfx:Play(mod.Sounds.CardMove, 1, 0, false, math.random(50,70)/100)
		elseif sprite:IsEventTriggered("Sound") then
			sfx:Play(mod.Sounds.CardFlip, 0.5, 0, false, 1)
		elseif sprite:IsEventTriggered("Reward") then
			mod:fortuneGrubCheck()
		end
	elseif gd.state == "LOSER" then
		if sprite:IsFinished("YouLose") then
			gd.state = "idle"
			for i = 1, #gd.wagers do
				mod:GetEntityData(gd.wagers[i]).wagered = nil
				mod:GetEntityData(gd.wagers[i]).wagerCount = nil
				gd.wagers[i].Color = mod.ColorNormal
				gd.wagers[i]:Update()
			end
		elseif sprite:IsEventTriggered("Lose") then
			if d.givenGoldenWatch then
				mod:SpawnItemPopup(mod.ITEM.COLLECTIBLE.GOLDEN_WATCH, mod.ItemPopupSubtypes.STANDARD, slot.Position+Vector(0,-20), slot)
				d.givenGoldenWatch = false
			end
			for i = 1, game:GetNumPlayers() do
				local player = Isaac.GetPlayer(i - 1)
				player:AnimateSad()
			end
			for i = 1, #gd.wagers do
				gd.wagers[i].Color = Color(1, 0.2, 0.2, 1)
			end
			sfx:Play(mod.Sounds.PokerBoyLaugh, 0.5, 0, false, 1.5)
		elseif sprite:IsEventTriggered("Cards") then
			sfx:Play(mod.Sounds.CardMove, 1, 0, false, math.random(100,240)/100)
		elseif sprite:IsEventTriggered("Chips") then
			sfx:Play(mod.Sounds.ChipPull, 1, 0, false, math.random(90,110)/100)
		elseif sprite:IsEventTriggered("Sound") then
			sfx:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, math.random(200,250)/100)
		else
			mod:spritePlay(sprite, "YouLose")
		end
	elseif gd.state == "shityouwon" then
		if sprite:IsFinished("YouWin") then
			gd.state = "idle"
			for i = 1, #gd.wagers do
				mod:GetEntityData(gd.wagers[i]).wagered = nil
				mod:GetEntityData(gd.wagers[i]).wagerCount = nil
				gd.wagers[i].Color = mod.ColorNormal
				gd.wagers[i]:Update()
			end
		elseif sprite:IsEventTriggered("Gasp") then
			sfx:Play(mod.Sounds.RMGasp, 0.5, 0, false, 1.1)
			mod:pokerTablePayout(slot)
			slot.SubType = mod.pokerTableStates.Idle
		elseif sprite:IsEventTriggered("Lose") then
			sfx:Play(mod.Sounds.SadBear, 0.2, 0, false, math.random(150,170)/100)
		elseif sprite:IsEventTriggered("Cards") then
			sfx:Play(mod.Sounds.CardDraw, 1, 0, false, 2.5)
		elseif sprite:IsEventTriggered("Reward") then

		else
			mod:spritePlay(sprite, "YouWin")
		end
	elseif gd.state == "screwyouguysimgoinhome" then
		if sprite:IsFinished("Defeat") then
			slot:Remove()
		elseif sprite:IsEventTriggered("Gasp") then
			sfx:Play(mod.Sounds.RMGasp, 0.5, 0, false, 1.1)
			mod:pokerTablePayout(slot)
			slot.SubType = mod.pokerTableStates.DoneLeaving
		elseif sprite:IsEventTriggered("Explode") then
			sfx:Play(mod.Sounds.PokerBoyYell, 2, 0, false, 0.9)
		elseif sprite:IsEventTriggered("Sound") then
			sfx:Play(SoundEffect.SOUND_HELL_PORTAL1,1,0,false,1)
			runningAwayGift(slot, d)
		elseif sprite:IsEventTriggered("Tap") then
			sfx:Play(SoundEffect.SOUND_BONE_SNAP, 1, 0, false, math.random(13, 15)/10)
		elseif sprite:IsEventTriggered("Lose") then
			sfx:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0, false, math.random(200,250)/100)
		elseif sprite:IsEventTriggered("Reward") then
			if d.givenGoldenWatch then
				for i = 1, Game():GetNumPlayers() do
					local player = Game():GetPlayer(i-1)
					local sd = mod:GetEntityData(player).ffsavedata.RunEffects
					if sd then
						sd.goldenWatchValue = sd.goldenWatchValue or 0
						sd.goldenWatchValue = sd.goldenWatchValue + 30
						sd.goldenWatchState = 0
						break
					end
				end
				sfx:Play(SoundEffect.SOUND_CASH_REGISTER)
        		sfx:Play(SoundEffect.SOUND_SLOTSPAWN)
				Isaac.Spawn(5, 100, mod.ITEM.COLLECTIBLE.GOLDEN_WATCH, slot.Position+Vector(0,40), nilvector, slot)
				d.givenGoldenWatch = false
			end
		else
			mod:spritePlay(sprite, "Defeat")
		end
	end

	if not gd.DropFunc then
		function gd.DropFunc()
			if not gd.DidDropFunc then
				slot:BloodExplode()
				slot:BloodExplode()
				slot:BloodExplode()
				local ass = Isaac.Spawn(1000, 2, 3, slot.Position+Vector(0,-20), Vector.Zero , slot)
				--Nerfing his drops, why play him when you can just blow him up
				--[[local chanceDrop = math.random(6)

				if chanceDrop == 1 or chanceDrop == 2 or chanceDrop == 3 then
					local rng = RNG()
					rng:SetSeed(slot.InitSeed, 46)

					local drops = chanceDrop == 3 and 2 or 1

					for i = 1, drops do
						local card = mod.GetWeightedUnlockedCard(mod.Deck52DropTable, rng)
						Isaac.Spawn(5, 300, card, slot.Position, Vector(math.random(4, 7), 0):Rotated(math.random(180)), slot)
					end
				elseif chanceDrop == 4 then
					Isaac.Spawn(5, 350, mod.pokerTableDropTable[math.random(1, #mod.pokerTableDropTable)], slot.Position, Vector(math.random(4, 7), 0):Rotated(math.random(180)), slot)
				elseif chanceDrop == 5 then
					Isaac.Spawn(5, 666, 11, slot.Position, Vector(math.random(4, 7), 0):Rotated(math.random(180)), slot)
				end]]
				local rng = slot:GetDropRNG()
				local pick = Isaac.Spawn(5, 20 + (rng:RandomInt(3) * 10), 0, slot.Position, RandomVector() * (math.random(20,30)/10), slot)
				pick:Update()
				gd.DidDropFunc = true
			end
		end
	end
	FiendFolio.OverrideExplosionHack(slot, false)
	--back here
end, 160)

local WagerCaps = {
	["Coin"] = 20,
	["Key"] = 10,
	["Bomb"] = 10,
}

function mod:determinePokerCaps(visual)
	local cap = WagerCaps[visual]
	local pakChoiMult = mod.getCollectibleMultiplierAcrossAllPlayers(mod.ITEM.COLLECTIBLE.PAK_CHOI)
	for i = 1, pakChoiMult do
		cap = cap * 1.09
	end
	if mod.anyPlayerHas(mod.ITEM.TRINKET.JEVILSTAIL, true) then
		if visual == "Coin" then
			cap = cap + 10
		end
	end
	return math.min(math.floor(cap),99)
end

function mod:pokerWagerAI(e)
	local sprite, d = e:GetSprite(), mod:GetEntityData(e)

	if e.FrameCount <= 30 then
		e.Color = Color(e.Color.R,e.Color.G,e.Color.B,math.min(1, e.FrameCount/30))
	end

	if not e.Parent then
		e:Remove()
	else
		if e.Parent.SubType == mod.pokerTableStates.DoneLeaving then
			e.Color = Color(e.Color.R,e.Color.G,e.Color.B,math.max(e.Color.A - 1/30, 0))
		end
		if not d.init then
			d.choiceBet = d.choiceBet or math.random(3) - 2
			if d.choiceBet then
				e.Position = e.Position + Vector(d.choiceBet * 32, 46)
			end
			d.init = true
		end

		e.RenderZOffset = -10000

		if d.choiceBet then
				d.Visual = "Bomb"
			if d.choiceBet == -1 then
				d.Visual = "Coin"
			elseif d.choiceBet == 1 then
				d.Visual = "Key"
			end
		end

		d.wagerCount = d.wagerCount or 0

		local player = Game():GetNearestPlayer(e.Position)
		local activelyWagering
		local tryingToWager
		if player.Position:Distance(e.Position) < 15 and player.Velocity:Length() < 1 then
			if ((d.Visual == "Coin" and player:GetNumCoins() >= 1) or (d.Visual == "Key" and player:GetNumKeys() >=1) or (d.Visual == "Bomb" and player:GetNumBombs() >=1)) then
				if mod:GetEntityData(e.Parent).state == "idle" or mod:GetEntityData(e.Parent).state == "wagering"  then
					tryingToWager = true
					local cap = mod:determinePokerCaps(d.Visual)
					if d.wagerCount <= cap and ((d.Visual == "Coin" and player:GetNumCoins() > d.wagerCount) or (d.Visual == "Key" and player:GetNumKeys() > d.wagerCount) or (d.Visual == "Bomb" and player:GetNumBombs() > d.wagerCount)) then
						d.wagering = d.wagering or -1
						d.wagering = d.wagering + 1
						if d.wagering == 0 then
							d.wagerCount = d.wagerCount + 1
						end
						activelyWagering = true
						d.wagered = false
					end
				end
			end
		else
			if d.wagering then
				d.wagered = true
			end
			d.wagering = nil
		end

		if activelyWagering and d.wagering > 10 then
			if d.Visual == "Coin" then
				if d.wagering % 3 == 0 then
					d.wagerCount = d.wagerCount + 1
				end
			elseif d.Visual == "Bomb" then
				if d.wagering % 4 == 0 then
					d.wagerCount = d.wagerCount + 1
				end
			elseif d.Visual == "Key" then
				if d.wagering % 5 == 0 then
					d.wagerCount = d.wagerCount + 1
				end
			end
		end
		d.wagerCount = math.min(d.wagerCount, mod:determinePokerCaps(d.Visual))

		if d.wagerCount and d.wagerCount > 0 then
			sprite:SetOverlayFrame("Number", d.wagerCount)
		else
			sprite:RemoveOverlay()
		end

		if activelyWagering or (not d.wagered and tryingToWager) then
			mod:spritePlay(sprite, "Bet" .. d.Visual .. "Selecting")
		elseif d.wagered then
			mod:spritePlay(sprite, "Bet" .. d.Visual .. "Wagered")
		else
			mod:spritePlay(sprite, "Bet" .. d.Visual .. "Idle")
		end
	end
end