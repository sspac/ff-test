local mod = FiendFolio
local game = Game()

mod.AddItemPickupCallback(function(player, added)
	player:AddSoulHearts(-2)
	mod:AddImmoralHearts(player, 4)
end, nil, mod.ITEM.COLLECTIBLE.HUITLACOCHE)

function mod:HuitlacocheMinionInit(e)
    local d = mod:GetEntityData(e)
    if not e.Parent or not e.Parent:ToPlayer() then
        for i=1,game:GetNumPlayers() do
            local player = Isaac.GetPlayer(i-1)
            if player.Position:Distance(e.Position) < 20 then
                e.Parent = player
                break
            end
        end
    end
    if e.Parent and e.Parent:ToPlayer() then
        local player = e.Parent:ToPlayer()
        if player:HasCollectible(mod.ITEM.COLLECTIBLE.HUITLACOCHE) and not d.AlreadySpawnedHuit then
            d.AlreadySpawnedHuit = player
            local spore = Isaac.Spawn(mod.FF.FloatingSpore.ID,mod.FF.FloatingSpore.Var,0,e.Position,Vector.Zero,player)
			local sd = mod:GetEntityData(spore)
			sd.fallspeed = -4
			sd.height = -5
			sd.target = mod:FindRandomFreePos(e, 120)
			sd.HuitlacocheSpawn = player
			spore:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
			spore:Update()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.HuitlacocheMinionInit, mod.PICKUP.VARIANT.FIEND_MINION)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.HuitlacocheMinionInit, 1736)

function mod:HuitlacocheTakeDmg(ent, tab, d)
    local huitdamage = false
    if not (ent:HasEntityFlags(EntityFlag.FLAG_NO_DEATH_TRIGGER) or ent:HasEntityFlags(EntityFlag.FLAG_NO_REWARD)) then
        if d.fiendminiondealingdamage and d.fiendminiondealingdamage:Exists() then
            if mod:GetEntityData(d.fiendminiondealingdamage).AlreadySpawnedHuit then
                huitdamage = true
            end
        end
    end
    if huitdamage then
        mod.scheduleForUpdate(function()
            if ent and ent:IsDead() then
                local pos = mod:FindRandomFreePos(ent, 120, true)
                if pos:Distance(ent.Position) < 150 then
                    local spore = Isaac.Spawn(mod.FF.FloatingSpore.ID,mod.FF.FloatingSpore.Var,0,ent.Position,Vector.Zero,ent)
                    local sd = mod:GetEntityData(spore)
                    sd.fallspeed = -4
                    sd.height = -5
                    sd.target = pos
                    sd.HuitlacocheSpawn = d.CheckToSpawnHuitlacoche
                    spore:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
                    spore:Update()
                end
            end
        end, 2)
    end
	--d.CheckToSpawnHuitlacoche = huitdamage
end
mod:AddCollectibleCallback("FF_GENERIC_NPC_TAKE_DMG_FERRIUM", mod.ITEM.COLLECTIBLE.HUITLACOCHE, mod.HuitlacocheTakeDmg)

--does it not keep data when enemies die huh
--[[function mod:HuitlacocheDeathCheck(npc)
    local d = mod:GetEntityData(npc)
    print(d.CheckToSpawnHuitlacoche, "death")
    if d.CheckToSpawnHuitlacoche and not (npc.Type == mod.FFID.Tech and npc.Variant > 999) and d.CheckToSpawnHuitlacoche:Exists() then
        local pos = mod:FindRandomFreePos(npc, 120)
        if pos:Distance(npc.Position) < 150 then
            local spore = Isaac.Spawn(mod.FF.FloatingSpore.ID,mod.FF.FloatingSpore.Var,0,npc.Position,Vector.Zero,player)
			local sd = mod:GetEntityData(spore)
			sd.fallspeed = -4
			sd.height = -5
			sd.target = pos
			sd.HuitlacocheSpawn = d.CheckToSpawnHuitlacoche
			spore:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
			spore:Update()
        end
    end
end]]

--function mod:FiendMinionAI(pickup)