library GenericBuff

	struct GenericBuff extends array

		method addPomangam takes integer val, real duration returns Buff
			return Buff.addWithValue(this,this,'Pmgm',0,duration,val)
		endmethod

		method addAddict takes integer val, real duration returns Buff
			return Buff.addWithValue(this,this,'Padt',0,duration,val)
		endmethod

		method addStun takes real duration returns Buff
			return Buff.add(this,this,'Stun',0,duration)
		endmethod

	endstruct

endlibrary

/*스턴*/
scope BuffStun initializer init
	
	globals
		public constant integer ID = 'Stun'
		public constant string NAME = "기절"
		public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNStun.blp"
		public constant integer INDIVISUAL = 0
		public constant integer POSITIVE = 0
		public constant boolean DISPLAY = true
		public constant boolean USE_DAMAGE_TAG = false
		public constant integer TAG1 = -1
		public constant integer TAG2 = -1
		public constant integer TAG3 = -1
		public constant integer TAG4 = -1
		public constant boolean USE_DAMAGE_FLAG = false
	endglobals

	public struct main extends Buff

		Effect ef = 0

		method init takes nothing returns boolean
			call .target.plusStatus(CONFIG_STATUS_STUN)
			if not .target.canStun() then
				call destroy()
				return false
			endif
			set ef = Effect.createAttatched("Abilities\\Spells\\Human\\Thunderclap\\ThunderclapTarget.mdl",.target.origin_unit,"overhead")
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call .target.minusStatus(CONFIG_STATUS_STUN)
			call ef.kill()
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

/*속박*/
scope BuffEnsn initializer init
	
	globals
		public constant integer ID = 'Ensn'
		public constant string NAME = "속박"
		public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNEnsnare.blp"
		public constant integer INDIVISUAL = 0
		public constant integer POSITIVE = 0
		public constant boolean DISPLAY = true
		public constant boolean USE_DAMAGE_TAG = false
		public constant integer TAG1 = -1
		public constant integer TAG2 = -1
		public constant integer TAG3 = -1
		public constant integer TAG4 = -1
		public constant boolean USE_DAMAGE_FLAG = false
	endglobals

	public struct main extends Buff

		method init takes nothing returns boolean
			call .target.plusStatus(CONFIG_STATUS_ENSNARE)
			if not .target.canStun() then
				call destroy()
				return false
			endif
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call .target.minusStatus(CONFIG_STATUS_ENSNARE)
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

/*심플둔화*/
scope BuffSlow initializer init
	
	globals
		public constant integer ID = 'Slow'
		public constant string NAME = ""
		public constant string ICON_PATH = ""
		public constant integer INDIVISUAL = 2
		public constant integer POSITIVE = 0
		public constant boolean DISPLAY = false
		public constant boolean USE_DAMAGE_TAG = false
		public constant integer TAG1 = -1
		public constant integer TAG2 = -1
		public constant integer TAG3 = -1
		public constant integer TAG4 = -1
		public constant boolean USE_DAMAGE_FLAG = false
	endglobals

	public struct main extends Buff

		integer val = 0

		method suspendFilterAdditional takes nothing returns boolean
			return .target.getStatus(CONFIG_STATUS_UNSTOP) > 0
		endmethod

		method init takes nothing returns boolean
			set .val = CUSTOM_RESPOND_BUFF_VALUE
			call .target.divideStatValue(CONFIG_STAT_MOVEMENT_SPEED,.val)
			if .target.getStatus(CONFIG_STATUS_UNSTOP) > 0 then
				call destroy()
				return false
			endif
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call .target.divideStatValue(CONFIG_STAT_MOVEMENT_SPEED,-.val)
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

/*포만감*/
scope BuffPmgm initializer init
	
	globals
		public constant integer ID = 'Pmgm'
		public constant string NAME = "포만감"
		public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNMonsterLure.blp"
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

	public struct main extends Buff

		integer val = 0

		method init takes nothing returns boolean
			set .val = CUSTOM_RESPOND_BUFF_VALUE
			set .extra = I2S(.val)
			call UnitClass(.target).addClass(CONFIG_UNIT_CLASS_POMANGAM,.val)
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call UnitClass(.target).addClass(CONFIG_UNIT_CLASS_POMANGAM,-.val)
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

/*포션중독*/
scope BuffPadt initializer init
	
	globals
		public constant integer ID = 'Padt'
		public constant string NAME = "포션중독"
		public constant string ICON_PATH = "ReplaceableTextures\\CommandButtons\\BTNVialEmpty.blp"
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

	public struct main extends Buff

		integer val = 0

		method init takes nothing returns boolean
			set .val = CUSTOM_RESPOND_BUFF_VALUE
			set .extra = I2S(.val)
			call UnitClass(.target).addClass(CONFIG_UNIT_CLASS_ADDICT,.val)
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call UnitClass(.target).addClass(CONFIG_UNIT_CLASS_ADDICT,-.val)
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope