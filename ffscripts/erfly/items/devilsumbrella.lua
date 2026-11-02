local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector.Zero

local flag = TearFlagsLib.RegisterTearFlag("DEVILS_UMBRELLA")

function mod:firePiss(player, fireVec)
	sfx:Play(mod.Sounds.Plorp, 0.3, 0, false, math.random(130,150)/100)
	--Determine fire position
	local firepos = player.Position
	local head = mod:GetActiveScissorDecapHead(player)
	if head then
		firepos = head.Position
	end
	--Effect
	local splat = Isaac.Spawn(1000, 1960, 33, firepos, nilvector, player):ToEffect()
	splat.Color = mod.ColorPissGood
	--print(player.Size)
	splat.SpriteOffset = Vector(0, (-35 * player.SpriteScale.Y))
	splat.SpriteScale = (Vector.One * (player.Size/2)) / 10
	splat:FollowParent(player)
	splat:Update()
	--Fired shots
	local spurts = math.ceil(10 * (math.log(math.max(1, player:GetCollectibleNum(mod.ITEM.COLLECTIBLE.DEVILS_UMBRELLA)), 3) + 1))
	for i = 1, spurts do
		--local newtear = player:FireTear(player.Position, tear.Velocity:Rotated(math.random(60) - 30):Resized(math.random(20,100)/10), false, true, false):ToTear()
		local newtear = Isaac.Spawn(2, 0, 0, firepos, (fireVec:Resized(10) + player:GetTearMovementInheritance(fireVec)):Rotated(math.random(60) - 30):Resized(math.random(20,100)/10), player):ToTear()
		local scalecalc = math.random(30,60) / 100
		newtear.Scale = scalecalc
		newtear.FallingSpeed = -25 - math.random(5)
		newtear.FallingAcceleration = 1.5 + (math.random() * 0.5)
		newtear.Height = -15
		newtear.CanTriggerStreakEnd = false
		newtear.Color = mod.ColorPissGood
		newtear.CollisionDamage = mod:LuaRound(scalecalc, 1)
		TearFlagsLib.AddTearFlags(newtear, flag)
		TearFlagsLib.SetTearFlagParams(newtear, flag, {DMG = player.Damage * 0.3})
        newtear.TearFlags = newtear.TearFlags | TearFlags.TEAR_PIERCING
		newtear:Update()
	end
end

mod:AddCollectibleCallback(FiendFolio.CALLBACK.FF_SECONDARY_FIRE, mod.ITEM.COLLECTIBLE.DEVILS_UMBRELLA, function(_, player, dir, amount, owner, params)
	if player:HasCollectible(mod.ITEM.COLLECTIBLE.DEVILS_UMBRELLA) then
		for i = 1, amount do
			if math.random(5) == 1 then
				mod:firePiss(player, dir)
			end
		end
	end
end)

function mod:devilsUmbrellaTearUpdate(tear, td)
	if TearFlagsLib.HasTearFlags(tear, flag) then
		if tear:IsDead() then
			local params = TearFlagsLib.GetTearFlagParams(tear, flag)
			if params and params.DMG then
				local piss = Isaac.Spawn(1000, 46, 0, tear.Position, nilvector, tear):ToEffect()
				local pisscolor = Color(1,1,1,1,0,0,0)
				pisscolor:SetColorize(7, 7, 1, 1)
				piss.Color = pisscolor
				piss.CollisionDamage = params.DMG * 0.4
				piss.Timeout = 60
				piss:Update()
			end
		end
	end
end

function mod:devilsUmbrellaLocustAI(fam)
	if fam.FireCooldown == -1 then
		local piss = Isaac.Spawn(1000, 46, 0, fam.Position, nilvector, fam):ToEffect()
		local pisscolor = Color(1,1,1,1,0,0,0)
		pisscolor:SetColorize(7, 7, 1, 1)
		piss.Color = pisscolor
		piss.CollisionDamage = mod:getLocustDamage(fam, 0.1)
		piss.Timeout = 60
		piss.Scale = 0.5
		piss:Update()
	end
end

function mod.handleDevilsUmbrellaD3(entity)
	local player = TearFlagsLib.GetTearPlayer(entity)
	if player then
		TearFlagsLib.SetTearFlagParams(entity, flag, {DMG = player.Damage * 0.3})
	end
end