local mod = FiendFolio
local sfx = SFXManager()

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, card, player, flag)
	if player:HasTrinket(FiendFolio.ITEM.TRINKET.BONE_LORDS_TABLET) and flag == flag | UseFlag.USE_OWNED then
		local mult = player:GetTrinketMultiplier(mod.ITEM.TRINKET.BONE_LORDS_TABLET)
        local rng = player:GetTrinketRNG(mod.ITEM.TRINKET.BONE_LORDS_TABLET)
		local itemConfig = Isaac.GetItemConfig():GetCard(card)
        if itemConfig:IsCard() then
            local total = math.ceil(4*mult)+rng:RandomInt(2)
            for i=1,total do
                mod.scheduleForUpdate(function()
                    local bone = Isaac.Spawn(3, FamiliarVariant.BONE_ORBITAL, 0, player.Position+Vector(0,40):Rotated(i*360/total), Vector.Zero, player):ToFamiliar()
                    bone.Player = player
                    if i < 3 then
                        sfx:Play(mod.Sounds.InscryptionBoneTokenLow, 0.8, 0, false, mod:getRoll(90,110,rng)/100)
                    else
                        sfx:Play(mod.Sounds.InscryptionBoneTokenHigh, 0.8, 0, false, mod:getRoll(90,110,rng)/100)
                    end
                end, i*4)
            end
        end
	end
end)