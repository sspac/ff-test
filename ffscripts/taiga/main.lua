FiendFolio.LoadScripts({
	-- Enemies
    "ffscripts.taiga.enemies.onlooker",
    "ffscripts.taiga.enemies.punted",
    "ffscripts.taiga.enemies.cuffs",
    "ffscripts.taiga.enemies.empath",
    "ffscripts.taiga.enemies.psychoAndManicFlies",
    "ffscripts.taiga.enemies.warble",
    "ffscripts.taiga.enemies.sensoryGrimace",
    "ffscripts.taiga.enemies.riftwalker",
	"ffscripts.taiga.enemies.fishfreak",
	"ffscripts.taiga.enemies.kingAndPawn",
	"ffscripts.taiga.enemies.foetus",
	"ffscripts.taiga.enemies.anemone",
	"ffscripts.taiga.enemies.oralopede",
	"ffscripts.taiga.enemies.oralid",
	"ffscripts.taiga.enemies.thrall",
	"ffscripts.taiga.enemies.clicketyChar",
	"ffscripts.taiga.enemies.summons",

	"ffscripts.taiga.enemies.proofOfConcept.brimstoneDrinkWorm",

	-- Bosses
	"ffscripts.taiga.bosses.ghostbuster",
	"ffscripts.taiga.bosses.foozTwins",
	"ffscripts.taiga.bosses.babyBubbles",

	-- Curses
	"ffscripts.taiga.curses.curseOfTheGate",

	-- Items
	"ffscripts.taiga.items.pinhead",
	"ffscripts.taiga.items.crucifix",
	"ffscripts.taiga.items.bedtimeStory",
	"ffscripts.taiga.items.prankCookie",
	"ffscripts.taiga.items.devilsHarvest",
	"ffscripts.taiga.items.rubberBullets",
	"ffscripts.taiga.items.theDeluxe",
	"ffscripts.taiga.items.lilMinx",
	"ffscripts.taiga.items.purplePutty",
	"ffscripts.taiga.items.fetalFiend",
	"ffscripts.taiga.items.fiendMix",
	"ffscripts.taiga.items.secretStash",
	"ffscripts.taiga.items.fiendHeart",
	"ffscripts.taiga.items.devilledEgg",
	"ffscripts.taiga.items.perfectlyGenericObject",
	"ffscripts.taiga.items.pageOfVirtues",
	"ffscripts.taiga.items.bridgeBombs",
	"ffscripts.taiga.items.lawnDarts",
	"ffscripts.taiga.items.toyPiano",
	"ffscripts.taiga.items.hypnoRing",
	"ffscripts.taiga.items.musca",
	"ffscripts.taiga.items.modelRocket",
	"ffscripts.taiga.items.siblingSyl",
	"ffscripts.taiga.items.wrongWarp",
	"ffscripts.taiga.items.dadsDip",
	"ffscripts.taiga.items.yickHeart",
	"ffscripts.taiga.items.anathema",
	"ffscripts.taiga.items.dogWhistle",
	"ffscripts.taiga.items.doomsdayClock",
	"ffscripts.taiga.items.shockImage",
	"ffscripts.taiga.items.stringTheory",
	"ffscripts.taiga.items.loadsamoney",
	"ffscripts.taiga.items.stardust",
	"ffscripts.taiga.items.planetX",
	"ffscripts.taiga.items.greenApple",
	"ffscripts.taiga.items.thePyx",
	"ffscripts.taiga.items.holyBean",
	"ffscripts.taiga.items.appendix",
	"ffscripts.taiga.items.canOfBeans",
	"ffscripts.taiga.items.blackEyedPea",
	"ffscripts.taiga.items.snoozeButton",
	"ffscripts.taiga.items.anarchistsEasyBake",
	"ffscripts.taiga.items.boundlessParasol",
	"ffscripts.taiga.items.repression",
	"ffscripts.taiga.items.rabbitsFoot",
	"ffscripts.taiga.items.greenBombs",
	"ffscripts.taiga.items.crushingAnxiety",
	"ffscripts.taiga.items.ycukHeart",
	"ffscripts.taiga.items.stevenSandwich",

	-- Trinkets
	"ffscripts.taiga.trinkets.leftovers",
	"ffscripts.taiga.trinkets.pincushion",
	"ffscripts.taiga.trinkets.sewingManual",
	"ffscripts.taiga.trinkets.sanguineSalivation",
	"ffscripts.taiga.trinkets.lunaticEye",
	"ffscripts.taiga.trinkets.characterSelect",
	"ffscripts.taiga.trinkets.ammoClip",

	-- Grids
	"ffscripts.taiga.grids.dogDoo",

	-- Pickups
	"ffscripts.taiga.pickups.copperBombs",
	"ffscripts.taiga.pickups.soulShards",

	-- Challenges
	"ffscripts.taiga.challenges.brickByBrick",
	"ffscripts.taiga.challenges.embryosAkimbo",
	"ffscripts.taiga.challenges.allowEnemyReplacements",
	"ffscripts.taiga.challenges.penIsland",
	"ffscripts.taiga.challenges.babySensory",
	"ffscripts.taiga.challenges.imperishableNight",

	-- Guns
	"ffscripts.taiga.guns.largeZit",
	"ffscripts.taiga.guns.megaBlast",

	-- Misc
	"ffscripts.taiga.misc.segmentedEnemyHandling",
	"ffscripts.taiga.misc.enemyDeathAnimations",
	"ffscripts.taiga.misc.sirenBlacklist",
	"ffscripts.taiga.misc.stevenTransformation",
	"ffscripts.taiga.misc.roomBlocking",
})

