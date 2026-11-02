local mod = FiendFolio

-- Broken Gaping Maw

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)
  if npc.Variant ~= 124 then return end
  --[[
  print("anm: " .. npc:GetSprite():GetAnimation())
  print("frame: " .. npc:GetSprite():GetFrame())
  print("oAnm2: " .. npc:GetSprite():GetOverlayAnimation())
  print("oFrame: " .. npc:GetSprite():GetOverlayFrame())
  print("frameCount: " .. npc.FrameCount)
  print("state: " .. npc.State)
  print("sFrame: " .. npc.StateFrame)
  print("---")
    ]]

  if npc.StateFrame == 1 then
    local offset = npc.SubType
    if (offset % 10) >= 5 then
      npc:GetSprite():Play("TurnOff", true)
      npc:GetSprite():RemoveOverlay()
    end
    npc.StateFrame = npc.StateFrame + 240/10 * offset
  end
end, 236)

-- 202 Init

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
  if not (npc.Variant >= 124 and npc.Variant <= 128) then return end
  local t = math.floor(npc.SubType/64)
  local s = npc.SubType
  if t == 0 then
    npc:Morph(202, 0, math.floor(s/16), -1)
    mod:GetEntityData(npc).ffGrimaceShootOffset = (s%16) * 3
  elseif t == 1 then
    --npc:Morph(202, 10, math.floor((s%64)/32), -1)
    if (s%64) < 32 then
      npc:Morph(202, 10, 0, -1)
    else
      npc:Morph(202, 10, 1, -1)
    end
    mod:GetEntityData(npc).ffGrimaceShootOffset = (s%32) * 3
    mod:GetEntityData(npc).ffGrimaceShootAuxOffset = 1
  elseif t == 2 then
    --npc:Morph(202, 11, math.floor((s%64)/32), -1)
    if (s%64) < 32 then
      npc:Morph(202, 11, 0, -1)
    else
      npc:Morph(202, 11, 1, -1)
    end
    mod:GetEntityData(npc).ffGrimaceShootOffset = (s%32) * 3
    mod:GetEntityData(npc).ffGrimaceShootAuxOffset = 1
  end
end, 202)

-- Constant Stone Shooter

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)

  if npc.Variant ~= 0 then return end
  if not mod:GetEntityData(npc).ffGrimaceShootOffset then return end
  if npc.State == 8 and mod:GetEntityData(npc).ffGrimaceShootOffset > 0 then
    npc:GetSprite():SetFrame(-mod:GetEntityData(npc).ffGrimaceShootOffset)
    mod:GetEntityData(npc).ffGrimaceShootOffset = 0
  elseif npc:GetSprite():GetFrame() == 28 then
    npc:GetSprite():SetFrame(-2)
  end
end, 202)

-- Cross Stone Shooter

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)

  if npc.Variant < 10 or npc.Variant > 11 then return end
  if not mod:GetEntityData(npc).ffGrimaceShootOffset then return end

  if npc.State == 8 then
    if mod:GetEntityData(npc).ffGrimaceShootOffset > 0 then
      npc:GetSprite():SetFrame(-mod:GetEntityData(npc).ffGrimaceShootOffset)
      mod:GetEntityData(npc).ffGrimaceShootOffset = 0
    end
    if npc:GetSprite():GetFrame() == 27 and mod:GetEntityData(npc).ffGrimaceShootAuxOffset > 0 then
      npc:GetSprite():SetFrame(26)
      mod:GetEntityData(npc).ffGrimaceShootAuxOffset = mod:GetEntityData(npc).ffGrimaceShootAuxOffset - 1
    elseif npc:GetSprite():GetFrame() == 0 then
      mod:GetEntityData(npc).ffGrimaceShootAuxOffset = 1
    end
  end
end, 202)

-- Brimstone Head

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
  --if npc.Variant ~= 124 then return end
  if not (npc.Variant >= 124 and npc.Variant <= 128) then return end
  local t = math.floor(npc.SubType/32)
  local s = npc.SubType
  if (npc.SubType % 32) == 0 then
    npc:Morph(203, 0, t, -1)
  else
    npc:Morph(203, 124, t, -1)
  end
  mod:GetEntityData(npc).ffGrimaceShootOffset = (s%32) * 3 + 1
  mod:GetEntityData(npc).ffGrimaceShootFrameLoop = 0 -- 90
end, 203)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)

  --if npc:GetSprite():GetFrame() == 10 then
  --  print("frameCount: " .. npc.FrameCount)
  --  print("index: " .. npc.Index)
  --  print("---")
  --end
  if not (npc.Variant >= 124 and npc.Variant <= 128) then return end

  if npc.FrameCount > 89 then
    if mod:GetEntityData(npc).ffGrimaceShootOffset > 0 then
      npc.State = 3
      mod:GetEntityData(npc).ffGrimaceShootOffset = mod:GetEntityData(npc).ffGrimaceShootOffset - 1
      if mod:GetEntityData(npc).ffGrimaceShootOffset == 0 then
        npc.State = 8
        mod:GetEntityData(npc).ffGrimaceShootFrameLoop = 89
      end
    elseif mod:GetEntityData(npc).ffGrimaceShootFrameLoop > 0 then
      if mod:GetEntityData(npc).ffGrimaceShootFrameLoop > 39 then
        npc.State = 8
      else
        npc.State = 3
      end
      mod:GetEntityData(npc).ffGrimaceShootFrameLoop = mod:GetEntityData(npc).ffGrimaceShootFrameLoop - 1
      if mod:GetEntityData(npc).ffGrimaceShootFrameLoop == 0 then
        mod:GetEntityData(npc).ffGrimaceShootFrameLoop = 90
      end
    end
  end

end, 203)

-- Shifted Quake Grimace

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, function(_, npc)
  if not (npc.Variant >= 124 and npc.Variant <= 128) then return end
  local t = math.floor(npc.SubType/64)
  local s = npc.SubType
  npc:Morph(804, 0, t, -1)
  mod:GetEntityData(npc).ffGrimaceShootOffset = (s%64) * 2
end, 804)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, npc)

  --if not (npc.Variant >= 124 and npc.Variant <= 128) then return end

  if npc.State == 8 and mod:GetEntityData(npc).ffGrimaceShootOffset and mod:GetEntityData(npc).ffGrimaceShootOffset > 0 then
    npc:GetSprite():Stop()
    mod:GetEntityData(npc).ffGrimaceShootOffset = mod:GetEntityData(npc).ffGrimaceShootOffset - 1
  end
end, 804)