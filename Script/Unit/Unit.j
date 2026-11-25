//! import "Tombstone.j"
//! import "LuckyBonus.j"

library Unit requires UnitData

	struct Unit extends Unit_prototype

		static boolean LOAD_ABILITY = true
		private static constant integer SKILLPOINT_PER_LEVEL = 3
		private static constant integer REMOVEPOINT_PER_LEVEL = 2

		integer removepoint = 0

		SimpleList upgrade_point = 0

		method getUpgradePoint takes integer index returns integer
			return .upgrade_point.get(index)
		endmethod

		method setUpgradePoint takes integer index, integer val returns nothing
			call .upgrade_point.setData(index,val)
			// set AbilityManager.REFRESH_SKILLPOINT_PLAYER = .owner
			// call TriggerEvaluate(AbilityManager.REFRESH_SKILLPOINT_TRIGGER)
		endmethod

		method addUpgradePoint takes integer index, integer val returns nothing
			call setUpgradePoint(index,getUpgradePoint(index)+val)
		endmethod

		/*특정 유닛의 어빌리티를 전부 복사*/
		/*가진 어빌리티가 아무것도 없을때 쓰는 것을 권장*/
		method copyAbility takes thistype target returns nothing
			local integer i = 0
			local Ability a = 0
			local Ability ta = 0
			loop
				exitwhen i >= CONFIG_ABILITY_SIZE
				set ta = Ability(target.getAbility(i))
				if ta > 0 then
					/*타겟의 어빌리티 복제*/
					set a = Ability.addUnitAbility(this,a.id)
					if a > 0 then
						/*레벨싱크*/
						call a.addLevel(ta.level-1)
						/*무기어빌 싱크*/
						if target.getWeaponAbility() == ta then
							call Ability.setUnitWeaponAbility(this,a)
						endif
					endif
				endif
				set i = i + 1
			endloop
		endmethod

		static method onLevel takes nothing returns nothing

		endmethod

		static method loveDamageCallback takes nothing returns nothing
			local thistype attacker = EVT_DAMAGE_ATTACKER
			local real love = attacker.getCalculatedStatValue(ENUM_STAT_LOVE)
			/*러브값 0이하면 리턴*/
			if love <= 0. then
				return
			endif
			/*그렇지 않으면 러브패널티*/
			set EVT_DAMAGE_AMOUNT = EVT_DAMAGE_AMOUNT * (100.0/(100.0+love))
		endmethod

		static method loveShieldCallback takes nothing returns nothing
			local thistype caster = 0
			local thistype target = 0
			local real val = 0.
			/*자가쉴드는 러브보너스x*/
			if EVT_SHIELD_CASTER == EVT_SHIELD_TARGET then
				return
			endif
			set caster = EVT_SHIELD_CASTER
			set target = EVT_SHIELD_TARGET
			// call BJDebugMsg("러브보너스!!")
			// call BJDebugMsg("적용전:"+I2S(R2I(EVT_SHIELD_AMOUNT)))
			/*1차가공(캐스터 기준)*/
			set val = caster.getCalculatedStatValue(ENUM_STAT_LOVE)
			if val >= 0. then
				set EVT_SHIELD_AMOUNT = EVT_SHIELD_AMOUNT * ((100.0+val)/100.0)
			else
				set EVT_SHIELD_AMOUNT = EVT_SHIELD_AMOUNT * (100.0/(100.0+val))
			endif
			/*2차가공(타겟 기준)*/
			set val = target.getCalculatedStatValue(ENUM_STAT_LOVE)
			if val >= 0. then
				set EVT_SHIELD_AMOUNT = EVT_SHIELD_AMOUNT * ((100.0+val)/100.0)
			else
				set EVT_SHIELD_AMOUNT = EVT_SHIELD_AMOUNT * (100.0/(100.0+val))
			endif
			// call BJDebugMsg("적용후:"+I2S(R2I(EVT_SHIELD_AMOUNT)))
			// call BJDebugMsg("//===================")
		endmethod

		static method loveHealCallback takes nothing returns nothing
			local thistype caster = 0
			local thistype target = 0
			local real val = 0.
			/*자가치유는 러브보너스x*/
			if EVT_HEAL_CASTER == EVT_HEAL_TARGET then
				return
			endif
			set caster = EVT_HEAL_CASTER
			set target = EVT_HEAL_TARGET
			// call BJDebugMsg("러브보너스!!")
			// call BJDebugMsg("적용전:"+I2S(R2I(EVT_HEAL_AMOUNT)))
			/*1차가공(캐스터 기준)*/
			set val = caster.getCalculatedStatValue(ENUM_STAT_LOVE)
			if val >= 0. then
				set EVT_HEAL_AMOUNT = EVT_HEAL_AMOUNT * ((100.0+val)/100.0)
			else
				set EVT_HEAL_AMOUNT = EVT_HEAL_AMOUNT * (100.0/(100.0+val))
			endif
			/*2차가공(타겟 기준)*/
			set val = target.getCalculatedStatValue(ENUM_STAT_LOVE)
			if val >= 0. then
				set EVT_HEAL_AMOUNT = EVT_HEAL_AMOUNT * ((100.0+val)/100.0)
			else
				set EVT_HEAL_AMOUNT = EVT_HEAL_AMOUNT * (100.0/(100.0+val))
			endif
			// call BJDebugMsg("적용후:"+I2S(R2I(EVT_HEAL_AMOUNT)))
			// call BJDebugMsg("//===================")
		endmethod

		method loadAbility takes nothing returns nothing
			local integer i = 0
			local Ability lc = 0
			if not LOAD_ABILITY then
				return
			endif
			loop
				exitwhen i >= CONFIG_ABILITY_SIZE or UnitData.getInteger(.id,ENUM_UNIT_PARAM_INITIAL_ABILITY) <= 0
				set lc = Ability.addUnitAbility(this,UnitData.getInteger(.id,ENUM_UNIT_PARAM_INITIAL_ABILITY))
				/*EXP적립*/
				call lc.setUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_BLUE,Ability.getTypeTier(lc.id))
				set lc.signature = true
				if Ability.getTypeCastType(lc.id) == ENUM_CAST_TYPE_WEAPON then
					call Ability.setUnitWeaponAbility(this,lc)
				endif
				set i = i + 1
			endloop
		endmethod

		method initClass takes nothing returns nothing
			call UnitClass(this).addClass(ENUM_UNIT_CLASS_POMANGAM_MAX,ENUM_UNIT_CLASS_MAX_VALUE)
			call UnitClass(this).addClass(ENUM_UNIT_CLASS_ADDICT_MAX,ENUM_UNIT_CLASS_MAX_VALUE)
		endmethod

		static method create takes player p, integer uid, real x, real y, real yaw returns thistype
			local thistype this = allocate(p,uid,x,y,yaw)
			local integer i = 0
			call loadAbility()
			call initClass()
			set .upgrade_point = SimpleList.create(ENUM_ABILITY_UPGRADE_TYPE_MAX)
			set .class = "Unit"
			set .mp = getCalculatedStatValue(ENUM_STAT_MAXMP)
			loop
				exitwhen i >= ENUM_ABILITY_UPGRADE_TYPE_MAX
				call setUpgradePoint(i,0)
				set i = i + 1
			endloop
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			call .upgrade_point.destroy()
			call UnitClass(this).clearClass()
		endmethod

		/*static method customSelect takes nothing returns nothing
			if CLICK_BUTTON_TYPE != MOUSE_BUTTON_TYPE_LEFT then
				return
			endif
			if GetOwningPlayer(CLICK_UNIT) != CLICK_PLAYER then
				return
			endif
			if get(CLICK_UNIT) > 0 then
				call User.setFocusUnit(CLICK_PLAYER,get(CLICK_UNIT))
				call UI(GetPlayerId(CLICK_PLAYER)).setTarget(get(CLICK_UNIT))
			endif
		endmethod*/

		static method onInit takes nothing returns nothing
			local trigger t = null
			/*커스텀 레벨업 트리거*/
			set t = CreateTrigger()
			call Event.register(t,ENUM_EVENT_LEVEL)
			call TriggerAddCondition(t,function thistype.onLevel)
			/*커스텀 최종뎀 트리거(애정)*/
			set t = CreateTrigger()
			call Event.register(t,ENUM_EVENT_DAMAGE_LAST)
			call TriggerAddCondition(t,function thistype.loveDamageCallback)
			/*커스텀 최종힐 트리거(애정)*/
			set t = CreateTrigger()
			call Event.register(t,ENUM_EVENT_HEAL_LAST)
			call TriggerAddCondition(t,function thistype.loveHealCallback)
			/*커스텀 최종쉴드 트리거(애정)*/
			set t = CreateTrigger()
			call Event.register(t,ENUM_EVENT_SHIELD_LAST)
			call TriggerAddCondition(t,function thistype.loveShieldCallback)
			/*set UNIT_SELECT = CreateTrigger()
			call Event.triggerRegisterGenericClick(UNIT_SELECT)
			call TriggerAddCondition(UNIT_SELECT,function thistype.customSelect)*/
			
			set t = null
		endmethod

	endstruct

endlibrary

//! import "InteractiveUnit/InteractiveUnit.j"
//! import "Summon.j"
//! import "Boss/Boss.j"