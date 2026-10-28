//! import "UnitData.j"
//! import "Tombstone.j"
//! import "Undead\\Undead.j"
//! import "LuckyBonus.j"

library Unit requires UnitData

	struct Unit extends Unit_prototype

		static boolean LOAD_ABILITY = true
		private static constant integer SKILLPOINT_PER_LEVEL = 3
		private static constant integer REMOVEPOINT_PER_LEVEL = 2

		//static trigger UNIT_SELECT = null
		Chingho chingho = 0
		integer removepoint = 0

		SimpleList upgrade_point = 0

		method getUpgradePoint takes integer index returns integer
			return .upgrade_point.get(index)
		endmethod

		method setUpgradePoint takes integer index, integer val returns nothing
			call .upgrade_point.setData(index,val)
			set AbilityManager.REFRESH_SKILLPOINT_PLAYER = .owner
			call TriggerEvaluate(AbilityManager.REFRESH_SKILLPOINT_TRIGGER)
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
				set ta = target.getAbility(i)
				if ta > 0 then
					/*타겟의 어빌리티 복제*/
					set a = addAbility(ta.id)
					if a > 0 then
						/*레벨싱크*/
						call a.addLevel(ta.level-1)
						/*무기어빌 싱크*/
						if target.weapon_ability == ta then
							call setWeaponAbility(a)
						endif
					endif
				endif
				set i = i + 1
			endloop
		endmethod

		static method onLevel takes nothing returns nothing
			local integer i = 0
			local Ability a = 0
			local thistype this = CUSTOM_RESPOND_LEVEL_UNIT
			if CUSTOM_RESPOND_LEVEL_UNIT <= 0 or CUSTOM_RESPOND_LEVEL_LEVEL <= 0 then
				return
			endif
			loop
				exitwhen i >= CONFIG_ABILITY_SIZE
				set a = getAbility(i)
				if a > 0 and a.signature then
					if a.level + CUSTOM_RESPOND_LEVEL_LEVEL > a.level_max then
						/*초과분 환급*/
						call User.addGold(.owner,Ability.getTypeCost(a.id)*(CUSTOM_RESPOND_LEVEL_LEVEL-a.level_max+a.level))
						call a.addLevel(a.level_max-a.level)
						/*EXP적립*/
						call a.setUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_BLUE,a.getUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_BLUE)+Ability.getTypeTier(a.id)*(a.level_max-a.level))
					else
						/*그냥레벨업*/
						call a.addLevel(CUSTOM_RESPOND_LEVEL_LEVEL)
						/*EXP적립*/
						call a.setUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_BLUE,a.getUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_BLUE)+Ability.getTypeTier(a.id)*CUSTOM_RESPOND_LEVEL_LEVEL)
					endif
				endif
				set i = i + 1
			endloop
			call setUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_RED,getUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_RED) + CUSTOM_RESPOND_LEVEL_LEVEL*SKILLPOINT_PER_LEVEL)
			set .removepoint = .removepoint + CUSTOM_RESPOND_LEVEL_LEVEL*REMOVEPOINT_PER_LEVEL
			/**/set CUSTOM_RESPOND_UI_REFRESH_PLAYER = .owner
			/**/call Event.activate(ENUM_EVENT_ABILITY_UI_REFRESH)
			/**/set CUSTOM_RESPOND_UI_REFRESH_PLAYER = null
		endmethod

		static method loveDamageCallback takes nothing returns nothing
			local thistype attacker = CUSTOM_RESPOND_DAMAGE_ATTACKER
			local real love = attacker.getCarculatedStatValue(ENUM_STAT_LOVE)
			/*러브값 0이하면 리턴*/
			if love <= 0. then
				return
			endif
			/*그렇지 않으면 러브패널티*/
			set CUSTOM_RESPOND_DAMAGE_AMOUNT = CUSTOM_RESPOND_DAMAGE_AMOUNT * (100.0/(100.0+love))
		endmethod

		static method loveShieldCallback takes nothing returns nothing
			local thistype caster = 0
			local thistype target = 0
			local real val = 0.
			/*자가쉴드는 러브보너스x*/
			if CUSTOM_RESPOND_SHIELD_CASTER == CUSTOM_RESPOND_SHIELD_TARGET then
				return
			endif
			set caster = CUSTOM_RESPOND_SHIELD_CASTER
			set target = CUSTOM_RESPOND_SHIELD_TARGET
			call BJDebugMsg("러브보너스!!")
			call BJDebugMsg("적용전:"+I2S(R2I(CUSTOM_RESPOND_SHIELD_AMOUNT)))
			/*1차가공(캐스터 기준)*/
			set val = caster.getCarculatedStatValue(ENUM_STAT_LOVE)
			if val >= 0. then
				set CUSTOM_RESPOND_SHIELD_AMOUNT = CUSTOM_RESPOND_SHIELD_AMOUNT * ((100.0+val)/100.0)
			else
				set CUSTOM_RESPOND_SHIELD_AMOUNT = CUSTOM_RESPOND_SHIELD_AMOUNT * (100.0/(100.0+val))
			endif
			/*2차가공(타겟 기준)*/
			set val = target.getCarculatedStatValue(ENUM_STAT_LOVE)
			if val >= 0. then
				set CUSTOM_RESPOND_SHIELD_AMOUNT = CUSTOM_RESPOND_SHIELD_AMOUNT * ((100.0+val)/100.0)
			else
				set CUSTOM_RESPOND_SHIELD_AMOUNT = CUSTOM_RESPOND_SHIELD_AMOUNT * (100.0/(100.0+val))
			endif
			call BJDebugMsg("적용후:"+I2S(R2I(CUSTOM_RESPOND_SHIELD_AMOUNT)))
			call BJDebugMsg("//===================")
		endmethod

		static method loveHealCallback takes nothing returns nothing
			local thistype caster = 0
			local thistype target = 0
			local real val = 0.
			/*자가치유는 러브보너스x*/
			if CUSTOM_RESPOND_HEAL_CASTER == CUSTOM_RESPOND_HEAL_TARGET then
				return
			endif
			set caster = CUSTOM_RESPOND_HEAL_CASTER
			set target = CUSTOM_RESPOND_HEAL_TARGET
			call BJDebugMsg("러브보너스!!")
			call BJDebugMsg("적용전:"+I2S(R2I(CUSTOM_RESPOND_HEAL_AMOUNT)))
			/*1차가공(캐스터 기준)*/
			set val = caster.getCarculatedStatValue(ENUM_STAT_LOVE)
			if val >= 0. then
				set CUSTOM_RESPOND_HEAL_AMOUNT = CUSTOM_RESPOND_HEAL_AMOUNT * ((100.0+val)/100.0)
			else
				set CUSTOM_RESPOND_HEAL_AMOUNT = CUSTOM_RESPOND_HEAL_AMOUNT * (100.0/(100.0+val))
			endif
			/*2차가공(타겟 기준)*/
			set val = target.getCarculatedStatValue(ENUM_STAT_LOVE)
			if val >= 0. then
				set CUSTOM_RESPOND_HEAL_AMOUNT = CUSTOM_RESPOND_HEAL_AMOUNT * ((100.0+val)/100.0)
			else
				set CUSTOM_RESPOND_HEAL_AMOUNT = CUSTOM_RESPOND_HEAL_AMOUNT * (100.0/(100.0+val))
			endif
			call BJDebugMsg("적용후:"+I2S(R2I(CUSTOM_RESPOND_HEAL_AMOUNT)))
			call BJDebugMsg("//===================")
		endmethod

		method setChingho takes integer id returns nothing
			if .chingho > 0 then
				call .chingho.destroy()
			endif
			call Ability_prototype.new(id)
			set .chingho = ABILITY_LAST_CREATED
			if .chingho > 0 then
				/*명함의 역할만 하기 때문에 essentialInit 호출 생략.*/
				set .chingho.owner = this
				call .chingho.init()
				call BlzSetHeroProperName(.origin_unit,"|cffffcc00["+.chingho.name+"]|r\n"+.origin_name)
			endif
		endmethod

		method copyStat takes integer stattype returns nothing
			if HaveSavedReal(UnitData.HASH,.id,UnitData.INDEX_STAT+(stattype*ENUM_STAT_INDEX_SIZE)+ENUM_STAT_INDEX_BASE) then
				call setStatValue(stattype,ENUM_STAT_INDEX_BASE,LoadReal(UnitData.HASH,.id,UnitData.INDEX_STAT+(stattype*ENUM_STAT_INDEX_SIZE)+ENUM_STAT_INDEX_BASE))
			else
				call setStatValue(stattype,ENUM_STAT_INDEX_BASE,LoadReal(UnitData.HASH,0,UnitData.INDEX_STAT+(stattype*ENUM_STAT_INDEX_SIZE)+ENUM_STAT_INDEX_BASE))
			endif
			if HaveSavedReal(UnitData.HASH,.id,UnitData.INDEX_STAT+(stattype*ENUM_STAT_INDEX_SIZE)+ENUM_STAT_INDEX_LEVEL) then
				call setStatValue(stattype,ENUM_STAT_INDEX_LEVEL,LoadReal(UnitData.HASH,.id,UnitData.INDEX_STAT+(stattype*ENUM_STAT_INDEX_SIZE)+ENUM_STAT_INDEX_LEVEL))
			else
				call setStatValue(stattype,ENUM_STAT_INDEX_LEVEL,LoadReal(UnitData.HASH,0,UnitData.INDEX_STAT+(stattype*ENUM_STAT_INDEX_SIZE)+ENUM_STAT_INDEX_LEVEL))	
			endif
			call refreshStatValue(stattype)
		endmethod

		method copyStats takes nothing returns nothing
			call copyStat(ENUM_STAT_MAXHP)
			call copyStat(ENUM_STAT_MAXMP)
			call copyStat(ENUM_STAT_ATTACK)
			call copyStat(ENUM_STAT_DEFENSE)
			call copyStat(ENUM_STAT_MAGICPOWER)
			call copyStat(ENUM_STAT_RESISTANCE)
			call copyStat(ENUM_STAT_ACCURACY)
			call copyStat(ENUM_STAT_EVASION)
			call copyStat(ENUM_STAT_HPREGEN)
			call copyStat(ENUM_STAT_MPREGEN)
			set .mp = .maxmp
		endmethod

		method loadAbility takes nothing returns nothing
			local integer i = 0
			local Ability lc = 0
			if not LOAD_ABILITY then
				return
			endif
			loop
				exitwhen i >= CONFIG_ABILITY_SIZE or UnitData.getInitialAbility(.id,i) <= 0
				set lc = addAbility(UnitData.getInitialAbility(.id,i))
				/*EXP적립*/
				call lc.setUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_BLUE,Ability.getTypeTier(lc.id))
				set lc.signature = true
				if Ability.getTypeCastType(lc.id) == ENUM_CAST_TYPE_WEAPON then
					call setWeaponAbility(lc)
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
			call copyStats()
			call loadAbility()
			call initClass()
			set .upgrade_point = SimpleList.create(ENUM_ABILITY_UPGRADE_TYPE_MAX)
			set .class = "Unit"
			loop
				exitwhen i >= ENUM_ABILITY_UPGRADE_TYPE_MAX
				call setUpgradePoint(i,0)
				set i = i + 1
			endloop
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			if .chingho > 0 then
				call .chingho.destroy()
			endif
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