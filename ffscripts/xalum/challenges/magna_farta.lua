local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

CustomPoopAPI.PoopSpellPool.MagnaFartaCommon = {}
CustomPoopAPI.PoopSpellPool.MagnaFartaRare = {}
CustomPoopAPI.PoopSpellPool.MagnaFartaSpecial = {}

CustomPoopAPI:AddSpellToPool("BUTTER COMPOST", "MagnaFartaCommon", 1)
CustomPoopAPI:AddSpellToPool("POISON COMPOST", "MagnaFartaCommon", 1)
CustomPoopAPI:AddSpellToPool("CHARM COMPOST",	"MagnaFartaRare", 1)
CustomPoopAPI:AddSpellToPool("UNSTABLE COMPOST", "MagnaFartaRare", 1)
CustomPoopAPI:AddSpellToPool("RUBBER COMPOST", "MagnaFartaCommon", 1)
CustomPoopAPI:AddSpellToPool("HOLY COMPOST", "MagnaFartaRare", 1)
CustomPoopAPI:AddSpellToPool("WAIT WHAT", "MagnaFartaSpecial", 1)
CustomPoopAPI:AddSpellToPool("BLACK BEAN", "MagnaFartaSpecial", 1)


for i, v in pairs({"BUTTER COMPOST", "POISON COMPOST", "CHARM COMPOST", "UNSTABLE COMPOST", "RUBBER COMPOST", "HOLY COMPOST", "WAIT WHAT", "BLACK BEAN"}) do
	CustomPoopAPI.SpellSprites[v] = {}
	for j = 1, 4 do
		CustomPoopAPI.SpellSprites[v][CustomPoopAPI.SpellAnimations[j]] = Sprite()
		CustomPoopAPI.SpellSprites[v][CustomPoopAPI.SpellAnimations[j]]:Load("gfx/ui/ui_ffpoop.anm2", true)
		CustomPoopAPI.SpellSprites[v][CustomPoopAPI.SpellAnimations[j]]:Play(CustomPoopAPI.SpellAnimations[j])
		CustomPoopAPI.SpellSprites[v][CustomPoopAPI.SpellAnimations[j]]:SetFrame(4 + i)
	end
end

function mod.CompostSpell(player, skin)
	local data = mod.savedata.run
	data.compostsThrown = data.compostsThrown or 0
	data.compostsThrown = data.compostsThrown + 1

	local compost = Isaac.Spawn(1000, 136, 0, player.Position, Vector.Zero, player)
	compost.Parent = player
	mod:GetEntityData(compost).spellDamageOverride = mod.ComposterSpellBaseDamage[skin or mod.ComposterSubType.DEFAULT]

	local sprite = compost:GetSprite()
	sprite:Load(mod.GetComposterSkin(skin or mod.ComposterSubType.DEFAULT), true)
	sprite:SetFrame("Idle", 0)

	player:TryHoldEntity(compost)
	sfx:Play(SoundEffect.SOUND_POOPITEM_HOLD)
end

CustomPoopAPI:AddPoopSpellCallback(function(_, spell, player)
	mod.CompostSpell(player, mod.ComposterSubType.DEFAULT)
end, "BUTTER COMPOST")

CustomPoopAPI:AddPoopSpellCallback(function(_, spell, player)
	mod.CompostSpell(player, mod.ComposterSubType.POISON)
end, "POISON COMPOST")

CustomPoopAPI:AddPoopSpellCallback(function(_, spell, player)
	mod.CompostSpell(player, mod.ComposterSubType.CHARMING)
end, "CHARM COMPOST")

CustomPoopAPI:AddPoopSpellCallback(function(_, spell, player)
	mod.CompostSpell(player, mod.ComposterSubType.UNSTABLE)
end, "UNSTABLE COMPOST")

CustomPoopAPI:AddPoopSpellCallback(function(_, spell, player)
	mod.CompostSpell(player, mod.ComposterSubType.BRUISING)
end, "RUBBER COMPOST")

CustomPoopAPI:AddPoopSpellCallback(function(_, spell, player)
	mod.CompostSpell(player, mod.ComposterSubType.HOLY)
end, "HOLY COMPOST")

CustomPoopAPI:AddPoopSpellCallback(function(_, spell, player)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_WAIT_WHAT)
end, "WAIT WHAT")

CustomPoopAPI:AddPoopSpellCallback(function(_, spell, player)
	player:UseActiveItem(CollectibleType.COLLECTIBLE_BLACK_BEAN)
end, "BLACK BEAN")

CustomPoopAPI:AddFillBagCallback(function(bag)
	if game.Challenge == mod.challenges.magnaFarta then
		local rares = math.floor(#bag * 0.25)
		local specials = math.floor(#bag * 0.15)
		local commons = #bag - rares - specials

		while #bag > 0 do table.remove(bag, 1) end

		for i = 1, commons do
			local entry = CustomPoopAPI:GetRandomElemWeighted(CustomPoopAPI.PoopSpellPool.MagnaFartaCommon)
			if entry then
				table.insert(bag, entry.Spell)
			end
		end

		for i = 1, rares do
			local entry = CustomPoopAPI:GetRandomElemWeighted(CustomPoopAPI.PoopSpellPool.MagnaFartaRare)
			if entry then
				table.insert(bag, entry.Spell)
			end
		end

		for i = 1, specials do
			local entry = CustomPoopAPI:GetRandomElemWeighted(CustomPoopAPI.PoopSpellPool.MagnaFartaSpecial)
			if entry then
				table.insert(bag, entry.Spell)
			end
		end

		CustomPoopAPI:Shuffle(bag)
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, function()
	if FiendFolio.ACHIEVEMENT.RAINBOW_BEAN:IsUnlocked() and not FiendFolio.ACHIEVEMENT.MAGNA_FARTA:IsUnlocked(true) then
		FiendFolio.ACHIEVEMENT.MAGNA_FARTA:Unlock()
	end
end, Achievement.TAINTED_BLUE_BABY)

mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_THROW, function(_, player, entity, vel)
	if entity and entity.Type == 1000 and entity.Variant == 136 then
		local data = mod:GetEntityData(entity)
		if data.spellDamageOverride then
			mod:AddOneTimeCallback(ModCallbacks.MC_POST_ENTITY_THROW, function(_, _, tear) -- It is unimaginably convenient that PRE_THROW has the helper, and POST_THROW has the tear
				tear.CollisionDamage = data.spellDamageOverride
			end)
		end
	end
end)