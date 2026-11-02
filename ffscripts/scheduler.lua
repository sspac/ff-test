local FF = FiendFolio
local co = coroutine

local function wrapInfiniteCo(func)
    return co.wrap(function(...)
        local args = {...}
        while true do
            local status, err = pcall(function() func(table.unpack(args)) end)
            if not status then
                print(err)
            end
            args = { co.yield() }
        end
    end)
end

local function RegisterCallback(cb, func, ...)
    FF:AddCallback(cb, func, ...)
    return {
        cancel = function()
            FF:RemoveCallback(cb, func)
        end
    }
end

function FF.WaitUntil(cond, cb, ...)
    if cb then
        -- if using a callback, check the cond in that callback
        local currco = co.running()
        local done = false

        local handle
        handle = RegisterCallback(cb, function()
            if cond() then
                -- once true, remove the callback so it only triggers once
                handle.cancel()
                co.resume(currco)
                done = true
            end
        end, ...)

        while not done do
            co.yield()
        end
    else
        while not cond() do
            co.yield()
        end
    end
end

function FF.WaitFor(numRuns)
    FF.WaitUntil(function()
        numRuns = numRuns - 1
        return numRuns < 0
    end)
end

function FF.AddCallbackRoutine(cb, func, ...)
    local cofunc = wrapInfiniteCo(func)
    return RegisterCallback(cb, function(...)
        cofunc(...)
    end, ...)
end

function FF.DoRoutines(funcs, ent)
    -- avoid running routines after entity ceases to exist
    -- this can cause cached variables (e.g. sprites) in coroutines
    -- to become invalid and crash the game without a trace
    if not ent:Exists() then return end

    local data = FF:GetEntityData(ent)
    if not data.Routines then
        data.Routines = {}
    end

    for _, func in ipairs(funcs) do
        data.Routines[func] = data.Routines[func] or wrapInfiniteCo(func)
        data.Routines[func](ent)
    end
end

