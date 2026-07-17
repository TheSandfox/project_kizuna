//! textmacro abilityDataHeader1000
globals
	private constant integer ID = '1000'
	private constant string NAME = "방패 밀어치기"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Warrior_ShieldBash.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = CONFIG_ABILITY_TAG_BASH
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 8.0
	private constant real COOLDOWN_MIN = 2.0
	private constant integer MANACOST = 25
	private constant real BACKSWING = 0.15
	private constant real RADIUS2 = 75.0
	private constant real CHARGE_DURATION = 0.25
	private constant real CHARGE_SPEED = 1250.0
	private constant real KNOCKBACK_DISTANCE = 100.0
	private constant real KNOCKBACK_DURATION = 0.5
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PRIMARY = 1.33
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 1.5
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_DEFENSE
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_AOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
	private constant integer STAT_BONUS1 = CONFIG_STAT_DEFENSE
	private constant integer STAT_BONUS2 = CONFIG_STAT_ARMOR_PENET
endglobals
//! endtextmacro
//! textmacro abilityDataHeader1010
globals
	private constant integer ID = '1010'
	private constant string NAME = "쌍극의 번개"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\btnAbility_protoss-doubleshieldrecharge.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_DRAG_TO_USE
	private constant integer TAG1 = CONFIG_ABILITY_TAG_LIGHTNING
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 6.7
	private constant real COOLDOWN_MIN = 0.5
	private constant integer MANACOST = 27
	private constant real CAST = 0.25
	private constant real DELAY = 0.65
	private constant real RANGE = 500.
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 2.25
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_MAGICPOWER
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_MAGICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_MAGICPOWER
	private constant integer STAT_BONUS2 = CONFIG_STAT_MAGIC_PENET
endglobals
//! endtextmacro
//! textmacro abilityDataHeader1020
globals
	private constant integer ID = '1020'
	private constant string NAME = "구식 저격총"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNDwarvenLongRifle.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_FIREARM
	private constant integer TAG2 = CONFIG_ABILITY_TAG_PIERCE
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real DELAY = 2.0
	private constant real BACKSWING = 0.25
	private constant real STARTAT = 45.0
	private constant real VELO = 1875.0
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = true
	private constant real WEAPON_RANGE = 600.0
	private constant real WEAPON_DELAY = 0.5
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 2.25
	private constant real DAMAGE_AMPLIFIER2 = 1.0
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_ATTACK_SPEED
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_ACCURACY
	private constant integer STAT_BONUS2 = CONFIG_STAT_ARMOR_PENET
endglobals
//! endtextmacro
//! textmacro abilityDataHeader1030
globals
	private constant integer ID = '1030'
	private constant string NAME = "화염구"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNFireBolt.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = CONFIG_ABILITY_TAG_FIRE
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 5.5
	private constant real COOLDOWN_MIN = 0.5
	private constant integer MANACOST = 25
	private constant real DELAY = 0.2
	private constant real RANGE = 750.
	private constant real BACKSWING = 0.15
	private constant real RADIUS2 = 65.0
	private constant real RADIUS3 = 145.0
	private constant real STARTAT = 32.5
	private constant real VELO = 1100.0
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 2.25
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_MAGICPOWER
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_MAGICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_AOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_MAGICPOWER
	private constant integer STAT_BONUS2 = CONFIG_STAT_SPELL_BOOST
endglobals
//! endtextmacro
//! textmacro abilityDataHeader1040
globals
	private constant integer ID = '1040'
	private constant string NAME = "연쇄번개"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\btnAbility_swarm-kerrigan-chainreaction.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_UNIT
	private constant integer TAG1 = CONFIG_ABILITY_TAG_LIGHTNING
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 5.3
	private constant real COOLDOWN_MIN = 0.5
	private constant integer MANACOST = 22
	private constant real DELAY = 0.2
	private constant real RANGE = 575.0
	private constant real RANGE_SECONDARY = 575.0
	private constant real BACKSWING = 0.15
	private constant real INTERVAL = 0.15
	private constant integer TARGET_MAX = 4
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 1.55
	private constant real DAMAGE_AMPLIFIER2 = 0.85
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_MAGICPOWER
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_ACCURACY
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_MAGICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_MAGICPOWER
	private constant integer STAT_BONUS2 = CONFIG_STAT_ACCURACY
endglobals
//! endtextmacro
//! textmacro abilityDataHeader1050
globals
	private constant integer ID = '1050'
	private constant string NAME = "신성의 빛"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNHolyBolt.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_UNIT
	private constant integer TAG1 = CONFIG_ABILITY_TAG_DIVINE
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 8.0
	private constant real COOLDOWN_MIN = 2.0
	private constant integer MANACOST = 35
	private constant real DELAY = 0.2
	private constant real RANGE = 600.0
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_MAXHP
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_MAGICPOWER
	private constant integer DAMAGE_STAT3 = CONFIG_STAT_UNIT_LEVEL
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_MAGICPOWER
	private constant integer STAT_BONUS2 = CONFIG_STAT_MAXHP
	private constant real DATA_REAL1 = 0.0325
	private constant real DATA_REAL2 = 0.85
	private constant real DATA_REAL3 = 9.0
endglobals
//! endtextmacro
//! textmacro abilityDataHeader1060
globals
	private constant integer ID = '1060'
	private constant string NAME = "점멸"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNBlink.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = -1
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 30.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 20
	private constant real RANGE = 600.0
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.1
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_EVASION
	private constant integer STAT_BONUS2 = CONFIG_STAT_ACCURACY
endglobals
//! endtextmacro
//! textmacro abilityDataHeader1070
globals
	private constant integer ID = '1070'
	private constant string NAME = "순보"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_SavageStrike.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = CONFIG_ABILITY_TAG_SLASH
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 6.0
	private constant real COOLDOWN_MIN = 0.5
	private constant integer MANACOST = 45
	private constant real RANGE = 500.0
	private constant real RADIUS3 = 65.0
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 1.25
	private constant real DAMAGE_AMPLIFIER2 = 0.35
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_ACCURACY
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_AOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ACCURACY
	private constant real DATA_REAL1 = 24.0
endglobals
//! endtextmacro
//! textmacro abilityDataHeader1080
globals
	private constant integer ID = '1080'
	private constant string NAME = "다중사격"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Multishot.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = CONFIG_ABILITY_TAG_PIERCE
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 3.5
	private constant real COOLDOWN_MIN = 0.5
	private constant integer MANACOST = 15
	private constant real DELAY = 0.2
	private constant real RANGE = 725.0
	private constant real BACKSWING = 0.15
	private constant real RADIUS2 = 32.5
	private constant real STARTAT = 32.5
	private constant real VELO = 1400.0
	private constant real WIDTH = 30.0
	private constant integer COUNT = 5
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_SECONDARY = 0.15
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 1.68
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ACCURACY
endglobals
//! endtextmacro
//! textmacro abilityDataHeader1090
globals
	private constant integer ID = '1090'
	private constant string NAME = "곤봉"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Mace_10.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_BASH
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = false
	private constant real WEAPON_RANGE = 125.0
	private constant real WEAPON_DELAY = 1.5
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 0.85
	private constant real DAMAGE_AMPLIFIER2 = 0.015
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_MAXHP
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_MAXHP
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10a0
globals
	private constant integer ID = '10a0'
	private constant string NAME = "조잡한 검"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNSteelMelee.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_NORMAL
	private constant integer TAG2 = CONFIG_ABILITY_TAG_SLASH
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = false
	private constant real WEAPON_RANGE = 125.0
	private constant real WEAPON_DELAY = 1.5
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 1.15
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ARMOR_PENET
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10b0
globals
	private constant integer ID = '10b0'
	private constant string NAME = "짓밟기"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNWarStomp.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_BASH
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = false
	private constant real WEAPON_RANGE = 125.0
	private constant real WEAPON_DELAY = 1.5
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 0.65
	private constant real DAMAGE_AMPLIFIER2 = 0.0275
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_MAXHP
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_MAXHP
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10c0
globals
	private constant integer ID = '10c0'
	private constant string NAME = "뾰족한 가시"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNQuillSprayOff.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_BIO
	private constant integer TAG2 = CONFIG_ABILITY_TAG_PIERCE
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real BACKSWING = 0.25
	private constant real STARTAT = 25.0
	private constant real VELO = 1485.0
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = true
	private constant real WEAPON_RANGE = 500.0
	private constant real WEAPON_DELAY = 1.25
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 1.1
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ARMOR_PENET
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10d0
globals
	private constant integer ID = '10d0'
	private constant string NAME = "사기의 외침"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Shout1.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_IMMEDIATE
	private constant integer TAG1 = -1
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 12.0
	private constant real COOLDOWN_MIN = 6.0
	private constant integer MANACOST = 38
	private constant real DELAY = 0.22
	private constant real DURATION = 8.0
	private constant real RADIUS1 = 450.
	private constant real ROTSPEED = 6.0
	private constant real INTERVAL = 0.25
	private constant integer COUNT = 8
	private constant integer BUFF_ID1 = '10d0'
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_HPREGEN
	private constant real DATA_REAL1 = 5.0
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10e0
globals
	private constant integer ID = '10e0'
	private constant string NAME = "박치기"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNDizzy.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_BASH
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = false
	private constant real WEAPON_RANGE = 125.0
	private constant real WEAPON_DELAY = 1.5
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 1.0
	private constant real DAMAGE_AMPLIFIER2 = 0.2
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_DEFENSE
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ARMOR_PENET
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10f0
globals
	private constant integer ID = '10f0'
	private constant string NAME = "역류의 칼날"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNFeedBack.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_SLASH
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = false
	private constant real WEAPON_RANGE = 125.0
	private constant real WEAPON_DELAY = 1.5
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 0.65
	private constant real DAMAGE_AMPLIFIER2 = 0.3
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_MAGICPOWER
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_MAGICPOWER
	private constant real DATA_REAL1 = 10.0
	private constant real DATA_REAL2 = 2.0
	private constant real DATA_REAL3 = 3.5
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10g0
globals
	private constant integer ID = '10g0'
	private constant string NAME = "그물 던지기"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNEnsnare.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = -1
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 10.0
	private constant real COOLDOWN_MIN = 5.0
	private constant integer MANACOST = 27
	private constant real DELAY = 0.2
	private constant real DURATION = 4.0
	private constant real RANGE = 800.0
	private constant real BACKSWING = 0.15
	private constant real RADIUS2 = 55.0
	private constant real STARTAT = 28.5
	private constant real VELO = 1100.0
	private constant integer BUFF_ID1 = '10g0'
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 0.5
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ACCURACY
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_ACCURACY
	private constant integer STAT_BONUS2 = CONFIG_STAT_EVASION
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10h0
globals
	private constant integer ID = '10h0'
	private constant string NAME = "투척용 도끼"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNOrcMeleeUpOne.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_NORMAL
	private constant integer TAG2 = CONFIG_ABILITY_TAG_THROW
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real BACKSWING = 0.25
	private constant real STARTAT = 25.0
	private constant real VELO = 1485.0
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = true
	private constant real WEAPON_RANGE = 550.0
	private constant real WEAPON_DELAY = 1.25
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 0.5
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ARMOR_PENET
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10i0
globals
	private constant integer ID = '10i0'
	private constant string NAME = "가우스 라이플"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\btnAbility_tychus-weapons-level4.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_FIREARM
	private constant integer TAG2 = CONFIG_ABILITY_TAG_PIERCE
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real RANGE_SECONDARY = 150.0
	private constant real BACKSWING = 0.25
	private constant real RADIUS2 = 55.0
	private constant real STARTAT = 25.0
	private constant real VELO = 1550.0
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = true
	private constant real WEAPON_RANGE = 550.0
	private constant real WEAPON_DELAY = 1.35
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 0.4
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ACCURACY
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10j0
globals
	private constant integer ID = '10j0'
	private constant string NAME = "청록의 파동"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Nature_AbolishMagic.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_IMMEDIATE
	private constant integer TAG1 = CONFIG_ABILITY_TAG_NATURE
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 3.0
	private constant real COOLDOWN_MIN = 3.0
	private constant integer MANACOST = 20
	private constant real RADIUS1 = 225.0
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 0.0375
	private constant real DAMAGE_AMPLIFIER2 = 0.075
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_MAXHP
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_MAXMP
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_MAGICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_AOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_MAXHP
	private constant integer STAT_BONUS2 = CONFIG_STAT_HPREGEN
	private constant real DATA_REAL1 = 0.12
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10k0
globals
	private constant integer ID = '10k0'
	private constant string NAME = "사냥꾼의 장궁"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNImprovedBows.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_PIERCE
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real BACKSWING = 0.25
	private constant real STARTAT = 25.0
	private constant real VELO = 1485.0
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = true
	private constant real WEAPON_RANGE = 550.0
	private constant real WEAPON_DELAY = 1.25
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 1.1
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ACCURACY
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10l0
globals
	private constant integer ID = '10l0'
	private constant string NAME = "전기충격기 건설"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNPowerGenerator.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = CONFIG_ABILITY_TAG_SUMMON
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 4.0
	private constant real COOLDOWN_MIN = 2.0
	private constant integer MANACOST = 10
	private constant real CAST = 0.5
	private constant real DURATION = 10.0
	private constant real RADIUS3 = 100.0
	private constant integer UNIT_ID1 = 'SP06'
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_HPREGEN
	private constant integer STAT_BONUS2 = CONFIG_STAT_RODONG
	private constant real DATA_REAL1 = 0.1
	private constant real DATA_REAL2 = 0.5
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10m0
globals
	private constant integer ID = '10m0'
	private constant string NAME = "전기충격"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\btnability-protoss-beambounce.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_LIGHTNING
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real RANGE_SECONDARY = 415.0
	private constant real INTERVAL = 0.15
	private constant integer TARGET_MAX = 4
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = true
	private constant real WEAPON_RANGE = 550.0
	private constant real WEAPON_DELAY = 1.5
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 0.65
	private constant real DAMAGE_AMPLIFIER2 = 0.35
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_MAGICPOWER
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_ACCURACY
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_MAGICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_MAGICPOWER
	private constant integer STAT_BONUS2 = CONFIG_STAT_ACCURACY
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10n0
globals
	private constant integer ID = '10n0'
	private constant string NAME = "번개 발톱"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNShamanAdept.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_NORMAL
	private constant integer TAG2 = CONFIG_ABILITY_TAG_LIGHTNING
	private constant integer TAG3 = CONFIG_ABILITY_TAG_WILD
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = false
	private constant real WEAPON_RANGE = 125.0
	private constant real WEAPON_DELAY = 1.5
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 0.55
	private constant real DAMAGE_AMPLIFIER2 = 0.55
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_MAGICPOWER
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_MAGICPOWER
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10o0
globals
	private constant integer ID = '10o0'
	private constant string NAME = "행운의 금화"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNMGExchange.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = -1
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real STARTAT = 45.0
	private constant real VELO = 1375.0
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = true
	private constant real WEAPON_RANGE = 575.0
	private constant real WEAPON_DELAY = 1.5
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 1.0
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_LUCK
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_LUCK
	private constant integer STAT_BONUS2 = CONFIG_STAT_GREED
	private constant real DATA_REAL1 = 0.1
	private constant real DATA_REAL2 = 300.0
	private constant integer DATA_INTEGER1 = 1
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10p0
globals
	private constant integer ID = '10p0'
	private constant string NAME = "돌진"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_storm_ui_icon_varian_charge.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = CONFIG_ABILITY_TAG_BASH
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 9.0
	private constant real COOLDOWN_MIN = 2.0
	private constant integer MANACOST = 30
	private constant real BACKSWING = 0.15
	private constant real RADIUS2 = 75.0
	private constant real CHARGE_DURATION = 0.5
	private constant real CHARGE_SPEED = 1200.0
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 0.075
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_MAXHP
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_AOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
	private constant integer STAT_BONUS1 = CONFIG_STAT_MAXHP
	private constant integer STAT_BONUS2 = CONFIG_STAT_ARMOR_PENET
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10q0
globals
	private constant integer ID = '10q0'
	private constant string NAME = "단검"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_ShortBlade_10.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_SLASH
	private constant integer TAG2 = CONFIG_ABILITY_TAG_PIERCE
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = false
	private constant real WEAPON_RANGE = 100.0
	private constant real WEAPON_DELAY = 1.0
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 0.7
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ACCURACY
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10r0
globals
	private constant integer ID = '10r0'
	private constant string NAME = "힘의 장갑"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNGauntletsOfOgrePower.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_PASSIVE
	private constant integer TAG1 = -1
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_BASE = 0.1
	private constant real DAMAGE_PER_LEVEL = 0.01
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_MAXHP
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10s0
globals
	private constant integer ID = '10s0'
	private constant string NAME = "날카로운 갈고리"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNClawsOfAttack.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_PASSIVE
	private constant integer TAG1 = -1
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_BASE = 0.1
	private constant real DAMAGE_PER_LEVEL = 0.01
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_ACCURACY
	private constant integer STAT_BONUS2 = CONFIG_STAT_ATTACK
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10t0
globals
	private constant integer ID = '10t0'
	private constant string NAME = "에메랄드"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNGem.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_PASSIVE
	private constant integer TAG1 = -1
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_BASE = 0.15
	private constant real DAMAGE_PER_LEVEL = 0.01
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_HPREGEN
	private constant integer STAT_BONUS2 = CONFIG_STAT_MAXHP
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10u0
globals
	private constant integer ID = '10u0'
	private constant string NAME = "뛰어들기"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNGhoulFrenzy.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_UNIT
	private constant integer TAG1 = CONFIG_ABILITY_TAG_NORMAL
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 6.5
	private constant real COOLDOWN_MIN = 0.5
	private constant integer MANACOST = 20
	private constant real RANGE = 500.0
	private constant real RANGE_SECONDARY = 100.0
	private constant real BACKSWING = 0.15
	private constant real VELO = 1500.0
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 2.0
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ARMOR_PENET
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10v0
globals
	private constant integer ID = '10v0'
	private constant string NAME = "끈적거미"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_MonsterSpiderCarapace_01.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_BIO
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real DURATION = 4.0
	private constant real BACKSWING = 0.25
	private constant real STARTAT = 25.0
	private constant real VELO = 900.0
	private constant integer BUFF_ID1 = '10v0'
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = true
	private constant real WEAPON_RANGE = 500.0
	private constant real WEAPON_DELAY = 1.5
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 1.05
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ACCURACY
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10w0
globals
	private constant integer ID = '10w0'
	private constant string NAME = "치고 빠지기"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Shadow_Shadowfury.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_UNIT
	private constant integer TAG1 = CONFIG_ABILITY_TAG_NORMAL
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 10.0
	private constant real COOLDOWN_MIN = 4.0
	private constant integer MANACOST = 17
	private constant real DURATION = 0.55
	private constant real RANGE = 600.0
	private constant real RANGE_SECONDARY = 500.0
	private constant real VELO = 2560.0
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 1.55
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ACCURACY
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10x0
globals
	private constant integer ID = '10x0'
	private constant string NAME = "암흑의 마법봉"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNWandSkull.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_DARK
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real BACKSWING = 0.25
	private constant real STARTAT = 25.0
	private constant real VELO = 1200.0
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = true
	private constant real WEAPON_RANGE = 550.0
	private constant real WEAPON_DELAY = 1.5
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 1.0
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_MAGICPOWER
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_MAGICPOWER
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_MAGICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_MAGICPOWER
	private constant integer STAT_BONUS2 = CONFIG_STAT_MAXMP
	private constant real DATA_REAL1 = 0.2
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10y0
globals
	private constant integer ID = '10y0'
	private constant string NAME = "오염된 식칼"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_storm_ui_icon_stitches_slam.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_BASH
	private constant integer TAG2 = CONFIG_ABILITY_TAG_POISON
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real DURATION = 4.0
	private constant integer BUFF_ID1 = '10y0'
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = false
	private constant real WEAPON_RANGE = 125.0
	private constant real WEAPON_DELAY = 1.5
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 0.75
	private constant real DAMAGE_AMPLIFIER2 = 0.01
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_MAXHP
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_MAXHP
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10z0
globals
	private constant integer ID = '10z0'
	private constant string NAME = "맑은 물"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Water0.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_IMMEDIATE
	private constant integer TAG1 = CONFIG_ABILITY_TAG_FOOD
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 1.5
	private constant real COOLDOWN_MIN = 1.5
	private constant integer MANACOST = 0
	private constant real DURATION = 20.0
	private constant integer BUFF_ID1 = '10z0'
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_HPREGEN
	private constant integer STAT_BONUS2 = CONFIG_STAT_MPREGEN
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10A0
globals
	private constant integer ID = '10A0'
	private constant string NAME = "빵"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Pan0.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_IMMEDIATE
	private constant integer TAG1 = CONFIG_ABILITY_TAG_FOOD
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 1.5
	private constant real COOLDOWN_MIN = 1.5
	private constant integer MANACOST = 0
	private constant real DURATION = 20.0
	private constant integer BUFF_ID1 = '10A0'
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_HPREGEN
	private constant integer STAT_BONUS2 = CONFIG_STAT_MPREGEN
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10B0
globals
	private constant integer ID = '10B0'
	private constant string NAME = "행운의 은관"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNCirclet.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_PASSIVE
	private constant integer TAG1 = -1
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real DURATION = 30.0
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_LUCK
	private constant integer STAT_BONUS2 = CONFIG_STAT_LOVE
	private constant integer DATA_INTEGER1 = 10
	private constant integer DATA_INTEGER2 = 2
