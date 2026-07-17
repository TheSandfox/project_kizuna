library Ability requires AbilityPrototype

	globals
		private hashtable HASH1 = InitHashtable()
		private hashtable HASH2 = InitHashtable()
		constant string ABILITY_TOOLTIP_PASSIVE = "|cff00ffff지속효과 : |r"
		constant string ABILITY_TOOLTIP_ACTIVE 	= "|cff00ffff사용 시 : |r"
		constant string ABILITY_TOOLTIP_SHIFT 	= "|cff00ffffShift + 스킬 단축키 : |r"
		constant string ABILITY_TOOLTIP_SUMMON 	= "|cffff0000해당 스킬 단축키 입력을 통한 |r|cff999999소환물 이동 후 스킬의 빠른시전 여부에 따라 소환물의 자동공격 활성화 상태가 변합니다.\n"+/*
		*/"(|r|cff00ffff즉시 사용 : |r|cff00ff00활성화|r |cff999999/|r "+/*
		*/"|cffffcc00사거리 표시 : |r|cff999999비활성화)|r"
		constant string ABILITY_TOOLTIP_FIXED_ATTACK_DELAY = "|cff999999고정된 공격속도를 가집니다.|r"
		constant string ABILITY_TOOLTIP_FREECAST = "|cff999999다른 행동 중에 사용할 수 있습니다.|r"
		constant string ABILITY_TOOLTIP_CANT_RIDE = "해당 유닛에 탑승할 수 없습니다."
		constant string ABILITY_TOOLTIP_CANT_CHARGE = "이동기 사용이 제한된 상태입니다."
		constant string ABILITY_TOOLTIP_CANT_GRAB = "잡을 수 없는 대상입니다."
	endglobals
	
	struct Ability extends Ability_prototype

		//HASH1:By Ability ID ('어빌id',인덱스)
		private static constant integer INDEX_TAG = 0
		private static constant integer INDEX_ICON_PATH = 8
		private static constant integer INDEX_NAME = 9
		private static constant integer INDEX_TIER = 10
		private static constant integer INDEX_COST = 11
		private static constant integer INDEX_BONUS_STAT = 12	/*SIZE : 2*/
		private static constant integer INDEX_TOOLTIP = 14
		private static constant integer INDEX_IS_WEAPON = 15
		private static constant integer INDEX_CAST_TYPE = 16
		private static constant integer INDEX_MAX_LEVEL = 17
		private static constant integer INDEX_LAST = 18
		//HASH2:By Instance ID (인스턴스id, 인덱스)
		private static constant integer INDEX_UPGRADE_POINT = 0

		real stat_bonus1 = 0.
		real stat_bonus2 = 0.
		boolean signature = false
		Servant servant = 0
		integer level_max = 0

		method getUpgradePoint takes integer index returns integer
			return LoadInteger(HASH2,this,INDEX_UPGRADE_POINT+index)
		endmethod

		method setUpgradePoint takes integer index, integer val returns nothing
			call SaveInteger(HASH2,this,INDEX_UPGRADE_POINT+index,val)
		endmethod

		method addUpgradePoint takes integer index, integer val returns nothing
			call setUpgradePoint(index,getUpgradePoint(index)+val)
		endmethod

		static method getTypeIsWeapon takes integer id returns boolean
			return LoadBoolean(HASH1,id,INDEX_IS_WEAPON)
		endmethod

		static method setTypeIsWeapon takes integer id, boolean b returns nothing
			call SaveBoolean(HASH1,id,INDEX_IS_WEAPON,b)
		endmethod

		static method getTypeTier takes integer id returns integer
			return LoadInteger(HASH1,id,INDEX_TIER)
		endmethod

		static method setTypeTier takes integer id, integer val returns nothing
			call SaveInteger(HASH1,id,INDEX_TIER,val)
		endmethod

		static method getTypeMaxLevel takes integer id returns integer
			return LoadInteger(HASH1,id,INDEX_MAX_LEVEL)
		endmethod

		static method setTypeMaxLevel takes integer id, integer val returns nothing
			call SaveInteger(HASH1,id,INDEX_MAX_LEVEL,val)
		endmethod

		static method getTypeCastType takes integer id returns integer
			return LoadInteger(HASH1,id,INDEX_CAST_TYPE)
		endmethod

		static method setTypeCastType takes integer id, integer val returns nothing
			call SaveInteger(HASH1,id,INDEX_CAST_TYPE,val)
		endmethod

		static method getTypeTooltip takes integer id returns string
			if HaveSavedString(HASH1,id,INDEX_TOOLTIP) then
				return LoadStr(HASH1,id,INDEX_TOOLTIP)
			else
				return "ToolTip Missing"
			endif
		endmethod

		static method setTypeTooltip takes integer id, string val returns nothing
			call SaveStr(HASH1,id,INDEX_TOOLTIP,val)
		endmethod

		static method getTypeCost takes integer id returns integer
			return LoadInteger(HASH1,id,INDEX_COST)
		endmethod

		static method setTypeCost takes integer id, integer val returns nothing
			call SaveInteger(HASH1,id,INDEX_COST,val)
		endmethod

		static method getTypeName takes integer id returns string
			return LoadStr(HASH1,id,INDEX_NAME)
		endmethod

		static method setTypeName takes integer id, string val returns nothing
			call SaveStr(HASH1,id,INDEX_NAME,val)
		endmethod

		static method getTypeIconPath takes integer id returns string
			if HaveSavedString(HASH1,id,INDEX_ICON_PATH) then
				return LoadStr(HASH1,id,INDEX_ICON_PATH)
			else
				return "Icons\\BTNBlackIcon.blp"
			endif
		endmethod

		static method setTypeIconPath takes integer id, string val returns nothing
			call SaveStr(HASH1,id,INDEX_ICON_PATH,val)
		endmethod

		static method getTypeBonusStatIndex takes integer id, integer slot returns integer
			return LoadInteger(HASH1,id,INDEX_BONUS_STAT+slot)
		endmethod

		static method setTypeBonusStatIndex takes integer id, integer slot, integer index returns nothing
			if slot == 0 or slot == 1 then
				call SaveInteger(HASH1,id,INDEX_BONUS_STAT+slot,index)
			endif
		endmethod

		static method getTierBorder takes integer v returns string
			return "Textures\\ability_border_tier"+I2S(v)+".blp"
		endmethod

		stub method iconClick takes nothing returns nothing
			local integer s = .smart
			if getTypeIsWeapon(.id) then
				call .owner.setWeaponAbility(this)
				call UI(GetPlayerId(.owner.owner)).refreshAbilityIconsTarget()
			elseif User.ENABLE_ABILITY_HOTKEY[GetPlayerId(.owner.owner)] > 0 then
				set .smart = 0
				call press()
				set .smart = s
			endif
		endmethod

		stub method iconRightClick takes nothing returns nothing
			if User.ENABLE_ABILITY_RIGHT_CLICK[GetPlayerId(.owner.owner)] > 0 then
				/*아이콘 어빌 우클릭 활성화상태*/
				if Ability.getTypeIsWeapon(.id) then
					/*무기 어빌리티 우클릭 > 무기 장착 해제*/
					if .owner.weapon_ability == this then
						call .owner.setWeaponAbility(0)
					endif
				else
					/*액티브 어빌리티 우클릭 > 스마트캐스트 설정*/
					call changeSmart(.smart + 1)
				endif
				call UI(GetPlayerId(.owner.owner)).refreshAbilityIconsTarget()
			else
				/*비활성화상태임(조합창에 올릴때 등 액션은 여기에 작성)*/
				call AbilityManager(GetPlayerId(.owner.owner)).abilityMixRegisterRequest(this,AbilityMixElement.TYPE_ABILITY)
			endif
		endmethod

		method servantTest takes nothing returns boolean
			return UnitClass(.owner).getClass(CONFIG_UNIT_CLASS_SUMMON) <= 0 and UnitClass(.owner).getClass(CONFIG_UNIT_CLASS_SERVANT) <= 0
		endmethod

		method plusBaseStatValue takes integer v returns nothing
			local integer ind1 = 0
			local integer ind2 = 0
			if getTypeTier(.id) <= 0 then
				return
			endif
			set ind1 = getTypeBonusStatIndex(.id,0)
			set ind2 = getTypeBonusStatIndex(.id,1)
			call .owner.plusBaseStatValue(ind1,v*STAT_NORMAL_VALUE[ind1]*getTypeTier(.id)*0.5)
			call .owner.plusBaseStatValue(ind2,v*STAT_NORMAL_VALUE[ind2]*getTypeTier(.id)*0.5)
			set .stat_bonus1 = .stat_bonus1 + v*STAT_NORMAL_VALUE[ind1]*getTypeTier(.id)*0.5
			set .stat_bonus2 = .stat_bonus2 + v*STAT_NORMAL_VALUE[ind2]*getTypeTier(.id)*0.5
		endmethod

		method addLevel takes integer v returns nothing
			if .level + v > .level_max then
				set v = .level_max - .level
			endif
			set .level = .level + v
			call plusBaseStatValue(v)
			call update(v)
		endmethod

		stub method deactivate takes nothing returns nothing

		endmethod

		method onDeath takes nothing returns nothing
			if getTypeTier(.id) > 0 then
				call .owner.plusBaseStatValue(getTypeBonusStatIndex(id,0),-.stat_bonus1)
				call .owner.plusBaseStatValue(getTypeBonusStatIndex(id,1),-.stat_bonus2)
			endif
			call deactivate()
			call UI(GetPlayerId(.owner.owner)).refreshAbilityIconsTarget()
		endmethod

		method sell takes nothing returns nothing
			call Unit(.owner).setUpgradePoint(CONFIG_UPGRADE_SKILL_POINT,Unit(.owner).getUpgradePoint(CONFIG_UPGRADE_SKILL_POINT)+getUpgradePoint(CONFIG_UPGRADE_SKILL_POINT))
			call Unit(.owner).setUpgradePoint(CONFIG_UPGRADE_LUCK,Unit(.owner).getUpgradePoint(CONFIG_UPGRADE_LUCK)+getUpgradePoint(CONFIG_UPGRADE_LUCK))
			call Unit(.owner).setUpgradePoint(CONFIG_UPGRADE_EXP,Unit(.owner).getUpgradePoint(CONFIG_UPGRADE_EXP)+getUpgradePoint(CONFIG_UPGRADE_EXP))
			call User.addGold(.owner.owner,getUpgradePoint(CONFIG_UPGRADE_GOLD))
			call kill()
		endmethod

		stub method executeAI takes nothing returns boolean
			return false
		endmethod

	endstruct

