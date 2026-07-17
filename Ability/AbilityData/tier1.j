//!Ability1000 방패 밀어치기
scope Ability1000 initializer init
	
		//! runtextmacro abilityDataHeader1000()
	
		public struct mv extends Charge
	
			method executeExplosion takes Unit_prototype target returns nothing
				local Knockback kn = Knockback.create(target,KNOCKBACK_DISTANCE/KNOCKBACK_DURATION,.caster.yaw)
				if kn > 0 then
					set kn.z_velo = 300.
					set kn.gravity = (300.*2)/KNOCKBACK_DURATION
					set kn.duration = KNOCKBACK_DURATION
				endif
				call setDamageFlagById(ID)
				if target == .target then
					call customDamageTarget(target,.damage * DAMAGE_PRIMARY)
				else
					call customDamageTarget(target,.damage)
				endif
				call Effect.create(EF_ROCK,target.x,target.y,target.z+target.pivot_z,0).setScale(2.5).kill()
				call Buff.add(0,target,'Stun',0,0.5)
			endmethod
	
			method executeTarget takes Unit_prototype target returns nothing
				set .target = target
				call explosionAction()
				set .want_destroy = true
				call UnitActor.create(.caster,0,0.,0.,0,BACKSWING,true)
				call .caster.issueTargetOrder("attack",target.origin_unit)
			endmethod
	
			static method create takes Unit u, real yaw, integer level returns thistype
				//! runtextmacro chargeAllocate("u","CHARGE_SPEED","yaw")
				set .use_collision = true
				set .duration  = CHARGE_DURATION
				set .refresh_facing = false
				set .level = level
				set .flag_collision = true
				set .radius_target = RADIUS2
				set .radius_explosion = 125.
				call .caster.setAnimSpeed(1.0*.caster.attack_speed)
				call .caster.queueAnim("stand")
				call Effect.create(EF_ROCK,u.x,u.y,u.z,0).setPitch(-90).kill()
				call carculateDamage(( .caster.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*.level ))
				return this
			endmethod
	
			method onDestroy takes nothing returns nothing
				call .caster.setAnimSpeed(1.0)
			endmethod
	
		endstruct
	
		public struct actor extends UnitActor
	
			real angle = 0.

			method periodicAction takes nothing returns nothing
			endmethod
	
			method onComplete takes nothing returns nothing
				call mv.create(.caster,.angle,level)
			endmethod
	
			static method create takes Unit u, real x, real y, real delay, integer level returns thistype
				local thistype this = allocate(u,0,x,y,level,delay,true)
				set .angle = Math.anglePoints(.caster.x,.caster.y,.x,.y)
				call .caster.setAnim("attack")
				call .caster.setAnimSpeed(.caster.attack_speed)
				call SetUnitFacing(.caster.origin_unit,.angle)
				set .suspend_ensnare = true
				set .progress_bar = ProgressBar.create(NAME,.caster.owner)
				return this
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
	
			//! runtextmacro abilityTooltip1000()
	
			method execute takes nothing returns nothing
				call actor.create(.owner,.command_x,.command_y,getCarculatedCastDelayByAttackSpeed(),level)
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .is_charge = true
				set .preserve_order = false
				set .cast_delay = 0.25
				set .indicator = ind.create(this,.owner.owner)
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"단거리 돌진,\n충돌 시 범위피해")
			endmethod

			method executeAI takes nothing returns boolean
				if Math.distancePoints(.owner.x,.owner.y,GetUnitX(.command_target),GetUnitY(.command_target)) <= 200. then
					return useRequest(GetUnitX(.command_target),GetUnitY(.command_target),.command_target,false)
				else
					return false
				endif
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability1010 쌍극의 번개
scope Ability1010 initializer init
	
		//! runtextmacro abilityDataHeader1010()

		globals
			private constant real BALL_UP = 0.3
			private constant real BALL_HEIGHT = 85.
			private constant real BALL_DISTANCE = 350.
			private constant real BALL_RADIUS = 55.
			private constant string EFFECT_PATH1 = "Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl"
			private constant string EFFECT_PATH2 = "Abilities\\Weapons\\ChimaeraLightningMissile\\ChimaeraLightningMissile.mdl"
		endglobals

		public struct explosion extends LineExplosion

			method executeExplosion takes Unit_prototype target returns nothing
				call damageTarget(target)
				call Effect.createAttatched(EFFECT_PATH2,target.origin_unit,"origin").kill()
			endmethod

		endstruct
	
		public struct a2 extends UnitActor
			
			Effect effect_1 = 0
			Effect effect_2 = 0
			Square sq = 0
			real angle = 0.

			method onComplete takes nothing returns nothing
				local Lightning lh = Lightning.create("CLSB",.effect_1.x,.effect_1.y,.effect_1.z,.effect_2.x,.effect_2.y,.effect_2.z)
				local LineExplosion lex = explosion.create(.owner,.effect_1.x,.effect_1.y,.effect_2.x,.effect_2.y,BALL_RADIUS)
				call lh.setDuration(0.25)
				set lh.fade = 3.
				set lex.damage = ( .caster.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*.level )
				call lex.setDamageFlagById(ID)
				call lex.activate()
			endmethod

			method periodicAction takes nothing returns nothing
				if .stage == 0 then
					if .caster.isAlly(GetLocalPlayer()) then
						call .sq.setLocalColor(0.,1.,0.,.sq.a)
					else
						call .sq.setLocalColor(1.,0.,0.,.sq.a)
					endif
					set .effect_1.z = .effect_1.z + (BALL_HEIGHT/BALL_UP) * TIMER_TICK
					set .effect_2.z = .effect_1.z
					call .effect_1.setAlpha(R2I((.timeout/BALL_UP)*255))
					call .effect_2.setAlpha(R2I((.timeout/BALL_UP)*255))
					if .timeout >= BALL_UP then
						call .effect_1.setAlpha(255)
						call .effect_2.setAlpha(255)
						set .effect_1.z = BALL_HEIGHT
						set .effect_2.z = .effect_1.z
						call stageNext()
					endif
				endif
			endmethod

			static method create takes Unit caster, real x, real y, real angle, integer level returns thistype
				local thistype this = allocate(caster,0,x,y,level,DELAY,false)
				set .sq = Square.create(Math.pPX(x,-BALL_RADIUS,angle),Math.pPY(y,-BALL_RADIUS,angle),0.,BALL_DISTANCE+BALL_RADIUS*2,angle,BALL_RADIUS,null)
				set .effect_1 = Effect.create(EFFECT_PATH1,x,y,0.,270.)
				set .effect_2 = Effect.create(EFFECT_PATH1,Math.pPX(x,BALL_DISTANCE,angle),Math.pPY(y,BALL_DISTANCE,angle),0.,270.)
				call .effect_1.setAlpha(0)
				call .effect_2.setAlpha(0)
				set .angle = angle
				set .sq.alpha_max = 0.5
				set .sq.refresh_color = false
				set .sq.permanent = true
				call .sq.setColor(0,0.3,1.,0.)
				call .sq.fadeIn(BALL_UP)
				call .sq.setFadeOutPoint(DELAY,0.25)
				// 
				call suspendFree()
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .effect_1.kill()
				call .effect_2.kill()
				call .sq.destroy()
			endmethod
	
		endstruct
	
		public struct actor extends UnitActor
	
			method onComplete takes nothing returns nothing
				call a2.create(.caster,.x,.y,Math.anglePoints(.x,.y,.x2,.y2),level)
			endmethod
	
			static method create takes Unit caster, real x, real y, real x2, real y2, integer level returns thistype
				local thistype this = allocate(caster,0,x,y,level,CAST,true)
				set .x2 = x2
				set .y2 = y2
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

		private struct ind extends LineIndicator

			method beforeRefresh takes nothing returns nothing
				set .yaw = Math.anglePoints(.abil.command_x_temp,.abil.command_y_temp,Mouse.getVX(owner),Mouse.getVY(owner))
				set .x = Math.pPX(.abil.command_x_temp,-BALL_RADIUS,.yaw)
				set .y = Math.pPY(.abil.command_y_temp,-BALL_RADIUS,.yaw)
				set .range = BALL_DISTANCE+BALL_RADIUS*2
				set .width = BALL_RADIUS
			endmethod

			static method create takes Ability_prototype abil, player owner returns thistype
				local thistype this = allocate(abil,owner)
				call .ef.setColor(0,R2I(0.3*255),255)
				call .circle.setColor(0,R2I(0.3*255),255)
				return this
			endmethod

		endstruct
	
		public struct main extends Ability
	
			//! runtextmacro abilityTooltip1010()

			method execute takes nothing returns nothing
				call actor.create(.owner,.command_x,.command_y,.command_x2,.command_y2,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .cast_range = RANGE
				set .preserve_order = false
				set .indicator = ind.create(this,.owner.owner)
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"직선영역 범위피해\n ")
			endmethod

		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability1020 구식 저격총
