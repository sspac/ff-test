local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local flag = TearFlagsLib.RegisterTearFlag("HORNCOB")

--[[
YOU WERE ALL FREAKING PLAYED
SO FREAKIND HARD HAHAHAH AHAH AH AHAH AHA
WE GOT U GOOOOOOOOOOOOOOOOOOOOOOOOOOOOD!!!!!

This was never an active item!
Nor was that biend ever real!
He was a joke from the start!

BUT! Hey, the sprites were nice right? I wanted to
make sure they were still used in the MOD somewhere...

So enjoy Horncob!
It's kinda like tainted GMO Corn I suppose.
The ULTIMATE corn!
]]

FiendFolio.AddItemPickupCallback(function(player, added)
    if player:GetPlayerType() == FiendFolio.PLAYER.FIEND then
        local str = "The Unscrupulous"
        local wingedFont = Font()
        wingedFont:Load("font/pftempestasevencondensed.fnt")
        for i = 1, 60 do
            mod.scheduleForUpdate(function()
                --wingedFont:GetStringWidth(str) * -3
                local pos = game:GetRoom():WorldToScreenPosition(player.Position) + Vector(wingedFont:GetStringWidth(str) * -0.5, -(player.SpriteScale.Y * 35) - i/3)
                local opacity
                if i >= 30 then
                    opacity = 1 - ((i-30)/30)
                else
                    opacity = i/30
                end
                --Isaac.RenderText(str, pos.X, pos.Y, 1, 1, 1, opacity)
                wingedFont:DrawString(str, pos.X, pos.Y, KColor(1,1,1,opacity), 0, false)
            end, i, ModCallbacks.MC_POST_RENDER)
        end
    end
end, nil, mod.ITEM.COLLECTIBLE.HORNCOB)

function mod:horncobFlagGeneric(entity, player, weaponFlag)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.HORNCOB) then
		TearFlagsLib.AddTearFlags(entity, flag)
		
		if weaponFlag == TearFlagsLib.WeaponFlag.TEAR or weaponFlag == TearFlagsLib.WeaponFlag.LUDOVICO_TEAR then
			mod:changeTearVariant(entity, mod.TEAR.HORNCOB_PILL)
		end
	end
end
mod:AddCollectibleCallback(TearFlagsLib.Callback.POLL_TEARFLAGS, FiendFolio.ITEM.COLLECTIBLE.HORNCOB, mod.horncobFlagGeneric)

function mod:applyHorncobFlag(entity, player, source)
	for i = 1, 2 do
        mod.scheduleForUpdate(function()
            --safety check
            if player and player:Exists() then
                if math.random() * 8 <= 2 + player.Luck * 0.4 then
                    if entity and entity:Exists() and entity:IsEnemy() and entity:IsDead() and not (mod:GetEntityData(entity).checkedHornCob or (entity.Type == mod.FFID.Tech and entity.Variant > 999)) then
                        local pillsToQueue = math.ceil(math.max(1, player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.HORNCOB)))
                        FiendFolio.QueuePills(player, pillsToQueue)
                        sfx:Play(SoundEffect.SOUND_PORTAL_SPAWN, 0.5, 0, false, math.random(130,170)/100)
                        sfx:Play(SoundEffect.SOUND_BAND_AID_PICK_UP, 0.7, 0, false, math.random(70,80)/100)
                        mod:GetEntityData(entity).checkedHornCob = true
                    end
                end
            end
        end, i)
    end
end
mod:AddCallback(TearFlagsLib.Callback.APPLY_TEARFLAG_EFFECT, mod.applyHorncobFlag, flag)

local pillSheets = {
	"pt_blackyellow",
	"pt_blueblue",
	"pt_bluegreen",
	"pt_whiteblack",
	"pt_whiteblue",
	"pt_whitewhite",
	"pt_yelloworange",
	"pt_yellowyellow",
}

mod.SewingManualWhitelist[FiendFolio.ITEM.COLLECTIBLE.HORNCOB] = {
	BodyColor = Color(1,1,1,1,-10.248/255,-28.735/255,-16.044/255,0.664,0.646,0.726,1),
	EyeAColor = Color(1,1,1,1,-16.991/255,-41.071/255,-40.115/255,0.655,0.761,0.487,1),
	EyeBColor = Color(1,1,1,1,-16.991/255,-41.071/255,-40.115/255,0.655,0.761,0.487,1)}
	
