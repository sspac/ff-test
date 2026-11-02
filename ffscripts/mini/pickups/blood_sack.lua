local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0,0)

--length 27
mod.bloodbaghearttable = {
	2,	--half
	2,
	2,
	2,
	2,
	2,
	2,
	2,
	2,
	2,
	1,	--full
	1,
	1,
	1,
	1,
	1,
	1,
	1,
	5,	--double
	5,
	5,
	5,
	10, --blended
}

--length 9
mod.bloodbaggibtable = {
	0,	--normal
	0,
	0,
	0,
	2,	--guts
	2,
	2,
	1,	--bone
	1
}

--52 Deck Table
mod.Deck52DropTable = {
	-- Vanilla
	{ID = Card.CARD_CLUBS_2},
	{ID = Card.CARD_DIAMONDS_2},
	{ID = Card.CARD_SPADES_2},
	{ID = Card.CARD_HEARTS_2},

	{ID = Card.CARD_ACE_OF_CLUBS},
	{ID = Card.CARD_ACE_OF_DIAMONDS},
	{ID = Card.CARD_ACE_OF_SPADES},
	{ID = Card.CARD_ACE_OF_HEARTS},

	{ID = Card.CARD_JOKER},
	{ID = Card.CARD_SUICIDE_KING},
	{ID = Card.CARD_QUEEN_OF_HEARTS},
	-- FiendFolio
	{ID = mod.ITEM.CARD.THREE_OF_CLUBS},
	{ID = mod.ITEM.CARD.THREE_OF_DIAMONDS},
	{ID = mod.ITEM.CARD.THREE_OF_SPADES},
	{ID = mod.ITEM.CARD.THREE_OF_HEARTS},

	{ID = mod.ITEM.CARD.JACK_OF_CLUBS},
	{ID = mod.ITEM.CARD.JACK_OF_DIAMONDS},
	{ID = mod.ITEM.CARD.JACK_OF_SPADES},
	{ID = mod.ITEM.CARD.JACK_OF_HEARTS},

	{ID = mod.ITEM.CARD.QUEEN_OF_CLUBS},
	{ID = mod.ITEM.CARD.QUEEN_OF_DIAMONDS},
	{ID = mod.ITEM.CARD.QUEEN_OF_SPADES},

	{ID = mod.ITEM.CARD.KING_OF_CLUBS},
	{ID = mod.ITEM.CARD.KING_OF_DIAMONDS},
	{ID = mod.ITEM.CARD.KING_OF_SPADES},

	{ID = mod.ITEM.CARD.MISPRINTED_JOKER, Weight = 1/3},
	{ID = mod.ITEM.CARD.MISPRINTED_JACK_OF_CLUBS, Weight = 1/3},
	{ID = mod.ITEM.CARD.MISPRINTED_TWO_OF_CLUBS, Weight = 1/3},
	{ID = mod.ITEM.CARD.MISPRINTED_THREE_OF_DIAMONDS, Weight = 1/3},
}

mod.decksacktable = mod.Deck52DropTable

function mod:bloodsackupdate(pickup)
--Price Adjustment for Sacks
	if pickup:GetSprite():IsPlaying("Collect") then
		--[[if pickup:GetSprite():GetFrame() == 2 then
			mod:GetEntityData(pickup).dummysack:Remove()
			for _, pickupmaybe in ipairs(Isaac.FindByType(5, -1, -1, false, false)) do
				if (mod:GetEntityData(pickupmaybe).bloodsackspawned == nil or mod:GetEntityData(pickupmaybe).bloodsackspawned == false) and (pickupmaybe:GetSprite():IsPlaying("Appear") and (pickupmaybe:GetSprite():GetFrame() < 3)) and math.abs((pickupmaybe.Position - pickup.Position):Length()) < 25 then
					pickupmaybe:Remove()
				end
			end
		end
		if mod:GetEntityData(pickup).soundcancel == nil and sfx:IsPlaying(252) then
			sfx:Stop(252)
			--mod:GetEntityData(pickup).soundcancel = true
		end]]
	end
	if pickup:GetSprite():IsFinished("Collect") then
		pickup:Remove();
	elseif pickup:GetSprite():IsEventTriggered("DropSound") then
		if pickup.SubType == 10 then
			sfx:Play(SoundEffect.SOUND_MUSHROOM_POOF, 1, 0, false, 2);
		elseif pickup.SubType == 0 then
			sfx:Play(SoundEffect.SOUND_DEATH_BURST_SMALL, 1, 0, false, 2);
		elseif pickup.SubType == 11 then
			sfx:Play(SoundEffect.SOUND_SCAMPER, 1, 0, false, 2);
		elseif pickup.SubType == 12 then
			sfx:Play(SoundEffect.SOUND_FETUS_LAND, 1, 0, false, 0.9)
			sfx:Play(SoundEffect.SOUND_FETUS_JUMP, 0.8, 0, false, 0.8)
		elseif pickup.SubType == 13 then
			sfx:Play(SoundEffect.SOUND_SCAMPER, 0.6, 0, false, 2)
		end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.bloodsackupdate, 666)


function mod:bloodsacktouch(pickup, collider)
	if collider.Type == 1 then
		collider = collider:ToPlayer()
		if pickup:IsShopItem() and pickup.Price > collider:GetNumCoins() then
			return true
		else
			if pickup:GetSprite():WasEventTriggered("DropSound") or pickup:GetSprite():IsPlaying("Idle") then
				mod:bloodsackontouch(pickup, collider)
				for _, playermaybe in ipairs(Isaac.FindByType(1, -1, -1, false, false)) do
					playermaybe:Update()
				end

				pickup.Velocity = Vector.Zero
				pickup.EntityCollisionClass = 0

				if pickup:IsShopItem() then
					collider:AddCoins(-1 * pickup.Price)
				end

				if pickup.OptionsPickupIndex ~= 0 then
					local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
					for _, entity in ipairs(pickups) do
						if entity:ToPickup().OptionsPickupIndex == pickup.OptionsPickupIndex and
						   (entity.Index ~= pickup.Index or entity.InitSeed ~= pickup.InitSeed)
						then
							Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, nilvector, nil)
							entity:Remove()
						end
					end
				end
			end
			return pickup:GetSprite():IsPlaying("Collect") or pickup:IsShopItem()
		end
	else
		return false
	end
end

function mod:bloodsackontouch(pickup, collider)
	mod:bloodsackburst(pickup, false, collider)
	if Game():GetRoom():GetType() == RoomType.ROOM_CHALLENGE then
		Ambush.StartChallenge()
	end
	pickup:Die()
	--[[if Game():GetRoom():GetType() == RoomType.ROOM_CHALLENGE then
		mod:GetEntityData(pickup).dummysack = Isaac.Spawn(5, 69, 0, pickup.Position, Vector(0,0), pickup):ToPickup()
		mod:GetEntityData(pickup).dummysack:GetData().bloodsackspawned = false
		mod:GetEntityData(pickup).dummysack.Visible = false
		for i = 0, 25, 1 do
			mod:GetEntityData(pickup).dummysack:Update()
		end
	end]]
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.bloodsacktouch, 666)

mod.TrashBagMiscs = {
	Hearts = {2,2,2,2, 8,8,8,8, 10,10, 11,11, 12,12,12,12, mod.PICKUP.VARIANT.MORBID_HEART, mod.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART, mod.PICKUP.VARIANT.THIRD_MORBID_HEART},
	Worms = {
		TrinketType.TRINKET_PULSE_WORM,
		TrinketType.TRINKET_WIGGLE_WORM,
		TrinketType.TRINKET_RING_WORM,
		TrinketType.TRINKET_FLAT_WORM,
		TrinketType.TRINKET_HOOK_WORM,
		TrinketType.TRINKET_WHIP_WORM,
		TrinketType.TRINKET_RAINBOW_WORM,
		TrinketType.TRINKET_TAPE_WORM,
		TrinketType.TRINKET_LAZY_WORM,
		TrinketType.TRINKET_OUROBOROS_WORM,
		TrinketType.TRINKET_BRAIN_WORM,
		mod.ITEM.TRINKET.FORTUNE_WORM,
		mod.ITEM.TRINKET.TRINITY_WORM
	}
}

function mod:makeFliesNice()
	--Add later
end

function mod:bloodsackburst(pickup, isSnagger, collider)
	--if mod:EpiphanyPickupCheck(pickup, collider) then return end
	--Isaac.ConsoleOutput("blooud")
	local subt = pickup.SubType
	if subt == 10 then
	--Trash Bag
		sfx:Play(SoundEffect.SOUND_MUSHROOM_POOF, 2, 0, false, 1.5);
		pickup:GetSprite():Play("Collect")
		local r = pickup:GetDropRNG()
		--Flies
		local randohelper = math.random(6)
		if randohelper < 4 then
			local randExtras = r:RandomInt(4)
			if isSnagger then
				randExtras = randExtras - 2
			end
			for i = 1, (3 + randExtras) do
				if isSnagger then
					local afly = Isaac.Spawn(18, 0, 0, pickup.Position, RandomVector()*math.random(1,5), pickup)
					afly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					afly.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
					afly:Update()

					mod.scheduleForUpdate(function()
						afly.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
					end, 10)
				else
					local afly = Isaac.Spawn(3, 43, 0, pickup.Position, nilvector, collider)
					afly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					afly:Update()
				end
			end
		--Spiders
		elseif randohelper < 6 then
			local randExtras = r:RandomInt(3)
			if isSnagger then
				randExtras = randExtras - 2
			end
			for i = 1, (2 + randExtras) do
				--[[local afly = Isaac.Spawn(3, 73, 0, pickup.Position, RandomVector()*1, pickup)
				afly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				afly:Update()]]
				if isSnagger then
					EntityNPC.ThrowSpider(pickup.Position, pickup, pickup.Position+RandomVector()*25, false, 0)
				else
					local gottenPlayer
					if collider:ToPlayer() then
						gottenPlayer = collider:ToPlayer()
					else
						gottenPlayer = Isaac.GetPlayer()
					end
					gottenPlayer:ThrowBlueSpider(pickup.Position, pickup.Position+RandomVector()*25)
				end
			end
		--Skuzzes
		else
			local randExtras = r:RandomInt(3)
			if isSnagger then
				randExtras = randExtras - 2
			end
			for i = 1, (2 + randExtras) do
				if isSnagger then
					local skuzz = Isaac.Spawn(666, 60, 0, pickup.Position, nilvector, pickup)
					skuzz.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
					mod:GetEntityData(skuzz).jumpytimer = 0
					skuzz:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					skuzz:Update()
				else
					Isaac.Spawn(3, mod.ITEM.FAMILIAR.ATTACK_SKUZZ, 0, pickup.Position, nilvector, collider)
				end
			end
		end
		--Heart - 33%
		if r:RandomInt(3) == 0 then
			local randHeart = mod.TrashBagMiscs.Hearts[r:RandomInt(#mod.TrashBagMiscs.Hearts) + 1]
			local gameData = Isaac.GetPersistentGameData()

			while (
				(randHeart == HeartSubType.HEART_BONE and (not gameData:Unlocked(Achievement.BONE_HEARTS)))
				or (randHeart == HeartSubType.HEART_ROTTEN and (not gameData:Unlocked(Achievement.ROTTEN_HEARTS)))
				or (randHeart == HeartSubType.HEART_HALF_SOUL and (not gameData:Unlocked(Achievement.EVERYTHING_IS_TERRIBLE)))
				or (randHeart == mod.PICKUP.VARIANT.MORBID_HEART and (not mod.ACHIEVEMENT.MORBID_HEART:IsUnlocked()))
				or (randHeart == mod.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART and (not mod.ACHIEVEMENT.MORBID_HEART:IsUnlocked()))
				or (randHeart == mod.PICKUP.VARIANT.THIRD_MORBID_HEART and (not mod.ACHIEVEMENT.MORBID_HEART:IsUnlocked()))
			) do
				randHeart = mod.TrashBagMiscs.Hearts[r:RandomInt(#mod.TrashBagMiscs.Hearts) + 1]
			end
			if randHeart == mod.PICKUP.VARIANT.MORBID_HEART or randHeart == mod.PICKUP.VARIANT.TWOTHIRDS_MORBID_HEART or randHeart == mod.PICKUP.VARIANT.THIRD_MORBID_HEART then
				local picky = Isaac.Spawn(5, randHeart, 0, pickup.Position, RandomVector()*1, pickup)
				mod:GetEntityData(picky).bloodsackspawned = true
			else
				local picky = Isaac.Spawn(5, 10, randHeart, pickup.Position, RandomVector()*1, pickup)
				mod:GetEntityData(picky).bloodsackspawned = true
			end
		end
		--Consumable/Trinket - 25%
		if r:RandomInt(4) == 0 then
			if r:RandomInt(3) == 0 then
				local picky = Isaac.Spawn(5, mod.PICKUP.VARIANT.RANDOM_OBJECT, 0, pickup.Position, RandomVector()*1	, pickup)
				mod:GetEntityData(picky).bloodsackspawned = true
			else
				local randWorm = r:RandomInt(#mod.TrashBagMiscs.Worms) + 1
				local picky = Isaac.Spawn(5, 350, mod.TrashBagMiscs.Worms[randWorm], pickup.Position, RandomVector()*1, pickup)
				mod:GetEntityData(picky).bloodsackspawned = true
			end
		end
	elseif subt == 0 then
	--Blood Sack
		sfx:Play(SoundEffect.SOUND_DEATH_BURST_SMALL, 2, 0, false, 1.5);
		pickup:GetSprite():Play("Collect")
		local spawnableHearts = {table.unpack(mod.bloodbaghearttable)}
		if Isaac.GetPersistentGameData():Unlocked(Achievement.BONE_HEARTS) then
			table.insert(spawnableHearts, 11) --Don't feel like fixing the magic number
			--For those so uninformed, this is a bone heart.
		end
		if Isaac.GetPersistentGameData():Unlocked(Achievement.SCARED_HEART) then
			 --Don't feel like fixing the magic number either
			table.insert(spawnableHearts, 9)
			table.insert(spawnableHearts, 9)
			table.insert(spawnableHearts, 9)
			-- this be a scared heart
		end
		for i = 1, math.random(2, 3), 1 do
			local heart = Isaac.Spawn(5, 10, spawnableHearts[math.random(1, #spawnableHearts)], pickup.Position, Vector(math.random(4, 7), 0):Rotated(math.random(359)), pickup):ToPickup()
			mod:GetEntityData(heart).bloodsackspawned = true
		end

		for i = 1, math.random(4, 6), 1 do
			Isaac.Spawn(1000, 5, mod.bloodbaggibtable[math.random(1, #mod.bloodbaggibtable)], pickup.Position, RandomVector()*(math.random(3, 6)), pickup)
		end

		for i = 1, math.random(4, 7), 1 do
			local bloodsplat = Isaac.Spawn(1000, 7, 0, pickup.Position + RandomVector() * math.random(2, 5), nilvector, pickup)
			bloodsplat.SpriteScale = Vector(math.random(20, 30)/10,math.random(15, 20)/10)
		end
	elseif subt == 11 then --52 Deck
		sfx:Play(SoundEffect.SOUND_SCAMPER)
		pickup:GetSprite():Play("Collect")

		local rng = RNG()
		rng:SetSeed(pickup.InitSeed, 46)

		local drops = 2 + rng:RandomInt(2)

		for i = 1, drops do
			local card = mod.GetWeightedUnlockedCard(mod.Deck52DropTable, rng)
			Isaac.Spawn(5, 300, card, pickup.Position, RandomVector():Resized(math.random(4, 7)), pickup)
		end
	elseif subt == 12 then --Potato Sack
		local rng = pickup:GetDropRNG()
		pickup:GetSprite():Play("Collect")
		sfx:Play(SoundEffect.SOUND_SHELLGAME, 1, 0, false, mod:RandomInt(80,90,rng)/100)
		local amount = mod:RandomInt(2, 4, rng)

		for i=1,amount do
			local vel = Vector(mod:RandomInt(15,40,rng)/10, 0):Rotated(rng:RandomInt(360))
			local potato = Isaac.Spawn(5, mod.PICKUP.VARIANT.POTATO_BATTERY, 0, pickup.Position, vel, pickup)
		end
	elseif subt == 13 then --Drug Baggie (For EIGHTEEN_FOOT_LEASH)
		local rng = pickup:GetDropRNG()
		pickup:GetSprite():Play("Collect")
		sfx:Play(SoundEffect.SOUND_DEATH_BURST_SMALL, 0.45, 0, false, 1.75)
		sfx:Play(SoundEffect.SOUND_BLACK_POOF, 0.35, 0, false, 1.6)
		sfx:Play(SoundEffect.SOUND_MUSHROOM_POOF, 0.9, 0, false, 1.3)
		sfx:Play(SoundEffect.SOUND_VAMP_GULP, 0.65, 0, false, 1)
		if collider and collider:ToPlayer() then
			local player = collider:ToPlayer()
			local strength = mod:GetEntityData(pickup).LeashMultiplier or 1
			local sd = mod:GetEntityData(player).ffsavedata.RunEffects
			sd.EighteenFootLeashBonus = sd.EighteenFootLeashBonus or {Speed = 0, Tears = 0, Dizzy = 0}
			sd.EighteenFootLeashBonus.Tears = math.min(10, 0.35*sd.EighteenFootLeashBonus.Tears+(0.65*sd.EighteenFootLeashBonus.Tears+strength*2)^0.84)
			sd.EighteenFootLeashBonus.Speed = 0.8
			sd.EighteenFootLeashBonus.Dizzy = sd.EighteenFootLeashBonus.Dizzy+0.01

			local amount = game:GetDizzyAmount()
			game:SetDizzyAmount(math.min(1, amount+0.01), amount)

			player:AddCacheFlags(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_FIREDELAY)
			player:EvaluateItems()
		end
		local dust = Isaac.Spawn(1000, 18, 0, pickup.Position, Vector.Zero, pickup):ToEffect()
		dust.Color = Color(1,1,1,0.5,0.5,0.5,0.5)
		dust.SpriteScale = Vector(0.5, 0.5)
		dust:Update()
		for i=1,3 do
			local randVel = RandomVector()*mod:RandomInt(10,30,rng)/20
			local cloud = Isaac.Spawn(1000, 59, 0, pickup.Position, Vector.Zero, pickup):ToEffect()
			cloud:SetTimeout(mod:RandomInt(60, 100, rng))
			local color = Color(1, 1, 1,0,0,0,0)
			cloud.Color = color
			local randScale = mod:RandomInt(65,90,rng)/100
			cloud.SpriteScale = Vector(0.3, 0.3)
			mod:GetEntityData(cloud).cosmeticDust = {scale = randScale, vel = randVel, alpha = 0.35}
		end
	end
end