local mod = FiendFolio
local game = Game()
local nilvector = Vector.Zero

-- General (enemies)
function mod:update120(npc)
	local sprite = npc:GetSprite();
	local npcdata = mod:GetEntityData(npc);
	local var = npc.Variant

	if var == mod.FF.Onlooker.Var then
		mod:onlookerAI(npc, sprite, npcdata)
	elseif var == mod.FF.Punted.Var then
		mod:puntedAI(npc, sprite, npcdata)
	elseif var == mod.FF.Cuffs.Var then
		mod:cuffsAI(npc, sprite, npcdata)
	elseif var == mod.FF.Empath.Var then
		mod:empathAI(npc, sprite, npcdata)
	elseif var == mod.FF.ManicFly.Var then
		mod:manicFlyAI(npc, sprite, npcdata)
	elseif var == mod.FF.Warble.Var then
		mod:warbleAI(npc, sprite, npcdata)
	elseif var == mod.FF.RiftWalker.Var then
		mod:riftWalkerAI(npc, sprite, npcdata)
	elseif var == mod.FF.Fishfreak.Var then
		mod:fishfreakAI(npc, sprite, npcdata)
	elseif var == mod.FF.King.Var then
		mod:kingAI(npc, sprite, npcdata)
	elseif var == mod.FF.Pawn.Var then
		mod:pawnAI(npc, sprite, npcdata)
	elseif var == mod.FF.Foetus.Var then
		mod:foetusAI(npc, sprite, npcdata)
	elseif var == mod.FF.Anemone.Var then
		mod:anemoneAI(npc, sprite, npcdata)
	elseif var == mod.FF.Oralopede.Var then
		mod:oralopedeAI(npc, sprite, npcdata)
	elseif var == mod.FF.Oralid.Var then
		mod:oralidAI(npc, sprite, npcdata)
	elseif var == mod.FF.Thrall.Var then
		mod:thrallAI(npc, sprite, npcdata)
	elseif var == 237 then
		if npc.SubType == 0 then
			mod:brimstoneDrinkWormAI(npc, sprite, npcdata)
		elseif npc.SubType == 1 then
			mod:drinkWormBrimballAI(npc, sprite, npcdata)
		end
	elseif var == mod.FF.ClicketyChar.Var then
		mod:clicketyCharAI(npc, sprite, npcdata)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.update120, mod.FFID.Taiga)

function mod:render120(npc, offset)
	local sprite = npc:GetSprite();
	local npcdata = mod:GetEntityData(npc);
	local var = npc.Variant

	if var == mod.FF.RiftWalker.Var then
		mod:riftWalkerRender(npc, sprite, npcdata, offset)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.render120, mod.FFID.Taiga)

