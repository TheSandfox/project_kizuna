//!Ability3000 기관총 난사
scope Ability3000 initializer init

		//! runtextmacro abilityDataHeader3000()
		
		globals
			private constant string EFFECT_PATH1 = "Effects\\Bullet.mdl"
			private constant string EFFECT_PATH2 = "Abilities\\Weapons\\Rifle\\RifleImpact.mdl"
		endglobals
	
		private struct bullet extends Missile

			method executeTarget takes Unit_prototype target returns nothing
				call damageTarget(target)
				call Effect.create(EFFECT_PATH2,target.x,target.y,target.z+target.pivot_z,270).setDuration(1.5)
			endmethod

			static method create takes Unit owner, real x, real y, real z, real yaw, integer level returns thistype
				local thistype this = allocate(owner,EFFECT_PATH1,x,y,z,yaw)
				local Effect ef
				set .velo = VELO
				set .damage = ( .owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*(level) )
				call setDamageFlagById(ID)
				call setCollision(RADIUS2)
				call setDuration((RANGE-STARTAT)/VELO)
				set .weapon_type = WEAPON_TYPE_METAL_LIGHT_CHOP
				set ef = Effect.create(EFFECT_PATH2,Math.pPX(.x,STARTAT,yaw),Math.pPY(.y,STARTAT,yaw),.z,270).setScale(1.5).setDuration(1.5)
				set ef.movement = Movement.create(ef,VELO*0.23,yaw)
				return this
			endmethod

		endstruct

		public struct actor extends UnitActor
	
			integer count = COUNT
			real angle = 0.
			real shoot = 0.
			Mover mover = 0

			method onComplete takes nothing returns nothing
				local bullet ms = 0
				if .count > 0 then
					set ms = bullet.create(.caster,/*
					*/Math.pPX(.caster.x,STARTAT,.angle),/*
					*/Math.pPY(.caster.y,STARTAT,.angle),.caster.pivot_z,/*
					*/.angle,.level)
				endif
			endmethod

			method periodicAction takes nothing returns nothing
				local bullet ms = 0
				set .shoot = .shoot + TIMER_TICK
				if .shoot >= INTERVAL and .count > 0 then
					set ms = bullet.create(.caster,/*
					*/Math.pPX(.caster.x,STARTAT,.angle),/*
					*/Math.pPY(.caster.y,STARTAT,.angle),.caster.pivot_z,/*
					*/.angle+GetRandomReal(-3,3),.level)
					set .caster.yaw = .angle
					set .count = .count - 1
					set .shoot = .shoot - INTERVAL
					if .count > 0 then
						call .caster.setAnim("stand")
						call .caster.setAnim("attack")
						call .caster.setAnimSpeed(3.)
					endif
				endif
			endmethod
	
			static method create takes Unit u, real x, real y, integer level returns thistype
				local thistype this = allocate(u,0,x,y,level,INTERVAL*COUNT,true)
				set .angle = Math.anglePoints(.caster.x,.caster.y,x,y)
				call .caster.setAnim("attack")
				call .caster.setAnimSpeed(3.)
				set .caster.yaw = .angle
				set .progress_bar = ProgressBar.create(NAME,.caster.owner)
				set .progress_bar.reverse = true
				set .mover = Mover.create(.caster)
				set .mover.refresh_facing = false
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .caster.queueAnim("stand ready")
				call .caster.setAnimSpeed(1.)
				call .mover.destroy()
			endmethod
	
		endstruct

		private struct ind extends LineIndicator

			method beforeRefresh takes nothing returns nothing
				set .x = .abil.owner.x
				set .y = .abil.owner.y
				set .yaw = Math.anglePoints(.x,.y,Mouse.getVX(owner),Mouse.getVY(owner))
				set .range = RANGE
				set .width = RADIUS2
			endmethod

			static method create takes Ability_prototype abil, player owner returns thistype
				local thistype this = allocate(abil,owner)
				return this
			endmethod

		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip3000()

			method execute takes nothing returns nothing
				local actor a = actor.create(.owner,.command_x,.command_y,level)
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .preserve_order = true
				set .indicator = ind.create(this,.owner.owner)
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"다수의 투사체 연사")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Buff3010 감속(버프)
scope Buff3010 initializer init
	
	//! runtextmacro buffDataHeader3010()

	public struct main extends Buff

		static constant string EFFECT_PATH1 = "Abilities\\Spells\\Human\\slow\\slowtarget.mdl"

		integer val1 = 0
		real val2 = 0.

		method relativeTooltip takes nothing returns string
			return "이동속도와 회피치가 감소했습니다."
		endmethod

		method addValue takes integer level returns nothing
			call .target.minusStatValue(CONFIG_STAT_MOVEMENT_SPEED,DATA_INTEGER1)
			call .target.plusStatValue(CONFIG_STAT_EVASION,(.caster.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1) * (1+DAMAGE_PER_LEVEL*(level)) )
			set .val1 = .val1 + DATA_INTEGER1
			set .val2 = .val2 + (.caster.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1) * (1+DAMAGE_PER_LEVEL*(level))
		endmethod

		method update takes nothing returns boolean
			return true
		endmethod

		method init takes nothing returns boolean
			call addEffect(Effect.createAttatched(EFFECT_PATH1,.target.origin_unit,"origin"))
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call .target.minusStatValue(CONFIG_STAT_MOVEMENT_SPEED,-val1)
			call .target.plusStatValue(CONFIG_STAT_EVASION,-val2)
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

