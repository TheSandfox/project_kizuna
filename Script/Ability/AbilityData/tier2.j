//!Buff2000 전투 자극제(버프:추뎀)
scope Buff2000 initializer init

	//! runtextmacro buffParam2000()

	globals
		private constant string EFFECT_PATH1 = "Effects\\stimpack.mdl"//"Abilities\\Spells\\Orc\\Bloodlust\\BloodlustTarget.mdl"
	endglobals

	public struct main extends Buff

		real v = 0.
		Trigger trig = 0

		Effect e1 = 0
		Effect e2 = 0

		method relativeTooltip takes nothing returns string
			return "공격력, 이동속도, 기본공격 적중 피해량이 증가했습니다."
		endmethod

		static method damageCallback takes nothing returns nothing
			local thistype this = 0
			if CUSTOM_RESPOND_DAMAGE_ONHIT_TYPE != Damage.ONHIT_TYPE_ONHIT then
				return
			endif
			if CUSTOM_RESPOND_DAMAGE_ATTACK_TYPE != Damage.ATTACK_TYPE_BASIC then
				return
			endif
			set this = Trigger.getData(GetTriggeringTrigger())
			if CUSTOM_RESPOND_DAMAGE_ATTACKER != .target then
				return
			endif
			set CUSTOM_RESPOND_DAMAGE_PLUS = CUSTOM_RESPOND_DAMAGE_PLUS + .v
		endmethod

		method update takes nothing returns boolean
			local real new = .caster.getCarculatedStatValue(ENUM_STAT_ATTACK)*DAMAGE_AMPLIFIER1*(1+DAMAGE_PER_LEVEL*(.level))
			if new > .v then
				set .v = new
			endif
			return true
		endmethod

		method init takes nothing returns boolean
			set .trig = Trigger.create(this)
			call .trig.addCondition(function thistype.damageCallback)
			call Event.register(.trig.main_trigger,ENUM_EVENT_DAMAGE_MODIFY)
			set .v = .caster.getCarculatedStatValue(ENUM_STAT_ATTACK)*DAMAGE_AMPLIFIER1*(1+DAMAGE_PER_LEVEL*(.level))
			call .target.multiplyStatValue(ENUM_STAT_ATTACK_SPEED,DATA_REAL1)
			call .target.multiplyStatValue(ENUM_STAT_MOVEMENT_SPEED,DATA_REAL2)
			/**/
			set .e1 = Effect.createAttatched(EFFECT_PATH1,.target.origin_unit,"hand left")
			set .e2 = Effect.createAttatched(EFFECT_PATH1,.target.origin_unit,"hand right")
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call .trig.destroy()
			call .target.multiplyStatValue(ENUM_STAT_ATTACK_SPEED,-DATA_REAL1)
			call .target.multiplyStatValue(ENUM_STAT_MOVEMENT_SPEED,-DATA_REAL2)
			call .e1.kill()
			call .e2.kill()
			set .e1 = 0
			set .e2 = 0
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

//!Ability2000 전투 자극제
scope Ability2000 initializer init

		//! runtextmacro abilityParam2000()
		
		globals
			private constant string EFFECT_PATH1 = "Effects\\stimpack2.mdl"
		endglobals
		public struct main extends Ability

			//! runtextmacro abilityTooltip2000()

			method execute takes nothing returns nothing
				call Effect.createAttatched(EFFECT_PATH1,.owner.origin_unit,"overhead").setDuration(1.5)
				call Buff.add(.owner,.owner,'2000',.level,DURATION)
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .preserve_order = true
				set .is_immediate = true
				set .useable_cast = true
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"공격속도 증가\n ")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability2030 칼날바람
scope Ability2030 initializer init

		//! runtextmacro abilityParam2030()
		
		globals
			private constant string EFFECT_PATH1 = "Effects\\Whirlwind.mdl"
			private constant string EFFECT_PATH2 = "Abilities\\Weapons\\Rifle\\RifleImpact.mdl"
			private constant string EFFECT_PATH3 = "Effects\\WindSlash.mdl"
		endglobals

		private struct exp extends Explosion

			integer level = 0

			method executeExplosion takes Unit target returns nothing
				local Effect ef = 0
				if IsUnitInGroup(target.origin_unit,.group_wave) then
					set .damage = ( .owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*(.level) )
				else
					set .damage = ( .owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*(.level) )
				endif
				call damageTarget(target)
				call Effect.createAttatched(EFFECT_PATH2,target.origin_unit,"chest").setDuration(1.5)
				set ef = Effect.create(EFFECT_PATH3,target.x+GetRandomReal(-25,25),target.y,target.z+target.pivot_z+GetRandomReal(-25,25),270.)
				call ef.setRoll(GetRandomReal(0.,360.))
				call ef.setMatrixScale(1.25,1.25,2.)
				call ef.setAlpha(192)
				call ef.setDuration(1.0)
			endmethod

			method beforeExplosion takes nothing returns nothing
				set .x = .owner.x
				set .y = .owner.y
			endmethod

			static method create takes Unit caster, real x, real y, real rad, integer level returns thistype
				local thistype this = allocate(caster,x,y,rad)
				set .level = level
				call setDamageFlagById(ID)
				set .weapon_type = WEAPON_TYPE_METAL_HEAVY_BASH
				set .damage = ( .owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*(.level) )
				return this
			endmethod

		endstruct

		public struct actor extends UnitActor
	
			Mover mover = 0
			Explosion ex = 0
			Circle c = 0
			Effect ef = 0
			real anim_progress = 0.

			method periodicAction takes nothing returns nothing
				set .anim_progress = .anim_progress + TIMER_TICK
				call .c.setPosition(.caster.x,.caster.y,5.)
				set .caster.yaw = .caster.yaw + 360 * TIMER_TICK * ROTSPEED
				if .anim_progress >= INTERVAL then
					call .caster.setAnimSpeed(6.)
					call .caster.setAnim("stand")
					call .caster.setAnim("attack")
					set .anim_progress = .anim_progress - INTERVAL
				endif
			endmethod
	
			static method create takes Unit u, real x, real y, integer level returns thistype
				local thistype this = allocate(u,0,x,y,level,INTERVAL*COUNT,true)
				call .caster.setAnim("attack")
				call .caster.setAnimSpeed(2.)
				set .progress_bar = ProgressBar.create(NAME,.caster.owner)
				set .progress_bar.reverse = true
				set .mover = Mover.create(.caster)
				set .mover.refresh_facing = false
				set .ex = exp.create(.caster,.caster.x,.caster.y,RADIUS1,level)
				set .ex.count = -1
				set .ex.interval = INTERVAL
				call .ex.activate()
				set .c = Circle.create(.caster.x,.caster.y,5.,RADIUS1)
				set .c.alpha_max = 0.45
				set .c.alpha = 0.
				call .c.fadeIn(0.35)
				set .ef = Effect.createAttatched(EFFECT_PATH1,.caster.origin_unit,"origin")
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .caster.queueAnim("stand ready")
				call .caster.setAnimSpeed(1.)
				call .mover.destroy()
				if .ex > 0 then
					call .ex.destroy()
				endif
				call .c.destroy()
				call .ef.kill()
			endmethod
	
		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip2030()

			method execute takes nothing returns nothing
				local actor a = actor.create(.owner,.command_x,.command_y,level)
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .preserve_order = true
				set .is_immediate = true
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"주변 적 연속공격\n ")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability2040 마법 카드패
scope Ability2040 initializer init

		//! runtextmacro abilityParam2040()
		
		globals
			private constant boolean CHANCE_MODE = false	/*N회 마다 확정으로 추가투척할지, 행운스탯을 활용해 운빨로 추가투척할지*/
			private constant string EFFECT_PATH1 = "Effects\\MagicCardRed.mdl"
			private constant string EFFECT_PATH2 = "Effects\\MagicCardBlue.mdl"
			private constant string EFFECT_PATH3 = "Effects\\MagicCardGold.mdl"
			private constant string EFFECT_PATH4 = "Effects\\MagicCardPurple.mdl"
		endglobals

			//! textmacro Ability2040_tm0
				local integer rint = GetRandomInt(0,3)
				local real nx = Math.pPX(.caster.x,STARTAT,.caster.yaw)
				local real ny = Math.pPY(.caster.y,STARTAT,.caster.yaw)
				local real dir = Math.anglePoints(.caster.x,.caster.y,.target.x,.target.y)
				local Missile ms = 0
				/*빨*/
				if rint == 0 then
					set ms = Missile.create(.caster,EFFECT_PATH1,nx,ny,.caster.z+.caster.pivot_z,dir)
					call ms.setDamageFlagById(ID)
					set ms.damage_type = Damage.DAMAGE_TYPE_PHYSICAL
					set ms.attack_type = Damage.ATTACK_TYPE_BASIC
					/*파*/
				elseif rint == 1 then
					set ms = Missile.create(.caster,EFFECT_PATH2,nx,ny,.caster.z+.caster.pivot_z,dir)
					call ms.setDamageFlagById(ID)
					set ms.damage_type = Damage.DAMAGE_TYPE_MAGICAL
					set ms.attack_type = Damage.ATTACK_TYPE_BASIC
					/*노*/
				elseif rint == 2 then
					set ms = Missile.create(.caster,EFFECT_PATH3,nx,ny,.caster.z+.caster.pivot_z,dir)
					call ms.setDamageFlagById(ID)
					set ms.damage_type = Damage.DAMAGE_TYPE_PHYSICAL
					set ms.attack_type = Damage.ATTACK_TYPE_SPELL
					/*보*/
				else
					set ms = Missile.create(.caster,EFFECT_PATH4,nx,ny,.caster.z+.caster.pivot_z,dir)
					call ms.setDamageFlagById(ID)
					set ms.damage_type = Damage.DAMAGE_TYPE_MAGICAL
					set ms.attack_type = Damage.ATTACK_TYPE_SPELL
				endif
				set ms.damage = (.caster.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1) * (1+DAMAGE_PER_LEVEL*(.level))
				set ms.radius_target = VELO*TIMER_TICK*0.5
				set ms.velo = VELO
				set ms.weapon_type = WEAPON_TYPE_WOOD_LIGHT_BASH
				call ms.setTarget(.target)
			//! endtextmacro

		public struct additional extends UnitActor

			method onComplete takes nothing returns nothing
				//! runtextmacro Ability2040_tm0()
			endmethod

			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target,0.,0.,level,0.15,false)
				return this
			endmethod

		endstruct
	
		public struct actor extends MeleeAttack

			method onComplete takes nothing returns nothing
				//! runtextmacro Ability2040_tm0()
				static if CHANCE_MODE then
					/*확정투척*/
					local Ability a = .caster.getAbilityById(ID)
					if a > 0 then				
						call a.addValue(1)
						if a.value >= COUNT then
							call additional.create(.caster,.target,.level)
							set a.value = 0
						endif
						set a.gauge = I2R(a.value)/I2R(COUNT-1)
					endif
				else
					/*운빨투척*/
					if Math.randomPercent() <= .caster.getLuckyPercent(DATA_REAL1,DATA_REAL2) then
						call additional.create(.caster,.target,.level)
					endif
				endif
				call Backswing.create(.caster)
			endmethod
	
			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target)
				set .level = level
				return this
			endmethod

		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip2040()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .count = 0
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"무작위 피해유형을 가진\n카드 투척")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability2050 암흑비전파동
scope Ability2050 initializer init

		//! runtextmacro abilityParam2050()
		
		globals
			private constant string EFFECT_PATH1 = "Abilities\\Weapons\\VengeanceMissile\\VengeanceMissile.mdl"
			private constant string EFFECT_PATH2 = "Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl"
		endglobals

		private struct exp extends LineExplosion

			integer level = 0

			method executeExplosion takes Unit target returns nothing
				call damageTarget(target)
				call Effect.createAttatched(EFFECT_PATH2,target.origin_unit,"origin").setDuration(1.5)
			endmethod

			static method create takes Unit caster, real x, real y, real x2, real y2, real rad, integer level returns thistype
				local thistype this = allocate(caster,x,y,x2,y2,rad)
				local real angle = Math.anglePoints(.x,.y,.x2,.y2)
				local Lightning lh = 0
				set .level = level
				call setDamageFlagById(ID)
				set .damage = ( .owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*(.level) )
				call Effect.create(EFFECT_PATH1,.x,.y,55.,270.).setScale(2.5).kill()
				call Effect.create(EFFECT_PATH2,.x,.y,0.,270.).setDuration(1.5)
				call Effect.create(EFFECT_PATH1,.x2,.y2,55.,270.).setScale(2.5).kill()
				set lh = Lightning.create("AFOD",.x,.y,55.,.x2,.y2,55.)
				call lh.setDuration(1.5)
				call lh.setFade(-TIMER_TICK*0.5)
				return this
			endmethod

		endstruct

		public struct actor extends UnitActor

			real range = 0.
			real angle = 0.

			Square sq = 0

			method periodicAction takes nothing returns nothing
				if .sq > 0 then
					call .sq.setPosition(.caster.x,.caster.y,2.)
				endif
			endmethod

			method onComplete takes nothing returns nothing
				local exp ex = exp.create(.caster,Math.pPX(.caster.x,RADIUS2,angle),Math.pPY(.caster.y,RADIUS2,angle),/*
				*/Math.pPX(.caster.x,.range-RADIUS2,.angle),Math.pPY(.caster.y,.range-RADIUS2,.angle),RADIUS2,.level)
				call ex.activate()
				call UnitActor.create(.caster,0,0.,0.,0,BACKSWING,true)
				call .caster.queueAnim("stand ready")
				call .caster.setAnimSpeed(1.)
				set .sq.alphaaxis = -1./0.5
			endmethod
	
			static method create takes Unit u, real x, real y, integer level, real range returns thistype
				local thistype this = allocate(u,0,x,y,level,DELAY,true)
				set .angle = Math.anglePoints(.caster.x,.caster.y,.x,.y)
				set .sq = Square.create(.caster.x,.caster.y,2.,range,angle,RADIUS2,null)
				call .sq.setColor(1.,0.,0.,0.)
				set .sq.alphaaxis = 1./0.35
				set .range = range
				call .caster.setAnim("attack")
				call .caster.setAnimSpeed(0.66)
				set .progress_bar = ProgressBar.create(NAME,.caster.owner)
				call SetUnitFacing(.caster.origin_unit,angle)
				return this
			endmethod

			method onSuspend takes nothing returns nothing
				call .caster.queueAnim("stand ready")
				call .caster.setAnimSpeed(1.)
				call .sq.destroy()
				set .sq = 0
			endmethod
	
			method onDestroy takes nothing returns nothing
				set .sq = 0
			endmethod

		endstruct

		private struct ind extends LineIndicator

			method beforeRefresh takes nothing returns nothing
				set .x = .abil.owner.x
				set .y = .abil.owner.y
				set .yaw = Math.anglePoints(.x,.y,Mouse.getVX(owner),Mouse.getVY(owner))
				set .range = .abil.cast_range
				set .width = RADIUS2
			endmethod

			static method create takes Ability_prototype abil, player owner returns thistype
				local thistype this = allocate(abil,owner)
				call .ef.setColor(255,0,0)
				call .circle.setColor(255,0,0)
				return this
			endmethod

		endstruct

		public struct charge extends UnitActor

			Effect ef = 0

			Mover mv = 0

			method periodicAction takes nothing returns nothing
				call .ef.setPosition(.caster.x,.caster.y,.caster.z+125)
				set .link_ability.cast_range = .link_ability.cast_range + ((RANGE_SECONDARY-RANGE)*TIMER_TICK)/DATA_REAL1
				call .ef.setScale(.ef.getScale()+TIMER_TICK)
				if .link_ability.cast_range > RANGE_SECONDARY then
					set .link_ability.cast_range = RANGE_SECONDARY
					call .ef.setScale(3.0)
				endif
				if .timeout >= 0.25 and .stage == 0 then
					call .caster.setAnimSpeed(0.)
					set .stage = 1
				endif
			endmethod

			static method create takes Unit caster returns thistype
				local thistype this = allocate(caster,0,0.,0.,0,DURATION,true)
				set .mv = Mover.create(.caster)
				set .mv.refresh_facing = true
				call .caster.setAnim("attack")
				call .caster.setAnim("spell")
				set .ef = Effect.create(EFFECT_PATH1,.caster.x,.caster.y,.caster.z+125.,270.)
				call .ef.setScale(2.0)
				set .progress_bar = ProgressBar.create(NAME,.caster.owner)
				set .progress_bar.reverse = true
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call mv.destroy()
				set mv = 0
				call .caster.setAnimSpeed(1.0)
				call .ef.destroy()
			endmethod

		endstruct
	
		public struct main extends Ability

			real range_temp = 0.

			//! runtextmacro abilityTooltip2050()

			method beforeRelease takes nothing returns nothing
				if .pressing then
					set .command_x = Mouse.getX(.owner.owner)
					set .command_y = Mouse.getY(.owner.owner)
					set .range_temp = .cast_range
					set .cast_range = -1.
					if .link_actor > 0 then
						set .useable_cast = true
					endif
				endif
			endmethod

			method onRelease takes nothing returns nothing
				if .link_actor > 0 then
					call .link_actor.destroy()
				endif
				set .cast_range = -1.
				set .useable_cast = false
			endmethod

			/*선입력했을경우 우클릭으로 취소가능*/
			method onRightClick takes nothing returns nothing
				if .link_actor <= 0 then
					call setPressState(false)
				endif
			endmethod

			method execute takes nothing returns nothing
				local actor a = 0
				if .link_actor > 0 then
					call .link_actor.destroy()
					set .link_actor = 0
				endif
				set a = actor.create(.owner,.command_x,.command_y,level,.range_temp)
				set .cast_range = -1.
				set .useable_cast = false
			endmethod
	
			method onPress takes nothing returns nothing
				local charge a = 0
				set .useable_cast = false
				if costFilter() and enableFilter() then
					/*선입력 사용이 아니면 차징 액터 생성*/
					if castFilter() then
						set a = charge.create(.owner)
						call linkActor(a)
					endif
					set .cast_range = RANGE
				else
					call sendError()
				endif
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .preserve_order = false
				set .indicator = ind.create(this,.owner.owner)
				set .drag_to_use = true
				set .cancle_rightclick = false
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"장거리 직선 범위공격\n")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability2060 수리검 투척
scope Ability2060 initializer init

		//! runtextmacro abilityParam2060()
		
		globals
			private constant string EFFECT_PATH1 = "Effects\\Shuriken.mdl"
		endglobals

		public struct actor extends UnitActor

			Mover mv = 0

			integer count = COUNT
			real angle = 0.

			method killFilter takes nothing returns boolean
				set .count = .count - 1
				if .count > 0 then
					set .duration = INTERVAL
					set .timeout = 0.
					return false
				else
					return true
				endif
			endmethod

			method periodicAction takes nothing returns nothing
				set .caster.yaw = .angle
			endmethod

			method onComplete takes nothing returns nothing
				local Missile ms = Missile.create(.caster,EFFECT_PATH1,Math.pPX(.caster.x,STARTAT,.angle),Math.pPY(.caster.y,STARTAT,.angle),.caster.pivot_z,.angle)
				call ms.setDamageFlagById(ID)
				set ms.damage = ( .owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*(.level) ) +/*
				*/ ( .owner.getCarculatedStatValue(DAMAGE_STAT2) * DAMAGE_AMPLIFIER2 ) * ( 1+DAMAGE_PER_LEVEL*(.level) )
				set ms.weapon_type = WEAPON_TYPE_METAL_LIGHT_SLICE
				/*첫타만 온힛*/
				if .count == COUNT then
					set ms.onhit_type = Damage.ONHIT_TYPE_ONHIT
				else
					set ms.onhit_type = Damage.ONHIT_TYPE_NONHIT
				endif
				if .count == COUNT - 1 then
					/*채널링프리*/
					call .caster.queueAnim("stand ready")
					call .caster.setAnimSpeed(1.)
					call .mv.destroy()
					set .mv = 0
					call resetChanneling()
				endif
				call ms.setCollision(RADIUS2)
				call ms.setDuration((RANGE-STARTAT)/VELO)
				set ms.velo = VELO
			endmethod

			method onSuspend takes nothing returns nothing
				call .caster.setAnimSpeed(1.)
			endmethod
	
			static method create takes Unit u, real angle, integer level returns thistype
				local thistype this = allocate(u,0,0.,0.,level,DELAY,true)
				set .angle = angle
				call .caster.setAnim("attack")
				call .caster.setAnimSpeed(1.66)
				call SetUnitFacing(.caster.origin_unit,.angle)
				set .mv = Mover.create(.caster)
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				if .mv > 0 then
					call .mv.destroy()
					set .mv = 0
				endif
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
				call .ef.setColor(144,144,144)
				call .circle.setColor(144,144,144)
				return this
			endmethod

		endstruct

		public struct main extends Ability
	
			//! runtextmacro abilityTooltip2060()
	
			method execute takes nothing returns nothing
				call actor.create(.owner,Math.anglePoints(.owner.x,.owner.y,.command_x,.command_y),level)
			endmethod

	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .preserve_order = true
				set .count_max = CHARGE
				set .count = CHARGE
				set .indicator = ind.create(this,.owner.owner)
				set .smart = 2
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"수리검 투척")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Buff2070 불붙은 시미터(버프)
scope Buff2070 initializer init

	//! runtextmacro buffParam2070()

	public struct main extends Buff
		
		static constant string EFFECT_PATH1 = "Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireDamage.mdl"

		implement DamageFlag

		method relativeTooltip takes nothing returns string
			return "매 초마다 체력재생에 비례한 피해를 입습니다."
		endmethod

		method intervalAction takes nothing returns nothing
			set .damage = ( (.owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1) * (1+DAMAGE_PER_LEVEL*(.level)) + (.target.hpregen*DATA_REAL1) ) * INTERVAL
			call damageTarget(.target)
		endmethod

		method update takes nothing returns boolean
			return true
		endmethod

		method init takes nothing returns boolean
			call addEffect(Effect.createAttatched(EFFECT_PATH1,.target.origin_unit,"chest"))
			set .interval = INTERVAL
			call setDamageFlagById(DAMAGE_ID)
			return true
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