endlibrary

//! textmacro abilityDataEnd
	private function act takes nothing returns nothing
		local main a = 0
		if ABILITY_CREATE_ID == ID then
			set a = main.create()
			set ABILITY_LAST_CREATED = a
		endif
	endfunction

	private function init takes nothing returns nothing
		call TriggerAddCondition(ABILITY_CREATE_TRIGGER,function act)
		call Ability.setTypeIconPath(ID,ICON_PATH)
		call Ability.setTypeName(ID,NAME)
		call Ability.setTypeTier(ID,TIER)
		call Ability.setTypeCost(ID,COST)
		call Ability.setTypeBonusStatIndex(ID,0,STAT_BONUS1)
		call Ability.setTypeBonusStatIndex(ID,1,STAT_BONUS2)
		call Ability.setTypeIsWeapon(ID,IS_WEAPON)
		call Ability.setTypeMaxLevel(ID,10+TIER*5)
		if TAG1 != -1 then
			call DamageTag.add(ID,TAG1)
		endif
		if TAG2 != -1 then
			call DamageTag.add(ID,TAG2)
		endif
		if TAG3 != -1 then
			call DamageTag.add(ID,TAG3)
		endif
		if TAG4 != -1 then
			call DamageTag.add(ID,TAG4)
		endif
		call Ability.setTypeCastType(ID,CAST_TYPE)
		static if USE_DAMAGE_FLAG then
			call DamageFlag.def(ID,DamageFlag.INDEX_DAMAGE_TYPE,DAMAGE_TYPE)
			call DamageFlag.def(ID,DamageFlag.INDEX_ATTACK_TYPE,ATTACK_TYPE)
			call DamageFlag.def(ID,DamageFlag.INDEX_INTERVAL_TYPE,INTERVAL_TYPE)
			call DamageFlag.def(ID,DamageFlag.INDEX_VECTOR_TYPE,VECTOR_TYPE)
			call DamageFlag.def(ID,DamageFlag.INDEX_TARGET_TYPE,TARGET_TYPE)
			call DamageFlag.def(ID,DamageFlag.INDEX_AOE_TYPE,AOE_TYPE)
			call DamageFlag.def(ID,DamageFlag.INDEX_ONHIT_TYPE,ONHIT_TYPE)
			call DamageFlag.def(ID,DamageFlag.INDEX_RANGE_TYPE,RANGE_TYPE)
		endif
	endfunction
