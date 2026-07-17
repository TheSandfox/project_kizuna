/*필드와 필드를 잇는 간이차원문(빠르게 이동할 수 있게)*/
private struct GasokuJump extends Charge

	static method create takes Unit u, real tx, real ty returns thistype
		local real v = Math.distancePoints(u.x,u.y,tx,ty)/0.75
		local real a = Math.anglePoints(u.x,u.y,tx,ty)
		//! runtextmacro chargeAllocate("u","v","a")
		set .duration = 0.75
		call AttatchedEffect.create("Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl",u).setDuration(1.75)
		call .owner.plusStatus(CONFIG_STATUS_GHOST)
		call .owner.issueImmediateOrder("stop")
		return this
	endmethod

	method onDestroy takes nothing returns nothing
		call .owner.minusStatus(CONFIG_STATUS_GHOST)
	endmethod

endstruct

private struct Gasoku extends NPC

	real tx = 0.
	real ty = 0.

	method onInteract takes Unit caster returns nothing
		local real a = Math.anglePoints(.x,.y,.tx,.ty)
		local real d = Math.distancePoints(.x,.y,.tx,.ty)
		local real ttx = Math.pPX(.x,d+175.,a)
		local real tty = Math.pPY(.y,d+175.,a)
		call GasokuJump.create(caster,ttx,tty)
	endmethod

	static method create takes real ox, real oy, real tx, real ty returns thistype
		local thistype this = allocate('NS06',ox,oy,1.5)
		call BlzSetUnitFacingEx(.origin_unit,Math.anglePoints(ox,oy,tx,ty))
		set .tx = tx
		set .ty = ty
		return this
	endmethod

endstruct