//!Ability2070 불붙은 시미터
scope Ability2070 initializer init

		//! runtextmacro abilityParam2070()
		
		globals
			private constant string EFFECT_PATH1 = "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile_mini.mdl"
			private constant string EFFECT_PATH2 = "Abilities\\Weapons\\RedDragonBreath\\RedDragonMissile.mdl"
			private constant string EFFECT_PATH3 = "Effects\\WindSlash.mdl"
		endglobals

		public struct actor extends MeleeAttack

			Effect ef1 = 0
			Effect ef2 = 0

			method onComplete takes nothing returns nothing
				local Ability a = .caster.getAbilityById(ID)
				local Effect ef = 0
				local Buff b = 0
				set .damage = (.owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1) * (1+DAMAGE_PER_LEVEL*(.level))
				call damageTarget(.target)
				call Effect.create(EFFECT_PATH1,.target.x,.target.y,.target.z+.target.pivot_z,270.).setScale(1.25).kill()
				set ef = Effect.create(EFFECT_PATH3,target.x+GetRandomReal(-25,25),target.y,target.z+target.pivot_z+GetRandomReal(-25,25),270.)
				call ef.setColor(255,153,66)
				call ef.setRoll(GetRandomReal(0.,360.))
				call ef.setMatrixScale(1.25,1.25,2.)
				call ef.setAlpha(192)
				call ef.setDuration(1.0)
				if a > 0 then
					call a.addValue(1)
					if a.value >= COUNT then
						call Effect.create(EFFECT_PATH2,.target.x,.target.y,.target.z+.target.pivot_z,0.).setAnimSpeed(1.5).kill()
						set b = Buff.add(.caster,.target,ID,.level,DURATION)
						set b.level = .level
						call b.intervalAction()
						set a.value = 0
					endif
					set a.gauge = I2R(a.value)/I2R(COUNT-1)
				endif
				call Backswing.create(.caster)
			endmethod
	
			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target)
				local real angle = Math.anglePoints(.caster.x,.caster.y,.target.x,.target.y)
				set .level = level
				call setDamageFlagById(ID)
				set .weapon_type = WEAPON_TYPE_METAL_HEAVY_SLICE
				set .ef1 = Effect.createAttatched(EFFECT_PATH1,.caster.origin_unit,"hand left")
				set .ef2 = Effect.createAttatched(EFFECT_PATH1,.caster.origin_unit,"hand right")
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				if .ef1 > 0 then
					call .ef1.kill()
				endif
				if .ef2 > 0 then
					call .ef2.kill()
				endif
				set .ef1 = 0
				set .ef2 = 0
			endmethod

		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip2070()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .count = 0
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"대상 약화 및 지속피해\n")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability2080 낚시
//! import "Special\\Fishing.j"