scope Ability1020 initializer init
	
		//! runtextmacro abilityDataHeader1020()

		globals
			private constant string EFFECT_PATH1 = "Abilities\\Weapons\\Mortar\\MortarMissile.mdl"
			private constant string EFFECT_PATH2 = "Effects\\Aim.mdl"
		endglobals
	
		public struct actor extends UnitActor
	
			boolean play = false
			Effect aim = 0
			Lightning lh = 0

			method suspendFilterAdditional takes nothing returns boolean
				return .target.isUnitType(UNIT_TYPE_DEAD)
			endmethod

			method onComplete takes nothing returns nothing
				local real nx = Math.pPX(.caster.x,STARTAT,.caster.yaw)
				local real ny = Math.pPY(.caster.y,STARTAT,.caster.yaw)
				local Missile ms = Missile.create(.caster,EFFECT_PATH1,nx,ny,.caster.z+.caster.pivot_z,.caster.yaw)
				set ms.damage = (.owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1) * (1+DAMAGE_PER_LEVEL*.level * .owner.attack_speed)
				call ms.setDamageFlagById(ID)
				set ms.radius_target = VELO*TIMER_TICK*0.5
				set ms.velo = VELO
				call ms.setTarget(.target)
				call UnitActor.create(.caster,0,0.,0.,0,BACKSWING,true)
			endmethod

			method periodicAction takes nothing returns nothing
				call SetUnitFacing(.caster.origin_unit,Math.anglePoints(.caster.x,.caster.y,.target.x,.target.y))
				if .duration_max - .timeout < 0.25 and not .play then
					call .caster.setAnim("attack")
					call .caster.setAnimSpeed(2.)
					set .play = true
				endif
			endmethod
	
			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target,0.,0.,level,DELAY,true)
				set .progress_bar = ProgressBar.create("저격",.caster.owner)
				set .suspend_rclick = true
				set .suspend_stop = true
				set .suspend_ability = true
				set .suspend_target_decay = true
				set .lh = Lightning.createOO("LSER",.caster,.target)
				set .lh.oz1 = .caster.pivot_z
				set .lh.oz2 = .target.pivot_z
				call .lh.refreshPosition()
				call .lh.setColor(1.,0.,0.)
				set .aim = Effect.createAttatched(EFFECT_PATH2,.target.origin_unit,"overhead")
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				//call .caster.queueAnim("stand ready")
				call .caster.setAnimSpeed(1.)
				call aim.destroy()
				call lh.destroy()
			endmethod

		endstruct
	
		public struct main extends Ability

			method getAttackSpeedValue takes real v returns real 
				return 1.
			endmethod

			//! runtextmacro abilityTooltip1020()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,.level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .cast_delay = DELAY
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"정신 집중 후\n단일 대상 공격")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability1030 화염구
scope Ability1030 initializer init
	
		//! runtextmacro abilityDataHeader1030()
		
		globals
			private constant string EFFECT_PATH1 = "Abilities\\Weapons\\RedDragonBreath\\RedDragonMissile.mdl"
			private constant string EFFECT_PATH2 = "Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl"
		endglobals
	
		private struct ball extends Missile

			Circle l = 0

			method periodicAction takes nothing returns nothing
				call .l.setPosition(.x,.y,5.)
			endmethod

			method executeTarget takes Unit target returns nothing
				call DoNothing()
			endmethod

			method afterExplosion takes nothing returns nothing
				local Circle c = Circle.create(.x,.y,5.,RADIUS3)
				call c.setColor(255,153,0)
				set c.alpha = 0.66
				call c.setFadeOutPoint(0.25,0.75)
				call Effect.create(EFFECT_PATH2,.x,.y,0.,0.).setDuration(1.5)
				call .l.destroy()
				set .l = 0
			endmethod

			static method create takes Unit owner, real x, real y, real z, real yaw, integer level returns thistype
				local thistype this = allocate(owner,EFFECT_PATH1,x,y,z,yaw)
				set .velo = VELO
				set .damage = ( .owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*(level) )
				call setDamageFlagById(ID)
				call setCollision(RADIUS2)
				call setExplosion(RADIUS3)
				call setDuration((RANGE-STARTAT)/VELO)
				set .l = Circle.create(x,y,5.,RADIUS2)
				call .l.setColor(255,153,0)
				set .l.alpha = 0.5
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				if .l != 0 then
					call .l.setFadeOutPoint(0.,1.5)
					set .l = 0
				endif
			endmethod

		endstruct

		public struct actor extends UnitActor
	
			real angle = 0.

			method onComplete takes nothing returns nothing
				local ball ms = ball.create(.caster,/*
				*/Math.pPX(.caster.x,STARTAT,Math.anglePoints(.caster.x,.caster.y,.x,.y)),/*
				*/Math.pPY(.caster.y,STARTAT,Math.anglePoints(.caster.x,.caster.y,.x,.y)),.caster.pivot_z,/*
				*/.angle,.level)
				call UnitActor.create(.caster,0,0.,0.,0,BACKSWING,true)
			endmethod
	
			static method create takes Unit u, real x, real y, real delay, integer level returns thistype
				local thistype this = allocate(u,0,x,y,level,delay,true)
				set .angle = Math.anglePoints(.caster.x,.caster.y,.x,.y)
				call .caster.setAnim("attack")
				call .caster.setAnimSpeed(1.66)
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
				call .ef.setColor(255,R2I(0.65*255),0)
				call .circle.setColor(255,R2I(0.65*255),0)
				return this
			endmethod

		endstruct

		public struct main extends Ability

			//! runtextmacro abilityTooltip1030()
	
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
				call Ability.setTypeTooltip(ID,"범위피해 투사체 발사\n ")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability1040 연쇄번개
scope Ability1040 initializer init
	
		//! runtextmacro abilityDataHeader1040()
		
		globals
			private constant string EFFECT_PATH1 = "Abilities\\Weapons\\FarseerMissile\\FarseerMissile.mdl"
		endglobals

		private struct chain extends ChainLightning

			method executeChain takes Unit target returns nothing
				call damageTarget(target)
				set .damage = ( .owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*.level )
				call Effect.createAttatched(EFFECT_PATH1,target.origin_unit,"chest").kill()
			endmethod

			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target,level,TARGET_MAX,INTERVAL,"CLPB")
				set .damage = ( .owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*.level ) + /*
				*/( .owner.getCarculatedStatValue(DAMAGE_STAT2) * DAMAGE_AMPLIFIER2 ) * ( 1+DAMAGE_PER_LEVEL*.level )
				call setDamageFlagById(ID)
				set .weapon_type = WEAPON_TYPE_METAL_LIGHT_CHOP
				set .radius_explosion = RANGE_SECONDARY
				return this
			endmethod

		endstruct

		public struct actor extends UnitActor
	
			method onComplete takes nothing returns nothing
				call chain.create(.caster,.target,.level)
			endmethod

			static method create takes Unit u, Unit target, real delay, integer level returns thistype
				local thistype this = allocate(u,target,0.,0.,level,delay+BACKSWING,true)
				call .caster.setAnim("attack")
				call .caster.setAnimSpeed(1.66)
				call SetUnitFacing(.caster.origin_unit,Math.anglePoints(.caster.x,.caster.y,.target.x,.target.y))
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .caster.queueAnim("stand ready")
				call .caster.setAnimSpeed(1.)
			endmethod
	
		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip1040()
	
			method execute takes nothing returns nothing
				call actor.create(.owner,Unit_prototype.get(.command_target),.cast_delay,level)
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .is_target = true
				set .cast_range = RANGE
				set .preserve_order = false
				set .cast_delay = INTERVAL
				set .indicator = AbilityIndicator.create(this,.owner.owner)
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"다수의 적 연쇄공격\n ")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability1050 신성의 빛
scope Ability1050 initializer init

		//! runtextmacro abilityDataHeader1050()

		globals
			private constant string EFFECT_PATH1 = "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl"
		endglobals

		public struct actor extends UnitActor
	
			method onComplete takes nothing returns nothing
				call .caster.healUnit(/*
				*/.target,/*
				*/(( .owner.getCarculatedStatValue(DAMAGE_STAT2) * DATA_REAL2 ) * ( 1+DAMAGE_PER_LEVEL*.level )) + /*
				*/(( .owner.getCarculatedStatValue(DAMAGE_STAT1) * DATA_REAL1 ) * ( 1+DAMAGE_PER_LEVEL*.level )) + DATA_REAL3 * .owner.level/*
				*/)
				call Effect.createAttatched(EFFECT_PATH1,.target.origin_unit,"origin").setDuration(1.5)
				call Backswing.create(.caster)
			endmethod

			static method create takes Unit u, Unit target, real delay, integer level returns thistype
				local thistype this = allocate(u,target,0.,0.,level,delay,true)
				call .caster.setAnim("attack")
				call .caster.setAnim("spell")
				if .caster != .target then
					call SetUnitFacing(.caster.origin_unit,Math.anglePoints(.caster.x,.caster.y,.target.x,.target.y))
				endif
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .caster.queueAnim("stand ready")
				call .caster.setAnimSpeed(1.)
			endmethod
	
		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip1050()

			// method targetFilterAdditional takes Unit_prototype target returns boolean
			// 	if target.hp < target.maxhp then
			// 		return true
			// 	else
			// 		set CUSTOM_RESPOND_ERROR_MESSAGE = "대상의 체력이 가득 찼습니다."
			// 		return false
			// 	endif
			// endmethod

			method execute takes nothing returns nothing
				call actor.create(.owner,Unit_prototype.get(.command_target),.cast_delay,level)
			endmethod

			method iconClick takes nothing returns nothing
				call useRequest(0.,0.,.owner.origin_unit,true)
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .target_useable_enemy = false
				set .target_useable_ally = true
				set .target_useable_self = true
				set .is_active = true
				set .is_target = true
				set .cast_range = RANGE
				set .preserve_order = false
				set .cast_delay = DELAY
				set .indicator = AbilityIndicator.create(this,.owner.owner)
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"단일대상 회복\n ")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability1060 점멸
scope Ability1060 initializer init

		//! runtextmacro abilityDataHeader1060()

		globals
			private constant string EFFECT_PATH1 = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
			private constant string EFFECT_PATH2 = "Abilities\\Spells\\NightElf\\Blink\\BlinkTarget.mdl"
		endglobals

		public struct main extends Ability
	
			method getMaxCooldown takes nothing returns real
				return getMaxCooldownBySpellBoost() / (1+.level*DAMAGE_PER_LEVEL)
			endmethod

			//! runtextmacro abilityTooltip1060()

			method beforePress takes nothing returns nothing
				set .cast_range = RANGE
			endmethod

			method beforeRelease takes nothing returns nothing
				set .cast_range = -1.
			endmethod
	
			method execute takes nothing returns nothing
				local real d = Math.distancePoints(.owner.x,.owner.y,.command_x,.command_y)
				local real a = Math.anglePoints(.owner.x,.owner.y,.command_x,.command_y)
				call Effect.create(EFFECT_PATH1,.owner.x,.owner.y,5.,270.).setDuration(1.5)
				if d > RANGE then
					set .command_x = Math.pPX(.owner.x,RANGE,a)
					set .command_y = Math.pPY(.owner.y,RANGE,a)
				endif
				call LocationEx.collisionProjection(.command_x,.command_y)
				set .command_x = LocationEx.getX()
				set .command_y = LocationEx.getY()
				/*탈 것 탑숭 중이면 내리기*/
				if Riding.getByCaster(.owner) > 0 then
					call Riding.getByCaster(.owner).destroy()
				endif
				set .owner.x = .command_x
				set .owner.y = .command_y
				call Effect.create(EFFECT_PATH2,.command_x,.command_y,5.,270.).setDuration(1.5)
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .is_charge = true
				set .useable_cast = true
				set .preserve_order = true
				set .indicator = AbilityIndicator.create(this,.owner.owner)
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"순간이동\n ")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability1070 순보
scope Ability1070 initializer init

		//! runtextmacro abilityDataHeader1070()

		globals
			private constant string EFFECT_PATH1 = "Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl"
			private constant string EFFECT_PATH2 = "Effects\\WindSlash.mdl"
			private constant string EFFECT_PATH3 = "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl"
		endglobals

		private struct exp extends LineExplosion

			boolean b = false

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

			//! runtextmacro abilityTooltip1070()

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

//!Ability1080 다중사격
scope Ability1080 initializer init

		//! runtextmacro abilityDataHeader1080()

		globals
			private constant string EFFECT_PATH1 = "Abilities\\Weapons\\GuardTowerMissile\\GuardTowerMissile.mdl"
		endglobals
	
		private struct arrow extends Missile

			method executeTarget takes Unit target returns nothing
				if IsUnitInGroup(target.origin_unit,.group_already) then
					/*약한데미지*/
					set .damage = .damage * DAMAGE_SECONDARY
					set .onhit_type = Damage.ONHIT_TYPE_NONHIT
				else
					/*데미지 그대로&이미맞은그룹에 추가*/
					//call GroupAddUnit(.group_already,target.origin_unit)
				endif
				call damageTarget(target)
			endmethod

			static method create takes Unit owner, real x, real y, real z, real yaw, integer level returns thistype
				local thistype this = allocate(owner,EFFECT_PATH1,x,y,z,yaw)
				set .velo = VELO
				set .damage = ( .owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*(level) )
				call setDamageFlagById(ID)
				set .weapon_type = WEAPON_TYPE_METAL_MEDIUM_BASH
				call setCollision(RADIUS2)
				call setDuration((RANGE-STARTAT)/VELO)
				return this
			endmethod

		endstruct

		public struct actor extends UnitActor
	
			real angle = 0.

			method onComplete takes nothing returns nothing
				local integer i = 0
				local arrow ms = 0
				local real a = 0.
				local MissileGroup mg = MissileGroup.create()
				loop
					exitwhen i >= COUNT
					set a = .angle - (WIDTH/2) + (WIDTH*i)/(COUNT-1)
					set ms = arrow.create(.caster,/*
					*/Math.pPX(.caster.x,STARTAT,a),/*
					*/Math.pPY(.caster.y,STARTAT,a),.caster.pivot_z,/*
					*/a,.level)
					call mg.add(ms)
					set i = i + 1
				endloop
				call UnitActor.create(.caster,0,0.,0.,0,BACKSWING,true)
			endmethod
	
			static method create takes Unit u, real x, real y, real delay, integer level returns thistype
				local thistype this = allocate(u,0,x,y,level,delay,true)
				set .angle = Math.anglePoints(.caster.x,.caster.y,.x,.y)
				call .caster.setAnim("attack")
				call .caster.setAnimSpeed(1.66)
				call SetUnitFacing(.caster.origin_unit,Math.anglePoints(.caster.x,.caster.y,x,y))
				set .progress_bar = ProgressBar.create(NAME,.caster.owner)
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .caster.queueAnim("stand ready")
				call .caster.setAnimSpeed(1.)
			endmethod
	
		endstruct
	
		private struct ind extends SectorIndicator

			method beforeRefresh takes nothing returns nothing
				set .x = .abil.owner.x
				set .y = .abil.owner.y
				set .yaw = Math.anglePoints(.x,.y,Mouse.getVX(owner),Mouse.getVY(owner))
				set .range = RANGE+RADIUS2
			endmethod

			static method create takes Ability_prototype abil, player owner returns thistype
				local thistype this = allocate(abil,owner,"30")
				/*call .ef.setColor(255,R2I(0.65*255),0)
				call .circle.setColor(255,R2I(0.65*255),0)*/
				return this
			endmethod

		endstruct

		public struct main extends Ability

			//! runtextmacro abilityTooltip1080()
	
			method execute takes nothing returns nothing
				call actor.create(.owner,.command_x,.command_y,.cast_delay,level)
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .preserve_order = false
				set .cast_delay = DELAY
				set .indicator = ind.create(this,.owner.owner)
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"다수의 투사체 발사\n")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability1090 강철망치
scope Ability1090 initializer init

		//! runtextmacro abilityDataHeader1090()
	
		public struct actor extends MeleeAttack

			method onComplete takes nothing returns nothing
				call Effect.createAttatched(EF_ROCK,.target.origin_unit,"chest").kill()
				set .damage = ((.owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1)+(.owner.getCarculatedStatValue(DAMAGE_STAT2) * DAMAGE_AMPLIFIER2) ) * (1+DAMAGE_PER_LEVEL*.level)
				call damageTarget(.target)
				call Backswing.create(.caster)
			endmethod
	
			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target)
				set .level = level
				call setDamageFlagById(ID)
				set .weapon_type = WEAPON_TYPE_METAL_HEAVY_BASH
				call .caster.setAnimSpeed(1.)
				return this
			endmethod

		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip1090()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"느리고 강한 공격")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability10a0 조잡한 검
scope Ability10a0 initializer init

		//! runtextmacro abilityDataHeader10a0()
	
		globals
			private constant string EFFECT_PATH1 = "Effects\\WindSlash.mdl"
			private constant string EFFECT_PATH2 = "Abilities\\Weapons\\Rifle\\RifleImpact.mdl"
		endglobals

		public struct actor extends MeleeAttack

			method onComplete takes nothing returns nothing
				call Effect.create(EFFECT_PATH1,.target.x,.target.y,.target.z+.target.pivot_z,270.).setScale(1.15).setRoll(GetRandomReal(0.,360.)).kill()
				call Effect.create(EFFECT_PATH2,.target.x,.target.y,.target.z+.target.pivot_z,270.).setScale(1.75).kill()
				set .damage = (.owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1) * (1+DAMAGE_PER_LEVEL*.level)
				call damageTarget(.target)
				call Backswing.create(.caster)
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

			//! runtextmacro abilityTooltip10a0()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"평범한 검격")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability10b0 짓밟기
scope Ability10b0 initializer init

		//! runtextmacro abilityDataHeader10b0()

		globals
			private constant string EFFECT_PATH1 = "Abilities\\Weapons\\WingedSerpentMissile\\WingedSerpentMissile.mdl"
			private constant string EFFECT_PATH2 = "Abilities\\Weapons\\Rifle\\RifleImpact.mdl"
		endglobals
	
		public struct actor extends MeleeAttack

			method onComplete takes nothing returns nothing
				call Effect.create(EFFECT_PATH1,.target.x,.target.y,.target.z+.target.pivot_z,270.).setScale(1.75).setAnimSpeed(2.5).kill()
				call Effect.create(EFFECT_PATH2,.target.x,.target.y,.target.z+.target.pivot_z,270.).setScale(1.75).kill()
				set .damage = ((.owner.getCarculatedStatValue(DAMAGE_STAT2) * DAMAGE_AMPLIFIER2) + (.owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1)) * (1+DAMAGE_PER_LEVEL*.level)
				call damageTarget(.target)
				call Backswing.create(.caster)
			endmethod
	
			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target)
				set .level = level
				call setDamageFlagById(ID)
				set .weapon_type = WEAPON_TYPE_METAL_HEAVY_BASH
				return this
			endmethod

		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip10b0()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"짓밟기 공격")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability10c0 뾰족한 가시
scope Ability10c0 initializer init

		//! runtextmacro abilityDataHeader10c0()

		globals
			private constant string EFFECT_PATH1 = "Abilities\\Weapons\\QuillSprayMissile\\QuillSprayMissile.mdl"
		endglobals
	
		public struct actor extends MeleeAttack

			method onComplete takes nothing returns nothing
				local real a = Math.anglePoints(.caster.x,.caster.y,.target.x,.target.y)
				local real nx = Math.pPX(.caster.x,STARTAT,a)
				local real ny = Math.pPY(.caster.y,STARTAT,a)
				local Missile ms = 0
				set ms = Missile.create(.caster,EFFECT_PATH1,nx,ny,.caster.z+.caster.pivot_z,a)
				call ms.setDamageFlagById(ID)
				set ms.damage = (.caster.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1) * (1+DAMAGE_PER_LEVEL*.level)
				set ms.radius_target = VELO*TIMER_TICK*0.5
				set ms.velo = VELO
				set ms.weapon_type = WEAPON_TYPE_WOOD_LIGHT_BASH
				call ms.setTarget(.target)
				call Backswing.create(.caster)
			endmethod
	
			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target)
				set .level = level
				return this
			endmethod

		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip10c0()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .count = 0
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"가시 발사")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Buff10d0 사기의 외침(버프)
scope Buff10d0 initializer init

	////! runtextmacro buffHeader("사기의 외침","10d0","2","BTNAbility_Shout1")
	//! runtextmacro buffDataHeader10d0()

	globals
		public constant string EFFECT_PATH1 = "Effects\\SpiritLinkTarget1.mdl"
	endglobals

	public struct main extends Buff

		real v1 = 0.
		real v2 = 0.

		method relativeTooltip takes nothing returns string
			return "공격력과 체력재생이 증가했습니다."
		endmethod
		
		method init takes nothing returns boolean
			local real v1 = (.caster.hpregen *  DAMAGE_AMPLIFIER1 ) * (1 + DAMAGE_PER_LEVEL * .level )
			local real v2 = DATA_REAL1 + DATA_REAL2 * .level
			call .target.plusStatValue(CONFIG_STAT_HPREGEN,v1)
			set .v1 = .v1 + v1
			call .target.multiplyStatValue(CONFIG_STAT_ATTACK,v2)
			set .v2 = .v2 + v2
			call addEffect(Effect.createAttatched(EFFECT_PATH1,.target.origin_unit,"chest"))
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call .target.plusStatValue(CONFIG_STAT_HPREGEN,-.v1)
			call .target.multiplyStatValue(CONFIG_STAT_ATTACK,-.v2)
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

//!Ability10d0 사기의 외침
scope Ability10d0 initializer init

		//! runtextmacro abilityDataHeader10d0()

		globals
			private constant string EFFECT_PATH1 = "Effects\\RoarCaster1.mdl"
		endglobals

		private struct exp extends Explosion

			integer level = 0

			method beforeExplosion takes nothing returns nothing
				
			endmethod

			method executeExplosion takes Unit target returns nothing
				local Buff b = Buff.add(.owner,target,ID,.level,DURATION)
				if UnitClass(target).isClass(CONFIG_UNIT_CLASS_SUMMON) then
					call Summon(target).addDuration(DATA_REAL1)
				endif
			endmethod

			static method create takes Unit caster, real x, real y, integer level returns thistype
				local thistype this = allocate(caster,x,y,RADIUS1)
				set .level = level
				set .affect_enemy = false
				set .affect_ally = true
				set .affect_invincible = true
				set .affect_evasion = true
				return this
			endmethod

		endstruct
		
		public struct actor extends UnitActor

			method onComplete takes nothing returns nothing
				call Backswing.create(.owner)
			endmethod

			static method create takes Unit caster, integer level returns thistype
				local thistype this = allocate(caster,0,0.,0.,level,DELAY,true)
				call .caster.setAnim("attack")
				call .caster.setAnimSpeed(1.)
				set .progress_bar = ProgressBar.create(NAME,.caster.owner)
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .caster.queueAnim("stand")
				call .caster.setAnimSpeed(1.0)
			endmethod

		endstruct

		public struct main extends Ability

			//! runtextmacro abilityTooltip10d0()

			method execute takes nothing returns nothing
				local Explosion ex = exp.create(.owner,.owner.x,.owner.y,.level)
				local Circle c = Circle.create(.owner.x,.owner.y,5.,RADIUS1)
				call actor.create(.owner,.level)
				set ex.count = 1
				set ex.activate_initial = false
				set ex.interval = DELAY
				call ex.activate()
				call c.setColor(10, 184, 10)
				call c.fadeIn(DELAY)
				call c.setFadeOutPoint(DELAY,0.5)
				set c.alpha_max = 0.8
				call Effect.create(EFFECT_PATH1,.owner.x,.owner.y,0.,270.).kill()
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .preserve_order = true
				set .is_immediate = true
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"주변 아군 격려\n ")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability10e0 박치기
scope Ability10e0 initializer init

		//! runtextmacro abilityDataHeader10e0()

		globals
			private constant string EFFECT_PATH2 = "Abilities\\Weapons\\Rifle\\RifleImpact.mdl"
		endglobals
	
		public struct actor extends MeleeAttack

			method onComplete takes nothing returns nothing
				call Effect.create(EF_ROCK,.target.x,.target.y,.target.z+.target.pivot_z,270.).setScale(0.5).kill()
				call Effect.create(EFFECT_PATH2,.target.x,.target.y,.target.z+.target.pivot_z,270.).setScale(1.75).kill()
				set .damage = ((.owner.getCarculatedStatValue(DAMAGE_STAT2) * DAMAGE_AMPLIFIER2) + (.owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1)) * (1+DAMAGE_PER_LEVEL*.level)
				call damageTarget(.target)
				call Backswing.create(.caster)
			endmethod
	
			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target)
				set .level = level
				call setDamageFlagById(ID)
				set .weapon_type = WEAPON_TYPE_METAL_MEDIUM_BASH
				return this
			endmethod

		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip10e0()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"박치기 공격")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability10f0 역류의 칼날
scope Ability10f0 initializer init

		//! runtextmacro abilityDataHeader10f0()

		globals
			private constant string EFFECT_PATH1 = "Effects\\WindSlash.mdl"
			private constant string EFFECT_PATH2 = "Abilities\\Spells\\Undead\\OrbOfDeath\\OrbOfDeathMissile.mdl"
		endglobals
	
		public struct actor extends MeleeAttack

			method onComplete takes nothing returns nothing
				call Effect.create(EFFECT_PATH1,.target.x,.target.y,.target.z+.target.pivot_z,270.).setScale(1.25).setRoll(GetRandomReal(-55,55)).setColor(255, 232, 27).kill()
				call Effect.create(EFFECT_PATH2,.target.x,.target.y,.target.z+.target.pivot_z,270.).kill()
				set .damage = ((.owner.getCarculatedStatValue(DAMAGE_STAT2) * DAMAGE_AMPLIFIER2) + (.owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1)) * (1+DAMAGE_PER_LEVEL*.level)
				call damageTarget(.target)
				if UnitClass(.target).isClass(CONFIG_UNIT_CLASS_SUMMON) then
					/*소환물일 때*/
					call Summon(.target).manaBurn(caster,DATA_REAL3)
				else
					set .target.mp = .target.mp - ( DATA_REAL1 + DATA_REAL2 * .caster.level )
				endif
				call Backswing.create(.caster)
			endmethod
	
			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target)
				set .level = level
				call setDamageFlagById(ID)
				set .weapon_type = WEAPON_TYPE_METAL_MEDIUM_SLICE
				return this
			endmethod

		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip10f0()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"마나 연소 공격")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Buff10g0 그물 던지기(버프)
scope Buff10g0 initializer init

	//! runtextmacro buffDataHeader10g0()

	globals
		private constant string EFFECT_PATH1 = "Abilities\\Spells\\Orc\\Ensnare\\ensnareTarget.mdl"
	endglobals

	public struct main extends Buff

		real v1 = 0.
		real v2 = 0.

		method relativeTooltip takes nothing returns string
			return "회피치와 이동속도가 감소했으며 이동기를 사용할 수 없습니다."
		endmethod

		method update takes nothing returns boolean
			call .target.minusStatValue(CONFIG_STAT_EVASION,-.v2)
			set .v2 = .caster.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 * (1+DAMAGE_PER_LEVEL*.level)
			call .target.minusStatValue(CONFIG_STAT_EVASION,.v2)
			return true
		endmethod

		method init takes nothing returns boolean
			call addEffect(Effect.createAttatched(EFFECT_PATH1,.target.origin_unit,"origin"))
			set .v1 = Math.reduceDivisor(DATA_REAL1)
			set .v2 = .caster.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 * (1+DAMAGE_PER_LEVEL*.level)
			call .target.divideStatValue(CONFIG_STAT_MOVEMENT_SPEED,.v1)
			call .target.minusStatValue(CONFIG_STAT_EVASION,.v2)
			call .target.plusStatus(CONFIG_STATUS_ROOT)
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call .target.divideStatValue(CONFIG_STAT_MOVEMENT_SPEED,-.v1)
			call .target.minusStatValue(CONFIG_STAT_EVASION,-.v2)
			call .target.minusStatus(CONFIG_STATUS_ROOT)
		endmethod

	endstruct

	//! runtextmacro buffEnd()

endscope

//!Ability10g0 그물 던지기
scope Ability10g0 initializer init

		//! runtextmacro abilityDataHeader10g0()

		globals
			private constant string EFFECT_PATH1 = "Abilities\\Spells\\Orc\\Ensnare\\EnsnareMissile.mdl"
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
				set .weapon_type = WEAPON_TYPE_METAL_LIGHT_CHOP
				call setCollision(RADIUS2)
				call setDuration((RANGE-STARTAT)/VELO)
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
				call .ef.setColor(199, 221, 255)
				call .circle.setColor(199, 221, 255)
				return this
			endmethod

		endstruct

		public struct main extends Ability
	
			//! runtextmacro abilityTooltip10g0()

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
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability10h0 도끼 투척
scope Ability10h0 initializer init

		//! runtextmacro abilityDataHeader10h0()

		globals
			private constant string EFFECT_PATH1 = "Abilities\\Weapons\\Axe\\AxeMissile.mdl"
		endglobals

		private struct axe extends Missile

			method periodicAction takes nothing returns nothing
				set .pitch = .pitch + 360*3*TIMER_TICK
			endmethod

			static method create takes Unit caster, Unit target, integer level returns thistype
				local real a = Math.anglePoints(caster.x,caster.y,target.x,target.y)
				local real nx = Math.pPX(caster.x,STARTAT,a)
				local real ny = Math.pPY(caster.y,STARTAT,a)
				local thistype this = allocate(caster,EFFECT_PATH1,nx,ny,caster.z+caster.pivot_z,a)
				call setDamageFlagById(ID)
				set .damage = (.owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1) * (1+DAMAGE_PER_LEVEL*(level))
				set .radius_target = VELO*TIMER_TICK*0.5
				set .velo = VELO
				set .weapon_type = WEAPON_TYPE_METAL_MEDIUM_BASH
				call setTarget(target)
				return this
			endmethod

		endstruct
	
		private struct secondattack extends UnitActor

			method onComplete takes nothing returns nothing
				call axe.create(.caster,.target,.level)
			endmethod

			method periodicAction takes nothing returns nothing
				call .caster.setAnimSpeed(1.0*.caster.attack_speed)
			endmethod

			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target,0.,0.,level,0.5/caster.attack_speed,true)
				set .suspend_rclick = true
				set .suspend_stop = true
				call .caster.setAnimSpeed(1.0*.caster.attack_speed)
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .caster.setAnimSpeed(1.0)
			endmethod

		endstruct

		public struct actor extends MeleeAttack

			method onComplete takes nothing returns nothing
				call axe.create(.caster,.target,.level)
				call secondattack.create(.caster,.target,.level)
			endmethod
	
			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target)
				set .level = level
				return this
			endmethod

		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip10h0()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"도끼 던지기")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability10i0 가우스 라이플
scope Ability10i0 initializer init

		//! runtextmacro abilityDataHeader10i0()

		globals
			private constant string EFFECT_PATH1 = "Effects\\bullet.mdl"
		endglobals

		private struct bullet extends Missile

			static method create takes Unit caster, real a, integer level, integer onhit returns thistype
				local real nx = Math.pPX(caster.x,STARTAT,a)
				local real ny = Math.pPY(caster.y,STARTAT,a)
				local thistype this = allocate(caster,EFFECT_PATH1,nx,ny,caster.z+caster.pivot_z,a)
				call setDamageFlagById(ID)
				set .onhit_type = onhit/*첫 타만 온힛판정 판별을 위해 사용*/
				set .damage = (.owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1) * (1+DAMAGE_PER_LEVEL*(level))
				set .velo = VELO
				set .weapon_type = WEAPON_TYPE_METAL_LIGHT_CHOP
				call setDuration((RANGE_SECONDARY+caster.attack_range-STARTAT)/VELO)
				call setScale(1.5)
				call setCollision(RADIUS2)
				return this
			endmethod

		endstruct
	
		private struct secondattack extends UnitActor

			integer count = 0
			real angle = 0.

			method killFilter takes nothing returns boolean
				set .count = .count - 1
				if .count <= 0 then
					return true
				else
					set .duration = 0.12/caster.attack_speed
					return false
				endif
			endmethod

			method onComplete takes nothing returns nothing
				call bullet.create(.caster,.angle,.level,Damage.ONHIT_TYPE_NONHIT)
			endmethod

			method periodicAction takes nothing returns nothing
				call .caster.setAnimSpeed(1.0*.caster.attack_speed)
			endmethod

			static method create takes Unit caster, real angle, integer level returns thistype
				local thistype this = allocate(caster,0,0.,0.,level,0.12/caster.attack_speed,true)
				set .angle = angle
				set .count = 2
				set .suspend_rclick = true
				set .suspend_stop = true
				call .caster.setAnimSpeed(1.0*.caster.attack_speed)
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .caster.setAnimSpeed(1.0)
			endmethod

		endstruct

		public struct actor extends MeleeAttack

			real angle = 0.

			method onComplete takes nothing returns nothing
				call bullet.create(.caster,.angle,.level,Damage.ONHIT_TYPE_ONHIT)
				call secondattack.create(.caster,.angle,.level)
			endmethod
	
			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target)
				set .duration = 0.2/caster.attack_speed
				set .level = level
				set .angle = Math.anglePoints(caster.x,caster.y,target.x,target.y)
				set .caster.yaw = .angle
				return this
			endmethod

		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip10i0()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .count = 0
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"기관총 사격")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability10j0 청록의 파동
scope Ability10j0 initializer init

		//! runtextmacro abilityDataHeader10j0()

		globals
			private constant string EFFECT_PATH1 = "Objects\\Spawnmodels\\NightElf\\NEDeathMedium\\NEDeath.mdl"
		endglobals

		private struct exp extends Explosion

			method beforeExplosion takes nothing returns nothing
				local Circle c = Circle.create(.x,.y,2,RADIUS1)
				call c.setColor(128, 233, 215)
				call c.setFadeOutPoint(0.125,0.5)
				call Effect.create(EFFECT_PATH1,.x,.y,0.,0.).setAnimSpeed(1.5).setDuration(2.)
			endmethod

			static method create takes Unit caster, real x, real y, integer level returns thistype
				local thistype this = allocate(caster,x,y,RADIUS1)
				call setDamageFlagById(ID)
				return this
			endmethod

		endstruct

		public struct main extends Ability

			//! runtextmacro abilityTooltip10j0()

			method execute takes nothing returns nothing
				local Explosion ex = 0
				set .owner.hp = .owner.hp * (1.-DATA_REAL1)
				if Riding.getByCaster(.owner) > 0 then
					set ex = exp.create(.owner,Riding.getByCaster(.owner).target.x,Riding.getByCaster(.owner).target.y,.level)
				else
					set ex = exp.create(.owner,.owner.x,.owner.y,.level)
				endif
				set ex.damage = (.owner.getCarculatedStatValue(DAMAGE_STAT1)*DAMAGE_AMPLIFIER1+.owner.getCarculatedStatValue(DAMAGE_STAT2)*DAMAGE_AMPLIFIER2)*(1+DAMAGE_PER_LEVEL*.level)
				set ex.count = 1
				call ex.setDamageFlagById(ID)
				call ex.activate()
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .preserve_order = true
				set .is_immediate = true
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"주변 적 광역피해\n ")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability10k0 사냥꾼의 장궁
scope Ability10k0 initializer init

		//! runtextmacro abilityDataHeader10k0()
	
		globals
			private constant string EFFECT_PATH1 = "Abilities\\Weapons\\Arrow\\ArrowMissile.mdl"
		endglobals

		public struct actor extends MeleeAttack

			method onComplete takes nothing returns nothing
				local real a = Math.anglePoints(.caster.x,.caster.y,.target.x,.target.y)
				local real nx = Math.pPX(.caster.x,STARTAT,a)
				local real ny = Math.pPY(.caster.y,STARTAT,a)
				local Missile ms = 0
				set ms = Missile.create(.caster,EFFECT_PATH1,nx,ny,.caster.z+.caster.pivot_z,a)
				call ms.setDamageFlagById(ID)
				set ms.damage = (.caster.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1) * (1+DAMAGE_PER_LEVEL*.level)
				set ms.radius_target = VELO*TIMER_TICK*0.5
				set ms.velo = VELO
				set ms.weapon_type = WEAPON_TYPE_WOOD_LIGHT_BASH
				call ms.setTarget(.target)
				call Backswing.create(.caster)
			endmethod
	
			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target)
				set .level = level
				return this
			endmethod

		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip10k0()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"화살 발사")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability10l0 전기충격기 건설
