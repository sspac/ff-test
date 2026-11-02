local mod = FiendFolio
local game = Game()
local qualityAssurance = mod.ITEM.TRINKET.QUALITY_ASSURANCE

local bugSpawner = {
	function(player, position) player:AddBlueSpider(position) end,
	function(player, position) player:AddBlueFlies(1, position, nil) end,
	function(player, position) mod.ThrowFriendlySkuzz(player, RandomVector() * 2, position) end,
	function(player, position) mod:ThrowBlueBeetle(player, position) end,
}

local function canNpcGetQualityAssurance(npc)
	return (
		npc and
		npc:IsVulnerableEnemy() and
		not npc:IsBoss() and
		not mod.DownloadFailureBlacklist[npc.Type] and
		not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and
		not npc:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) and
		not npc:HasEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
	)
end

mod:AddTrinketCallback(ModCallbacks.MC_POST_NEW_ROOM, qualityAssurance, function()
	local power = PlayerManager.GetTotalTrinketMultiplier(qualityAssurance)
	local player = PlayerManager.FirstTrinketOwner(qualityAssurance) or Isaac.GetPlayer(0)
	local rng = player:GetTrinketRNG(qualityAssurance)

	TearFlagsLib.ForAllEntities(function(entity) -- Have you ever seen FiendFolio's GetRoomEntities function, what even happened there
		if canNpcGetQualityAssurance(entity:ToNPC()) and rng:RandomFloat() < 0.1 * power then
			mod:GetEntityData(entity).DownloadFailuredManually = true
		end
	end)
end)

mod:AddTrinketCallback(ModCallbacks.MC_POST_ENTITY_KILL, qualityAssurance, function(_, npc)
	if mod.downloadFailureCarded or mod:GetEntityData(npc).DownloadFailuredManually then
		local power = math.max(PlayerManager.GetTotalTrinketMultiplier(qualityAssurance), 1)
		local player = PlayerManager.FirstTrinketOwner(qualityAssurance) or Isaac.GetPlayer(0)
		local rng = player:GetTrinketRNG(qualityAssurance)

		for i = 1, 3 * power do
			bugSpawner[rng:RandomInt(#bugSpawner) + 1](player, npc.Position)
			Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_SPIDER, mod.ITEM.FAMILIAR.BLUE_BABY_SPIDER_SUBTYPE, npc.Position, Vector.Zero, player)
		end
	end
end)