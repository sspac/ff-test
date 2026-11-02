local game = Game()
local sfx = SFXManager()

return {
	AI = function(npc)
		npc.Velocity = npc.Velocity * 0.8

		local data = FiendFolio:GetEntityData(npc)
		if npc.State == 16 then
			npc:Die()

			-- need to do it this way cause it loses status effects when it becomes the bone pile
			if FiendFolio:shouldDoDeathAnimation(npc) and not data.WasShrunk then
				local off = math.random(360)
				for i = 1, 2 do
					local clack = Isaac.Spawn(889, 0, 0, npc.Position, Vector(40, 0):Rotated(off + i * 180), npc):ToNPC()
					clack:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					if FiendFolio:GetEntityData(npc).clicketyClashFriendly then
						clack:AddCharmed(EntityRef(npc), -1)
					end
					clack:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
					clack:ToNPC().State = 16
					if data.AmonSpawned and npc.SpawnerEntity:Exists() and npc.SpawnerEntity:GetData().currentwave then
						table.insert(npc.SpawnerEntity:GetData().currentwave, clack)
                	end
				end
			end
		else
			data.clicketyClashFriendly = FiendFolio:isFriend(npc)
		end
		data.WasShrunk = npc:HasEntityFlags(EntityFlag.FLAG_SHRINK)
	end,
}