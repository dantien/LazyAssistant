local addonName, ns = ...
ns.Templates = {}

local commonStart = [[
/cleartarget [dead][noexists]
/targetenemy [noexists]
/startattack
]]

-- ============================================================================
-- 🏹 HUNTER (Beast Mastery)
-- ============================================================================
ns.Templates["HUNTER"] = {
    [1] = commonStart .. [[
/petattack
/petautocastoff [group] Growl; /petautocaston [nogroup] Growl
/cast [mod:shift, @focus, help][mod:shift, @pet, exists] Misdirection
/cast Bestial Wrath
/cast Rapid Fire
/cast [target=pettarget,exists] Call of the Wild
/cast [target=pettarget,exists] Kill Command
/cast [target=pettarget,exists] Rabid
/cast [mod:alt, @target, exists, harm] Kill Shot
/castsequence reset=target/combat Hunter's Mark, Serpent Sting, Steady Shot, Steady Shot, Steady Shot, Steady Shot, Steady Shot, Steady Shot, Steady Shot
]],
    [2] = [[
/startattack
/petattack
/cast [mod:shift, nochanneling:Volley] Multi-Shot; [nochanneling:Volley] Volley
]],
    [3] = [[
/petpassive
/petfollow
/cast [mod:shift] Deterrence; [mod:ctrl] Disengage; Feign Death
]],
    [4] = [[
/cast [mod:shift] Frost Trap; [mod:ctrl] Explosive Trap; [mod:alt] Snake Trap; Freezing Trap
]],
    [5] = [[
/cast [mod:shift] !Aspect of the Dragonhawk; [mod:ctrl] !Aspect of the Viper; [mod:alt] !Aspect of the Pack
/castsequence [nomod] !Aspect of the Dragonhawk, !Aspect of the Viper
]]
}

-- ============================================================================
-- ⚔️ WARRIOR (Arms/Fury Hybrid Leveling)
-- ============================================================================
ns.Templates["WARRIOR"] = {
    [1] = commonStart .. [[
/cast [nocombat] Charge
/cast Recklessness
/cast [mod:shift] Execute; [mod:ctrl] Victory Rush
/castsequence reset=target/combat Rend, Mortal Strike, Overpower, Slam
/cast Heroic Strike
]],
    [2] = [[
/cast [mod:shift] Bladestorm
/cast Sweeping Strikes
/cast Whirlwind
/cast Cleave
]],
    [3] = [[
/cast [mod:shift] Shield Wall; [mod:ctrl] Enraged Regeneration; Shield Block
]],
    [4] = [[
/cast [mod:shift] Intimidating Shout; [mod:ctrl] Hamstring; Pummel
]],
    [5] = [[
/castsequence Battle Shout, Commanding Shout
]]
}

-- ============================================================================
-- 🛡️ PALADIN (Retribution)
-- ============================================================================
ns.Templates["PALADIN"] = {
    [1] = commonStart .. [[
/cast Avenging Wrath
/cast [mod:shift] Divine Plea; [mod:ctrl] Hammer of Wrath
/castsequence reset=8 Judgement of Light, Crusader Strike, Divine Storm, Consecration, Exorcism
]],
    [2] = [[
/castsequence reset=8 Divine Storm, Consecration, Holy Wrath
]],
    [3] = [[
/cast [mod:shift] Divine Shield; [mod:ctrl] Lay on Hands; Divine Protection
]],
    [4] = [[
/cast [mod:shift] Repentance; Hammer of Justice
]],
    [5] = [[
/castsequence Greater Blessing of Might, Greater Blessing of Kings
]]
}

-- ============================================================================
-- 💀 DEATH KNIGHT (Unholy/Blood Leveling)
-- ============================================================================
ns.Templates["DEATHKNIGHT"] = {
    [1] = commonStart .. [[
/petattack
/cast [mod:shift] Death Coil
/castsequence reset=target/combat Icy Touch, Plague Strike, Heart Strike, Heart Strike, Death Strike, Death Coil
]],
    [2] = [[
/castsequence reset=target/combat Death and Decay, Pestilence, Blood Boil, Blood Boil
]],
    [3] = [[
/cast [mod:shift] Icebound Fortitude; [mod:ctrl] Vampiric Blood; Anti-Magic Shell
]],
    [4] = [[
/cast [mod:shift] Strangulate; [mod:ctrl] Death Grip; Mind Freeze
]],
    [5] = [[
/cast Horn of Winter
/cast Raise Dead
]]
}

