local mod = FiendFolio

-- Red Little Horn

local function ShootMiniTrollBombPoison(npc)
  local pTarget = mod:getClosestPlayer(npc.Position, 99999999).Position
  local vel = (pTarget - npc.Position):Normalized()
  local tBomb = Isaac.Spawn(4, 3, 0, npc.Position + vel*20, vel*15, npc):ToBomb()
  mod:GetEntityData(tBomb).red_champ_variant = 2
  tBomb:SetSize(12, Vector.One, 12)
  tBomb.RadiusMultiplier = 0.5
  tBomb.ExplosionDamage = tBomb.ExplosionDamage * 0.5
  mod:GetEntityData(tBomb).LastPos = npc.Position

  local bSprite = tBomb:GetSprite()
  bSprite:Load("gfx/bosses/champions/littlehorn/bomb_small.anm2", false)
  bSprite:ReplaceSpritesheet(0, "gfx/bosses/champions/littlehorn/boss_littlehorn_roddy.png")
  bSprite:LoadGraphics()
  bSprite:Play("Appear")
  bSprite:SetFrame(6)
end

--[[
  3:  idle
  6:  tp
  8:  spit dark ball
  9:  t bomb
  10: mega t bomb
  13: fixed hole
  14: single/multi moving hole
  16: multi-tp-bomb
]]

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
  if npc.Variant == 0 and npc:GetBossColorIdx() == mod.FF.RedLittleHorn.IDx then
    local cVar = mod:GetEntityData(npc).red_champ_variant
    local state = npc.State

    --local pana1, pana2 = mod:GetEntityData(npc).red_champ_pana1, mod:GetEntityData(npc).red_champ_pana2
    --if pana1 and pana2 then
    --  pana1, pana2 = 0, 0
    --  if pana1:IsDead() then pana1 = 1 end
    --  if pana2:IsDead() then pana2 = 1 end
    --  mod:GetEntityData(npc).red_champ_phase = pana1 + pana2
    --end

    --normal
    if cVar == 1 then
      if state == 8 then
        --print(npc.StateFrame)
        npc.State = 9
        npc:GetSprite():Play("Bomb", true)
      elseif state == 13 or state == 14 then
        --local n, s = table.unpack(({{6, "Teleport"}, {9, "Bomb"}, {10, "MegaBomb"}})[math.random(1,3)])     --33% Teleport, 33% Bomb, 33% MegaBomb
        npc.State = 3
        npc:GetSprite():Play("Idle", true)
      end

    --poison
    elseif cVar == 2 then
      if state == 9 or state == 10 then
        npc.State = 8
        npc:GetSprite():Play("Shoot", true)
      elseif state == 13 or state == 14 then
        --local n, s = table.unpack(({{6, "Teleport"}, {8, "Shoot"}})[math.random(1,2)])     --50% Teleport, 50% Shoot
        npc.State = 3
        npc:GetSprite():Play("Idle", true)
      elseif state == 16 and npc:GetSprite():IsPlaying("Return") and npc:GetSprite():IsEventTriggered("Shoot") then
        ShootMiniTrollBombPoison(npc)
        SFXManager():Play(414, 1, 0, false, 1, 0)
      end

      -- esto es una cagada
      if state == 16 and npc:GetSprite():GetFilename() ~= "gfx/bosses/champions/littlehorn/red_littlehorn_aux.anm2" then
        npc:GetSprite():Load("gfx/bosses/champions/littlehorn/red_littlehorn_aux.anm2", true)
      elseif state ~= 16 and npc:GetSprite():GetFilename() ~= "gfx/bosses/champions/littlehorn/red_littlehorn.anm2" then
        npc:GetSprite():Load("gfx/bosses/champions/littlehorn/red_littlehorn.anm2", false)
        npc:GetSprite():Play("Idle")
        for i=0, 4 do
          npc:GetSprite():ReplaceSpritesheet(i, "gfx/bosses/champions/littlehorn/boss_littlehorn_roddy.png")
        end
        npc:GetSprite():LoadGraphics()
      end

    --fire
    elseif cVar == 3 then
      if state == 8 or state == 10 then
        npc.State = 9
        npc:GetSprite():Play("Bomb", true)
      elseif state == 13 or state == 14 then
        --local n, s = table.unpack(({{6, "Teleport"}, {9, "Bomb"}})[math.random(1,2)])     --50% Teleport, 50% Bomb
        npc.State = 3
        npc:GetSprite():Play("Idle", true)
      end

    end
