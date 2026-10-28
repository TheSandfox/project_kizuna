/*체력바*/
private struct mybar extends BossUI

	static constant integer WIDTH = 480
	static constant integer FILL_WIDTH = 474
	static constant integer HEIGHT = 16
	static constant integer FILL_HEIGHT = 10

	framehandle hp_backdrop = null
	framehandle hp_fill = null
	real val = 1.0
	real val_prev = 1.0

	method refresh takes nothing returns nothing
		// call BJDebugMsg("흐음")
		set .val = .owner.hp/.owner.maxhp
		call BlzFrameSetVisible(.hp_fill,.val>=0.005)
		if .val < 1. then
			call BlzFrameSetSizePixel(.hp_fill,FILL_WIDTH*.val,FILL_HEIGHT)
		else
			call BlzFrameSetSizePixel(.hp_fill,FILL_WIDTH,FILL_HEIGHT)
		endif
		if .val_prev - .val >= 0.005 then
			call BarHPLoss.create(.hp_backdrop,.hp_fill,FILL_WIDTH*.val,FILL_WIDTH*(.val_prev-.val),FILL_HEIGHT)
		endif
		set .val_prev = .val
	endmethod

	static method create takes Boss caster returns thistype
		local thistype this = allocate(caster)
		set .hp_backdrop = BlzCreateFrameByType("BACKDROP","",.container,"",0)
		call BlzFrameSetPointPixel(.hp_backdrop,FRAMEPOINT_TOP,.name,FRAMEPOINT_BOTTOM,0,-8)
		call BlzFrameSetSizePixel(.hp_backdrop,WIDTH,HEIGHT)
		call BlzFrameSetTexture(.hp_backdrop,"replaceabletextures\\teamcolor\\teamcolor27.blp",0,true)
		set .hp_fill = BlzCreateFrameByType("BACKDROP","",.container,"",0)
		call BlzFrameSetPointPixel(.hp_fill,FRAMEPOINT_TOPLEFT,.hp_backdrop,FRAMEPOINT_TOPLEFT,(WIDTH-FILL_WIDTH)/2.,-(HEIGHT-FILL_HEIGHT)/2.)
		call BlzFrameSetSizePixel(.hp_fill,FILL_WIDTH,FILL_HEIGHT)
		call BlzFrameSetTexture(.hp_fill,"replaceabletextures\\teamcolor\\teamcolor06.blp",0,true)
		return this
	endmethod

	method onDestroy takes nothing returns nothing
		//! runtextmacro destroyFrame(".hp_fill")
		//! runtextmacro destroyFrame(".hp_backdrop")
	endmethod

endstruct