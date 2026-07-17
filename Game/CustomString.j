//! import "GeneratedCustomString.j"

library CustomString

	//! textmacro customStringArray takes key
		string array CUSTOM_STRING_$key$_COLOR
		string array CUSTOM_STRING_$key$_ICON
		string array CUSTOM_STRING_$key$_DESCRIPTION
		string array CUSTOM_STRING_$key$_NAME
	//! endtextmacro

	globals
		//! runtextmacro customStringArray("STAT")
		//! runtextmacro customStringArray("STATUS")
		//! runtextmacro customStringArray("DAMAGE")
		//! runtextmacro customStringArray("UNIT_CLASS")
		//! runtextmacro customStringArray("TIER")
		//! runtextmacro customStringArray("ABILITY_TAG")
		//! runtextmacro customStringArray("CAST_TYPE")
		//! runtextmacro customStringArray("UPGRADE")
	endglobals

	struct CustomString

		static method className takes integer ctype returns string
			return CUSTOM_STRING_STAT_COLOR[CONFIG_STAT_CONSTANT]+CUSTOM_STRING_UNIT_CLASS_NAME[ctype]+"|r"
		endmethod

		static method statName takes integer index returns string
			return CUSTOM_STRING_STAT_COLOR[index]+CUSTOM_STRING_STAT_NAME[index]+"|r"
		endmethod

		static method statString takes integer index, string s returns string
			return CUSTOM_STRING_STAT_COLOR[index]+s+"|r"
		endmethod

		static method statStringReal takes integer index, real v, integer jom returns string
			return CUSTOM_STRING_STAT_COLOR[index]+R2SW(v,jom,jom)+"|r"
		endmethod

		static method statStringPercent takes integer index, real v returns string
			return CUSTOM_STRING_STAT_COLOR[index]+I2S(MathRound(v*100.))+"%|r"
		endmethod

		static method statStringInteger takes integer index, integer v returns string
			return CUSTOM_STRING_STAT_COLOR[index]+I2S(v)+"|r"
		endmethod

		static method statTooltip takes integer index, string s returns string
			return CUSTOM_STRING_STAT_COLOR[index]+s+"|r"
		endmethod

		static method statTooltipReal takes integer index, real v, integer jom returns string
			return CUSTOM_STRING_STAT_COLOR[index]+R2SW(v,jom,jom)+"|r"
		endmethod

		static method statTooltipSecond takes integer index, real v returns string
			return CUSTOM_STRING_STAT_COLOR[index]+R2SW(v,1,1)+"초|r"
		endmethod

		static method statTooltipPercent takes integer index, real v returns string
			return CUSTOM_STRING_STAT_COLOR[index]+R2SW(v*100.,1,1)+"%|r"
		endmethod

		static method statTooltipInteger takes integer index, integer v returns string
			return CUSTOM_STRING_STAT_COLOR[index]+I2S(v)+"|r"
		endmethod

		static method statusName takes integer index returns string
			return "|cff00ffff"+CUSTOM_STRING_STATUS_NAME[index]+"|r"
		endmethod

		static method coloredString takes string cs, string s returns string
			return cs + s + "|r"
		endmethod

		static method shiftTooltip takes string s returns string
			if User.getKeyState(GetLocalPlayer(),OSKEY_LSHIFT) then
				return s
			else
				return ""
			endif
		endmethod

		static method shiftStatTooltip takes integer index returns string
			return shiftTooltip(CUSTOM_STRING_STAT_COLOR[index]+"(▲"+CUSTOM_STRING_STAT_NAME[index]+")|r")
		endmethod

		static method onInit takes nothing returns nothing
			//! runtextmacro generatedCustomString()
		endmethod

	endstruct

endlibrary