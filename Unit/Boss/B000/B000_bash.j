/*대지강타 폭발*/
private struct rockexplosion extends Explosion

	boolean strong = false

	method executeFilter takes nothing returns boolean
		return .owner.getStatus(CONFIG_STATUS_DEAD) <= 0 and .owner.getStatus(CONFIG_STATUS_UNSTOP) > 0
	endmethod

	method beforeExplosion takes nothing returns nothing
		call Effect.create("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl",.x,.y,0.,0.).setDuration(1.0)
		call Effect.create("abilities\\weapons\\DemolisherMissile\\DemolisherMissile.mdl",.x,.y,0.,0.).setScale(2.5).kill()
	endmethod

	method executeExplosion takes Unit target returns nothing
		call Buff.addWithValue(.owner,target,'Slow',0,0.5,90)
		/*마지막 일격*/
		if .strong then
			set .damage = .owner.getCarculatedStatValue(CONFIG_STAT_ATTACK) * 1.0 + target.maxhp*0.5 
			/*50범위 이내일 때 제자리*/
			if Math.distancePoints(.x,.y,target.x,target.y) <= 50. then
				call SpinningKnockback.create(target,0,0,550.,3.,0.5)
			/*바깥이면 넉백*/
			else
				call SpinningKnockback.create(target,300.,Math.anglePoints(.x,.y,target.x,target.y),550.,3.,0.5)
			endif
			/*+스턴*/
			call Buff.add(0,target,'Stun',0,0.5)
		/*마지막 일격 아님*/
		else
			set .damage = .owner.getCarculatedStatValue(CONFIG_STAT_ATTACK) * 1.0 + target.maxhp*0.33
		endif
		call damageTarget(target)
	endmethod

	static method create takes Unit owner, real x, real y, real radius, real delay, boolean strong returns thistype
		local thistype this = allocate(owner,x,y,radius)
		set .activate_initial = false
		set .interval = delay
		set .strong = strong
		//
		set .damage_id = ID1
		set .damage_type = CONFIG_DAMAGE_PHYSICAL
		set .attack_type = CONFIG_DAMAGE_BASIC
		set .interval_type = CONFIG_DAMAGE_SINGLE
		set .vector_type = CONFIG_DAMAGE_OUTTER
		set .target_type = CONFIG_DAMAGE_TARGET
		set .aoe_type 	= CONFIG_DAMAGE_AOE
		set .onhit_type = CONFIG_DAMAGE_ONHIT
		set .range_type = CONFIG_DAMAGE_RANGED
		call activate()
		return this
	endmethod

endstruct

private struct sanrengeki extends BossActor

	static constant real ANIM_SLOW = 0.2
	static constant real ANIM_VERY_SLOW = 0.1
	static constant real ANIM_FAST = 3.25
	static constant real EXP_DELAY_SLOW = 1.75
	static constant real EXP_DELAY_FAST = 1.25
	static constant real DURATION_SLOW = 2.0
	static constant real DURATION_FAST = 1.5
	static constant real RAD_SMALL = 150.
	static constant real RAD_LARGE = 225.

	integer count = 3
	boolean anim_play = false
	boolean anim_reset = false

	method play takes boolean fast returns nothing
		local ProgressiveEffect ps = 0
		if fast then
			call .caster.setAnim("attack")
			call .caster.setAnimSpeed(ANIM_SLOW)
			call .caster.queueAnim("stand ready")
			call SetUnitFacing(.caster.origin_unit,Math.anglePoints(.caster.x,.caster.y,.target.x,.target.y))
			set ps = ProgressiveCircle.create(.target.x,.target.y,0.,RAD_SMALL,EXP_DELAY_FAST)
			call rockexplosion.create(.caster,.target.x,.target.y,RAD_SMALL,EXP_DELAY_FAST,false)
		else
			call .caster.setAnim("attack")
			call .caster.setAnimSpeed(ANIM_VERY_SLOW)
			call .caster.queueAnim("stand ready")
			call SetUnitFacing(.caster.origin_unit,Math.anglePoints(.caster.x,.caster.y,.target.x,.target.y))
			set ps = ProgressiveCircle.create(.target.x,.target.y,0.,RAD_LARGE,EXP_DELAY_SLOW)
			call rockexplosion.create(.caster,.target.x,.target.y,RAD_LARGE,EXP_DELAY_SLOW,true)
		endif
		call ps.getEffect(0).setColor(192,0,0)
		call ps.getEffect(1).setColor(255,0,0)
	endmethod

	method killFilter takes nothing returns boolean
		set .count = .count - 1
		if .count <= 0 then
			return true
		elseif .count > 1 then
			set .duration = DURATION_FAST
			call play(true)
			set .anim_play = false
			set .anim_reset = false
			return false
		elseif .count == 1 then
			set .duration = DURATION_SLOW
			call play(false)
			set .anim_play = false
			set .anim_reset = false
			return false
		endif
		return true
	endmethod

	method periodicAction takes nothing returns nothing
		if .count > 1 then
			if not .anim_play then
				if .duration <= DURATION_FAST - EXP_DELAY_FAST + 0.18 then
					set .anim_play = true
					call .caster.setAnimSpeed(ANIM_FAST)
				endif
			endif
			if not .anim_reset then
				if .duration <= DURATION_FAST - EXP_DELAY_FAST then
					set .anim_reset = true
					call .caster.setAnimSpeed(1.0)
				endif
			endif
		elseif .count == 1 then
			if not .anim_play then
				if .duration <= DURATION_SLOW - EXP_DELAY_SLOW + 0.15 then
					set .anim_play = true
					call .caster.setAnimSpeed(ANIM_FAST)
				endif
			endif
			if not .anim_reset then
				if .duration <= DURATION_SLOW - EXP_DELAY_SLOW then
					set .anim_reset = true
					call .caster.setAnimSpeed(1.0)
				endif
			endif
		endif
	endmethod

	method onComplete takes nothing returns nothing
		call .caster.setAnimSpeed(1.0)
	endmethod

	static method create takes Boss caster, Unit target returns thistype
		local thistype this = allocate(caster,target,0,0,caster.level,DURATION_FAST,true)
		set .count = GetRandomInt(2,4)
		call play(true)
		return this
	endmethod

	method onDestroy takes nothing returns nothing
		call .caster.setAnimSpeed(1.0)
		call .caster.queueAnim("stand ready")
	endmethod

	static method onInit takes nothing returns nothing
		call DamageTag.add(ID1,CONFIG_ABILITY_TAG_EARTH)
	endmethod

endstruct