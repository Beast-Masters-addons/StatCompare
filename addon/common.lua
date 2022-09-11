---@class StatCompare
local addonName, addon = ...
addon.name = addonName
addon.version = '@project-version@'
---@type BMUtils
addon.BMUtils = _G.LibStub('BM-utils-1')