--
    --mod:GetEntityData(npc).red_champ_old_state = npc.State

  end
end, 404)

--init

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
  --if npc.Variant == 0 and npc.SubType == mod.FF.RedLittleHorn.Sub and npc.MaxHitPoints == 100 and not cVar then
  if npc.Variant == 0 and npc:GetBossColorIdx() == mod.FF.RedLittleHorn.IDx and npc.SpawnerType ~= 404 and not mod.BigHornAsksYouVeryNicelyNotToTriplicate then
    --print(npc.SpawnerType)
    mod:GetEntityData(npc).red_champ_variant = 1
    --for i=0, 4 do
    --  npc:GetSprite():ReplaceSpritesheet(i, "gfx/bosses/champions/littlehorn/boss_littlehorn_roddy.png")
    --end
    --npc:GetSprite():LoadGraphics()

    local pana1 = Isaac.Spawn(404, 0, npc.SubType, npc.Position + Vector(-1,0), Vector(0,0), npc):ToNPC()
    mod:GetEntityData(pana1).red_champ_variant = 2
    for i=0, 4 do
      pana1:GetSprite():ReplaceSpritesheet(i, "gfx/bosses/champions/littlehorn/boss_littlehorn_roddy.png")
    end
    pana1:GetSprite():LoadGraphics()

    local pana2 = Isaac.Spawn(404, 0, npc.SubType, npc.Position, Vector(1,0), npc):ToNPC()
    mod:GetEntityData(pana2).red_champ_variant = 3
    for i=0, 4 do
      pana2:GetSprite():ReplaceSpritesheet(i, "gfx/bosses/champions/littlehorn/boss_littlehorn_riddy.png")
    end
    pana2:GetSprite():LoadGraphics()

    --mod:GetEntityData(npc).red_champ_pana1 = pana1
    --mod:GetEntityData(npc).red_champ_pana2 = pana2

    --mod:GetEntityData(pana1).red_champ_pana1 = npc
    --mod:GetEntityData(pana1).red_champ_pana2 = pana2

    --mod:GetEntityData(pana2).red_champ_pana1 = pana1
    --mod:GetEntityData(pana2).red_champ_pana2 = npc

    --mod:GetEntityData(npc).red_champ_phase = 0
    --mod:GetEntityData(pana1).red_champ_phase = 0
    --mod:GetEntityData(pana2).red_champ_phase = 0

  end
end, 404)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, npc)
  if npc.Variant == 0 and npc:ToNPC():GetBossColorIdx() == mod.FF.RedLittleHorn.IDx and mod:GetEntityData(npc).red_champ_variant then

    local pana1, pana2
    local panas = Isaac.FindByType(404, 0, npc.SubType, false, false)
    for _, pana in ipairs(panas) do
      if npc.Position:Distance(pana.Position) < 10 and pana.FrameCount == 0 then
        if not pana1 then
          pana1 = pana
        else
          pana2 = pana
        end
      end
        end

    if not pana1 or not pana2 then return end  --salvese quien pueda

    local cVar = mod:GetEntityData(npc).red_champ_variant

    mod:GetEntityData(pana1).red_champ_variant = cVar
    mod:GetEntityData(pana2).red_champ_variant = cVar

    for i=0, 4 do
      pana1:GetSprite():ReplaceSpritesheet(i, "gfx/bosses/champions/littlehorn/boss_littlehorn_" .. ({"reddy", "roddy", "riddy"})[cVar] .. ".png")
      pana2:GetSprite():ReplaceSpritesheet(i, "gfx/bosses/champions/littlehorn/boss_littlehorn_" .. ({"reddy", "roddy", "riddy"})[cVar] .. ".png")
    end
    pana1:GetSprite():LoadGraphics()
    pana2:GetSprite():LoadGraphics()
  end
end, 404)

--bombs

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
  if npc.Variant == 1 and npc.SpawnerEntity and npc.SpawnerEntity.Type == 404 and npc.SpawnerEntity:ToNPC():GetBossColorIdx() == mod.FF.RedLittleHorn.IDx and mod:GetEntityData(npc.SpawnerEntity).red_champ_variant == 2 then
    ShootMiniTrollBombPoison(npc.SpawnerEntity:ToNPC())
    npc:Remove()
  end
end, 404)


mod:AddCallback(ModCallbacks.MC_POST_BOMB_INIT, function(_, bomb)
  if bomb.SpawnerEntity and bomb.SpawnerEntity.Type == 404 and mod:GetEntityData(bomb.SpawnerEntity).red_champ_variant == 2
  and bomb.SpawnerEntity:ToNPC().State == 16 and bomb:GetSprite():GetAnimation() == "BombReturn" then
    bomb:Remove()
  end
  if bomb.SpawnerEntity and bomb.SpawnerEntity.Type == 404 and mod:GetEntityData(bomb.SpawnerEntity).red_champ_variant and mod:GetEntityData(bomb.SpawnerEntity).red_champ_variant ~= 2 then
    mod:GetEntityData(bomb).red_champ_variant = mod:GetEntityData(bomb.SpawnerEntity).red_champ_variant

    bomb:SetSize(12, Vector.One, 12)
    bomb.RadiusMultiplier = 0.5
    bomb.ExplosionDamage = bomb.ExplosionDamage * 0.5

    local bSprite = bomb:GetSprite()
    if bomb.Variant == 4 then
      bSprite:Load("gfx/bosses/champions/littlehorn/bomb_small2.anm2", false)
    else
      bSprite:Load("gfx/bosses/champions/littlehorn/bomb_small.anm2", false)
    end
    local fSprite = "gfx/bosses/champions/littlehorn/boss_littlehorn_" .. ({"reddy", "roddy", "riddy"})[mod:GetEntityData(bomb).red_champ_variant] .. ".png"
    bSprite:ReplaceSpritesheet(0, fSprite)
    bSprite:ReplaceSpritesheet(2, fSprite)
    bomb:UpdateDirtColor(true)
    bSprite:LoadGraphics()
    bSprite:Play("BombReturn")

    --anti tele-frag
    if mod:GetEntityData(bomb).red_champ_variant == 3 and bomb.SpawnerEntity and bomb.SpawnerEntity:ToNPC().State == 9 then
      local player = mod:getClosestPlayer(bomb.Position, 99999)
      local room = Game():GetRoom()
      local cPos
      for i=1, 10 do
        local fLoop = true
        cPos = player.Position + RandomVector() * 130
        if room:IsPositionInRoom(cPos, 12) then
          cPos = room:FindFreePickupSpawnPosition(cPos, 0, false, false)
          local players = Isaac.FindByType(1, -1, -1, false, false)
          for _, p in ipairs(players) do
            if p.Position:Distance(cPos) < 100 then
              fLoop = true
              break
            else
              fLoop = false
            end
          end
        end
        if not fLoop then break end
      end
      bomb.Position = cPos
    end
  end
end)

mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, function(_, bomb)
  if mod:GetEntityData(bomb).red_champ_variant then
    if mod:GetEntityData(bomb).red_champ_variant == 2 then
      if bomb.Position:Distance(mod:GetEntityData(bomb).LastPos) > 30 or bomb:IsDead() then
        mod:GetEntityData(bomb).LastPos = bomb.Position
        local pCloud = Isaac.Spawn(1000, 141, 0, bomb.Position, Vector(0,0), bomb.EntitySpawner):ToEffect()
        local cScale =  (not bomb:IsDead() and 0.66) or (bomb:IsDead() and 1.2)
        local cTimeout = (not bomb:IsDead() and 75) or (bomb:IsDead() and 150)
        pCloud:GetSprite().Scale = Vector(1, 1) * cScale
        pCloud.Timeout = cTimeout
      end
    elseif bomb:IsDead() and mod:GetEntityData(bomb).red_champ_variant == 3 then
      local flame = Isaac.Spawn(33, 10, 0, bomb.Position, Vector(0,0), nil):ToNPC()
      flame.Scale = 0.5
    end
  end
end)

mod:AddCallback(ModCallbacks.MC_PRE_BOMB_COLLISION, function(_, bomb, collider)
  if mod:GetEntityData(bomb).red_champ_variant == 3 then
    if (collider:HasEntityFlags(EntityFlag.FLAG_CHARM) and collider:IsVulnerableEnemy()) or collider.Type == 1 or collider.Type == 3 then
      collider:TakeDamage(1, DamageFlag.DAMAGE_FIRE, EntityRef(bomb), 0)
    end
  end
end)