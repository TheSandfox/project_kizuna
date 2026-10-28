library Chingho

	struct Chingho extends Ability
		

	endstruct

endlibrary

/*C000 칭호_새내기*/
scope AbilityC000 initializer init

		
		//! runtextmacro abilityParamC000()

		public struct main extends Chingho

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
			endmethod

			method deactivate takes nothing returns nothing
				/*call .owner.multiplyStatValue(ENUM_STAT_MAXHP,-0.05)
				call .owner.multiplyStatValue(ENUM_STAT_HPREGEN,-0.05)
				call .owner.multiplyStatValue(ENUM_STAT_MAXMP,-0.05)
				call .owner.multiplyStatValue(ENUM_STAT_MPREGEN,-0.05)
				call .owner.multiplyStatValue(ENUM_STAT_ATTACK,-0.05)
				call .owner.multiplyStatValue(ENUM_STAT_DEFENCE,-0.05)
				call .owner.multiplyStatValue(ENUM_STAT_MAGICPOWER,-0.05)
				call .owner.multiplyStatValue(ENUM_STAT_RESISTANCE,-0.05)
				call .owner.multiplyStatValue(ENUM_STAT_ACCURACY,-0.05)
				call .owner.multiplyStatValue(ENUM_STAT_EVASION,-0.05)*/
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"아직은 풋풋한 느낌")
			endmethod

		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

/*C001 칭호_동인천 역가드*/
scope AbilityC001 initializer init

		
	//! runtextmacro abilityParamC001()

		public struct main extends Chingho

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
			endmethod

			method deactivate takes nothing returns nothing
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"나의 역가드를 알까?")
			endmethod

		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

/*C002 칭호_가짜광기*/
scope AbilityC002 initializer init

		
	//! runtextmacro abilityParamC002()

		public struct main extends Chingho

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
			endmethod

			method deactivate takes nothing returns nothing
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"어중간하게 미쳐있는 사람")
			endmethod

		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

/*C003 칭호_꿈나무*/
scope AbilityC003 initializer init

		
	//! runtextmacro abilityParamC003()

		public struct main extends Chingho

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
			endmethod

			method deactivate takes nothing returns nothing
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"무럭무럭 자라나는 DreamTree")
			endmethod

		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

/*C004 칭호_아이돌*/
scope AbilityC004 initializer init

		
	//! runtextmacro abilityParamC004()

		public struct main extends Chingho

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
			endmethod

			method deactivate takes nothing returns nothing
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"어떠한 역경도 이겨낼 준비가 되어있는 자들")
			endmethod

		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

/*C005 칭호_정의의 사도*/
scope AbilityC005 initializer init

		
	//! runtextmacro abilityParamC005()

		public struct main extends Chingho

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
			endmethod

			method deactivate takes nothing returns nothing
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"불순한 것들은 내가 다 처리했으니 안심하라구!")
			endmethod

		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

/*C006 칭호_치유계*/
scope AbilityC006 initializer init

		
	//! runtextmacro abilityParamC006()

		public struct main extends Chingho

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
			endmethod

			method deactivate takes nothing returns nothing
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"모두가 어리광부리고싶어하는 스타일")
			endmethod

		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

/*C007 칭호_패셔니스타*/
scope AbilityC007 initializer init

		
	//! runtextmacro abilityParamC007()

		public struct main extends Chingho

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
			endmethod

			method deactivate takes nothing returns nothing
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"앞서나가는 존재들이지만 항상 사람들을 이끄는 것은 아니다.")
			endmethod

		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

/*C008 칭호_밤의 일족*/
scope AbilityC008 initializer init

		
	//! runtextmacro abilityParamC008()

		public struct main extends Chingho

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
			endmethod

			method deactivate takes nothing returns nothing
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"혈관에 피 대신 카페인이 흐르는 사람들")
			endmethod

		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope