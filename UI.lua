local addonName, ns = ...
ns.UI = {}

local frame, editBox, helpFrame
local currentBtn = 1
local mainButtons = {}
local tabNameBox

-- Button Labels
local btnLabels = {
    [1] = "MAIN",
    [2] = "AOE",
    [3] = "PANIC",
    [4] = "CC",
    [5] = "BURST"
}

function ns.UI.Init()
    frame = CreateFrame("Frame", "LazyAssistantGUI", UIParent)
    frame:SetSize(500, 430) -- Taller to fit help text
    frame:SetPoint("CENTER")
    frame:SetBackdrop({
        bgFile = "Interface/DialogFrame/UI-DialogBox-Background", 
        edgeFile = "Interface/DialogFrame/UI-DialogBox-Border", 
        tile = true, tileSize = 32, edgeSize = 32, 
        insets = { left = 8, right = 8, top = 8, bottom = 8 }
    })
    frame:SetBackdropColor(0, 0, 0, 0.9)
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local p, _, _, x, y = self:GetPoint()
        LazyAssistantDB.point = p; LazyAssistantDB.x = x; LazyAssistantDB.y = y
    end)
    frame:SetScript("OnShow", function(self)
        if LazyAssistantDB and LazyAssistantDB.point then
            self:ClearAllPoints()
            self:SetPoint(LazyAssistantDB.point, UIParent, LazyAssistantDB.point, LazyAssistantDB.x, LazyAssistantDB.y)
        end
    end)
    frame:SetScript("OnHide", function()
        if helpFrame and helpFrame:IsShown() then
            helpFrame:Hide()
        end
    end)
    frame:Hide()
    tinsert(UISpecialFrames, "LazyAssistantGUI") 

    local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", -5, -5)

    local helpBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    helpBtn:SetSize(20, 20)
    helpBtn:SetPoint("TOPRIGHT", -35, -6)
    helpBtn:SetText("?")
    helpBtn:SetScript("OnClick", function() ns.UI.ShowHelp() end)

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -12)
    title:SetText("LazyAssistant v5.1")

    -- Info Text
    local info = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    info:SetPoint("TOP", 0, -35)
    info:SetText("Select a macro slot below to edit.")

    -- Button Selectors (1-5)
    local playerClass = select(2, UnitClass("player"))
    for i = 1, 5 do
        local b = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
        b:SetSize(60, 25) -- Wider buttons
        b:SetPoint("TOPLEFT", 20 + ((i-1)*70), -60)
        local btnText = (LazyAssistantDB and LazyAssistantDB.tabNames and LazyAssistantDB.tabNames[playerClass]) and LazyAssistantDB.tabNames[playerClass][i] or btnLabels[i]
        b:SetText(btnText) -- Smart Names
        b:SetScript("OnClick", function() ns.UI.LoadMacro(i) end)
        mainButtons[i] = b
    end

    -- Editor Title
    local editTitle = frame:CreateFontString("LazyEditTitle", "OVERLAY", "GameFontNormal")
    editTitle:SetPoint("TOPLEFT", 25, -95)
    editTitle:SetText("Editing: MAIN (Single Target)")

    -- Scroll Editor
    local scroll = CreateFrame("ScrollFrame", "LazyAssistantScrollFrame", frame, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 20, -120)
    scroll:SetPoint("BOTTOMRIGHT", -30, 50)

    editBox = CreateFrame("EditBox", "LazyAssistantEditBox", scroll)
    editBox:SetMultiLine(true)
    editBox:SetFontObject(ChatFontNormal)
    editBox:SetWidth(450)
    editBox:SetHeight(300)
    editBox:SetAutoFocus(false)
    editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    scroll:SetScrollChild(editBox)

    -- Custom Tab Name Input
    local tabNameLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    tabNameLabel:SetPoint("BOTTOMLEFT", 120, 20)
    tabNameLabel:SetText("Tab Name:")

    tabNameBox = CreateFrame("EditBox", "LazyTabNameBox", frame, "InputBoxTemplate")
    tabNameBox:SetSize(80, 20)
    tabNameBox:SetPoint("BOTTOMLEFT", 185, 17)
    tabNameBox:SetAutoFocus(false)
    tabNameBox:SetMaxLetters(8) -- Keep names short to fit button width!
    tabNameBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

    -- Save
    local save = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    save:SetPoint("BOTTOMRIGHT", -20, 15)
    save:SetSize(80, 25)
    save:SetText("Save")
    save:SetScript("OnClick", function()
        if InCombatLockdown() then print("Error: In Combat") return end
        ns.DB.SaveMacro(currentBtn, editBox:GetText())
        
        -- Save custom tab name
        local newName = strtrim(tabNameBox:GetText()):upper()
        if newName == "" then newName = btnLabels[currentBtn] end
        LazyAssistantDB.tabNames[playerClass][currentBtn] = newName
        mainButtons[currentBtn]:SetText(newName)
        
        ns.Engine.UpdateAll()
        frame:Hide()
        print("|cFF00FF00LazyAssistant:|r Saved " .. newName)
    end)

    -- Reset
    local reset = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    reset:SetPoint("BOTTOMLEFT", 20, 15)
    reset:SetSize(80, 25)
    reset:SetScript("OnClick", function()
        if InCombatLockdown() then return end
        ns.DB.ResetToDefaults()
        ns.UI.LoadMacro(currentBtn)
        ns.Engine.UpdateAll()
    end)

    -- Minimap Button
    local minimapBtn = CreateFrame("Button", "LazyMinimapButton", Minimap)
    minimapBtn:SetSize(31, 31)
    minimapBtn:SetFrameLevel(8) -- Set high frame level so it is not tucked under minimap border
    minimapBtn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    minimapBtn:RegisterForClicks("AnyUp")
    minimapBtn:RegisterForDrag("LeftButton")

    -- Circular background cutout
    local bg = minimapBtn:CreateTexture(nil, "BACKGROUND")
    bg:SetSize(20, 20)
    bg:SetPoint("TOPLEFT", 7, -5)
    bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")

    -- Icon texture (Artwork)
    local icon = minimapBtn:CreateTexture(nil, "ARTWORK")
    icon:SetSize(20, 20)
    icon:SetPoint("TOPLEFT", 7, -5)
    icon:SetTexture("Interface\\Icons\\INV_Misc_Gear_01")
    icon:SetTexCoord(0.05, 0.95, 0.05, 0.95) -- Crop square edges to make it look circular

    -- Border overlay
    local border = minimapBtn:CreateTexture(nil, "OVERLAY")
    border:SetSize(53, 53)
    border:SetPoint("TOPLEFT")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

    local function UpdateButtonPosition()
        local angle = LazyAssistantDB.minimapAngle or 45
        local x = math.cos(math.rad(angle)) * 80
        local y = math.sin(math.rad(angle)) * 80
        minimapBtn:ClearAllPoints()
        minimapBtn:SetPoint("CENTER", Minimap, "CENTER", x, y)
    end

    minimapBtn:SetScript("OnDragStart", function(self)
        self:SetScript("OnUpdate", function()
            local mx, my = Minimap:GetCenter()
            local cx, cy = GetCursorPosition()
            local scale = Minimap:GetEffectiveScale()
            cx, cy = cx / scale, cy / scale
            local angle = math.atan2(cy - my, cx - mx)
            LazyAssistantDB.minimapAngle = math.deg(angle)
            UpdateButtonPosition()
        end)
    end)

    minimapBtn:SetScript("OnDragStop", function(self)
        self:SetScript("OnUpdate", nil)
    end)

    minimapBtn:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            ns.UI.Toggle()
        elseif button == "RightButton" then
            if LazyAssistantDB then
                LazyAssistantDB.alerts = not LazyAssistantDB.alerts
                print("|cFF00FF00LazyAssistant:|r Execute alerts are now " .. (LazyAssistantDB.alerts and "|cFF00FF00ENABLED|r" or "|cFFFF0000DISABLED|r"))
            end
        end
    end)

    minimapBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:ClearLines()
        GameTooltip:AddLine("|cFF00FF00LazyAssistant|r")
        GameTooltip:AddLine("Left-Click: Toggle Editor", 1, 1, 1)
        GameTooltip:AddLine("Right-Click: Toggle Alerts", 1, 1, 1)
        GameTooltip:AddLine("Drag: Move Icon", 1, 1, 1)
        GameTooltip:Show()
    end)

    minimapBtn:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    -- Initialize position
    UpdateButtonPosition()
    
    if LazyAssistantDB.showMinimap == false then
        minimapBtn:Hide()
    end
end

function ns.UI.LoadMacro(index)
    currentBtn = index
    local playerClass = select(2, UnitClass("player"))
    local tabName = (LazyAssistantDB and LazyAssistantDB.tabNames and LazyAssistantDB.tabNames[playerClass]) and LazyAssistantDB.tabNames[playerClass][index] or btnLabels[index]
    editBox:SetText(ns.DB.GetMacro(index))
    if tabNameBox then
        tabNameBox:SetText(tabName)
    end
    _G["LazyEditTitle"]:SetText("Editing: " .. tabName)
end

function ns.UI.Toggle()
    if frame:IsShown() then frame:Hide() else frame:Show() end
end

function ns.UI.ShowHelp()
    if helpFrame and helpFrame:IsShown() then
        helpFrame:Hide()
        return
    end

    if not helpFrame then
        helpFrame = CreateFrame("Frame", "LazyAssistantHelpGUI", UIParent)
        helpFrame:SetSize(460, 370)
        
        -- Position next to main frame if shown, otherwise center
        if frame and frame:IsShown() then
            helpFrame:SetPoint("LEFT", frame, "RIGHT", 10, 0)
        else
            helpFrame:SetPoint("CENTER")
        end
        
        helpFrame:SetBackdrop({
            bgFile = "Interface/DialogFrame/UI-DialogBox-Background", 
            edgeFile = "Interface/DialogFrame/UI-DialogBox-Border", 
            tile = true, tileSize = 32, edgeSize = 32, 
            insets = { left = 8, right = 8, top = 8, bottom = 8 }
        })
        helpFrame:SetBackdropColor(0, 0, 0, 0.95)
        helpFrame:EnableMouse(true)
        helpFrame:SetMovable(true)
        helpFrame:RegisterForDrag("LeftButton")
        helpFrame:SetScript("OnDragStart", helpFrame.StartMoving)
        helpFrame:SetScript("OnDragStop", helpFrame.StopMovingOrSizing)
        tinsert(UISpecialFrames, "LazyAssistantHelpGUI")

        local closeBtn = CreateFrame("Button", nil, helpFrame, "UIPanelCloseButton")
        closeBtn:SetPoint("TOPRIGHT", -5, -5)

        local title = helpFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOPLEFT", 18, -18)
        title:SetText("Opplæring & Hjelp")

        -- Scroll Area for content
        local helpScroll = CreateFrame("ScrollFrame", "LazyHelpScrollFrame", helpFrame, "UIPanelScrollFrameTemplate")
        helpScroll:SetPoint("TOPLEFT", 20, -85)
        helpScroll:SetPoint("BOTTOMRIGHT", -30, 20)

        local content = CreateFrame("Frame", nil, helpScroll)
        content:SetSize(380, 230)
        helpScroll:SetScrollChild(content)

        local helpText = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        helpText:SetWidth(370)
        helpText:SetPoint("TOPLEFT", 5, -5)
        helpText:SetJustifyH("LEFT")
        helpText:SetJustifyV("TOP")

        -- Tab data with custom WoW formatting colors (in English, as requested)
        local tabs = {
            {
                name = "About",
                text = "|cffffd200What is LazyAssistant?|r\n" ..
                       "LazyAssistant is a powerful addon that allows you to write complex, multi-line rotation macros without the game's default 255-character limit.\n\n" ..
                       "|cffffd200How to get started:|r\n" ..
                       "1. Open this editor by typing |cff00ff00/la|r in chat.\n" ..
                       "2. Select one of the 5 macro slots (MAIN, AOE, PANIC, CC, BURST).\n" ..
                       "3. Type or paste your macro text here and click |cff00ff00Save|r.\n" ..
                       "4. Open WoWs default macro window by typing |cff00ff00/macro|r in chat.\n" ..
                       "5. Create a new macro and add the corresponding |cff00ff00/click|r command:\n" ..
                       "   - |cffffffffMAIN|r: |cff00ff00/click LazyButton1|r\n" ..
                       "   - |cffffffffAOE|r: |cff00ff00/click LazyButton2|r\n" ..
                       "   - |cffffffffPANIC|r: |cff00ff00/click LazyButton3|r\n" ..
                       "   - |cffffffffCC|r: |cff00ff00/click LazyButton4|r\n" ..
                       "   - |cffffffffBURST|r: |cff00ff00/click LazyButton5|r\n" ..
                       "6. Drag that macro to your action bar (e.g. keybind |cff00ff001|r).\n" ..
                       "7. Spam that key in combat to execute your rotation!\n" ..
                       "8. |cff00ff00Using Modifiers:|r If your macro uses a |cff00ff00[mod:alt]|r condition, hold down |cffffffffAlt|r while pressing your macro key (e.g. |cffffffffAlt+1|r) to trigger that spell."
            },
            {
                name = "Why /click?",
                text = "|cffffd200Why do I need a standard macro?|r\n" ..
                       "You might wonder why you still need to create a macro in WoWs default |cff00ff00/macro|r UI if you write your rotation inside LazyAssistant.\n\n" ..
                       "|cffffd200Blizzard's Security Restrictions:|r\n" ..
                       "For security reasons (to prevent botting), Blizzard blocks addons from casting spells or executing macro text directly in combat. Spells can only be cast when a player clicks a |cffffffffSecure Button|r.\n\n" ..
                       "|cffffd200How LazyAssistant works:|r\n" ..
                       "LazyAssistant creates 5 invisible, secure buttons in the background (|cffffffffLazyButton1|r to |cffffffff5|r) and loads your custom rotation text into them.\n\n" ..
                       "By creating a standard WoW macro with |cff00ff00/click LazyButton1|r, your keypress clicks the secure button, which safely executes your long rotation in combat!\n\n" ..
                       "|cffffd200Is this allowed / safe?|r\n" ..
                       "|cff00ff00Yes!|r LazyAssistant uses Blizzard's official, built-in |cffffffffSecureActionButtonTemplate|r. It does not automate gameplay or make decisions for you in combat (no botting). It simply allows you to write longer macros that comply 100% with the game's rules."
            },
            {
                name = "Examples",
                text = "|cffffd200Useful Macro Templates for LazyAssistant:|r\n" ..
                       "You can copy and customize these examples inside the editor:\n\n" ..
                       "|cff00ff001. Simple Cast Sequence (Rotation)|r\n" ..
                       "Casts spells in order, resetting when you change target or after 5 seconds of inactivity:\n" ..
                       "|cffffffff/castsequence reset=target/5 Serpent Sting, Steady Shot, Steady Shot|r\n\n" ..
                       "|cff00ff002. Cooldown Priority (Spam Macro)|r\n" ..
                       "WoW executes macros top-to-bottom. Spells that do not trigger the Global Cooldown (GCD) or are on cooldown will let the macro continue to the next lines:\n" ..
                       "|cffffffff/cast @BIG_CD|r\n" ..
                       "|cffffffff/cast Chimera Shot|r\n" ..
                       "|cffffffff/cast Aimed Shot|r\n" ..
                       "|cffffffff/cast Steady Shot|r\n\n" ..
                       "|cff00ff003. Modifiers (Utility Button)|r\n" ..
                       "Performs different actions depending on whether you hold Shift/Ctrl/Alt:\n" ..
                       "|cffffffff/cast [mod:shift] Hearthstone; [mod:ctrl] Mount; [@pet,dead] Revive Pet; Mend Pet|r\n\n" ..
                       "|cff00ff00How Modifiers Work:|r\n" ..
                       "To trigger a modifier spell (like |cffffffff[mod:alt] Kill Shot|r), you must hold down the corresponding key (e.g. |cff00ff00Alt|r) while pressing your macro key (e.g. |cffffffffAlt+1|r if bound to 1). This is controlled by the |cff00ff00[mod:alt]|r condition written in your macro.\n\n" ..
                       "|cffff0000*Note on Keybind Conflicts:*|r\n" ..
                       "If your macro is bound to keys |cffffffff1-10|r, holding |cffffffffCtrl|r (e.g. Ctrl+1) will trigger the Pet Bar by default instead of your macro! You can either unbind the Pet Bar keys in WoWs Keybindings, or use |cffffffffAlt|r or |cffffffffShift|r modifiers instead."
            },
            {
                name = "Smart Tags",
                text = "|cffffd200Smart Tags (Smart Shortcuts):|r\n\n" ..
                       "Instead of specific spell names, use these codes to make your macros automatically adapt to the class you are currently playing:\n\n" ..
                       "- |cff00ff00@EXECUTE|r: Automatically translates to your class execute spell (Kill Shot for Hunter, Execute for Warrior, SW: Death for Priest).\n\n" ..
                       "- |cff00ff00@BIG_CD|r: Translates to your main DPS cooldown (Bestial Wrath for Hunter, Recklessness for Warrior, Power Infusion for Priest).\n\n" ..
                       "- |cff00ff00@INTERRUPT|r: Translates to your interrupt spell (Intimidation for Hunter, Pummel for Warrior, Silence for Priest).\n\n" ..
                       "- |cff00ff00@MISDIRECT|r: Casts misdirection/threat transfer on your pet (Misdirection @pet for Hunter)."
            }
        }

        local tabButtons = {}
        local function SelectTab(id)
            for i, btn in ipairs(tabButtons) do
                if i == id then
                    btn:LockHighlight()
                else
                    btn:UnlockHighlight()
                end
            end
            helpText:SetText(tabs[id].text)
            local height = helpText:GetStringHeight()
            content:SetHeight(height + 15)
            helpScroll:SetVerticalScroll(0) -- Reset scroll to top
        end

        for i, tab in ipairs(tabs) do
            local btn = CreateFrame("Button", nil, helpFrame, "GameMenuButtonTemplate")
            btn:SetSize(95, 22)
            btn:SetPoint("TOPLEFT", 18 + ((i-1)*105), -48)
            btn:SetText(tab.name)
            btn:SetScript("OnClick", function() SelectTab(i) end)
            tabButtons[i] = btn
        end

        SelectTab(1)
    end

    helpFrame:Show()
end