//!Ability2090 돌진v2
scope Ability2090 initializer init

		//! runtextmacro abilityParam2090()
		
		globals
			private constant string EFFECT_PATH1 = "Abilities\\Spells\\Orc\\Shockwave\\ShockwaveMissile.mdl"
		endglobals

		public struct mv extends Charge
		
			Effect ef = 0
			timer t

			static method tA takes nothing returns nothing
				local thistype this = Timer.getData(GetExpiredTimer())
				call .ef.setPosition(.caster.x,.caster.y,.caster.z+.caster.pivot_z)
			endmethod

			method executeWave takes Unit_prototype target returns nothing
				set .damage = ( .caster.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*(.level) )
				call damageTarget(target)
				call Effect.create(EF_ROCK,target.x,target.y,target.z+target.pivot_z,0.).kill()
			endmethod
			
			static method create takes Unit u, real yaw, integer level returns thistype
				//! runtextmacro chargeAllocate("u","CHARGE_SPEED","yaw")
				call setDamageFlagById(ID)
				call airbourne(450.,CHARGE_DURATION)
				set .use_collision = true
				set .duration  = CHARGE_DURATION
				set .refresh_facing = true
				set .level = level
				set .radius_wave = RADIUS2
				set .flag_wave = true
				call .caster.setAnim("attack")
				call .caster.setAnimSpeed(0.7)
				set .ef = Effect.create(EFFECT_PATH1,.caster.x,.caster.y,.caster.z+.caster.pivot_z,yaw)
				set .t = Timer.new(this)
				call Timer.start(.t,TIMER_TICK,true,function thistype.tA)
				return this
			endmethod
	
			method onDestroy takes nothing returns nothing
				call Timer.release(.t)
				set .t = null
				call .caster.setAnimSpeed(1.0)
				call .caster.queueAnim("stand")
				call .ef.kill()
			endmethod
	
		endstruct

		private struct ind extends LineIndicator

			method beforeRefresh takes nothing returns nothing
				set .x = .abil.owner.x
				set .y = .abil.owner.y
				set .yaw = Math.anglePoints(.x,.y,Mouse.getVX(owner),Mouse.getVY(owner))
				set .range = (CHARGE_SPEED*CHARGE_DURATION)
				set .width = RADIUS2
			endmethod

			static method create takes Ability_prototype abil, player owner returns thistype
				local thistype this = allocate(abil,owner)
				call .ef.setColor(255,R2I(0.65*255),0)
				return this
			endmethod

		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip2090()
	
			method execute takes nothing returns nothing
				call mv.create(.owner,Math.anglePoints(.owner.x,.owner.y,.command_x,.command_y),level)
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .is_charge = true
				set .preserve_order = true
				set .cast_delay = 0.25
				set .indicator = ind.create(this,.owner.owner)
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"단거리 돌진,\n충돌 시 범위피해")
			endmethod

			method executeAI takes nothing returns boolean
				if Math.distancePoints(.owner.x,.owner.y,GetUnitX(.command_target),GetUnitY(.command_target)) <= 575. then
					return useRequest(GetUnitX(.command_target),GetUnitY(.command_target),.command_target,false)
				else
					return false
				endif
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability20a0 돼지 조련술
scope Ability20a0 initializer init

		//! runtextmacro abilityParam20a0()
		
		globals
			private constant string EFFECT_PATH1 = "Abilities\\Weapons\\SorceressMissile\\SorceressMissile.mdl"
		endglobals

		private struct hploss

			timer main_timer = null
			real v = 0.
			real v_max = 0.
			Unit caster = 0 

			static method callback takes nothing returns nothing
				local thistype this = Timer.getData(GetExpiredTimer())
				local boolean want_destroy = false
				local real pv = (.v_max*0.1) / DATA_REAL5
				if .v <= 0 then
					set want_destroy = true
				elseif .v <= pv then
					set .caster.hp = .caster.hp - .v
					set want_destroy = true
				else
					set .caster.hp = .caster.hp - pv
					set .v = .v - pv
				endif
				if want_destroy then
					call destroy()
				endif
			endmethod

			static method create takes Unit caster, real r returns thistype
				local thistype this = allocate()
				set .caster = caster
				set .v = r
				set .v_max = r
				set .main_timer = Timer.new(this)
				call Timer.start(.main_timer,0.1,true,function thistype.callback)
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call Timer.release(.main_timer)
				set .main_timer = null
			endmethod

		endstruct
	
		public struct pig extends Summon

			method summonDeath takes nothing returns nothing
				call Effect.create(EFFECT_PATH1,.x,.y,.z+.pivot_z,0.).kill()
				call hploss.create(.caster,(.maxhp - .hp)*DATA_REAL4)
				static if CONFIG_DEBUG then
					call BJDebugMsg("흡")
				endif
			endmethod

			static method create takes Unit caster, Unit target, real x, real y, real yaw, integer level returns thistype
				local thistype this = allocate(caster,UNIT_ID1,x,y,yaw,caster.level,DURATION)
				call setScale(0.85)
				call plusStatus(ENUM_STATUS_GHOST)
				call setPosition(x,y)
				call issueTargetOrder("smart",target.origin_unit)
				call Effect.create(EFFECT_PATH1,.x,.y,.z+.pivot_z,0.).setScale(1.75).kill()
				call plusStatValue(DAMAGE_STAT1,.caster.getCarculatedStatValue(DAMAGE_STAT1) * .caster.getCarculatedStatValue(DAMAGE_STAT2) * (DATA_REAL1 + DATA_REAL2 * (level)))
				set .damage_give = DATA_REAL3 * caster.damage_give
				return this
			endmethod

		endstruct

		public struct actor extends MeleeAttack

			method onComplete takes nothing returns nothing
				/*TODO 돼지소환*/
				call pig.create(.caster,target,.caster.x+GetRandomReal(-75,75),.caster.y+GetRandomReal(-75,75),.caster.yaw,level)
				call Backswing.create(.caster)
			endmethod
	
			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target)
				set .level = level
				return this
			endmethod

		endstruct
	
		public struct main extends Ability

			method getAttackSpeedValue takes real v returns real
				return 1.
			endmethod

			//! runtextmacro abilityTooltip20a0()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,.level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"대상을 공격하는 돼지 소환\n")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Buff20b0 퇴마의 장막(버프)
scope Buff20b0 initializer init

	//! runtextmacro buffParam20b0()
	public struct main extends Buff

		static constant string EFFECT_PATH1 = "Effects\\AntiMagicShell1.mdl"

		real v = 0.

		method relativeTooltip takes nothing returns string
			return "저항력과 공격속도가 증가했습니다."
		endmethod

		method update takes nothing returns boolean
			call ShieldBuff(this).refill(.caster.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 * (1+DAMAGE_PER_LEVEL*(.level)))
			/*스탯*/
			call .target.plusStatValue(ENUM_STAT_RESISTANCE,-.v)
			set .v = .caster.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER2 * (1+DAMAGE_PER_LEVEL*(.level))
			call .target.plusStatValue(ENUM_STAT_RESISTANCE,.v)
			return true
		endmethod

		method init takes nothing returns boolean
			call addEffect(Effect.createAttatched(EFFECT_PATH1,.target.origin_unit,"origin"))
			call ShieldBuff(this).register(.caster.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 * (1+DAMAGE_PER_LEVEL*(.level)))
			set .v = .caster.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER2 * (1+DAMAGE_PER_LEVEL*(.level))
			call .target.plusStatValue(ENUM_STAT_RESISTANCE,.v)
			call .target.multiplyStatValue(ENUM_STAT_ATTACK_SPEED,DATA_REAL1)
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call .target.plusStatValue(ENUM_STAT_RESISTANCE,-.v)
			call .target.multiplyStatValue(ENUM_STAT_ATTACK_SPEED,-DATA_REAL1)
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

//!Ability20b0 퇴마의 장막
scope Ability20b0 initializer init

		//! runtextmacro abilityParam20b0()
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip20b0()

			method execute takes nothing returns nothing
				call Buff.add(.owner,.owner,'20b0',.level,DURATION)
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .preserve_order = true
				set .is_immediate = true
				set .useable_cast = true
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"마법 보호막 전개\n ")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Buff20c0 맹독 칼날(버프)
scope Buff20c0 initializer init

	//! runtextmacro buffParam20c0()

	public struct main extends Buff

		/*DPS*/
		
		static constant string EFFECT_PATH1 = "Abilities\\Weapons\\PoisonSting\\PoisonStingTarget.mdl"

		implement DamageFlag

		method relativeTooltip takes nothing returns string
			return "매 초마다 피해를 입습니다."
		endmethod

		method intervalAction takes nothing returns nothing
			set .damage = (.caster.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1) * (1+DAMAGE_PER_LEVEL*(.level)) * INTERVAL
			call damageTarget(.target)
		endmethod

		method update takes nothing returns boolean
			return true
		endmethod

		method init takes nothing returns boolean
			call addEffect(Effect.createAttatched(EFFECT_PATH1,.target.origin_unit,"chest"))
			set .interval = INTERVAL
			call setDamageFlagById(DAMAGE_ID)
			return true
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

//!Ability20c0 맹독 칼날
scope Ability20c0 initializer init

		//! runtextmacro abilityParam20c0()
		
		globals
			private constant string EFFECT_PATH1 = "Abilities\\Spells\\Other\\Cleave\\CleaveDamageTarget.mdl"
			// private constant string EFFECT_PATH2 = "Abilities\\Spells\\Human\\SweepingStrike\\SweepingStrike.mdl"
			// private constant string EFFECT_PATH1 = "Effects\\WindSlash.mdl"
		endglobals
	
		public struct actor extends MeleeAttack

			method onComplete takes nothing returns nothing
				local Buff b = 0
				set .damage = ((.owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1)+(.owner.getCarculatedStatValue(DAMAGE_STAT2) * DAMAGE_AMPLIFIER2)) * (1+DAMAGE_PER_LEVEL*(.level))
				call damageTarget(.target)
				call Effect.create(EFFECT_PATH1,.target.x,.target.y,.target.z+.target.pivot_z,270.).setScale(2.5).kill()
				// call Effect.create(EFFECT_PATH2,.caster.x,.caster.y,.caster.z+.caster.pivot_z,Math.anglePoints(.caster.x,.caster.y,.target.x,.target.y)).setScale(2.5).kill()
				set b = Buff.add(.caster,.target,ID,.level,DURATION)
				call b.intervalAction()
				call Backswing.create(.caster)
			endmethod
	
			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target)
				local real angle = Math.anglePoints(.caster.x,.caster.y,.target.x,.target.y)
				set .level = level
				call setDamageFlagById(ID)
				set .weapon_type = WEAPON_TYPE_METAL_MEDIUM_SLICE
				return this
			endmethod

		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip20c0()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"지속피해\n")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Buff20d1 회심의 일격(버프:추뎀)
scope Buff20d1 initializer init

	//! runtextmacro buffParam20d1()

	public struct main extends Buff

		real v = 0.
		Trigger trig = 0

		method relativeTooltip takes nothing returns string
			return "다음으로 가하는 기본공격 피해량이 증가합니다."
		endmethod

		static method damageCallback takes nothing returns nothing
			local thistype this = 0
			if CUSTOM_RESPOND_DAMAGE_ONHIT_TYPE != Damage.ONHIT_TYPE_ONHIT then
				return
			endif
			if CUSTOM_RESPOND_DAMAGE_ATTACK_TYPE != Damage.ATTACK_TYPE_BASIC then
				return
			endif
			set this = Trigger.getData(GetTriggeringTrigger())
			if CUSTOM_RESPOND_DAMAGE_ATTACKER != .target then
				return
			endif
			set CUSTOM_RESPOND_DAMAGE_PLUS = CUSTOM_RESPOND_DAMAGE_PLUS + .v
			call destroy()
		endmethod

		method update takes nothing returns boolean
			local real new = .caster.getCarculatedStatValue(DAMAGE_STAT1)*DAMAGE_AMPLIFIER1*(1+DAMAGE_PER_LEVEL*(.level))
			if new > .v then
				set .v = new
			endif
			return true
		endmethod

		method init takes nothing returns boolean
			set .trig = Trigger.create(this)
			call .trig.addCondition(function thistype.damageCallback)
			call Event.register(.trig.main_trigger,ENUM_EVENT_DAMAGE_MODIFY)
			set .v = .caster.getCarculatedStatValue(DAMAGE_STAT1)*DAMAGE_AMPLIFIER1*(1+DAMAGE_PER_LEVEL*(.level))
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call .trig.destroy()
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

//!Buff20d0 회심의 일격(버프:감속)
scope Buff20d0 initializer init

	//! runtextmacro buffParam20d0()

	globals
		private constant string EFFECT_PATH1 = "Effects\\InvisibilityTarget0.mdl"
	endglobals

	public struct main extends Buff

		method relativeTooltip takes nothing returns string
			return "이동속도가 감소했습니다."
		endmethod

		method update takes nothing returns boolean
			return true
		endmethod

		method init takes nothing returns boolean
			call addEffect(Effect.createAttatched(EFFECT_PATH1,.target.origin_unit,"chest"))
			call .target.divideStatValue(ENUM_STAT_MOVEMENT_SPEED,100.)
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call Buff.add(.caster,.target,'20d1',.level,DURATION)
			call .target.divideStatValue(ENUM_STAT_MOVEMENT_SPEED,-100.)
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

//!Ability20d0 회심의 일격
scope Ability20d0 initializer init

		//! runtextmacro abilityParam20d0()
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip20d0()

			method execute takes nothing returns nothing
				call Buff.add(.owner,.owner,'20d0',.level,DURATION)
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .preserve_order = true
				set .useable_cast = true
				set .is_immediate = true
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"다음 공격 피해량 증가\n ")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability20e0 도약강타
scope Ability20e0 initializer init

		//! runtextmacro abilityParam20e0()

		globals
			private constant string EFFECT_PATH1 = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl"
		endglobals
		
		public struct jump extends Charge

			method executeExplosion takes Unit target returns nothing
				call damageTarget(target)
			endmethod

			method onComplete takes nothing returns nothing
				call explosionAction()
				call Effect.create(EFFECT_PATH1,.caster.x,.caster.y,0.,270.).kill()
				call Backswing.create(.caster)
			endmethod

			method onBound takes nothing returns boolean
				call onComplete()
				return true
			endmethod

			static method create takes Unit caster, real x, real y, integer level returns thistype
				local real d = Math.distancePoints(caster.x,caster.y,x,y)
				local real a = Math.anglePoints(caster.x,caster.y,x,y)
				//! runtextmacro chargeAllocate("caster","d/DURATION","a")
				set .level = level
				set .radius_explosion = RADIUS3
				call airbourne(2250.,DURATION)
				// set .z_velo = 2250.
				// set .gravity = (2250.*2)/DURATION
				//set .duration = DURATION
				set .caster.yaw = a
				call .caster.setAnim("attack")
				call setDamageFlagById(ID)
				set .damage = (.caster.getCarculatedStatValue(DAMAGE_STAT2)*DAMAGE_AMPLIFIER2+.caster.getCarculatedStatValue(DAMAGE_STAT1)*DAMAGE_AMPLIFIER1)*(1+DAMAGE_PER_LEVEL*(.level))
				return this
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
				call .c.setColor(255,143,0)
				call .circle.setColor(255,143,0)
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .c.destroy()
			endmethod

		endstruct

		public struct main extends Ability

			//! runtextmacro abilityTooltip20e0()

			//인디케이터 상으로 사거리 표시
			method beforePress takes nothing returns nothing
				set .cast_range = RANGE
			endmethod

			//뗄 때는 거리 제한 없이
			method beforeRelease takes nothing returns nothing
				set .cast_range = -1.
			endmethod
	
			method execute takes nothing returns nothing
				/*좌표보정*/
				local real d = Math.distancePoints(.owner.x,.owner.y,.command_x,.command_y)
				local real a = Math.anglePoints(.owner.x,.owner.y,.command_x,.command_y)
				call Effect.create(EF_ROCK,.owner.x,.owner.y,5.,270.).kill()
				if d > RANGE then
					set .command_x = Math.pPX(.owner.x,RANGE,a)
					set .command_y = Math.pPY(.owner.y,RANGE,a)
				endif
				call LocationEx.collisionProjection(.command_x,.command_y)
				set .command_x = LocationEx.getX()
				set .command_y = LocationEx.getY()
				/*액터생성*/
				call jump.create(.owner,.command_x,.command_y,.level)
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .is_charge = true
				set .preserve_order = false
				set .indicator = ind.create(this,.owner.owner)
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"도약 후 내려찍기\n ")
			endmethod

			method executeAI takes nothing returns boolean
				if Math.distancePoints(.owner.x,.owner.y,GetUnitX(.command_target),GetUnitY(.command_target)) <= 575. then
					return useRequest(GetUnitX(.command_target),GetUnitY(.command_target),.command_target,false)
				else
					return false
				endif
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability20f0 악령의 칼날
scope Ability20f0 initializer init

		//! runtextmacro abilityParam20f0()
		
		globals
			private constant string EFFECT_PATH1 = "Effects\\WindSlash.mdl"
			private constant string EFFECT_PATH2 = "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl"
			private constant string EFFECT_PATH3 = "Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl"
		endglobals

		public struct illusion extends Illusion

			static method create takes Unit caster, Unit target, integer level returns thistype
				local real ta = GetRandomReal(0.,360.)
				local real tx = Math.pPX(target.x,75.,ta)
				local real ty = Math.pPY(target.y,75.,ta)
				local thistype this = allocate(caster, caster.id, tx, ty, ta-180., level, DURATION)
				set .damage_give = DATA_REAL3 * caster.damage_give
				call plusStatValue(ENUM_STAT_ATTACK,(.caster.getCarculatedStatValue(DAMAGE_STAT2) * DAMAGE_AMPLIFIER2) * (1+DAMAGE_PER_LEVEL*(level)))
				call issueTargetOrder("attack",target.origin_unit)
				call Effect.create(EFFECT_PATH3,.x,.y,.z,270.).setScale(0.66).kill()
				call plusStatus(ENUM_STATUS_LOCUST)
				call copyAbility(caster)
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call minusStatus(ENUM_STATUS_LOCUST)
			endmethod

		endstruct
	
		public struct actor extends MeleeAttack

			method onComplete takes nothing returns nothing
				call Effect.create(EFFECT_PATH1,.target.x,.target.y,.target.z+.target.pivot_z,270.).setScale(1.45).setColor(0,0,0).setRoll(50).kill()
				call Effect.create(EFFECT_PATH1,.target.x,.target.y,.target.z+.target.pivot_z,270.).setScale(1.45).setColor(0,0,0).setRoll(-50).kill()
				call Effect.create(EFFECT_PATH2,.target.x,.target.y,.target.z+.target.pivot_z,270.).setScale(1.75).setAnimSpeed(1.75).kill()
				set .damage = (.caster.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1) * (1+DAMAGE_PER_LEVEL*(.level))
				call damageTarget(.target)
				call Backswing.create(.caster)
				if UnitClass(.caster).getClass(ENUM_UNIT_CLASS_ILLUSION) <= 0 then
					if .caster.luckyTest(DATA_REAL1,DATA_REAL2) then
						call illusion.create(.caster,.target,.level)
					endif
				endif
			endmethod
	
			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target)
				set .level = level
				call setDamageFlagById(ID)
				set .weapon_type = WEAPON_TYPE_METAL_MEDIUM_SLICE
				call .caster.setAnimSpeed(1.)
				return this
			endmethod

		endstruct
	
		public struct main extends Ability
			
			//! runtextmacro abilityTooltip20f0()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"환영 공격")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Buff20g0 광폭화(버프:추뎀)
scope Buff20g0 initializer init

	//! runtextmacro buffParam20g0()

	globals
		private constant string EFFECT_PATH1 = "Effects\\berserk.mdl"//"Abilities\\Spells\\Orc\\Bloodlust\\BloodlustTarget.mdl"
	endglobals

	public struct main extends Buff

		real v = 0.
		Trigger trig = 0

		Effect e1 = 0
		Effect e2 = 0

		method relativeTooltip takes nothing returns string
			return "공격속도와 기본공격 적중 피해량이 증가했습니다."
		endmethod

		static method damageCallback takes nothing returns nothing
			local thistype this = 0
			if CUSTOM_RESPOND_DAMAGE_ATTACK_TYPE != Damage.ATTACK_TYPE_BASIC then
				return
			endif
			set this = Trigger.getData(GetTriggeringTrigger())
			if CUSTOM_RESPOND_DAMAGE_ATTACKER != .target then
				return
			endif
			set CUSTOM_RESPOND_DAMAGE_PLUS = CUSTOM_RESPOND_DAMAGE_PLUS + .v
		endmethod

		method update takes nothing returns boolean
			local real new = .caster.getCarculatedStatValue(DAMAGE_STAT1)*DAMAGE_AMPLIFIER1*(1+DAMAGE_PER_LEVEL*(.level))
			if new > .v then
				set .v = new
			endif
			return true
		endmethod

		method init takes nothing returns boolean
			set .trig = Trigger.create(this)
			call .trig.addCondition(function thistype.damageCallback)
			call Event.register(.trig.main_trigger,ENUM_EVENT_DAMAGE_MODIFY)
			set .v = .caster.getCarculatedStatValue(DAMAGE_STAT1)*DAMAGE_AMPLIFIER1*(1+DAMAGE_PER_LEVEL*(.level))
			call .target.multiplyStatValue(ENUM_STAT_ATTACK_SPEED,DATA_REAL1)
			/**/
			set .e1 = Effect.createAttatched(EFFECT_PATH1,.target.origin_unit,"hand left")
			set .e2 = Effect.createAttatched(EFFECT_PATH1,.target.origin_unit,"hand right")
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call .trig.destroy()
			call .target.multiplyStatValue(ENUM_STAT_ATTACK_SPEED,-DATA_REAL1)
			call .e1.kill()
			call .e2.kill()
			set .e1 = 0
			set .e2 = 0
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

//!Ability20g0 광폭화
scope Ability20g0 initializer init

		//! runtextmacro abilityParam20g0()
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip20g0()

			method execute takes nothing returns nothing
				call Buff.add(.owner,.owner,'20g0',.level,DURATION)
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .preserve_order = true
				set .is_immediate = true
				set .useable_cast = true
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"공격속도 증가\n ")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Buff20h1 자연의 결속(타겟)
scope Buff20h1 initializer init

	//! runtextmacro buffParam20h1()

	globals
		private constant string EFFECT_PATH1 = "Abilities\\Spells\\Other\\ANrl\\ANrlTarget.mdl"
		private constant string EFFECT_PATH2 = "Abilities\\Weapons\\WitchDoctorMissile\\WitchDoctorMissile.mdl"
	endglobals

	public struct main extends Buff

		Lightning l1 = 0
		Lightning l2 = 0
		Chain ch = 0
		Effect ef = 0

		method relativeTooltip takes nothing returns string
			return "매 초마다 체력과 마나를 회복합니다."
		endmethod

		method periodicAction takes nothing returns nothing
			call .ch.progressLength(3.*TIMER_TICK)
			call .ef.setPosition(.caster.x,.caster.y,.caster.z+.caster.pivot_z)
		endmethod

		method update takes nothing returns boolean
			call .caster.healUnit(target,.caster.getCarculatedStatValue(DAMAGE_STAT1)*DAMAGE_AMPLIFIER1*(1+DAMAGE_PER_LEVEL*(.level)))
			call target.restoreMP(.caster.getCarculatedStatValue(DAMAGE_STAT2)*DAMAGE_AMPLIFIER2*(1+DAMAGE_PER_LEVEL*(.level)))
			return true
		endmethod

		method intervalAction takes nothing returns nothing
			call update()
		endmethod

		method init takes nothing returns boolean
			set .permanent = true
			set .interval = 0.5
			call suspendFree()
			call update()
			call addEffect(Effect.createAttatched(EFFECT_PATH1,.target.origin_unit,"origin"))
			set .l1 = Lightning.createOO("DRAL",.target,.caster)
			set .l1.oz1 = .target.pivot_z
			set .l1.oz2 = .caster.pivot_z
			call .l1.refreshPosition()
			set .l2 = Lightning.createOO("DRAM",.target,.caster)
			set .l2.oz1 = .target.pivot_z
			set .l2.oz2 = .caster.pivot_z
			call .l2.refreshPosition()
			/*체인*/
			set .ch = Chain.create(CurveLinear.create(0,0,0,0,0,0))
			call .ch.add(Effect.create(EFFECT_PATH2,0,0,0,0).setTeamColor(.caster.owner).setScale(0.75))
			call .ch.add(Effect.create(EFFECT_PATH2,0,0,0,0).setTeamColor(.caster.owner).setScale(0.75))
			call .ch.add(Effect.create(EFFECT_PATH2,0,0,0,0).setTeamColor(.caster.owner).setScale(0.75))
			call .ch.setCaster(.caster)
			call .ch.setTarget(.target)
			call .ch.refresh()
			/*Effect*/
			set .ef = Effect.create(EFFECT_PATH2,.caster.x,.caster.y,.caster.z+.caster.pivot_z,270)
			call .ef.setAnim(ANIM_TYPE_STAND)
			call .ef.setScale(1.75)
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call .l1.destroy()
			call .l2.destroy()
			/*체인*/
			call .ch.destroy()
			/*이펙트*/
			call .ef.remove()
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

//!Buff20h0 자연의 결속(캐스터)
scope Buff20h0 initializer init

	//! runtextmacro buffParam20h0()

	globals

	endglobals

	public struct main extends Buff

		method relativeTooltip takes nothing returns string
			return "대상 유닛을 강화합니다."
		endmethod

		method update takes nothing returns boolean
			return true
		endmethod

		method init takes nothing returns boolean
			set .permanent = true
			call suspendFree()
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