endglobals
//! endtextmacro
//! textmacro abilityDataHeader10C0
globals
	private constant integer ID = '10C0'
	private constant string NAME = "곡괭이"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNGatherGold.blp"
	private constant integer TIER = 1
	private constant integer COST = 1
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_BASH
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real BACKSWING = 0.25
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = false
	private constant real WEAPON_RANGE = 100.0
	private constant real WEAPON_DELAY = 1.5
	private constant real DAMAGE_SECONDARY = 3.0
	private constant real DAMAGE_PER_LEVEL = 0.06
	private constant real DAMAGE_AMPLIFIER1 = 1.1
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_HPREGEN
endglobals
//! endtextmacro
//! textmacro abilityDataHeader2000
globals
	private constant integer ID = '2000'
	private constant string NAME = "전투 자극제"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_terran-stimpack-color.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_IMMEDIATE
	private constant integer TAG1 = -1
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 10.0
	private constant real COOLDOWN_MIN = 2.0
	private constant integer MANACOST = 35
	private constant real DURATION = 5.0
	private constant integer BUFF_ID1 = '2000'
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_HPREGEN
endglobals
//! endtextmacro
//! textmacro abilityDataHeader2030
globals
	private constant integer ID = '2030'
	private constant string NAME = "칼날바람"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNWhirlwind.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_IMMEDIATE
	private constant integer TAG1 = CONFIG_ABILITY_TAG_NORMAL
	private constant integer TAG2 = CONFIG_ABILITY_TAG_SLASH
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 19
	private constant real RADIUS1 = 200.0
	private constant real ROTSPEED = 6.0
	private constant real INTERVAL = 0.25
	private constant integer COUNT = 8
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.07
	private constant real DAMAGE_AMPLIFIER1 = 0.3
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_AOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ARMOR_PENET
endglobals
//! endtextmacro
//! textmacro abilityDataHeader2040
globals
	private constant integer ID = '2040'
	private constant string NAME = "마법 카드패"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_PickACard.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_THROW
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real BACKSWING = 0.25
	private constant real STARTAT = 25.0
	private constant real VELO = 1250.0
	private constant integer COUNT = 4
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = true
	private constant real WEAPON_RANGE = 550.0
	private constant real WEAPON_DELAY = 1.0
	private constant real DAMAGE_PER_LEVEL = 0.07
	private constant real DAMAGE_AMPLIFIER1 = 0.6
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_LUCK
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_UNDEFINED
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_UNDEFINED
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_LUCK
	private constant real DATA_REAL1 = 0.25
	private constant real DATA_REAL2 = 255.0
endglobals
//! endtextmacro
//! textmacro abilityDataHeader2050
globals
	private constant integer ID = '2050'
	private constant string NAME = "암흑비전파동"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_ArchonQ.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = CONFIG_ABILITY_TAG_DARK
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 5.25
	private constant real COOLDOWN_MIN = 5.0
	private constant integer MANACOST = 25
	private constant real DELAY = 0.5
	private constant real DURATION = 2.5
	private constant real RANGE = 450.0
	private constant real RANGE_SECONDARY = 1000.0
	private constant real BACKSWING = 0.25
	private constant real RADIUS2 = 80.0
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.07
	private constant real DAMAGE_AMPLIFIER1 = 2.65
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_MAGICPOWER
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_MAGICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_AOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_MAGICPOWER
	private constant integer STAT_BONUS2 = CONFIG_STAT_MAGIC_PENET
	private constant real DATA_REAL1 = 1.25
endglobals
//! endtextmacro
//! textmacro abilityDataHeader2060
globals
	private constant integer ID = '2060'
	private constant string NAME = "수리검 투척"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Shuriken.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = CONFIG_ABILITY_TAG_THROW
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 1.5
	private constant real COOLDOWN_MIN = 1.5
	private constant integer MANACOST = 3
	private constant real DELAY = 0.25
	private constant real RANGE = 575.0
	private constant real BACKSWING = 0.15
	private constant real RADIUS2 = 55.0
	private constant real STARTAT = 35.0
	private constant real VELO = 1250.0
	private constant real INTERVAL = 0.15
	private constant integer CHARGE = 3
	private constant integer COUNT = 3
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.07
	private constant real DAMAGE_AMPLIFIER1 = 0.15
	private constant real DAMAGE_AMPLIFIER2 = 0.05
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_ACCURACY
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ACCURACY
endglobals
//! endtextmacro
//! textmacro abilityDataHeader2070
globals
	private constant integer ID = '2070'
	private constant string NAME = "불붙은 시미터"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Gangplank_Passive.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_FIRE
	private constant integer TAG2 = CONFIG_ABILITY_TAG_SLASH
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real DURATION = 5.0
	private constant integer COUNT = 3
	private constant integer BUFF_ID1 = '2070'
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = false
	private constant real WEAPON_RANGE = 125.0
	private constant real WEAPON_DELAY = 1.5
	private constant real DAMAGE_PER_LEVEL = 0.07
	private constant real DAMAGE_AMPLIFIER1 = 1.2
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_HPREGEN
endglobals
//! endtextmacro
//! textmacro abilityDataHeader2080
globals
	private constant integer ID = '2080'
	private constant string NAME = "낚시"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Fishingpole.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = -1
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 1.5
	private constant real COOLDOWN_MIN = 1.5
	private constant integer MANACOST = 0
	private constant real CAST = 0.2
	private constant real RANGE = 600.0
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_HPREGEN
	private constant integer STAT_BONUS2 = CONFIG_STAT_LUCK
endglobals
//! endtextmacro
//! textmacro abilityDataHeader2090
globals
	private constant integer ID = '2090'
	private constant string NAME = "돌진 v2"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_storm_ui_icon_varian_charge.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = CONFIG_ABILITY_TAG_BASH
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 9.0
	private constant real COOLDOWN_MIN = 2.0
	private constant integer MANACOST = 25
	private constant real BACKSWING = 0.15
	private constant real RADIUS2 = 75.0
	private constant real CHARGE_DURATION = 0.5
	private constant real CHARGE_SPEED = 1200.0
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.07
	private constant real DAMAGE_AMPLIFIER1 = 0.1175
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_MAXHP
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_AOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
	private constant integer STAT_BONUS1 = CONFIG_STAT_MAXHP
	private constant integer STAT_BONUS2 = CONFIG_STAT_ARMOR_PENET
endglobals
//! endtextmacro
//! textmacro abilityDataHeader20a0
globals
	private constant integer ID = '20a0'
	private constant string NAME = "돼지 조련술"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNPig.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_SUMMON
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real DURATION = 5.0
	private constant integer UNIT_ID1 = 'SP03'
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = true
	private constant real WEAPON_RANGE = 650.0
	private constant real WEAPON_DELAY = 2.0
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_ATTACK_SPEED
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_HPREGEN
	private constant real DATA_REAL1 = 0.2
	private constant real DATA_REAL2 = 0.02
	private constant real DATA_REAL3 = 0.5
	private constant real DATA_REAL4 = 0.25
	private constant real DATA_REAL5 = 2.5
endglobals
//! endtextmacro
//! textmacro abilityDataHeader20b0
globals
	private constant integer ID = '20b0'
	private constant string NAME = "퇴마의 장막"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNSpellBreakerMagicDefend.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_IMMEDIATE
	private constant integer TAG1 = -1
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 9.0
	private constant real COOLDOWN_MIN = 2.0
	private constant integer MANACOST = 30
	private constant real DURATION = 9.0
	private constant integer BUFF_ID1 = '20b0'
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_RESISTANCE
	private constant integer STAT_BONUS2 = CONFIG_STAT_ATTACK
