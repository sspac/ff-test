local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

mod.snaggerPickupTable = {
    ["10 | 1"] = {Type = "Heart", Multiplier = 1},
    ["10 | 2"] = {Type = "Heart", Multiplier = 0.5},
    ["10 | 3"] = {Type = "Heart", Multiplier = 1},
    ["10 | 4"] = {Type = "Heart", Multiplier = 2},
    ["10 | 5"] = {Type = "Heart", Multiplier = 2},
    ["10 | 6"] = {Type = "Heart", Multiplier = 1},
    ["10 | 7"] = {Type = "Heart", Multiplier = 1},
    ["10 | 8"] = {Type = "Heart", Multiplier = 0.5},
    ["10 | 9"] = {Type = "Heart", Multiplier = 1},
    ["10 | 10"] = {Type = "Heart", Multiplier = 1},
    ["10 | 11"] = {Type = "Heart", Multiplier = 1},
    ["10 | 12"] = {Type = "Heart", Multiplier = 1},
    ["1022 | 0"] = {Type = "Heart", Multiplier = 0.5},
    ["1023 | 0"] = {Type = "Heart", Multiplier = 1},
    ["1024 | 0"] = {Type = "Heart", Multiplier = 1},
    ["1025 | 0"] = {Type = "Heart", Multiplier = 0.5},
    ["1026 | 0"] = {Type = "Heart", Multiplier = 1},

    ["20 | 1"] = {Anim = "EatCoin", State = "attacking", Sprite = "coins/penny.png", Type = "Coin", Count = 1},
    ["20 | 2"] = {Anim = "EatCoin", State = "attacking", Sprite = "coins/nickel.png", Type = "Coin", Count = 5},
    ["20 | 3"] = {Anim = "EatCoin", State = "attacking", Sprite = "coins/dime.png", Type = "Coin", Count = 10},
    ["20 | 4"] = {Anim = "EatCoin", State = "attacking", Sprite = "coins/penny_double.png", Type = "Coin", Count = 2},
    ["20 | 5"] = {Anim = "EatCoin", State = "attacking", Sprite = "coins/penny.png", Type = "Coin", Count = 1},
    ["20 | 7"] = {Anim = "EatCoin", State = "attacking", Sprite = "coins/penny_golden.png", Type = "Coin", Count = 1, Special = "goldenpenny"},
    ["20 | 213"] = {Anim = "EatCoin", State = "attacking", Sprite = "coins/penny_cursed.png", Type = "Coin", Count = 0, Hurts = true},
    ["20 | 214"] = {Anim = "EatCoin", State = "attacking", Sprite = "coins/penny_haunted.png", Type = "Coin", Count = 1, Special = "wisp"},
    ["20 | 215"] = {Anim = "EatCoin", State = "attacking", Sprite = "coins/penny_honey.png", Type = "Coin", Count = 1, Special = "honey"},
    ["20 | 216"] = {Anim = "EatCoin", State = "attacking", Sprite = "coins/penny_goldencursed.png", Type = "Coin", Count = 0, Special = "goldenpennycursed", Hurts = true},

    ["30 | 1"] = {Anim = "Key", State = "attacking", Sprite = "keys/key.png", Type = "Key", Count = 1},
    ["30 | 2"] = {Anim = "Key", State = "attacking", Sprite = "keys/key_golden.png", Type = "Key", Count = 1, Special="golden"},
    ["30 | 3"] = {Anim = "Key", State = "attacking", Sprite = "keys/key_double.png", Type = "Key", Count = 2},
    ["30 | 4"] = {Anim = "KeyCharge", State = "attacking", Sprite = "keys/key.png", Type = "Key", Count = 1, Special="charged"},
    ["30 | 179"] = {Anim = "Key", State = "attacking", Sprite = "keys/key_spicy2.png", Type = "Key", Count = 2, Hurts = true},
    ["30 | 180"] = {Anim = "Key", State = "attacking", Sprite = "keys/key_spicy3.png", Type = "Key", Count = 3, Hurts = true},
    ["30 | 181"] = {Anim = "KeyCharge", State = "attacking", Sprite = "keys/key_spicy2.png", Type = "Key", Special="charged", Count = 2, Hurts = true},
    ["30 | 182"] = {Anim = "Key", State = "attacking", Sprite = "keys/key_spicy2.png", Type = "Key", Count = 2, Hurts = true},
    ["30 | 183"] = {Anim = "Key", State = "attacking", Sprite = "keys/key_spicy3.png", Type = "Key", Count = 3, Hurts = true},
    ["30 | 184"] = {Anim = "KeyCharge", State = "attacking", Sprite = "keys/key_spicy2.png", Type = "Key", Special="charged", Count = 2, Hurts = true},
    ["30 | 185"] = {Anim = "Key", State = "attacking", Sprite = "keys/key_spicy2.png", Type = "Key", Count = 2, Hurts = true},
    ["30 | 186"] = {Anim = "Key", State = "attacking", Sprite = "keys/key_spicy3.png", Type = "Key", Count = 3, Hurts = true},
    ["30 | 187"] = {Anim = "KeyCharge", State = "attacking", Sprite = "keys/key_spicy2.png", Type = "Key", Special="charged", Count = 2, Hurts = true},

    ["40 | 1"] = {Anim = "Bomb", State = "attacking", Sprite = "bombs/bomb.png", Type = "Bomb"},
    ["40 | 2"] = {Anim = "Bomb", State = "attacking", Sprite = "bombs/bomb_double.png", Type = "Bomb", Special="double"},
    ["40 | 4"] = {Anim = "Bomb", State = "attacking", Sprite = "bombs/bomb_golden.png", Type = "Bomb", Special="golden"},
    ["40 | 7"] = {Anim = "GigaBomb", State = "crush", Type = "GigaBomb"},
    ["41 | 0"] = {Anim = "Bomb", State = "attacking", Sprite = "bombs/bomb_red.png", Type = "Bomb", Special="red"},
    ["40 | 923"] = {Anim = "Bomb", State = "attacking", Sprite = "bombs/bomb_copper.png", Type = "Bomb", Special="copper"},
    ["40 | 924"] = {Anim = "Bomb", State = "attacking", Sprite = "bombs/bomb_double_copper.png", Type = "Bomb", Special="doublecopper"},
    ["40 | 925"] = {Anim = "Bomb", State = "attacking", Sprite = "bombs/bomb_double_mixed.png", Type = "Bomb", Special="mixeddouble"},

    ["42 | 0"] = {Anim = "EatCoin", State = "attacking", Sprite = "bombs/poop_small.png", Type = "Poop"},
    ["42 | 1"] = {Anim = "EatCoin", State = "attacking", Sprite = "bombs/poop_big.png", Type = "Poop", Special="bigfart"},

    ["50 | 1"] = {Type = "Chest"},
    ["52 | 1"] = {Type = "Chest", Hurts = true},
    ["54 | 1"] = {Type = "Chest"},
    ["56 | 1"] = {Type = "Chest"},
    ["58 | 1"] = {Type = "Chest"},

    ["300 | " .. mod.ITEM.CARD.SMALL_CONTRABAND] = {Type = "Contraband", Sprite = "keys/contraband_small.png",},
    ["100 | " .. mod.ITEM.COLLECTIBLE.CONTRABAND] = {Type = "ContrabandBig", Sprite = "keys/contraband_item.png"},

    ["360 | 1"] = {Type = "Chest"},

    ["69 | 1"] = {Type = "Sack"},
    ["69 | 2"] = {Type = "Sack"},

    ["90 | 1"] = {Type = "Battery", Duration = "300"},
    ["90 | 2"] = {Type = "Battery", Duration = "150"},
    ["90 | 3"] = {Type = "Battery", Duration = "600"},
    ["90 | 4"] = {Type = "Battery", Duration = "600"},

    [FiendFolio.PICKUP.VARIANT.FIREWORK_BATTERY .. " | 0"] 	= {Type = "Battery", Duration = "300"},
    [FiendFolio.PICKUP.VARIANT.VIRTUOUS_BATTERY .. " | 0"] 	= {Type = "Battery", Duration = "300", Special = "wisp"},
    [FiendFolio.PICKUP.VARIANT.POTATO_BATTERY .. " | 0"] 	= {Type = "Battery", Duration = "60"},
    [FiendFolio.PICKUP.VARIANT.CURSED_BATTERY .. " | 0"] 	= {Type = "Battery", Duration = "300"},

	[FiendFolio.PICKUP.VARIANT.BRIEND_BIRTHRIGHT_GUN .. " | " .. -1] = {Type = "Gun"},
	[FiendFolio.PICKUP.VARIANT.SPARE_ERASER .. " | 0"] 				 = {Type = "Eraser"},

    ["666 | 0"] = {Type = "PlayerSack"},
    ["666 | 10"] = {Type = "PlayerSack"},

    ["710 | 0"] = {Type = "PlayerChest"},
    ["712 | 0"] = {Type = "PlayerChest"},

    ["1873 | 1"] = {Type = "Heart"},
    ["1873 | 2"] = {Anim = "Key", State = "attacking", Type = "Key"},
    ["1873 | 3"] = {Anim = "Bomb", State = "attacking", Type = "Bomb"},
    ["1873 | 6"] = {Type = "Battery"},
    ["1873 | 7"] = {Type = "Heart"},
    ["1873 | 8"] = {Anim = "Key", State = "attacking", Type = "Key"},
    ["1873 | 9"] = {Anim = "Bomb", State = "attacking", Type = "Bomb"},
}

mod.snaggerPickupsHighVal = {
	[10] = true,
	[20] = true,
	[50] = true,
	[52] = true,
	[54] = true,
	[69] = true,
	[90] = true,
	[360] = true,
	[666] = true,
}

mod.snaggerCoinAngles = {
[1] = {StartOff = 0, AddVal = 0},
[2] = {StartOff = -30, AddVal = 60},
[3] = {StartOff = -45, AddVal = 45},
[4] = {StartOff = -40, AddVal = 26.6333},
[5] = {StartOff = -60, AddVal = 30},

}

function mod:snaggerAI(npc)
	local d = mod:GetEntityData(npc)
	local r = npc:GetDropRNG()
	local sprite = npc:GetSprite()
	local target = npc:GetPlayerTarget()
	local room = game:GetRoom()

	if not d.init then
		d.state = "searching"
		d.init = true
		d.batteried = 0
		d.honeybuff = 0
		if d.spawned_by_buck then
			mod:spritePlay(sprite, "AppearBuck")
		end
	else
		npc.StateFrame = npc.StateFrame + 1
		d.batteried = d.batteried - 1
	end

	if d.batteried > 0 then
		if npc.StateFrame > 1 then
			d.interpolationframe = true
		end
		mod:spriteOverlayPlay(sprite, "Charged")
	elseif d.batteried == 0 then
		sprite:RemoveOverlay()
	end
	if d.honeybuff and d.honeybuff > 0 then
		d.honeybuff = d.honeybuff - 1
		if npc.FrameCount % 3 == 0 then
			local honeycolor = Color(1,1,1,1,0,0,0)
			honeycolor:SetColorize(5.5, 3.5, 1, 1)
			local creep = Isaac.Spawn(1000, EffectVariant.CREEP_BROWN, 0, npc.Position, Vector.Zero, npc):ToEffect()
			creep:SetTimeout(120)
			creep:Update()
			creep:GetSprite().Color = honeycolor
		end
	end

	if npc.HitPoints > npc.MaxHitPoints then
		local increase = math.ceil(npc.HitPoints - npc.MaxHitPoints)
		npc:SetColor(Color(1,1,1,1,(increase * 5) / 255,0,0),15,1,true,false)
	end

	if d.state == "searching" then
		if d.spawned_by_buck and npc.FrameCount == 2 then
			local poof = Isaac.Spawn(1000, 15, 0, npc.Position, Vector.Zero, nil):ToEffect()
			d.poofd = true
		end
		if (not sprite:IsPlaying("Spawn")) and (not sprite:IsPlaying("AppearBuck")) then
			if d.monching then
				mod:spritePlay(sprite, "FloatDown02")
				if sprite:IsEventTriggered("crunch") then
					npc:PlaySound(mod.Sounds.CronchyWorms, 1, 0, false, math.random(115,125)/100)
				end
			else
				mod:spritePlay(sprite, "FloatDown")
			end
		end
		local tPickup

		--Movement
		local pickups = Isaac.FindByType(5, -1, -1, false, false)
		local dist = 999999
		local isCoins
		for _, pickup in pairs(pickups) do
			local entry = mod.snaggerPickupTable[pickup.Variant .. " | " .. pickup.SubType]
					   or mod.snaggerPickupTable[pickup.Variant .. " | " .. -1]

			if entry then
				local isValuable = mod.snaggerPickupsHighVal[pickup.Variant]
				if d.monching and isValuable then
					if pickup.Variant == 20 then
						isCoins = true
					end
					if tPickup and not mod.snaggerPickupsHighVal[tPickup.Variant] then
						tPickup = pickup
						dist = pickup.Position:Distance(npc.Position)
					end
				end
				local newdist = pickup.Position:Distance(npc.Position)
				if newdist < dist and ((not isCoins) or pickup.Variant == 20 or pickup.Variant == 10) then
					tPickup = pickup
					dist = newdist
				end
			end
		end

		local targetVelocity = Vector.Zero
		local snagspeed = 3.2 * math.random(8,10) / 10
		local cBomb = mod.FindNearbyBombs(npc.Position, 100)
		if mod:isScare(npc) then
			targetVelocity = (target.Position - npc.Position):Resized(-snagspeed)
		elseif mod:isConfuse(npc) then
			targetVelocity = (mod:confusePos(npc, target.Position) - npc.Position):Resized(snagspeed)
		elseif cBomb then
			targetVelocity = (npc.Position - cBomb.Position):Resized(snagspeed)
		elseif d.monching and ((not tPickup) or (not mod.snaggerPickupsHighVal[tPickup.Variant])) then
			targetVelocity = (target.Position - npc.Position):Resized(snagspeed)
		elseif tPickup and (not d.frozen_by_buck) then
			targetVelocity = (tPickup.Position - npc.Position):Resized(snagspeed)
		elseif not d.frozen_by_buck then
			targetVelocity = (target.Position - npc.Position):Resized(snagspeed)
		end
		npc.Velocity = mod:Lerp(npc.Velocity, targetVelocity,0.2)
		if npc.Velocity.X < 0 then
			sprite.FlipX = true
		else
			sprite.FlipX = false
		end

		if (not mod:isScareOrConfuse(npc)) and d.monching and (((not tPickup)
		or (not mod.snaggerPickupsHighVal[tPickup.Variant]))
		or npc.Position:Distance(target.Position) < npc.Position:Distance(tPickup.Position)
		or (d.monching >= 10 and npc.Position:Distance(target.Position) < 300 and room:CheckLine(npc.Position, target.Position, 3, 0, false, false))) then
			d.state = "blarghe"
		elseif tPickup and tPickup:Exists() and not mod:isScareOrConfuse(npc) then
			if npc.StateFrame > 10 and npc.Position:Distance(tPickup.Position) < 15 and tPickup.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_NONE then
				local choice = mod.snaggerPickupTable[tPickup.Variant .. " | " .. tPickup.SubType]
							or mod.snaggerPickupTable[tPickup.Variant .. " | " .. -1]

				npc.StateFrame = 0
				tPickup:ToPickup():PlayPickupSound()
				d.sState = nil
				d.hurts = nil
				if choice.Anim then
					d.anim = choice.Anim
					mod:spritePlay(sprite, d.anim)
					sprite.FlipX = false
				end
				if choice.State then
					d.state = choice.State
				end
				if choice.Count then
					d.count = choice.Count
				end
				if choice.Hurts then
					d.hurts = choice.Hurts
				end
				if choice.Special then
					d.special = choice.Special
				else
					d.special = nil
				end
				local spritesheet
				if choice.Sprite then
					spritesheet = "gfx/enemies/snagger/pickups/"..choice.Sprite
				end
				if choice.Type then
					if choice.Type == "Heart" then
						npc.HitPoints = npc.HitPoints + (npc.MaxHitPoints * choice.Multiplier)
						if npc.HitPoints > npc.MaxHitPoints * 3 then
							npc.HitPoints = npc.MaxHitPoints * 3
						end
						local poof = Isaac.Spawn(1000, 49, 0, npc.Position, Vector.Zero, npc):ToEffect()
						poof.SpriteOffset = Vector(0,-40)
						poof:FollowParent(npc)
						poof:Update()
						if tPickup.Variant == 1022 or tPickup.Variant == 1023 then
							sfx:Play(SoundEffect.SOUND_UNHOLY)
						elseif tPickup.Variant >= 1024 and tPickup.Variant <= 1026 then
							sfx:Play(mod.Sounds.FiendHeartPickup)
						end
					elseif choice.Type == "Contraband" then
						d.state = "contrabandFleeing"
						d.anim = "Contraband"
						sprite:ReplaceSpritesheet(1, spritesheet)
						sprite:ReplaceSpritesheet(2, spritesheet)
						sprite:LoadGraphics()
					elseif choice.Type == "ContrabandBig" then
						d.state = "contrabandFleeing"
						d.anim = "ContrabandItem"
						sprite:ReplaceSpritesheet(1, spritesheet)
						sprite:ReplaceSpritesheet(2, spritesheet)
						sprite:LoadGraphics()
					elseif choice.Type == "GigaBomb" then
						d.state = "gigabomb"
					elseif choice.Type == "Poop" then
						d.state = "poop"
						sprite:ReplaceSpritesheet(1, spritesheet)
						sprite:LoadGraphics()
					elseif choice.Type == "Chest" then
						tPickup:ToPickup():TryOpenChest()
						if choice.Hurts then
							npc:TakeDamage(5, 0, EntityRef(tPickup), 0)
						end
						if tPickup.Variant == PickupVariant.PICKUP_HAUNTEDCHEST then
							local polty = Isaac.Spawn(816,0,0,tPickup.Position,Vector.Zero,npc)
							polty:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						end
					elseif choice.Type == "Sack" then
						local num = math.random(2,3)

						for i = 1, num do
							local num2 = math.random(5)
							if num2 == 5 then num2 = 9 end
							num2 = num2 * 10
							Isaac.Spawn(5, num2, 0, tPickup.Position, RandomVector()*math.random(1,5), nil)
						end
					elseif choice.Type == "Battery" then
						d.batteried = d.batteried + (choice.Duration or 300)
						npc:PlaySound(SoundEffect.SOUND_BATTERYCHARGE, 1, 0, false, 1)
						local poof = Isaac.Spawn(1000, 49, 1, npc.Position, Vector.Zero, npc):ToEffect()
						poof.SpriteOffset = Vector(0,-40)
						poof:FollowParent(npc)
						poof:Update()
						if choice.Hurts then
							npc:TakeDamage(5, 0, EntityRef(tPickup), 0)
						end
						if d.special == "wisp" then
							local wisp = Isaac.Spawn(808,0,0,npc.Position+(RandomVector()*20),Vector.Zero,npc)
							wisp:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
							wisp:GetSprite():Load("gfx/enemies/snagger/willo_blue.anm2", true)
							mod:GetEntityData(wisp).IsBlueWillo = true
						end
					elseif choice.Type == "PlayerSack" then
						if tPickup.Variant == 666 then
							mod:bloodsackburst(tPickup, true)
						end
					elseif choice.Type == "PlayerChest" then
						if tPickup.Variant == 710 then
							mod:GetEntityData(tPickup).Opened = true
							tPickup:GetSprite():Play("Open")
							sfx:Play(SoundEffect.SOUND_CHEST_OPEN, 1, 0, false, 1)
						elseif tPickup.Variant == 712 then
							mod:FFDireChestOpening(tPickup:ToPickup(), npc)
						end
					elseif choice.Type == "Gun" then
						d.GunslingerData = d.GunslingerData or {}
						d.GunslingerData.Guns = d.GunslingerData.Guns or {}
						local gunTracker = mod:CreateBountyGunTracker(tPickup.SubType)
						table.insert(d.GunslingerData.Guns, gunTracker)
					elseif choice.Type == "Eraser" then
						Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.ERASER, 0, npc.Position, Vector.Zero, Isaac.GetPlayer(0))
					else
						if choice.Type == "Coin" then
							if npc:GetDropRNG():RandomInt(10) < 9 then
								if d.special == "goldenpenny" then
									local gold = Isaac.Spawn(5, 20, 7, mod:FindRandomFreePos(tPickup), Vector.Zero, tPickup)
									gold:GetSprite():Play("Reappear", true)
								elseif d.special == "goldenpennycursed" then
									local gold = Isaac.Spawn(5, 20, 216, mod:FindRandomFreePos(tPickup), Vector.Zero, tPickup)
									gold:GetSprite():Play("Reappear", true)
								end
							end
							if tPickup.SubType == mod.PICKUP.COIN.HAUNTED then
								sfx:Play(SoundEffect.SOUND_SOUL_PICKUP, 1.3, 0, false, 1)
							elseif tPickup.SubType == mod.PICKUP.COIN.HONEY then
								sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH, 1.3, 0, false, 1)
								sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 0, false, 1)
							end
						elseif choice.Type == "Key" then
							if choice.Hurts then
								npc:TakeDamage(5, 0, EntityRef(tPickup), 0)
								sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS)
							end
						elseif choice.Type == "Bomb" then
							if d.special == "copper" then
								sfx:Play(FiendFolio.Sounds.CopperBombPickup, 0.2, 0, false, 1)
								sfx:Play(SoundEffect.SOUND_FETUS_FEET, 2, 0, false, 1)
							end
						end
						if spritesheet then
							local layers = {}
							if choice.Type == "Coin" then
								layers = {1}
							elseif choice.Type == "Bomb" then
								layers = {2,4}
							elseif choice.Type == "Key" then
								layers = {5,6}
							end
							for _, layer in pairs(layers) do
								sprite:ReplaceSpritesheet(layer, spritesheet)
							end
							sprite:LoadGraphics()
						end
						d.aType = choice.Type
					end
				end

				d.shotsFired = 0

				if tPickup.Variant == 10 or tPickup.Variant == 69 or tPickup.Variant == 90 or (tPickup.Variant >= 1022 and tPickup.Variant <= 1026) then
					local effect = Isaac.Spawn(1000,7000,0,tPickup.Position,Vector.Zero,nil)
					local efsprite = effect:GetSprite()
					efsprite:Load(tPickup:GetSprite():GetFilename(),true)
					efsprite:Play("Collect")
					mod:GetEntityData(effect).HeartCollect = true
				end
				if choice.Type ~= "Chest" and choice.Type ~= "PlayerChest" then
					tPickup:Remove()
				end
				tPickup:Update()
			end
		end

		if --[[npc.SpawnerEntity and--]] (d.frozen_by_buck or (d.spawned_by_buck and npc.FrameCount < 60)) --[[and d.state == "searching"--]] then
			local v = mod.FindClosestEntity(npc.Position,50,9,1,0)
			if v and (mod:GetEntityData(v).projType == "buckbomb") --[[and v:ToProjectile().Height > -40]] then
				--print("foundBomb")
				v:Remove()
				d.state = "attacking"
				d.anim = "Bomb"
				d.aType = "Bomb"
				d.shotsFired = 0
				d.BuckTimer = nil
				sfx:Play(SoundEffect.SOUND_FETUS_FEET, 0.8, 0, false, 1.2)
			end
			if d.frozen_by_buck then
				d.BuckTimer = d.BuckTimer or 0
				d.BuckTimer = d.BuckTimer + 1
				if d.BuckTimer > 120 then
					d.frozen_by_buck = false
					d.BuckTimer = nil
				end
			end
		else
			d.frozen_by_buck = false
		end

	elseif d.state == "attacking" then
		npc.Velocity = npc.Velocity * 0.7
		if not d.sState then
			d.sState = "PreSpawn"
			mod:spritePlay(sprite, d.anim)
		elseif d.sState == "PreSpawn" then
			if sprite:IsFinished(d.anim) then
				if d.aType == "Bomb" then
					npc:PlaySound(SoundEffect.SOUND_SHELLGAME,1,2,false,1)
					local slot = mod.FindClosestEntity(npc.Position, 99999, 6)
					local schest = mod.FindClosestEntity(npc.Position, 99999, 5, 51, 1)
					local gchest = mod.FindClosestEntity(npc.Position, 99999, 5, 713, 0)
					local sNick = mod.FindClosestEntity(npc.Position, 99999, 5, 20, 6)
					if slot and not slot:GetSprite():IsPlaying("Broken") then
						target = slot
					elseif schest then
						target = schest
					elseif gchest then
						target = gchest
					elseif sNick then
						target = sNick
					end
					local thrownum, throwang = 1, 45
					if d.special == "double" or d.special == "doublecopper" or d.special == "mixeddouble" then
						throwang = 30
						thrownum = 2
					end

					for i = 1, thrownum do
						local vel = ((target.Position - npc.Position) / 30):Rotated(-45 + throwang * i)
						if vel:Length() > 13 then
							vel = vel:Resized(13)
						end
						local rand = r:RandomFloat()
						local bombshot = mod:LazySpawnProjectile(ProjectileVariant.PROJECTILE_BONE, 0, npc.Position, vel + npc.Velocity, npc):ToProjectile()
						local bombd = mod:GetEntityData(bombshot)
						bombshot.SpawnerEntity = npc
						--Isaac.ConsoleOutput(bombshot.SpawnerEntity.Type)
						bombd.projType = "thrownbomb"
						bombd.friendInfo = mod:isFriend(npc)
						if d.special == "golden" then bombd.projTypeS = true end
						if d.special == "red" then bombd.pinkBomb = true end
						if d.special == "copper" or d.special == "doublecopper" then bombd.copperBomb = true end
						if d.special == "mixeddouble" and i == 2 then bombd.copperBomb = true end
						bombshot.FallingSpeed = -20
						bombshot.FallingAccel = 1.2
						bombshot.Scale = 1
					end
				elseif d.aType == "Key" then
					npc:PlaySound(SoundEffect.SOUND_SHELLGAME,1,2,false,1)
					local Echest = mod.FindClosestEntity(npc.Position, 99999, 5, 53, 1)
					local Ochest = mod.FindClosestEntity(npc.Position, 99999, 5, 55, 1)
					local Mchest = mod.FindClosestEntity(npc.Position, 99999, 5, 57, 1)
					local Gchest = mod.FindClosestEntity(npc.Position, 99999, 5, 60, 1)
					local Schest = mod.FindClosestEntity(npc.Position, 99999, 5, 711, 0)
					local GLchest = mod.FindClosestEntity(npc.Position, 99999, 5, 713, 0)
					if Echest or Gchest or Schest or GLchest or Ochest or Mchest then
						if Echest then
							target = Echest
						elseif Gchest then
							target = Gchest
						elseif GLchest then
							target = GLchest
						elseif Ochest then
							target = Ochest
						elseif Mchest then
							target = Mchest
						elseif Schest then
							target = Schest
						end
					end
					local thrownum, throwang, keysubt, keyspeed = d.count, 45, 0, 11
					if d.special == "golden" then
						keysubt = 10
					elseif d.special == "charged" then
						keysubt = 20
						keyspeed = 15
						d.batteried = d.batteried + 200
						npc:PlaySound(SoundEffect.SOUND_BATTERYCHARGE, 1, 0, false, 1)
						local poof = Isaac.Spawn(1000, 49, 1, npc.Position, Vector.Zero, npc):ToEffect()
						poof.SpriteOffset = Vector(0,-40)
						poof:FollowParent(npc)
						poof:Update()
						if d.hurts then
							keysubt = 40
						end
					elseif d.hurts then
						keysubt = 30
					end
					if d.count == 2 then
						throwang = 30
					elseif d.count == 3 then
						throwang = 22.5
					end
					for i = 1, thrownum do
						local vel = (target.Position - npc.Position):Resized(keyspeed):Rotated(-45 + throwang * i)
						local key = Isaac.Spawn(mod.FF.KeyProjectile.ID, mod.FF.KeyProjectile.Var, keysubt, npc.Position, vel, npc)
						key.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
						key:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						mod:GetEntityData(key).speed = keyspeed
						key:Update()
					end
				end

				d.shotsFired = d.shotsFired + 1
				if (d.special == "golden") and d.shotsFired < 4 then
					sprite:Play(d.anim, true)
				else
					if d.aType == "Coin" then
						d.monching = d.monching or 0
						d.monching = d.monching + d.count
						mod:spritePlay(sprite, "FloatDown02")
					else
						mod:spritePlay(sprite, "Spawn")
					end
					d.state = "searching"
				end
			elseif d.aType == "Coin" and sprite:IsEventTriggered("crunch") then
				npc:PlaySound(mod.Sounds.Monch,1,0,false,math.random(115,135)/100)
				if d.hurts then
					sfx:Play(mod.Sounds.CursedPennyNegative, 1, 0, false, 1)
					Isaac.Explode(npc.Position, npc, 10)
					npc:Kill()
					if d.monching and d.monching > 1 then
						for i = 1, d.monching do
							local vel = RandomVector() * math.random(1,6)
							Isaac.Spawn(5, 20, 1, npc.Position, vel, npc)
						end
					end
				end
				if d.special then
					if d.special == "wisp" then
						local wisp = Isaac.Spawn(808,0,0,npc.Position+(RandomVector()*20),Vector.Zero,npc)
						wisp:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						wisp:GetSprite():Load("gfx/enemies/snagger/willo_blue.anm2", true)
						mod:GetEntityData(wisp).IsBlueWillo = true
					elseif d.special == "honey" then
						d.honeybuff = 450
					end
				end
			else
				mod:spritePlay(sprite, d.anim)
			end
		end
	elseif d.state == "blarghe" then
		npc.Velocity = npc.Velocity * 0.7
		if sprite:IsFinished("ShootFull") then
			d.state = "searching"
		elseif sprite:IsEventTriggered("shoot") then
			npc:PlaySound(SoundEffect.SOUND_LITTLE_SPIT,1,2,false,1.3)
			local coins = math.min(d.monching, 5)
			local angHelper = mod.snaggerCoinAngles[coins]

			local params = ProjectileParams()
			params.Variant = mod.FF.BetterCoinProjectile.Var
			local vec = (target.Position - npc.Position):Resized(10):Rotated(angHelper.StartOff)
			for i = 1, coins do
				npc:FireProjectiles(npc.Position, vec:Rotated(angHelper.AddVal * (i - 1)), 0, params)
			end
			d.monching = d.monching - coins
			if d.monching < 1 then
				d.monching = nil
			end
		else
			mod:spritePlay(sprite, "ShootFull")
		end
	elseif d.state == "contrabandFleeing" then
		if not sprite:IsPlaying("Contraband") and d.anim =="Contraband" then
			sprite:Play("Contraband",false)
		end

		if not sprite:IsPlaying("ContrabandItem") and d.anim =="ContrabandItem" then
			sprite:Play("ContrabandItem",false)
		end
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
		d.vec = d.vec or RandomVector()*15
		npc.Velocity = mod:Lerp(npc.Velocity, d.vec, 0.03)
		npc.SpriteOffset = mod:Lerp(npc.SpriteOffset, Vector(0, -100), 0.02)
		d.ColorVal = d.ColorVal or 1
		d.ColorVal = mod:Lerp(d.ColorVal, 0, 0.02)
		npc.Color = Color(d.ColorVal,d.ColorVal,d.ColorVal,1,0,0,0)
		npc.Scale = mod:Lerp(npc.Scale, 2, 0.005)
		if npc.Position.X < -100 or npc.Position.X > room:GetGridWidth()*40+100 or npc.Position.Y > room:GetGridHeight()*40+300 or npc.Position.Y < -300 then
			npc:Remove()
		end
		if npc.StateFrame > 10 then
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			npc.CanShutDoors = false
		end
	elseif d.state == "gigabomb" then
		npc.Velocity = npc.Velocity * 0.7
		if sprite:IsFinished(d.anim) then
			local bomb = Isaac.Spawn(4,17,0,npc.Position,npc.Velocity,npc)
			bomb:GetSprite():Play("Pulse")
			npc:Kill()
		end
	elseif d.state == "poop" then
		npc.Velocity = npc.Velocity * 0.7
		if sprite:IsFinished("EatCoin") then
			d.anim = "Fart"
			sprite:Play("Fart")
		elseif sprite:IsFinished("Fart") then
			d.state = "searching"
		else
			mod:spritePlay(sprite, d.anim)
		end
		if sprite:IsEventTriggered("shoot") then
			if d.special == "bigfart" then
				Isaac.Spawn(245, 0, 0, npc.Position, Vector.Zero, npc)
				game:ButterBeanFart(npc.Position, 170, npc, true)
			else
				game:ButterBeanFart(npc.Position, 85, npc, true)
			end
		elseif sprite:IsEventTriggered("crunch") then
			npc:PlaySound(mod.Sounds.Monch,1,0,false,math.random(115,135)/100)
		end
	end