function mod:takeDmg120(entity, damage, flags, source, countdown)
	local var = entity.Variant

	if var == mod.FF.Onlooker.Var then
		return mod:onlookerTakeDmg(entity, damage, flags, source, countdown)
	elseif var == mod.FF.Punted.Var then
		return mod:puntedTakeDmg(entity, damage, flags, source, countdown)
	elseif var == mod.FF.Cuffs.Var then
		return mod:cuffsTakeDmg(entity, damage, flags, source, countdown)
	elseif var == mod.FF.Warble.Var then
		return mod:warbleTakeDmg(entity, damage, flags, source, countdown)
	elseif var == mod.FF.RiftWalker.Var then
		return mod:riftWalkerTakeDmg(entity, damage, flags, source, countdown)
	elseif var == mod.FF.Fishfreak.Var then
		return mod:fishfreakTakeDmg(entity, damage, flags, source, countdown)
	elseif var == mod.FF.Pawn.Var then
		return mod:pawnTakeDmg(entity, damage, flags, source, countdown)
	elseif var == mod.FF.Oralopede.Var then
		return mod:oralopedeTakeDmg(entity, damage, flags, source, countdown)
	elseif var == mod.FF.Oralid.Var then
		return mod:oralidTakeDmg(entity, damage, flags, source, countdown)
	elseif var == 237 then
		return mod:brimstoneDrinkWormTakeDmg(entity, damage, flags, source, countdown)
	elseif var == mod.FF.ClicketyChar.Var then
		return mod:clicketyCharTakeDmg(entity, damage, flags, source, countdown)
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.takeDmg120, mod.FFID.Taiga)

function mod:kill120(entity)
	local var = entity.Variant

	--[[if var == mod.FF.Warble.Var then
		mod:warbleKill(entity)
	else]]
	if var == mod.FF.Fishfreak.Var then
		mod:fishfreakKill(entity)
	elseif var == mod.FF.ClicketyChar.Var then
		mod:clicketyCharKill(entity)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.kill120, mod.FFID.Taiga)

function mod:collide120(entity, collider, low)
	local var = entity.Variant

	if var == mod.FF.Punted.Var then
		return mod:puntedCollision(entity, collider, low)
	elseif var == mod.FF.Warble.Var then
		return mod:warbleCollision(entity, collider, low)
	elseif var == mod.FF.Pawn.Var then
		return mod:pawnCollision(entity, collider, low)
	end
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.collide120, mod.FFID.Taiga)

-- Misc. helper functions

function mod:getSign(rng)
    local r = rng:RandomInt(2)
    if r == 0 then
        return -1
    else
        return 1
    end
end

function mod:copyColor(color)
	local colorize = color:GetColorize()
	return Color(color.R, color.G, color.B, color.A, color.RO, color.GO, color.BO, colorize.R, colorize.G, colorize.B, colorize.A)
end

function mod:swapMinecartContents(npc1, npc2, gridcoll1, gridcoll2)
	local minecart1 = nil
	local minecart2 = nil

	local minecarts = Isaac.FindByType(EntityType.ENTITY_MINECART)
	for _, minecart in ipairs(minecarts) do
		if minecart.Child == nil then
			--continue
		elseif minecart.Child.Index == npc1.Index and minecart.Child.InitSeed == npc1.InitSeed then
			minecart1 = minecart:ToNPC()
		elseif minecart.Child.Index == npc2.Index and minecart.Child.InitSeed == npc2.InitSeed then
			minecart2 = minecart:ToNPC()
		end
	end

	if minecart1 then
		local replacement = Isaac.Spawn(minecart1.Type, 1, minecart1.SubType, minecart1.Position, minecart1.Velocity, nil):ToNPC()
		replacement.Child = npc2
		replacement:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

		npc2.Position = minecart1.Position
		npc2.DepthOffset = 0.01
		npc2.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE

		replacement.I1 = minecart1.I1
		replacement.I2 = minecart1.I2
		replacement.V1 = minecart1.V1
		replacement.V2 = minecart1.V2
		replacement.State = minecart1.State
		replacement.StateFrame = minecart1.StateFrame

		mod:GetEntityData(npc2).FFManualMinecart = replacement
		mod:GetEntityData(replacement).FFIsManualMinecart = true

		local minecartSprite = minecart1:GetSprite()
		local replacementSprite = replacement:GetSprite()

		replacementSprite:Play(minecartSprite:GetAnimation(), true)
		replacementSprite:SetFrame(minecartSprite:GetFrame())

		replacementSprite.FlipX = minecartSprite.FlipX
		replacementSprite.FlipY = minecartSprite.FlipY
		replacementSprite.PlaybackSpeed = minecartSprite.PlaybackSpeed
		replacementSprite.Rotation = minecartSprite.Rotation
		replacementSprite.Scale = minecartSprite.Scale

		replacement:Update()

		minecart1.Child = nil
		minecart1:Remove()
	else
		mod:GetEntityData(npc2).FFManualMinecart = nil
		npc2.SpriteOffset = Vector(0,0)
		npc2.DepthOffset = 0
		npc2.GridCollisionClass = gridcoll2
	end

	if minecart2 then
		local replacement = Isaac.Spawn(minecart2.Type, 1, minecart2.SubType, minecart2.Position, minecart2.Velocity, nil):ToNPC()
		replacement.Child = npc1
		replacement:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

		npc1.Position = minecart2.Position
		npc1.DepthOffset = 0.01
		npc1.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE

		replacement.I1 = minecart2.I1
		replacement.I2 = minecart2.I2
		replacement.V1 = minecart2.V1
		replacement.V2 = minecart2.V2
		replacement.State = minecart2.State
		replacement.StateFrame = minecart2.StateFrame

		mod:GetEntityData(npc1).FFManualMinecart = replacement
		mod:GetEntityData(replacement).FFIsManualMinecart = true

		local minecartSprite = minecart2:GetSprite()
		local replacementSprite = replacement:GetSprite()

		replacementSprite:Play(minecartSprite:GetAnimation(), true)
		replacementSprite:SetFrame(minecartSprite:GetFrame())

		replacementSprite.FlipX = minecartSprite.FlipX
		replacementSprite.FlipY = minecartSprite.FlipY
		replacementSprite.PlaybackSpeed = minecartSprite.PlaybackSpeed
		replacementSprite.Rotation = minecartSprite.Rotation
		replacementSprite.Scale = minecartSprite.Scale

		replacement:Update()

		minecart2.Child = nil
		minecart2:Remove()
	else
		mod:GetEntityData(npc1).FFManualMinecart = nil
		npc1.SpriteOffset = Vector(0,0)
		npc1.DepthOffset = 0
		npc1.GridCollisionClass = gridcoll1
	end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, minecart)
	if mod:GetEntityData(minecart).FFIsManualMinecart and minecart.Child then
		minecart.Child.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
	end
end, EntityType.ENTITY_MINECART)

mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, minecart, offset)
	if mod:GetEntityData(minecart).FFIsManualMinecart then
		mod:GetEntityData(minecart).LastRenderOffset = offset

		if minecart.Child then
			local minecartSprite = minecart:GetSprite()

			local y
			if minecartSprite:IsPlaying("Move1") or minecartSprite:IsFinished("Move1") then
				y = -5
			elseif  minecartSprite:IsPlaying("Move2") or minecartSprite:IsFinished("Move2") then
				y = -4
			elseif  minecartSprite:IsPlaying("Move3") or minecartSprite:IsFinished("Move3") then
				y = -3
			elseif  minecartSprite:IsPlaying("Move4") or minecartSprite:IsFinished("Move4") then
				y = -1
			elseif  minecartSprite:IsPlaying("Move5") or minecartSprite:IsFinished("Move5") then
				y = 1
			elseif  minecartSprite:IsPlaying("Move6") or minecartSprite:IsFinished("Move6") then
				y = -1
			elseif  minecartSprite:IsPlaying("Move7") or minecartSprite:IsFinished("Move7") then
				y = -3
			elseif  minecartSprite:IsPlaying("Move8") or minecartSprite:IsFinished("Move8") then
				y = -4
			else
				return
			end

			if minecartSprite:GetFrame() >= 3 then
				y = y + 1
			end

			minecart.Child.SpriteOffset = Vector(0, y)
		end
	end
end, EntityType.ENTITY_MINECART)

function mod:finishManualMinecartRendering(npc, offset, data)
	if data.FFManualMinecart then
		local minecart = data.FFManualMinecart

		local minecartSprite = minecart:GetSprite()
		minecartSprite:RenderLayer(1, Isaac.WorldToRenderPosition(minecart.Position + minecart.PositionOffset) + (mod:GetEntityData(minecart).LastRenderOffset or Vector(0,0)))
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, function(_, pickup, offset)
	if mod:GetEntityData(pickup).FFManualMinecart then
		local minecart = mod:GetEntityData(pickup).FFManualMinecart

		local minecartSprite = minecart:GetSprite()
		minecartSprite:RenderLayer(1, Isaac.WorldToRenderPosition(minecart.Position + minecart.PositionOffset) + (mod:GetEntityData(minecart).LastRenderOffset or Vector(0,0)))
	end
end)

function mod:iWillMakeFlyGameWorkGoddamnit(knife, collider, low)
	-- i will make this stupid room work or die trying
	if collider.Type == mod.FF.Flickerspirit.ID and
	   collider.Variant == mod.FF.Flickerspirit.Var and
	   mod:GetEntityData(collider).eternalFlickerspirited and
	   not collider:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) and
	   not collider:HasEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK) and
	   not collider:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK) and
	   knife.TearFlags & TearFlags.TEAR_KNOCKBACK ~= TearFlags.TEAR_KNOCKBACK
	then
		collider.Velocity = Vector.FromAngle(knife.Rotation):Resized(10)
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_PRE_KNIFE_COLLISION, math.huge, mod.iWillMakeFlyGameWorkGoddamnit)

mod.BossRushFlooded = false
mod.BossRushFloodedOldWater = nil
mod.BossRushFloodedShouldDrain = false
function mod:floodBossRush()
	for i = 1, 60 do
		mod.scheduleForUpdate(function()
			local room = game:GetRoom()
			local oldWaterAmount = room:GetWaterAmount()
			local newWaterAmount = i / 60
			if newWaterAmount > oldWaterAmount then
				room:SetWaterAmount(newWaterAmount)
				mod.BossRushFlooded = true
				if mod.BossRushFloodedOldWater == nil then
					mod.BossRushFloodedOldWater = oldWaterAmount
				end
			end
		end, i)
	end
	mod.BossRushFloodedShouldDrain = false
end

function mod:drainBossRush()
	for i = 1, 30 do
		mod.scheduleForUpdate(function()
			local room = game:GetRoom()
			local oldWaterAmount = room:GetWaterAmount()
			local newWaterAmount = math.max(mod.BossRushFloodedOldWater or 0, (30 - i) / 30)
			if newWaterAmount < oldWaterAmount then
				room:SetWaterAmount(newWaterAmount)
				mod.BossRushFlooded = true
				if newWaterAmount <= (mod.BossRushFloodedOldWater or 0) then
					mod.BossRushFlooded = false
					mod.BossRushFloodedOldWater = nil
				end
			end
		end, i)
	end
end

if ModCallbacks.MC_POST_START_AMBUSH_WAVE then
mod:AddCallback(ModCallbacks.MC_POST_START_AMBUSH_WAVE, function(_, bossAmbush)
	if bossAmbush and game:GetRoom():GetType() == RoomType.ROOM_BOSSRUSH and mod.BossRushFlooded then
		mod.scheduleForUpdate(function()
			if mod.BossRushFloodedShouldDrain then
				mod:drainBossRush()
			end
		end, 32)
		mod.BossRushFloodedShouldDrain = true
	end
end)
end

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function()
	if mod.BossRushFlooded then
		mod:drainBossRush()
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	mod.BossRushFlooded = false
	mod.BossRushFloodedOldWater = nil
	mod.BossRushFloodedShouldDrain = false
end)

function mod:GetMultiShotPositionVelocityBasic(shotDir, shotSpeed, numTears, index)
	-- stripped down version of GetMultiShotPositionVelocity that only accounts for the number of tears and nothing else like num eyes active or cross-eyed shots
	local pos = Vector(0,0)
	local vel = Vector(shotDir.X * shotSpeed, shotDir.Y * shotSpeed)

	if numTears > 1 then
		local spreadAngle = (numTears - 1) * 2.17
		local tearAngleRatio = math.min(math.max(0, index / (numTears - 1)), 1)
		local tearAngle = math.rad(tearAngleRatio * 180 - 90)
		local shotDirLength = shotDir:Length()

		pos = Vector(math.cos(tearAngle) * 1.15 * shotDirLength, math.sin(tearAngle) * 0.8 * shotDirLength):Rotated(shotDir:GetAngleDegrees())
		vel = vel:Rotated(spreadAngle * 2 * tearAngleRatio - spreadAngle)
	end

	return pos, vel
end

-- colorize.rgb: default color of outline pixels when no nearby non-outline pixels can be found (uses H and S in HSV color space)
-- colorize.a: threshold beneath which outline pixels are detected (based on V in HSV color space, [0,1], defaults to 0.25 when not set)
mod.NeonItemColors = {
	[CollectibleType.COLLECTIBLE_SAD_ONION] = Color(1,1,1,1,0,0,0,153/255,201/255,141/255,0),
	[CollectibleType.COLLECTIBLE_BLOOD_OF_THE_MARTYR] = Color(1,1,1,1,0,0,0,199/255,123/255,10/255,0),
	[CollectibleType.COLLECTIBLE_DOLLAR] = Color(1,1,1,1,0,0,0,0,0,0,0.3),
	[CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL] = Color(1,1,1,1,0,0,0,0,0,0,0.14),
	[CollectibleType.COLLECTIBLE_NECRONOMICON] = Color(1,1,1,1,0,0,0,0,0,0,0.22),
	[CollectibleType.COLLECTIBLE_TAMMYS_HEAD] = Color(1,1,1,1,0,0,0,245/255,207/255,160/255,0),
	[CollectibleType.COLLECTIBLE_KAMIKAZE] = Color(1,1,1,1,0,0,0,234/255,19/255,20/255,0),
	[CollectibleType.COLLECTIBLE_BOBS_ROTTEN_HEAD] = Color(1,1,1,1,0,0,0,239/255,247/255,196/255,0),
	[CollectibleType.COLLECTIBLE_TELEPORT] = Color(1,1,1,1,0,0,0,73/255,182/255,236/255,0),
	[CollectibleType.COLLECTIBLE_LUCKY_FOOT] = Color(1,1,1,1,0,0,0,202/255,194/255,2/255,0),
	[CollectibleType.COLLECTIBLE_PENTAGRAM] = Color(1,1,1,1,0,0,0,209/255,0/255,0/255,0),
	[CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS] = Color(1,1,1,1,0,0,0,0,0,0,0.59),
	[CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL_PASSIVE] = Color(1,1,1,1,0,0,0,0,0,0,0.14),
	[CollectibleType.COLLECTIBLE_CHARM_VAMPIRE] = Color(1,1,1,1,0,0,0,0,0,0,0.14),
	[CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK] = Color(1,1,1,1,0,0,0,0,0,0,0.50),
	[CollectibleType.COLLECTIBLE_PHD] = Color(1,1,1,1,0,0,0,0,0,0,0.27),
	[CollectibleType.COLLECTIBLE_XRAY_VISION] = Color(1,1,1,1,0,0,0,200/255,119/255,121/255,0),
	[CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS] = Color(1,1,1,1,0,0,0,0,0,0,0.19),
	[CollectibleType.COLLECTIBLE_DEAD_CAT] = Color(1,1,1,1,0,0,0,0,0,0,0.19),
	[CollectibleType.COLLECTIBLE_LOKIS_HORNS] = Color(1,1,1,1,0,0,0,0,0,0,0.19),
	[CollectibleType.COLLECTIBLE_BOOK_OF_SIN] = Color(1,1,1,1,0,0,0,0,0,0,0.13),
	[CollectibleType.COLLECTIBLE_LITTLE_GISH] = Color(1,1,1,1,0,0,0,0,0,0,0.14),
}

-- stuff that needs custom sprites to be properly supported
mod.NeonItemSprites = {
	--[CollectibleType.COLLECTIBLE_CHARM_VAMPIRE] = "",
	[CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK] = "gfx/items/collectibles/neon/collectibles_065_anarchistcookbook.png",
	--[CollectibleType.COLLECTIBLE_TECHNOLOGY] = "",
	--[CollectibleType.COLLECTIBLE_CUBE_OF_MEAT] = "",
	--[CollectibleType.COLLECTIBLE_MY_LITTLE_UNICORN] = "",
	--[CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS] = "",
	--[CollectibleType.COLLECTIBLE_SPIDER_BITE] = "",
	--[CollectibleType.COLLECTIBLE_SACK_OF_PENNIES] = "",
	--[CollectibleType.COLLECTIBLE_BOOK_OF_SIN] = "",
	--[CollectibleType.COLLECTIBLE_LITTLE_GISH] = "",
}

mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, function(_, cmd)
	if cmd == "neonitems" then
		for _, item in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
			local sprite = item:GetSprite()
			sprite:SetCustomShader("shaders/fiendfolio/coloroffset_neon")
			sprite:GetLayer(4):SetColor(Color(1,1,1,0))
			sprite:GetLayer(5):SetColor(Color(1,1,1,0))
			sprite:SetFrame(0)
			sprite:Stop()
			if mod.NeonItemColors[item.SubType] then sprite.Color = mod.NeonItemColors[item.SubType] end
			if mod.NeonItemSprites[item.SubType] then
				sprite:ReplaceSpritesheet(1, mod.NeonItemSprites[item.SubType])
				sprite:LoadGraphics()
			end
		end
	end
end)