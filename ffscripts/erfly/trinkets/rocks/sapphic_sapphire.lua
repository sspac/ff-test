local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local tearcolor = Color(0.7, 0.7, 1, 1, -0.1, -0.1, 0.1)

function mod:sapphicSapphireFlagGeneric(entity, player, weaponFlag)
	if player:HasTrinket(FiendFolio.ITEM.ROCK.SAPPHIC_SAPPHIRE) then
		local trinketPower = FiendFolio.GetGolemTrinketPower(player, FiendFolio.ITEM.ROCK.SAPPHIC_SAPPHIRE)
        local chance = math.min(5 + player.Luck * 2, 20) * trinketPower
        if math.random(60) < chance then
			FiendFolio.FlagPeppermint(entity)
			
			if weaponFlag == TearFlagsLib.WeaponFlag.AQUARIUS then
				mod:GetEntityData(entity).FFAquariusTearColor = tearcolor
			elseif weaponFlag == TearFlagsLib.WeaponFlag.EPIC_FETUS or weaponFlag == TearFlagsLib.WeaponFlag.CLUB_EPIC_FETUS then
				mod:GetEntityData(entity).FFExplosionColor = tearcolor
			elseif weaponFlag == TearFlagsLib.WeaponFlag.LASER or 
			       weaponFlag == TearFlagsLib.WeaponFlag.ANTI_GRAV_LASER or 
			       weaponFlag == TearFlagsLib.WeaponFlag.KNIFE or
			       weaponFlag == TearFlagsLib.WeaponFlag.DARK_ARTS or
			       weaponFlag == TearFlagsLib.WeaponFlag.LOCUST or
			       weaponFlag == TearFlagsLib.WeaponFlag.UMBILICAL_WHIP or
			       weaponFlag == TearFlagsLib.WeaponFlag.BRIMSTONE_BALL or
			       weaponFlag == TearFlagsLib.WeaponFlag.BOBS_ROTTEN_HEAD or
			       weaponFlag == TearFlagsLib.WeaponFlag.SHARP_KEY or
			       weaponFlag == TearFlagsLib.WeaponFlag.OCULAR_RIFT or
			       weaponFlag == TearFlagsLib.WeaponFlag.HEMOPTYSIS
			then
				return
			else
				entity.Color = tearcolor
			end
		end
	end
end
mod:AddTrinketCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.ROCK.SAPPHIC_SAPPHIRE, mod.sapphicSapphireFlagGeneric)

function mod:tryMakeLaserSapphic(laser)
    if laser.Variant == 1 then
        local sprite = laser:GetSprite()
        sprite:Load("gfx/effects/sapphicsapphire/effect_lesbeam.anm2")
        sprite:Play("LargeRedLaser", true)
        mod:GetEntityData(laser).SapphicSapphireLesbianBeam = true
        return true
    elseif laser.Variant == 9 then
        local sprite = laser:GetSprite()
        sprite:Load("gfx/effects/sapphicsapphire/effect_lestech.anm2")
        sprite:Play("LargeRedLaser", true)
        mod:GetEntityData(laser).SapphicSapphireLesbianBeam = true
        return true
    end
end

--Here for ease/consistency ig
function mod:tryMakeLaserTrans(laser)
    if laser.Variant == 1 then
        local sprite = laser:GetSprite()
        sprite:Load("gfx/effects/sapphicsapphire/effect_transbeam.anm2")
        sprite:Play("LargeRedLaser", true)
        mod:GetEntityData(laser).TransRightsAreHumanRightsBeam = true
        return true
    elseif laser.Variant == 11 then
        local sprite = laser:GetSprite()
        sprite:Load("gfx/effects/sapphicsapphire/effect_transbeam_big.anm2")
        sprite:Play("LargeRedLaser", true)
        mod:GetEntityData(laser).TransRightsAreHumanRightsBeamBig = true
        return true
    end
end
function mod:tryMakeLaserEmoji(laser)
    if laser.Variant == 1 then
        local sprite = laser:GetSprite()
        sprite:Load("gfx/effects/sapphicsapphire/effect_emojibeam.anm2")
        sprite:Play("LargeRedLaser", true)
        mod:GetEntityData(laser).EmojisAreInTheBeam = true
        return true
    end
end

function mod:sapphicSapphireFireLaser(player, laser, rng)
    if player:HasTrinket(FiendFolio.ITEM.ROCK.SAPPHIC_SAPPHIRE) or player:HasTrinket(FiendFolio.ITEM.ROCK.HOMOEROTIC_RUBY) or player:HasTrinket(FiendFolio.ITEM.ROCK.GAY_GARNET) then
        mod:tryMakeLaserSapphic(laser)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, npc)
    if npc.FrameCount == 0 then
        if mod:GetEntityData(npc.Parent).SapphicSapphireLesbianBeam then
            local sprite = npc:GetSprite()
            sprite:Load("gfx/effects/sapphicsapphire/effect_lesbeam_impact.anm2")
            sprite:Play("Start", true)
        elseif mod:GetEntityData(npc.Parent).TransRightsAreHumanRightsBeam then
            local sprite = npc:GetSprite()
            sprite:Load("gfx/effects/sapphicsapphire/effect_transbeam_impact.anm2")
            sprite:Play("Start", true)
        elseif mod:GetEntityData(npc.Parent).TransRightsAreHumanRightsBeamBig then
            local sprite = npc:GetSprite()
            sprite:Load("gfx/effects/sapphicsapphire/effect_transbeam_impact_big.anm2")
            sprite:Play("Start", true)
        elseif mod:GetEntityData(npc.Parent).EmojisAreInTheBeam then
            local sprite = npc:GetSprite()
            sprite:Load("gfx/effects/sapphicsapphire/effect_emojibeam_impact.anm2")
            sprite:Play("Start", true)
        end
    end
end, EffectVariant.LASER_IMPACT)

local function getLabyrinthAdjustedLevelStage()
	local level = game:GetLevel()
	local levelstage = level:GetStage()
	if levelstage % 2 == 1 and levelstage <= LevelStage.STAGE4_1 and 
	   (level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH == LevelCurse.CURSE_OF_LABYRINTH or game:IsGreedMode()) then
		levelstage = levelstage + 1
	end
	return levelstage
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
    --oh I was going to do more support but it doesn't actually need it after the second hand rewrite, I guess mult doesn't matter
    if mod.anyPlayerHas(FiendFolio.ITEM.ROCK.SAPPHIC_SAPPHIRE, true) or mod.anyPlayerHas(FiendFolio.ITEM.ROCK.GAY_GARNET, true) then
        for j = 1, game:GetNumPlayers() do
            local isWoman
            local p = Isaac.GetPlayer(j - 1)
            local secondHand = p:GetTrinketMultiplier(TrinketType.TRINKET_SECOND_HAND) + 1

            for i = 1, #FiendFolio.Nonmale do
                if FiendFolio.Nonmale[i].ID
                and (npc.Type == FiendFolio.Nonmale[i].ID[1]) 
                and ((not FiendFolio.Nonmale[i].ID[2]) or npc.Variant == FiendFolio.Nonmale[i].ID[2]) 
                and ((not FiendFolio.Nonmale[i].ID[3]) or npc.SubType == FiendFolio.Nonmale[i].ID[3]) 
                and FiendFolio.Nonmale[i].Affliction == "Woman"
                then
                    isWoman = true
                    break
                end
            end

            if isWoman then
                npc:AddCharmed(EntityRef(p), 300*secondHand)
                if mod.WomanMode > 0 then
                    sfx:Stop(mod.Sounds.WomanRevealer)
                    sfx:Play(mod.Sounds.WomanRevealer, 4, 0, false, 1)
                    mod:ShowFortune("Woman", true)
                    game:GetHUD():ShowItemText("Woman", "This is a woman")
                    local e = Isaac.Spawn(mod.FF.WomanIndicator.ID, mod.FF.WomanIndicator.Var, mod.FF.WomanIndicator.Sub, npc.Position, Vector.Zero, p):ToEffect()
                    e.SpriteOffset = Vector(0, -30 + npc.Size * -1.0)
                    e:FollowParent(npc)
                    e.DepthOffset = 20
                end
                break
            end
        end
    elseif mod.WomanMode == 2 or 
	       (PlayerManager.AnyoneIsPlayerType(FiendFolio.PLAYER.IMAGE) and getLabyrinthAdjustedLevelStage() >= LevelStage.STAGE3_1)
	then
        local isWoman
        for i = 1, #FiendFolio.Nonmale do
            if FiendFolio.Nonmale[i].ID
            and (npc.Type == FiendFolio.Nonmale[i].ID[1]) 
            and ((not FiendFolio.Nonmale[i].ID[2]) or npc.Variant == FiendFolio.Nonmale[i].ID[2]) 
            and ((not FiendFolio.Nonmale[i].ID[3]) or npc.SubType == FiendFolio.Nonmale[i].ID[3]) 
            and FiendFolio.Nonmale[i].Affliction == "Woman"
            then
                isWoman = true
                break
            end
        end
        if isWoman then
            sfx:Stop(mod.Sounds.WomanRevealer)
            sfx:Play(mod.Sounds.WomanRevealer, 4, 0, false, 1)
            mod:ShowFortune("Woman", true)
            game:GetHUD():ShowItemText("Woman", "This is a woman")
            local e = Isaac.Spawn(mod.FF.WomanIndicator.ID, mod.FF.WomanIndicator.Var, mod.FF.WomanIndicator.Sub, npc.Position, Vector.Zero, npc):ToEffect()
            e.SpriteOffset = Vector(0, -30 + npc.Size * -1.0)
            e:FollowParent(npc)
            e.DepthOffset = 20
        end
    end
end)