endglobals
//! endtextmacro
//! textmacro abilityDataHeader20c0
globals
	private constant integer ID = '20c0'
	private constant string NAME = "맹독 칼날"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNEnvenomedSpear.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_SLASH
	private constant integer TAG2 = CONFIG_ABILITY_TAG_POISON
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real DURATION = 5.0
	private constant integer BUFF_ID1 = '20c0'
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = false
	private constant real WEAPON_RANGE = 125.0
	private constant real WEAPON_DELAY = 1.5
	private constant real DAMAGE_PER_LEVEL = 0.07
	private constant real DAMAGE_AMPLIFIER1 = 1.05
	private constant real DAMAGE_AMPLIFIER2 = 0.1
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_ACCURACY
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ACCURACY
endglobals
//! endtextmacro
//! textmacro abilityDataHeader20d0
globals
	private constant integer ID = '20d0'
	private constant string NAME = "회심의 일격"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Paladin_SwiftRetribution.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_IMMEDIATE
	private constant integer TAG1 = -1
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 5.0
	private constant real COOLDOWN_MIN = 1.75
	private constant integer MANACOST = 15
	private constant real DURATION = 1.5
	private constant integer BUFF_ID1 = '20d0'
	private constant integer BUFF_ID2 = '20d1'
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_ACCURACY
	private constant integer STAT_BONUS2 = CONFIG_STAT_ARMOR_PENET
endglobals
//! endtextmacro
//! textmacro abilityDataHeader20e0
globals
	private constant integer ID = '20e0'
	private constant string NAME = "도약강타"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_storm_ui_icon_sonya_leap.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = CONFIG_ABILITY_TAG_BASH
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 8.0
	private constant real COOLDOWN_MIN = 4.0
	private constant integer MANACOST = 25
	private constant real DURATION = 0.5
	private constant real RANGE = 550.0
	private constant real RADIUS3 = 175.0
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.07
	private constant real DAMAGE_AMPLIFIER1 = 1.8
	private constant real DAMAGE_AMPLIFIER2 = 0.03
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_MAXHP
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_AOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_MAXHP
endglobals
//! endtextmacro
//! textmacro abilityDataHeader20f0
globals
	private constant integer ID = '20f0'
	private constant string NAME = "악령의 칼날"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Shadow_RitualOfSacrifice.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_SLASH
	private constant integer TAG2 = CONFIG_ABILITY_TAG_DARK
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real DURATION = 3.0
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = false
	private constant real WEAPON_RANGE = 125.0
	private constant real WEAPON_DELAY = 1.0
	private constant real DAMAGE_PER_LEVEL = 0.07
	private constant real DAMAGE_AMPLIFIER1 = 0.7
	private constant real DAMAGE_AMPLIFIER2 = 0.3
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_ACCURACY
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ACCURACY
	private constant real DATA_REAL1 = 0.25
	private constant real DATA_REAL2 = 200.0
	private constant real DATA_REAL3 = 0.33
endglobals
//! endtextmacro
//! textmacro abilityDataHeader20g0
globals
	private constant integer ID = '20g0'
	private constant string NAME = "광폭화"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNBerserkForTrolls.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_IMMEDIATE
	private constant integer TAG1 = -1
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 10.0
	private constant real COOLDOWN_MIN = 2.0
	private constant integer MANACOST = 35
	private constant real DURATION = 4.0
	private constant integer BUFF_ID1 = '20g0'
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ARMOR_PENET
endglobals
//! endtextmacro
//! textmacro abilityDataHeader20h0
globals
	private constant integer ID = '20h0'
	private constant string NAME = "자연의 결속"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNManaFlare.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_UNIT
	private constant integer TAG1 = CONFIG_ABILITY_TAG_NATURE
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 1.5
	private constant real COOLDOWN_MIN = 1.5
	private constant integer MANACOST = 10
	private constant real VELO = 1080.0
	private constant integer BUFF_ID1 = '20h0'
	private constant integer BUFF_ID2 = '20h1'
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_MAXHP
	private constant integer STAT_BONUS2 = CONFIG_STAT_MAXMP
endglobals
//! endtextmacro
//! textmacro abilityDataHeader20i0
globals
	private constant integer ID = '20i0'
	private constant string NAME = "정찰탑 건설"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNHumanWatchTower.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = CONFIG_ABILITY_TAG_SERVANT
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 4.0
	private constant real COOLDOWN_MIN = 4.0
	private constant integer MANACOST = 30
	private constant real CAST = 4.0
	private constant real DELAY = 0.75
	private constant real RADIUS3 = 100.0
	private constant integer UNIT_ID1 = 'SP05'
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_RODONG
	private constant integer STAT_BONUS2 = CONFIG_STAT_HPREGEN
	private constant real DATA_REAL1 = 0.25
endglobals
//! endtextmacro
//! textmacro abilityDataHeader20j0
globals
	private constant integer ID = '20j0'
	private constant string NAME = "늑대의 상"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNSpiritWolf.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_IMMEDIATE
	private constant integer TAG1 = CONFIG_ABILITY_TAG_TRANSFORM
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 1.5
	private constant real COOLDOWN_MIN = 1.5
	private constant integer MANACOST = 20
	private constant integer BUFF_ID1 = '20j0'
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_MAGICPOWER
	private constant integer STAT_BONUS2 = CONFIG_STAT_ACCURACY
endglobals
//! endtextmacro
//! textmacro abilityDataHeader20k0
globals
	private constant integer ID = '20k0'
	private constant string NAME = "고대 코끼리의 상"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNBlackMammoth.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_IMMEDIATE
	private constant integer TAG1 = CONFIG_ABILITY_TAG_TRANSFORM
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 1.5
	private constant real COOLDOWN_MIN = 1.5
	private constant integer MANACOST = 20
	private constant integer BUFF_ID1 = '20k0'
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_MAXHP
	private constant integer STAT_BONUS2 = CONFIG_STAT_HPREGEN
endglobals
//! endtextmacro
//! textmacro abilityDataHeader20l0
globals
	private constant integer ID = '20l0'
	private constant string NAME = "달빛 글레이브"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNUpgradeMoonGlaive.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_THROW
	private constant integer TAG2 = CONFIG_ABILITY_TAG_NORMAL
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real RANGE = 450.0
	private constant real BACKSWING = 0.25
	private constant real STARTAT = 25.0
	private constant real VELO = 1150.0
	private constant integer TARGET_MAX = 3
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = true
	private constant real WEAPON_RANGE = 530.0
	private constant real WEAPON_DELAY = 1.5
	private constant real DAMAGE_PRIMARY = 0.75
	private constant real DAMAGE_SECONDARY = 0.4
	private constant real DAMAGE_PER_LEVEL = 0.07
	private constant real DAMAGE_AMPLIFIER1 = 1.1
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ACCURACY
endglobals
//! endtextmacro
//! textmacro abilityDataHeader20m0
globals
	private constant integer ID = '20m0'
	private constant string NAME = "투창"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNSteelRanged.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_THROW
	private constant integer TAG2 = CONFIG_ABILITY_TAG_PIERCE
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real DELAY = 0.5
	private constant real BACKSWING = 0.5
	private constant real STARTAT = 25.0
	private constant real VELO = 1200.0
	private constant real CHARGE_DURATION = 0.25
	private constant real CHARGE_SPEED = 0.5
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = true
	private constant real WEAPON_RANGE = 525.0
	private constant real WEAPON_DELAY = 1.5
	private constant real DAMAGE_PER_LEVEL = 0.07
	private constant real DAMAGE_AMPLIFIER1 = 1.25
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ARMOR_PENET
endglobals
//! endtextmacro
//! textmacro abilityDataHeader20n0
globals
	private constant integer ID = '20n0'
	private constant string NAME = "보강"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAdvStruct.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_IMMEDIATE
	private constant integer TAG1 = -1
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 10.0
	private constant real COOLDOWN_MIN = 5.0
	private constant integer MANACOST = 17
	private constant real DURATION = 3.5
	private constant integer BUFF_ID1 = '20n0'
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_DEFENSE
	private constant integer STAT_BONUS2 = CONFIG_STAT_RESISTANCE
endglobals
//! endtextmacro
//! textmacro abilityDataHeader20o0
globals
	private constant integer ID = '20o0'
	private constant string NAME = "광란"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNUnholyFrenzy.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_IMMEDIATE
	private constant integer TAG1 = -1
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 5.0
	private constant real COOLDOWN_MIN = 5.0
	private constant integer MANACOST = 30
	private constant real DURATION = 3.0
	private constant integer BUFF_ID1 = '20o0'
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_MAXHP
endglobals
//! endtextmacro
//! textmacro abilityDataHeader20p0
globals
	private constant integer ID = '20p0'
	private constant string NAME = "산성 거미줄"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Web0.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = CONFIG_ABILITY_TAG_BIO
	private constant integer TAG2 = CONFIG_ABILITY_TAG_POISON
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 10.0
	private constant real COOLDOWN_MIN = 5.0
	private constant integer MANACOST = 20
	private constant real DELAY = 0.2
	private constant real DURATION = 5.0
	private constant real RANGE = 800.0
	private constant real BACKSWING = 0.15
	private constant real RADIUS2 = 55.0
	private constant real STARTAT = 28.5
	private constant real VELO = 1100.0
	private constant integer BUFF_ID1 = '20p0'
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.07
	private constant real DAMAGE_AMPLIFIER1 = 0.75
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ACCURACY
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_ACCURACY
	private constant integer STAT_BONUS2 = CONFIG_STAT_ATTACK
endglobals
//! endtextmacro
//! textmacro abilityDataHeader20q0
globals
	private constant integer ID = '20q0'
	private constant string NAME = "그림자 화살"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Shadow_PainSpike.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_DARK
	private constant integer TAG2 = CONFIG_ABILITY_TAG_SUMMON
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real DURATION = 3.0
	private constant real BACKSWING = 0.25
	private constant real STARTAT = 25.0
	private constant real VELO = 1050.0
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = true
	private constant real WEAPON_RANGE = 545.0
	private constant real WEAPON_DELAY = 1.5
	private constant real DAMAGE_PER_LEVEL = 0.07
	private constant real DAMAGE_AMPLIFIER1 = 1.25
	private constant real DAMAGE_AMPLIFIER2 = 0.3
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_ACCURACY
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_ACCURACY
	private constant integer STAT_BONUS2 = CONFIG_STAT_ATTACK
	private constant real DATA_REAL1 = 0.25
	private constant real DATA_REAL2 = 166.0
	private constant real DATA_REAL3 = 0.33
endglobals
//! endtextmacro
//! textmacro abilityDataHeader20r0
globals
	private constant integer ID = '20r0'
	private constant string NAME = "해골 전사 소환"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNSkeletonWarrior.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = CONFIG_ABILITY_TAG_SUMMON
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 10.0
	private constant real COOLDOWN_MIN = 3.0
	private constant integer MANACOST = 50
	private constant real DELAY = 0.2
	private constant real DURATION = 15.0
	private constant real RANGE = 800.0
	private constant real BACKSWING = 0.15
	private constant real RADIUS2 = 65.0
	private constant real STARTAT = 32.5
	private constant integer COUNT = 1
	private constant integer UNIT_ID1 = 'SP04'
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.07
	private constant real DAMAGE_AMPLIFIER1 = 0.2
	private constant real DAMAGE_AMPLIFIER2 = 0.2
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_MAGICPOWER
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_MAXHP
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_MAXHP
	private constant integer STAT_BONUS2 = CONFIG_STAT_MAGICPOWER
	private constant real DATA_REAL1 = 0.66
endglobals
//! endtextmacro
//! textmacro abilityDataHeader20s0
globals
	private constant integer ID = '20s0'
	private constant string NAME = "부패가스"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNPlagueCloud.blp"
	private constant integer TIER = 2
	private constant integer COST = 2
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_PASSIVE
	private constant integer TAG1 = CONFIG_ABILITY_TAG_BIO
	private constant integer TAG2 = CONFIG_ABILITY_TAG_POISON
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real DURATION = 1.5
	private constant real RADIUS3 = 200.0
	private constant real INTERVAL = 0.5
	private constant integer COUNT = 8
	private constant integer BUFF_ID1 = '20s0'
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.07
	private constant real DAMAGE_AMPLIFIER1 = 1.25
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_HPREGEN
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_MAGICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_ETC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_PERIODIC
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_AOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_NONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_HPREGEN
	private constant integer STAT_BONUS2 = CONFIG_STAT_RESISTANCE
endglobals
//! endtextmacro
//! textmacro abilityDataHeader3000
globals
	private constant integer ID = '3000'
	private constant string NAME = "기관총 난사"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNFlakCannons.blp"
	private constant integer TIER = 3
	private constant integer COST = 3
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = CONFIG_ABILITY_TAG_FIREARM
	private constant integer TAG2 = CONFIG_ABILITY_TAG_PIERCE
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 8.0
	private constant real COOLDOWN_MIN = 1.5
	private constant integer MANACOST = 26
	private constant real RANGE = 750.0
	private constant real BACKSWING = 0.15
	private constant real RADIUS2 = 65.0
	private constant real STARTAT = 32.5
	private constant real VELO = 1875.0
	private constant real INTERVAL = 0.125
	private constant integer COUNT = 10
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.08
	private constant real DAMAGE_AMPLIFIER1 = 0.45
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ACCURACY
endglobals
//! endtextmacro
//! textmacro abilityDataHeader3010
globals
	private constant integer ID = '3010'
	private constant string NAME = "감속"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNSlow.blp"
	private constant integer TIER = 3
	private constant integer COST = 3
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = -1
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 10.0
	private constant real COOLDOWN_MIN = 4.0
	private constant integer MANACOST = 30
	private constant real CAST = 0.25
	private constant real DURATION = 4.5
	private constant real RANGE = 800.0
	private constant real BACKSWING = 0.15
	private constant real RADIUS3 = 200.0
	private constant real INTERVAL = 0.5
	private constant integer COUNT = 10
	private constant integer BUFF_ID1 = '3010'
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.08
	private constant real DAMAGE_AMPLIFIER1 = 0.1
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_MAGICPOWER
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_MAGICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_AOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_MAGICPOWER
	private constant integer STAT_BONUS2 = CONFIG_STAT_MPREGEN
	private constant real DATA_REAL1 = 0.2
	private constant integer DATA_INTEGER1 = 15
endglobals
//! endtextmacro
//! textmacro abilityDataHeader3020
globals
	private constant integer ID = '3020'
	private constant string NAME = "착취의 보옥"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNOrbOfDeath.blp"
	private constant integer TIER = 3
	private constant integer COST = 3
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_DARK
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real RANGE = 800.0
	private constant real INTERVAL = 0.25
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = true
	private constant real WEAPON_RANGE = 500.0
	private constant real WEAPON_DELAY = 0.25
	private constant real DAMAGE_PER_LEVEL = 0.08
	private constant real DAMAGE_AMPLIFIER1 = 0.2
	private constant real DAMAGE_AMPLIFIER2 = 0.75
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_MAGICPOWER
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_HPREGEN
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_MAGICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_PERIODIC
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_INNER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_MAGICPOWER
	private constant integer STAT_BONUS2 = CONFIG_STAT_HPREGEN
	private constant real DATA_REAL1 = 0.4
	private constant real DATA_REAL2 = 0.5
	private constant integer DATA_INTEGER1 = 10
	private constant integer DATA_INTEGER2 = 3
endglobals
//! endtextmacro
//! textmacro abilityDataHeader3030
globals
	private constant integer ID = '3030'
	private constant string NAME = "전격 구체"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNOrbOfLightning.blp"
	private constant integer TIER = 3
	private constant integer COST = 3
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_LIGHTNING
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real DURATION = 2.0
	private constant real BACKSWING = 0.25
	private constant real STARTAT = 25.0
	private constant real VELO = 1250.0
	private constant integer BUFF_ID1 = '3030'
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = true
	private constant real WEAPON_RANGE = 575.0
	private constant real WEAPON_DELAY = 1.4
	private constant real DAMAGE_PRIMARY = 0.2
	private constant real DAMAGE_SECONDARY = 1
	private constant real DAMAGE_PER_LEVEL = 0.08
	private constant real DAMAGE_AMPLIFIER1 = 1.3
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_MAGICPOWER
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_MAGICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_MAGICPOWER
	private constant integer STAT_BONUS2 = CONFIG_STAT_ACCURACY
	private constant real DATA_REAL1 = 400.0
endglobals
//! endtextmacro
//! textmacro abilityDataHeader3040
globals
	private constant integer ID = '3040'
	private constant string NAME = "바람 칼날"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_WindBlade0.blp"
	private constant integer TIER = 3
	private constant integer COST = 3
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_SLASH
	private constant integer TAG2 = CONFIG_ABILITY_TAG_WIND
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real BACKSWING = 0.25
	private constant real STARTAT = 25.0
	private constant real VELO = 1600.0
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = true
	private constant real WEAPON_RANGE = 755.0
	private constant real WEAPON_DELAY = 1.5
	private constant real DAMAGE_PER_LEVEL = 0.08
	private constant real DAMAGE_AMPLIFIER1 = 1.57
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ACCURACY
	private constant real DATA_REAL1 = 600.0
	private constant real DATA_REAL2 = 575.0
	private constant real DATA_REAL3 = 2000.0
endglobals
//! endtextmacro
//! textmacro abilityDataHeader3050
globals
	private constant integer ID = '3050'
	private constant string NAME = "강철 군마"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNRiderlessHorse.blp"
	private constant integer TIER = 3
	private constant integer COST = 3
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = CONFIG_ABILITY_TAG_SERVANT
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant integer UNIT_ID1 = 'SP00'
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_MAXHP
	private constant integer STAT_BONUS2 = CONFIG_STAT_EVASION
	private constant integer DATA_INTEGER1 = 110
endglobals
//! endtextmacro
//! textmacro abilityDataHeader3060
globals
	private constant integer ID = '3060'
	private constant string NAME = "갈고리 던지기"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_storm_ui_icon_stitches_hook.blp"
	private constant integer TIER = 3
	private constant integer COST = 3
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = CONFIG_ABILITY_TAG_NORMAL
	private constant integer TAG2 = CONFIG_ABILITY_TAG_THROW
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 10.0
	private constant real COOLDOWN_MIN = 3.3
	private constant integer MANACOST = 31
	private constant real RANGE = 1000.0
	private constant real RADIUS2 = 65.0
	private constant real STARTAT = 25.0
	private constant real VELO = 1350.0
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.08
	private constant real DAMAGE_AMPLIFIER1 = 2.85
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ARMOR_PENET
	private constant real DATA_REAL1 = 0.2
	private constant real DATA_REAL2 = 0.5
	private constant real DATA_REAL3 = 155.0
endglobals
//! endtextmacro
//! textmacro abilityDataHeader3070
globals
	private constant integer ID = '3070'
	private constant string NAME = "용암채찍"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_LavaSwip.blp"
	private constant integer TIER = 3
	private constant integer COST = 3
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_WEAPON
	private constant integer TAG1 = CONFIG_ABILITY_TAG_FIRE
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant real RANGE = 300.0
	private constant real BACKSWING = 0.25
	private constant real RADIUS1 = 65.0
	private constant real STARTAT = 65.0
	private constant real WIDTH = 150.0
	private constant integer COUNT = 3
	private constant boolean IS_WEAPON = true
	private constant boolean WEAPON_IS_RANGED = false
	private constant real WEAPON_RANGE = 250.0
	private constant real WEAPON_DELAY = 1.5
	private constant real DAMAGE_SECONDARY = 1.5
	private constant real DAMAGE_PER_LEVEL = 0.08
	private constant real DAMAGE_AMPLIFIER1 = 0.65
	private constant real DAMAGE_AMPLIFIER2 = 0.55
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_MAGICPOWER
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_MAGICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_TARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_AOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_MAGICPOWER
endglobals
//! endtextmacro
//! textmacro abilityDataHeader3080
globals
	private constant integer ID = '3080'
	private constant string NAME = "순보 v2"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_SavageStrike.blp"
	private constant integer TIER = 3
	private constant integer COST = 3
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = CONFIG_ABILITY_TAG_SLASH
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 6.0
	private constant real COOLDOWN_MIN = 0.5
	private constant integer MANACOST = 45
	private constant real DURATION = 4.0
	private constant real RANGE = 500.0
	private constant real RADIUS3 = 65.0
	private constant integer BUFF_ID1 = '3080'
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.08
	private constant real DAMAGE_AMPLIFIER1 = 1.75
	private constant real DAMAGE_AMPLIFIER2 = 0.75
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant integer DAMAGE_STAT2 = CONFIG_STAT_ACCURACY
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_AOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_ACCURACY
	private constant real DATA_REAL1 = 26.0
endglobals
//! endtextmacro
//! textmacro abilityDataHeader4000
globals
	private constant integer ID = '4000'
	private constant string NAME = "미사일 컨테이너"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNClusterRockets.blp"
	private constant integer TIER = 4
	private constant integer COST = 4
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = CONFIG_ABILITY_TAG_FIREARM
	private constant integer TAG2 = CONFIG_ABILITY_TAG_EXPLOSION
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 12.0
	private constant real COOLDOWN_MIN = 2.0
	private constant integer MANACOST = 50
	private constant real DELAY = 0.2
	private constant real DURATION = 3.0
	private constant real RANGE = 1200.0
	private constant real BACKSWING = 0.15
	private constant real RADIUS2 = 65.0
	private constant real RADIUS3 = 500.0
	private constant real STARTAT = 32.5
	private constant real VELO = 400.0
	private constant real INTERVAL = 0.125
	private constant integer COUNT = 20
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_SECONDARY = 0.3
	private constant real DAMAGE_PER_LEVEL = 0.09
	private constant real DAMAGE_AMPLIFIER1 = 1.25
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_SPELL_BOOST
endglobals
//! endtextmacro
//! textmacro abilityDataHeader4010
globals
	private constant integer ID = '4010'
	private constant string NAME = "불사조"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_storm_ui_icon_kaelthas_phoenix.blp"
	private constant integer TIER = 4
	private constant integer COST = 4
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_DRAG_TO_USE
	private constant integer TAG1 = CONFIG_ABILITY_TAG_FIRE
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 9.0
	private constant real COOLDOWN_MIN = 3.0
	private constant integer MANACOST = 55
	private constant real CAST = 0.25
	private constant real DELAY = 0.5
	private constant real RANGE = 800.0
	private constant real RANGE_SECONDARY = 1500.0
	private constant real RADIUS3 = 200.0
	private constant real VELO = 1500.0
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.09
	private constant real DAMAGE_AMPLIFIER1 = 3.75
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_MAGICPOWER
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_MAGICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_AOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_MAGICPOWER
	private constant integer STAT_BONUS2 = CONFIG_STAT_MAXMP
endglobals
//! endtextmacro
//! textmacro abilityDataHeader5000
globals
	private constant integer ID = '5000'
	private constant string NAME = "화룡의 숨결"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_storm_ui_icon_deathwing_molten_flame.blp"
	private constant integer TIER = 5
	private constant integer COST = 5
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = CONFIG_ABILITY_TAG_FIRE
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 10.0
	private constant real COOLDOWN_MIN = 5.0
	private constant integer MANACOST = 85
	private constant real CAST = 0.75
	private constant real RANGE = 800.0
	private constant real RADIUS3 = 250.0
	private constant real INTERVAL = 0.2
	private constant integer COUNT = 15
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.1
	private constant real DAMAGE_AMPLIFIER1 = 0.67
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_MAGICPOWER
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_MAGICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_AOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_MAGICPOWER
	private constant integer STAT_BONUS2 = CONFIG_STAT_MAGIC_PENET
	private constant real DATA_REAL1 = 0.5
endglobals
//! endtextmacro
//! textmacro abilityDataHeader5010
globals
	private constant integer ID = '5010'
	private constant string NAME = "종막: 이스보셋"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Isubosete.blp"
	private constant integer TIER = 5
	private constant integer COST = 5
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_TARGET_LOCATION
	private constant integer TAG1 = CONFIG_ABILITY_TAG_FIREARM
	private constant integer TAG2 = CONFIG_ABILITY_TAG_PIERCE
	private constant integer TAG3 = CONFIG_ABILITY_TAG_DARK
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 125
	private constant real CAST = 0.8
	private constant real RANGE = 1250.0
	private constant real BACKSWING = 0.2
	private constant real RADIUS2 = 50.0
	private constant real STARTAT = 35.0
	private constant real VELO = 2000.0
	private constant real INTERVAL = 0.125
	private constant real WIDTH = 30.0
	private constant integer COUNT = 4
	private constant boolean IS_WEAPON = false
	private constant real DAMAGE_PER_LEVEL = 0.1
	private constant real DAMAGE_AMPLIFIER1 = 0.55
	private constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	private constant boolean USE_DAMAGE_FLAG = true
	private constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	private constant integer ATTACK_TYPE = CONFIG_DAMAGE_SPELL
	private constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	private constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	private constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	private constant integer AOE_TYPE = CONFIG_DAMAGE_AOE
	private constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	private constant integer RANGE_TYPE = CONFIG_DAMAGE_RANGED
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_MAXMP
	private constant integer DATA_INTEGER1 = 20
endglobals
//! endtextmacro
//! textmacro abilityDataHeaderC000
globals
	private constant integer ID = 'C000'
	private constant string NAME = "새내기"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNMurgalSlave.blp"
	private constant integer TIER = 0
	private constant integer COST = 0
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_PASSIVE
	private constant integer TAG1 = CONFIG_ABILITY_TAG_CHINGHO
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_LUCK
	private constant integer STAT_BONUS2 = CONFIG_STAT_HPREGEN
endglobals
//! endtextmacro
//! textmacro abilityDataHeaderC001
globals
	private constant integer ID = 'C001'
	private constant string NAME = "동인천 역가드"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNSacrifice.blp"
	private constant integer TIER = 0
	private constant integer COST = 0
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_PASSIVE
	private constant integer TAG1 = CONFIG_ABILITY_TAG_CHINGHO
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_ACCURACY
	private constant integer STAT_BONUS2 = CONFIG_STAT_EVASION
endglobals
//! endtextmacro
//! textmacro abilityDataHeaderC002
globals
	private constant integer ID = 'C002'
	private constant string NAME = "가짜광기"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNBerserkForTrolls.blp"
	private constant integer TIER = 0
	private constant integer COST = 0
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_PASSIVE
	private constant integer TAG1 = CONFIG_ABILITY_TAG_CHINGHO
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_ATTACK
	private constant integer STAT_BONUS2 = CONFIG_STAT_EVASION
endglobals
//! endtextmacro
//! textmacro abilityDataHeaderC003
globals
	private constant integer ID = 'C003'
	private constant string NAME = "꿈나무"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAcorn.blp"
	private constant integer TIER = 0
	private constant integer COST = 0
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_PASSIVE
	private constant integer TAG1 = CONFIG_ABILITY_TAG_CHINGHO
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_MAXHP
	private constant integer STAT_BONUS2 = CONFIG_STAT_MAXMP
endglobals
//! endtextmacro
//! textmacro abilityDataHeaderC004
globals
	private constant integer ID = 'C004'
	private constant string NAME = "아이돌"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNSorceress.blp"
	private constant integer TIER = 0
	private constant integer COST = 0
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_PASSIVE
	private constant integer TAG1 = CONFIG_ABILITY_TAG_CHINGHO
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_SPELL_BOOST
	private constant integer STAT_BONUS2 = CONFIG_STAT_MPREGEN
endglobals
//! endtextmacro
//! textmacro abilityDataHeaderC005
globals
	private constant integer ID = 'C005'
	private constant string NAME = "정의의 사도"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNRacoon.blp"
	private constant integer TIER = 0
	private constant integer COST = 0
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_PASSIVE
	private constant integer TAG1 = CONFIG_ABILITY_TAG_CHINGHO
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_DEFENSE
	private constant integer STAT_BONUS2 = CONFIG_STAT_RESISTANCE
endglobals
//! endtextmacro
//! textmacro abilityDataHeaderC006
globals
	private constant integer ID = 'C006'
	private constant string NAME = "치유계"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNFountainOfLife.blp"
	private constant integer TIER = 0
	private constant integer COST = 0
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_PASSIVE
	private constant integer TAG1 = CONFIG_ABILITY_TAG_CHINGHO
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_HPREGEN
	private constant integer STAT_BONUS2 = CONFIG_STAT_MAGICPOWER
endglobals
//! endtextmacro
//! textmacro abilityDataHeaderC007
globals
	private constant integer ID = 'C007'
	private constant string NAME = "패셔니스타"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNRobeOfTheMagi.blp"
	private constant integer TIER = 0
	private constant integer COST = 0
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_PASSIVE
	private constant integer TAG1 = CONFIG_ABILITY_TAG_CHINGHO
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_EVASION
	private constant integer STAT_BONUS2 = CONFIG_STAT_MAXHP
endglobals
//! endtextmacro
//! textmacro abilityDataHeaderC008
globals
	private constant integer ID = 'C008'
	private constant string NAME = "밤의 일족"
	private constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNElunesBlessing.blp"
	private constant integer TIER = 0
	private constant integer COST = 0
	private constant integer CAST_TYPE = CONFIG_CAST_TYPE_PASSIVE
	private constant integer TAG1 = CONFIG_ABILITY_TAG_CHINGHO
	private constant integer TAG2 = -1
	private constant integer TAG3 = -1
	private constant integer TAG4 = -1
	private constant real COOLDOWN_MAX = 0.0
	private constant real COOLDOWN_MIN = 0.0
	private constant integer MANACOST = 0
	private constant boolean IS_WEAPON = false
	private constant boolean USE_DAMAGE_FLAG = false
	private constant integer STAT_BONUS1 = CONFIG_STAT_MAGICPOWER
	private constant integer STAT_BONUS2 = CONFIG_STAT_RESISTANCE
endglobals
//! endtextmacro