//! endtextmacro

//! textmacro abilitySetup
	static if IS_WEAPON then
		set .weapon_is_ranged = WEAPON_IS_RANGED
		set .weapon_delay = WEAPON_DELAY
		set .weapon_range = WEAPON_RANGE
	endif
	set .id = ID
	set .name = NAME
	set .icon = ICON_PATH
	set .level_max = Ability.getTypeMaxLevel(ID)
	set .drag_to_use = CAST_TYPE == CONFIG_CAST_TYPE_DRAG_TO_USE
	set .cooldown_max = COOLDOWN_MAX
	set .cooldown_min = COOLDOWN_MIN
	set .manacost = MANACOST
	// set .cast_range = RANGE
	call setUpgradePoint(CONFIG_UPGRADE_GOLD,0)
	call setUpgradePoint(CONFIG_UPGRADE_SKILL_POINT,0)
	call setUpgradePoint(CONFIG_UPGRADE_LUCK,0)
	call setUpgradePoint(CONFIG_UPGRADE_EXP,0)
	call plusBaseStatValue(5)
//! endtextmacro

//! import "AbilityData\\AbilityData.j"
//! import "Chingho.j"
//! import "AbilityMix.j"
//! import "AbilityTable.j"
//! import "GenericBuffs/GenericBuffs.j"