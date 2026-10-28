library CustomString

	struct CustomString

		static method className takes integer ctype returns string
			return CONSTANT_STAT_COLOR[ENUM_STAT_CONSTANT]+CONSTANT_UNIT_CLASS_NAME[ctype]+"|r"
		endmethod

		static method statName takes integer index returns string
			return CONSTANT_STAT_COLOR[index]+CONSTANT_STAT_NAME[index]+"|r"
		endmethod

		static method statString takes integer index, string s returns string
			return CONSTANT_STAT_COLOR[index]+s+"|r"
		endmethod

		static method statStringReal takes integer index, real v, integer jom returns string
			return CONSTANT_STAT_COLOR[index]+R2SW(v,jom,jom)+"|r"
		endmethod

		static method statStringPercent takes integer index, real v returns string
			return CONSTANT_STAT_COLOR[index]+I2S(MathRound(v*100.))+"%|r"
		endmethod

		static method statStringInteger takes integer index, integer v returns string
			return CONSTANT_STAT_COLOR[index]+I2S(v)+"|r"
		endmethod

		static method statTooltip takes integer index, string s returns string
			return CONSTANT_STAT_COLOR[index]+s+"|r"
		endmethod

		static method statTooltipReal takes integer index, real v, integer jom returns string
			return CONSTANT_STAT_COLOR[index]+R2SW(v,jom,jom)+"|r"
		endmethod

		static method statTooltipSecond takes integer index, real v returns string
			return CONSTANT_STAT_COLOR[index]+R2SW(v,1,1)+"초|r"
		endmethod

		static method statTooltipPercent takes integer index, real v returns string
			return CONSTANT_STAT_COLOR[index]+R2SW(v*100.,1,1)+"%|r"
		endmethod

		static method statTooltipInteger takes integer index, integer v returns string
			return CONSTANT_STAT_COLOR[index]+I2S(v)+"|r"
		endmethod

		static method statusName takes integer index returns string
			return "|cff00ffff"+CONSTANT_STATUS_NAME[index]+"|r"
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
			return shiftTooltip(CONSTANT_STAT_COLOR[index]+"(▲"+CONSTANT_STAT_NAME[index]+")|r")
		endmethod

	endstruct

endlibrary