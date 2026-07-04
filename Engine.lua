local addonName, ns = ...
ns.Engine = {}

local NUM_BUTTONS = 5
local playerClass
local buttons = {}

function ns.Engine.Init()
    playerClass = select(2, UnitClass("player"))

    for i = 1, NUM_BUTTONS do
        local btn = CreateFrame("Button", "LazyButton"..i, UIParent, "SecureActionButtonTemplate")
        btn:RegisterForClicks("AnyDown", "AnyUp")
        btn:SetAttribute("type", "macro")
        buttons[i] = btn
    end
    ns.Engine.UpdateAll()
end

function ns.Engine.UpdateAll()
    if InCombatLockdown() then return end -- Safety first
    
    for i = 1, NUM_BUTTONS do
        -- 1. Get Raw Text (from DB or Template)
        local raw = ns.DB.GetMacro(i)
        
        -- 2. Parse Smart Tags (@EXECUTE -> Kill Shot)
        local parsed = ns.Utils.ParseTags(raw, playerClass)
        
        -- 3. Wrap (Auto-Trinket + Silence)
        local final = ns.Utils.WrapMacro(parsed, i)
        
        -- 4. Apply to Secure Button
        buttons[i]:SetAttribute("macrotext", final)
    end
end
