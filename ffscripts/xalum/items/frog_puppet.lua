local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local frogPuppet = mod.ITEM.TRINKET.FROG_PUPPET
local tatteredPuppet = mod.ITEM.TRINKET.TATTERED_FROG_PUPPET

-- Priority:
--[[
	Held Golden Frog Puppet
	Held Frog Puppet
	Held Tattered Frog Puppet
	Smelted Golden Frog Puppet
	Smelted Frog Puppet
	Smelted Tattered Frog Puppet
]]

function mod.CanPlayerReviveWithFrogPuppet(player)
	return player:GetTrinketMultiplier(mod.ITEM.TRINKET.FROG_PUPPET) + player:GetTrinketMultiplier(mod.ITEM.TRINKET.TATTERED_FROG_PUPPET) > 0
end

function mod:HandleFrogPuppetLivesRender(player, lives)
	local t0 = player:GetTrinket(0)
	local t1 = player:GetTrinket(1)
	local smeltedTrinkets = player:GetSmeltedTrinkets({mod.ITEM.TRINKET.FROG_PUPPET, mod.ITEM.TRINKET.TATTERED_FROG_PUPPET})
	local momsBoxFactor = (player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) and 1) or 0
	
	local frogMultiplier = math.max(0, player:GetTrinketMultiplier(mod.ITEM.TRINKET.FROG_PUPPET) - momsBoxFactor)
	
	local numFrogTrinkets = ((t0 % TrinketType.TRINKET_GOLDEN_FLAG == mod.ITEM.TRINKET.FROG_PUPPET and 1) or 0) +
	                        ((t1 % TrinketType.TRINKET_GOLDEN_FLAG == mod.ITEM.TRINKET.FROG_PUPPET and 1) or 0) +
	                        smeltedTrinkets[mod.ITEM.TRINKET.FROG_PUPPET].trinketAmount +
	                        smeltedTrinkets[mod.ITEM.TRINKET.FROG_PUPPET].goldenTrinketAmount
	local numTatteredFrogTrinkets = ((t0 % TrinketType.TRINKET_GOLDEN_FLAG == mod.ITEM.TRINKET.TATTERED_FROG_PUPPET and 1) or 0) +
	                                ((t1 % TrinketType.TRINKET_GOLDEN_FLAG == mod.ITEM.TRINKET.TATTERED_FROG_PUPPET and 1) or 0) +
	                                smeltedTrinkets[mod.ITEM.TRINKET.TATTERED_FROG_PUPPET].trinketAmount +
	                                smeltedTrinkets[mod.ITEM.TRINKET.TATTERED_FROG_PUPPET].goldenTrinketAmount
							
	local livesFromTattering = numFrogTrinkets * momsBoxFactor
	
	local frogLives = frogMultiplier + numTatteredFrogTrinkets + livesFromTattering
	if frogLives > 0 then
		return {Lives = lives + frogLives}
	end
end
mod:AddTrinketCallback(CustomHealthAPI.Enums.Callbacks.PRE_RENDER_LIVES, mod.ITEM.TRINKET.FROG_PUPPET, mod.HandleFrogPuppetLivesRender)
mod:AddTrinketCallback(CustomHealthAPI.Enums.Callbacks.PRE_RENDER_LIVES, mod.ITEM.TRINKET.TATTERED_FROG_PUPPET, mod.HandleFrogPuppetLivesRender)

function mod.DowngradeFrogPuppet(player)
	mod.DowngradeTrinket(player, frogPuppet, tatteredPuppet)
end

-- Called from `ffscripts/revives.lua`
function mod.TryFrogPuppetRevive(player)
	if not mod.CanPlayerReviveWithFrogPuppet(player) then return end

	mod.DowngradeFrogPuppet(player)
	player:Revive()

	-- Transform the main twin.
	if player:GetMainTwin() and GetPtrHash(player) ~= GetPtrHash(player:GetMainTwin()) then
		player = player:GetMainTwin()
		player:Revive()
	end

	local oldPlayerType = player:GetPlayerType()
	local alreadySlippy = oldPlayerType == mod.PLAYER.SLIPPY
	local expectedBrokens = mod.GetExpectedBrokenHeartsFromDamage(player)

	if not alreadySlippy then
		player:ChangePlayerType(mod.PLAYER.SLIPPY)
		player:ClearCostumes()

		player:SetPocketActiveItem(mod.ITEM.COLLECTIBLE.FROG_HEAD, ActiveSlot.SLOT_POCKET)
		mod.UniversalRemoveItemFromPools(mod.ITEM.COLLECTIBLE.FROG_HEAD)
	end

	if oldPlayerType == mod.PLAYER.CHINA then
		player:AddBrokenHearts(-6)
	elseif player:GetBrokenHearts() + expectedBrokens >= 12 then
		player:AddBrokenHearts(-(player:GetBrokenHearts() + expectedBrokens) + 12)
	end

	player:AddMaxHearts(6 - player:GetMaxHearts())
	player:AddBoneHearts(-player:GetBoneHearts())
	player:AddSoulHearts(-player:GetSoulHearts())
	player:AddRottenHearts(-player:GetRottenHearts())
	player:AddHearts(-99) -- clearing out custom hp
	player:AddHearts(6)

	game:Fart(player.Position, 80, player, 1, 0)
	for i = 45, 360, 45 do
		game:Fart(player.Position + Vector(40, 0):Rotated(i), 80, player, 1, 0)
	end

	game:ButterBeanFart(player.Position, 280, player, false)
	game:ShakeScreen(50)
	sfx:Play(mod.Sounds.FartFrog4, 1, 0, false, math.random(90,110)/100)
	sfx:Stop(SoundEffect.SOUND_FART)
	player:SetMinDamageCooldown(90)
end