mod:AddCallback(FiendFolio.CALLBACK.POST_DOLL_FIRE_TEAR, function(_, familiar, tear)
	TearFlagsLib.AddTearFlags(tear, TearFlagsLib.Flag.HORNCOB)
	mod:changeTearVariant(tear, mod.TEAR.HORNCOB_PILL)
end, FiendFolio.ITEM.COLLECTIBLE.HORNCOB)

function mod:hornCobPillTearRender(tear, var, data, offset)
	local sprite = tear:GetSprite()
	if not data.FFSetPillSheet then
		sprite:ReplaceSpritesheet(0, "gfx/projectiles/pilltears/" .. pillSheets[math.random(#pillSheets)] .. ".png")
		sprite:LoadGraphics()
		data.FFSetPillSheet = true
	end
	local scale = tear.Scale
	local flags = tear.TearFlags
	
	local anim
	if scale <= 0.3 then
		anim = "RegularTear1"
	elseif scale <= 0.55 then
		anim = "RegularTear2"
	elseif scale <= 0.675 then
		anim = "RegularTear3"
	elseif scale <= 0.8 then
		anim = "RegularTear4"
	elseif scale <= 0.925 then
		anim = "RegularTear5"
	elseif scale <= 1.05 then
		anim = "RegularTear6"
	elseif scale <= 1.175 then
		anim = "RegularTear7"
	elseif scale <= 1.425 then
		anim = "RegularTear8"
	elseif scale <= 1.675 then
		anim = "RegularTear9"
	elseif scale <= 1.925 then
		anim = "RegularTear10"
	elseif scale <= 2.175 then
		anim = "RegularTear11"
	elseif scale <= 2.55 then
		anim = "RegularTear12"
	else
		anim = "RegularTear13"
	end
	
	if not sprite:IsPlaying(anim) then
		local frame = sprite:GetFrame()
		sprite:Play(anim, true)
		sprite:SetFrame(frame)
	end

	local spritescale = mod:getTearScale13(tear)
	local layers = sprite:GetAllLayers()
	for _, layer in ipairs(layers) do
		layer:SetSize(spritescale)
	end
	
	if flags & TearFlags.TEAR_FLAT == TearFlags.TEAR_FLAT then
		local adjustedVelocity = tear.Velocity
		if tear.WaitFrames > 0 then
			adjustedVelocity = tear.ContinueVelocity
		elseif (tear.FallingSpeed < 0 or 0.2 < tear.FallingSpeed) and 
		       flags & TearFlags.TEAR_LUDOVICO ~= TearFlags.TEAR_LUDOVICO and
		       ((flags & TearFlags.TEAR_ABSORB ~= TearFlags.TEAR_ABSORB and flags & TearFlags.TEAR_POP ~= TearFlags.TEAR_POP) or tear.Velocity:Length() <= 0.1) 
		then
			adjustedVelocity = adjustedVelocity + Vector(0, tear.FallingSpeed)
		end
		
		sprite.Rotation = adjustedVelocity:GetAngleDegrees()
		sprite.FlipX = false
		sprite.FlipY = false
	else
		data.HornCobRotation = data.HornCobRotation or math.random(360)
		if not game:IsPaused() then
			if tear.Velocity.X > 0 then
				data.HornCobRotation = data.HornCobRotation + tear.Velocity:Length()
			else
				data.HornCobRotation = data.HornCobRotation - tear.Velocity:Length()
			end
		end
		sprite.Rotation = data.HornCobRotation
		sprite.FlipX = false
		sprite.FlipY = false
	end
end
mod:AddCallback("FF_CUSTOM_TEAR_RENDER", mod.hornCobPillTearRender, FiendFolio.TEAR.HORNCOB_PILL)

function mod:hornCobPillTearSplat(tear, var, data)
	if not data.denySound then
        sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 0.1, 0, false, 2.5 - math.max(math.min(tear.Scale, 1.5), 0))
    end
	if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then return end
	
	local scale = tear.Scale
	local color = tear:GetSprite().Color

	local smoke = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, tear.Position, tear.Velocity:Resized(3), tear)
	--smoke.SpriteScale = Vector(1,1)
	mod:GetEntityData(smoke).longonly = true
	smoke.SpriteScale = Vector(scale * 0.8, scale * 0.8)
	smoke.PositionOffset = tear.PositionOffset
    smoke:Update()
end
mod:AddCallback("FF_CUSTOM_TEAR_SPLAT", mod.hornCobPillTearSplat, FiendFolio.TEAR.HORNCOB_PILL)