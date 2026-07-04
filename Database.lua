local addonName, ns = ...
ns.DB = {}

local playerClass

function ns.DB.Init()
    playerClass = select(2, UnitClass("player"))

    LazyAssistantDB = LazyAssistantDB or { 
        point = "CENTER", x = 0, y = 0, visible = true, 
        alerts = true,
        macros = {} 
    }
    if LazyAssistantDB.alerts == nil then
        LazyAssistantDB.alerts = true
    end
    if LazyAssistantDB.showMinimap == nil then
        LazyAssistantDB.showMinimap = true
    end
    if LazyAssistantDB.minimapAngle == nil then
        LazyAssistantDB.minimapAngle = 45
    end
    
    -- Tøm feilloggen på oppstart så den kun inneholder gjeldende økt
    LazyAssistantDB.errors = {}
    
    -- Structure: DB.macros[CLASS][SPEC_GROUP][BUTTON_INDEX]
    if not LazyAssistantDB.macros[playerClass] then
        LazyAssistantDB.macros[playerClass] = {}
    end

    -- Structure: DB.tabNames[CLASS][BUTTON_INDEX]
    LazyAssistantDB.tabNames = LazyAssistantDB.tabNames or {}
    if not LazyAssistantDB.tabNames[playerClass] then
        LazyAssistantDB.tabNames[playerClass] = {
            [1] = "MAIN",
            [2] = "AOE",
            [3] = "PANIC",
            [4] = "CC",
            [5] = "BURST"
        }
    end
end

function ns.DB.GetMacro(index)
    local spec = GetActiveTalentGroup() or 1 -- 1 or 2 (Dual Spec)
    
    -- Ensure tables exist
    if not LazyAssistantDB.macros[playerClass][spec] then
        LazyAssistantDB.macros[playerClass][spec] = {}
    end
    
    local text = LazyAssistantDB.macros[playerClass][spec][index]
    
    -- Load template if empty
    if not text or text == "" then
        text = ns.Templates[playerClass][index] or ""
    end
    
    return text
end

function ns.DB.SaveMacro(index, text)
    local spec = GetActiveTalentGroup() or 1
    LazyAssistantDB.macros[playerClass][spec][index] = text
end

function ns.DB.ResetToDefaults()
    local spec = GetActiveTalentGroup() or 1
    LazyAssistantDB.macros[playerClass][spec] = {} -- Wipe custom
end

function ns.DB.LogError(msg)
    if not LazyAssistantDB then return end
    LazyAssistantDB.errors = LazyAssistantDB.errors or {}
    table.insert(LazyAssistantDB.errors, {
        time = date("%Y-%m-%d %H:%M:%S"),
        error = msg
    })
end
