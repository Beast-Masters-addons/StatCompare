---@type StatCompare
local _, addon = ...
---@class TooltipParse
local parser = {}
addon.parser = parser

---@param tooltip GameTooltip
---@return TooltipParse
function parser:parse(tooltip)
    local o = {}
    o.tooltip = tooltip

    setmetatable(o, self)
    self.__index = self
    return o
end

function parser:armor()
    local frame = self.tooltip:GetName()
    for i = 3, self.tooltip:NumLines() do
        local text = _G[frame .. "TextLeft" .. i]:GetText()
        local match = text:match('(%d+)%s' .. _G.STAT_ARMOR)
        if match then
            return tonumber(match)
        end
    end
end

---Get stats from tooltip
function parser:stats()
    local _, link = self.tooltip:GetItem()
    local stats = {}

    if link then
        stats = _G.GetItemStats(link)
    end
    stats['STAT_ARMOR'] = self:armor()

    return stats
end