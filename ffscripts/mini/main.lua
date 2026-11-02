local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

FiendFolio.LoadScripts({
	-- Enemies
	"ffscripts.mini.enemies.dope_head",
	"ffscripts.mini.enemies.patzer",
	"ffscripts.mini.enemies.marge",
	"ffscripts.mini.enemies.calzone",
	"ffscripts.mini.enemies.curdle",
	"ffscripts.mini.enemies.creepterum",
	"ffscripts.mini.enemies.soft_serve",
	"ffscripts.mini.enemies.load",
	"ffscripts.mini.enemies.baro",
	"ffscripts.mini.enemies.bone_worm",
	"ffscripts.mini.enemies.wetstone",
	"ffscripts.mini.enemies.chorister",
	"ffscripts.mini.enemies.foamy",
	"ffscripts.mini.enemies.fathead",
	"ffscripts.mini.enemies.skuzz",
	"ffscripts.mini.enemies.skuzzball",
	"ffscripts.mini.enemies.ransacked",
	"ffscripts.mini.enemies.boiler",
	"ffscripts.mini.enemies.drink_worm",
	"ffscripts.mini.enemies.wobbles",
	"ffscripts.mini.enemies.sludge_host",
	"ffscripts.mini.enemies.cistern",

	-- Items
	"ffscripts.mini.items.bacon_grease",
	
	-- Pickups
	"ffscripts.mini.pickups.blood_sack",
})