scope Ability10l0 initializer init

		//! runtextmacro abilityDataHeader10l0()

		globals
			private constant string EFFECT_PATH1 = "buildings\\human\\HumanTower\\HumanTower.mdl"
			private constant string EFFECT_PATH2 = "Abilities\\Weapons\\VengeanceMissile\\VengeanceMissile.mdl"
		endglobals

		private struct mytower extends Summon

			private Trigger ba_trigger = 0

			Block block = 0

			method summonDeath takes nothing returns nothing
				/*블록은 일단 죽는 시점에 지워야함*/
				if .block > 0 and not .is_revive then
					call .block.destroy()
					set .block = 0
				endif
				call Effect.create(EFFECT_PATH2,.x,.y,0.,270.).setScale(2.5).kill()
			endmethod

			static method damageCallback takes nothing returns nothing
				local thistype this = 0
				/*기본공격 아니면 컷*/
				if CUSTOM_RESPOND_DAMAGE_ATTACK_TYPE != CONFIG_DAMAGE_BASIC then
					return
				endif
				/*타입캐스트*/
				set this = Trigger.getData(GetTriggeringTrigger())
				/*공격자가 내가 아니면 컷*/
				if CUSTOM_RESPOND_DAMAGE_ATTACKER != this then
					return
				endif
				set CUSTOM_RESPOND_DAMAGE_MULTIPLY = CUSTOM_RESPOND_DAMAGE_MULTIPLY + DATA_REAL2
			endmethod

			static method create takes Unit caster, Block block, integer level returns thistype
				local thistype this = allocate(caster,UNIT_ID1,block.x,block.y,270.,level,DURATION)
				set .block = block
				/*중량화(밀려나지 않음)*/
				call plusStatus(CONFIG_STATUS_HEAVY)
				/*이동 불가*/
				call BlzUnitDisableAbility(.origin_unit,'Amov',true,true)
				/*이 유닛은 건물임*/
				call UnitClass(this).plusClass(CONFIG_UNIT_CLASS_STRUCTURE)
				/*레벨*/
				set .level = level
				/*애님*/
				call setAnim("stand")
				/*좌표조정*/
				set .x = block.x
				set .y = block.y
				/*트리거*/
				set .ba_trigger = Trigger.create(this)
				call Event.register(.ba_trigger.main_trigger,CONFIG_EVENT_DAMAGE_MODIFY)
				call .ba_trigger.addCondition(function thistype.damageCallback)
				set .pivot_z = 75.
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .ba_trigger.destroy()
				set .ba_trigger = 0
				if .block > 0 then
					call .block.destroy()
				endif
				set .block = 0
			endmethod

		endstruct

		public struct actor extends UnitActor

			real manacost = 0.
			Effect ef = 0

			Block block = 0

			method onComplete takes nothing returns nothing
				set .caster.mp = .caster.mp - .manacost
				set .caster.hp = .caster.hp - .caster.hp*DATA_REAL1
				call mytower.create(.caster,.block,.level)
				set .block = 0				
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
			
			//! runtextmacro abilityTooltip10l0()
	
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

			method execute takes nothing returns nothing
				call actor.create(.owner,.command_x,.command_y,.level,.manacost)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .cast_range = 155.
				set .is_active = true
				set .preserve_order = false
				set .indicator = ind.create(this,.owner.owner)
				
			endmethod

			method deactivate takes nothing returns nothing

			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"전기충격기 건설\n ")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability10m0 전기충격(전기충격기)
scope Ability10m0 initializer init

		//! runtextmacro abilityDataHeader10m0()

		globals
			private constant string EFFECT_PATH1 = "Abilities\\Weapons\\VengeanceMissile\\VengeanceMissile.mdl"
		endglobals

		private struct chain extends ChainLightning

			method executeChain takes Unit target returns nothing
				call damageTarget(target)
				set .damage = ( .owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*.level )
				call Effect.createAttatched(EFFECT_PATH1,target.origin_unit,"chest").kill()
				set .onhit_type = Damage.ONHIT_TYPE_NONHIT
			endmethod

			static method create takes Unit_prototype caster, Unit_prototype target, integer level returns thistype
				local thistype this = allocate(caster,target,level,TARGET_MAX,INTERVAL,"AFOD")
				set .damage = ( .owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*.level ) + /*
				*/( .owner.getCarculatedStatValue(DAMAGE_STAT2) * DAMAGE_AMPLIFIER2 ) * ( 1+DAMAGE_PER_LEVEL*.level )
				call setDamageFlagById(ID)
				set .weapon_type = WEAPON_TYPE_METAL_LIGHT_CHOP
				set .radius_explosion = RANGE_SECONDARY
				return this
			endmethod

		endstruct

		public struct actor extends MeleeAttack
	
			method onComplete takes nothing returns nothing
				call chain.create(.caster,.target,.level)
			endmethod

			static method create takes Unit u, Unit target, integer level returns thistype
				local thistype this = allocate(u,target)
				set .level = .level
				call .caster.setAnim("attack")
				call .caster.setAnimSpeed(1.66)
				call SetUnitFacing(.caster.origin_unit,Math.anglePoints(.caster.x,.caster.y,.target.x,.target.y))
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .caster.queueAnim("stand ready")
				call .caster.setAnimSpeed(1.)
			endmethod
	
		endstruct
	
		public struct main extends Ability
	
			//! runtextmacro abilityTooltip10m0()

			method basicAttack takes Unit target returns nothing
				call actor.create(.owner,target,level)
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"다수의 적 연쇄공격\n ")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability10n0 번개 발톱
scope Ability10n0 initializer init

		//! runtextmacro abilityDataHeader10n0()

		globals
			private constant string EFFECT_PATH1 = "Effects\\WindSlash.mdl"
			private constant string EFFECT_PATH2 = "Abilities\\Spells\\Items\\AIlb\\AIlbSpecialArt.mdl"
		endglobals
	
		public struct actor extends MeleeAttack

			method onComplete takes nothing returns nothing
				call Effect.create(EFFECT_PATH1,.target.x-15,.target.y,.target.z+.target.pivot_z+15,270.).setScale(1.15).setColor(92,128,255).setRoll(45.).kill()
				call Effect.create(EFFECT_PATH1,.target.x+15,.target.y,.target.z+.target.pivot_z-15,270.).setScale(1.15).setColor(92,128,255).setRoll(45.).kill()
				call Effect.create(EFFECT_PATH2,.target.x,.target.y,.target.z+.target.pivot_z,270.).kill()
				set .damage = ((.owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1)+(.owner.getCarculatedStatValue(DAMAGE_STAT2) * DAMAGE_AMPLIFIER2)) * (1+DAMAGE_PER_LEVEL*.level)
				call damageTarget(.target)
				call Backswing.create(.caster)
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

			//! runtextmacro abilityTooltip10n0()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"번개 발톱 핡퀴기")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability10o0 행운의 금화
scope Ability10o0 initializer init

		//! runtextmacro abilityDataHeader10o0()
	
		globals
			private constant string EFFECT_PATH1 = "Objects\\InventoryItems\\PotofGold\\PotofGold.mdl"
			private constant string EFFECT_PATH2 = "UI\\Feedback\\GoldCredit\\GoldCredit.mdl"
		endglobals

		public struct missile extends Missile

			method executeTarget takes Unit target returns nothing
				call damageTarget(target)
				if .owner.luckyTest(DATA_REAL1,DATA_REAL2) then
					call User.addGold(.owner.owner,DATA_INTEGER1)
					call Effect.create(EFFECT_PATH2,target.x,target.y,target.z,0.).setDuration(1.5)
				endif
			endmethod

			static method create takes Unit caster, Unit target, integer level returns thistype
				local real a = Math.anglePoints(caster.x,caster.y,target.x,target.y)
				local real nx = Math.pPX(caster.x,STARTAT,a)
				local real ny = Math.pPY(caster.y,STARTAT,a)
				local thistype this = allocate(caster,EFFECT_PATH1,nx,ny,caster.z+caster.pivot_z-40.0,a)
				call setDamageFlagById(ID)
				set .damage = (.owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1) * (1+DAMAGE_PER_LEVEL*.level)
				set .radius_target = VELO*TIMER_TICK*0.5
				set .velo = VELO
				set .weapon_type = WEAPON_TYPE_WOOD_LIGHT_BASH
				call setTarget(target)
				return this
			endmethod

		endstruct

		public struct actor extends MeleeAttack

			method onComplete takes nothing returns nothing
				call missile.create(.caster,.target,.level)
				call Backswing.create(.caster)
			endmethod
	
			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target)
				set .level = level
				return this
			endmethod

		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip10o0()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"금화 던지기")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability10p0 돌진
scope Ability10p0 initializer init

		//! runtextmacro abilityDataHeader10p0()
		
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
				set .damage = ( .caster.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*.level )
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

			//! runtextmacro abilityTooltip10p0()
	
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

//!Ability10q0 단검
scope Ability10q0 initializer init

		//! runtextmacro abilityDataHeader10q0()
	
		globals
			private constant string EFFECT_PATH1 = "Effects\\WindSlash.mdl"
		endglobals
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip10q0()

			static method attackCode takes nothing returns nothing
				local MeleeAttack ma = MeleeAttack.CODE_ACTOR
				if ma <= 0 then
					return
				endif
				call Effect.create(EFFECT_PATH1,ma.target.x,ma.target.y,ma.target.z+ma.target.pivot_z,270.).setScale(1.15).setRoll(GetRandomReal(0.,360.)).kill()
				call ma.setDamageFlagById(ID)
				set ma.weapon_type = WEAPON_TYPE_METAL_LIGHT_SLICE
				set ma.damage = (ma.owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1) * (1+DAMAGE_PER_LEVEL*(ma.level))
				call ma.damageTarget(ma.target)
				call Backswing.create(ma.caster)
			endmethod

			method basicAttack takes Unit target returns nothing
				local MeleeAttack ma = MeleeAttack.create(.owner,target)
				set ma.level = .level
				call ma.addCode(function thistype.attackCode)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"평범한 검격")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//================================언데드================================

