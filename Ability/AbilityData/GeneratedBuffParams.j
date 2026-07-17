//! textmacro buffDataHeader10d0
globals
	public constant integer ID = '10d0'
	public constant string NAME = "사기의 외침"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Shout1.blp"
	public constant integer INDIVISUAL = 2
	public constant integer POSITIVE = 1
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant real DAMAGE_PER_LEVEL = 0.06
	public constant real DAMAGE_AMPLIFIER1 = 0.5
	public constant integer DAMAGE_STAT1 = CONFIG_STAT_HPREGEN
	public constant integer DAMAGE_STAT2 = CONFIG_STAT_ATTACK
	public constant boolean USE_DAMAGE_FLAG = false
	public constant real DATA_REAL1 = 0.15
	public constant real DATA_REAL2 = 0.01
endglobals
//! endtextmacro
//! textmacro buffDataHeader10g0
globals
	public constant integer ID = '10g0'
	public constant string NAME = "그물 던지기"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNEnsnare.blp"
	public constant integer INDIVISUAL = 0
	public constant integer POSITIVE = 0
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant real DAMAGE_PER_LEVEL = 0.06
	public constant real DAMAGE_AMPLIFIER1 = 0.2
	public constant integer DAMAGE_STAT1 = CONFIG_STAT_ACCURACY
	public constant boolean USE_DAMAGE_FLAG = false
	public constant real DATA_REAL1 = 0.33
endglobals
//! endtextmacro
//! textmacro buffDataHeader10v0
globals
	public constant integer ID = '10v0'
	public constant string NAME = "끈적 거미"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_MonsterSpiderCarapace_01.blp"
	public constant integer INDIVISUAL = 1
	public constant integer POSITIVE = 0
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant real DAMAGE_PER_LEVEL = 0.06
	public constant real DAMAGE_AMPLIFIER1 = 0.03
	public constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	public constant boolean USE_DAMAGE_FLAG = false
	public constant real DATA_REAL1 = 5.0
endglobals
//! endtextmacro
//! textmacro buffDataHeader10y0
globals
	public constant integer ID = '10y0'
	public constant string NAME = "오염된 식칼"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_storm_ui_icon_stitches_slam.blp"
	public constant integer INDIVISUAL = 1
	public constant integer POSITIVE = 0
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant real DAMAGE_PER_LEVEL = 0.06
	public constant real DAMAGE_AMPLIFIER1 = 0.025
	public constant integer DAMAGE_STAT1 = CONFIG_STAT_MAXHP
	public constant boolean USE_DAMAGE_FLAG = false
endglobals
//! endtextmacro
//! textmacro buffDataHeader10z0
globals
	public constant integer ID = '10z0'
	public constant string NAME = "맑은 물"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Water0.blp"
	public constant integer INDIVISUAL = 2
	public constant integer POSITIVE = 1
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant real DAMAGE_BASE = 20.0
	public constant real DAMAGE_PER_LEVEL = 0.06
	public constant boolean USE_DAMAGE_FLAG = false
	public constant integer DATA_INTEGER1 = 50
endglobals
//! endtextmacro
//! textmacro buffDataHeader10A0
globals
	public constant integer ID = '10A0'
	public constant string NAME = "빵"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Pan0.blp"
	public constant integer INDIVISUAL = 2
	public constant integer POSITIVE = 1
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant real DAMAGE_BASE = 50.0
	public constant real DAMAGE_PER_LEVEL = 0.06
	public constant boolean USE_DAMAGE_FLAG = false
	public constant integer DATA_INTEGER1 = 50
endglobals
//! endtextmacro
//! textmacro buffDataHeader2000
globals
	public constant integer ID = '2000'
	public constant string NAME = "전투자극제"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_terran-stimpack-color.blp"
	public constant integer INDIVISUAL = 0
	public constant integer POSITIVE = 1
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant real DAMAGE_PER_LEVEL = 0.07
	public constant real DAMAGE_AMPLIFIER1 = 0.175
	public constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	public constant boolean USE_DAMAGE_FLAG = false
	public constant real DATA_REAL1 = 0.3
	public constant real DATA_REAL2 = 0.1
