local addonName, ns = ...
ns.Utils = {}

-- 🔇 Error Filter & Custom Redirector to "LazyErrors" Chat Tab
local errorFrame
local function GetErrorFrame()
    if errorFrame then return errorFrame end
    for i = 1, NUM_CHAT_WINDOWS do
        local name = GetChatWindowInfo(i)
        if name == "LazyErrors" then
            errorFrame = _G["ChatFrame"..i]
            return errorFrame
        end
    end
    -- Opprett ny chat-fane hvis den ikke eksisterer
    if FCF_OpenNewWindow then
        FCF_OpenNewWindow("LazyErrors")
        for i = 1, NUM_CHAT_WINDOWS do
            local name = GetChatWindowInfo(i)
            if name == "LazyErrors" then
                errorFrame = _G["ChatFrame"..i]
                -- Fjern alle standardkanaler fra denne fanen så den forblir ren
                if FCF_UnregisterAllMessagesFromFrame then
                    FCF_UnregisterAllMessagesFromFrame(errorFrame)
                end
                return errorFrame
            end
        end
    end
    errorFrame = DEFAULT_CHAT_FRAME
    return errorFrame
end

-- Avregistrer standard rød feilskrift fra midten av skjermen
if UIErrorsFrame then
    UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
end

local ErrorFilter = CreateFrame("Frame")
ErrorFilter:RegisterEvent("UI_ERROR_MESSAGE")
ErrorFilter:SetScript("OnEvent", function(self, event, msg)
    local frame = GetErrorFrame()
    if frame then
        frame:AddMessage(string.format("|cffff0000[LazyError]|r %s", msg))
    end
    -- Logg feilen til SavedVariables databasen
    if ns.DB and ns.DB.LogError then
        ns.DB.LogError(msg)
    end
end)


-- 🏷️ Tag System (Smart Macro Translator)
local tags = {
    ["HUNTER"] = {
        ["@EXECUTE"] = "/cast [mod:shift,exists,harm] Kill Shot",
        ["@INTERRUPT"] = "/cast Intimidation",
        ["@BIG_CD"] = "/cast Bestial Wrath\n/cast Rapid Fire\n/cast [target=pettarget,exists] Call of the Wild",
        ["@MISDIRECT"] = "/cast [@focus,help][@pet,exists] Misdirection"
    },
    ["WARRIOR"] = {
        ["@EXECUTE"] = "/cast Execute",
        ["@INTERRUPT"] = "/cast Pummel",
        ["@BIG_CD"] = "/cast Recklessness"
    },
    ["PRIEST"] = {
        ["@EXECUTE"] = "/cast Shadow Word: Death",
        ["@INTERRUPT"] = "/cast Silence",
        ["@BIG_CD"] = "/cast Power Infusion"
    },
    ["DEFAULT"] = {
        ["@EXECUTE"] = "",
        ["@INTERRUPT"] = "",
        ["@BIG_CD"] = "",
        ["@MISDIRECT"] = ""
    }
}

function ns.Utils.ParseTags(text, class)
    if not text then return "" end
    local classTags = tags[class] or tags["DEFAULT"]
    
    -- Replace known tags
    for tag, replacement in pairs(classTags) do
        text = string.gsub(text, tag, replacement)
    end
    
    -- Fallback for tags not in class list (use default empty)
    for tag, replacement in pairs(tags["DEFAULT"]) do
        text = string.gsub(text, tag, replacement)
    end
    
    return text
end

_G.LazyClicks = 0
function _G.LazyLog(index)
    _G.LazyClicks = _G.LazyClicks + 1
    if LazyAssistantDB and LazyAssistantDB.debug then
        local frame = GetErrorFrame()
        if frame then
            frame:AddMessage(string.format("|cFF00FF00[LazyAssistant]|r Klikk registrert på knapp %d! Totalt: %d", index or 1, _G.LazyClicks))
        end
    end
end

-- 📦 Wrap Macro (Trinkets + Safety + Logging)
function ns.Utils.WrapMacro(text, index)
    local prefix = string.format("/run LazyLog(%d)\n/console Sound_EnableSFX 0\n/use 13\n/use 14\n/use 10\n", index or 1)
    local suffix = "\n/console Sound_EnableSFX 1\n/script UIErrorsFrame:Clear()"
    return prefix .. text .. suffix
end
