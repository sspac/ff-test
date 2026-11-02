local mod = FiendFolio
local game = Game()
local sfx = SFXManager()
local nilvector = Vector(0, 0)

--bone worm ai - round worm alt that shoots in a + then x
function mod:bonewormai(npc, sprite, npcdata)
	if not npcdata.Init then
		npc:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
		npcdata.Init = true
	end
	if npc:HasEntityFlags(EntityFlag.FLAG_FEAR) or npc:HasEntityFlags(EntityFlag.FLAG_CONFUSION) then
		if sprite:IsPlaying("DigOut") and sprite:GetFrame() == 32 then
			mod:spritePlay(sprite, "DigIn")
			npc.State = 6
		end
	end
	--print(tostring(npc.State))
	if sprite:IsEventTriggered("shootplus") then
		npc:PlaySound(SoundEffect.SOUND_BOIL_HATCH,0.7,0,false,1)
		local params = ProjectileParams()
		params.Variant = ProjectileVariant.PROJECTILE_BONE
		npc:FireProjectiles(npc.Position, Vector(10,0), 6, params)
	end
	if sprite:IsEventTriggered("shootx") then
		npc:PlaySound(SoundEffect.SOUND_BOIL_HATCH,1,0,false,1)
		local params = ProjectileParams()
		params.Variant = ProjectileVariant.PROJECTILE_BONE
		npc:FireProjectiles(npc.Position, Vector(10,0), 7, params)
	end
end