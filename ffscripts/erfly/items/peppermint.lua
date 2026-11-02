local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero
local statusflag = mod:RegisterEnemyStatusEffect("PEPPERMINT_SLOW", 0, "peppermintSlowOnUpdate", {Vasculitis = "peppermintSlowOnVasculitis"})
local tearflag = TearFlagsLib.RegisterTearFlag("PEPPERMINT")

function mod:firePeppermint(player, pos, fireDir, forceFire)
	local plluck = math.max(math.min(math.ceil(player.Luck), 11), 0)
	local rand = math.max(12 - plluck, 2)
	if math.random(rand) == 1 or forceFire then
		local fire = Isaac.Spawn(1000, 52, 0, pos or player.Position, (fireDir:Resized(10) + player:GetTearMovementInheritance(fireDir)) * 1.4, player):ToEffect()
		fire.Parent = player
		--fire.Color = Color(0.7,0.7,0.7,1,-0.3,0.4,0.8)
		local sprite = fire:GetSprite()
		sprite:ReplaceSpritesheet(0, "gfx/effects/effect_005_fire_peppermint.png")
		sprite:ReplaceSpritesheet(1, "gfx/effects/effect_peppermintpoof.png")
		sprite:LoadGraphics()
		fire.CollisionDamage = player.Damage * 1.5
		fire.Timeout = 300
		mod:GetEntityData(fire).IsPeppermint = true
		fire:Update()
	end
end

mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, mod.ITEM.COLLECTIBLE.PEPPERMINT, function(_, player, dir, amount, owner, params)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.PEPPERMINT) then
		for i = 1, amount do
			mod:firePeppermint(player, player.Position, dir)
		end
	end
end)

function mod:applyPeppermintSlow(npc, source, duration, mult)
	npc:AddSlowing(source, duration, mult or 0.5, Color(1.2,1.2,1.2,1,0,0,0.1))
	
	if not npc:HasEntityFlags(EntityFlag.FLAG_ICE) then
		npc:AddEntityFlags(EntityFlag.FLAG_ICE)
		local ptrhash = GetPtrHash(npc)
		mod.HasTempStatusFlag[ptrhash] = {NPC = npc, 
										  FlagsToRemove = ((mod.HasTempStatusFlag[ptrhash] and mod.HasTempStatusFlag[ptrhash].FlagsToRemove) or 0) | EntityFlag.FLAG_ICE}
	end
	
	mod:TrackEnemyStatus(npc, statusflag)
	local ptrhash = GetPtrHash(npc)
	mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
	mod.VasculitisInfo[ptrhash][statusflag] = {}
end

function mod:peppermintTakeDmg(npc, data, sourceEnt, sourceData)
	if sourceData.IsPeppermint and not mod:isFriend(npc) and not npc:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS) then
		mod:applyPeppermintSlow(npc, EntityRef(sourceEnt.Parent), 60)
	end
end

function mod:peppermintSlowOnUpdate(npc)
	if not npc:HasEntityFlags(EntityFlag.FLAG_SLOW) then
		mod:UntrackEnemyStatus(npc, statusflag)
	
		if not (npc:IsDead() or npc:HasMortalDamage()) then
			local ptrhash = GetPtrHash(npc)
			mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
			mod.VasculitisInfo[ptrhash][statusflag] = nil
		end
	else
		if not npc:HasEntityFlags(EntityFlag.FLAG_ICE) then
			npc:AddEntityFlags(EntityFlag.FLAG_ICE)
			local ptrhash = GetPtrHash(npc)
			mod.HasTempStatusFlag[ptrhash] = {NPC = npc, 
											  FlagsToRemove = ((mod.HasTempStatusFlag[ptrhash] and mod.HasTempStatusFlag[ptrhash].FlagsToRemove) or 0) | EntityFlag.FLAG_ICE}
		end
	end
end

function mod:peppermintSlowOnVasculitis(tear, npc)
	local ptrhash = GetPtrHash(npc)
	mod.VasculitisInfo[ptrhash] = mod.VasculitisInfo[ptrhash] or {}
	
	local vasculitisInfo = mod.VasculitisInfo[ptrhash][statusflag]
	if vasculitisInfo then
		TearFlagsLib.AddTearFlags(tear, tearflag)
		TearFlagsLib.SetTearFlagParams(tear, tearflag, {Duration = 60})
	end
end

function FiendFolio.FlagPeppermint(entity, duration)
	TearFlagsLib.AddTearFlags(entity, tearflag)
	TearFlagsLib.SetTearFlagParams(entity, tearflag, {Duration = duration or 60})
end

function mod:applyPeppermintFlag(entity, player, source)
	local params = TearFlagsLib.GetTearFlagParams(source, tearflag)
	mod:applyPeppermintSlow(entity, EntityRef(player), params.Duration or 60)
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyPeppermintFlag, tearflag)

