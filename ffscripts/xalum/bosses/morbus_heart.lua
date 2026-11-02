local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local CRYING_ANM2 = "gfx/bosses/morbusheart/crying_morbus_heart.anm2"
local CRYING_CREEP_SCALE = 3

return {
	Init = function(npc)
		local data = npc:GetData()
		data.rng = RNG(npc.InitSeed)
		data.beatSpeed = 1
		data.spawnLocation = npc.Position
		data.donePhaseShift = false
		data.spawnCreep = false
		data.nextTomaThreshold = npc.MaxHitPoints * 7/8

		data.spawnsList = {}
		for i = 1, 2 do
			-- Spawn weeper
			-- insert weeper
		end

		-- spawn decorative guts

		local sprite = npc:GetSprite()
		sprite:Play("Heartbeat1")
	end,

	AI = function(npc)
		local data = npc:GetData()
		local sprite = npc:GetSprite()
		local rng = data.rng

		npc.Velocity = data.spawnLocation - npc.Position

		if npc.HitPoints < data.nextTomaThreshold then
			data.nextTomaThreshold = data.nextTomaThreshold - npc.MaxHitPoints * 1/8
			-- blood explode
			-- eject toma chunks
		end

		if npc.HitPoints < npc.MaxHitPoints / 2 and not data.donePhaseShift then
			data.donePhaseShift = true
			data.beatSpeed = 3
			sprite:RemoveOverlay()
			sprite:Play("StartCrying")
		end

		-- if health under 1/3 (1/4?) retract & spawn some big teratoma chunks

		if sprite:IsEventTriggered("Heartbeat") then
			game:MakeShockwave(npc.Position, 0.015, 0.025, 5)

			if sprite:IsPlaying("StartCrying") then
				-- BRIMSTONE

				local creep = Isaac.Spawn(1000, 22, 0, npc.Position, Vector.Zero, npc):ToEffect()
				creep.SpriteScale = creep.SpriteScale * CRYING_CREEP_SCALE
				creep:Update()
			elseif sprite:GetFilename() == CRYING_ANM2 then
				-- BULLETS

				local creep = Isaac.Spawn(1000, 22, 0, npc.Position, Vector.Zero, npc):ToEffect()
				creep.SpriteScale = creep.SpriteScale * CRYING_CREEP_SCALE
				creep:Update()
			end
		end

		if sprite:IsFinished("StartCrying") then
			sprite:Load(CRYING_ANM2)
			sprite:Play("Heartbeat" .. data.beatSpeed)
		end

		if sprite:GetAnimation() == "Heartbeat" .. data.beatSpeed and sprite:GetFrame() == 0 then

			-- if noSpawns and chance then spawn

			if npc.FrameCount > 1 and rng:RandomFloat() < 1/3 then
				sprite:PlayOverlay("Blink" .. data.beatSpeed)
			end
		end

		if sprite:IsOverlayFinished() then
			sprite:RemoveOverlay()
		end
	end,
}