//!Ability20h0 자연의 결속
scope Ability20h0 initializer init

		//! runtextmacro abilityParam20h0()
		
		globals
			private constant string ICON_PATH2 = "ReplaceableTextures\\CommandButtons\\BTNCancel.blp"
			private trigger MY_RESPOND = CreateTrigger()
			private integer MY_RESPOND_ABILITY = 0
			private boolean MY_RESPOND_FLAG = false
			private integer MY_RESPOND_RIDE_INSTANCE = 0
		endglobals
	
		private struct myride extends Riding

			Buff bf1 = 0
			Buff bf2 = 0

			static method create takes Unit caster, Unit target, integer level returns thistype
				local Ability a = caster.getAbilityById(ID)
				//! runtextmacro ridingAllocate("caster","target","level","ID")
				call setPosition(450.,0,-90)
				set .bf1 = Buff.add(.caster,.caster,'20h0',.level,0.)
				set .bf2 = Buff.add(.caster,.target,'20h1',.level,0.)
				call .caster.plusStatus(ENUM_STATUS_HIDE)
				call .caster.plusStatus(ENUM_STATUS_EVASION)
				if a > 0 then
					set MY_RESPOND_ABILITY = a
					set MY_RESPOND_FLAG = true
					set MY_RESPOND_RIDE_INSTANCE = this
					call TriggerEvaluate(MY_RESPOND)
				endif
				set .id = ID
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				local Ability a = .caster.getAbilityById(ID)
				call .caster.minusStatus(ENUM_STATUS_HIDE)
				call .caster.minusStatus(ENUM_STATUS_EVASION)
				call .bf1.destroy()
				call .bf2.destroy()
				if a > 0 then
					set MY_RESPOND_ABILITY = a
					set MY_RESPOND_FLAG = false
					call TriggerEvaluate(MY_RESPOND)
				endif
			endmethod

		endstruct

		private struct dolzin extends Charge

			Lightning l1 = 0
			Lightning l2 = 0

			// method suspendFilterAdditional takes nothing returns boolean
			// 	if Riding.getByTarget(.target) > 0 then
			// 		call setSuspendEventFlag(Actor.SUSPEND_TYPE_TARGET_LOSS,ENUM_STATUS_WHOKNOWS)
			// 		return true
			// 	endif
			// 	return false
			// endmethod

			method executeTarget takes Unit target returns nothing
				call myride.create(.caster,target,level)
				set .want_destroy = true
			endmethod

			static method create takes Unit caster, Unit target, integer level returns thistype
				//! runtextmacro chargeAllocate("caster","VELO","0.")
				set .level = level
				set .target = target
				set .affect_invincible = true
				set .affect_enemy = false
				set .affect_ally = true
				set .suspend_target_dead = false
				set .target_distance_flag_3d = false
				/*라이트닝*/
				set .l1 = Lightning.createOO("DRAL",.target,.caster)
				set .l1.oz1 = .target.pivot_z
				set .l1.oz2 = .caster.pivot_z
				call .l1.refreshPosition()
				set .l2 = Lightning.createOO("DRAM",.target,.caster)
				set .l2.oz1 = .target.pivot_z
				set .l2.oz2 = .caster.pivot_z
				call .l2.refreshPosition()
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .l1.destroy()
				call .l2.destroy()
			endmethod

		endstruct

		public struct main extends Ability
	
			Riding ride = 0
			boolean state = false

			method setState takes boolean flag returns nothing
				if flag then
					/*비탑승 -> 탑승*/
					/*스킬을 '내리기' 로 전환*/
					set .useable_cast = true
					set .manacost = 0
					set .is_target = false
					set .cast_range = -1
					set .activate_event = false
					set .is_immediate = true
					set .icon = ICON_PATH2
					set .is_charge = false
					set .is_ride = false
				else
					/*탑승 -> 비탑승*/
					/*스킬을 '결속' 으로 전환*/
					set .manacost = MANACOST
					set .useable_cast = false
					set .is_target = true
					set .cast_range = 600.
					set .activate_event = true
					set .is_immediate = false
					set .icon = getTypeIconPath(.id)
					set .is_charge = true
					set .is_ride = true
					//
					set .ride = 0
				endif
				set .state = flag
				set CUSTOM_RESPOND_UI_REFRESH_PLAYER = .owner.owner
				set CUSTOM_RESPOND_UI_REFRESH_SLOT = -1
				set CUSTOM_RESPOND_UI_REFRESH_ABILITY = this
				call Event.activate(ENUM_EVENT_ABILITY_UI_REFRESH)
				set CUSTOM_RESPOND_UI_REFRESH_ABILITY = 0
			endmethod

			//! runtextmacro abilityTooltip20h0()

			method execute takes nothing returns nothing
				if .state then
					/*이미 타고있으면*/
					/*내리기 작동*/
					if .ride > 0 then
						call .ride.destroy()
						/*스테이트 변경은 알아서 됨*/
					endif
				else
					/**/
					call dolzin.create(.owner,Unit_prototype.get(.command_target),.level)
				endif
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .target_useable_invincible = true
				set .target_useable_enemy = false
				set .target_useable_ally = true
				set .is_active = true
				set .preserve_order = false
				call setState(false)
				set .indicator = AbilityIndicator.create(this,.owner.owner)
				
			endmethod

			method deactivate takes nothing returns nothing
				if .ride > 0 then
					call DisableTrigger(MY_RESPOND)
					call .ride.destroy()
					call EnableTrigger(MY_RESPOND)
					set .ride = 0
				endif
				call setState(false)
			endmethod

			static method actorRespond takes nothing returns nothing
				local thistype this = MY_RESPOND_ABILITY
				if this <= 0 then
					return
				endif
				if MY_RESPOND_FLAG then
					set .ride = MY_RESPOND_RIDE_INSTANCE
				endif
				call setState(MY_RESPOND_FLAG)
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"대상 유닛 결속 및 강화\n ")
				/**/
				call TriggerAddCondition(MY_RESPOND,function thistype.actorRespond)
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability20i0 정찰탑 건설
scope Ability20i0 initializer init

		//! runtextmacro abilityParam20i0()
		
		globals
			private constant string EFFECT_PATH1 = "buildings\\human\\HumanTower\\HumanTower.mdl"
			private constant string EFFECT_PATH2 = "UI\\Feedback\\RallyPoint\\RallyPoint.mdl"
			private trigger MY_RESPOND = null
			private integer MY_RESPOND_EVENT_ID = 0
			private integer MY_RESPOND_ABILITY = 0
			private integer MY_RESPOND_TOWER = 0
		endglobals

		/*탑승*/
		private struct ride extends Riding

			AttatchedEffect ef = 0

			method ridingCommandFilter takes nothing returns boolean
				return true
			endmethod

			static method create takes Unit caster, Unit target returns thistype
				//! runtextmacro ridingAllocate("caster","target","0","ID")
				call .caster.plusStatus(ENUM_STATUS_HIDE)
				call .caster.plusStatus(ENUM_STATUS_EVASION)
				call .caster.plusStatus(ENUM_STATUS_DISABLED)
				set .ef = AttatchedEffect.create(EFFECT_PATH2,target)
				call .ef.setTeamColor(.caster.owner)
				set .ef.offset_z = 125.0
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .caster.minusStatus(ENUM_STATUS_HIDE)
				call .caster.minusStatus(ENUM_STATUS_EVASION)
				call .caster.minusStatus(ENUM_STATUS_DISABLED)
				call .ef.remove()
				set .ef = 0
			endmethod

		endstruct

		/*탑승하기*/
		private struct ract extends UnitActor

			method onComplete takes nothing returns nothing
				/*정찰탑 하나에 한명만 들어갈 수 있게*/
				if not .target.isUnitType(UNIT_TYPE_DEAD) and Riding.countInstanceById(.target,ID) < 1 then
					call ride.create(.caster,.target)
				endif
			endmethod

			static method create takes Unit caster, Unit target returns thistype
				local thistype this = allocate(caster,target,0.,0.,0,DELAY,true)
				set .progress_bar = ProgressBar.create("들어가기",.caster.owner)
				set .suspend_rclick = true
				set .suspend_stop = true
				return this
			endmethod

		endstruct

		/*정찰탑*/
		private struct mytower extends Servant
		
			Trigger main_trigger = 0
			Block block = 0

			method onInteract takes Unit caster returns nothing
				/*정찰탑 하나에 한명만 들어갈 수 있게*/
				if not isUnitType(UNIT_TYPE_DEAD) and Riding.countInstanceById(this,ID) < 1 then
					call ract.create(caster,this)
				endif
			endmethod

			static method deathCallback takes nothing returns nothing
				local thistype this = Trigger.getData(GetTriggeringTrigger())
				if CUSTOM_RESPOND_DEATH_UNIT != this then
					return
				endif
				/*블록은 일단 죽는 시점에 지워야함*/
				if .block > 0 and not .is_revive then
					call .block.destroy()
					set .block = 0
				endif
				/*사망 시 서번트 할당 해제*/
				set MY_RESPOND_ABILITY = .caster.getAbilityById(ID)
				if MY_RESPOND_ABILITY > 0 then
					set MY_RESPOND_EVENT_ID = 1
					set MY_RESPOND_TOWER = this
					call DisableTrigger(.main_trigger.main_trigger)
					call TriggerEvaluate(MY_RESPOND)
				endif
			endmethod

			static method create takes Unit caster, Block block, integer level returns thistype
				local thistype this = allocate(caster,UNIT_ID1,block.x,block.y,270.,level)
				set .block = block
				/*부활하지 않음*/
				set .is_revive = false
				/*중량화(밀려나지 않음)*/
				call plusStatus(ENUM_STATUS_HEAVY)
				/*이동 불가*/
				call BlzUnitDisableAbility(.origin_unit,'Amov',true,true)
				/*이 유닛은 건물임*/
				call UnitClass(this).plusClass(ENUM_UNIT_CLASS_STRUCTURE)
				/*사망트리거*/
				set .main_trigger = Trigger.create(this)
				call Event.register(.main_trigger.main_trigger,ENUM_EVENT_DEATH)
				call .main_trigger.addCondition(function thistype.deathCallback)
				/*레벨*/
				set .level = level
				/*애님*/
				call setAnim("stand")
				/*좌표조정*/
				set .x = block.x
				set .y = block.y
				/*타점Z*/
				set .pivot_z = 125.
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				/*블록*/
				if .block > 0 then
					call .block.destroy()
					set .block = 0
				endif
				/*사망트리거*/
				call .main_trigger.destroy()
				set .main_trigger = 0
			endmethod

		endstruct

		/*건축행동*/
		public struct actor extends UnitActor

			real manacost = 0.
			Effect ef = 0

			Block block = 0

			method onComplete takes nothing returns nothing
				set MY_RESPOND_ABILITY = .caster.getAbilityById(ID)
				if MY_RESPOND_ABILITY > 0 then
					set .caster.mp = .caster.mp - .manacost
					set .caster.hp = .caster.hp - .caster.hp*DATA_REAL1
					set MY_RESPOND_TOWER = mytower.create(.caster,.block,.level)
					set MY_RESPOND_EVENT_ID = 0
					call TriggerEvaluate(MY_RESPOND)
					set .block = 0
				endif
			endmethod

			static method create takes Unit caster, real x, real y, integer level, real manacost returns thistype
				local thistype this = allocate(caster,0,x,y,level,CAST,true)
				call .caster.restoreMP(manacost)
				set .x = Block.getModX(.x)
				set .y = Block.getModY(.y)
				set .manacost = manacost
				set .suspend_rclick = true
				set .suspend_stop = true
				call .caster.setAnim("attack")
				call .caster.setAnim("stand work")
				call .caster.queueAnim("stand work")
				call SetUnitFacing(.caster.origin_unit,Math.anglePoints(.caster.x,.caster.y,.x,.y))
				/*프로그레스*/
				set .progress_bar = ProgressBar.create(NAME,.caster.owner)
				/*건축이펙트*/
				set .ef = Effect.create(EFFECT_PATH1,.x,.y,2.,270.).setAnim(ANIM_TYPE_BIRTH)
				/*블록인스턴스*/
				set .block = Block.create(x,y)
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .caster.queueAnim("stand ready")
				/*건축이펙트*/
				call .ef.remove()
				/*건축 실패 시 블록인스턴스 파괴(성공했을 때에는 타워한테 인스턴스 인계)*/
				if .block > 0 then
					call .block.destroy()
				endif
				set .block = 0
			endmethod

		endstruct

		private struct ind extends BlockIndicator

			method beforeRefresh takes nothing returns nothing
				set .x = Mouse.getVX(.abil.owner.owner)
				set .y = Mouse.getVY(.abil.owner.owner)
			endmethod

			static method create takes Ability_prototype abil, player owner returns thistype
				local thistype this = allocate(abil,owner)
				return this
			endmethod

		endstruct

		public struct main extends Ability
	
			//! runtextmacro abilityTooltip20i0()

			method execute takes nothing returns nothing
				call actor.create(.owner,.command_x,.command_y,.level,.manacost)
			endmethod

			/*Override*/
			/*블록 점유중이 아니어야함*/
			method releaseFilter takes nothing returns boolean
				if Block.get(.command_x,.command_y) > 0 or IsTerrainPathable(Block.getModX(.command_x),Block.getModY(.command_y),PATHING_TYPE_WALKABILITY) then
					set CUSTOM_RESPOND_ERROR_MESSAGE = "해당 위치에 건설할 수 없습니다."
					return false
				else
					return true
				endif
			endmethod
	
			method removeTower takes nothing returns nothing
				if .servant > 0 then
					call DisableTrigger(MY_RESPOND)
					call .servant.unSummon()
					call EnableTrigger(MY_RESPOND)
					set .servant = 0
				endif
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .cast_range = 155.
				set .is_active = true
				set .preserve_order = false
				set .indicator = ind.create(this,.owner.owner)
			endmethod

			method deactivate takes nothing returns nothing
				call removeTower()
			endmethod

			static method myRespondCallback takes nothing returns nothing
				local thistype this = MY_RESPOND_ABILITY
				local integer i = 0
				if MY_RESPOND_EVENT_ID == 0 then
					/*타워가 완성되었음 -> 기존 타워 제거 후 새 타워를 servant로 등록*/
					set i = MY_RESPOND_TOWER
					call removeTower()
					set .servant = i
				elseif MY_RESPOND_EVENT_ID == 1 then
					/*타워가 제거되었음 -> 핸들프리*/
					set .servant = 0
				endif
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"정찰탑 건설\n ")
				/**/
				set MY_RESPOND = CreateTrigger()
				call TriggerAddCondition(MY_RESPOND,function thistype.myRespondCallback)
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Buff20j0 늑대의 상(버프)
scope Buff20j0 initializer init

	//! runtextmacro buffParam20j0()

	globals
		public trigger MY_RESPOND = null
		public integer MY_RESPOND_EVENT_ID = 0
		public integer MY_RESPOND_BUFF = 0
		public integer MY_RESPOND_ABILITY = 0
	endglobals

	globals
		private constant integer SKIN_ID = 'SP07'
		private constant string EFFECT_PATH1 = "Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl"//"Abilities\\Spells\\Orc\\Bloodlust\\BloodlustTarget.mdl"
	endglobals

	public struct main extends Buff

		Trigger main_trigger = 0
		real as = 0.

		method relativeTooltip takes nothing returns string
			return "공격속도, 이동속도가 증가했으며 근접 기본공격 적중 피해량이 증가합니다."
		endmethod

		method intervalAction takes nothing returns nothing
			set .caster.mp = .caster.mp - DATA_INTEGER2*INTERVAL
			if .caster.mp <= 0 then
				set .want_kill = true
			endif
		endmethod

		static method damageCallback takes nothing returns nothing
			local thistype this = Trigger.getData(GetTriggeringTrigger())
			if CUSTOM_RESPOND_DAMAGE_ATTACKER != .target then
				return
			endif
			if CUSTOM_RESPOND_DAMAGE_RANGE_TYPE == Damage.RANGE_TYPE_MELEE and CUSTOM_RESPOND_DAMAGE_ATTACK_TYPE == Damage.ATTACK_TYPE_BASIC and /*
				*/CUSTOM_RESPOND_DAMAGE_ONHIT_TYPE == Damage.ONHIT_TYPE_ONHIT then
				/*'근접'기본공격*/
				set CUSTOM_RESPOND_DAMAGE_PLUS = CUSTOM_RESPOND_DAMAGE_PLUS + .owner.getCarculatedStatValue(DAMAGE_STAT1)*DAMAGE_AMPLIFIER1 * (1+DAMAGE_PER_LEVEL*(.level))
				set .caster.mp = .caster.mp + DATA_INTEGER2
			endif
		endmethod

		method update takes nothing returns boolean
			if .as != 0. then
				call .target.multiplyStatValue(ENUM_STAT_ATTACK_SPEED,-.as)
			endif
			set .as = DATA_REAL1+DATA_REAL2*(.level)
			call .target.multiplyStatValue(ENUM_STAT_ATTACK_SPEED,.as)
			return true
		endmethod

		method init takes nothing returns boolean
			set .permanent = true
			set MY_RESPOND_ABILITY = .caster.getAbilityById(ID)
			if MY_RESPOND_ABILITY > 0 then
				set MY_RESPOND_EVENT_ID = 0
				set MY_RESPOND_BUFF = this
				call TriggerEvaluate(MY_RESPOND)
			endif
			set .interval = INTERVAL
			call .target.plusStatValue(ENUM_STAT_MOVEMENT_SPEED,DATA_INTEGER1)
			call .target.addSkin(SKIN_ID)
			/*추뎀트리거*/
			set .main_trigger = Trigger.create(this)
			call Event.register(.main_trigger.main_trigger,ENUM_EVENT_DAMAGE_MODIFY)
			call .main_trigger.addCondition(function thistype.damageCallback)
			/*이펙*/
			call Effect.create(EFFECT_PATH1,.target.x,.target.y,.target.z+.target.pivot_z,0).kill()
			/*업데이트*/
			call update()
			/*변신 레지스터*/
			call Transform(this).register()
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call .target.multiplyStatValue(ENUM_STAT_ATTACK_SPEED,-.as)
			call .target.plusStatValue(ENUM_STAT_MOVEMENT_SPEED,-DATA_INTEGER1)
			call .target.removeSkin(SKIN_ID)
			set MY_RESPOND_ABILITY = .caster.getAbilityById(ID)
			if MY_RESPOND_ABILITY > 0 then
				set MY_RESPOND_EVENT_ID = 1
				call TriggerEvaluate(MY_RESPOND)
			endif
			/*추뎀트리거*/
			call .main_trigger.destroy()
			/*이펙*/
			call Effect.create(EFFECT_PATH1,.target.x,.target.y,.target.z+.target.pivot_z,0).kill()
			/*변신 레지스터*/
			call Transform(this).unregister()
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

//!Ability20j0 늑대의 상
scope Ability20j0 initializer init

		//! runtextmacro abilityParam20j0()

		public struct main extends Ability
	
			Buff bf = 0
			boolean state = false

			//! runtextmacro abilityTooltip20j0()

			method setState takes boolean flag returns nothing
				set .state = flag
				if flag then
					/*취소 -> 늑대변신*/
					set .manacost = 20
					set .icon = getTypeIconPath(.id)
				else
					/*늑대변신 -> 취소*/
					set .manacost = 0
					set .icon = "ReplaceableTextures\\CommandButtons\\BTNCancel.blp"
				endif
				set CUSTOM_RESPOND_UI_REFRESH_PLAYER = .owner.owner
				set CUSTOM_RESPOND_UI_REFRESH_SLOT = -1
				set CUSTOM_RESPOND_UI_REFRESH_ABILITY = this
				call Event.activate(ENUM_EVENT_ABILITY_UI_REFRESH)
				set CUSTOM_RESPOND_UI_REFRESH_ABILITY = 0
			endmethod

			method execute takes nothing returns nothing
				if .state then
					/*'변신하기'*/
					call Buff.add(.owner,.owner,ID,.level,0.)
				else
					/*'변신풀기'*/
					if .bf > 0 then
						call .bf.destroy()
					else
						call setState(true)
					endif
				endif
			endmethod

			method update takes nothing returns nothing
				if .bf > 0 then
					set .bf.level = .level
					call .bf.update()
				endif
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .preserve_order = true
				set .is_immediate = true
				call setState(true)
				
			endmethod
	
			method deactivate takes nothing returns nothing
				if .bf > 0 then
					call .bf.destroy()
				endif
			endmethod

			static method myRespondCallback takes nothing returns nothing
				local thistype this = Buff20j0_MY_RESPOND_ABILITY
				if this <= 0 then
					return
				endif
				if Buff20j0_MY_RESPOND_EVENT_ID == 0 then
					/*버프가 생성됐음*/
					set .bf = Buff20j0_MY_RESPOND_BUFF
					call setState(false)
				elseif Buff20j0_MY_RESPOND_EVENT_ID == 1 then
					/*버프가 제거됐음*/
					set .bf = 0
					call setState(true)
				endif
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"공격속도 증가\n ")
				/**/
				set Buff20j0_MY_RESPOND = CreateTrigger()
				call TriggerAddCondition(Buff20j0_MY_RESPOND,function thistype.myRespondCallback)
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Buff20k0 고대 코끼리의 상(버프)
scope Buff20k0 initializer init

	//! runtextmacro buffParam20k0()

	globals
		public trigger MY_RESPOND = null
		public integer MY_RESPOND_EVENT_ID = 0
		public integer MY_RESPOND_BUFF = 0
		public integer MY_RESPOND_ABILITY = 0
	endglobals

	globals
		private constant integer SKIN_ID = 'SP08'
		private constant string EFFECT_PATH1 = "Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl"//"Abilities\\Spells\\Orc\\Bloodlust\\BloodlustTarget.mdl"
	endglobals

	public struct main extends Buff

		Trigger main_trigger = 0

		method relativeTooltip takes nothing returns string
			return "최대체력과 근접 기본공격 적중 피해량이 증가했습니다."
		endmethod

		method intervalAction takes nothing returns nothing
			set .caster.mp = .caster.mp - DATA_INTEGER2*INTERVAL
			if .caster.mp <= 0 then
				set .want_kill = true
			endif
		endmethod

		static method damageCallback takes nothing returns nothing
			local thistype this = Trigger.getData(GetTriggeringTrigger())
			if CUSTOM_RESPOND_DAMAGE_ATTACKER != .target then
				return
			endif
			if CUSTOM_RESPOND_DAMAGE_RANGE_TYPE == Damage.RANGE_TYPE_MELEE and CUSTOM_RESPOND_DAMAGE_ATTACK_TYPE == Damage.ATTACK_TYPE_BASIC then
				/*'근접'기본공격*/
				set CUSTOM_RESPOND_DAMAGE_PLUS = CUSTOM_RESPOND_DAMAGE_PLUS + .owner.getCarculatedStatValue(DAMAGE_STAT1)*DAMAGE_AMPLIFIER1 * (1+DAMAGE_PER_LEVEL*(.level))
			endif
		endmethod

		method init takes nothing returns boolean
			set .permanent = true
			set MY_RESPOND_ABILITY = .caster.getAbilityById(ID)
			if MY_RESPOND_ABILITY > 0 then
				set MY_RESPOND_EVENT_ID = 0
				set MY_RESPOND_BUFF = this
				call TriggerEvaluate(MY_RESPOND)
			endif
			set .interval = INTERVAL
			call .target.multiplyStatValue(ENUM_STAT_MAXHP,DATA_REAL1)
			call .target.plusStatValue(ENUM_STAT_MOVEMENT_SPEED,DATA_INTEGER1)
			call .target.addSkin(SKIN_ID)
			/*추뎀트리거*/
			set .main_trigger = Trigger.create(this)
			call Event.register(.main_trigger.main_trigger,ENUM_EVENT_DAMAGE_MODIFY)
			call .main_trigger.addCondition(function thistype.damageCallback)
			/*이펙*/
			call Effect.create(EFFECT_PATH1,.target.x,.target.y,.target.z+.target.pivot_z,0).kill()
			/*변신 레지스터*/
			call Transform(this).register()
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call .target.multiplyStatValue(ENUM_STAT_MAXHP,-DATA_REAL1)
			call .target.plusStatValue(ENUM_STAT_MOVEMENT_SPEED,-DATA_INTEGER1)
			call .target.removeSkin(SKIN_ID)
			set MY_RESPOND_ABILITY = .caster.getAbilityById(ID)
			if MY_RESPOND_ABILITY > 0 then
				set MY_RESPOND_EVENT_ID = 1
				call TriggerEvaluate(MY_RESPOND)
			endif
			/*추뎀트리거*/
			call .main_trigger.destroy()
			/*이펙*/
			call Effect.create(EFFECT_PATH1,.target.x,.target.y,.target.z+.target.pivot_z,0).kill()
			/*변신 레지스터*/
			call Transform(this).unregister()
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

//!Ability20k0 고대 코끼리의 상
scope Ability20k0 initializer init

		//! runtextmacro abilityParam20k0()

		public struct main extends Ability
	
			Buff bf = 0
			boolean state = false

			//! runtextmacro abilityTooltip20k0()

			method setState takes boolean flag returns nothing
				set .state = flag
				if flag then
					/*취소 -> 늑대변신*/
					set .manacost = 20
					set .icon = getTypeIconPath(.id)
				else
					/*늑대변신 -> 취소*/
					set .manacost = 0
					set .icon = "ReplaceableTextures\\CommandButtons\\BTNCancel.blp"
				endif
				set CUSTOM_RESPOND_UI_REFRESH_PLAYER = .owner.owner
				set CUSTOM_RESPOND_UI_REFRESH_SLOT = -1
				set CUSTOM_RESPOND_UI_REFRESH_ABILITY = this
				call Event.activate(ENUM_EVENT_ABILITY_UI_REFRESH)
				set CUSTOM_RESPOND_UI_REFRESH_ABILITY = 0
			endmethod

			method execute takes nothing returns nothing
				if .state then
					/*'변신하기'*/
					call Buff.add(.owner,.owner,ID,.level,0.)
				else
					/*'변신풀기'*/
					if .bf > 0 then
						call .bf.destroy()
					else
						call setState(true)
					endif
				endif
			endmethod

			method update takes nothing returns nothing
				if .bf > 0 then
					set .bf.level = .level
					call .bf.update()
				endif
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .preserve_order = true
				set .is_immediate = true
				call setState(true)
				
			endmethod
	
			method deactivate takes nothing returns nothing
				if .bf > 0 then
					call .bf.destroy()
				endif
			endmethod

			static method myRespondCallback takes nothing returns nothing
				local thistype this = Buff20k0_MY_RESPOND_ABILITY
				if this <= 0 then
					return
				endif
				if Buff20k0_MY_RESPOND_EVENT_ID == 0 then
					/*버프가 생성됐음*/
					set .bf = Buff20k0_MY_RESPOND_BUFF
					call setState(false)
				elseif Buff20k0_MY_RESPOND_EVENT_ID == 1 then
					/*버프가 제거됐음*/
					set .bf = 0
					call setState(true)
				endif
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"최대체력 증가\n ")
				/**/
				set Buff20k0_MY_RESPOND = CreateTrigger()
				call TriggerAddCondition(Buff20k0_MY_RESPOND,function thistype.myRespondCallback)
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability20l0 달빛 글레이브
scope Ability20l0 initializer init

		//! runtextmacro abilityParam20l0()
		
		globals
			private constant string EFFECT_PATH1 = "Abilities\\Weapons\\SentinelMissile\\SentinelMissile.mdl"
		endglobals

		struct glave extends Glave

			method nextTargetAction takes boolean exists returns boolean
				local real ra = GetRandomReal(0,360)
				local real dx = 0.
				local real dy = 0.
				set .onhit_type = Damage.ONHIT_TYPE_NONHIT
				if exists then
					set .damage = .damage * DAMAGE_PRIMARY
					return false
				else
					set .damage = .damage * DAMAGE_SECONDARY
					call setTarget(.target_previous)
					// DO BEZIER
					set .curve = CurveBezier3.create(.x,.y,.z,.target.x,.target.y,.target.z+.target.pivot_z)
					set .curve.overtime = 0.5
					set dx = Math.pPX(.target.x,450.,ra-45.)
					set dy = Math.pPY(.target.y,450.,ra-45.)
					call CurveBezier3(.curve).setX(Curve.POINT_MIDDLE+0,dx)
					call CurveBezier3(.curve).setY(Curve.POINT_MIDDLE+0,dy)
					call CurveBezier3(.curve).setZ(Curve.POINT_MIDDLE+0,.target.z+100.)
					set dx = Math.pPX(.target.x,450.,ra+45.)
					set dy = Math.pPY(.target.y,450.,ra+45.)
					call CurveBezier3(.curve).setX(Curve.POINT_MIDDLE+1,dx)
					call CurveBezier3(.curve).setY(Curve.POINT_MIDDLE+1,dy)
					call CurveBezier3(.curve).setZ(Curve.POINT_MIDDLE+1,.target.z+100.)
					set .count = 0
					return false
				endif
			endmethod

			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,EFFECT_PATH1,target,STARTAT,RANGE,TARGET_MAX)
				set .velo = VELO
				call setDamageFlagById(ID)
				set .damage = .owner.getCarculatedStatValue(DAMAGE_STAT1)*DAMAGE_AMPLIFIER1*(1+DAMAGE_PER_LEVEL*(level))
				set .weapon_type = WEAPON_TYPE_METAL_MEDIUM_SLICE
				return this
			endmethod

		endstruct
	
		public struct actor extends MeleeAttack

			method onComplete takes nothing returns nothing
				call glave.create(.caster,.target,.level)
				call Backswing.create(.caster)
			endmethod
	
			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target)
				set .level = level
				return this
			endmethod

		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip20l0()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"다수 타격 글레이브 투척")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability20m0 투창
scope Ability20m0 initializer init

		//! runtextmacro abilityParam20m0()
		
		globals
			private constant string EFFECT_PATH1 = "Abilities\\Weapons\\Banditmissile\\Banditmissile.mdl"
		endglobals

		public struct dash extends Charge

			static method create takes Unit caster, real x, real y returns thistype
				local real a = Math.anglePoints(caster.x,caster.y,x,y)
				//! runtextmacro chargeAllocate("caster","caster.getCarculatedStatValue(ENUM_STAT_MOVEMENT_SPEED)*CHARGE_SPEED*(1.0/CHARGE_DURATION)","a")
				set .duration = CHARGE_DURATION
				call caster.issueImmediateOrder("stop")
				return this
			endmethod

		endstruct
	
		public struct backswing extends Backswing

			boolean right_pressed = false
			real right_x = 0.
			real right_y = 0.

			method onRightClick takes nothing returns nothing
				if CUSTOM_RESPOND_CLICK_TARGET == null then
					set .right_pressed = true
					set .right_x = CUSTOM_RESPOND_CLICK_X
					set .right_y = CUSTOM_RESPOND_CLICK_Y
				endif
				//DO DASH
				call dash.create(.caster,.right_x,.right_y)
				set want_destroy = true
			endmethod

			static method create takes Unit caster returns thistype
				local thistype this = allocate(caster)
				set .duration = BACKSWING/caster.attack_speed
				set .suspend_rclick = false
				return this
			endmethod

		endstruct

		public struct actor extends MeleeAttack

			boolean right_pressed = false
			real right_x = 0.
			real right_y = 0.

			method onRightClick takes nothing returns nothing
				if CUSTOM_RESPOND_CLICK_TARGET == null then
					set .right_pressed = true
					set .right_x = CUSTOM_RESPOND_CLICK_X
					set .right_y = CUSTOM_RESPOND_CLICK_Y
				endif
			endmethod

			method onComplete takes nothing returns nothing
				local real a = Math.anglePoints(.caster.x,.caster.y,.target.x,.target.y)
				local real dx = Math.pPX(.caster.x,STARTAT,a)
				local real dy = Math.pPY(.caster.y,STARTAT,a)
				local Missile ms = Missile.create(.caster,EFFECT_PATH1,dx,dy,.caster.z+.caster.pivot_z,a)
				call ms.setTarget(.target)
				call ms.setDamageFlagById(ID)
				set ms.velo = VELO
				set ms.weapon_type = WEAPON_TYPE_METAL_LIGHT_CHOP
				set ms.damage = .owner.getCarculatedStatValue(DAMAGE_STAT1)*DAMAGE_AMPLIFIER1*(1+DAMAGE_PER_LEVEL*(level))
				if .right_pressed then
					//DO DASH
					call dash.create(.caster,.right_x,.right_y)
				else
					call backswing.create(.caster)
				endif
			endmethod
	
			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target)
				set .suspend_rclick = false
				set .duration = DELAY/caster.attack_speed
				call .caster.setAnimSpeed(0.5*.caster.attack_speed)
				set .level = level
				return this
			endmethod

		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip20m0()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"투창 후 대쉬")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Buff20n0 보강(버프)
scope Buff20n0 initializer init

	//! runtextmacro buffParam20n0()
	public struct main extends Buff

		static constant string EFFECT_PATH1 = "Effects\\HexagonShield.mdl"

		real v = 0.

		method relativeTooltip takes nothing returns string
			return "방어력과 저항력이 증가했습니다."
		endmethod

		method update takes nothing returns boolean
			/*스탯*/
			call .target.multiplyStatValue(ENUM_STAT_RESISTANCE,-.v)
			call .target.multiplyStatValue(ENUM_STAT_DEFENSE,-.v)
			set .v = DATA_REAL1 + (DATA_REAL2*(.level))
			call .target.multiplyStatValue(ENUM_STAT_RESISTANCE,.v)
			call .target.multiplyStatValue(ENUM_STAT_DEFENSE,.v)
			return true
		endmethod

		method init takes nothing returns boolean
			call addEffect(Effect.createAttatched(EFFECT_PATH1,.target.origin_unit,"origin"))
			set .v = DATA_REAL1 + (DATA_REAL2*(.level))
			call .target.multiplyStatValue(ENUM_STAT_RESISTANCE,.v)
			call .target.multiplyStatValue(ENUM_STAT_DEFENSE,.v)
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call .target.multiplyStatValue(ENUM_STAT_RESISTANCE,-.v)
			call .target.multiplyStatValue(ENUM_STAT_DEFENSE,-.v)
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

//!Ability20n0 보강
scope Ability20n0 initializer init

		//! runtextmacro abilityParam20n0()
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip20n0()

			method execute takes nothing returns nothing
				call Buff.add(.owner,.owner,'20n0',.level,DURATION)
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .preserve_order = true
				set .is_immediate = true
				set .useable_cast = true
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"내구력 증강")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//================================언데드스킬================================

//!Buff20o0 광란(버프)
scope Buff20o0 initializer init

	//! runtextmacro buffParam20o0()

	public struct main extends Buff

		static constant string EFFECT_PATH1 = "Abilities\\Spells\\Undead\\UnholyFrenzy\\UnholyFrenzyTarget.mdl"

		trigger main_trigger = null
		triggercondition main_cond = null

		method relativeTooltip takes nothing returns string
			return "공격속도와 기본공격 피해량이 증가한 대신 적 공격 시 체력을 잃습니다."
		endmethod

		method getAdditionalDamage takes nothing returns real
			return .target.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 * (1+DAMAGE_PER_LEVEL * (.level))
		endmethod

		method reduceHP takes real val returns nothing
			local real th = .target.getCarculatedStatValue(DAMAGE_STAT1) * DATA_REAL3
			if .target.hp <= th then
				return
			endif
			if .target.hp - val <= th then
				set .target.hp = th
			else
				set .target.hp = .target.hp - val
			endif
		endmethod

		static method cond takes nothing returns nothing
			local thistype this = Trigger.getData(GetTriggeringTrigger())
			if Event.getValue() == ENUM_EVENT_DAMAGE_MODIFY then
				if CUSTOM_RESPOND_DAMAGE_ATTACKER != .target then
					return
				endif
				if CUSTOM_RESPOND_DAMAGE_ATTACK_TYPE == Damage.ATTACK_TYPE_BASIC then
					set CUSTOM_RESPOND_DAMAGE_PLUS = CUSTOM_RESPOND_DAMAGE_PLUS + getAdditionalDamage()
					call reduceHP(.target.getCarculatedStatValue(DAMAGE_STAT1) * DATA_REAL2)
				endif
			elseif Event.getValue() == ENUM_EVENT_WEAPON_CHANGE then
				if CUSTOM_RESPOND_WEAPON_CHANGE_UNIT != .target then
					return
				endif
				if CUSTOM_RESPOND_WEAPON_CHANGE_OLD != CUSTOM_RESPOND_WEAPON_CHANGE_NEW then
					call destroy()
				endif
			endif
		endmethod

		method update takes nothing returns boolean
			return true
		endmethod

		method init takes nothing returns boolean
			call addEffect(Effect.createAttatched(EFFECT_PATH1,.target.origin_unit,"overhead"))
			call .target.plusStatValue(ENUM_STAT_ATTACK_SPEED,DATA_REAL1)
			set .main_trigger = Trigger.new(this)
			set .main_cond = TriggerAddCondition(.main_trigger,function thistype.cond)
			call Event.register(.main_trigger,ENUM_EVENT_DAMAGE_MODIFY)
			call Event.register(.main_trigger,ENUM_EVENT_WEAPON_CHANGE)
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call .target.plusStatValue(ENUM_STAT_ATTACK_SPEED,-DATA_REAL1)
			//! runtextmacro destroyTriggerAndCondition(".main_trigger",".main_cond")
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

//!Ability20o0 광란
scope Ability20o0 initializer init

		//! runtextmacro abilityParam20o0()
	
		public struct main extends Ability
	
			method useFilterAdditional takes nothing returns boolean
				if .owner.weapon_ability.weapon_is_ranged then
					set CUSTOM_RESPOND_ERROR_MESSAGE = "원거리 무기로 사용할 수 없는 능력입니다."
					return false
				else
					return true
				endif
			endmethod

			//! runtextmacro abilityTooltip20o0()

			method execute takes nothing returns nothing
				local Buff b = Buff.add(.owner,.owner,ID,.level,DURATION)
				set b.level = .level
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .preserve_order = true
				set .is_immediate = true
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"공격속도 급증 및 체력 희생\n ")
			endmethod

			method executeAI takes nothing returns boolean
				return useRequest(GetUnitX(.command_target),GetUnitY(.command_target),.command_target,false)
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Buff20p0 산성 거미줄(버프)
scope Buff20p0 initializer init

	//! runtextmacro buffParam20p0()

	globals
		private constant string EFFECT_PATH1 = "Abilities\\Spells\\Undead\\Web\\Web_AirTarget.mdl"
	endglobals

	public struct main extends Buff

		real v1 = 0.
		real v2 = 0.

		method relativeTooltip takes nothing returns string
			return "이동속도와 방어력이 감소했으며 이동기 사용이 제한됩니다."
		endmethod

		method update takes nothing returns boolean
			call .target.minusStatValue(ENUM_STAT_DEFENSE,-.v2)
			set .v2 = .caster.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 * (1+DAMAGE_PER_LEVEL*(.level))
			call .target.minusStatValue(ENUM_STAT_DEFENSE,.v2)
			return true
		endmethod

		method init takes nothing returns boolean
			call addEffect(Effect.createAttatched(EFFECT_PATH1,.target.origin_unit,"chest"))
			set .v1 = Math.reduceDivisor(DATA_REAL1)
			set .v2 = .caster.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 * (1+DAMAGE_PER_LEVEL*(.level))
			call .target.divideStatValue(ENUM_STAT_MOVEMENT_SPEED,.v1)
			call .target.minusStatValue(ENUM_STAT_DEFENSE,.v2)
			call .target.plusStatus(ENUM_STATUS_ROOT)
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call .target.divideStatValue(ENUM_STAT_MOVEMENT_SPEED,-.v1)
			call .target.minusStatValue(ENUM_STAT_DEFENSE,-.v2)
			call .target.minusStatus(ENUM_STATUS_ROOT)
		endmethod

	endstruct

	//! runtextmacro buffEnd()

endscope

//!Ability20p0 산성 거미줄
scope Ability20p0 initializer init

		//! runtextmacro abilityParam20p0()
		
		globals
			private constant string EFFECT_PATH1 = "Abilities\\Spells\\Undead\\Web\\Webmissile.mdl"
		endglobals
	
		private struct ms extends Missile

			method executeTarget takes Unit target returns nothing
				call damageTarget(target)
				call Buff.add(.owner,target,ID,.level,DURATION)
			endmethod

			static method create takes Unit owner, real x, real y, real z, real yaw, integer level returns thistype
				local thistype this = allocate(owner,EFFECT_PATH1,x,y,z,yaw)
				set .level = level
				set .velo = VELO
				set .damage = ( .owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*(level) )
				call setDamageFlagById(ID)
				call setCollision(RADIUS2)
				call setDuration((RANGE-STARTAT)/VELO)
				set .weapon_type = WEAPON_TYPE_METAL_LIGHT_CHOP
				return this
			endmethod

		endstruct

		public struct actor extends UnitActor
	
			real angle = 0.

			method onComplete takes nothing returns nothing
				local ms m = ms.create(.caster,/*
				*/Math.pPX(.caster.x,STARTAT,Math.anglePoints(.caster.x,.caster.y,.x,.y)),/*
				*/Math.pPY(.caster.y,STARTAT,Math.anglePoints(.caster.x,.caster.y,.x,.y)),.caster.pivot_z,/*
				*/.angle,.level)
				call UnitActor.create(.caster,0,0.,0.,0,BACKSWING,true)
			endmethod
	
			static method create takes Unit u, real x, real y, real delay, integer level returns thistype
				local thistype this = allocate(u,0,x,y,level,delay,true)
				set .angle = Math.anglePoints(.caster.x,.caster.y,.x,.y)
				call .caster.setAnim("attack")
				call .caster.setAnimSpeed(1.)
				call SetUnitFacing(.caster.origin_unit,Math.anglePoints(.caster.x,.caster.y,x,y))
				set .progress_bar = ProgressBar.create(NAME,.caster.owner)
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .caster.queueAnim("stand ready")
				call .caster.setAnimSpeed(1.)
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
				call .ef.setColor(117, 185, 60)
				call .circle.setColor(117, 185, 60)
				return this
			endmethod

		endstruct

		public struct main extends Ability

			//! runtextmacro abilityTooltip20p0()
	
			method execute takes nothing returns nothing
				call actor.create(.owner,.command_x,.command_y,.cast_delay,level)
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .cast_delay = DELAY
				set .indicator = ind.create(this,.owner.owner)
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"감속 그물 투척\n ")
			endmethod
	
			method executeAI takes nothing returns boolean
				return useRequest(GetUnitX(.command_target),GetUnitY(.command_target),.command_target,false)
			endmethod

		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability20q0 그림자 화살
scope Ability20q0 initializer init

		//! runtextmacro abilityParam20q0()
		
		globals
			private constant string EFFECT_PATH1 = "Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdl"
		endglobals

		public struct illusion extends Illusion

			static method create takes Unit caster, Unit target, integer level returns thistype
				local real ta = GetRandomReal(0.,360.)
				local real tx = Math.pPX(target.x,75.,ta)
				local real ty = Math.pPY(target.y,75.,ta)
				local thistype this = allocate(caster, target.id, tx, ty, ta-180., level, DURATION)
				set .damage_give = DATA_REAL3 * caster.damage_give
				call plusStatValue(ENUM_STAT_ATTACK,(.caster.getCarculatedStatValue(DAMAGE_STAT2) * DAMAGE_AMPLIFIER2) * (1+DAMAGE_PER_LEVEL*(level)))
				call issueTargetOrder("attack",target.origin_unit)
				call Effect.create(EFFECT_PATH1,.x,.y,.z,270.).setScale(1.11).kill()
				call setColor(0,0,0,200)
				call plusStatus(ENUM_STATUS_LOCUST)
				call copyAbility(target)
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call minusStatus(ENUM_STATUS_LOCUST)
			endmethod

		endstruct

		private struct mss extends Missile

			method executeTarget takes Unit target returns nothing
				call damageTarget(target)
				if UnitClass(.owner).getClass(ENUM_UNIT_CLASS_ILLUSION) <= 0 then
					if .owner.luckyTest(DATA_REAL1,DATA_REAL2) then
						call illusion.create(.owner,.target,.level)
					endif
				endif
			endmethod

			static method create takes Unit caster, Unit target, real x, real y, real z, real yaw, integer level returns thistype
				local thistype this = allocate(caster,EFFECT_PATH1,x,y,z,yaw)
				call setTarget(target)
				set .level = level
				set .velo = VELO
				call setDamageFlagById(ID)
				set .damage = (.owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1) * (1+DAMAGE_PER_LEVEL*(level))
				return this
			endmethod

		endstruct
	
		public struct actor extends MeleeAttack

			method onComplete takes nothing returns nothing
				local real a = Math.anglePoints(.caster.x,.caster.y,.target.x,.target.y)
				local mss ms = mss.create(.caster,.target,Math.pPX(.caster.x,STARTAT,a),Math.pPY(.caster.y,STARTAT,a),.caster.z+.caster.pivot_z,a,.level)
				call Backswing.create(.caster)
			endmethod
	
			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target)
				set .level = level
				return this
			endmethod

		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip20q0()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"원거리 공격\n대상 환영 생성")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Abilityu130 해골 전사 소환
scope Ability20r0 initializer init

		//! runtextmacro abilityParam20r0()
		
		globals
			private constant string EFFECT_PATH1 = "Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl"
		endglobals

		public struct skeleton extends Summon

			static method create takes Unit caster, real x, real y, real yaw, integer level, real tx, real ty returns thistype
				local thistype this = allocate(caster,UNIT_ID1,x,y,yaw,level,DURATION)
				local real a = Math.anglePoints(.caster.x,.caster.y,tx,ty)
				call setScale(0.95)
				call issuePointOrder("attack",Math.pPX(.caster.x,RANGE,a),Math.pPY(.caster.y,RANGE,a))
				call Effect.create(EFFECT_PATH1,.x,.y,.z+.pivot_z,0.).setScale(1.25).kill()
				call plusStatValue(ENUM_STAT_ATTACK,.caster.getCarculatedStatValue(DAMAGE_STAT1) *DAMAGE_AMPLIFIER1*(1+DAMAGE_PER_LEVEL*(level)))
				call plusStatValue(ENUM_STAT_MAXHP,.caster.getCarculatedStatValue(DAMAGE_STAT2) *DAMAGE_AMPLIFIER2*(1+DAMAGE_PER_LEVEL*(level)))
				set .damage_give = caster.damage_give * DATA_REAL1
				set .hide_when_dead = false
				return this
			endmethod

		endstruct

		public struct actor extends UnitActor
	
			real angle = 0.

			method onComplete takes nothing returns nothing
				local integer i = 0
				loop
					exitwhen i >= COUNT
					call skeleton.create(.caster,Math.pPX(.caster.x,STARTAT,.angle),Math.pPY(.caster.y,STARTAT,.angle),.angle,.level,.x,.y)
					set i = i + 1
				endloop
				call UnitActor.create(.caster,0,0.,0.,0,BACKSWING,true)
			endmethod
	
			static method create takes Unit u, real x, real y, real delay, integer level returns thistype
				local thistype this = allocate(u,0,x,y,level,delay,true)
				set .angle = Math.anglePoints(.caster.x,.caster.y,.x,.y)
				call .caster.setAnim("attack")
				call .caster.setAnimSpeed(1.1)
				call SetUnitFacing(.caster.origin_unit,Math.anglePoints(.caster.x,.caster.y,x,y))
				set .progress_bar = ProgressBar.create(NAME,.caster.owner)
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .caster.queueAnim("stand ready")
				call .caster.setAnimSpeed(1.)
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
				call .ef.setColor(0, 88, 7)
				call .circle.setColor(0, 88, 7)
				return this
			endmethod

		endstruct

		public struct main extends Ability

			//! runtextmacro abilityTooltip20r0()
	
			method execute takes nothing returns nothing
				call actor.create(.owner,.command_x,.command_y,.cast_delay,level)
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .cast_delay = DELAY
				set .indicator = ind.create(this,.owner.owner)
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"해골 전사 소환\n ")
			endmethod
	
			method executeAI takes nothing returns boolean
				return useRequest(GetUnitX(.command_target),GetUnitY(.command_target),.command_target,false)
			endmethod

		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Buff20s0 부패가스(버프)
scope Buff20s0 initializer init
	//! runtextmacro buffParam20s0()

	public struct main extends Buff

		static constant string EFFECT_PATH1 = "Units\\Undead\\PlagueCloud\\PlagueCloudtarget.mdl"

		method relativeTooltip takes nothing returns string
			return "받는 회복량이 감소했습니다."
		endmethod

		method update takes nothing returns boolean
			return true
		endmethod

		method init takes nothing returns boolean
			call addEffect(Effect.createAttatched(EFFECT_PATH1,.target.origin_unit,"head"))
			call .target.divideStatValue(ENUM_STAT_HEAL_AMP,(1/(1-DATA_REAL1)) - 1)
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call .target.divideStatValue(ENUM_STAT_HEAL_AMP,-((1/(1-DATA_REAL1)) - 1))
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

//!Abilityu140 부패가스
scope Ability20s0 initializer init

		//! runtextmacro abilityParam20s0()
		
		globals
			private constant string EFFECT_PATH1 = "Abilities\\Spells\\Undead\\PlagueCloud\\PlagueCloudCaster.mdl"
			private trigger DESTROY_REQUEST = CreateTrigger()
			private integer DESTROY_REQUEST_ABILITY = 0
		endglobals

		private struct exx extends Explosion

			Ability a = 0
			integer level = 1
			Effect ef = 0

			method executeExplosion takes Unit target returns nothing
				call damageTarget(target)
				//if damageTarget(target) > 0. then
					call Buff.add(.owner,target,ID,.level,DURATION)
				//endif
			endmethod

			method beforeExplosion takes nothing returns nothing
				set .x = .owner.x
				set .y = .owner.y
				set .damage = ( .owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*(.level) )
			endmethod

			static method create takes Unit caster, integer level returns thistype
				local thistype this = allocate(caster,0.,0.,RADIUS3)
				set .activate_initial = false
				set .count = COUNT
				set .interval = INTERVAL
				call setDamageFlagById(ID)
				set .level = level
				/*이펙트*/
				set .ef = Effect.createAttatched(EFFECT_PATH1,.owner.origin_unit,"origin")
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .ef.kill()
				set .ef = 0
				set DESTROY_REQUEST_ABILITY = .a
				call TriggerEvaluate(DESTROY_REQUEST)
				set DESTROY_REQUEST_ABILITY = 0
			endmethod

		endstruct
	
		public struct main extends Ability

			private exx ex = 0
			private Trigger main_trigger = 0

			//! runtextmacro abilityTooltip20s0()

			method execute takes nothing returns nothing
				if .ex > 0 then
					set .ex.count = COUNT
				else
					set .ex = exx.create(.owner,.level)
					set .ex.a = this
					call .ex.activate()
				endif
				set .ex.level = .level
			endmethod

			static method damageAction takes nothing returns nothing
				local thistype this = Trigger.getData(GetTriggeringTrigger())
				if this <= 0 or .owner != CUSTOM_RESPOND_DAMAGE_TARGET then
					return
				endif
				call execute()
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
				/**/
				set .main_trigger = Trigger.create(this)
				call .main_trigger.addCondition(function thistype.damageAction)
				call Event.register(.main_trigger.main_trigger,ENUM_EVENT_DAMAGE_BEFORE_HPREDUCE)
			endmethod

			method deactivate takes nothing returns nothing
				if .ex > 0 then
					call .ex.destroy()
					set .ex = 0
				endif
				call .main_trigger.destroy()
			endmethod

			static method destroyRequest takes nothing returns nothing
				if DESTROY_REQUEST_ABILITY <= 0 then
					return
				endif
				set thistype(DESTROY_REQUEST_ABILITY).ex = 0
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"지속 범위피해 및\n대상 받는 치유량 감소")
				/**/
				call TriggerAddCondition(DESTROY_REQUEST,function thistype.destroyRequest)
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope