local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

function mod:griddleRenderAI(npc)
	local sprite = npc:GetSprite()
	if sprite:IsPlaying("Death") and sprite:GetFrame() == 15 then
		npc:PlaySound(SoundEffect.SOUND_BOSS_LITE_GURGLE,0.7,0,false,1)
	elseif sprite:IsPlaying("Death") and sprite:GetFrame() == 36 then
		npc:PlaySound(mod.Sounds.GriddleDeath, 1.5, 0, false, 1)
	end
end

function mod:griddleHornAI(npc, sprite, d)
	local target = npc:GetPlayerTarget()
	local r = npc:GetDropRNG()

	--Used for determining the range at which griddlehorn runs from / runs towards during idle
	local maxdist = 200
	local closedist = 75

	--Initialises griddle's variables
	if not d.init then
		npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		d.state = "appear"
		sprite:Play("Appear", true)
		--Table here shows how often griddle has performed certain attacks
		--During his idle, he'll check this to see the least used attacks.
		d.ad = {--Attacks done
		{"teleport", 0},--Tele
		{"lob", 0},		--Lob
		{"thanos", 0},	--Snap
		{"shoot", 0},	--Shoot
		{"shootmote", 0}--ShootMote
		}
		d.init = true

        local champANM2
		local champ
        if npc.SubType > 0 then
			champ = npc.SubType
		elseif mod:shouldBossBeChampion(npc) then
			--champ = 1
        end

        if champ == 1 then
			npc.SubType = 1
			champANM2 = "gfx/bosses/griddlehorn/boss_griddlehorn_smokey.anm2"
		end
        if champANM2 then
            sprite:Load(champANM2, true)
            sprite:Play("Appear", true)
        end
	else
		--Update this variable each frame to act as a timer
		npc.StateFrame = npc.StateFrame + 1
	end

	--Intended for making sounds when he first spawns
	if npc.FrameCount == 3 then
		sfx:Play(mod.Sounds.FireLight, 0.3, 0, false, 1.3)
	elseif npc.FrameCount == 25 then
		sfx:Play(mod.Sounds.FireFizzle, 0.4, 0, false, 1.3)
	end

	--Changes whether Griddle can be damaged when entering / leaving his hole
	if sprite:IsEventTriggered("DMG") then
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		d.unhurtable = false
	elseif sprite:IsEventTriggered("NoDMG") then
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

	--Sounds synced up to his holes opening / closing
	elseif sprite:IsEventTriggered("HellOpens") then
		sfx:Play(mod.Sounds.FireLight, 0.4, 0, false, 1.3)
	elseif sprite:IsEventTriggered("HellCloses") then
		sfx:Play(mod.Sounds.FireFizzle, 0.4, 0, false, 1.3)
	end

	if d.state == "appear" then
		npc.Velocity = npc.Velocity * 0.75
		if sprite:IsFinished("Appear") then
			d.state = "idle"
			npc.StateFrame = 0
		elseif sprite:IsEventTriggered("Scream") then
			game:ShakeScreen(30)
			npc:PlaySound(mod.Sounds.GriddleScream, 1.5, 0, false, 1)
		else
			mod:spritePlay(sprite, "Appear")
		end


	--The idle movement state
	elseif d.state == "idle" then
		mod:spritePlay(sprite, "Idle")
		npc.Velocity = npc.Velocity * 0.9

		local distance = npc.Position:Distance(target.Position)

		local targetvelocity = npc.Velocity
		--If player is too close
		if distance < 75 then
			targetvelocity = (npc.Position - target.Position):Resized(10)
			--They might teleport, depends if they've done anything recently
			if r:RandomInt(math.max(5, math.ceil(20 - (npc.StateFrame * 0.05)))) == 0 then
				d.state = "teleport"
			end
		--If player is too far
		elseif distance > maxdist then
			--GET CLOSER!
			targetvelocity = (target.Position - npc.Position):Resized(10)
		else
		--Regular idle movement
			--Initialises the data
			d.gridtarget = d.gridtarget or mod:FindRandomFreePosAir(target.Position, 100, maxdist)
			--Ensures it changes place every now and then, also they might move in on the player
			if npc.StateFrame % 75 == 0 then
				d.gridtarget = mod:FindRandomFreePosAir(target.Position, 50, maxdist)
			end
			--Makes em find a new place if they get too close
			if npc.Position:Distance(d.gridtarget) < 30 then
				targetvelocity = nilvector
				d.gridtarget = nil
			else --Otherwise yeah just go to it man
				targetvelocity = (d.gridtarget - npc.Position):Resized(8)
			end
		end

		--The actual velocity
		npc.Velocity = mod:Lerp(npc.Velocity, targetvelocity, 0.05)

		--He wants to stick near you, don't go too far now!
		if distance > 280 then
			d.state = "teleport"
		end

		if npc.StateFrame > 25 then
			if r:RandomInt(10) == 0 then

				local attackchoice = mod.ChooseNextAttack(d.ad, r)

				--Ensures Griddle won't start running to the same position when attacks are complete.
				d.gridtarget = nil
				--Used for the lob attack, just makes sure they'll target a fresh new position
				d.lobthrow = nil
				--Ensures a base nil value for how many lobs he's done
				d.lobcount = 0
				--Finally changes the state to perform a new attack
				d.state = attackchoice
			end
		end

	--Teleporting state, collision / sounds are handled earlier in the code
	elseif d.state == "teleport" then
		--Keeps the boy still
		npc.Velocity = nilvector
		if sprite:IsFinished("Teleport") then
			d.state = "return"
			--Teleport to a new home
			npc.Position = mod:FindRandomFreePosAir(target.Position, 100, maxdist)
		elseif sprite:IsEventTriggered("HellCloses") then
		--elseif sprite:GetFrame() == 25 then
			--Spawns a few fires just to make it threatening
			for i = 1, 6 do
				local fire = Isaac.Spawn(1000,7005, 1, npc.Position, Vector(8,0):Rotated((360/6) * i), npc)
				fire:Update()
			end
		else
			mod:spritePlay(sprite, "Teleport")
		end
	--End of the teleport state, this is when they leave their hole.
	elseif d.state == "return" then
		--Makes sure the little bastard doesn't move
		npc.Velocity = nilvector
		if sprite:IsFinished("Return") then
			--Increases the tally of how many teleports have been performed.
			d.ad[1][2] = d.ad[1][2] + 1
			--I don't think this actually gets used much, d.targ will only stay set after a recent snap attack
			if d.targ then
				d.state = "lob"
			--If there's a fire nearby, get a mote out and set it alight, keeps the room busy.
			elseif mod.FindClosestFire(npc.Position,175) and mod.GetEntityCount(mod.FF.Mote.ID, mod.FF.Mote.Var) < 2 then
				d.state = "shootmote"
			--Otherwise just return to idle
			else
				d.state = "idle"
			end
			--Reset the timer
			npc.StateFrame = 0
		else
			mod:spritePlay(sprite, "Return")
		end

	--Snap attack, changes depending on gunpowder in the room
	elseif d.state == "thanos" then
		--STOP MOVING BOY
		npc.Velocity = nilvector
		if sprite:IsFinished("SnapFinger") then
			--When all's set and done, return to the idle state.
			d.state = "idle"
			--Increase the number of snaps performed
			d.ad[3][2] = d.ad[3][2] + 1
			--Reset the timer as per usual
			npc.StateFrame = 0
		elseif sprite:IsEventTriggered("Snap") then
			npc:PlaySound(mod.Sounds.fingersnap,2.5,0,false,1)

			--This checks the amount of gunpowder creep in the room
			local numgunpowders = mod.GetEntityCount(1000,26, 7001)
			--If there isn't much, Griddle will spawn a bunch around the player
			if numgunpowders < 5 then

				--Spawns a smoke effect to look nice
				local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, target.Position, nilvector, npc)
				smoke.SpriteScale = Vector(3.5,3.5)
				smoke.SpriteOffset = Vector(0, -50)
				smoke:Update()

				--Calls a function that handles gunpowder, gives it a long timeout / fire time
				mod.SpawnGunpowder(npc, target.Position, 500, 200)

				--Determines a vector to be used by the cross pattern
				local vec = Vector(0,25)
				--Randomly selects if it's diagonal or cardinal
				if r:RandomInt(2) == 0 then vec = vec:Rotated(45) end
				--A loop that rotates by 90 degrees until it reaches 360
				for i = 90, 360, 90 do
					--Used to multiply the vector for distances of 25, 50 and 75
					for k = 1, 3 do
						--Finally spawns the gunpowder, the spread radius is lower here to make the cross light in a cooler way
						mod.SpawnGunpowder(npc, target.Position + vec:Rotated(i) * k, 500, 200, 30)
					end
				end

				--This gets set but is otherwise currently unused outside of a rare teleport combo
				--Could be interesting to include in a lob combo
				if r:RandomInt(3) == 0 then
					d.targ = target.Position
				end

			--If there's plenty of gunpowder in the room, just set it all alight!
			else
				--BURN BABY BURN (this calls a custom function)
				mod:SetRoomAlight(npc)
				sfx:Play(mod.Sounds.FireLight, 0.3, 0, false, 1.2)
			end
		else
			mod:spritePlay(sprite, "SnapFinger")
		end

	--The name shoot is a bit misleading, this is Griddle's vomit attack, where a bunch of coal is launched up.
	elseif d.state == "shoot" then
		--Stops him from moving during the attack
		npc.Velocity = nilvector

		if sprite:IsFinished("Shoot") then
			--If attack is all set and done, this can lead into a couple combos
			local rand = r:RandomInt(3)
			--First involves the snap attack, he'll likely set the room alight
			if rand == 0 then
				d.state = "thanos"
			--Since his teleport leaves a bunch of fire around it, this'll set the surrounding fires alight
			elseif rand == 1 then
				d.state = "teleport"
			--Otherwise he might just return to his idle phase for fun
			else
				d.state = "idle"
			end
			--Increases the tally for how many times he's vomited, and resets the timer
			d.ad[4][2] = d.ad[4][2] + 1
			npc.StateFrame = 0
		elseif sprite:IsEventTriggered("Shoot") then
			npc:PlaySound(SoundEffect.SOUND_BOSS_LITE_GURGLE,0.7,0,false,1.9)
			--Ensures at least one coal is headed towards the player, not entirely random
			local vel = ((target.Position - npc.Position) / 30)
			--Make sure he's not launching them too far
			if vel:Length() > 13 then
				vel = vel:Resized(13)
			end
			--There will always be at least 3 shots fired, up to 5
			local numshots = r:RandomInt(3) + 3
			for i = 1, numshots do
				--Due to custom behaviour, we spawn a projectile manually rather than through default projectile firing code.
				local coal = mod:LazySpawnProjectile(1, 0, npc.Position, vel:Rotated((360 / numshots)*i), npc):ToProjectile()
				coal.SpawnerEntity = npc

				--This lets us pass some values to be used in the projectile's update
				--Timeout and burntime are specific data values used by gunpowder
				local coald = mod:GetEntityData(coal)
				coald.projType = "coal"
				coald.timeout = 500
				coald.burntime = 200

				--This messes with more of the default values, it'll fall slightly randomly
				coal.FallingSpeed = -22 + r:RandomInt(5)
				coal.FallingAccel = 1.2

				--This updates the sprite to look nice and fancy
				local coals = coal:GetSprite()
				coals:Load("gfx/projectiles/sooty_tear.anm2",true)
				coals:Play("spin",true)

				--Then ensure the projectile runs through its code this frame so it's working right.
				coal:Update()
			end
		else
			mod:spritePlay(sprite, "Shoot")
		end

	--Burning coal throw attack
	elseif d.state == "lob" then
		--Initialisation for the attack
		if not d.lobthrow then

			--Returns a vector from the player to griddle, whilst also saving the player's position at the time
			local thingy = (target.Position - npc.Position)
			d.targ = target.Position

			--Unused code where they would initially target gunpowder. Wasn't too useful.
			--[[local gunpowder = mod.FindClosestEntity(npc.Position,200,1000,26,7001)
			if gunpowder then
				thingy = (gunpowder.Position - npc.Position)
				d.targ = gunpowder.Position
			else
				thingy = (target.Position - npc.Position)
				d.targ = target.Position
			end]]

			--The attacks are a bit specifically animated, with one being better at vertical, the other at horizontal throws.
			if math.abs(thingy.X) > math.abs(thingy.Y) then
				d.lobthrow = 1
			else
				d.lobthrow = 2
			end

			--Just checks which side of griddle the player is on, and if they should use their left or right hand.
			if target.Position.X > npc.Position.X then
				sprite.FlipX = true
			else
				sprite.FlipX = false
			end
		end

		--As usual, keep griddle still
		npc.Velocity = nilvector

		--This concatenates the string for where horn throws it.
		if sprite:IsFinished("ThrowCoal0" .. d.lobthrow) then
			--Resets the throwing state
			d.lobthrow = nil
			d.targ = nil
			npc.StateFrame = 0

			--Some code to determine if griddle is ready to stop throwing coal. Max is three throws.
			if d.lobcount > 2 or math.random(4 - d.lobcount) == 1 then
				--When he's ready to stop, he tallies a new lob, and goes back to a normal state.
				d.ad[2][2] = d.ad[2][2] + 1
				d.state = "idle"
				--Resets his lobcount for next time
				d.lobcount = 0
				--Unflips his sprite if it was.
				sprite.FlipX = false
			else
				--He threw another shot, keeps it going up
				d.lobcount = d.lobcount + 1
				--Due to lobthrow being nil, quickly changes it to idle and resets the animation used
				sprite:Play("Idle")
			end
		--A quick sound trigger
		elseif sprite:IsEventTriggered("Raise") then
			npc:PlaySound(SoundEffect.SOUND_SHELLGAME,0.7,0,false,1.1)
		elseif sprite:IsEventTriggered("Shoot") then
			--Makes the sounds slightly random.
			npc:PlaySound(SoundEffect["SOUND_LITTLE_HORN_GRUNT_" .. math.random(1,2)],1.2,0,false,math.random(80,90)/100)
			sfx:Play(SoundEffect.SOUND_SHELLGAME, 0.6, 0, false, 0.8)

            local shootNum = 1
            if npc.SubType == 1 then
                shootNum = 3
            end
            for i = 1, shootNum do
                --Check the "shoot" state for a better explanation of this, it's mostly the same
                local vel = (d.targ - npc.Position):Resized(7 / i)
                local coal = mod:LazySpawnProjectile(1, 0, npc.Position, vel, npc):ToProjectile()
                coal.SpawnerEntity = npc
                --Lets us mess with the projectile manually
                local coald = mod:GetEntityData(coal)
                if npc.SubType == 1 then
                    coald.projType = "coal"
                else
                    coald.projType = "coal2"
                end
                --Some regular projectile settings
                coal.FallingSpeed = -25
                coal.FallingAccel = 1
                --Change it's sprite to be prettier
                local coals = coal:GetSprite()
                if npc.SubType == 1 then
                    coals:Load("gfx/projectiles/sooty_tear.anm2",true)
                else
                    coals:Load("gfx/projectiles/sooty_tear2.anm2",true)
                end
                coals:Play("spin",true)
                --Update the projectile this frame
                coal:Update()
            end
		else
			mod:spritePlay(sprite, "ThrowCoal0" .. d.lobthrow)
		end

	--Mote shootin time!
	elseif d.state == "shootmote" then
		--You probably know the drill at this point
		npc.Velocity = nilvector
		if sprite:IsFinished("ShootMote") then
			--Reset the state when all's done
			d.state = "idle"
			d.ad[5][2] = d.ad[5][2] + 1
			npc.StateFrame = 0
		elseif sprite:IsEventTriggered("Shoot") then
			npc:PlaySound(SoundEffect.SOUND_WHEEZY_COUGH,1,0,false,1.25)

			--Initialises the variable
			local dist
			--Checks if there's a fire nearby that the mote can be put through
			local fire = mod.FindClosestFire(npc.Position, 200)

			--If there IS a fire, shoot that mote right at it
			if fire then
				dist = (fire.Position - npc.Position):Resized(4)
			--Otherwise go for the player
			else
				dist = (target.Position - npc.Position):Resized(4)
			end

			--Spawns the ball
            if npc.SubType == 1 then
                local bol = mod.spawnent(npc, npc.Position + dist, dist, EntityType.ENTITY_LITTLE_HORN, 1)
                bol:Update()
            else
                local bol = mod.spawnent(npc, npc.Position + dist, dist, mod.FF.Mote.ID, mod.FF.Mote.Var)
                bol:Update()
            end

			--A nice effect to look nice alongside the spawn
			local smoke = Isaac.Spawn(1000, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, npc.Position, nilvector, npc)
			smoke.SpriteScale = Vector(3,3)
			smoke.SpriteOffset = Vector(0, -25)
			smoke:Update()
		else
			mod:spritePlay(sprite, "ShootMote")
		end
	end
end