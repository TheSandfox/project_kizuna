//!Ability4000 미사일 컨테이너
scope Ability4000 initializer init

		//! runtextmacro abilityParam4000()

		globals
			private constant string EFFECT_PATH1 = "Effects\\MissilePod.mdl"
			private constant string EFFECT_PATH2 = "Abilities\\Spells\\Other\\TinkerRocket\\TinkerRocketMissile.mdl"
			private constant string EFFECT_PATH3 = "Abilities\\Weapons\\SearingArrow\\SearingArrowMissile.mdl"
		endglobals

		private struct mss extends Missile

			method executeTarget takes Unit target returns nothing
				if IsUnitInGroup(target.origin_unit,.group_already) then
					set .damage = .damage * DAMAGE_SECONDARY
					set .onhit_type = Damage.ONHIT_TYPE_NONHIT
				else
					call GroupAddUnit(.group_already,target.origin_unit)
				endif
				call damageTarget(target)
			endmethod

			static method create takes Unit caster, Unit target, real x, real y, real z, integer level returns thistype
				local real a = GetRandomReal(45,135)
				local thistype this = allocate(caster,EFFECT_PATH2,x,y,z,Math.anglePoints(x,y,target.x,target.y))
				local CurveBezier3 bz = 0
				call setTarget(target)
				set .curve = CurveBezier3.create(x,y,z,target.x,target.y,target.z+target.pivot_z)
				set .curve.overtime = 0.75
				set bz = .curve
				call bz.setProjectedControlPoint(0,-800, 300, a)
				call bz.setProjectedControlPoint(1, 0, 800, a)
				call setDamageFlagById(ID)
				set .damage = ( .owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*(level) )
				set .weapon_type = WEAPON_TYPE_METAL_MEDIUM_BASH
				set .movement.refresh_facing = true
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				set .pitch = 0.
			endmethod

		endstruct

		private struct ball extends Missile

			integer count_true = COUNT
			Circle c = 0

			MissileGroup mg = 0

			method periodicAction takes nothing returns nothing
				call .c.setPosition(.x,.y,2.)
			endmethod

			method executeWave takes Unit target returns nothing

			endmethod

			method beforeWave takes nothing returns nothing
				call GroupClear(.group_wave)
			endmethod

			method afterWave takes nothing returns nothing
				local Unit u = Unit_prototype.get(Group.getRandomUnit(.group_wave))
				local Missile ms = 0
				local Effect ef = 0
				if u > 0 then
					set ms = mss.create(.owner,u,.x,.y,.z,.level)
					call .mg.add(ms)
					set .count_true = .count_true - 1
					if .count_true <= 0 then
						set .want_kill = true
					endif
					set .velo = VELO*0.5
					set ef = Effect.create(EFFECT_PATH3,Math.pPX(.x,STARTAT*-1,Math.anglePoints(.x,.y,u.x,u.y)),/*
						*/Math.pPY(.y,STARTAT*-1,Math.anglePoints(.x,.y,u.x,u.y)),.z,Math.anglePoints(.x,.y,u.x,u.y))
					set ef.pitch = -90.
					call ef.kill()
				else
					set .velo = VELO
				endif
			endmethod

			static method create takes Unit caster, real x, real y, real z, real yaw, integer level returns thistype
				local thistype this = allocate(caster,EFFECT_PATH1,x,y,z,yaw)
				call setScale(3.)
				set .level = level
				set .velo = VELO
				set .mg = MissileGroup.create()
				call .mg.setDuration(15.)
				call setWave(RADIUS3)
				set .wave_interval = INTERVAL
				call setDuration(DURATION)
				set .c = Circle.createSpecific("Effects\\CastRangeCircle.mdl",x,y,2.,0.)
				call .c.setScale(RADIUS3/100.)
				call .c.setAlpha(192)
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .mg.setDuration(15.)
				set .mg = 0
				call .c.setFadeOutPoint(0.,0.75)
			endmethod

		endstruct

		public struct actor extends UnitActor
	
			real angle = 0.

			method onComplete takes nothing returns nothing
				local ball ms = ball.create(.caster,/*
				*/Math.pPX(.caster.x,STARTAT,Math.anglePoints(.caster.x,.caster.y,.x,.y)),/*
				*/Math.pPY(.caster.y,STARTAT,Math.anglePoints(.caster.x,.caster.y,.x,.y)),75.,/*
				*/.angle,.level)
				call UnitActor.create(.caster,0,0.,0.,0,BACKSWING,true)
			endmethod
	
			static method create takes Unit u, real x, real y, real delay, integer level returns thistype
				local thistype this = allocate(u,0,x,y,level,delay,true)
				set .angle = Math.anglePoints(.caster.x,.caster.y,.x,.y)
				call .caster.setAnim("attack")
				call .caster.setAnim("spell")
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
				set .yaw = Math.anglePoints(.abil.owner.x,.abil.owner.y,Mouse.getVX(owner),Mouse.getVY(owner))
				set .x = Math.pPX(.abil.owner.x,-RADIUS3,.yaw)
				set .y = Math.pPY(.abil.owner.y,-RADIUS3,.yaw)
				set .range = RANGE+RADIUS3*2
				set .width = RADIUS3
			endmethod

			static method create takes Ability_prototype abil, player owner returns thistype
				local thistype this = allocate(abil,owner)
				return this
			endmethod

		endstruct

		public struct main extends Ability

			//! runtextmacro abilityTooltip4000()
	
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
				call Ability.setTypeTooltip(ID,"연발 미사일 컨테이너 소환\n ")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope

//!Ability4010 불사조
scope Ability4010 initializer init

	//! runtextmacro abilityParam4010()
	
	globals
		private constant real BALL_DIST = 600.
		private constant real BALL_HEIGHT = 1000.
		private constant string EFFECT_PATH1 = "units\\human\\phoenix\\phoenix.mdl"
		private constant string EFFECT_PATH2 = "Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl"
		private constant string EFFECT_PATH3 = "Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireDamage.mdl"
	endglobals

	private struct ball extends Missile

		integer stage = 0
		Circle c = 0
		real to2 = 0.
		real ox = 0.
		real oy = 0.
		real oa = 0.

		method periodicAction takes nothing returns nothing
			if .stage == 1 then
				if .c > 0 then
					set .c.x = .x
					set .c.y = .y
				endif
				set .to2 = .to2 + TIMER_TICK
				if .to2 >= (RANGE_SECONDARY/VELO) then
					set .stage = 2
					set .radius_wave = 0.
					set .movement.curve = CurveBezier2.create(.x,.y,0.,Math.pPX(.x,BALL_HEIGHT,.yaw),Math.pPY(.y,BALL_HEIGHT,.yaw),BALL_DIST)
					call .movement.curve.setX(Curve.POINT_MIDDLE,Math.pPX(.x,BALL_HEIGHT,.yaw))
					call .movement.curve.setY(Curve.POINT_MIDDLE,Math.pPY(.y,BALL_HEIGHT,.yaw))
					call .movement.curve.setZ(Curve.POINT_MIDDLE,0.)
					set .movement.curve.overtime = DELAY+CAST
					set .movement.refresh_facing = true
					set .want_remove = true
					call Effect.create(EFFECT_PATH2,.x,.y,125.,.yaw).setPitch(-105).setDuration(1.0)
					if .c > 0 then
						call .c.setFadeOutPoint(0.,1.25)
					endif
					set .c = 0
				endif
			elseif .stage == 2 then
				call setAlpha(R2I(getAlpha()-255*TIMER_TICK/DELAY))
			endif
		endmethod

		method afterWave takes nothing returns nothing
			local real d = SquareRoot(GetRandomReal(0,(RADIUS3/2)*(RADIUS3/2)))
			local real a = GetRandomReal(0,360)
			call Effect.create(EFFECT_PATH3,Math.pPX(.x,d,a),Math.pPY(.y,d,a),0.,.yaw).setDuration(1.5).setScale(2.).setPitch(-30.)
		endmethod

		method executeWave takes Unit target returns nothing
			call damageTarget(target)
			call Effect.create(EFFECT_PATH2,target.x,target.y,target.z+55.,.yaw).setScale(0.5).setDuration(1.5).setPitch(-90)
		endmethod

		method afterExplosion takes nothing returns nothing
			local Effect ef = Effect.create(EFFECT_PATH2,.x,.y,125.,.oa)
			call GroupClear(.group_wave)
			call ef.setDuration(1.0)
			call ef.setPitch(-90)
			call resetTargetLocation()
			set .movement.curve = 0
			set .movement.refresh_facing = false
			/*커브 제거 후 좌표보정*/
			set .x = .ox
			set .y = .oy
			set .yaw = .oa
			set .velo = VELO
			call setDuration((RANGE_SECONDARY/VELO)+DELAY+CAST)
			call setWave(RADIUS3)
			call setColor(255,255,153)
			set .c = Circle.create(.x,.y,1.,RADIUS3)
			call .c.setColor(255,R2I(0.65*255),0)
			call .c.fadeIn(CAST)
		endmethod

		method executeExplosion takes Unit target returns nothing

		endmethod

		method killFilter takes nothing returns boolean
			if .stage == 0 then
				set .stage = 1
				set .want_kill = false
				return false
			endif
			return true
		endmethod

		static method create takes Unit caster, real x, real y, real angle, integer level returns thistype
			local real tx = Math.pPX(x,BALL_DIST,angle+180)
			local real ty = Math.pPY(y,BALL_DIST,angle+180)
			local thistype this = allocate(caster,EFFECT_PATH1,tx,ty,BALL_HEIGHT,angle)
			set .offset_pitch = 20.
			call setYaw(90.)
			set .movement.curve = CurveBezier2.create(tx,ty,BALL_HEIGHT,x,y,0.)
			set .movement.curve.overtime = DELAY
			call .movement.curve.setX(Curve.POINT_MIDDLE,tx)
			call .movement.curve.setY(Curve.POINT_MIDDLE,ty)
			call .movement.curve.setZ(Curve.POINT_MIDDLE,0.)
			set .movement.refresh_facing = true
			set .offset_z = 125.
			call setScale(2.)
			set .level = level
			call setTargetLocation(x,y,0.)
			call setExplosion(RADIUS3)
			call setDamageFlagById(ID)
			set .damage = (.owner.getCarculatedStatValue(DAMAGE_STAT1) * DAMAGE_AMPLIFIER1 ) * ( 1+DAMAGE_PER_LEVEL*(.level) )
			/*원래사용지점&각도*/
			set .ox = x
			set .oy = y
			set .oa = angle
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			if .c > 0 then
				call .c.setFadeOutPoint(0.,1.25)
			endif
			set .c = 0
		endmethod

	endstruct

	private struct actor extends UnitActor

		real angle = 0.

		method onComplete takes nothing returns nothing
			call ball.create(caster,x,y,angle,level)
		endmethod

		static method create takes Unit caster, real x, real y, real angle, integer level returns thistype
			local thistype this = allocate(caster,0,x,y,level,CAST,true)
			call .caster.setAnim("attack")
			call .caster.setAnim("spell")
			call .caster.queueAnim("stand ready")
			call .caster.setAnimSpeed(1.66)
			set .angle = angle
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			call .caster.setAnimSpeed(1.)
		endmethod

	endstruct

	private struct ind extends LineIndicator

		method beforeRefresh takes nothing returns nothing
			set .yaw = Math.anglePoints(.abil.command_x_temp,.abil.command_y_temp,Mouse.getVX(owner),Mouse.getVY(owner))
			set .x = Math.pPX(.abil.command_x_temp,-RADIUS3,.yaw)
			set .y = Math.pPY(.abil.command_y_temp,-RADIUS3,.yaw)
			set .range = RANGE_SECONDARY+RADIUS3*2
			set .width = RADIUS3
		endmethod

		static method create takes Ability_prototype abil, player owner returns thistype
			local thistype this = allocate(abil,owner)
			call .ef.setColor(255,R2I(0.65*255),0)
			call .circle.setColor(255,R2I(0.65*255),0)
			return this
		endmethod

	endstruct

	public struct main extends Ability

		//! runtextmacro abilityTooltip4010()

		method execute takes nothing returns nothing
			local actor a = actor.create(.owner,.command_x,.command_y,Math.anglePoints(.command_x,.command_y,.command_x2,.command_y2),level)
		endmethod

		method init takes nothing returns nothing
			//! runtextmacro abilitySetup()
			set .is_active = true
			set .cast_range = RANGE
			set .preserve_order = false
			set .indicator = ind.create(this,.owner.owner)
			
		endmethod

		static method onInit takes nothing returns nothing
			call Ability.setTypeTooltip(ID,"직선범위 적 공격\n ")
		endmethod

	endstruct
	
	//! runtextmacro abilityDataEnd()
endscope