endglobals
//! endtextmacro
//! textmacro buffDataHeader2070
globals
	public constant integer ID = '2070'
	public constant string NAME = "불붙은 시미터"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Gangplank_Passive.blp"
	public constant integer INDIVISUAL = 1
	public constant integer POSITIVE = 0
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = true
	public constant integer DAMAGE_ID = '2071'
	public constant integer TAG1 = CONFIG_ABILITY_TAG_FIRE
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant real INTERVAL = 0.5
	public constant real DAMAGE_PER_LEVEL = 0.07
	public constant real DAMAGE_AMPLIFIER1 = 0.85
	public constant integer DAMAGE_STAT1 = CONFIG_STAT_HPREGEN
	public constant boolean USE_DAMAGE_FLAG = true
	public constant integer DAMAGE_TYPE = CONFIG_DAMAGE_MAGICAL
	public constant integer ATTACK_TYPE = CONFIG_DAMAGE_ETC
	public constant integer INTERVAL_TYPE = CONFIG_DAMAGE_PERIODIC
	public constant integer VECTOR_TYPE = CONFIG_DAMAGE_INNER
	public constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	public constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	public constant integer ONHIT_TYPE = CONFIG_DAMAGE_NONHIT
	public constant integer RANGE_TYPE = CONFIG_DAMAGE_UNDEFINED
	public constant real DATA_REAL1 = 1.0
endglobals
//! endtextmacro
//! textmacro buffDataHeader20b0
globals
	public constant integer ID = '20b0'
	public constant string NAME = "퇴마의 장막"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNSpellBreakerMagicDefend.blp"
	public constant integer INDIVISUAL = 0
	public constant integer POSITIVE = 1
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant real DAMAGE_PER_LEVEL = 0.07
	public constant real DAMAGE_AMPLIFIER1 = 1.65
	public constant real DAMAGE_AMPLIFIER2 = 0.45
	public constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	public constant boolean USE_DAMAGE_FLAG = false
	public constant real DATA_REAL1 = 0.2
endglobals
//! endtextmacro
//! textmacro buffDataHeader20c0
globals
	public constant integer ID = '20c0'
	public constant string NAME = "맹독 칼날"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNEnvenomedSpear.blp"
	public constant integer INDIVISUAL = 1
	public constant integer POSITIVE = 0
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = true
	public constant integer DAMAGE_ID = '20c1'
	public constant integer TAG1 = CONFIG_ABILITY_TAG_POISON
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant real INTERVAL = 0.5
	public constant real DAMAGE_PER_LEVEL = 0.07
	public constant real DAMAGE_AMPLIFIER1 = 0.2
	public constant integer DAMAGE_STAT1 = CONFIG_STAT_ACCURACY
	public constant boolean USE_DAMAGE_FLAG = true
	public constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	public constant integer ATTACK_TYPE = CONFIG_DAMAGE_ETC
	public constant integer INTERVAL_TYPE = CONFIG_DAMAGE_PERIODIC
	public constant integer VECTOR_TYPE = CONFIG_DAMAGE_INNER
	public constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	public constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	public constant integer ONHIT_TYPE = CONFIG_DAMAGE_NONHIT
	public constant integer RANGE_TYPE = CONFIG_DAMAGE_UNDEFINED
endglobals
//! endtextmacro
//! textmacro buffDataHeader20d0
globals
	public constant integer ID = '20d0'
	public constant string NAME = "회심의 일격(감속)"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Paladin_SwiftRetribution.blp"
	public constant integer INDIVISUAL = 0
	public constant integer POSITIVE = 0
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant real DURATION = 5.0
	public constant boolean USE_DAMAGE_FLAG = false
endglobals
//! endtextmacro
//! textmacro buffDataHeader20d1
globals
	public constant integer ID = '20d1'
	public constant string NAME = "회심의 일격(추뎀)"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Paladin_SwiftRetribution.blp"
	public constant integer INDIVISUAL = 0
	public constant integer POSITIVE = 1
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant real DAMAGE_PER_LEVEL = 0.07
	public constant real DAMAGE_AMPLIFIER1 = 1.25
	public constant integer DAMAGE_STAT1 = CONFIG_STAT_ACCURACY
	public constant boolean USE_DAMAGE_FLAG = false
endglobals
//! endtextmacro
//! textmacro buffDataHeader20g0
globals
	public constant integer ID = '20g0'
	public constant string NAME = "광폭화"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNBerserkForTrolls.blp"
	public constant integer INDIVISUAL = 0
	public constant integer POSITIVE = 1
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant real DAMAGE_PER_LEVEL = 0.07
	public constant real DAMAGE_AMPLIFIER1 = 0.15
	public constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	public constant boolean USE_DAMAGE_FLAG = false
	public constant real DATA_REAL1 = 0.5
