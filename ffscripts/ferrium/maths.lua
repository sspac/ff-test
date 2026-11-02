local mod = FiendFolio
local placeHolderRNG = RNG()
local game = Game()

function mod:compoundRoll(dropTable, seed, customRNG)
	if customRNG == nil then
		customRNG = placeHolderRNG
	end

	local outcomes = {}
	for key,specificRoll in ipairs(dropTable) do
		if (mod:getRoll(1, 100, customRNG) <= specificRoll[3]) then
			table.insert(outcomes, mod:getRoll(specificRoll[1], specificRoll[2], customRNG))
		else
			table.insert(outcomes, -1)
		end
	end

	return outcomes
end

--Note, maximum needs to be larger than 
function mod:getRoll(minimum, maximum, rng)
	if rng == nil then
		rng = placeHolderRNG
	end
	if minimum > maximum then
		local newMin = maximum
		maximum = minimum
		minimum = newMin
	end
	local fixedNum = maximum-minimum
	return rng:RandomInt(fixedNum)+1+minimum
end

--Does not include 0
function mod:getSeveralDifferentNumbers(needed, totalAmount, rng, blacklist)
	local numTable = {}
	local results = {}
	for i=1,totalAmount do
		table.insert(numTable, i)
	end
	if rng == nil then
		rng = placeHolderRNG
	end
	
	if blacklist then
		for _,num in ipairs(blacklist) do
			table.remove(numTable, num)
		end
	end

	for i=1,needed do
		if #numTable == 0 then
            break
        else
            local roll = rng:RandomInt(#numTable)+1
            results[i] = numTable[roll]
            table.remove(numTable, roll)
        end
	end
	return results
end

function mod:makeCopiedTable(original)
	if not original then return end
	local tab = {}
	for key,entry in pairs(original) do
		if type(entry) == "table" then
			tab[key] = mod:makeCopiedTable(entry)
		else
			tab[key] = entry
		end
	end
	return tab
end

function mod:adjustChildrenData(ent, tag, result)
	if ent.Child then
		local child = ent.Child
		while child do
			local data = mod:GetEntityData(child)
			data[tag] = result
			
			if child.Child and child.Child:Exists() then
				child = child.Child
			else
				child = nil
			end
		end
	end
end

function mod:BasicRandomFloat(low, high, rng) --I had a comment on this function saying it's not exact but I'm just copy pasting it
    local newLow = math.floor(low)
    local newHigh = math.ceil(high)
    local val = rng:RandomFloat() * (newHigh-newLow)
    return math.max(math.min(newLow+val, high), low)
end

function mod:weightedRNG(table, rng) --same goes for this one
    local totalWeight = 0
    local current = 0
    for _,entry in pairs(table) do
		if type(entry) == "table" then
			if entry.Weight then
				totalWeight = totalWeight+entry.Weight
			else
				totalWeight = totalWeight+entry[2]
			end
		else
			totalWeight = totalWeight+1
		end
    end

    local randVal = rng:RandomFloat()*totalWeight
    for key,entry in pairs(table) do
		if type(entry) == "table" then
			if entry.Weight then
				current = current+entry.Weight
			else
				current = current+entry[2]
			end
			if current >= randVal then
				return entry[1], key, entry
			end
		else
			current = current+1
			if current >= randVal then
				return entry, key
			end
		end
        
    end
end

function mod:ClampNumber(num, min, max)
	if min > max then
		local placeholder = min
		min = max
		max = placeholder
	end
	return math.min(max, math.max(min, num))
end

---Requires a list in sequential order, no missing gaps!
function mod:GetRandomOrderedTable(list2, rng, existing)
	local list = mod:makeCopiedTable(list2)
	local result = existing or {}
	local failSafe = 0
	while #list > 0 and failSafe < 100 do
		local rand = rng:RandomInt(#list)+1
		table.insert(result, list[rand])
		table.remove(list, rand)
		failSafe = failSafe+1
	end
	return result
end

--Removes entries from a table based on what the key holds.
function mod:RemoveEntryThroughResult(list2, result)
	local list = mod:makeCopiedTable(list2)
	if type(result) == "table" then
		for _,res in ipairs(result) do
			for key,entry in pairs(list) do
				if entry == res then
					table.remove(list, key)
				end
			end
		end
	else
		for key,entry in pairs(list) do
			if entry == result then
				table.remove(list, key)
			end
		end
	end
	return list
end

--Quick and dirty function, does not do well at good distances due to angles spreading out and making it inaccurate
function mod:IsPosInBetweenBad(start, stop, check, lenience, line)
	local ang = mod:GetAngleDifferenceDead((stop-start), (check-start))
	if math.abs(ang) < (lenience or 10) then
		local room = game:GetRoom()
		if start:Distance(stop) > start:Distance(check) and (not line or room:CheckLine(start, stop, line, 1, false, false))then
			return true
		end
	end
end

function mod:GoRoundNumber(num)
	local frac = num % 1
	if frac > 0.5 then
		return math.ceil(num)
	else
		return math.floor(num)
	end
end