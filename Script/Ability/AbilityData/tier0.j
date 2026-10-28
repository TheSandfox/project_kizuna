//!Ability0000 툴팁미씽
scope Ability0000 initializer init
	

	
		globals

		endglobals
	
		public struct main extends Ability
	
			method relativeTooltip takes nothing returns string
				return "나는 쓸모가 없을 수도 있는 0티어 스킬.."
			endmethod
	
			method execute takes nothing returns nothing
				
			endmethod
	
			method init takes nothing returns nothing
				set .is_active = false
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"단거리 돌진,\n충돌 시 범위피해")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope