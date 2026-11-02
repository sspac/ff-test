-- Sanguine Salivation --

local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.LATE, function(_, entity, damage, flags, source, countdown)
	local npc = entity:ToNPC()
	if npc and npc:IsBoss() then
		local data = mod:GetEntityData(npc)
		data.FFSanguineSalivationDoFX = nil
		if npc.HitPoints <= npc.MaxHitPoints * 0.3 then
			local salivationNum = mod.getTrinketMultiplierAcrossAllPlayers(mod.ITEM.TRINKET.SANGUINE_SALIVATION)
			if salivationNum > 0 then
				data.FFSanguineSalivationDoFX = true
				return {Damage = damage * 1.3}
			end
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, function(_, entity, damage, flags, source, countdown)
	local npc = entity:ToNPC()
	if npc and npc:IsBoss() then
		local data = mod:GetEntityData(npc)
		if data.FFSanguineSalivationDoFX then
			data.FFSanguineSalivationDoFX = nil
			local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF04, 0, npc.Position, nilvector, nil):ToEffect()
			blood.Color = npc.SplatColor
			blood.PositionOffset = Vector(npc.Size * npc.SizeMulti.X * (math.random() * 2 - 1), npc.Size * npc.SizeMulti.Y * math.random() * -2)
			blood.DepthOffset = 50.0
			sfx:Play(SoundEffect.SOUND_MEAT_JUMPS, 1.0, 0, false, 1.0)
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function()
	local room = game:GetRoom()
	if room:GetType() == RoomType.ROOM_BOSS then
		for i = 1, game:GetNumPlayers() do
			local player = Isaac.GetPlayer(i - 1)
			local salivationNum = player:GetTrinketMultiplier(mod.ITEM.TRINKET.SANGUINE_SALIVATION)
			if salivationNum > 0 then
				player:AddHearts(2 * salivationNum)
				local notif = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, player.Position, nilvector, nil):ToEffect()
				notif.DepthOffset = 1.0
				notif.SpriteOffset = Vector(0, -40)
				notif:Update()
				sfx:Play(SoundEffect.SOUND_VAMP_GULP, 1.0, 0, false, 1.0)
			end
		end
	end
end)