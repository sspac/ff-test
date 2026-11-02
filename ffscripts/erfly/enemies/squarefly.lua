local mod = FiendFolio
local game = Game()
local sfx = SFXManager()

function mod:squareFlyAI(npc)
	local s = npc:GetSprite()
	local d = mod:GetEntityData(npc)
	local v = npc.Variant
	local target = npc:GetPlayerTarget()

	local speed = 4.5

	local pos = npc.Position
	local targetPos = mod:confusePos(npc, npc:GetPlayerTarget().Position)

	mod:beelzebubCheck(npc)

	if npc:IsDead() then
		local burst = Isaac.Spawn(1000, 3, 0, npc.Position, Vector.Zero, npc):ToEffect()
		burst.SpriteOffset = Vector(0,-14)
	end

	if not s:IsPlaying("Fly") then
		s:Play("Fly", 0)
	end

	if targetPos.X - npc.Position.X > 0
		then
			d.MV1 = 2
			d.MV3 = 1
		else
			d.MV1 = 1
			d.MV3 = 2
	end

	if targetPos.Y - npc.Position.Y > 0
		then
			d.MV2 = 2
			d.MV4 = 1
		else
			d.MV2 = 1
			d.MV4 = 2
	end

	if not d.init then
		if FiendFolio.GetBits(npc.SubType, 0, 1) == 1 then
			s:Load("gfx/enemies/squarefly/square_fly_ccw.anm2", true)
		end

		d.init = true
	end

	if d.moveDir == nil then
		d.changeDir = 1
		d.moveDir = FiendFolio.GetBits(npc.SubType, 1, 2) + 1
	else
		if d.moveDir == 1 then
			d.targetVelocity = Vector(speed,0) * d.MV1
		elseif d.moveDir == 2 then
			d.targetVelocity = Vector(0,speed) * d.MV2
		elseif d.moveDir == 3 then
			d.targetVelocity = Vector((0-speed),0) * d.MV3
		elseif d.moveDir == 4 then
			d.targetVelocity = Vector(0,(0-speed)) * d.MV4
		end
	d.changeDir = d.changeDir + 1
	if mod.anyPlayerHas(CollectibleType.COLLECTIBLE_SKATOLE) then
		d.targetVelocity = d.targetVelocity * 0.5
		npc.CollisionDamage = 0
	end
	npc.Velocity = mod:runIfFear(npc, (d.targetVelocity * 0.3) + (npc.Velocity * 0.6), speed)
	end

	if d.changeDir == 25 then
		if FiendFolio.GetBits(npc.SubType, 0, 1) == 0 then
			d.moveDir = d.moveDir + 1
			if d.moveDir == 5 then
				d.moveDir = 1
			end
		else
			d.moveDir = d.moveDir - 1
			if d.moveDir == 0 then
				d.moveDir = 4
			end
		end
		d.changeDir = 1
	end
end

--Run Square Fly AI
function mod:checkSquareFly(npc)
	mod:squareFlyAI(npc)
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkSquareFly, mod.FF.SquareFly.ID)

function mod:squareFlyPosCheck(room)
    local rng = RNG()
    rng:SetSeed(room:GetDecorationSeed())
    if rng:RandomInt(9537627) == 0
	or mod:entityValidationTechniqueFour() and rng:RandomInt(92544) == 0 then
        local br = StageAPI.GetScreenBottomRight()
        local pos = Vector(rng:RandomInt(math.floor(br.X)), rng:RandomInt(math.floor(br.Y)))
        local wait = rng:RandomInt(3600)
        for i = 0, 1 do
            mod.scheduleForUpdate(function()
				if mod.anyPlayerHas(mod.ITEM.TRINKET.ADBLOCKER, true, nil, nil, true) then
					if i == 0 then
						mod:adBlocked()
					end
				else
					local sprite = Sprite()
					sprite:Load("gfx/enemies/woodburner/figure.anm2", true)
					sprite.Scale = Vector.One
					sprite.Color = mod.ColorNormal
					sprite:SetFrame("Figure", i)
					sprite:Render(pos,Vector.Zero,Vector.Zero)
					if i == 0 then
						mod.SquareFlyPosChecked = true
					end
				end
            end, wait + i, ModCallbacks.MC_POST_RENDER, true)
        end
    end
end