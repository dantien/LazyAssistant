local addonName, ns = ...
ns.Templates = {}

local commonStart = [[
/cleartarget [dead][noexists]
/targetenemy [noexists]
/startattack
]]

-- ============================================================================
-- 🏹 HUNTER  —  per spec-tree: [1] Beast Mastery, [2] Marksmanship, [3] Survival
-- Shared toolkit (traps, Deterrence/Disengage/Feign Death, Multi-Shot/Volley,
-- aspects) is identical across trees on purpose - those aren't talent-gated
-- in WotLK. Only the main rotation and burst cooldowns actually differ.
-- ============================================================================
ns.Templates["HUNTER"] = {
    -- ---- [1] Beast Mastery ----
    [1] = {
        [1] = commonStart .. [[
/cast [mod:shift, @pet, exists, nodead] Misdirection
/cast Bestial Wrath
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
    },
    -- ---- [2] Marksmanship ----
    [2] = {
        [1] = commonStart .. [[
/cast [mod:shift, @pet, exists, nodead] Misdirection
/cast Rapid Fire
/cast [mod:alt, @target, exists, harm] Kill Shot
/castsequence reset=target/combat Hunter's Mark, Serpent Sting, Chimera Shot, Aimed Shot, Steady Shot, Steady Shot, Chimera Shot, Aimed Shot, Steady Shot, Steady Shot
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
/cast Readiness
/cast [@target,exists,harm] Silencing Shot
]]
    },
    -- ---- [3] Survival ----
    [3] = {
        [1] = commonStart .. [[
/cast [mod:shift, @pet, exists, nodead] Misdirection
/cast [mod:alt, @target, exists, harm] Kill Shot
/castsequence reset=target/combat Hunter's Mark, Serpent Sting, Black Arrow, Explosive Shot, Steady Shot, Explosive Shot, Aimed Shot, Steady Shot
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
/cast Rapid Fire
]]
    }
}

-- ============================================================================
-- ⚔️ WARRIOR  —  per spec-tree: [1] Arms, [2] Fury, [3] Protection
-- ============================================================================
ns.Templates["WARRIOR"] = {
    -- ---- [1] Arms ----
    [1] = {
        [1] = commonStart .. [[
/cast [nocombat] Charge
/cast [mod:alt, @target, exists, harm] Execute; [mod:shift] Victory Rush
/castsequence reset=target/combat Rend, Mortal Strike, Overpower, Slam, Slam
/cast Heroic Strike
]],
        [2] = [[
/cast Sweeping Strikes
/cast Whirlwind
/cast Cleave
]],
        [3] = [[
/cast [mod:shift] Berserker Rage; [mod:ctrl] Enraged Regeneration; Retaliation
]],
        [4] = [[
/cast [mod:shift] Intimidating Shout; [mod:ctrl] Hamstring; Pummel
]],
        [5] = [[
/castsequence Battle Shout, Commanding Shout
]]
    },
    -- ---- [2] Fury ----
    [2] = {
        [1] = commonStart .. [[
/cast [nocombat] Charge
/cast Recklessness
/cast Death Wish
/cast [mod:alt, @target, exists, harm] Execute; [mod:shift] Victory Rush
/castsequence reset=target/combat Bloodthirst, Whirlwind, Bloodthirst, Heroic Strike
]],
        [2] = [[
/cast Whirlwind
/cast Cleave
/cast Heroic Strike
]],
        [3] = [[
/cast [mod:shift] Berserker Rage; [mod:ctrl] Enraged Regeneration; Retaliation
]],
        [4] = [[
/cast [mod:shift] Intimidating Shout; [mod:ctrl] Hamstring; Pummel
]],
        [5] = [[
/castsequence Battle Shout, Commanding Shout
]]
    },
    -- ---- [3] Protection ----
    [3] = {
        [1] = commonStart .. [[
/cast [nocombat] Charge
/cast [mod:alt, @target, exists, harm] Execute
/castsequence reset=target/combat Shield Slam, Revenge, Devastate, Devastate, Devastate
/cast Heroic Strike
]],
        [2] = [[
/cast Thunder Clap
/cast Shockwave
/cast Cleave
]],
        [3] = [[
/cast [mod:shift] Shield Wall; [mod:ctrl] Last Stand; Shield Block
]],
        [4] = [[
/cast [mod:shift] Concussion Blow; [mod:ctrl] Disarm; Shield Bash
]],
        [5] = [[
/castsequence Demoralizing Shout, Battle Shout, Commanding Shout
]]
    }
}

-- ============================================================================
-- 🛡️ PALADIN  —  per spec-tree: [1] Holy, [2] Protection, [3] Retribution
-- ============================================================================
ns.Templates["PALADIN"] = {
    -- ---- [1] Holy ----
    [1] = {
        [1] = commonStart .. [[
/cast [mod:shift] Divine Favor
/cast [mod:alt, @target, exists, harm] Hammer of Wrath
/castsequence reset=8 Judgement of Wisdom, Holy Shock, Consecration, Consecration
]],
        [2] = [[
/castsequence reset=8 Consecration, Holy Wrath
]],
        [3] = [[
/cast [mod:shift] Divine Shield; [mod:ctrl] Lay on Hands; [mod:alt, @player] Flash of Light; Divine Protection
]],
        [4] = [[
/cast [mod:shift] Repentance; Hammer of Justice
]],
        [5] = [[
/castsequence Greater Blessing of Wisdom, Greater Blessing of Kings
]]
    },
    -- ---- [2] Protection ----
    [2] = {
        [1] = commonStart .. [[
/cast Righteous Fury
/cast [mod:alt, @target, exists, harm] Hammer of Wrath
/castsequence reset=8 Judgement of Wisdom, Hammer of the Righteous, Shield of Righteousness, Consecration
/cast Avenger's Shield
]],
        [2] = [[
/castsequence reset=8 Consecration, Holy Wrath
]],
        [3] = [[
/cast [mod:shift] Divine Shield; [mod:ctrl] Lay on Hands; [mod:alt] Divine Protection; Holy Shield
]],
        [4] = [[
/cast [mod:shift] Repentance; Hammer of Justice
]],
        [5] = [[
/castsequence Greater Blessing of Kings, Greater Blessing of Sanctuary
]]
    },
    -- ---- [3] Retribution ----
    [3] = {
        [1] = commonStart .. [[
/cast Avenging Wrath
/cast [mod:shift] Divine Plea
/cast [mod:alt, @target, exists, harm] Hammer of Wrath
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
}

-- ============================================================================
-- 💀 DEATH KNIGHT  —  per spec-tree: [1] Blood, [2] Frost, [3] Unholy
-- All 3 share the disease-maintenance backbone (Icy Touch/Plague Strike/
-- Pestilence) and just swap their main "spender" - Heart Strike, Obliterate
-- + Frost Strike, and Scourge Strike respectively.
-- ============================================================================
ns.Templates["DEATHKNIGHT"] = {
    -- ---- [1] Blood ----
    [1] = {
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
    },
    -- ---- [2] Frost ----
    [2] = {
        [1] = commonStart .. [[
/petattack
/cast [mod:shift] Empower Rune Weapon
/castsequence reset=target/combat Icy Touch, Plague Strike, Obliterate, Obliterate, Frost Strike, Frost Strike
]],
        [2] = [[
/castsequence reset=target/combat Death and Decay, Pestilence, Howling Blast
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
    },
    -- ---- [3] Unholy ----
    [3] = {
        [1] = commonStart .. [[
/petattack
/cast [mod:shift] Death Coil
/castsequence reset=target/combat Icy Touch, Plague Strike, Scourge Strike, Scourge Strike, Death Coil
]],
        [2] = [[
/castsequence reset=target/combat Death and Decay, Pestilence, Blood Boil
]],
        [3] = [[
/cast [mod:shift] Icebound Fortitude; [mod:ctrl] Anti-Magic Shell; Bone Shield
]],
        [4] = [[
/cast [mod:shift] Strangulate; [mod:ctrl] Death Grip; Mind Freeze
]],
        [5] = [[
/cast Summon Gargoyle
/cast Raise Dead
]]
    }
}

-- ============================================================================
-- ⛪ PRIEST  —  per spec-tree: [1] Discipline, [2] Holy, [3] Shadow
-- Disc/Holy are written for SOLO leveling (their real-world use here), not
-- raid healing - Smite/Holy Fire damage plus self-sustain, not [target=tank].
-- ============================================================================
ns.Templates["PRIEST"] = {
    -- ---- [1] Discipline ----
    [1] = {
        [1] = [[
/targetenemy [noexists][dead]
/cast [mod:shift, @player] Power Word: Shield
/cast [mod:alt, @target, exists, harm] Shadow Word: Death
/castsequence reset=target/combat Holy Fire, Shadow Word: Pain, Penance, Mind Blast, Smite, Smite
]],
        [2] = [[
/cast [mod:shift] Holy Nova; Mind Sear
]],
        [3] = [[
/cast [mod:shift] Pain Suppression; [mod:ctrl] Fade; [@player] Power Word: Shield
]],
        [4] = [[
/cast Psychic Scream
]],
        [5] = [[
/castsequence Power Word: Fortitude, Divine Spirit, Shadow Protection
]]
    },
    -- ---- [2] Holy ----
    [2] = {
        [1] = [[
/targetenemy [noexists][dead]
/cast [mod:shift, @player] Renew
/cast [mod:alt, @target, exists, harm] Shadow Word: Death
/castsequence reset=target/combat Holy Fire, Shadow Word: Pain, Mind Blast, Smite, Smite, Smite
]],
        [2] = [[
/cast [mod:shift] Holy Nova; Mind Sear
]],
        [3] = [[
/cast [mod:shift] Guardian Spirit; [mod:ctrl] Fade; [@player] Flash Heal
]],
        [4] = [[
/cast Psychic Scream
]],
        [5] = [[
/castsequence Power Word: Fortitude, Divine Spirit, Shadow Protection
]]
    },
    -- ---- [3] Shadow ----
    [3] = {
        [1] = [[
/targetenemy [noexists][dead]
/cast [noform] Shadowform
/cast Power Infusion
/cast [mod:alt, @target, exists, harm] Shadow Word: Death
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
}

-- ============================================================================
-- 🔥 MAGE  —  per spec-tree: [1] Arcane, [2] Fire, [3] Frost
-- ============================================================================
ns.Templates["MAGE"] = {
    -- ---- [1] Arcane ----
    [1] = {
        [1] = [[
/targetenemy [noexists][dead]
/cast Arcane Power
/cast [mod:shift] Presence of Mind
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
    },
    -- ---- [2] Fire ----
    [2] = {
        [1] = [[
/targetenemy [noexists][dead]
/cast [nocombat] Pyroblast
/cast Combustion
/cast [mod:alt, @target, exists, harm] Scorch
/castsequence reset=target/combat Living Bomb, Fireball, Fireball, Fireball
]],
        [2] = [[
/cast [mod:shift] Frost Nova; [mod:ctrl] Dragon's Breath; Flamestrike
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
    },
    -- ---- [3] Frost ----
    [3] = {
        [1] = [[
/targetenemy [noexists][dead]
/cast Icy Veins
/cast [mod:shift] Cold Snap
/castsequence reset=target/combat Frostbolt, Frostbolt, Frostbolt, Frostbolt, Ice Lance
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
/castsequence Arcane Intellect, Frost Armor, Conjure Refreshment
]]
    }
}

-- ============================================================================
-- 😈 WARLOCK  —  per spec-tree: [1] Affliction, [2] Demonology, [3] Destruction
-- ============================================================================
ns.Templates["WARLOCK"] = {
    -- ---- [1] Affliction ----
    [1] = {
        [1] = [[
/targetenemy [noexists][dead]
/petattack
/cast [mod:shift] Life Tap
/castsequence reset=target/combat Haunt, Curse of Agony, Corruption, Unstable Affliction, Shadow Bolt, Drain Life
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
    },
    -- ---- [2] Demonology ----
    [2] = {
        [1] = [[
/targetenemy [noexists][dead]
/petattack
/cast [mod:shift] Life Tap
/castsequence reset=target/combat Immolate, Corruption, Shadow Bolt, Shadow Bolt, Soul Fire
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
/castsequence Demon Armor, Create Healthstone, Summon Voidwalker
]]
    },
    -- ---- [3] Destruction ----
    [3] = {
        [1] = [[
/targetenemy [noexists][dead]
/petattack
/cast [mod:shift] Life Tap
/castsequence reset=target/combat Immolate, Conflagrate, Chaos Bolt, Incinerate, Incinerate
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
}

-- ============================================================================
-- 🗡️ ROGUE  —  per spec-tree: [1] Assassination, [2] Combat, [3] Subtlety
-- ============================================================================
ns.Templates["ROGUE"] = {
    -- ---- [1] Assassination ----
    [1] = {
        [1] = commonStart .. [[
/cast Cold Blood
/cast [mod:shift] Vendetta
/castsequence reset=combat/target Mutilate, Mutilate, Mutilate, Envenom, Rupture
]],
        [2] = [[
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
    },
    -- ---- [2] Combat ----
    [2] = {
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
    },
    -- ---- [3] Subtlety ----
    [3] = {
        [1] = commonStart .. [[
/cast [nocombat] Stealth
/cast [mod:shift] Premeditation
/cast [nocombat] Ambush
/castsequence reset=combat/target Hemorrhage, Backstab, Backstab, Backstab, Eviscerate
]],
        [2] = [[
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
}

-- ============================================================================
-- 🐻 DRUID  —  per spec-tree: [1] Balance, [2] Feral, [3] Restoration
-- Restoration is written for SOLO leveling (baseline damage + self-sustain),
-- not group healing, matching the same choice made for Disc/Holy Priest.
-- ============================================================================
ns.Templates["DRUID"] = {
    -- ---- [1] Balance ----
    [1] = {
        [1] = [[
/targetenemy [noexists][dead]
/cast [noform] Moonkin Form
/cast Force of Nature
/castsequence reset=target/combat Moonfire, Insect Swarm, Starfire, Starfire, Wrath
]],
        [2] = [[
/cast Hurricane
/cast Typhoon
]],
        [3] = [[
/cast Barkskin
/cast [mod:shift] Nature's Grasp
]],
        [4] = [[
/cast [mod:shift] Cyclone; [mod:ctrl] Entangling Roots; Bash
]],
        [5] = [[
/castsequence Mark of the Wild, Thorns, Moonkin Aura
]]
    },
    -- ---- [2] Feral ----
    [2] = {
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
    },
    -- ---- [3] Restoration ----
    [3] = {
        [1] = [[
/targetenemy [noexists][dead]
/cast [mod:shift, @player] Rejuvenation
/cast [mod:alt, @player] Regrowth
/castsequence reset=target/combat Moonfire, Wrath, Wrath, Wrath
]],
        [2] = [[
/cast Hurricane
]],
        [3] = [[
/cast Barkskin
/cast [@player] Swiftmend
]],
        [4] = [[
/cast [mod:shift] Cyclone; [mod:ctrl] Entangling Roots; Bash
]],
        [5] = [[
/castsequence Mark of the Wild, Thorns, Tranquility
]]
    }
}

-- ============================================================================
-- ⚡ SHAMAN  —  per spec-tree: [1] Elemental, [2] Enhancement, [3] Restoration
-- Restoration is written for SOLO leveling (baseline damage + self-sustain),
-- not group healing, matching the same choice made for the other healer trees.
-- ============================================================================
ns.Templates["SHAMAN"] = {
    -- ---- [1] Elemental ----
    [1] = {
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
    },
    -- ---- [2] Enhancement ----
    [2] = {
        [1] = commonStart .. [[
/cast Feral Spirit
/cast [mod:shift] Fire Elemental Totem
/castsequence reset=target/combat Flame Shock, Stormstrike, Earth Shock, Lava Lash, Stormstrike
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
/cast [mod:shift] Call of the Elements; Lightning Shield
]]
    },
    -- ---- [3] Restoration ----
    [3] = {
        [1] = [[
/targetenemy [noexists][dead]
/cast [mod:shift, @player] Healing Wave
/cast [mod:alt, @player] Riptide
/castsequence reset=target/combat Flame Shock, Lightning Bolt, Lightning Bolt, Lightning Bolt
]],
        [2] = [[
/castsequence reset=combat Magma Totem, Fire Nova, Fire Nova
]],
        [3] = [[
/cast [mod:shift] Astral Shift; [mod:ctrl] Shamanistic Rage; [@player] Healing Wave
]],
        [4] = [[
/cast [mod:shift] Thunderstorm; Hex
]],
        [5] = [[
/cast [mod:shift] Mana Tide Totem; Water Shield
]]
    }
}

-- Generic fallback
local generic = {
    [1] = commonStart,
    [2] = "", [3] = "", [4] = "", [5] = ""
}

setmetatable(ns.Templates, {__index = function() return generic end})
