local mod = FiendFolio
local game = Game()

function FiendFolio:IsPlayerWeapon(entity)
    return entity.Type == EntityType.ENTITY_TEAR
    or entity.Type == EntityType.ENTITY_FAMILIAR
    or entity.Type == EntityType.ENTITY_LASER
    or entity.Type == EntityType.ENTITY_KNIFE
end

-- Returns nil if no pillars
function FiendFolio:GetClosestPillar(pos)
	local room = Game():GetRoom()
	
    local distance, pillarPos

	for i = 0, room:GetGridSize() - 1 do
        local grid = room:GetGridEntity(i)
        if grid and grid:GetType() == GridEntityType.GRID_PILLAR then
            local calc = grid.Position:Distance(pos)
            if not distance or calc < distance then
                distance = calc
                pillarPos = grid.Position
            end
        end
    end
	
    return pillarPos
end

---@param tear EntityTear
function FiendFolio:ClearTearEffectSprites(tear)
    tear:GetDeadEyeSprite():Reset()
    tear:GetTearEffectSprite():Reset()
    tear:GetTearHaloSprite():Reset()
end

-- Excludes co-op babies, Found Soul, Strawman, co-op ghosts, etc.
---@param player EntityPlayer
function FiendFolio:IsRealAlivePlayer(player)
    local effects = player:GetEffects()
    return player.Variant == PlayerVariant.PLAYER
    and not player:IsCoopGhost()
    and not player:IsDead()
    and not player:HasMortalDamage()
    and not effects:HasNullEffect(NullItemID.ID_SOUL_FORGOTTEN)
    and not effects:HasNullEffect(NullItemID.ID_SOUL_JACOB)
    and not effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_STRAW_MAN)
end

-- Renders the white outline for active items that have custom rendering.
-- renderType 0 - render both the sprite and the white outline, if the outline should be rendered
-- renderType 1 - only render the white outline, if the outline should be rendered
-- renderType 2 - only render the sprite
function FiendFolio:RenderActive(sprite, player, slot, offset, scale, alpha, renderType)
    --local pkitem = player:GetPocketItem(0)
    --local ispocketactive = (pkitem:GetSlot() == 3 and pkitem:GetType() == 2)
    local renderPos = Vector(16, 16) * scale
    --if slot ~= ActiveSlot.SLOT_PRIMARY and not ispocketactive then
    --    renderPos = renderPos / 2
    --end

    renderPos = renderPos + offset

    sprite.Scale = Vector(scale, scale)

    local minUsableCharge = player:GetActiveMinUsableCharge(slot)
    if minUsableCharge > 0 
    and minUsableCharge <= player:GetActiveCharge(slot)
    and (renderType == 0 or renderType == 1) then
        sprite.Color = Color(1, 1, 1, alpha, 1, 1, 1)

        sprite:Render(renderPos + Vector(0, 1))
        sprite:Render(renderPos + Vector(0, -1))
        sprite:Render(renderPos + Vector(1, 0))
        sprite:Render(renderPos + Vector(-1, 0))

        sprite.Color = Color(1, 1, 1, alpha)
    end

    if renderType == 0 or renderType == 2 then
        sprite:Render(renderPos)
    end
end

function FiendFolio:CopyColor(color)
    return Color.Lerp(Color(1, 1, 1, 1), color, 1)
end

-- Try not to call this every frame, as it doesn't cache the path.
-- Code adapted from PROAPI!!!!!!
---@param player EntityPlayer
---@param position Vector
function FiendFolio:CanReachPosition(player, position)
    local room = game:GetRoom()
    local hasFlight = player:IsFlying() or player.CanFly
    if not mod.RoomGridPath then -- TODO update this for enemies that mess with the path values
        mod.RoomGridPath = mod:GetRoomGridPath()
    end
    if not mod.RoomIndexOffsets then
        mod.RoomIndexOffsets = mod:GetRoomIndexOffsets()
    end

    if room:CheckLine(position, player.Position, hasFlight and LineCheckMode.EXPLOSION or LineCheckMode.ENTITY, 1, false, false) then
        return true
    end

    local threshold = 0
    if not mod.RoomGridPreBuiltPaths[threshold] then
        local path = {}
        for i = 0, #mod.RoomGridPath do
            if mod.RoomGridPath[i] <= threshold or (hasFlight and mod.RoomGridPath[i] == 3000) then
                path[i] = 1000
            else
                path[i] = 2000
            end
        end
        mod.RoomGridPreBuiltPaths[threshold] = path
    end
    local path = { table.unpack(mod.RoomGridPreBuiltPaths[threshold]) }
    local cells = {}
    local targetIndex = room:GetGridIndex(position)
    path[targetIndex] = 0
    table.insert(cells, targetIndex)
    for _, gridIndex in ipairs(cells) do
        for _, offset in pairs(mod.RoomIndexOffsets) do
            local adjIndex = gridIndex + offset
            if path[adjIndex] == 1000 then
                path[adjIndex] = path[gridIndex] + 1
                table.insert(cells, adjIndex)
            end
        end
    end

    -- Check if there's a valid path by looking for the player's grid index
    for i, adjIndex in pairs(cells) do
        if adjIndex == room:GetGridIndex(player.Position) then
            return true
        end
    end

    return false
end

---@param player EntityPlayer
---@param position Vector
function FiendFolio:FindNearestReachableTile(player, position, dontOverlapEntities)
    local room = game:GetRoom()
    if FiendFolio:CanReachPosition(player, position) then
        if dontOverlapEntities and room:FindFreePickupSpawnPosition(position, 0, true, true):Distance(position) > 1 then
            return FiendFolio:FindNearestReachableTile(player, room:FindFreePickupSpawnPosition(position, 0, true, true), dontOverlapEntities)
        end

        return position
    else
        local gridSize = room:GetGridSize()
        local dist, chosen
        for i = 0, gridSize - 1 do
            local coll = room:GetGridCollision(i)
            if (player:IsFlying() and coll < GridCollisionClass.COLLISION_WALL)
            or coll == GridCollisionClass.COLLISION_NONE then
                local pos = room:GetGridPosition(i)
                local calc = pos:DistanceSquared(position)
                if not dist or dist > calc then
                    if FiendFolio:CanReachPosition(player, pos) then
                        if dontOverlapEntities and room:FindFreePickupSpawnPosition(pos, 0, true, true):Distance(pos) < 1 then
                            dist = calc
                            chosen = pos 
                        elseif not dontOverlapEntities then
                            dist = calc
                            chosen = pos
                        end
                    end
                end
            end
        end

        return chosen
    end
end

FiendFolio.LoadScripts({

    -- Utilities
    -- "ffscripts.catinsurance.utilities.golden_trinket_blacklist",
    
    -- Items
    "ffscripts.catinsurance.items.hydrokinesis",
    "ffscripts.catinsurance.items.friends_fireball_formula",
    "ffscripts.catinsurance.items.daydream",
    "ffscripts.catinsurance.items.imp_soda_tricky_cherry",
    "ffscripts.catinsurance.items.grandpas_gattling_gun",
    "ffscripts.catinsurance.items.shadow_cluster",
    "ffscripts.catinsurance.items.shuffle_bombs",
    "ffscripts.catinsurance.items.repentance_plus",
    "ffscripts.catinsurance.items.gizmo_boots",
    "ffscripts.catinsurance.items.nendoroid",
    "ffscripts.catinsurance.items.golden_spikes",
    "ffscripts.catinsurance.items.brilliance",
    "ffscripts.catinsurance.items.radiance",
    "ffscripts.catinsurance.items.moms_pendant",
    "ffscripts.catinsurance.items.echolilac",
    "ffscripts.catinsurance.items.soapsuds",

    -- Cards
    "ffscripts.catinsurance.cards.egg_sack",
    "ffscripts.catinsurance.cards.soul_of_friend",

    -- Trinkets
    "ffscripts.catinsurance.trinkets.infestation_one_point_five",
    "ffscripts.catinsurance.trinkets.spectral_keychain",
    "ffscripts.catinsurance.trinkets.corrupted_larva",
    "ffscripts.catinsurance.trinkets.wanted_poster",
    "ffscripts.catinsurance.trinkets.five_leaf_clover",
    "ffscripts.catinsurance.trinkets.circadian_rhythm",
    "ffscripts.catinsurance.trinkets.baby_bottle",

    -- Rocks
    "ffscripts.catinsurance.rocks.eternalcrystal",
    "ffscripts.catinsurance.rocks.uranium",

    -- Familiars
    "ffscripts.catinsurance.familiars.blue_baby_spider",
    "ffscripts.catinsurance.familiars.raincloud",
    "ffscripts.catinsurance.familiars.snags",
    "ffscripts.catinsurance.familiars.plasma_ball",
    "ffscripts.catinsurance.familiars.cry_baby",
    "ffscripts.catinsurance.familiars.lil_inaba",

    -- Enemies
    "ffscripts.catinsurance.enemies.level_0_fly",
    "ffscripts.catinsurance.enemies.warp_cultist",
    "ffscripts.catinsurance.enemies.klutz",
    "ffscripts.catinsurance.enemies.geigerspirit",
    "ffscripts.catinsurance.enemies.binary",
    "ffscripts.catinsurance.enemies.congregation",
    "ffscripts.catinsurance.enemies.cacapillar",
    "ffscripts.catinsurance.enemies.turducken",
    "ffscripts.catinsurance.enemies.peepy",
    "ffscripts.catinsurance.enemies.dang",
    "ffscripts.catinsurance.enemies.flaming_minecart",

    -- Guns
    "ffscripts.catinsurance.guns.evil_eye",
    "ffscripts.catinsurance.guns.cursed_eye",
    "ffscripts.catinsurance.guns.chocolate_milk",
    "ffscripts.catinsurance.guns.epiphora",
    "ffscripts.catinsurance.guns.c_section",
    "ffscripts.catinsurance.guns.number_one",
    "ffscripts.catinsurance.guns.left_right_eye_interactions",
    "ffscripts.catinsurance.guns.immaculate_heart",
    "ffscripts.catinsurance.guns.kidney_stone",
    "ffscripts.catinsurance.guns.tough_love",
    "ffscripts.catinsurance.guns.tech_05",
    "ffscripts.catinsurance.guns.technology_2",
    "ffscripts.catinsurance.guns.tear_copying_familiar",
    "ffscripts.catinsurance.guns.mega_mush",
    "ffscripts.catinsurance.guns.dead_tooth",
    "ffscripts.catinsurance.guns.polyphemus",

    -- Pickups
    "ffscripts.catinsurance.pickups.spare_eraser",

    -- Grids
    "ffscripts.catinsurance.grids.golden_spike_rock",

    -- Misc
    "ffscripts.catinsurance.misc.fortune_gfx",
    "ffscripts.catinsurance.misc.commands_stuff",
    "ffscripts.catinsurance.misc.mega_mush_costumes",
    "ffscripts.catinsurance.misc.wisps_stuff",
    "ffscripts.catinsurance.misc.shitposts",
    "ffscripts.catinsurance.misc.delirium",
    "ffscripts.catinsurance.misc.splash_text",
    "ffscripts.catinsurance.misc.locusts_stuff",

    -- Skinless
    "ffscripts.catinsurance.skinless.skinless",
})

-- [[ BASIS OF CALLBACK MERGING CODE TAKEN FROM CONNOR, THANK YOU ]]

local ENEMY_CALLBACKS = {
	Init = { Callback = ModCallbacks.MC_POST_NPC_INIT },
	--PreUpdate = { Callback = ModCallbacks.MC_PRE_NPC_UPDATE },
	Update = { Callback = ModCallbacks.MC_NPC_UPDATE },
	PreRender = { Callback = ModCallbacks.MC_PRE_NPC_RENDER },
    PostRender = { Callback = ModCallbacks.MC_POST_NPC_RENDER },
	Death = { Callback = ModCallbacks.MC_POST_NPC_DEATH },
	PreCollisionEarly = {
		Callback = ModCallbacks.MC_PRE_NPC_COLLISION,
		Priority = CallbackPriority.EARLY,
	},
	PreCollisionLate = {
		Callback = ModCallbacks.MC_PRE_NPC_COLLISION,
		Priority = CallbackPriority.LATE,
	},
    PostCollision = { Callback = ModCallbacks.MC_POST_NPC_COLLISION },
	PreDamageEarly = {
		Callback = ModCallbacks.MC_ENTITY_TAKE_DMG,
		Priority = CallbackPriority.EARLY,
	},
	PreDamageLate = {
		Callback = ModCallbacks.MC_ENTITY_TAKE_DMG,
		Priority = CallbackPriority.LATE,
	},
    PostDeath = { Callback = ModCallbacks.MC_POST_NPC_DEATH },
    PostRemove = { Callback = ModCallbacks.MC_POST_ENTITY_REMOVE }
}

local CAT_ENEMIES = {
	[FiendFolio.FF.Geigerspirit.Var] = {
		Init = mod.GeigerspiritInit,
		Update = mod.GeigerspiritUpdate,
        PreDamageEarly = mod.GeigerspiritTakeDamage
    },
    [FiendFolio.FF.Klutz.Var] = {
        Init = mod.KlutzInit,
        Update = mod.KlutzUpdate,
        PreRender = mod.KlutzPreRender,
        PostCollision = mod.KlutzPostCollision,
        PreDamageEarly = mod.KlutzCancelHazardDamage,
    },
    [FiendFolio.FF.Level0Fly.Var] = {
        Init = mod.LevelZeroFlyInit,
        Update = mod.LevelZeroFlyUpdate,
        PostRender = mod.LevelZeroFlyRender,
        PostCollision = mod.LevelZeroFlyCollision,
        PreDamageEarly = mod.LevelZeroFlyCancelDamage,
        PostDeath = mod.LevelZeroFlyDie,
    },
    [FiendFolio.FF.WarpCultist.Var] = {
        Init = mod.WarpCultistInit,
        Update = mod.WarpCultistUpdate,
    },
    [FiendFolio.FF.BinaryRed.Var] = {
        Init = mod.BinaryInit,
        Update = mod.BinaryUpdate,
        PreDamageEarly = mod.BinaryHurt,
        PostCollision = mod.BinaryCollide,
    },
    [FiendFolio.FF.Congregation.Var] = {
        Init = mod.CongregationInit,
        Update = mod.CongregationNpcUpdate,
        PreCollisionEarly = mod.CongregationCollision,
        PreRender = mod.CongregationRender,
    },
    [FiendFolio.FF.Cacapillar.Var] = {
        Update = mod.CacapillarUpdate,
        Death = mod.CacapillarDeath,
    },
    [FiendFolio.FF.Turducken.Var] = {
        Update = mod.TurduckenUpdate,
        Death = mod.TurduckenDeath,
    },
    [FiendFolio.FF.Peepy.Var] = {
        Update = mod.PeepyUpdate,
    },
    [FiendFolio.FF.Dang.Var] = {
        Init = mod.DangInit,
        Update = mod.clotterAI,
    },
    [FiendFolio.FF.DangCornHazard.Var] = {
        Init = mod.DangCornHazardInit,
        Update = mod.DangCornHazardUpdate,
        Death = mod.DangCornHazardDeath,
    },
}

for key, tab in pairs(ENEMY_CALLBACKS) do
	mod:AddPriorityCallback(tab.Callback, tab.Priority or CallbackPriority.DEFAULT, function(_, npc, ...)
		local vartab = CAT_ENEMIES[npc.Variant]
		if vartab then
			local func = vartab[key]
			if func then
				return func(FiendFolio, npc, ...)
			end
		end
	end, FiendFolio.FFID.Cat)
end

function mod:catinsurancePlayerUpdate(player, data)
    mod:KlutzResistMovement(player, data)
end

function mod:catinsurancePeffectUpdate(player, data)
    mod:ShootGrandpasGatlingGun(player, data)
    mod:EpiphoraGunTrackDirection(player, data)
	mod:FriendTech05Laser(player, data)
	mod:ShootGrandpasGatlingGun(player, data)
	mod:UpdateHydroLastAttackDirection(player, data)
	mod:DepleteTrickyCherryCritTime(player, data)
end

function mod:catinsurancePostRender()
    mod:CircadianRhythmRender()
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.catinsurancePostRender)

function mod:catinsurancePostUpdate()
    mod:DaydreamUpdate()
    mod:SpectralKeychainHandleCombining()
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.catinsurancePostUpdate)

function mod:catinsurancePostPlayerTakeDmg(player, ...)
    local data = mod:GetEntityData(player)
    mod:KlutzCancelControlPlayer(player, data, ...)
    mod:FriendTeleportOnDamage(player, data, ...)
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, mod.catinsurancePostPlayerTakeDmg, EntityType.ENTITY_PLAYER)

function mod:catinsurancePostNewRoom()
    mod:KlutzCancelControlAllPlayer()
    mod:WarpCultistWipeReviveList()
    mod:DaydreamAngelPostNewRoom()
    mod:ResetDaydreamRazor()
    mod:ResetDaydreamSpoonbender()
    mod:RemoveRainclouds()
    mod:SpectralKeychainResetDoorslotStuff()
    mod:PlasmaBallNewRoom()
    mod:GoldenSpikeNewRoom()
    mod:GizmoBootsReset()
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.catinsurancePostNewRoom)

function mod:catinsurancePostNewLevel()
    mod:ChaosBombsRandomizeEffects()
    mod:GrandpasGatlingGunRefill()
    mod:PlasmaBallNewLevel()
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.catinsurancePostNewLevel)

function mod:catinsurancePreGameExit()
    mod:WarpCultistWipeReviveList()
end
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.catinsurancePreGameExit)

function mod:catinsurancePostTearInit(tear)
    mod:WispTearFired(tear)
end
mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, mod.catinsurancePostTearInit)

function mod:catinsuranceProjDeath(proj, data)
    mod:TurduckenProjectileDeath(proj, data)
    mod:DangCornProjectileDeath(proj, data)
end