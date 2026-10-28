library Mine requires NPCUI

	private struct data extends array

		boolean occupied_true
		unit origin_unit

		method operator occupied takes nothing returns boolean
			return occupied_true
		endmethod

		method operator occupied= takes boolean b returns nothing
			set .occupied_true = b
		endmethod

		method hit takes nothing returns nothing
			call UnitDamageTarget(.origin_unit,.origin_unit,0.,false,false,ATTACK_TYPE_HERO,DAMAGE_TYPE_NORMAL,WEAPON_TYPE_METAL_LIGHT_CHOP)
			call Effect.create("Abilities\\Weapons\\Rifle\\RifleImpact.mdl",GetUnitX(.origin_unit),GetUnitY(.origin_unit),55.,0.).kill()
		endmethod

	endstruct

	private struct mining extends UnitActor

		static real ANIM_PERIOD = 1.

		integer mine_instance = 0
		real anim_timeout = 0.

		method killFilter takes nothing returns boolean
			return false
		endmethod

		method periodicAction takes nothing returns nothing
			set .anim_timeout = .anim_timeout + TIMER_TICK
			if .anim_timeout >= ANIM_PERIOD then
				/*애니메이션 재생*/
				call .caster.setAnim("attack")
				/*타격음*/
				call data(.mine_instance).hit()
				/**/
				set .anim_timeout = .anim_timeout - ANIM_PERIOD
			endif
		endmethod

		method onComplete takes nothing returns nothing
			set .duration = 3.
			set .timeout = 0.
			/*TODO MINING COMPLETE*/
		endmethod

		static method create takes Unit caster, real x, real y, integer instance returns thistype
			local thistype this = allocate(caster,0,x,y,0,3.,true)
			set .mine_instance = instance
			set .suspend_rclick = true
			set .suspend_stop = true
			call .caster.setAnim("attack")
			set data(.mine_instance).occupied = true
			call data(.mine_instance).hit()
			set .progress_bar = ProgressBar.create("채광하기...",.caster.owner)
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			call .caster.queueAnim("stand")
			set data(.mine_instance).occupied = false
		endmethod

	endstruct

	struct Mine extends NPC

		method operator occupied takes nothing returns boolean
			return data(this).occupied
		endmethod

		method operator occupied= takes boolean b returns nothing
			set data(this).occupied = b
		endmethod

		method onInteract takes Unit caster returns nothing
			if not .occupied then
				call mining.create(caster,.x,.y,this)
			else
				/*광산 사용중임*/
				call Error.show(caster.owner,"다른 유닛이 사용중입니다.")
			endif
		endmethod

		static method create takes integer uid, real x, real y, real yaw returns thistype
			local thistype this = allocate(uid,x,y,2.25)
			set .level = 10
			call BlzSetUnitFacingEx(.origin_unit,yaw)
			set .occupied = false
			set data(this).origin_unit = .origin_unit
			return this
		endmethod

		static method init takes nothing returns nothing
			call create('NS00',GetRectCenterX(gg_rct_NPCMine1),GetRectCenterY(gg_rct_NPCMine1),300.)
			call create('NS00',GetRectCenterX(gg_rct_NPCMine2),GetRectCenterY(gg_rct_NPCMine2),300.)
			call create('NS00',GetRectCenterX(gg_rct_NPCMine3),GetRectCenterY(gg_rct_NPCMine3),300.)
			call create('NS00',GetRectCenterX(gg_rct_NPCMine4),GetRectCenterY(gg_rct_NPCMine4),300.)
		endmethod

	endstruct

endlibrary