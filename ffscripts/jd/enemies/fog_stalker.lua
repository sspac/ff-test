local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

local transparentcolor = Color(1, 1, 1, 0.3, 0, 0, 0)

function mod:FogStalkerAI(npc, sprite, data)
	local target = npc:GetPlayerTarget()
	local targetpos = mod:confusePos(npc, target.Position)
	--print(npc.GridCollisionClass)
	
	if not data.Init then
        npc.SplatColor = mod.ColorWaterPeople
		mod:spriteOverlayPlay(sprite,"HeadIdle02")
		data.State = "solid"
		data.StateTimer = 80
		npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        data.Init = true
    end
	
	if npc.Velocity:Length() > 0.1 then
		sprite:Play("BodyWalk")
	else
		sprite:SetFrame("BodyIdle", 0)
	end
	
	if targetpos.X < npc.Position.X then
		npc.FlipX = true
	else
		npc.FlipX = false
	end

	mod.QuickSetEntityGridPath(npc)
	
	data.UseFFPlayerMap = true
	FiendFolio.TryUpdatePathMap(FiendFolio.GenericChaserPathMap)
    if data.Path then
		if mod:isScare(npc) then
			npc.Velocity = mod:Lerp(npc.Velocity, (npc.Position - targetpos):Resized(4), 0.2)
		else
			FiendFolio.FollowPath(npc, 13.5, data.Path, true, 0.05, 500, true)
		end
    end
	
	--[[if data.StateTimer < 10 then
		if npc.FrameCount % 4 == 0 then
			npc.Color = transparentcolor
		elseif npc.FrameCount % 2 == 0 then
			npc.Color = Color.Default
		end
	end]]
	
	if npc.FrameCount % mod:RandomInt(6, 10) == 0 then
		local effect = Isaac.Spawn(1000, mod.FF.FFWhiteSmoke.Var, mod.FF.FFWhiteSmoke.Sub, npc.Position - Vector(0,25), Vector.Zero, npc):ToEffect()
		effect.Color = Color(0.7, 0.7, 0.9, 0.4, 0, 0, 0)
		mod:GetEntityData(effect).longonly = true
		effect.SpriteScale = effect.SpriteScale*1.3
	end
	
	if data.StateTimer == 0 then
		if data.State == "solid" then
			npc.Color = Color.Default
			data.State = "spooky"
			data.StateTimer = 60
			sfx:Play(SoundEffect.SOUND_MENU_FLIP_LIGHT, 1.2, 2, false, 0.5)
		else
			npc.Color = transparentcolor
			data.State = "solid"
			data.StateTimer = 80
			sfx:Play(SoundEffect.SOUND_MENU_FLIP_LIGHT, 1.2, 2, false, 1)
		end
	end
	
	if data.State == "solid" then
		if npc.Color.A > 0.9 then
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
		end
		npc.Color = Color.Lerp(npc.Color, Color.Default, 0.1)
		
		if sprite:GetOverlayFrame() == 3 and sprite:GetOverlayAnimation() == "HeadIdle01" then
			mod:spriteOverlayPlay(sprite,"HeadTransition01")
		end
	end
	if data.State == "spooky" then
		npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		npc.Color = Color.Lerp(npc.Color, transparentcolor, 0.1)
		if sprite:GetOverlayFrame() == 3 and sprite:GetOverlayAnimation() == "HeadIdle02" then
			mod:spriteOverlayPlay(sprite,"HeadTransition02")
		end
	end
	
	if sprite:IsOverlayFinished("HeadTransition02") then
		mod:spriteOverlayPlay(sprite,"HeadIdle01")
	end
	if sprite:IsOverlayFinished("HeadTransition01") then
		mod:spriteOverlayPlay(sprite,"HeadIdle02")
	end
	npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
	
	data.StateTimer = math.max(0, data.StateTimer-1)
end