endglobals
//! endtextmacro
//! textmacro buffDataHeader20h0
globals
	public constant integer ID = '20h0'
	public constant string NAME = "자연의 결속(캐스터)"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNManaFlare.blp"
	public constant integer INDIVISUAL = 2
	public constant integer POSITIVE = 1
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant boolean USE_DAMAGE_FLAG = false
endglobals
//! endtextmacro
//! textmacro buffDataHeader20h1
globals
	public constant integer ID = '20h1'
	public constant string NAME = "자연의 결속(타겟)"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNManaFlare.blp"
	public constant integer INDIVISUAL = 2
	public constant integer POSITIVE = 1
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant real DAMAGE_PER_LEVEL = 0.07
	public constant real DAMAGE_AMPLIFIER1 = 0.027
	public constant real DAMAGE_AMPLIFIER2 = 0.022
	public constant integer DAMAGE_STAT1 = CONFIG_STAT_MAXHP
	public constant integer DAMAGE_STAT2 = CONFIG_STAT_MAXMP
	public constant boolean USE_DAMAGE_FLAG = false
endglobals
//! endtextmacro
//! textmacro buffDataHeader20j0
globals
	public constant integer ID = '20j0'
	public constant string NAME = "늑대의 상"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNSpiritWolf.blp"
	public constant integer INDIVISUAL = 0
	public constant integer POSITIVE = 1
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant real INTERVAL = 0.5
	public constant real DAMAGE_PER_LEVEL = 0.07
	public constant real DAMAGE_AMPLIFIER1 = 0.225
	public constant integer DAMAGE_STAT1 = CONFIG_STAT_MAGICPOWER
	public constant boolean USE_DAMAGE_FLAG = false
	public constant real DATA_REAL1 = 0.135
	public constant real DATA_REAL2 = 0.015
	public constant integer DATA_INTEGER1 = 60
	public constant integer DATA_INTEGER2 = 3
endglobals
//! endtextmacro
//! textmacro buffDataHeader20k0
globals
	public constant integer ID = '20k0'
	public constant string NAME = "고대코끼리의 상"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNBlackMammoth.blp"
	public constant integer INDIVISUAL = 0
	public constant integer POSITIVE = 1
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant real INTERVAL = 0.5
	public constant real DAMAGE_PER_LEVEL = 0.07
	public constant real DAMAGE_AMPLIFIER1 = 0.0175
	public constant integer DAMAGE_STAT1 = CONFIG_STAT_MAXHP
	public constant boolean USE_DAMAGE_FLAG = false
	public constant real DATA_REAL1 = 0.25
	public constant integer DATA_INTEGER1 = 20
	public constant integer DATA_INTEGER2 = 3
endglobals
//! endtextmacro
//! textmacro buffDataHeader20n0
globals
	public constant integer ID = '20n0'
	public constant string NAME = "보강"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAdvStruct.blp"
	public constant integer INDIVISUAL = 0
	public constant integer POSITIVE = 1
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant boolean USE_DAMAGE_FLAG = false
	public constant real DATA_REAL1 = 0.35
	public constant real DATA_REAL2 = 0.015
endglobals
//! endtextmacro
//! textmacro buffDataHeader20o0
globals
	public constant integer ID = '20o0'
	public constant string NAME = "광란"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNUnholyFrenzy.blp"
	public constant integer INDIVISUAL = 0
	public constant integer POSITIVE = 1
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant real DAMAGE_PER_LEVEL = 0.07
	public constant real DAMAGE_AMPLIFIER1 = 0.05
	public constant integer DAMAGE_STAT1 = CONFIG_STAT_MAXHP
	public constant boolean USE_DAMAGE_FLAG = false
	public constant real DATA_REAL1 = 0.6
	public constant real DATA_REAL2 = 0.05
	public constant real DATA_REAL3 = 0.1
endglobals
//! endtextmacro
//! textmacro buffDataHeader20p0
globals
	public constant integer ID = '20p0'
	public constant string NAME = "산성 거미줄"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_Web0.blp"
	public constant integer INDIVISUAL = 0
	public constant integer POSITIVE = 0
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant real DAMAGE_PER_LEVEL = 0.07
	public constant real DAMAGE_AMPLIFIER1 = 0.4
	public constant integer DAMAGE_STAT1 = CONFIG_STAT_ACCURACY
	public constant boolean USE_DAMAGE_FLAG = false
	public constant real DATA_REAL1 = 0.33
endglobals
//! endtextmacro
//! textmacro buffDataHeader20s0
globals
	public constant integer ID = '20s0'
	public constant string NAME = "부패가스"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNPlagueCloud.blp"
	public constant integer INDIVISUAL = 0
	public constant integer POSITIVE = 0
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant boolean USE_DAMAGE_FLAG = false
	public constant real DATA_REAL1 = 0.75
endglobals
//! endtextmacro
//! textmacro buffDataHeader3010
globals
	public constant integer ID = '3010'
	public constant string NAME = "감속"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNSlow.blp"
	public constant integer INDIVISUAL = 1
	public constant integer POSITIVE = 0
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant real DAMAGE_PER_LEVEL = 0.08
	public constant real DAMAGE_AMPLIFIER1 = 0.02
	public constant integer DAMAGE_STAT1 = CONFIG_STAT_MAGICPOWER
	public constant boolean USE_DAMAGE_FLAG = false
	public constant integer DATA_INTEGER1 = 15
endglobals
//! endtextmacro
//! textmacro buffDataHeader3030
globals
	public constant integer ID = '3030'
	public constant string NAME = "전격구체"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNOrbOfLightning.blp"
	public constant integer INDIVISUAL = 0
	public constant integer POSITIVE = 1
	public constant boolean DISPLAY = false
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant boolean USE_DAMAGE_FLAG = false
	public constant real DATA_REAL1 = 0.4
	public constant real DATA_REAL2 = 0.1
	public constant real DATA_REAL3 = 0.25
endglobals
//! endtextmacro
//! textmacro buffDataHeader3080
globals
	public constant integer ID = '3080'
	public constant string NAME = "순보 v2"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNAbility_SavageStrike.blp"
	public constant integer INDIVISUAL = 2
	public constant integer POSITIVE = 0
	public constant boolean DISPLAY = false
	public constant boolean USE_DAMAGE_TAG = true
	public constant integer DAMAGE_ID = '3081'
	public constant integer TAG1 = CONFIG_ABILITY_TAG_SLASH
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant integer COUNT = 2
	public constant real DAMAGE_PER_LEVEL = 0.08
	public constant real DAMAGE_AMPLIFIER1 = 0.25
	public constant real DAMAGE_AMPLIFIER2 = 0.25
	public constant integer DAMAGE_STAT1 = CONFIG_STAT_ATTACK
	public constant integer DAMAGE_STAT2 = CONFIG_STAT_ACCURACY
	public constant boolean USE_DAMAGE_FLAG = true
	public constant integer DAMAGE_TYPE = CONFIG_DAMAGE_PHYSICAL
	public constant integer ATTACK_TYPE = CONFIG_DAMAGE_BASIC
	public constant integer INTERVAL_TYPE = CONFIG_DAMAGE_SINGLE
	public constant integer VECTOR_TYPE = CONFIG_DAMAGE_OUTTER
	public constant integer TARGET_TYPE = CONFIG_DAMAGE_NONTARGET
	public constant integer AOE_TYPE = CONFIG_DAMAGE_NONAOE
	public constant integer ONHIT_TYPE = CONFIG_DAMAGE_ONHIT
	public constant integer RANGE_TYPE = CONFIG_DAMAGE_MELEE
endglobals
//! endtextmacro
//! textmacro buffDataHeaderg000
globals
	public constant integer ID = 'g000'
	public constant string NAME = "포만감"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\null.blp"
	public constant integer INDIVISUAL = 2
	public constant integer POSITIVE = 0
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
	public constant boolean USE_DAMAGE_FLAG = false
endglobals
//! endtextmacro
//! textmacro buffDataHeaderg001
globals
	public constant integer ID = 'g001'
	public constant string NAME = "포션중독"
	public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\null.blp"
	public constant integer INDIVISUAL = 2
	public constant integer POSITIVE = 0
	public constant boolean DISPLAY = true
	public constant boolean USE_DAMAGE_TAG = false
	public constant integer TAG1 = -1
	public constant integer TAG2 = -1
	public constant integer TAG3 = -1
	public constant integer TAG4 = -1
endglobals
//! endtextmacro
