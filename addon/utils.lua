---@type StatCompare
local _, addon = ...
---@class StatCompareUtils
local utils = {}
addon.utils = utils

function utils.sort_diff(diff)
    local diff_values = {}
    for key, value in pairs(diff) do
        table.insert(diff_values, { key, value })
    end

    table.sort(diff_values, function(a, b)
        return a[1] > b[1]
    end)

    return diff_values
end

function utils.compare_stats(base, compare)
    local diff = {}
    for stat, value in pairs(base) do
        if compare[stat] ~= nil then
            diff[stat] = compare[stat] - base[stat]
        else
            --Stats not on compared item
            diff[stat] = -value
        end
    end

    --Stats only on compared item
    for stat, value in pairs(compare) do
        if diff[stat] == nil then
            diff[stat] = value
        end
    end

    --Remove stats with no difference
    for stat in pairs(diff) do

        if diff[stat] == 0 then
            diff[stat] = nil
        end
    end

    return diff
end

function utils.parseFloat(float)
    local num = float:gsub(_G.DECIMAL_SEPERATOR, '.')
    return tonumber(num)
end

function utils.formatFloat(float)
    return tostring(float):gsub('%.', _G.DECIMAL_SEPERATOR)
end

function utils.isFloat(num)
    return num % 1 == 0
end