---@type StatCompare
local _, addon = ...
---@class StatCompareTooltip
local tooltip = { addon = addon }
addon.tooltip = tooltip

---Get stats from tooltip
function tooltip:stats(f)
    local parser = self.addon.parser:parse(f)
    return parser:stats()
end

function tooltip:compare_stat_frames(base, compare)
    local stats_base = self:stats(base)
    local stats_compare = self:stats(compare)
    return self.addon.utils.compare_stats(stats_base, stats_compare)
end

function tooltip:show_diff(frame, diff)
    if self.addon.BMUtils:empty(diff) then
        return
    end

    local diff_sorted = self.addon.utils.sort_diff(diff)
    frame:AddLine(' ')
    frame:AddLine(_G.ITEM_DELTA_DESCRIPTION, 1, 211 / 255, 0, true)

    for _, values in ipairs(diff_sorted) do
        local stat, v = _G.unpack(values)
        if v ~= 0 then
            local value, format
            if v % 1 == 0 then
                format = '%d' --int
            else
                format = '%.1f' --float
            end
            if not stat:find('SHORT') and _G[stat .. '_SHORT'] ~= nil then
                stat = stat .. '_SHORT' --Use short name if available
            end

            if v > 0 then
                value = addon.BMUtils:colorize(('+' .. format):format(v), 0, 255, 0)
            else
                value = addon.BMUtils:colorize((format):format(v), 255, 0, 0)
            end
            local text = ('%s %s'):format(value, addon.BMUtils:colorize(_G[stat], 255, 255, 255))
            frame:AddLine(text)--, (v < 0) and 1 or 0, (v > 0) and 1 or 0, 0)
        end

    end
end

for _, frame in ipairs({ _G.ShoppingTooltip1, _G.ShoppingTooltip2 }) do
    frame:HookScript("OnTooltipSetItem", function(self)
        local diff = tooltip:compare_stat_frames(self, _G.GameTooltip)
        tooltip:show_diff(self, diff)
    end)
end