//!Ability3010 감속
scope Ability3010 initializer init

	//! runtextmacro abilityDataHeader3010()
	
	globals
		private constant string EFFECT_PATH1 = "Abilities\\Spells\\Human\\slow\\slowtarget.mdl"
		private constant string EFFECT_PATH2 = "Abilities\\Spells\\Human\\Slow\\SlowCaster.mdl"
		private constant string EFFECT_PATH3 = "Abilities\\Spells\\Orc\\Disenchant\\DisenchantSpecialArt.mdl"
	endglobals

	public struct explosion extends Explosion

		Circle c = 0
		Effect ef = 0

		integer level = 0

		method beforeExplosion takes nothing returns nothing
			local Effect e = Effect.create(EFFECT_PATH3,.x,.y,GetRandomReal(2,55),270)
			call e.setDuration(1.25)
			call e.setScale(GetRandomReal(1.5,3))
		endmethod

		method executeExplosion takes Unit_prototype target returns nothing
			local Effect e = Effect.create(EFFECT_PATH2,target.x,target.y,target.z+target.pivot_z,270)
			local Buff bf = 0
			call e.setDuration(1.5)
			if IsUnitInGroup(target.origin_unit,.group_wave) then
				set .onhit_type = Damage.ONHIT_TYPE_NONHIT
			else
				set .onhit_type = Damage.ONHIT_TYPE_ONHIT
			endif
			set bf = Buff.add(.owner,target,ID,.level,DURATION)
			call bf.addValue(.level)
			call damageTarget(target)
		endmethod

		static method create takes Unit caster, real x, real y, real rad, integer level returns thistype
			local thistype this = allocate(caster,x,y,rad)
			set .level = level
			set .interval = INTERVAL
			call setDamageFlagById(ID)
			set .count = COUNT
			set .c = Circle.create(.x,.y,2.,RADIUS3)
			call .c.setColor(255,R2I(255*0.9),0)
			call .c.setAlpha(0)
			call .c.fadeIn(0.45)
			set .ef = Effect.create(EFFECT_PATH1,.x,.y,2.,270)
			call .ef.setScale(2.5)
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			call .c.setFadeOutPoint(0.01,0.75)
			set .c = 0
			call .ef.kill()
		endmethod

	endstruct

	public struct actor extends UnitActor

		method onComplete takes nothing returns nothing
			local explosion ex = explosion.create(.caster,.x,.y,RADIUS3,.level)
			set ex.damage = ( .caster.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*(.level) )
			call ex.activate()
		endmethod

		static method create takes Unit caster, real x, real y, integer level returns thistype
			local thistype this = allocate(caster,0,x,y,level,CAST,true)
			call SetUnitFacing(.caster.origin_unit,Math.anglePoints(.caster.x,.caster.y,x,y))
			call .caster.setAnim("attack")
			call .caster.setAnimSpeed(2.)
			set .progress_bar = ProgressBar.create(NAME,.caster.owner)
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			call .caster.queueAnim("stand ready")
			call .caster.setAnimSpeed(1.)
		endmethod

	endstruct

	private struct ind extends AbilityIndicator

		Effect c = 0

		method refresh takes nothing returns nothing
			call .c.setPosition(Mouse.getVX(.owner),Mouse.getVY(.owner),2.)
		endmethod

		method show takes boolean flag returns nothing
			if flag then
				if GetLocalPlayer() == .owner then
					call .c.setLocalAlpha(192)
				endif
			else
				call .c.setLocalAlpha(0)
			endif
		endmethod

		static method create takes Ability_prototype abil, player owner returns thistype
			local thistype this = allocate(abil,owner)
			set .c = Effect.create("Effects\\RCircle.mdl",0.,0.,2.,270.)
			call .c.setScale(RADIUS3/100.)
			call .c.setLocalAlpha(0)
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			call .c.destroy()
		endmethod

	endstruct

	public struct main extends Ability

		//! runtextmacro abilityTooltip3010()

		method execute takes nothing returns nothing
			local actor a = actor.create(.owner,.command_x,.command_y,level)
		endmethod

		method init takes nothing returns nothing
			//! runtextmacro abilitySetup()
			set .is_active = true
			set .cast_range = RANGE
			set .indicator = ind.create(this,.owner.owner)
			
		endmethod

		static method onInit takes nothing returns nothing
			call Ability.setTypeTooltip(ID,"이동속도, 회피치\n감소 영역 전개")
		endmethod

	endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability3020 착취의 보옥
scope Ability3020 initializer init

	//! runtextmacro abilityDataHeader3020()
	
	globals
		private constant real ANIM_DURATION = 0.75
		private constant string EFFECT_PATH1 = "Abilities\\Spells\\Other\\Drain\\DrainTarget.mdl"
		private constant string EFFECT_PATH2 = "Abilities\\Spells\\Other\\Drain\\DrainCaster.mdl"
	endglobals

	public struct actor extends UnitActor

		implement DamageFlag

		Lightning l = 0
		Effect ef1 = 0
		Effect ef2 = 0
		real play = 0.
		boolean cancle = false
		trigger main_trigger = null
		triggercondition main_cond = null
		integer onhit_counter = 0

		method periodicAction takes nothing returns nothing
			set .play = .play + TIMER_TICK
			if .play >= ANIM_DURATION then
				call .caster.queueAnim("attack")
				call .caster.setAnimSpeed(ANIM_DURATION)
				set .play = .play - ANIM_DURATION
			endif
		endmethod

		method suspendFilterAdditional takes nothing returns boolean
			if Math.distancePoints(.caster.x,.caster.y,.target.x,.target.y) > RANGE then
				return true
			elseif .target.isUnitType(UNIT_TYPE_DEAD) then
				return true
			elseif .cancle then
				return true
			else
				return false
			endif
		endmethod

		static method weaponChange takes nothing returns nothing
			local thistype this = Trigger.getData(GetTriggeringTrigger())
			if CUSTOM_RESPOND_WEAPON_CHANGE_UNIT != .owner then
				return
			endif
			if CUSTOM_RESPOND_WEAPON_CHANGE_OLD != CUSTOM_RESPOND_WEAPON_CHANGE_NEW then
				set .cancle = true
			endif
		endmethod

		method killFilter takes nothing returns boolean
			set .duration = .duration + INTERVAL
			set .timeout = 0.
			return false
		endmethod

		method onComplete takes nothing returns nothing
			local Ability a = .caster.getAbilityById(ID)
			if a > 0 then
				if a.value < DATA_INTEGER1 then
					call .caster.healUnit(.caster,.damage*DATA_REAL1)
				else
					call .caster.healUnit(.caster,.damage*DATA_REAL1*DATA_REAL2)
				endif
				set .onhit_counter = .onhit_counter + 1
				if .onhit_counter >= DATA_INTEGER2 then
					set .onhit_type = Damage.ONHIT_TYPE_ONHIT
					set .onhit_counter = 0
				else
					set .onhit_type = Damage.ONHIT_TYPE_NONHIT
				endif
				call damageTarget(.target)
				call a.addValue(1)
			endif
		endmethod

		static method create takes Unit caster, Unit target, integer level returns thistype
			local thistype this = allocate(caster,target,0,0,level,INTERVAL,true)
			set .l = Lightning.createOO("DRAL",.caster,.target)
			set .l.oz1 = .caster.pivot_z
			set .l.oz2 = .target.pivot_z
			call .l.refreshPosition()
			set .ef1 = Effect.createAttatched(EFFECT_PATH1,.caster.origin_unit,"chest")
			set .ef2 = Effect.createAttatched(EFFECT_PATH2,.target.origin_unit,"chest")
			set .suspend_rclick = true
			set .suspend_ability = true
			set .suspend_stop = true
			call SetUnitFacing(.caster.origin_unit,Math.anglePoints(.caster.x,.caster.y,.target.x,.target.y))
			call .caster.setAnim("attack")
			call .caster.setAnimSpeed(1.)
			set .damage = ( .owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*(.level) )
			call setDamageFlagById(ID)
			set .main_trigger = Trigger.new(this)
			set .main_cond = TriggerAddCondition(.main_trigger,function thistype.weaponChange)
			call Event.register(.main_trigger,CONFIG_EVENT_WEAPON_CHANGE)
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			//! runtextmacro destroyTriggerAndCondition(".main_trigger",".main_cond")
			call .l.destroy()
			call .ef1.kill()
			call .ef2.kill()
			call .caster.queueAnim("stand ready")
			call .caster.setAnimSpeed(1.)
		endmethod

	endstruct

	public struct main extends Ability

		trigger main_trigger = null
		triggercondition main_cond = null

		//! runtextmacro abilityTooltip3020()

		method addValue takes integer v returns nothing
			set .value = .value + v
			if .value >= DATA_INTEGER1 then
				set .value = DATA_INTEGER1
			elseif .value <= 0 then
				set .value = 0
			endif
			set .gauge = I2R(.value) / I2R(DATA_INTEGER1)
		endmethod

		static method cond takes nothing returns nothing
			local thistype this = Trigger.getData(GetTriggeringTrigger())
			if CUSTOM_RESPOND_DAMAGE_ATTACKER != .owner then
				return
			endif
			if CUSTOM_RESPOND_DAMAGE_ATTACK_TYPE != Damage.ATTACK_TYPE_SPELL then
				return
			endif
			if .value > 0 then
				set CUSTOM_RESPOND_DAMAGE_PLUS = CUSTOM_RESPOND_DAMAGE_PLUS + ( .owner.getCarculatedStatValue(DAMAGE_STAT2) * DAMAGE_AMPLIFIER2 ) * ( 1+DAMAGE_PER_LEVEL*(.level) ) * .value
				set .value = 0
				set .gauge = 0.
			endif
		endmethod

		method basicAttack takes Unit target returns nothing
			local actor a = actor.create(.owner,target,level)
		endmethod

		method deactivate takes nothing returns nothing
			//! runtextmacro destroyTriggerAndCondition(".main_trigger",".main_cond")
		endmethod

		method init takes nothing returns nothing
			set .main_trigger = Trigger.new(this)
			set .main_cond = TriggerAddCondition(.main_trigger,function thistype.cond)
			call Event.register(.main_trigger,CONFIG_EVENT_DAMAGE_MODIFY)
			//! runtextmacro abilitySetup()
			
		endmethod

		static method onInit takes nothing returns nothing
			call Ability.setTypeTooltip(ID,"정신집중하여 생명력 흡수\n")
		endmethod

	endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Buff3030 전격 구체(버프)
scope Buff3030 initializer init

	//! runtextmacro buffDataHeader3030()

	public struct main extends Buff

		real v1 = 0.

		method relativeTooltip takes nothing returns string
			return "이동속도가 증가했습니다."
		endmethod

		method intervalAction takes nothing returns nothing
			if .v1 > DATA_REAL2 then
				set .v1 = .v1 - DATA_REAL2
				call .target.multiplyStatValue(CONFIG_STAT_MOVEMENT_SPEED,-DATA_REAL2)
			else
				call .target.multiplyStatValue(CONFIG_STAT_MOVEMENT_SPEED,-.v1)
				set .v1 = 0.
				set .want_kill = true
			endif
		endmethod

		method init takes nothing returns boolean
			set .v1 = DATA_REAL1
			call .target.multiplyStatValue(CONFIG_STAT_MOVEMENT_SPEED,.v1)
			set .interval = DATA_REAL3

			return true
		endmethod

		method onDestroy takes nothing returns nothing
			if .v1 > 0. then
				call .target.multiplyStatValue(CONFIG_STAT_MOVEMENT_SPEED,-.v1)
				set .v1 = 0.
			endif
		endmethod

	endstruct

	//! runtextmacro buffEnd()

endscope

//!Ability3030 전격 구체
scope Ability3030 initializer init

		//! runtextmacro abilityDataHeader3030()
		
		globals
			private constant string EFFECT_PATH1 = "Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl"
			private trigger MY_RESPOND = CreateTrigger()
			private Unit MY_RESPOND_TARGET = 0 
			private Ability MY_RESPOND_ABILITY = 0
		endglobals

		public struct additional extends Missile

			Lightning l = 0

			static method create takes Unit caster, Unit target, real x, real y, integer level returns thistype
				local real a = Math.anglePoints(x,y,target.x,target.y)
				local real a2 = Math.anglePoints(caster.x,caster.y,target.x,target.y)
				local thistype this = allocate(caster,EFFECT_PATH1,x,y,55,a)
				local real dist = Math.distancePoints(caster.x,caster.y,x,y)
				local real val = 0.
				if dist > DATA_REAL1 then
					set dist = DATA_REAL1
				endif
				call setDamageFlagById(ID)
				set .velo = VELO
				call setTarget(target)
				set val = (DAMAGE_SECONDARY - DAMAGE_PRIMARY) * (dist/DATA_REAL1) + DAMAGE_PRIMARY
				set .damage = (.owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1) * (1+DAMAGE_PER_LEVEL*(level)) * val
				set .l = Lightning.create("CLSB",.owner.x,.owner.y,55.,0,0,0)
				call .l.setTarget2(this)
				call .l.refreshPosition()
				set .weapon_type = WEAPON_TYPE_METAL_MEDIUM_BASH
				call setScale(1.5)
				/*커브*/
				set .curve = CurveBezier3.create(.x,.y,.z,.target.x,.target.y,.target.z+.target.pivot_z)
				call .curve.setX(Curve.POINT_MIDDLE,Math.pPX(.owner.x,-600+dist/2,a2))
				call .curve.setY(Curve.POINT_MIDDLE,Math.pPY(.owner.y,-600+dist/2,a2))
				call .curve.setZ(Curve.POINT_MIDDLE,450.+dist/2)
				call .curve.setX(Curve.POINT_MIDDLE+1,.owner.x)
				call .curve.setY(Curve.POINT_MIDDLE+1,.owner.y)
				call .curve.setZ(Curve.POINT_MIDDLE+1,600.+dist/2)
				set .curve.overtime = 0.5
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .l.destroy()
				set .l = 0
			endmethod

		endstruct

		public struct missile extends Missile

			static method create takes Unit caster, Unit target, integer level returns thistype
				local real a = Math.anglePoints(caster.x,caster.y,target.x,target.y)
				local thistype this = allocate(caster,EFFECT_PATH1,Math.pPX(caster.x,STARTAT,a),Math.pPY(caster.y,STARTAT,a),caster.pivot_z,a)
				call setDamageFlagById(ID)
				set .velo = VELO
				set .damage = (.owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1) * (1+DAMAGE_PER_LEVEL*(level))
				set .weapon_type = WEAPON_TYPE_METAL_MEDIUM_BASH
				call setTarget(target)
				return this
			endmethod

		endstruct
	
		public struct actor extends MeleeAttack

			method onComplete takes nothing returns nothing
				local Ability a = .caster.getAbilityById(ID)
				call missile.create(.caster,.target,.level)
				call Backswing.create(.caster)
				if a > 0 then
					set MY_RESPOND_ABILITY = a
					set MY_RESPOND_TARGET = .target
					call TriggerEvaluate(MY_RESPOND) 
				endif
				call Buff.add(.caster,.caster,ID,.level,1.)
			endmethod
	
			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target)
				call setDamagePoint(0.1)
				set .level = level
				return this
			endmethod

		endstruct
	
		public struct main extends Ability

			timer orb_timer = null
			real orb_lifespan = 0.
			Effect orb_effect = 0
			Lightning orb_lightning = 0

			method removeOrb takes nothing returns nothing
				if .orb_effect > 0 then
					call .orb_effect.kill()
				endif
				if .orb_lightning > 0 then
					call .orb_lightning.destroy()
				endif
				set .orb_lightning = 0
				set .orb_effect = 0
				call Timer.pause(.orb_timer)
			endmethod

			static method orbTimer takes nothing returns nothing
				local thistype this = Timer.getData(GetExpiredTimer())
				if .orb_lifespan > 0. then
					set .orb_lifespan = .orb_lifespan - TIMER_TICK
					if .orb_lifespan <= 0. then
						call removeOrb()
					endif
				endif
			endmethod

			method createOrb takes nothing returns nothing
				if .orb_effect > 0 then
					call .orb_effect.kill()
					call .orb_lightning.destroy()
				endif
				set .orb_effect = Effect.create(EFFECT_PATH1,.owner.x,.owner.y,55.,0.)
				set .orb_lightning = Lightning.createOO("CLSB",.owner,.orb_effect)
				set .orb_lifespan = DURATION
				call Timer.start(.orb_timer,TIMER_TICK,true,function thistype.orbTimer)
			endmethod

			method respond takes Unit target returns nothing
				if target > 0 and .orb_effect > 0 then
					call additional.create(.owner,target,.orb_effect.x,.orb_effect.y,.level)
				endif
				call removeOrb()
				call createOrb()
			endmethod

			static method customRespond takes nothing returns nothing
				local thistype this = MY_RESPOND_ABILITY
				if MY_RESPOND_ABILITY <= 0 then
					return
				endif
				call respond(MY_RESPOND_TARGET)
			endmethod

			//! runtextmacro abilityTooltip3030()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
				//
				set .orb_timer = Timer.new(this)
			endmethod

			method deactivate takes nothing returns nothing
				call removeOrb()
				call Timer.release(.orb_timer)
				set .orb_timer = null
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"전격 구체 투척")
				//
				call TriggerAddCondition(MY_RESPOND,function thistype.customRespond)
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability3040 바람 칼날
scope Ability3040 initializer init

		//! runtextmacro abilityDataHeader3040()
		
		globals
			private constant string EFFECT_PATH1 = "Effects\\Windblade_Large.mdl"
		endglobals

		public struct missile extends Missile

			static method create takes Unit caster, Unit target, integer level returns thistype
				local real a = Math.anglePoints(caster.x,caster.y,target.x,target.y)
				local thistype this = allocate(caster,EFFECT_PATH1,Math.pPX(caster.x,STARTAT,a),Math.pPY(caster.y,STARTAT,a),caster.pivot_z,a)
				call setDamageFlagById(ID)
				set .velo = VELO
				set .damage = (.owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1) * (1+DAMAGE_PER_LEVEL*(level))
				set .weapon_type = WEAPON_TYPE_METAL_LIGHT_CHOP
				call setScale(1.25)
				call setRoll(GetRandomReal(-15,15))
				call setTarget(target)
				return this
			endmethod

		endstruct

		public struct dolzin extends Charge

			static method create takes Unit caster, Unit target returns thistype
				local real d = 0.
				//! runtextmacro chargeAllocate("caster","DATA_REAL3","Math.anglePoints(caster.x,caster.y,target.x,target.y)")
				set d = Math.distancePoints(caster.x,caster.y,target.x,target.y)-DATA_REAL2
				call setTargetLocation(/*
					*/Math.pPX(.caster.x,d,Math.anglePoints(caster.x,caster.y,target.x,target.y)),/*
					*/Math.pPY(.caster.y,d,Math.anglePoints(caster.x,caster.y,target.x,target.y)),/*
					*/0./*
				*/)
				set .duration = d/VELO
				set .use_collision = false
				return this
			endmethod

		endstruct
	
		public struct actor extends MeleeAttack

			method onComplete takes nothing returns nothing
				local Ability a = .caster.getAbilityById(ID)
				call missile.create(.caster,.target,.level)
				call Backswing.create(.caster)
			endmethod
	
			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target)
				local real dist = Math.distancePoints(.caster.x,.caster.y,.target.x,.target.y)
				set .level = level
				/*거리재기*/
				if dist > DATA_REAL1 then
					if dolzin.create(.caster,.target) <= 0 then
						/*돌진 못함*/
						call .caster.setAnim("stand ready")
						call .caster.recoverAttackDelay(true)
						call destroy()
						return 0
					endif
				endif
				/*거리 가까우면 돌진 못해도 때리기*/
				return this
			endmethod

		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip3040()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
			endmethod

			method deactivate takes nothing returns nothing

			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"바람 칼날 사출")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability3050 강철 군마
scope Ability3050 initializer init

		//! runtextmacro abilityDataHeader3050()

		globals
			private constant string EFFECT_PATH1 = "Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl"
			private constant real SUMMON_COOLDOWN = 3.5
			private integer HORSE_ABILITY_INDEX = 1
		endglobals
	
		private struct ride extends Riding

			static method create takes Unit caster, Unit target returns thistype
				//! runtextmacro ridingAllocate("caster","target","0","ID")
				call setPosition(75.,0.,-90)
				call .target.plusStatValue(CONFIG_STAT_MOVEMENT_SPEED,DATA_INTEGER1)
				call .caster.plusStatus(CONFIG_STATUS_DUMMY)
				call .caster.plusStatus(CONFIG_STATUS_HIDE)
				call .caster.plusStatus(CONFIG_STATUS_EVASION)
				set .id = ID
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .target.plusStatValue(CONFIG_STAT_MOVEMENT_SPEED,-DATA_INTEGER1)
				call .caster.minusStatus(CONFIG_STATUS_DUMMY)
				call .caster.minusStatus(CONFIG_STATUS_HIDE)
				call .caster.minusStatus(CONFIG_STATUS_EVASION)
			endmethod

		endstruct

		private struct horse extends Servant
		
			method onInteract takes Unit caster returns nothing
				if .owner == caster.owner and not isUnitType(UNIT_TYPE_DEAD) then
					call ride.create(caster,this)
				endif
			endmethod

			static method create takes Unit caster, integer uid, real x, real y, real yaw, integer level returns thistype
				local thistype this = allocate(caster,uid,x,y,yaw,level)
				return this
			endmethod

		endstruct

		public struct main extends Ability

			timer summon_timer = null
			real summon_cooldown = 0.
			ExtraAbilityIcon ex_icon = 0

			static method summonTimer takes nothing returns nothing
				local thistype this = Timer.getData(GetExpiredTimer())
				set .summon_cooldown = .summon_cooldown - TIMER_TICK
				set .gauge = .summon_cooldown / SUMMON_COOLDOWN
				if .summon_cooldown <= 0. then
					call Timer.pause(.summon_timer)
				endif
			endmethod

			method runSummonCooldown takes nothing returns nothing
				if .servant <= 0 then
					return
				endif
				set .summon_cooldown = SUMMON_COOLDOWN
				call Timer.start(.summon_timer,TIMER_TICK,true,function thistype.summonTimer)
			endmethod

			//! runtextmacro abilityTooltip3050()

			method execute takes nothing returns nothing
				if .servant <= 0 then
					return
				endif
				/*if Riding.getByCaster(.owner) > 0 then
					if Riding.getByCaster(.owner).target == .servant then
						call Riding.getByCaster(.owner).destroy()
					endif
				else*/
					if .servant > 0 then
						if .command_target != null then
							if .command_target == .owner.origin_unit then
								/*자기자신=군마소환*/
								if Riding.getByCaster(.owner).target != .servant then
									/*탑승물이 군마가 아닐 때*/
									if .summon_cooldown <= 0. and not .servant.isUnitType(UNIT_TYPE_DEAD) then
										call summonHorse()
										call runSummonCooldown()
									endif
								endif
							elseif .command_target == .servant.origin_unit then
								/*군마=군마탑승*/
								if Riding.getByCaster(.owner) <= 0 then
									call .owner.issueTargetOrder(CONFIG_ORDER_STRING_INTERACT,.servant.origin_unit)
									call .servant.issueTargetOrder("smart",.owner.origin_unit)
								endif
							else
								/*나머지=그냥팔로잉*/
								call .servant.issueTargetOrder("smart",.command_target)
							endif
						else
							/*맨땅찍음*/
							if .smart == 1 then
								/*사거리표시면 자동공격 안함*/
								call .servant.issuePointOrder(CONFIG_ORDER_STRING_CUSTOM_MOVE,.command_x,.command_y)
							elseif .smart == 2 then
								/*즉시시전이면 자동공격 함*/
								call .servant.issuePointOrder("move",.command_x,.command_y)
							endif
							call Mouse.customClick(.owner.owner,.servant,null,MOUSE_BUTTON_TYPE_RIGHT,.command_x,.command_y)
						endif
					endif
				/*endif*/
			endmethod

			method killHorse takes nothing returns nothing
				if .servant > 0 then
					call .servant.unSummon()
				endif
				set .servant = 0
				if .ex_icon > 0 then
					call .ex_icon.destroy()
				endif
				set .ex_icon = 0
			endmethod

			method summonHorse takes nothing returns boolean
				local real nx = Math.pPX(.owner.x,55.,.owner.yaw)
				local real ny = Math.pPY(.owner.y,55.,.owner.yaw)
				if .servant <= 0 then
					if servantTest() then
						set .servant = horse.create(.owner,UNIT_ID1,nx,ny,.owner.yaw,.level)
					else
						return false
					endif
				endif
				call .servant.setPosition(nx,ny)
				call Effect.create(EFFECT_PATH1,.servant.x,.servant.y,.servant.z,270.).kill()
				return true
			endmethod

			method iconClick takes nothing returns nothing
				/*SHIFT CLICK = 군마스킬사용*/
				if .servant <= 0 then
					return
				endif
				call .servant.getAbility(HORSE_ABILITY_INDEX).useRequest(Mouse.getX(.owner.owner),Mouse.getY(.owner.owner),null,true)
			endmethod

			method update takes integer v returns nothing
				if .servant <= 0 then
					return
				endif
				set .servant.level = .level
			endmethod

			static method mR takes nothing returns nothing
				local thistype this = Trigger.getData(GetTriggeringTrigger())
				if CUSTOM_RESPOND_KEYPRESS_KEY == OSKEY_K then
					if .servant <= 0 then
						return
					endif
					call .servant.kill()
				endif
			endmethod

			method init takes nothing returns nothing
				local trigger t = null
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .is_target = true
				set .is_freetarget = true
				set .is_immediate = true
				set .useable_cast = true
				set .useable_dead = true
				set .preserve_order = true
				set .indicator = AbilityIndicator.create(this,.owner.owner)
				set .force_smart = true
				set .smart = 2
				set .activate_event = false
				
				/*군마소환*/
				set .summon_timer = Timer.new(this)
				if summonHorse() then
					/*아이콘 생성*/
					set .ex_icon = ExtraAbilityIcon.create(.owner.owner,.servant.getAbility(HORSE_ABILITY_INDEX))
				endif
				/*임시*/
				static if CONFIG_DEBUG then
					//set t = Trigger.new(this)
					//call Event.register(t,CONFIG_EVENT_KEYPRESS)
					//call TriggerAddCondition(t,function thistype.mR)
					//call BlzTriggerRegisterPlayerKeyEvent(User.KEYPRESS[0],Player(0),OSKEY_K,0,true)
					//call BlzTriggerRegisterPlayerKeyEvent(User.KEYPRESS[0],Player(0),OSKEY_K,0,false)
				endif
			endmethod

			method deactivate takes nothing returns nothing
				/*군마제거*/
				call killHorse()
				call Timer.release(.summon_timer)
				set .summon_timer = null				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"탑승용 군마 소환")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability3060 갈고리 던지기
scope Ability3060 initializer init

		//! runtextmacro abilityDataHeader3060()
		
		globals
			private constant string EFFECT_PATH1 = "Effects\\Galgori.mdl"
			private constant string EFFECT_PATH2 = "Effects\\Chain.mdl"
			private constant real CHAIN_EXPAND = 0.03	/*체인 연장 간격*/
			private constant real CHAIN_SCALE = 1.65
		endglobals

		private struct spin extends UnitActor

			method periodicAction takes nothing returns nothing
				set .caster.yaw = .caster.yaw + 3.* 360. * TIMER_TICK
				set .duration = 99.
			endmethod

			static method create takes Unit caster returns thistype
				local thistype this = allocate(caster,0,0.,0.,0,99.,false)
				return this
			endmethod

		endstruct

		private struct puush extends Knockback

			spin sp = 0
			Chain ch = 0

			static method create takes Unit caster, real velo, real angle, Chain ch returns thistype
				//! runtextmacro knockbackAllocate("caster","(velo-DATA_REAL3)/DATA_REAL2","angle")
				if .velo < 0. then
					set .velo = 0.
				endif
				set .ch = ch
				set .sp = spin.create(caster)
				call .sp.suspendFree()
				call Effect.create(EF_ROCK,caster.x,caster.y,0.,270.).kill()
				set .z_velo = 550.+(.velo*0.3)
				set .gravity = (.z_velo*2)/DATA_REAL2
				set .duration = DATA_REAL2+TIMER_TICK
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .ch.destroy()
				call .sp.destroy()
			endmethod

		endstruct

		private struct grrab extends Grabbing

			Chain ch = 0

			method onComplete takes nothing returns nothing
				/*밀치기 성공 시에만 체인 승계*/
				if puush.create(.target,Math.distancePoints(.target.x,.target.y,.caster.x,.caster.y)-STARTAT,Math.anglePoints(.target.x,.target.y,.caster.x,.caster.y),.ch) > 0 then
					set .ch = 0
				endif
			endmethod

			static method create takes Unit caster, Unit target, Chain nc returns thistype
				//! runtextmacro grabbingAllocate("caster","target","0","ID","false")
				set .refresh_position = false
				set .ch = nc
				call .ch.setCaster(caster)
				call .ch.setTarget(target)
				set .duration = DATA_REAL1
				call .caster.setAnimSpeed(2.0)
				call .caster.plusStatus(CONFIG_STATUS_CAST)
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				if .ch > 0 then
					call .ch.destroy()
				endif
				call .caster.setAnimSpeed(1.0)
				call .caster.queueAnim("stand ready")
				call .caster.minusStatus(CONFIG_STATUS_CAST)
			endmethod

		endstruct
		
		public struct hoook extends Missile

			Chain ch = 0

			real timeout = 0.
			boolean continue = false

			method periodicAction takes nothing returns nothing
				if .ch <= 0 then
					return
				endif
				set .timeout = .timeout + TIMER_TICK
				if .timeout >= CHAIN_EXPAND then
					set .timeout = .timeout - CHAIN_EXPAND
					call .ch.add(Effect.create(EFFECT_PATH2,0,0,0,0).setScale(CHAIN_SCALE))
				endif
				call .ch.progressLength(-2.*TIMER_TICK)
			endmethod

			method executeTarget takes Unit target returns nothing
				local grrab gr = grrab.create(.origin_owner,target,.ch)
				call Effect.create(EF_BLOOD,target.x,target.y,target.z+target.pivot_z,270.).kill()
				call damageTarget(target)
				if gr > 0 then
					/*잡혔음*/
					/*체인 인수인계*/
					set .ch = 0
					set .continue = true
				else
					/*잡기에 실패했음*/
				endif
			endmethod

			static method create takes Unit caster, real angle, integer level returns thistype
				local thistype this = allocate(caster,EFFECT_PATH1,Math.pPX(caster.x,STARTAT,angle),Math.pPY(caster.y,STARTAT,angle),caster.pivot_z,angle)
				set .damage = .owner.getCarculatedStatValue(DAMAGE_STAT1)*DAMAGE_AMPLIFIER1*(1+DAMAGE_PER_LEVEL*(level))
				call setDamageFlagById(ID)
				set .weapon_type = WEAPON_TYPE_METAL_MEDIUM_BASH
				call setCollision(RADIUS2)
				set .velo = VELO
				call setDuration((RANGE-STARTAT)/VELO)
				call setScale(1.35)
				/*체인*/
				set .ch = Chain.create(CurveLinear.create(caster.x,caster.y,caster.pivot_z,0,0,0))
				call .ch.setCaster(.owner)
				call .ch.setTarget(this)
				call .ch.skipBirthAnim(true)
				call .ch.add(Effect.create(EFFECT_PATH2,0,0,0,0).setScale(CHAIN_SCALE))
				call .ch.add(Effect.create(EFFECT_PATH2,0,0,0,0).setScale(CHAIN_SCALE))
				call .ch.refreshEffectsPosition()
				/*행동 정지*/
				call .owner.plusStatus(CONFIG_STATUS_CAST)
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				if .ch > 0 then
					call .ch.destroy()
				endif
				if not .continue then
					/*잡기에 실패했을 때만 애니메이션 복구*/
					call .owner.setAnimSpeed(1.0)
					call .owner.queueAnim("stand ready")
				endif
				call .owner.minusStatus(CONFIG_STATUS_CAST)
			endmethod

		endstruct

		public struct actor extends UnitActor

			real angle = 0.

			method onComplete takes nothing returns nothing
				call hoook.create(.caster,.angle,.level)
			endmethod

			static method create takes Unit caster, real x, real y, integer level returns thistype
				local thistype this = allocate(caster,0,x,y,level,0.25,true)
				call .caster.setAnim("attack")
				set .angle = Math.anglePoints(.caster.x,.caster.y,x,y)
				call SetUnitFacing(.caster.origin_unit,.angle)
				set .progress_bar = ProgressBar.create(NAME,.caster.owner)
				return this
			endmethod

		endstruct

		private struct ind extends LineIndicator

			method beforeRefresh takes nothing returns nothing
				set .x = .abil.owner.x
				set .y = .abil.owner.y
				set .yaw = Math.anglePoints(.x,.y,Mouse.getVX(owner),Mouse.getVY(owner))
				set .range = RANGE+RADIUS2
				set .width = RADIUS2
			endmethod

			static method create takes Ability_prototype abil, player owner returns thistype
				local thistype this = allocate(abil,owner)
				call .ef.setColor(128,128,128)
				call .circle.setColor(128,128,128)
				return this
			endmethod

		endstruct

		public struct main extends Ability

			//! runtextmacro abilityTooltip3060()

			method execute takes nothing returns nothing
				/*TODO CREATE MISSLE*/
				call actor.create(.owner,.command_x,.command_y,.level)
			endmethod

			method beforePress takes nothing returns nothing
				set .cast_range = RANGE
			endmethod

			method beforeRelease takes nothing returns nothing
				set .cast_range = -1.
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .preserve_order = false
				set .indicator = ind.create(this,.owner.owner)
				
			endmethod

			method deactivate takes nothing returns nothing

			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"갈고리 투척")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability3070 용암 채찍
