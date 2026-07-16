local addonName, ns = ...

-- 🚀 BOOTLOADER
local e = CreateFrame("Frame")
e:RegisterEvent("ADDON_LOADED")
e:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
e:RegisterEvent("PLAYER_ENTERING_WORLD")
e:RegisterEvent("SPELLS_CHANGED")
e:RegisterEvent("LEARNED_SPELL_IN_TAB")
e:RegisterEvent("PLAYER_LEVEL_UP")
e:RegisterEvent("PLAYER_REGEN_ENABLED")
e:RegisterEvent("UNIT_PET")
local playerClass = select(2, UnitClass("player"))
local killShotAlerted = false
local soonAlerted = false

-- Dedicated Alert Frame for LazyAssistant
local alertFrame = CreateFrame("Frame", "LazyAlertFrame", UIParent)
alertFrame:SetSize(600, 60)
alertFrame:SetPoint("CENTER", 0, 180) -- Highly visible center-top position (above character)
alertFrame:Hide()

local alertText = alertFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
alertText:SetPoint("CENTER")
local fontPath, _, _ = alertText:GetFont()
alertText:SetFont(fontPath, 26, "THICKOUTLINE") -- Bold size with a dark outline for high contrast

-- Timer to hide our custom alert frame
local alertTimerFrame = CreateFrame("Frame")
alertTimerFrame:Hide()
local alertTimeLeft = 0
alertTimerFrame:SetScript("OnUpdate", function(self, elapsed)
    alertTimeLeft = alertTimeLeft - elapsed
    if alertTimeLeft <= 0 then
        alertFrame:Hide()
        self:Hide()
    end
end)

local function TriggerAlert(text)
    alertText:SetText(text)
    alertFrame:Show()
    alertTimeLeft = 1.2 -- Show for exactly 1.2 seconds
    alertTimerFrame:Show()
end

e:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "LazyAssistant" then
        ns.DB.Init()
        ns.Utils.RefreshKnownSpells()
        ns.Engine.Init()
        ns.UI.Init()
        
        -- Load first button into UI
        ns.UI.LoadMacro(1)
        
        self:RegisterEvent("UNIT_HEALTH")
        self:RegisterEvent("PLAYER_TARGET_CHANGED")
        
        self:UnregisterEvent("ADDON_LOADED")
        print("|cFF00FF00LazyAssistant v5.1:|r Modular Engine Loaded. Use |cFFFFFF00/la|r")
    elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
        if ns.Utils and ns.Utils.RefreshKnownSpells then
            ns.Utils.RefreshKnownSpells()
        end
        if ns.Engine and ns.Engine.UpdateAll then
            ns.Engine.UpdateAll()
        end
        if LazyAssistantGUI and LazyAssistantGUI:IsShown() and ns.UI.LoadMacro then
            ns.UI.LoadMacro(1)
        end
    elseif event == "PLAYER_ENTERING_WORLD" or event == "SPELLS_CHANGED"
        or event == "LEARNED_SPELL_IN_TAB" or event == "PLAYER_LEVEL_UP"
        or (event == "UNIT_PET" and arg1 == "player") then
        -- Spellbook may have changed (leveled up, trained a spell, logged in) - 
        -- rescan what's known and rebuild the macros to match
        if ns.Utils and ns.Utils.RefreshKnownSpells then
            ns.Utils.RefreshKnownSpells()
        end
        if ns.Engine and ns.Engine.UpdateAll then
            ns.Engine.UpdateAll()
        end
        if ns.UI and ns.UI.RefreshCurrent then
            ns.UI.RefreshCurrent()
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        -- Secure buttons can't be touched during combat (InCombatLockdown
        -- blocks it in Engine.UpdateAll). Catch up here in case a level-up
        -- or spec-related rebuild got skipped while a fight was in progress.
        if ns.Engine and ns.Engine.UpdateAll then
            ns.Engine.UpdateAll()
        end
    elseif event == "UNIT_HEALTH" and arg1 == "target" or event == "PLAYER_TARGET_CHANGED" then
        if event == "PLAYER_TARGET_CHANGED" then
            killShotAlerted = false
            soonAlerted = false
        end
        if LazyAssistantDB and not LazyAssistantDB.alerts then return end
        if UnitExists("target") and not UnitIsDead("target") and UnitCanAttack("player", "target") then
            local hp = UnitHealth("target")
            local max = UnitHealthMax("target")
            if max > 0 then
                local pct = hp / max
                if playerClass == "HUNTER" then
                    if pct <= 0.20 then
                        if not killShotAlerted then
                            killShotAlerted = true
                            TriggerAlert("|cff00ff00>>> USE KILL SHOT (ALT) <<<|r")
                            PlaySoundFile("Sound\\Spells\\RaidWarning.wav")
                        end
                    elseif pct <= 0.25 then
                        if not soonAlerted then
                            soonAlerted = true
                            TriggerAlert("|cffffd200>>> KILL SHOT SOON (25%) <<<|r")
                        end
                    elseif pct > 0.25 then
                        killShotAlerted = false
                        soonAlerted = false
                    end
                elseif playerClass == "WARRIOR" then
                    if pct <= 0.20 then
                        if not killShotAlerted then
                            killShotAlerted = true
                            TriggerAlert("|cffff0000>>> USE EXECUTE (ALT) <<<|r")
                            PlaySoundFile("Sound\\Spells\\RaidWarning.wav")
                        end
                    elseif pct <= 0.25 then
                        if not soonAlerted then
                            soonAlerted = true
                            TriggerAlert("|cffffd200>>> EXECUTE SOON (25%) <<<|r")
                        end
                    elseif pct > 0.25 then
                        killShotAlerted = false
                        soonAlerted = false
                    end
                elseif playerClass == "PALADIN" then
                    if pct <= 0.35 then
                        if not killShotAlerted then
                            killShotAlerted = true
                            TriggerAlert("|cffffff00>>> USE HAMMER OF WRATH (ALT) <<<|r")
                            PlaySoundFile("Sound\\Spells\\RaidWarning.wav")
                        end
                    elseif pct <= 0.40 then
                        if not soonAlerted then
                            soonAlerted = true
                            TriggerAlert("|cffffd200>>> HAMMER SOON (40%) <<<|r")
                        end
                    elseif pct > 0.40 then
                        killShotAlerted = false
                        soonAlerted = false
                    end
                end
            end
        else
            killShotAlerted = false
            soonAlerted = false
        end
    end
end)

SLASH_LAZYAS1 = "/la"
SlashCmdList["LAZYAS"] = function(msg)
    if msg == "alerts" then
        if LazyAssistantDB then
            LazyAssistantDB.alerts = not LazyAssistantDB.alerts
            print("|cFF00FF00LazyAssistant:|r Execute alerts are now " .. (LazyAssistantDB.alerts and "|cFF00FF00ENABLED|r" or "|cFFFF0000DISABLED|r"))
        end
    elseif msg == "minimap" then
        if LazyAssistantDB then
            LazyAssistantDB.showMinimap = not LazyAssistantDB.showMinimap
            print("|cFF00FF00LazyAssistant:|r Minimap button is now " .. (LazyAssistantDB.showMinimap and "|cFF00FF00ENABLED|r" or "|cFFFF0000DISABLED|r"))
            if LazyMinimapButton then
                if LazyAssistantDB.showMinimap then
                    LazyMinimapButton:Show()
                else
                    LazyMinimapButton:Hide()
                end
            end
        end
    else
        ns.UI.Toggle()
    end
end