//!Ability10u0 뛰어들기
scope Ability10u0 initializer init

		//! runtextmacro abilityDataHeader10u0()

		public struct actor extends Charge

			Unit ability_target = 0

			method onComplete takes nothing returns nothing
				call damageTarget(.ability_target)
				call .caster.issueTargetOrder("attack",.ability_target.origin_unit)
			endmethod
			
			static method create takes Unit caster, Unit target, integer level returns thistype
				//! runtextmacro chargeAllocate("caster","VELO","Math.anglePoints(caster.x,caster.y,target.x,target.y)")
				set .ability_target = target
				set .duration = (Math.distancePoints(caster.x,caster.y,target.x,target.y)+RANGE_SECONDARY)/VELO
				set .z_velo = 800.
				set .gravity = 1600./.duration
				set .level = level
				set .use_collision = false
				set .ability_target = target
				call setDamageFlagById(ID)
				set .damage = (.caster.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1) * (1+DAMAGE_PER_LEVEL*.level)
				set .weapon_type = WEAPON_TYPE_METAL_HEAVY_CHOP
				call .caster.setAnim("attack")
				call .caster.setAnimSpeed(1.5)
				call .caster.queueAnim("stand ready")
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .caster.setAnimSpeed(1.0)
			endmethod

		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip10u0()
	
			method execute takes nothing returns nothing
				call actor.create(.owner,Unit_prototype.get(.command_target),level)
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .is_target = true
				set .is_charge = true
				set .cast_range = RANGE
				set .preserve_order = false
				set .indicator = AbilityIndicator.create(this,.owner.owner)
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"대상에게 돌진\n ")
			endmethod

			method executeAI takes nothing returns boolean
				return useRequest(GetUnitX(.command_target),GetUnitY(.command_target),.command_target,false)
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Buff10v0 끈적거미(버프)
scope Buff10v0 initializer init
	
	//! runtextmacro buffDataHeader10v0()

	public struct main extends Buff
		
		static constant string EFFECT_PATH1 = "Abilities\\Weapons\\CryptFiendMissile\\CryptFiendMissile.mdl"
		real val = 0.
		real v = 0.

		method relativeTooltip takes nothing returns string
			return "공격력과 이동속도가 감소했습니다."
		endmethod

		private method addValue takes nothing returns nothing
			local real r = .caster.getCarculatedStatValue(DAMAGE_STAT1)*DAMAGE_AMPLIFIER1*(1+DAMAGE_PER_LEVEL*.level)
			set .val = .val + DATA_REAL1
			call .target.minusStatValue(CONFIG_STAT_MOVEMENT_SPEED,DATA_REAL1)
			set .v = .v + r
			call .target.minusStatValue(CONFIG_STAT_ATTACK,r)
		endmethod

		method update takes nothing returns boolean
			call addValue()
			return true
		endmethod

		method init takes nothing returns boolean
			call addValue()
			call addEffect(Effect.createAttatched(EFFECT_PATH1,.target.origin_unit,"chest"))
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call .target.minusStatValue(CONFIG_STAT_MOVEMENT_SPEED,-.val)
			call .target.minusStatValue(CONFIG_STAT_ATTACK,-.v)
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

//!Ability10v0 끈적거미
scope Ability10v0 initializer init

		//! runtextmacro abilityDataHeader10v0()

		globals
			private constant string EFFECT_PATH1 = "Abilities\\Weapons\\CryptFiendMissile\\CryptFiendMissile.mdl"
		endglobals

		private struct mss extends Missile

			method executeTarget takes Unit target returns nothing
				call damageTarget(target)
				call Buff.add(.owner,target,ID,.level,DURATION)
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

			//! runtextmacro abilityTooltip10v0()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"거미떼 공격,\n대상 이동속도 감소")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability10w0 치고 빠지기
scope Ability10w0 initializer init

		//! runtextmacro abilityDataHeader10w0()

		globals
			private constant string EFFECT_PATH1 = "Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdl"
			private constant string EFFECT_PATH2 = "Abilities\\Spells\\Undead\\OrbOfDeath\\OrbOfDeathMissile.mdl"
		endglobals

		private struct dolzin extends Charge

			boolean first = true
			real yaw_temp = 0.

			Effect ef1 = 0
			Effect ef2 = 0

			method executeTarget takes Unit target returns nothing
				call Effect.create(EFFECT_PATH1,target.x,target.y,target.z+target.pivot_z,0.).setScale(2.).kill()
				call damageTarget(target)
				set .target = 0
				/*튕기기*/
				set .z_velo = 800.
				set .gravity = (800.*2)/DURATION
				set .velo = RANGE_SECONDARY/DURATION
				set .yaw = .yaw_temp-180.
				set .refresh_facing = false
				set .caster.yaw = .yaw_temp
				call .ef1.kill()
				call .ef2.kill()
				set .ef1 = 0
				set .ef2 = 0
				/*어택*/
				call .caster.issueTargetOrder("attack",target.origin_unit)
			endmethod

			static method create takes Unit caster, Unit target, integer level returns thistype
				//! runtextmacro chargeAllocate("caster","VELO","0.")
				set .refresh_facing = true
				set .level = level
				set .target = target
				call setDamageFlagById(ID)
				set .damage = .caster.getCarculatedStatValue(DAMAGE_STAT1)*DAMAGE_AMPLIFIER1*(1+DAMAGE_PER_LEVEL*.level)
				set .weapon_type = WEAPON_TYPE_METAL_MEDIUM_CHOP
				/*임시각도*/
				set .yaw_temp = Math.anglePoints(.caster.x,.caster.y,.target.x,.target.y)
				/*이펙트*/
				set .ef1 = Effect.createAttatched(EFFECT_PATH1,.caster.origin_unit,"chest")
				set .ef2 = Effect.createAttatched(EFFECT_PATH2,.caster.origin_unit,"chest")
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				if .ef1 > 0 then
					call .ef1.kill()
					call .ef2.kill()
				endif
			endmethod

		endstruct

		public struct main extends Ability

			//! runtextmacro abilityTooltip10w0()

			method execute takes nothing returns nothing
				call dolzin.create(.owner,Unit_prototype.get(.command_target),.level)
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_target = true
				set .cast_range = RANGE
				set .is_charge = true
				set .is_active = true
				set .preserve_order = true
				set .indicator = AbilityIndicator.create(this,.owner.owner)
				
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"돌진 후 거리벌리기\n ")
			endmethod
	
			method executeAI takes nothing returns boolean
				if Math.distancePoints(.owner.x,.owner.y,GetUnitX(.command_target),GetUnitY(.command_target)) <= 600. then
					return useRequest(GetUnitX(.command_target),GetUnitY(.command_target),.command_target,false)
				else
					return false
				endif
			endmethod

		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability10x0 암흑의 마법봉
scope Ability10x0 initializer init

		//! runtextmacro abilityDataHeader10x0()

		globals
			private constant string EFFECT_PATH1 = "Abilities\\Weapons\\NecromancerMissile\\NecromancerMissile.mdl"
		endglobals

		private struct mss extends Missile

			method executeTarget takes Unit target returns nothing
				call damageTarget(target)
				call .owner.restoreMP(.owner.getCarculatedStatValue(DAMAGE_STAT2)*DATA_REAL1)
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

			//! runtextmacro abilityTooltip10x0()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"원거리 마법공격\n")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Buff10y0 오염된 식칼(버프)
scope Buff10y0 initializer init
	
	//! runtextmacro buffDataHeader10y0()

	public struct main extends Buff
		
		real v = 0.

		method relativeTooltip takes nothing returns string
			return "최대체력이 감소했습니다."
		endmethod

		method update takes nothing returns boolean
			/*local real r = .caster.maxhp*DAMAGE_AMPLIFIER1*(1+DAMAGE_PER_LEVEL*.level)
			if r > .v then
				call .target.minusStatValue(CONFIG_STAT_MAXHP,-.v)
				set .v = r
				call .target.minusStatValue(CONFIG_STAT_MAXHP,.v)
			endif*/
			local real r = .caster.getCarculatedStatValue(DAMAGE_STAT1)*DAMAGE_AMPLIFIER1*(1+DAMAGE_PER_LEVEL*.level)*.caster.damage_give
			set .v = .v + r
			call .target.minusStatValue(CONFIG_STAT_MAXHP,r)
			return true
		endmethod

		method init takes nothing returns boolean
			set .v = .caster.getCarculatedStatValue(DAMAGE_STAT1)*DAMAGE_AMPLIFIER1*(1+DAMAGE_PER_LEVEL*.level)
			call .target.minusStatValue(CONFIG_STAT_MAXHP,.v)
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call .target.minusStatValue(CONFIG_STAT_MAXHP,-.v)
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

//!Ability10y0 오염된 식칼
scope Ability10y0 initializer init

		//! runtextmacro abilityDataHeader10y0()

		globals
			private constant string EFFECT_PATH1 = "Effects\\WindSlash.mdl"
			private constant string EFFECT_PATH2 = "Abilities\\Spells\\Other\\Cleave\\CleaveDamageTarget.mdl"
		endglobals
	
		public struct actor extends MeleeAttack

			method onComplete takes nothing returns nothing
				call Effect.create(EFFECT_PATH1,.target.x,.target.y,.target.z+.target.pivot_z,270.).setScale(1.8).setRoll(GetRandomReal(-55,55)).setColor(0, 116, 19).kill()
				call Effect.create(EFFECT_PATH2,.target.x,.target.y,.target.z+.target.pivot_z,270.).setScale(1.8).kill()
				set .damage = ((.owner.getCarculatedStatValue(DAMAGE_STAT2) * DAMAGE_AMPLIFIER2) + (.owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1)) * (1+DAMAGE_PER_LEVEL*.level)
				call damageTarget(.target)
				call Buff.add(.caster,.target,ID,.level,DURATION)
				call Backswing.create(.caster)
			endmethod
	
			static method create takes Unit caster, Unit target, integer level returns thistype
				local thistype this = allocate(caster,target)
				set .level = level
				call setDamageFlagById(ID)
				set .weapon_type = WEAPON_TYPE_METAL_HEAVY_BASH
				return this
			endmethod

		endstruct
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip10y0()

			method basicAttack takes Unit target returns nothing
				local actor ac = actor.create(.owner,target,level)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"체력 깎아내기")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//================================아이템================================