scope Ability3070 initializer init

		//! runtextmacro abilityDataHeader3070()
		
		globals
			private constant string EFFECT_PATH1 = "Abilities\\Weapons\\RedDragonBreath\\RedDragonMissile.mdl"
			private constant string EFFECT_PATH2 = "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile_mini.mdl"
			private constant string EFFECT_PATH3 = "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl"
			private trigger MY_RESPOND = CreateTrigger()
			private integer MY_RESPOND_ABILITY = 0
			private boolean MY_RESPOND_ADD_COUNT = false
		endglobals

		private struct sex extends SectorExplosion

			Unit main_target = 0

			method executeExplosion takes Unit target returns nothing
				if target == .main_target then
					set .onhit_type = CONFIG_DAMAGE_ONHIT
				else
					set .onhit_type = CONFIG_DAMAGE_NONHIT
				endif
				call damageTarget(target)
				call Effect.create(EFFECT_PATH1,target.x,target.y,target.z+target.pivot_z,270.).kill()
			endmethod

			static method create takes Unit caster, Unit target, real x, real y, real angle returns thistype
				local thistype this = allocate(caster, x, y, RANGE, angle, WIDTH)
				set .main_target = target
				call setDamageFlagById(ID)
				set .weapon_type = WEAPON_TYPE_METAL_MEDIUM_CHOP
				return this
			endmethod

		endstruct

		private struct lex extends LineExplosion

			Unit main_target = 0

			method executeExplosion takes Unit target returns nothing
				if target == .main_target then
					set .onhit_type = CONFIG_DAMAGE_ONHIT
				else
					set .onhit_type = CONFIG_DAMAGE_NONHIT
				endif
				call damageTarget(target)
				call Effect.create(EFFECT_PATH1,target.x,target.y,target.z+target.pivot_z,270.).kill()
			endmethod

			method afterExplosion takes nothing returns nothing
				local integer i = 0
				local real tx = 0.
				local real ty = 0.
				loop
					exitwhen i >= 8
					set tx = .x + i*((.x2-.x)/7.)
					set ty = .y + i*((.y2-.y)/7.)
					call Effect.create(EF_ROCK,tx,ty,.owner.z,0.).kill()
					set i = i + 1
				endloop
			endmethod

			static method create takes Unit caster, Unit target, real x, real y, real x2, real y2 returns thistype
				local thistype this = allocate(caster, x, y, x2, y2, RADIUS1)
				set .main_target = target
				call setDamageFlagById(ID)
				set .weapon_type = WEAPON_TYPE_METAL_HEAVY_BASH
				return this
			endmethod

		endstruct

		public struct actor extends MeleeAttack

			Chain ch = 0
			integer count = 0
			real tx = 0.
			real ty = 0.
			real tz = 0.

			private method carculatePosition takes boolean end returns nothing
				local real v = 0.
				if end then
					set v = 1.0
				else
					set v = getProgression()
				endif
				/*공격횟수에따른 채찍경로설정*/
				if .count == 0 then
					set .tx = Math.pPX(.owner.x,RANGE,.owner.yaw-(WIDTH/2.)+(WIDTH*v))
					set .ty = Math.pPY(.owner.y,RANGE,.owner.yaw-(WIDTH/2.)+(WIDTH*v))
					set .tz = .owner.z+.owner.pivot_z
				elseif .count == 1 then
					set .tx = Math.pPX(.owner.x,RANGE,.owner.yaw+(WIDTH/2.)-(WIDTH*v))
					set .ty = Math.pPY(.owner.y,RANGE,.owner.yaw+(WIDTH/2.)-(WIDTH*v))
					set .tz = .owner.z+.owner.pivot_z
				else
					set .tx = Math.pPX(.owner.x,RANGE*Sin(Deg2Rad(-30.+v*(90.+30.))),.owner.yaw)
					set .ty = Math.pPY(.owner.y,RANGE*Sin(Deg2Rad(-30.+v*(90.+30.))),.owner.yaw)
					set .tz = .owner.z/*+.owner.pivot_z*/ + RANGE*Cos(Deg2Rad(-30.+v*(90.+30.)))
				endif
			endmethod

			method onComplete takes nothing returns nothing
				local Explosion ex = 0
				local real dt = ((.owner.getCarculatedStatValue(DAMAGE_STAT2) * DAMAGE_AMPLIFIER2) + (.owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1)) * (1+DAMAGE_PER_LEVEL*(.level))
				/*DO DAMAGE*/
				if .count < COUNT-1 then
					/*부채꼴*/
					set ex = sex.create(.caster,.target,.caster.x,.caster.y,.caster.yaw)
					set ex.damage = dt
				else
					/*직선*/
					set ex = lex.create(.caster,.target,/*
						*/Math.pPX(.caster.x,STARTAT,.caster.yaw),/*
						*/Math.pPY(.caster.y,STARTAT,.caster.yaw),/*
						*/Math.pPX(.caster.x,RANGE,.caster.yaw),/*
						*/Math.pPY(.caster.y,RANGE,.caster.yaw)/*
					*/)
					set ex.damage = dt*DAMAGE_SECONDARY
				endif
				call ex.activate()
				/**/
				set MY_RESPOND_ABILITY = .caster.getAbilityById(ID)
				set MY_RESPOND_ADD_COUNT = .count != COUNT-1
				call TriggerEvaluate(MY_RESPOND)
				call Backswing.create(.caster)
				/*평타 치는데 성공했을 때에만 chain의 deathanim 출력*/
				call carculatePosition(true)
				call .ch.list.curve.setPosition(Curve.POINT_LAST,tx,ty,tz)
				call .ch.refreshEffectsPosition()
				call .ch.skipDeathAnim(false)
			endmethod

			method periodicAction takes nothing returns nothing
				call carculatePosition(false)
				call .ch.list.curve.setPosition(Curve.POINT_LAST,tx,ty,tz)
				call .ch.refreshEffectsPosition()
			endmethod
	
			static method create takes Unit caster, Unit target, integer level, integer count returns thistype
				local thistype this = allocate(caster,target)
				local integer i = 0
				set .level = level
				set .count = count
				set .owner.yaw = Math.anglePoints(caster.x,caster.y,target.x,target.y)
				call carculatePosition(false)
				/*체인*/
				set .ch = Chain.create(CurveLinear.create(.owner.x,.owner.y,.owner.z+.owner.pivot_z,.tx,.ty,.tz))
				call .ch.setCaster(.owner)
				call .ch.skipBirthAnim(true)
				call .ch.setLength(0.8,0.33)
				loop 
					exitwhen i >= 6
					call .ch.add(Effect.create(EFFECT_PATH1,0,0,0,0).setScale(0.5))
					call .ch.add(Effect.create(EFFECT_PATH2,0,0,0,0).setScale(0.5))
					set i = i + 1
				endloop
				if .count == COUNT-1 then
					call .ch.add(Effect.create(EFFECT_PATH3,0,0,0,0).setScale(0.5).setAnimSpeed(3.0))
				endif
				call .ch.refreshEffectsPosition()
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .ch.destroy()
			endmethod

		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip3070()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level,.count)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .count = 0
			endmethod

			private static method counterCallback takes nothing returns nothing
				local thistype this = MY_RESPOND_ABILITY
				if MY_RESPOND_ABILITY <= 0 then
					return
				endif
				if MY_RESPOND_ADD_COUNT then
					/*카운트 증가시키기*/
					set .count = .count + 1
					set .gauge = I2R(.count) / I2R(COUNT-1)
				else
					/*카운트 초기화*/
					set .count = 0
					set .gauge = 0.
				endif
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"채찍 휘두르기\n")
				call TriggerAddCondition(MY_RESPOND,function thistype.counterCallback)
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability3080 순보 v2
scope Ability3080 initializer init

		//! runtextmacro abilityDataHeader3080()

		globals
			private constant string EFFECT_PATH1 = "Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl"
			private constant string EFFECT_PATH2 = "Effects\\WindSlash.mdl"
			private constant string EFFECT_PATH3 = "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl"
		endglobals

		private struct exp extends LineExplosion

			boolean b = false

			method afterExplosion takes nothing returns nothing
				local Unit u = Unit.get(Group.getNearest(.group_wave,.x,.y,null))
				//TODO
			endmethod

			method executeExplosion takes Unit target returns nothing
				local Effect ef = Effect.create(EFFECT_PATH2,target.x,target.y,target.z+target.pivot_z,270.)
				call ef.setScale(2.)
				call ef.setRoll(45.)
				call ef.setColor(255,0,255)
				call ef.setDuration(1.0)
				set ef = Effect.createAttatched(EFFECT_PATH3,target.origin_unit,"chest").setDuration(1.5)
				call damageTarget(target)
				if not .b then
					call .owner.restoreMP(DATA_REAL1)
					set .b = true
				endif
			endmethod

			static method create takes Unit caster, real x1, real y1, real x2, real y2, integer level returns thistype
				local thistype this = allocate(caster,x1,y1,x2,y2,RADIUS3)
				local Effect ef = 0
				set .count = 1
				set .damage = ( .owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*(level) ) + /*
				*/( .owner.getCarculatedStatValue(DAMAGE_STAT2) * DAMAGE_AMPLIFIER2 ) * ( 1+DAMAGE_PER_LEVEL*(level) )
				call setDamageFlagById(ID)
				set .weapon_type = WEAPON_TYPE_METAL_MEDIUM_SLICE
				/*이펙트*/
				set ef = Effect.create(EFFECT_PATH1,x1,y1,55,.owner.yaw)
				set ef.pitch = -90
				call ef.setMatrixScale(1,1,0.5)
				call ef.setAnimSpeed(2.)
				call ef.setDuration(1.5)
				set ef = Effect.create(EFFECT_PATH1,x2,y2,55,.owner.yaw)
				set ef.pitch = -90
				call ef.setMatrixScale(1,1,2.5)
				call ef.setAnimSpeed(2.)
				call ef.setDuration(1.5)
				return this
			endmethod

		endstruct

		private struct ind extends LineIndicator

			method beforeRefresh takes nothing returns nothing
				set .x = .abil.owner.x
				set .y = .abil.owner.y
				set .yaw = Math.anglePoints(.x,.y,Mouse.getVX(owner),Mouse.getVY(owner))
				set .range = RANGE
				set .width = RADIUS3
			endmethod

			static method create takes Ability_prototype abil, player owner returns thistype
				local thistype this = allocate(abil,owner)
				call .ef.setColor(255,0,255)
				call .circle.setColor(255,0,255)
				return this
			endmethod

		endstruct

		public struct main extends Ability

			//! runtextmacro abilityTooltip3080()

			/*사거리 표시는 최대 이동거리로 해주되*/
			method beforePress takes nothing returns nothing
				set .cast_range = RANGE
			endmethod

			/*떼는 위치는 거리 제약 없게끔*/
			method beforeRelease takes nothing returns nothing
				set .cast_range = -1.
			endmethod
	
			method execute takes nothing returns nothing
				local real d = Math.distancePoints(.owner.x,.owner.y,.command_x,.command_y)
				local real a = Math.anglePoints(.owner.x,.owner.y,.command_x,.command_y)
				local real bx = .owner.x
				local real by = .owner.y
				local Explosion ex = 0
				if d > RANGE then
					set .command_x = Math.pPX(.owner.x,RANGE,a)
					set .command_y = Math.pPY(.owner.y,RANGE,a)
				endif
				call LocationEx.collisionProjection(.command_x,.command_y)
				set .command_x = LocationEx.getX()
				set .command_y = LocationEx.getY()
				set .owner.x = .command_x
				set .owner.y = .command_y
				set .owner.yaw = Math.anglePoints(bx,by,.owner.x,.owner.y)
				/*라인익스플로전*/
				set ex = exp.create(.owner,bx,by,.owner.x,.owner.y,.level)
				call ex.activate()
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .is_charge = true
				set .preserve_order = false
				set .indicator = ind.create(this,.owner.owner)
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"순간이동 및\n직선 범위공격")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope