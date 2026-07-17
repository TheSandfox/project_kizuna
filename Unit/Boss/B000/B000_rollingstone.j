private struct rollingstone_fall extends Explosion

	static constant real RAD = 425.0
	static constant real DELAY = 0.75

	method executeExplosion takes Unit target returns nothing
		call Buff.addWithValue(.owner,target,'Slow',0,0.5,90)
		set .damage = .owner.getCarculatedStatValue(CONFIG_STAT_ATTACK) * 1.0 + target.maxhp*0.45
		call Airbourne.create(target,0.,0.,1550.,1.0)
		call damageTarget(target)
		call Effect.create(EF_ROCK,target.x,target.y,target.z+target.pivot_z,270.).setScale(1.75).kill()
	endmethod

	method afterExplosion takes nothing returns nothing
		call Effect.create("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",.x,.y,0.,0.).setDuration(1.5)
		call Effect.create("abilities\\weapons\\DemolisherMissile\\DemolisherMissile.mdl",.x,.y,0.,0.).setScale(5.0).kill()
	endmethod

	static method create takes Boss caster, real x, real y returns thistype
		local thistype this = allocate(caster,x,y,RAD)
		local real a = Math.anglePoints(caster.x,caster.y,x,y)
		local Effect ef = 0
		local Curve c = 0
		set .interval = DELAY
		set .activate_initial = false
		call activate()
		/*무적+안보이기*/
		call caster.plusStatus(CONFIG_STATUS_INVINCIBLE)
		call caster.plusStatus(CONFIG_STATUS_HIDE)
		/*패턴*/
		set caster.yaw = a
		set caster.pattern_running = caster.pattern_running + 1
		/*이펙트&커브*/
		set ef = Effect.create(EF_ROCK,caster.x,caster.y,caster.pivot_z,a)
		call ef.setScale(5.5)
		set ef.movement = Movement.create(ef,0.,a)
		set c = CurveBezier3.create(caster.x,caster.y,caster.z,x,y,0.)
		set ef.movement.curve = c
		call ef.setDuration(DELAY)
		set c.overtime = DELAY
		call c.setPosition(Curve.POINT_MIDDLE,caster.x,caster.y,2000)
		call c.setPosition(Curve.POINT_MIDDLE+1,x,y,2000)
		/*데미지플래그*/
		set .damage_id = ID2
		set .damage_type = CONFIG_DAMAGE_PHYSICAL
		set .attack_type = CONFIG_DAMAGE_SPELL
		set .interval_type = CONFIG_DAMAGE_SINGLE
		set .vector_type = CONFIG_DAMAGE_OUTTER
		set .target_type = CONFIG_DAMAGE_NONTARGET
		set .aoe_type 	= CONFIG_DAMAGE_AOE
		set .onhit_type = CONFIG_DAMAGE_ONHIT
		set .range_type = CONFIG_DAMAGE_MELEE
		return this
	endmethod

	method onDestroy takes nothing returns nothing
		/*무적+안보이기*/
		call .owner.minusStatus(CONFIG_STATUS_INVINCIBLE)
		call .owner.minusStatus(CONFIG_STATUS_HIDE)
		/*패턴*/
		set Boss(.owner).pattern_running = Boss(.owner).pattern_running - 1
		set .owner.x = .x
		set .owner.y = .y
	endmethod

endstruct

private struct rollingstone_roll extends Missile

	static constant real RAD = 185.0
	static constant real RANGE = 800.
	static constant real VELO = 1600.

	Effect ef = 0

	method periodicAction takes nothing returns nothing
		local real ra = GetRandomReal(0.,360.)
		local real rd = SquareRoot(GetRandomReal(0,.radius_wave*.radius_wave))
		call .ef.setPosition(.x,.y,2.0)
		call Effect.create(EF_ROCK,Math.pPX(.x,rd,ra),Math.pPY(.y,rd,ra),0.,270.).setScale(1.75).kill()
	endmethod

	method executeWave takes Unit target returns nothing
		call Buff.addWithValue(.owner,target,'Slow',0,0.5,90)
		set .damage = .owner.getCarculatedStatValue(CONFIG_STAT_ATTACK) * 1.0 + target.maxhp*0.45
		call damageTarget(target)
		call Airbourne.create(target,200.,.owner.yaw,750.,1.0)
		call Effect.create(EF_ROCK,target.x,target.y,target.z+target.pivot_z,270.).setScale(1.75).kill()
	endmethod

	static method create takes Boss caster, real x, real y returns thistype
		local real angle = Math.anglePoints(caster.x,caster.y,x,y)
		local thistype this = allocate(caster,EF_ROCK,caster.x,caster.y,caster.pivot_z,angle)
		set caster.yaw = angle
		call setWave(RAD)
		call setScale(5.5)
		set .velo = VELO
		call setDuration(RANGE/VELO)
		set .ef = Effect.create("Effects\\CastRangeCircle.mdl",.x,.y,2.0,270.)
		call .ef.setScale(RAD/100.)
		call .ef.setColor(255,0,0)
		/*무적+안보이기*/
		call caster.plusStatus(CONFIG_STATUS_INVINCIBLE)
		call caster.plusStatus(CONFIG_STATUS_HIDE)
		/*패턴*/
		set caster.pattern_running = caster.pattern_running + 1
		/*데미지플래그*/
		set .damage_id = ID2
		set .damage_type = CONFIG_DAMAGE_PHYSICAL
		set .attack_type = CONFIG_DAMAGE_SPELL
		set .interval_type = CONFIG_DAMAGE_SINGLE
		set .vector_type = CONFIG_DAMAGE_OUTTER
		set .target_type = CONFIG_DAMAGE_NONTARGET
		set .aoe_type 	= CONFIG_DAMAGE_AOE
		set .onhit_type = CONFIG_DAMAGE_ONHIT
		set .range_type = CONFIG_DAMAGE_MELEE
		set .weapon_type = WEAPON_TYPE_ROCK_HEAVY_BASH
		return this
	endmethod

	method onDestroy takes nothing returns nothing
		call .ef.destroy()
		/*무적+안보이기*/
		call .owner.minusStatus(CONFIG_STATUS_INVINCIBLE)
		call .owner.minusStatus(CONFIG_STATUS_HIDE)
		/*패턴*/
		set Boss(.owner).pattern_running = Boss(.owner).pattern_running - 1
		call .owner.warp(.x,.y)
	endmethod

endstruct

private struct rollingstone extends BossActor

	/*구르기 준비동작*/
	static constant real DELAY1 = 1.25
	static constant real EF_SCALE = 4.0
	static constant real RANGE = 800.

	integer atype = 0/*0구르기,1수직낙하*/
	Effect ef = 0

	method onComplete takes nothing returns nothing
		if .atype == 0 then
			call rollingstone_roll.create(.caster,.x,.y)
		elseif .atype == 1 then
			call rollingstone_fall.create(.caster,.x,.y)
		endif
	endmethod

	method periodicAction takes nothing returns nothing
		// if .atype == 0 then
		call .ef.setScale(.ef.getScale()+(1.5*TIMER_TICK)/DELAY1)
		// elseif .atype == 1 then
		// 	set .ef.z = .ef.z + 600*TIMER_TICK
		// endif
	endmethod

	static method create takes Boss caster, Unit target returns thistype
		local thistype this = allocate(caster,0,0.,0.,0,DELAY1,true)
		local ProgressiveEffect ps = 0
		local real tx = 0.
		local real ty = 0.
		local real ta = Math.anglePoints(caster.x,caster.y,target.x,target.y)
		/*무적+안보이기*/
		call caster.plusStatus(CONFIG_STATUS_INVINCIBLE)
		call caster.plusStatus(CONFIG_STATUS_HIDE)
		/*이펙트*/
		call Effect.create(EF_ROCK,caster.x,caster.y,caster.z+caster.pivot_z,caster.yaw).setScale(5.0).kill()
		set .ef = Effect.create(EF_ROCK,caster.x,caster.y,caster.z+caster.pivot_z,caster.yaw)
		call .ef.setScale(EF_SCALE)
		/*사거리밖:수직낙하*/
		if Math.distancePoints(caster.x,caster.y,target.x,target.y) > rollingstone_roll.RANGE then
			set tx = target.x
			set ty = target.y
			/*대상이 보스존 안임*/
			if Math.inBox(tx,ty,GetRectMinX(caster.zone),GetRectMaxY(caster.zone),Boss.ZONE_SIZE,Boss.ZONE_SIZE) then
				set .x = tx
				set .y = ty
			/*대상이 보스존 밖임*/
			else
				set .x = GetRandomReal(GetRectMinX(caster.zone)+128,GetRectMaxX(caster.zone)-128)
				set .y = GetRandomReal(GetRectMinY(caster.zone)+128,GetRectMaxY(caster.zone)-128)
			endif
			set ps = ProgressiveCircle.create(.x,.y,0.,rollingstone_fall.RAD,DELAY1+rollingstone_fall.DELAY)
			call ps.getEffect(0).setColor(192,0,0)
			call ps.getEffect(1).setColor(255,0,0)
			set .atype = 1
		/*사거리 안*/
		else
			set tx = Math.pPX(caster.x,rollingstone_roll.RANGE,ta)
			set ty = Math.pPY(caster.y,rollingstone_roll.RANGE,ta)
			/*사거리 안, 유효좌표:구르기*/
			if Math.inBox(tx,ty,GetRectMinX(caster.zone),GetRectMaxY(caster.zone),Boss.ZONE_SIZE,Boss.ZONE_SIZE) then
				set .x = tx
				set .y = ty
				set .atype = 0
				set ps = ProgressiveLine.create(.caster.x,.caster.y,0.,rollingstone_roll.RAD,rollingstone_roll.RANGE,ta,DELAY1)
				call ps.getEffect(0).setColor(192,0,0)
				call ps.getEffect(1).setColor(255,0,0)
			/*사거리 안, 비유효 :수직낙하*/
			else
				set tx = target.x
				set ty = target.y
				/*대상이 보스존 안임*/
				if Math.inBox(tx,ty,GetRectMinX(caster.zone),GetRectMaxY(caster.zone),Boss.ZONE_SIZE,Boss.ZONE_SIZE) then
					set .x = tx
					set .y = ty
				/*대상이 보스존 밖임*/
				else
					set .x = GetRandomReal(GetRectMinX(caster.zone)+128,GetRectMaxX(caster.zone)-128)
					set .y = GetRandomReal(GetRectMinY(caster.zone)+128,GetRectMaxY(caster.zone)-128)
				endif
				set .atype = 1
				set ps = ProgressiveCircle.create(.x,.y,0.,rollingstone_fall.RAD,DELAY1+rollingstone_fall.DELAY)
				call ps.getEffect(0).setColor(192,0,0)
				call ps.getEffect(1).setColor(255,0,0)
			endif
		endif
		return this
	endmethod

	method onDestroy takes nothing returns nothing
		/*무적+안보이기*/
		call caster.minusStatus(CONFIG_STATUS_INVINCIBLE)
		call caster.minusStatus(CONFIG_STATUS_HIDE)
		/*이펙트*/
		if .ef > 0 then
			call .ef.kill()
		endif
	endmethod

	static method onInit takes nothing returns nothing
		call DamageTag.add(ID2,CONFIG_ABILITY_TAG_EARTH)
	endmethod

endstruct