library NPC

	struct NPC extends NPC_prototype

		Effect ef = 0

		method operator level takes nothing returns integer
			return GetHeroLevel(.origin_unit)
		endmethod

		method operator level= takes integer v returns nothing
			call SetHeroLevel(.origin_unit,v,false)
		endmethod

		static method create takes integer uid, real x, real y, real efscale returns thistype
			local thistype this = allocate(uid,x,y,270.)
			set .ef = Effect.create("Effects\\FacingCircle.mdl",.x,.y,.z,270.)
			call .ef.setColor(255,255,0)
			call .ef.setScale(efscale)
			set .level = 99
			call BlzSetUnitBooleanFieldBJ(.origin_unit, UNIT_BF_HIDE_MINIMAP_DISPLAY, true)
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			call .ef.kill()
			set .ef = 0
		endmethod

	endstruct

endlibrary