function mod:check666(npc)
	local sprite = npc:GetSprite()
	local npcdata = mod:GetEntityData(npc)
	local var = npc.Variant
	if var == mod.FF.SoftServe.Var or var == mod.FF.Sundae.Var or var == mod.FF.Scoop.Var then
		if not npcdata.eraserinit then
			if(var == mod.FF.Sundae.Var) then
				npcdata.scoopnumber = 2
			elseif var == mod.FF.Scoop.Var then
				npcdata.scoopnumber = 1
			end
			npcdata.eraserinit = true
		end
		local ErasedSoftServe = game:IsErased(mod.FF.SoftServe.ID, mod.FF.SoftServe.Var, -1) or game:IsErased(mod.FF.Sundae.ID, mod.FF.Sundae.Var, -1) or game:IsErased(mod.FF.Scoop.ID, mod.FF.Scoop.Var, -1)
		if ErasedSoftServe then
			npcdata.scoopnumber = 0
			if game:IsErased(mod.FF.SoftServe.ID, mod.FF.SoftServe.Var, -1)  then
				npc:Morph(mod.FF.SoftServe.ID, mod.FF.SoftServe.Var, 0, -1)
			elseif game:IsErased(mod.FF.Sundae.ID, mod.FF.Sundae.Var, -1) then
				npc:Morph(mod.FF.Sundae.ID, mod.FF.Sundae.Var, 0, -1)
			elseif game:IsErased(mod.FF.Scoop.ID, mod.FF.Scoop.Var, -1) then
				npc:Morph(mod.FF.Scoop.ID, mod.FF.Scoop.Var, 0, -1)
			end
		end
		mod:softServeAI(npc, sprite, npcdata, var);
	elseif var == mod.FF.Load.Var or var == mod.FF.CornLoad.Var then
		mod:loadai(npc, sprite, npcdata, var)
	elseif var == mod.FF.Baro.Var then
		mod:baroai(npc, sprite, npcdata)
	elseif var == mod.FF.Chorister.Var then
		mod:choristerai(npc, sprite, npcdata)
	elseif var == mod.FF.Foamy.Var then
		mod:foamyai(npc, sprite, npcdata)
	elseif var == mod.FF.Fathead.Var then
		mod:fatheadai(npc, sprite, npcdata)
	elseif var == mod.FF.Skuzz.Var then
		mod:skuzzai(npc, sprite, npcdata)
	elseif var == mod.FF.Ransacked.Var then
		mod:ransackedai(npc, sprite, npcdata)
	elseif var == mod.FF.Skuzzball.Var then
		mod:skuzzballai(npc, sprite, npcdata)
	elseif var == mod.FF.SkuzzballSmall.Var then
		if not npcdata.init then
			npcdata.init = true
			sprite.Offset = Vector(0, 0)
			npcdata.jumpytimer = math.random(20, 60)
			npcdata.state = "idle"
			npcdata.stateframe = 0
			npcdata.lookdown = "not"
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
			npcdata.spidernumber = 3
			npcdata.spiderlist = {0, 6, 12}
			npcdata.size = "small"
			npcdata.jumpsize = "small"
			npcdata.jumpstartdone = false
			npcdata.isCorpse = mod:CheckStage("Corpse", {34,43,44})
			for _, player in ipairs(Isaac.FindByType(1, -1, -1, false, false)) do
				player = player:ToPlayer()
				if player:HasCollectible(377) then
					npc.CollisionDamage = 0
					npcdata.bursting = 1
				end
			end
		end
		mod:skuzzballai(npc, sprite, npcdata)
	elseif var == mod.FF.Boiler.Var then
		mod:boilerai(npc, sprite, npcdata)
	elseif var == mod.FF.DrinkWorm.Var then
		mod:drinkwormai(npc, sprite, npcdata)
	elseif var == mod.FF.DrunkWorm.Var then
		mod:drunkwormai(npc, sprite, npcdata)
	elseif var == mod.FF.Wobbles.Var then
		mod:wobblesai(npc, sprite, npcdata)
	elseif var == mod.FF.SludgeHost.Var then
		mod:sludgehostai(npc, sprite, npcdata);
	elseif var == mod.FF.Creepterum.Var then
		mod:creepterumai(npc, sprite, npcdata)
	elseif var == mod.FF.Curdle.Var then
		mod:curdleai(npc, sprite, npcdata)
	elseif var == mod.FF.CurdleNaked.Var then
		if not npcdata.init then
			npc:Morph(666,mod.FF.Curdle.Var,0,-1)
			sprite:Load("gfx/enemies/curdle/curdleLEWD.anm2",true)
			npcdata.skin = false
			npcdata.state = "walk"
			npcdata.vomtimer = math.random(60, 90)
			npcdata.confuseangle = math.random(360)
			npcdata.init = true
		end
		mod:curdleai(npc, sprite, npcdata)
	elseif var == mod.FF.Calzone.Var or var == mod.FF.Breadbin.Var  then
		mod:calzoneai(npc, sprite, npcdata)
	elseif var == mod.FF.Honeydrop.Var then
		mod:honeydropai(npc, sprite, npcdata)
	elseif var == mod.FF.Bella.Var then
		mod:bellaai(npc, sprite, npcdata)
	elseif var == mod.FF.Marge.Var then
		mod:margeai(npc, sprite, npcdata)
	elseif var == mod.FF.Heiress.Var then
		mod:heiressai(npc, sprite, npcdata)
	elseif var == mod.FF.Patzer.Var then
		mod:patzerai(npc, sprite, npcdata)
	elseif var == mod.FF.PatzerShell.Var then
		mod:patzershellai(npc, sprite, npcdata)
	elseif var == mod.FF.DopeHead.Var then
		mod:dopeheadai(npc, sprite, npcdata)
	elseif var == mod.FF.DopeHeadProjectile.Var then
		mod:dopeheadprojectileai(npc, sprite, npcdata)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.check666, mod.FFID.Mini)

function mod:check666Init(npc)
	local sprite = npc:GetSprite()
	local var = npc.Variant
	if var == mod.FF.SoftServe.Var or var == mod.FF.Sundae.Var or var == mod.FF.Scoop.Var then
		if (npc.SubType == 1 or npc.SubType == 2) and npc:HasEntityFlags(EntityFlag.FLAG_APPEAR) then
			npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			sprite:Play("Appear" .. npc.SubType, true)
			npc:AddEntityFlags(EntityFlag.FLAG_APPEAR)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT , mod.check666Init, mod.FFID.Mini)

function mod:check666Death(ent)
	if ent.Variant == mod.FF.Load.Var or ent.Variant == mod.FF.CornLoad.Var then
		local npc = ent:ToNPC()

		if mod:shouldDoDeathAnimation(npc) then
			for i = 1, 15 do
				local bugcheck = math.random(1,6);
				Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.bugtable[bugcheck], 0, npc.Position, (RandomVector()*(math.random()+math.random(5,12))), npc);
			end
		end
	elseif ent.Variant == mod.FF.Baro.Var then
		local npc = ent:ToNPC()

		if mod:shouldDoDeathAnimation(npc) then
			Isaac.Spawn(281, 0, 0, npc.Position, nilvector, npc);
			for i = 1, 10 do
				local bugcheck = math.random(1,6)
				Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.bugtable[bugcheck], 0, npc.Position, (RandomVector()*(math.random()+math.random(5,12))), npc);
			end
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.check666Death, FiendFolio.FFID.Mini)

function mod:check666Hurt(npc, damage)
	local room = game:GetRoom()
	if npc.Variant == mod.FF.Load.Var or npc.Variant == mod.FF.CornLoad.Var or npc.Variant == mod.FF.Baro.Var then
		if npc:ToNPC().State == 17 then
			return false
		end
	elseif npc.Variant == 120 then
		--sludge host
		local npcdata = mod:GetEntityData(npc);
		if npcdata.invul == true then
			if not (npc:GetSprite():IsPlaying("Bombed") or npcdata.alreadybombed == true) then
				npcdata.damagedown = npcdata.damagedown + damage
					if (npcdata.damagedown >= (npc.MaxHitPoints * 2) - 1) then
					npcdata.damagedown = 0;
					mod:GetEntityData(npc).stateframe = 0;
					mod:spritePlay(npc:GetSprite(), "Bombed");
					npcdata.alreadybombed = true
				end
			else
				npcdata.damagedown = 0;
			end
			return false;
		end
	elseif npc.Variant == 130 then
		--creepterum
		if mod:GetEntityData(npc).living then
			--in air
			if (damage >= npc.HitPoints) then
				--ground him
				npc:ClearEntityFlags(EntityFlag.FLAG_FREEZE | EntityFlag.FLAG_MIDAS_FREEZE)
				npc:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET)
				mod:spritePlay(npc:GetSprite(), "Fall")
				mod:GetEntityData(npc).living = false
				mod:GetEntityData(npc).attacking = false
				npc.HitPoints = npc.MaxHitPoints
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				mod:GetEntityData(npc).attacktimer = math.random(120, 180)
				-- find spot
				local keeploop = 100
				while keeploop > 0 do
					local landPos = mod:chooserandomlocationforskuzz(npc, 300, 300, false)
					npc.Velocity = (landPos - npc.Position) / 22
					local newPos = (npc.Position + npc.Velocity) * 22
					if room:GetGridIndex(newPos) == GridCollisionClass.COLLISION_NONE then
						keeploop = 0;
					end
					keeploop = keeploop - 1;
				end
				return false;
			end
			return true;
		else
			--on ground
			return false;
		end
	elseif npc.Variant == 140 then
		--Curdle
		if (damage >= npc.HitPoints and mod:GetEntityData(npc).skin) then
			npc.HitPoints = npc.MaxHitPoints
			mod:GetEntityData(npc).state = "break"
			mod:GetEntityData(npc).skin = false
		end
	elseif npc.Variant == 160 then
		if mod:GetEntityData(npc).phase == "transfer" then
			npc.HitPoints = npc.HitPoints + (damage * 0.33)
		end
	elseif npc.Variant == 161 then
		--Bella
		if mod:GetEntityData(npc).cooldown and mod:GetEntityData(npc).cooldown < 0 and not (mod:GetEntityData(npc).foureyes or mod.GetEntityCount(281) >= 4) then
			local vec = RandomVector()
			local fly = mod.cheekyspawn(npc.Position + vec * 7.5, npc, npc.Position + vec * 50, 281, 0, 0)
			fly.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			mod:GetEntityData(npc).cooldown = 45
			mod:GetEntityData(npc).shaketimer = 4
			sfx:Play(181, 0.66, 0, false, 1.2)
		end
		return false
	elseif npc.Variant == mod.FF.DopeHead.Var or npc.Variant == mod.FF.DopeHeadProjectile.Var then
		return false
	end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.check666Hurt, FiendFolio.FFID.Mini)

function mod:checkminicollide(npc, other, low)
	if npc.Variant == mod.FF.DopeHead.Var then
		--dopehead collision
		if mod:GetEntityData(npc).die then
			return true
		end
		if other.Type == mod.FF.DopeHead.ID and other.Variant == mod.FF.DopeHead.Var then
			if mod:GetEntityData(other).die then
				return true
			end
			local xdiff = math.abs(npc.Velocity.X - other.Velocity.X)
			local ydiff = math.abs(npc.Velocity.Y - other.Velocity.Y)
			if ydiff > xdiff then
				if npc.Position.Y > other.Position.Y then
					npc.Velocity = Vector(npc.Velocity.X, math.abs(npc.Velocity.Y)*-1):Normalized() * 12
					other.Velocity = Vector(other.Velocity.X, math.abs(other.Velocity.Y)):Normalized() * 12
				else
					npc.Velocity = Vector(npc.Velocity.X, math.abs(npc.Velocity.Y)):Normalized() * 12
					other.Velocity = Vector(other.Velocity.X, math.abs(other.Velocity.Y)*-1):Normalized() * 12
				end
			else
				if npc.Position.X > other.Position.X then
					npc.Velocity = Vector(math.abs(npc.Velocity.X), npc.Velocity.Y):Normalized() * 12
					other.Velocity = Vector(math.abs(other.Velocity.X) * -1, other.Velocity.Y):Normalized() * 12
				else
					npc.Velocity = Vector(math.abs(npc.Velocity.X) * -1, npc.Velocity.Y):Normalized() * 12
					other.Velocity = Vector(math.abs(other.Velocity.X), other.Velocity.Y):Normalized() * 12
				end
			end
			mod:GetEntityData(npc).prevx = FiendFolio.sign(npc.Velocity.X);
			mod:GetEntityData(npc).prevy = FiendFolio.sign(npc.Velocity.Y);
			mod:GetEntityData(other).prevx = FiendFolio.sign(npc.Velocity.X);
			mod:GetEntityData(other).prevy = FiendFolio.sign(npc.Velocity.Y);
			if mod:GetEntityData(npc).prevx == 1 then
				sfx:Play(SoundEffect.SOUND_BONE_BOUNCE, 0.7, 0, false, 0.8)
				mod:spritePlay(npc:GetSprite(), "spinr")
			else
				sfx:Play(SoundEffect.SOUND_BONE_BOUNCE, 0.7, 0, false, 0.8)
				mod:spritePlay(npc:GetSprite(), "spinl")
			end
			if mod:GetEntityData(other).prevx == 1 then
				sfx:Play(SoundEffect.SOUND_BONE_BOUNCE, 0.7, 0, false, 0.8)
				mod:spritePlay(other:GetSprite(), "spinr")
			else
				sfx:Play(SoundEffect.SOUND_BONE_BOUNCE, 0.7, 0, false, 0.8)
				mod:spritePlay(other:GetSprite(), "spinl")
			end
			return false
		elseif other.Type == mod.FF.Junkstrap.ID and other.Variant == mod.FF.Junkstrap.Var then
			if mod:GetEntityData(npc).junksucked and mod:GetEntityData(other).Sucking then
				return true
			end
		elseif other.Type ~= 1 and other.Type ~= 2 then
			return true
		end
	elseif npc.Variant == mod.FF.DopeHeadProjectile.Var then
		if other.Type == 1 then
			mod:DestroyDopeHeadProjectile(npc)
		else
			return true
		end
	elseif npc.Variant == mod.FF.PatzerShell.Var then
		return mod:PatzerShellColl(npc, other)
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.checkminicollide, FiendFolio.FFID.Mini)

--drowned hive don''t fucking replace my men
function mod:drownedhivedontnt(npc, npcdata)
	if npcdata.fuckoff then
		npc:Morph(22, 666, 0, -1)
	end
end

--Run Hive AI
function mod:checkHive(npc)
	local sprite = npc:GetSprite()
	if npc.Variant == mod.FF.Cistern.Var then
		local npcdata = mod:GetEntityData(npc)
		mod:cisternai(npc, sprite, npcdata)
	elseif npc.Variant == 1 then
		local npcdata = mod:GetEntityData(npc)
		mod:drownedhivedontnt(npc, npcdata)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.checkHive, 22)