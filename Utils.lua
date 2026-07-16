local addonName, ns = ...
ns.Utils = {}

-- Fallback for legacy 3.3.5a client compatibility
local GetSpellBookItemName = GetSpellBookItemName or GetSpellName


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

-- 📚 Known Spell Cache
-- Walks the real spellbook so filtering always matches what the character
-- can currently actually cast - level, trainer visits, and talent-granted
-- spells are all reflected automatically, no hardcoded level tables needed.
local knownSpells = {}
local hasScannedSpellbook = false

function ns.Utils.RefreshKnownSpells()
    wipe(knownSpells)
    for tab = 1, GetNumSpellTabs() do
        local _, _, offset, numSlots = GetSpellTabInfo(tab)
        for i = offset + 1, offset + numSlots do
            local name = GetSpellBookItemName(i, BOOKTYPE_SPELL)
            if name then knownSpells[name] = true end
        end
    end
    -- Pet-taught abilities (pet talents like Rabid) live in a separate
    -- spellbook and are commanded via /cast from the player, so they need
    -- to count as "known" too, or lines like [target=pettarget] Rabid
    -- get wrongly stripped even when the pet genuinely has the talent.
    local numPetSpells = HasPetSpells()
    if numPetSpells then
        for i = 1, numPetSpells do
            local name = GetSpellBookItemName(i, "pet")
            if name then knownSpells[name] = true end
        end
    end
    hasScannedSpellbook = true
end

-- Strips leading [conditions] and a leading ! toggle marker so we're left
-- with just the bare spell name to check against the spellbook.
local function ExtractSpellName(segment)
    local rest = strtrim(segment)
    while true do
        local remainder = rest:match("^%[.-%]%s*(.*)$")
        if not remainder then break end
        rest = remainder
    end
    rest = rest:gsub("^!", "")
    return strtrim(rest)
end

-- /cast [cond] SpellA; [cond] SpellB; SpellC  ->  drops only the unknown segments
local function FilterCastLine(line)
    local prefix, body = line:match("^(/cast%s+)(.+)$")
    if not prefix then return line end

    local kept = {}
    for segment in (body .. ";"):gmatch("(.-);") do
        local trimmed = strtrim(segment)
        if trimmed ~= "" then
            local spellName = ExtractSpellName(trimmed)
            if spellName == "" or knownSpells[spellName] then
                table.insert(kept, trimmed)
            end
        end
    end

    if #kept == 0 then return nil end -- every segment was an unknown spell
    return prefix .. table.concat(kept, "; ")
end

-- /castsequence [cond] reset=X SpellA, SpellB, SpellC  ->  drops unknown
-- entries from the sequence while preserving the condition block/reset clause.
local function FilterCastSequenceLine(line)
    local body = line:match("^/castsequence%s+(.*)$")
    if not body then return line end

    local condBlock = ""
    while true do
        local cond, remainder = body:match("^(%[.-%])%s*(.*)$")
        if not cond then break end
        condBlock = condBlock .. cond .. " "
        body = remainder
    end

    local resetPart = ""
    local resetToken, afterReset = body:match("^(reset=%S+)%s+(.*)$")
    if resetToken then
        resetPart = resetToken .. " "
        body = afterReset
    end

    local kept = {}
    for spell in (body .. ","):gmatch("(.-),") do
        local name = strtrim(spell)
        if name ~= "" and knownSpells[name] then
            table.insert(kept, name)
        end
    end

    if #kept == 0 then return nil end -- sequence would be empty, drop the line
    return "/castsequence " .. condBlock .. resetPart .. table.concat(kept, ", ")
end

-- 🧹 Filters /cast and /castsequence entries for spells the character
-- doesn't currently know (wrong level, wrong spec, not trained yet).
-- Runs after ParseTags, so it only ever sees real spell names, never tags.
function ns.Utils.FilterUnknownSpells(text)
    if not text or text == "" then return text end
    -- Safety: if we haven't scanned the spellbook yet, don't filter at all -
    -- better to show everything than to accidentally wipe out a macro.
    if not hasScannedSpellbook or not next(knownSpells) then return text end

    local out = {}
    for line in (text .. "\n"):gmatch("(.-)\n") do
        local trimmedLine = strtrim(line)
        local result = trimmedLine
        if trimmedLine:match("^/castsequence") then
            result = FilterCastSequenceLine(trimmedLine)
        elseif trimmedLine:match("^/cast%s") then
            result = FilterCastLine(trimmedLine)
        end
        if result then
            table.insert(out, result)
        end
    end
    return table.concat(out, "\n")
end

local function CountCastLineSpells(line, counts)
    local body = line:match("^/cast%s+(.+)$")
    if not body then return end
    for segment in (body .. ";"):gmatch("(.-);") do
        local trimmed = strtrim(segment)
        if trimmed ~= "" then
            local spellName = ExtractSpellName(trimmed)
            if spellName ~= "" then
                counts.total = counts.total + 1
                if knownSpells[spellName] then counts.known = counts.known + 1 end
            end
        end
    end
end

local function CountCastSequenceSpells(line, counts)
    local body = line:match("^/castsequence%s+(.*)$")
    if not body then return end
    while true do
        local remainder = body:match("^%[.-%]%s*(.*)$")
        if not remainder then break end
        body = remainder
    end
    local afterReset = body:match("^reset=%S+%s+(.*)$")
    if afterReset then body = afterReset end
    for spell in (body .. ","):gmatch("(.-),") do
        local name = strtrim(spell)
        if name ~= "" then
            counts.total = counts.total + 1
            if knownSpells[name] then counts.known = counts.known + 1 end
        end
    end
end

-- 📊 How many abilities in this macro text are currently castable vs total
-- referenced. Purely additive/informational - doesn't change what plays,
-- just gives the UI something honest to show ("5/7 known") without needing
-- a hardcoded spell-to-level table anywhere.
function ns.Utils.CountSpellCoverage(text)
    local counts = { known = 0, total = 0 }
    if not text or text == "" or not hasScannedSpellbook then return counts.known, counts.total end

    for line in (text .. "\n"):gmatch("(.-)\n") do
        local trimmedLine = strtrim(line)
        if trimmedLine:match("^/castsequence") then
            CountCastSequenceSpells(trimmedLine, counts)
        elseif trimmedLine:match("^/cast%s") then
            CountCastLineSpells(trimmedLine, counts)
        end
    end
    return counts.known, counts.total
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
