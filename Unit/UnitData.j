//! textmacro unitDataHeader takes key, icon
	private function init takes nothing returns nothing
		set UnitData.ID = '$key$'
		call UnitData.setIconPath("ReplaceableTextures\\CommandButtons\\$icon$.blp")
//! endtextmacro

//! textmacro unitDataEnd
	endfunction
//! endtextmacro

library UnitData requires UnitPrototype

	struct UnitData extends array

		static hashtable HASH = InitHashtable()
		static integer INDEX_STAT = 0
		static integer INDEX_INITIAL_ABILITY = 0
		static integer INDEX_EXTRA_ABILITY = 0
		static integer INDEX_ITEM = 0
		static integer INDEX_STATUS = 0
		static integer INDEX_LAST = 0
		static integer INDEX_EXTERNAL = 0 
		static integer ID = 0

		static method getIconPath takes integer uid returns string
			if HaveSavedString(HASH,uid,INDEX_EXTERNAL+0) then
				return LoadStr(HASH,uid,INDEX_EXTERNAL+0)
			else
				return "BTNBlackIcon"
			endif
		endmethod

		static method setIconPath takes string nval returns nothing
			call SaveStr(HASH,ID,INDEX_EXTERNAL+0,nval)
		endmethod

		static method getInitialAbility takes integer uid, integer index returns integer
			if HaveSavedInteger(HASH,uid,INDEX_INITIAL_ABILITY+index) then
				return LoadInteger(HASH,uid,INDEX_INITIAL_ABILITY+index)
			else
				return 0
			endif
		endmethod

		static method setInitialAbility takes integer index, integer aid returns nothing
			call SaveInteger(HASH,ID,INDEX_INITIAL_ABILITY+index,aid)
		endmethod

		static method getExtraAbility takes integer uid, integer index returns integer
			if HaveSavedInteger(HASH,uid,INDEX_EXTRA_ABILITY+index) then
				return LoadInteger(HASH,uid,INDEX_EXTRA_ABILITY+index)
			else
				return 0
			endif
		endmethod

		static method setExtraAbility takes integer index, integer aid returns nothing
			call SaveInteger(HASH,ID,INDEX_EXTRA_ABILITY+index,aid)
		endmethod

		static method setStatValue takes integer stattype, real base, real level returns nothing
			call SaveReal(HASH,ID,INDEX_STAT+(stattype*CONFIG_STAT_INDEX_SIZE)+CONFIG_STAT_INDEX_BASE,base)
			call SaveReal(HASH,ID,INDEX_STAT+(stattype*CONFIG_STAT_INDEX_SIZE)+CONFIG_STAT_INDEX_LEVEL,level)
		endmethod

		static method setDefaults takes nothing returns nothing
			set ID = 0
			call setStatValue(CONFIG_STAT_MAXHP,		400.,	40.	)
			call setStatValue(CONFIG_STAT_MAXMP,		100.,	10.	)
			call setStatValue(CONFIG_STAT_ATTACK,		20.,	2.	)
			call setStatValue(CONFIG_STAT_DEFENSE,		20.,	2.	)
			call setStatValue(CONFIG_STAT_MAGICPOWER,	20.,	2.	)
			call setStatValue(CONFIG_STAT_RESISTANCE,	20.,	2.	)
			call setStatValue(CONFIG_STAT_ACCURACY,		20.,	2.	)
			call setStatValue(CONFIG_STAT_EVASION,		20.,	2.	)
			call setStatValue(CONFIG_STAT_HPREGEN,		4.,		0.4	)
			call setStatValue(CONFIG_STAT_MPREGEN,		1.,		0.1	)
		endmethod

		private static method onInit takes nothing returns nothing
			set INDEX_STAT 	 	= 0
			set INDEX_INITIAL_ABILITY 	= INDEX_STAT + CONFIG_STAT_SIZE * CONFIG_STAT_INDEX_SIZE
			set INDEX_EXTRA_ABILITY = INDEX_INITIAL_ABILITY + 8
			set INDEX_ITEM		= INDEX_EXTRA_ABILITY + CONFIG_ABILITY_SIZE
			set INDEX_STATUS	= INDEX_ITEM + CONFIG_UNIT_INVENTORY_SIZE
			set INDEX_LAST		= INDEX_STATUS + CONFIG_STATUS_SIZE
			set INDEX_EXTERNAL 	= INDEX_LAST
			call setDefaults()
		endmethod

	endstruct

endlibrary

//! import "GeneratedUnitParams.j"