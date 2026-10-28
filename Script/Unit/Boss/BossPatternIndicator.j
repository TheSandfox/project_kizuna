struct BossPatternIndicator

	timer main_timer = null
	Effect outter = 0
	Effect inner = 0

	real x = 0.
	real y = 0.
	real progress = 0./*0.~1.0*/
	real radius = 0.
	real length = 0.
	real yaw = 0.

	real duration = 0.
	real duration_max = 1.
	real alpha = 0.25
	boolean auto_destroy = true
	boolean auto_progress = true

	integer state = 0
	integer type = 0

	method setProgress takes real v returns nothing
		set .progress = v
		if .progress > 1.0 then
			set .progress = 1.0
		elseif .progress < 0. then
			set .progress = 0.
		endif
		if .type == 0 then
			call .inner.setScale((.progress*.radius)/100.)
		elseif .type == 1 then
			set .outter.yaw = .yaw
			set .inner.yaw = .yaw
			call .outter.setPosition(Math.pPX(.x,-.radius,.yaw),Math.pPY(.y,-.radius,.yaw),1.)
			call .inner.setPosition(Math.pPX(.x,-.radius,.yaw),Math.pPY(.y,-.radius,.yaw),4.)
			call BlzSetSpecialEffectMatrixScale(.outter.origin_effect,(.length+.radius*2)/100.,.radius/50.,1.)
			call BlzSetSpecialEffectMatrixScale(.inner.origin_effect,(.length+.radius*2)/100.,.progress*.radius/50.,1.)
		endif
	endmethod

	static method timerCallback takes nothing returns nothing
		local thistype this = Timer.getData(GetExpiredTimer())
		if state == 0 then
			call .outter.setAlpha(R2I(92+255*(1.0-.duration/.duration_max)*2.0))
			call .inner.setAlpha(R2I(64+255*(1.0-.duration/.duration_max)*2.0))
			if .auto_progress then
				set .duration = .duration - TIMER_TICK
				call setProgress(1.0-(.duration/.duration_max))
			endif
			if .auto_destroy then
				if .duration <= 0. then
					set .state = 1
					set .duration = 0.5
					set .duration_max = 0.5
				endif
			endif
		else
			set .duration = .duration - TIMER_TICK
			call .outter.setAlpha(R2I(128*(.duration/.duration_max)))
			call .inner.setAlpha(R2I(128*(.duration/.duration_max)))
			if .duration <= 0. then
				call destroy()
			endif
		endif
	endmethod

	static method create takes real x, real y, real radius, real duration, string tstring returns thistype
		local thistype this = allocate()
		if duration <= 0. then
			set .duration_max = 1.0
			set .duration = 1.0
		else
			set .duration_max = duration
			set .duration = duration
		endif
		set .x = x
		set .y = y
		if tstring == "circle" then
			set .type = 0
		elseif tstring == "line" then
			set .type = 1
		else
			set .type = 0
		endif
		if .type == 0 then
			set .outter = Effect.create("Effects\\CastRangeCircle.mdl",x,y,1.0,0.)
			set .inner = Effect.create("Effects\\CastRangeCircle.mdl",x,y,4.0,0.)
			call .outter.setScale(radius/100.)
		elseif .type == 1 then
			set .outter = Effect.create("Effects\\RLine.mdl",x,y,1.0,0.)
			set .inner = Effect.create("Effects\\RLine.mdl",x,y,4.0,0.)
		endif
		call .outter.setColor(192,192,192)
		call .outter.setAlpha(R2I(0.75*255))
		call .inner.setColor(255,16,16)
		call .inner.setAlpha(R2I(0.25*255))
		set .radius = radius
		set .main_timer = Timer.new(this)
		call Timer.start(.main_timer,TIMER_TICK,true,function thistype.timerCallback)
		call setProgress(0.)
		return this
	endmethod

	method onDestroy takes nothing returns nothing
		call Timer.release(.main_timer)
		set .main_timer = null
		call .outter.destroy()
		call .inner.destroy()
	endmethod

endstruct

struct BossPatternLineIndicator extends BossPatternIndicator

	static method create takes real x, real y, real length, real angle, real radius, real duration returns thistype
		local thistype this = allocate(x,y,radius,duration,"line")
		set .yaw = angle
		set .length = length
		call setProgress(0.)
		return this
	endmethod

endstruct