local mod = FiendFolio

local Settings = {
	InactiveSpeed = 2.5,
	ActiveSpeed = 5,

	MinSpinSpeed = 1,
	MaxSpinSpeed = 2.5,
	SpeedDecrease = 0.05,
	StopThreshold = 0.1,

	HeadSpeed = 9,
	HeadJumpSpeed = 7.5,
	Gravity = 1,
}

local frameData = {
	-- Frames past this are for the inactive state
	InactiveStartFrame = 6,

	-- Frames that can be chosen when spawned
	StartFrames = {
		Active 	 = { 1, 2, 3, },
		Inactive = { 9, 10, 11, },
	},

	-- Frames to never stop on
	InvalidFrames = {
		[5]  = true, [6]  = true, [7]  = true,
		[13] = true, [14] = true, [15] = true,
	},
}



-- Update the entity's head based on the helper sprite's frame
local function setHeadFrame(entity)
	local sprite = entity:GetSprite()
	local helper = mod:GetEntityData(entity).NonBinaryHelper

	local headLayer = sprite:GetLayer("head")
	local layerData = helper:GetLayerFrameData( headLayer:GetLayerID() )
	headLayer:SetCropOffset( layerData:GetCrop() )

	entity.I1 = helper:GetFrame()
	entity.V1.X = helper.PlaybackSpeed
end



-- Effects for bouncing off of stuff
local function bounceEffects(entity, noDust)
	-- Sound
	if entity.I1 <= 0 then
		entity.I1 = 6
		mod:PlaySoundCool(nil, SoundEffect.SOUND_STONE_IMPACT, 0.5, 1.15)
	end

	-- Dust
	if not noDust and entity.I2 <= 0 then
		entity.I2 = 6

		local offset = math.random(-30, 30)
		local velocity = -entity.Velocity:Rotated(offset) / 6
		mod:SpawnDust(entity.Position, velocity, 0.6, Color(0.6,0.6,0.6, 0.75))
	end
end



function mod:NonBinaryInit(entity)
	entity:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)

	--[[ Body ]]--
	if entity.SubType ~= mod.FF.NonBinary.HeadSub then
		local data = mod:GetEntityData(entity)

		-- Set the active state
		data.NonBinaryActive = entity.SubType % 2 == 1
		entity.SubType = 0

		-- Create the spin helper
		local helper = Sprite(entity:GetSprite():GetFilename(), true)
		helper:Play("Spin", true)
		helper.PlaybackSpeed = 0
		data.NonBinaryHelper = helper

		-- Set the starting frame
		local state = data.NonBinaryActive and "Active" or "Inactive"
		local frames = frameData.StartFrames[state]
		local rng = RNG(entity.InitSeed)

		local startFrame = mod:RandomIndex(frames, rng)
		helper:SetFrame(startFrame)
		setHeadFrame(entity)


	--[[ Head ]]--
	else
		entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
		entity:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		entity.State = NpcState.STATE_MOVE
	end


	-- Set the spritesheet
	local backdrop = Game():GetRoom():GetBackdropType()
	local entry = mod.roomBackdrop and mod.TotemColorsGFX[2][mod.roomBackdrop] or mod.TotemColorsGFX[1][backdrop]

	if entry then
		if (entry[1] == "A_red" 	  and entry[2] == "B_lightGray")
		or (entry[1] == "A_lightGray" and entry[2] == "B_purple") then
			entity:ReplaceSpritesheet(1, "gfx/enemies/nonbinary/nonbinary_head_pink.png")
			entity:ReplaceSpritesheet(0, "gfx/enemies/nonbinary/nonbinary_body_pink.png")
			entity:GetSprite():LoadGraphics()
		end
	end
end

function mod:NonBinaryUpdate(entity)
	local sprite = entity:GetSprite()


	--[[ Body ]]--
	if entity.SubType ~= mod.FF.NonBinary.HeadSub then
		mod:ChangeFromInit(entity, NpcState.STATE_MOVE)

		if entity.State == NpcState.STATE_MOVE then
			local data = mod:GetEntityData(entity)
			local speed = data.NonBinaryActive and Settings.ActiveSpeed or Settings.InactiveSpeed
			mod:ChasePlayerCool(entity, speed)


			-- Set the animation
			if entity.Velocity:Length() >= 0.1 then
				local angle = entity.Velocity:GetAngleDegrees() % 360 % 180
				local isVert = angle >= 45 and angle <= 135
				local suffix = isVert and "Vert" or entity.Velocity.X < 0 and "Left" or "Right"
				mod:LoopingAnim(sprite, "Walk" .. suffix)
			else
				mod:LoopingAnim(sprite, "Idle")
			end


			-- Update the spinning speed
			local helper = data.NonBinaryHelper

			if helper.PlaybackSpeed > 0 then
				helper.PlaybackSpeed = math.max(Settings.StopThreshold, helper.PlaybackSpeed - Settings.SpeedDecrease)
				local isValidFrame = not frameData.InvalidFrames[ helper:GetFrame() ]

				-- Only stop on valid frames
				if helper.PlaybackSpeed <= Settings.StopThreshold + 0.01 and isValidFrame then
					data.NonBinaryActive = helper:GetFrame() < frameData.InactiveStartFrame
					helper.PlaybackSpeed = 0
				end
			end

			helper:Update()
			setHeadFrame(entity)
		end



	--[[ Head ]]--
	else
		mod:LoopingAnim(sprite, "Spin")

		-- Midair
		if entity.State == NpcState.STATE_JUMP then
			entity.TargetPosition.Y = entity.TargetPosition.Y + Settings.Gravity
			entity.PositionOffset.Y = entity.PositionOffset.Y + entity.TargetPosition.Y

			-- Land
			if entity.PositionOffset.Y >= 0 then
				entity.State = NpcState.STATE_MOVE
				entity.PositionOffset = Vector.Zero
				bounceEffects(entity)
			end


		-- Spinning on the gorund
		elseif entity.State == NpcState.STATE_MOVE then
			local speed = math.max(entity.Velocity:Length(), Settings.HeadSpeed)
			entity.Velocity = entity.Velocity:Resized(speed)
			sprite.PlaybackSpeed = entity.Velocity:Length() * 0.11

			-- Bounce effect cooldowns
			entity.I1 = math.max(0, entity.I1 - 1)
			entity.I2 = math.max(0, entity.I2 - 1)

			-- Die on room clear
			local room = Game():GetRoom()

			if room:IsClear() and room:GetAliveEnemiesCount() <= 0 then
				entity:Kill()
			end
		end
	end
end



-- Bounce off of other entities
function mod:NonBinaryPostCollision(entity, target, bool)
	if entity.SubType == mod.FF.NonBinary.HeadSub and entity.State == NpcState.STATE_MOVE then
		local speed = math.max(1, target.Velocity:Length() / 2)
		entity.Velocity = (entity.Position - target.Position):Resized(speed)
		bounceEffects(entity, true)
	end
end

-- Grid bounce effects
function mod:NonBinaryPostGridCollision(entity, grindex, grid)
	if entity.SubType == mod.FF.NonBinary.HeadSub and entity.State == NpcState.STATE_MOVE and grid then
		bounceEffects(entity)

		-- Activate levers
		local customGrid = StageAPI and StageAPI.GetCustomGrid(grindex)

		if customGrid and customGrid.GridConfig.Name == "FFTotemLever" then
			customGrid.Data.Hitbox:TakeDamage(1, 0, EntityRef(entity), 0)
		end
	end
end



-- Keep track of the last hit direction
function mod:NonBinaryPostDMG(entity, damageAmount, damageFlags, damageSource, damageCountdownFrames)
	if entity.SubType ~= mod.FF.NonBinary.HeadSub and not (damageFlags & DamageFlag.DAMAGE_POISON_BURN > 0) then
		entity.TargetPosition = entity.Position - damageSource.Position
	end
end

-- Spawn the head on death
function mod:NonBinaryDeath(entity)
	if entity.SubType ~= mod.FF.NonBinary.HeadSub then
		local baseVector = entity.TargetPosition:Length() > 0 and entity.TargetPosition or -entity.Velocity
		local offset = mod:Random(-15, 15)
		local velocity = baseVector:Resized(Settings.HeadSpeed):Rotated(offset)

		local head = Isaac.Spawn(entity.Type, entity.Variant, mod.FF.NonBinary.HeadSub, entity.Position, velocity, entity):ToNPC()
		head.State = NpcState.STATE_JUMP
		head.TargetPosition = Vector(0, -Settings.HeadJumpSpeed)

		-- Set the height
		local bodySprite = entity:GetSprite()
		local layerID = bodySprite:GetLayer("head"):GetLayerID()
		head.PositionOffset.Y = bodySprite:GetLayerFrameData(layerID):GetPos().Y
		head:Update()

		-- Set the starting frame and speed
		local headSprite = head:GetSprite()
		headSprite:SetFrame(entity.I1)
		headSprite.PlaybackSpeed = math.max(entity.V1.X, 0.5)
	end
end



-- Spin the heads of all Non-binaries when the totem state switches
function mod:SpinNonBinaries(totemState)
	local queers = Isaac.FindByType(mod.FF.NonBinary.ID, mod.FF.NonBinary.Var, 0)
	local diff = Settings.MaxSpinSpeed - Settings.MinSpinSpeed
	local playSound = false

	for i, entity in pairs(queers) do
		local helper = mod:GetEntityData(entity).NonBinaryHelper
		local addedSpeed = Settings.MinSpinSpeed + mod:Random() * diff
		helper.PlaybackSpeed = math.min(Settings.MaxSpinSpeed, helper.PlaybackSpeed + addedSpeed)

		playSound = true
	end

	if playSound then
		mod:PlaySoundCool(nil, SoundEffect.SOUND_SHELLGAME, 1.1, 1.1)
	end
end
mod:AddCallback(mod.CALLBACK.SWITCH_TOTEMS, mod.SpinNonBinaries)