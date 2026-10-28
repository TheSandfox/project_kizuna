library InteractiveUnit requires Unit

	private struct data extends array

		boolean exists

	endstruct

	struct InteractiveUnit extends Unit

		static trigger MAIN_TRIGGER = null
		static integer COUNTER = 0

		static method adjustTrigger takes boolean flag returns nothing
			if flag then
				set .COUNTER = .COUNTER + 1
				if .COUNTER == 1 then
					call EnableTrigger(.MAIN_TRIGGER)
				endif
			else
				set .COUNTER = .COUNTER - 1
				if .COUNTER == 0 then
					call DisableTrigger(.MAIN_TRIGGER)
				endif
			endif
		endmethod

		stub method onInteract takes Unit caster returns nothing
			
		endmethod

		static method interact takes nothing returns nothing
			local thistype this = 0
			local Unit caster = 0
			if GetSpellAbilityId() != CONFIG_ABILITY_ID_INTERACT then
				return
			endif
			set caster = get(GetTriggerUnit())
			if caster <= 0 then
				return
			endif
			set this = get(GetSpellTargetUnit())
			if not data(this).exists then
				return
			endif
			call onInteract(caster)
		endmethod

		static method create takes player p, integer uid, real x, real y, real yaw returns thistype
			local thistype this = allocate(p,uid,x,y,yaw)
			call UnitAddAbility(.origin_unit,CONFIG_ABILITY_ID_CLASS_INTERACTIVE)
			call adjustTrigger(true)
			set data(this).exists = true
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			call adjustTrigger(false)
			set data(this).exists = false
		endmethod

		static method onInit takes nothing returns nothing
			set .MAIN_TRIGGER = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(.MAIN_TRIGGER,EVENT_PLAYER_UNIT_SPELL_EFFECT)
			call TriggerAddCondition(.MAIN_TRIGGER,function thistype.interact)
			call DisableTrigger(.MAIN_TRIGGER)
		endmethod

	endstruct

	struct Servant extends InteractiveUnit

		Unit caster = 0

		static method create takes Unit caster, integer uid, real x, real y, real yaw, integer level returns thistype
			local thistype this = allocate(caster.owner,uid,x,y,yaw)
			set .caster = caster
			call UnitClass(this).plusClass(ENUM_UNIT_CLASS_SERVANT)
			set .is_revive = true
			set .level = level
			call disableInteract()
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			call UnitClass(this).minusClass(ENUM_UNIT_CLASS_SERVANT)
		endmethod

	endstruct

endlibrary

//! import "ManggakAzae.j"
//! import "Fisher.j"
//! import "Lumberman.j"
//! import "Miner.j"