end

function mod:snaggerKeyAI(npc)
	local d = mod:GetEntityData(npc)
	local sprite = npc:GetSprite()
	local subt = npc.SubType

	local title = "Key"
	if subt > 39 then
		title = "SpicyCharge"
	elseif subt > 29 then
		title = "Spicy"
	elseif subt > 19 then
		title = "Charge"
	elseif subt > 9 then
		title = "Gold"
	end

	if subt % 10 == 0 then
		mod:spritePlay(sprite, title .. "Launch")

		local Gchest = mod.FindClosestEntity(npc.Position, 15, 5, 60, 1)
		local Echest = mod.FindClosestEntity(npc.Position, 15, 5, 53, 1)
		local Schest = mod.FindClosestEntity(npc.Position, 99999, 5, 711, 0)
		if Gchest or Echest or Schest then
			if Echest then
				Echest:ToPickup():TryOpenChest()
			elseif Gchest then
				Gchest:ToPickup():TryOpenChest()
			elseif Schest then
				Schest:GetSprite():Play("Open")
				Schest.SubType = mod.shopChestStates.Opening
				sfx:Play(SoundEffect.SOUND_CHEST_OPEN, 1, 0, false, 1)
				sfx:Play(SoundEffect.SOUND_UNLOCK00, 1, 0, false, 1)
			end
			mod:snaggerKeyGib(npc, subt, true)
			npc:Remove()
		end
	else
		if subt % 10 == 1 then
			mod:spritePlay(sprite, title .. "Head")
		elseif subt % 10 == 2 then
			mod:spritePlay(sprite, title .. "Body")
		end
	end

	npc.FallingAccel = -0.1
	npc.SpriteRotation = npc.Velocity:GetAngleDegrees()
end

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.snaggerKeyAI, mod.FF.KeyProjectile.Var)

function mod:snaggerKeyBreak(npc)
	if npc.Variant == mod.FF.KeyProjectile.Var then
		local d = mod:GetEntityData(npc)
		local sprite = npc:GetSprite()
		local subt = npc.SubType

		if npc.SubType % 10 == 0 then
			for i = -25, 25, 50 do
				local keysubt = 1 + subt
				if i > 0 then
					keysubt = 2 + subt
				end
				local vel = npc.Velocity:Rotated(180 + i):Resized(d.speed)
				local key = Isaac.Spawn(mod.FF.KeyProjectile.ID, mod.FF.KeyProjectile.Var, keysubt, npc.Position, vel, npc)
				key.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
				key:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				key:Update()
			end
		end
		mod:snaggerKeyGib(npc, subt, (npc.SubType % 10 == 0))
	end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, mod.snaggerKeyBreak, mod.FF.KeyProjectile.ID)

function mod:snaggerKeyGib(npc, subt, justSmoke)
	sfx:Play(SoundEffect.SOUND_POT_BREAK,0.7,0,false,1.8)
	for k = 0, 360, 45 do
		local vec = Vector(math.random(3,7),0):Rotated(k - 10 + math.random(20))
		local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, npc.Position + vec:Resized(15), Vector(math.random(3,7),0):Rotated(k - 10 + math.random(20)), npc):ToEffect()
		smoke.SpriteRotation = math.random(360)
		smoke.Color = Color(1,1,1,0.2,0,0,0)
		smoke.SpriteOffset = Vector(0, -16)
		smoke.RenderZOffset = 300
		smoke:Update()
	end
	if not justSmoke then
		for k = 1, 4 do
			local vec = RandomVector() * mod:RandomInt(1,3)
			local gib = Isaac.Spawn(1000, 86, 0, npc.Position + vec:Resized(15), Vector(math.random(3,7),0):Rotated(k - 10 + math.random(20)), npc):ToEffect()
			if subt then
				if subt > 9 and subt < 20 then
					gib.Color = Color(1,1,1,1,100 / 255,50 / 255,-50 / 255)
				elseif subt > 29 and subt < 50 then
					gib.Color = Color(1,1,1,1,150 / 255,50 / 255,20 / 255)
				end
			end
			gib.FallingAcceleration = 1.3
			gib.FallingSpeed = -1
			--gib.PositionOffset = Vector(vec.X, math.abs(vec.Y) * -1)
			gib:Update()
		end
	end
end

function mod:oldsnaggerAI(npc)
	local d = mod:GetEntityData(npc)
	local r = npc:GetDropRNG()
	local p = npc.Position
	local s = npc:GetSprite()

	local snagspeed = 3.2 * math.random(8,10) / 10

	--Initialisation
	if not d.collection then
		d.collection = 0
		d.ammo = {}
		d.frozen_by_buck = false
	end



	--Spawn Attack
	if s:IsFinished("PreSpawn") or s:IsFinished("PreSpawn401") or s:IsFinished("PreSpawn402") or s:IsFinished("PreSpawn404") then
		d.collection = d.collection - 1
		if not s:IsPlaying("Spawn") then
			s:Play("Spawn",false)
		end
		--FIRE
		local ammovar = d.ammo[1][1]
		local ammosub = d.ammo[1][2]
		local target = npc:GetPlayerTarget()
		--Hearts

		--[[if ammovar == 10 then
			local vec = RandomVector()
			for i = 120, 360, 120 do
			mod.cheekyspawn(npc.Position + vec:Rotated(i) * 30, npc, npc.Position + vec:Rotated(i) * 100, 18, 0, 0)
			end]]

		--Coins
		if ammovar == 20 then
		local shotspeed = (target.Position - npc.Position)*0.03
		--fire the projectile
		local projectile = mod:LazySpawnProjectile(7, 0, npc.Position, shotspeed, npc):ToProjectile();
		projectile.FallingSpeed = -30;
		projectile.FallingAccel = 1;

		--Keys
		elseif ammovar == 30 then

		--Bombs
		elseif ammovar == 40 then
			local slot = mod.FindClosestEntity(target.Position, 99999, 6)
			if slot then
				target = slot
			end
			local throwang
			if ammosub == 2 then
				throwang = 30
				thrownum = 2
			else
				throwang = 45
				thrownum = 1
			end

			for i = 1, thrownum do
				local vel = ((target.Position - npc.Position) / 30):Rotated(-45 + throwang * i)
				if vel:Length() > 13 then
					vel = vel:Resized(13)
				end
				local rand = r:RandomFloat()
				local bombshot = mod:LazySpawnProjectile(ProjectileVariant.PROJECTILE_BONE, 0, npc.Position, vel + npc.Velocity, npc):ToProjectile()
				local bombd = mod:GetEntityData(bombshot)
				bombshot.SpawnerEntity = npc
				--Isaac.ConsoleOutput(bombshot.SpawnerEntity.Type)
				bombd.projType = "thrownbomb"
				if ammosub == 4 then bombd.projTypeS = true end
				bombshot.FallingSpeed = -20
				bombshot.FallingAccel = 1.2
				bombshot.Scale = 1
			end
		end
		table.remove(d.ammo,1)



	end
	if s:IsFinished("Spawn") then
		s:Play("FloatDown",false)
	end

	local target = mod:findPickup(npc.Position, 10000, true, npc.InitSeed)
	if d.ammo[1] then
		if d.ammo[1][1] == 40 then target = nil end
	end
	if target ~= nil then
		local td = mod:GetEntityData(target)
		if not td.bumtargeteer then
			td.bumtargeteer = npc.InitSeed
		end
		if not s:IsPlaying("Spawn") then
			s:Play("FloatDown",false)
		end
		d.personalDistance = 30
		if p:Distance(target.Position) < 15 then
			local sprite = target:GetSprite()
			if td.collected == nil then
				td.collected = true
				if target.Variant == 10 then
					npc.HitPoints = npc.HitPoints + npc.MaxHitPoints
					if npc.HitPoints == npc.MaxHitPoints * 5 then
						npc.HitPoints = npc.MaxHitPoints * 5
					end
				elseif target.Variant == 40 and target.SubType == 4 then
					for i = 1, 4 do
					table.insert(d.ammo, 1, {target.Variant, target.SubType})
					end
					d.collection = d.collection+4
				elseif td.projType == "buckbomb" then
					table.insert(d.ammo, 1, {40, 0})
					d.collection = d.collection+1
				else
					table.insert(d.ammo, 1, {target.Variant, target.SubType})
					d.collection = d.collection+1
				end
				local effect = Isaac.Spawn(1000,7000,0,target.Position,Vector.Zero,nil)
				local efsprite = effect:GetSprite()
				efsprite:Load(sprite:GetFilename(),true)
				efsprite:Play("Collect",true)
				target:Remove()
				sprite:Play("Collect",true)
				target:ToPickup():PlayPickupSound()
			end
		end
	else
		target = npc:GetPlayerTarget()
		if d.ammo[1] then
			if d.ammo[1][1] == 40 then
			d.personalDistance = 9999
			else
			d.personalDistance = 250
			end

			if p:Distance(target.Position) < d.personalDistance then
			target = nil
				if not s:IsPlaying("Spawn") then
					if d.ammo[1][1] == 40 then
						s:Play("PreSpawn" .. d.ammo[1][1] .. d.ammo[1][2],false)
					else
						s:Play("PreSpawn",false)
					end
				end
			end
		end
	end

	local targetVelocity = Vector.Zero
	if d.frozen_by_buck == false then
		if target then
			targetVelocity = (target.Position - p):Normalized()*snagspeed
		end
	else
		npc.Velocity = mod:Lerp(npc.Velocity, targetVelocity,0.5) --lerp harder
	end
	npc.Velocity = mod:Lerp(npc.Velocity, targetVelocity,0.2)
end

--Run Snagger AI
function mod:checkSnagger(npc)
	mod:snaggerAI(npc)
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkSnagger, mod.FF.Snagger.ID)

local honeyIcon = Sprite()
honeyIcon:Load("gfx/ui/ff_statuseffects.anm2", true)
honeyIcon:Play("Honey", true)

function mod:renderSnagger(npc)
	local d = mod:GetEntityData(npc)
	if d.batteried and d.interpolationframe then
		npc:Update()
		npc:GetSprite():Update()
		d.interpolationframe = nil
	end
	if d.honeybuff and d.honeybuff > 0 then
		honeyIcon:Render(Isaac.WorldToScreen(npc.Position + Vector(0,-50)), Vector.Zero, Vector.Zero)
	end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.renderSnagger, mod.FF.Snagger.ID)