-- ============================================================================
-- ⛪ PRIEST (Shadow)
-- ============================================================================
ns.Templates["PRIEST"] = {
    [1] = [[
/targetenemy [noexists][dead]
/cast [noform] Shadowform
/cast Power Infusion
/cast [mod:shift] Shadow Word: Death
/castsequence reset=target/combat Vampiric Touch, Devouring Plague, Mind Blast, Mind Flay, Mind Flay
]],
    [2] = [[
/cast [mod:shift] Holy Nova; Mind Sear
]],
    [3] = [[
/cast [mod:shift] Dispersion; [mod:ctrl] Fade; Power Word: Shield
]],
    [4] = [[
/cast Psychic Scream
]],
    [5] = [[
/castsequence Power Word: Fortitude, Divine Spirit, Shadow Protection
]]
}

-- ============================================================================
-- 🔥 MAGE (Arcane/Frost)
-- ============================================================================
ns.Templates["MAGE"] = {
    [1] = [[
/targetenemy [noexists][dead]
/cast Presence of Mind
/cast [mod:shift] Arcane Missiles
/castsequence reset=target/combat Arcane Blast, Arcane Blast, Arcane Blast, Arcane Barrage
]],
    [2] = [[
/cast [mod:shift] Frost Nova; [mod:ctrl] Arcane Explosion; Blizzard
]],
    [3] = [[
/cast [mod:shift] Ice Block; [mod:ctrl] Mana Shield; Ice Barrier
]],
    [4] = [[
/cast Counterspell
]],
    [5] = [[
/castsequence Arcane Intellect, Molten Armor, Conjure Refreshment
]]
}

-- ============================================================================
-- 😈 WARLOCK (Destruction/Affliction)
-- ============================================================================
ns.Templates["WARLOCK"] = {
    [1] = [[
/targetenemy [noexists][dead]
/petattack
/cast [mod:shift] Life Tap
/castsequence reset=target/combat Immolate, Curse of Agony, Corruption, Chaos Bolt, Incinerate, Incinerate, Conflagrate
]],
    [2] = [[
/cast [mod:shift] Seed of Corruption; Rain of Fire
]],
    [3] = [[
/cast [mod:shift] Howl of Terror; [mod:ctrl] Fear; Death Coil
]],
    [4] = [[
/cast Banish
]],
    [5] = [[
/castsequence Fel Armor, Create Healthstone, Summon Imp
]]
}

-- ============================================================================
-- 🗡️ ROGUE (Combat)
-- ============================================================================
ns.Templates["ROGUE"] = {
    [1] = commonStart .. [[
/cast Adrenaline Rush
/cast Blade Flurry
/cast [mod:shift] Killing Spree
/castsequence reset=combat/target Sinister Strike, Sinister Strike, Sinister Strike, Sinister Strike, Eviscerate
]],
    [2] = [[
/cast Blade Flurry
/cast Fan of Knives
]],
    [3] = [[
/cast [mod:shift] Cloak of Shadows; [mod:ctrl] Vanish; Evasion
]],
    [4] = [[
/cast [mod:shift] Gouge; Kidney Shot
]],
    [5] = [[
/use Instant Poison IX
/use Deadly Poison IX
]]
}

-- ============================================================================
-- 🐻 DRUID (Feral/Balance Hybrid)
-- ============================================================================
ns.Templates["DRUID"] = {
    [1] = commonStart .. [[
/cast [nostance] Cat Form
/cast [stance:1] Mangle (Bear)
/cast [stance:1] Maul
/castsequence [stance:3] reset=target/combat Mangle (Cat), Rake, Mangle (Cat), Mangle (Cat), Ferocious Bite
/cast [nostance] Wrath
]],
    [2] = [[
/cast [stance:1] Swipe (Bear); [stance:3] Swipe (Cat); Hurricane
]],
    [3] = [[
/cast Barkskin
/cast [stance:1] Frenzied Regeneration; [stance:3] Survival Instincts
]],
    [4] = [[
/cast [mod:shift] Cyclone; [mod:ctrl] Entangling Roots; Bash
]],
    [5] = [[
/castsequence Mark of the Wild, Thorns, Omen of Clarity
]]
}

-- ============================================================================
-- ⚡ SHAMAN (Elemental)
-- ============================================================================
ns.Templates["SHAMAN"] = {
    [1] = [[
/targetenemy [noexists][dead]
/cast Elemental Mastery
/cast [mod:shift] Chain Lightning
/castsequence reset=target/combat Flame Shock, Lava Burst, Lightning Bolt, Lightning Bolt, Earth Shock
]],
    [2] = [[
/castsequence reset=combat Magma Totem, Fire Nova, Fire Nova
]],
    [3] = [[
/cast [mod:shift] Astral Shift; [mod:ctrl] Shamanistic Rage; Stoneclaw Totem
]],
    [4] = [[
/cast [mod:shift] Thunderstorm; Hex
]],
    [5] = [[
/cast [mod:shift] Call of the Elements; Water Shield
]]
}

-- Generic fallback
local generic = {
    [1] = commonStart,
    [2] = "", [3] = "", [4] = "", [5] = ""
}

setmetatable(ns.Templates, {__index = function() return generic end})
