local mod = FiendFolio
local game = Game()

--[[
⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢺⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠆⠜⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⠿⠿⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⣿⣿⣿
⣿⣿⡏⠁⠀⠀⠀⠀⠀⣀⣠⣤⣤⣶⣶⣶⣶⣶⣦⣤⡄⠀⠀⠀⠀⢀⣴⣿⣿
⣿⣿⣷⣄⠀⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⡧⠇⢀⣤⣶⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣾⣮⣭⣿⡻⣽⣒⠀⣤⣜⣭⠐⢐⣒⠢⢰⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣏⣿⣿⣿⣿⣿⣿⡟⣾⣿⠂⢈⢿⣷⣞⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣽⣿⣿⣷⣶⣾⡿⠿⣿⠗⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠻⠋⠉⠑⠀⠀⢘⢻⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⡿⠟⢹⣿⣿⡇⢀⣶⣶⠴⠶⠀⠀⢽⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⡿⠀⠀⢸⣿⣿⠀⠀⠣⠀⠀⠀⠀⠀⡟⢿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⡿⠟⠋⠀⠀⠀⠀⠹⣿⣧⣀⠀⠀⠀⠀⡀⣴⠁⢘⡙⣿⣿⣿⣿⣿⣿
--]]

mod.HC = {}
mod.HC.Colors = {}
mod.HC.Colors.GhostWhite = Color(1,1,1,1,0.5,0.5,0.5)
mod.HC.Colors.GhostWhite:SetColorize(1,1,1,1)
mod.HC.Colors.GhostWhite:SetTint(2,2,2,1)
mod.HC.Colors.Silver = Color(0.9,0.9,1,1,0,0,0)
mod.HC.Colors.Silver:SetColorize(1.3,1.3,1.5,1)
mod.HC.Colors.Sickly = Color(1,1,1,1,0.5,0.5,0.5)
mod.HC.Colors.Sickly:SetColorize(1,1.5,1.2,1)
mod.HC.Colors.Sickly:SetTint(0.3,0.3,0.3,1)

FiendFolio.LoadScripts({
	-- One enemy
    "ffscripts.hippo.enemies.flashmaiden",
	"ffscripts.hippo.enemies.necornier",
	"ffscripts.hippo.enemies.holyglobin",
	"ffscripts.hippo.enemies.paladin",

    -- One item
	"ffscripts.hippo.items.copperwrench",
    "ffscripts.hippo.items.lilgolem",
})

function mod:update197(npc)
	local sprite = npc:GetSprite();
	local data = mod:GetEntityData(npc);
	local var = npc.Variant

	if var == mod.FF.FlashMaiden.Var then
		mod:flashMaidenAI(npc, sprite, data)
    elseif var == mod.FF.Necornier.Var then
		mod:necornierAI(npc, sprite, data)
	elseif npc.Variant == mod.FF.HolyGlobin.Var then
        mod:holyGlobinAI(npc, sprite, data)
	elseif npc.Variant == mod.FF.Paladin.Var then
        mod:PaladinAI(npc, sprite, data)
	end
end
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.update197, mod.FFID.Hippo)

function mod:checkEffects6430(effect)
	if effect.SubType == mod.FF.PaladinSlash.Sub then
		mod:PaladinSlashEffect(effect)
	end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.checkEffects6430, 6430)

function mod:hurt197(npc, amount, flags, source, cooldown)
	local sprite = npc:GetSprite();
	local data = mod:GetEntityData(npc);
	local var = npc.Variant

	if var == mod.FF.FlashMaiden.Var then
		return mod:flashMaidenHurt(npc, sprite, data, amount, flags, source, cooldown)
    elseif var == mod.FF.Necornier.Var then
		return mod:necornierHurt(npc, sprite, data, amount, flags, source, cooldown)
    elseif var == mod.FF.HolyGlobin.Var then
		return mod:holyGlobinHurt(npc, sprite, data, amount, flags, source, cooldown)
    elseif var == mod.FF.Paladin.Var then
        return mod:paladinHurt(npc, sprite, data, amount, flags, source, cooldown)
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.hurt197, mod.FFID.Hippo)

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, proj)
	proj = proj:ToProjectile()
	local d = mod:GetEntityData(proj)

	if d.projType == "FlashMaiden" then
		mod:flashMaidenProjDeath(proj, d)
	end
end, 9)

function mod:CountRoom(entityType,entityVariant)
	local number = 0
	for i, entity in ipairs(Isaac.FindByType(entityType, entityVariant)) do
			number = number + 1
	end
	return number
end

function mod:AreGreyButtonsPressed(lenient) -- lenient: returns true if there are no buttons
    local room = game:GetRoom()
    local isButtons = false
    if lenient == nil then lenient = false end
    for i = 1, room:GetGridSize() - 1 do
        local grid = room:GetGridEntity(i)
        if grid and grid:ToPressurePlate() and grid:GetVariant() == 0 then
            isButtons = true
            if grid.State ~= 3 then
                return false
            end
        end
    end
    return isButtons or lenient
end

function mod:RoomClearExcept(type, variant, subtype)
    for _, npc in pairs(Isaac.GetRoomEntities()) do
        if npc:ToNPC() and npc.CanShutDoors
        and not ((npc.Type == type and npc.Variant == variant and npc.SubType == subtype)
        or npc.Type == EntityType.ENTITY_GIDEON
        or npc:GetData().RoomClearException) then
            return false
        end
    end

    return mod:AreGreyButtonsPressed(true)
end 

function mod:RoomClearExceptMe(entity, variant, subtype)
    return mod:RoomClearExcept(entity.Type, variant or entity.Variant, subtype or entity.SubType)
end 

function mod:ChasePlayerLerp(npc, speed, lerpval, setGridPath)
    return mod:ChasePosition(npc, mod:confusePos(npc, npc:GetPlayerTarget().Position), speed, lerpval, setGridPath)
end

function mod:ChasePosition(npc, targetpos, speed, lerpval, setGridPath)
    lerpval = lerpval or 0.3
    local pathSpeed
    if type(speed) == "table" then
        pathSpeed = speed[2]
        speed = speed[1]
    else
        pathSpeed = (speed * 0.1) + 0.2
    end
    if setGridPath == nil then setGridPath = true end
    local room = game:GetRoom()

    if setGridPath then
        mod.QuickSetEntityGridPath(npc)
    end

    if room:CheckLine(npc.Position,targetpos,0,1,false,false) or mod:isScare(npc) then
        npc.Velocity = mod:Lerp(npc.Velocity, mod:reverseIfFear(npc, (targetpos - npc.Position):Resized(speed)), lerpval)
        return true
    elseif npc.Pathfinder:HasPathToPos(targetpos) then
        npc.Pathfinder:FindGridPath(targetpos, pathSpeed, 900, true)
        return true
    else
        npc.Velocity = mod:Lerp(npc.Velocity, Vector.Zero, lerpval)
    end
end