//!Ability10r0 힘의 장갑
scope Ability10r0 initializer init

		//! runtextmacro abilityDataHeader10r0()
	
		public struct main extends Ability

			Trigger main_trigger = 0

			//! runtextmacro abilityTooltip10r0()

			static method callback takes nothing returns nothing
				local thistype this = 0
				set this = Trigger.getData(GetTriggeringTrigger())
				if CUSTOM_RESPOND_DAMAGE_ATTACKER != .owner then
					return
				endif
				if CUSTOM_RESPOND_DAMAGE_RANGE_TYPE == Damage.RANGE_TYPE_MELEE then
					set CUSTOM_RESPOND_DAMAGE_MULTIPLY = CUSTOM_RESPOND_DAMAGE_MULTIPLY + DAMAGE_BASE + DAMAGE_PER_LEVEL*.level
					return
				elseif DamageTag.includes(CUSTOM_RESPOND_DAMAGE_ID,CONFIG_ABILITY_TAG_BASH) then
					set CUSTOM_RESPOND_DAMAGE_MULTIPLY = CUSTOM_RESPOND_DAMAGE_MULTIPLY + DAMAGE_BASE + DAMAGE_PER_LEVEL*.level
					return
				endif
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .main_trigger = Trigger.create(this)
				call Event.register(.main_trigger.main_trigger,CONFIG_EVENT_DAMAGE_MODIFY)
				call .main_trigger.addCondition(function thistype.callback)
				//
				
			endmethod

			method deactivate takes nothing returns nothing
				call .main_trigger.destroy()
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"근접공격 피해량 증가")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability10s0 날카로운 갈고리
scope Ability10s0 initializer init

		//! runtextmacro abilityDataHeader10s0()
	
		public struct main extends Ability

			Trigger main_trigger = 0

			//! runtextmacro abilityTooltip10s0()

			static method callback takes nothing returns nothing
				local thistype this = 0
				set this = Trigger.getData(GetTriggeringTrigger())
				if CUSTOM_RESPOND_DAMAGE_ATTACKER != .owner then
					return
				endif
				if DamageTag.includes(CUSTOM_RESPOND_DAMAGE_ID,CONFIG_ABILITY_TAG_SLASH) then
					set CUSTOM_RESPOND_DAMAGE_MULTIPLY = CUSTOM_RESPOND_DAMAGE_MULTIPLY + DAMAGE_BASE + DAMAGE_PER_LEVEL*.level
					return
				elseif DamageTag.includes(CUSTOM_RESPOND_DAMAGE_ID,CONFIG_ABILITY_TAG_PIERCE) then
					set CUSTOM_RESPOND_DAMAGE_MULTIPLY = CUSTOM_RESPOND_DAMAGE_MULTIPLY + DAMAGE_BASE + DAMAGE_PER_LEVEL*.level
					return
				endif
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .main_trigger = Trigger.create(this)
				call Event.register(.main_trigger.main_trigger,CONFIG_EVENT_DAMAGE_MODIFY)
				call .main_trigger.addCondition(function thistype.callback)
				//
				
			endmethod

			method deactivate takes nothing returns nothing
				call .main_trigger.destroy()
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"참격, 관통공격 피해량 증가")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability10t0 에메랄드
scope Ability10t0 initializer init

		//! runtextmacro abilityDataHeader10t0()
	
		public struct main extends Ability

			/*체젠증가량(%)*/
			real v = 0.

			//! runtextmacro abilityTooltip10t0()

			method refresh takes boolean b returns nothing
				if .v > 0. then
					call .owner.multiplyStatValue(STAT_BONUS1,-.v)
				endif
				set .v = 0.
				if b then
					set .v = DAMAGE_BASE + ( DAMAGE_PER_LEVEL * .level )
					call .owner.multiplyStatValue(STAT_BONUS1,.v)
				endif
			endmethod

			method update takes integer val returns nothing
				call refresh(true)
			endmethod

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				call refresh(true)
			endmethod

			method deactivate takes nothing returns nothing
				call refresh(false)
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"체력재생")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Buff10z0 맑은 물(버프)
scope Buff10z0 initializer init

	//! runtextmacro buffDataHeader10z0()

	globals
		public constant string EFFECT_PATH1 = "Abilities\\Spells\\Other\\ANrl\\ANrlTarget.mdl"
	endglobals

	public struct main extends Buff

		real v = 0.
		real power = 0.
		integer poman = 0

		method relativeTooltip takes nothing returns string
			return "매 초 마나를 회복합니다."
		endmethod

		method intervalAction takes nothing returns nothing
			call .target.restoreMP((.v*.power*.interval)/.duration_max)
		endmethod

		method init takes nothing returns boolean
			set .poman = CUSTOM_RESPOND_BUFF_VALUE//REMAINS
			if .poman > DATA_INTEGER1 then
				set .poman = DATA_INTEGER1
			endif
			set .extra = I2S(.poman)
			call UnitClass(.target).addClass(CONFIG_UNIT_CLASS_POMANGAM,.poman)
			set .power = I2R(.poman)/I2R(DATA_INTEGER1)
			set .v = DAMAGE_BASE * (1+DAMAGE_PER_LEVEL*.level)
			set .interval = 0.5
			call addEffect(Effect.createAttatched(EFFECT_PATH1,.target.origin_unit,"origin"))
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call UnitClass(.target).addClass(CONFIG_UNIT_CLASS_POMANGAM,-.poman)
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

//!Ability10z0 맑은 물
scope Ability10z0 initializer init

		//! runtextmacro abilityDataHeader10z0()
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip10z0()

			method execute takes nothing returns nothing
				local integer remains = UnitClass(.owner).getClass(CONFIG_UNIT_CLASS_POMANGAM_MAX) - UnitClass(.owner).getClass(CONFIG_UNIT_CLASS_POMANGAM)
				call Buff.addWithValue(.owner,.owner,'10z0',.level,DURATION,remains)
			endmethod

			method useFilterAdditional takes nothing returns boolean
				if UnitClass(.owner).getClass(CONFIG_UNIT_CLASS_POMANGAM) >= UnitClass(.owner).getClass(CONFIG_UNIT_CLASS_POMANGAM_MAX) then
					set CUSTOM_RESPOND_ERROR_MESSAGE = "배불러서 더이상 먹을 수 없습니다."
					return false
				endif
				return true
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .preserve_order = true
				set .is_immediate = true
				set .useable_cast = true
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"마나 회복\n ")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Buff10A0 빵(버프)
scope Buff10A0 initializer init

	//! runtextmacro buffDataHeader10A0()

	globals
		public constant string EFFECT_PATH1 = "Abilities\\Spells\\Other\\ANrm\\ANrmTarget.mdl"
	endglobals

	public struct main extends Buff

		real v = 0.
		real power = 0.
		integer poman = 0

		method relativeTooltip takes nothing returns string
			return "매 초 체력을 회복합니다."
		endmethod

		method intervalAction takes nothing returns nothing
			call .target.healUnit(.target,(.v*.power*.interval)/.duration_max)
		endmethod

		method init takes nothing returns boolean
			set .poman = CUSTOM_RESPOND_BUFF_VALUE//REMAINS
			if .poman > DATA_INTEGER1 then
				set .poman = DATA_INTEGER1
			endif
			set .extra = I2S(.poman)
			call UnitClass(.target).addClass(CONFIG_UNIT_CLASS_POMANGAM,.poman)
			set .power = I2R(.poman)/I2R(DATA_INTEGER1)
			set .v = DAMAGE_BASE * (1+DAMAGE_PER_LEVEL*.level)
			set .interval = 0.5
			call addEffect(Effect.createAttatched(EFFECT_PATH1,.target.origin_unit,"origin"))
			return true
		endmethod

		method onDestroy takes nothing returns nothing
			call UnitClass(.target).addClass(CONFIG_UNIT_CLASS_POMANGAM,-.poman)
		endmethod

	endstruct

	//! runtextmacro buffEnd()
endscope

//!Ability10A0 빵
scope Ability10A0 initializer init

		//! runtextmacro abilityDataHeader10A0()
	
		public struct main extends Ability

			//! runtextmacro abilityTooltip10A0()

			method execute takes nothing returns nothing
				local integer remains = UnitClass(.owner).getClass(CONFIG_UNIT_CLASS_POMANGAM_MAX) - UnitClass(.owner).getClass(CONFIG_UNIT_CLASS_POMANGAM)
				call Buff.addWithValue(.owner,.owner,'10A0',.level,DURATION,remains)
			endmethod

			method useFilterAdditional takes nothing returns boolean
				if UnitClass(.owner).getClass(CONFIG_UNIT_CLASS_POMANGAM) >= UnitClass(.owner).getClass(CONFIG_UNIT_CLASS_POMANGAM_MAX) then
					set CUSTOM_RESPOND_ERROR_MESSAGE = "배불러서 더이상 먹을 수 없습니다."
					return false
				endif
				return true
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .preserve_order = true
				set .is_immediate = true
				set .useable_cast = true
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"체력 회복\n ")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability10B0 행운의 은관
scope Ability10B0 initializer init

		//! runtextmacro abilityDataHeader10B0()
	
		public struct main extends Ability

			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
			endmethod

			method deactivate takes nothing returns nothing
				
			endmethod

			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"행운 마일리지 저축")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope