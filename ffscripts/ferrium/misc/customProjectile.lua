local mod = FiendFolio

function mod:TryToAddProjBehavior(v, d, tab)
    d.projType = "customProjectileBehavior"
    if d.customProjectileBehavior then
        local orig = d.customProjectileBehavior
        for key,entry in pairs(tab) do
            if orig[key] then
                if type(entry) == "function" then
                    if type(orig[key]) == "table" then
                        table.insert(orig[key], entry)
                    else
                        orig[key] = {orig[key], entry}
                    end
                else
                    orig[key] = entry
                end
            else
                orig[key] = entry
            end
        end
    else
        d.customProjectileBehavior = tab
    end
end

function mod.customProjectileBehavior(v, d)
    if d.projType == "customProjectileBehavior" and d.customProjectileBehavior then
        local tab = d.customProjectileBehavior
        if tab.update then
            if type(tab.update) == "table" then
                for key,entry in pairs(tab.update) do
                    entry(v, tab, d, key)
                end
            else
                tab.update(v, tab)
            end
        end
    end
end

function mod.customProjectileRemove(v, d)
    if d.projType == "customProjectileBehavior" and d.customProjectileBehavior then
        local tab = d.customProjectileBehavior
        if tab.death then
            if type(tab.death) == "table" then
                for key,entry in pairs(tab.death) do
                    entry(v:ToProjectile(), tab, d, key)
                end
            else
                tab.death(v:ToProjectile(), tab, d)
            end
        end
    end
end

function mod:TryToAddTearBehavior(v, d, tab)
    if d.customTearBehavior then
        local orig = d.customTearBehavior
        for key,entry in pairs(tab) do
            if orig[key] then
                if type(entry) == "function" then
                    if type(orig[key]) == "table" then
                        table.insert(orig[key], entry)
                    else
                        orig[key] = {orig[key], entry}
                    end
                else
                    orig[key] = entry
                end
            else
                orig[key] = entry
            end
        end
    else
        d.customTearBehavior = tab
    end
end

function mod.customTearBehavior(v, d)
    if d.customTearBehavior then
        local tab = d.customTearBehavior
        if tab.update then
            if type(tab.update) == "table" then
                for key,entry in pairs(tab.update) do
                    entry(v, tab, d, key)
                end
            else
                tab.update(v, tab, d)
            end
        end
    end
end

function mod.customTearRemove(v, d)
    if d.customTearBehavior then
        local tab = d.customTearBehavior
        if tab.death then
            if type(tab.death) == "table" then
                for key,entry in pairs(tab.death) do
                    entry(v:ToTear(), tab, d, key)
                end
            else
                tab.death(v:ToTear(), tab, d)
            end
        end
    end
end

function mod.collideWithPillarProj(v, d)
    if d.noWallCollidePillar then
        local wallDetect = Game():GetRoom():GetGridCollisionAtPos(v.Position)
		if wallDetect == GridCollisionClass.COLLISION_WALL then
			v:Die()
		end
    end
end