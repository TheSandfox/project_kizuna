library Field requires Frame

	private struct myrespond extends array

		implement Respond

		static constant integer TYPE_SWITCH_INTERACT = 0
		static constant integer TYPE_FIELD_OPEN = 1

	endstruct

	struct Wall extends array

		private static integer ROWS = 8
		private static integer COLS = 8
		private static integer DID = 'LTrc'
		private static string WALL_PATH = "replaceabletextures\\teamcolor\\teamcolor24.blp"

		private static integer COUNT = 1

		framehandle icon
		integer state /*0:막힘, 1:개방*/
		real x
		real y
		Hash destructables
		integer counter
		integer s1
		integer s2

		method fill takes nothing returns nothing
			local integer i = 0
			local integer j = 0
			local destructable d = null
			local real px = .x-512
			local real py = .y+512
			loop
				exitwhen i >= COLS
				set j = 0
				loop
					exitwhen j >= ROWS
					set d = CreateDestructable(DID,px+i*128+64,py-j*128-64,GetRandomInt(1,360),1.0,GetRandomInt(0,10))
					call .destructables.setDestructable(.counter,d)
					set .counter = .counter + 1
					set j = j + 1
				endloop
				set i = i + 1
			endloop
			set .state = 0
			set d = null
		endmethod

		method clear takes nothing returns nothing
			local integer i = 0
			local destructable d = null
			if .state == 1 then
				return
			endif
			set .state = 1
			loop
				exitwhen i >= .counter
				set d = .destructables.getDestructable(i)
				call KillDestructable(d)
				set i = i + 1
			endloop
			call .destructables.deallocate()
			set .destructables = 0
			call BlzDestroyFrame(.icon)
			set .icon = null
			set d = null
		endmethod

		static method create takes rect r returns thistype
			local thistype this = .COUNT
			set .counter = 0
			set .state = 0
			set .x = GetRectCenterX(r)
			set .y = GetRectCenterY(r)
			set .destructables = Hash.allocate()
			set .icon = BlzCreateFrameByType("BACKDROP","",FRAME_MINIMAP,"",0)
			call BlzFrameSetPointPixel(.icon,FRAMEPOINT_CENTER,FRAME_MINIMAP,FRAMEPOINT_BOTTOMLEFT,/*
				*/CONFIG_MINIMAP_SIZE*(.x-CONFIG_MIN_X)/(CONFIG_MAX_X-CONFIG_MIN_X),/*
				*/CONFIG_MINIMAP_SIZE*(.y-CONFIG_MIN_Y)/(CONFIG_MAX_Y-CONFIG_MIN_Y)/*
			*/)
			call BlzFrameSetTexture(.icon,WALL_PATH,0,true)
			call BlzFrameSetSizePixel(.icon,12,12)
			call fill()
			set .COUNT = .COUNT + 1
			return this
		endmethod

	endstruct

	private struct WallSwitch_widget extends NPC

		integer switch_id

		method onInteract takes Unit caster returns nothing
			if myrespond.eval(myrespond.TYPE_SWITCH_INTERACT,.switch_id) then
				call myrespond.eval(myrespond.TYPE_FIELD_OPEN,.switch_id)
			endif
		endmethod

		static method create takes integer switch_id, real x, real y returns thistype
			local thistype this = allocate('NS04',x,y,1.5)
			set .switch_id = switch_id
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			call Effect.create("Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl",.x,.y,0.,270.).setDuration(2.5)
		endmethod

	endstruct

	//! import "Gasoku.j"

	private struct WallSwitch extends array

		private static integer COUNT = 1

		Wall wall
		boolean interact_enabled	/*false안보임 true보임*/
		WallSwitch_widget wd
		integer destination

		method activate takes nothing returns nothing
			if .wd > 0 then
				set .interact_enabled = true
				call BlzSetUnitSkin(.wd.origin_unit,'NS04')
				call SetUnitAnimation(.wd.origin_unit,"stand alternate")
			endif
		endmethod

		method deactivate takes nothing returns nothing
			set .interact_enabled = false
			if .wd > 0 then
				call BlzSetUnitSkin(.wd.origin_unit,'NS05')
			endif
		endmethod

		/*상호작용물체 숨김*/
		method destroyWidget takes nothing returns nothing
			set .interact_enabled = false
			call .wd.destroy()
			set .wd = 0
		endmethod

		/*스위치열기*/
		method open takes nothing returns nothing
			local thistype t1 = thistype(.wall.s1)
			local thistype t2 = thistype(.wall.s2)
			local lightning l = null
			/*벽 허물기*/
			call .wall.clear()
			/*가속발판 설치*/
			call Gasoku.create(t1.wd.x,t1.wd.y,t2.wd.x,t2.wd.y)
			call Gasoku.create(t2.wd.x,t2.wd.y,t1.wd.x,t1.wd.y)
			set l = AddLightningEx("DRAM", true, t1.wd.x,t1.wd.y, 105., t2.wd.x,t2.wd.y, 105.)
			call SetLightningColor(l,1,1,1,0.5)
			set l = AddLightningEx("DRAM", true, t2.wd.x,t2.wd.y, 105., t1.wd.x,t1.wd.y, 105.)
			call SetLightningColor(l,1,1,1,0.5)
			/*상호작용숨김*/
			call t1.destroyWidget()
			call t2.destroyWidget()
			set l = null
		endmethod

		static method create takes integer field_id, Wall w, real x, real y returns thistype
			local thistype this = .COUNT
			set .destination = field_id
			set .interact_enabled = true
			set .wall = w
			set .wd = WallSwitch_widget.create(this,x,y)
			call deactivate()
			set .COUNT = .COUNT + 1
			return this
		endmethod

		static method interactCallback takes nothing returns nothing
			local thistype this = 0
			if myrespond.RESPOND_TYPE != myrespond.TYPE_SWITCH_INTERACT then
				return
			endif
			set this = myrespond.RESPOND_VALUE
			if not .interact_enabled then
				set myrespond.RESPOND_RESULT = false
				return
			endif
			call open()
			set myrespond.RESPOND_RESULT = true
		endmethod

		static method onInit takes nothing returns nothing
			call TriggerAddCondition(myrespond.RESPOND,function thistype.interactCallback)
		endmethod

	endstruct
	
	struct Field extends array

		private static Hash HASH_WALL = 0
		private static Hash HASH_POSITION = 0
		private static integer COUNT = 1
		private static string LOCK_PATH = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"
		
		Hash hash_w
		Hash hash_p
		Array switches
		real x
		real y
		integer position_x
		integer position_y
		integer state/*0미개방 1개방 2개방불가*/
		framehandle icon

		/*무작위 시작 워프필드*/
		static method getRandomWaygateField takes nothing returns thistype
			local integer i = GetRandomInt(1,4)
			if i == 1 then
				return 10//3
			elseif i == 2 then
				return 10
			elseif i == 3 then
				return 10//11
			elseif i == 4 then
				return 10//18
			endif
			return 2
		endmethod

		static method getWall takes thistype f1, thistype f2 returns Wall
			return Hash(HASH_WALL.getInteger(f1)).getInteger(f2)
		endmethod

		static method getByPosition takes integer px, integer py returns thistype
			if px < 0 or py < 0 then
				return 0
			endif
			return Hash(HASH_POSITION.getInteger(px)).getInteger(py)
		endmethod

		private method positionRegister takes nothing returns nothing
			if HASH_POSITION.getInteger(.position_x) <= 0 then
				call HASH_POSITION.setInteger(.position_x,Hash.allocate())
			endif
			if Hash(HASH_POSITION.getInteger(.position_x)).getInteger(.position_y) <= 0 then
				call Hash(HASH_POSITION.getInteger(.position_x)).setInteger(.position_y,this)
			endif
		endmethod

		static method link takes thistype f1, thistype f2, Wall w returns nothing
			local real a = Math.anglePoints(w.x,w.y,f1.x,f1.y)
			local WallSwitch ws = WallSwitch.create(f2,w,Math.pPX(w.x,640,a),Math.pPY(w.y,640,a))
			call Hash(HASH_WALL.getInteger(f1)).setInteger(f2,w)
			call Hash(HASH_WALL.getInteger(f2)).setInteger(f1,w)
			call f1.switches.add(ws)
			set a = Math.anglePoints(w.x,w.y,f2.x,f2.y)
			set w.s1 = ws
			set ws = WallSwitch.create(f1,w,Math.pPX(w.x,640,a),Math.pPY(w.y,640,a))
			call f2.switches.add(ws)
			set w.s2 = ws
			// call AddLightningEx("CLPB", true, f1.x, f1.y, 0., f2.x, f2.y, 0.)
		endmethod

		method setState takes integer val returns nothing
			if .state != val then
				if val == 0 then
					/*잠김*/
					if .icon == null then
						set .icon = BlzCreateFrameByType("BACKDROP","",FRAME_MINIMAP,"",0)
					endif
					call BlzFrameSetPointPixel(.icon,FRAMEPOINT_CENTER,FRAME_MINIMAP,FRAMEPOINT_BOTTOMLEFT,/*
						*/CONFIG_MINIMAP_SIZE*(.x-CONFIG_MIN_X)/(CONFIG_MAX_X-CONFIG_MIN_X),/*
						*/CONFIG_MINIMAP_SIZE*(.y-CONFIG_MIN_Y)/(CONFIG_MAX_Y-CONFIG_MIN_Y)/*
					*/)
					call BlzFrameSetTexture(.icon,LOCK_PATH,0,true)
					call BlzFrameSetSizePixel(.icon,32,32)
					call BlzFrameSetAlpha(.icon,200)
				elseif val == 1 then
					if .icon != null then
						call BlzDestroyFrame(.icon)
					endif
					set .icon = null
				endif
			endif
			set .state = val
		endmethod

		private method open takes nothing returns nothing
			local integer i = 0
			local thistype af = 0
			local Wall w = 0
			/*내 구역의 스위치들을 활성화*/
			loop
				exitwhen i >= .switches.size
				call WallSwitch(.switches.getValue(i)).activate()
				set i = i + 1
			endloop
			/*인접한 필드중에 이미 열린 필드가 있으면*/
			/*사이의 벽 제거*/
			/*우*/
			//! textmacro Field_Field_open takes xval, yval
			set af = getByPosition(.position_x$xval$,.position_y$yval$)
			// call BJDebugMsg(I2S(af)+"( "+I2S(R2I(.position_x$xval$))+"," +I2S(R2I(.position_y$yval$))+")")
			if af > 0 then
				set w = getWall(this,af)
				if w > 0 and af.state == 1 then
					if w.state == 0 then
						call WallSwitch(w.s1).open()
					endif
				endif
			endif
			//! endtextmacro
			// call BJDebugMsg("//")
			// call BJDebugMsg("( "+I2S(R2I(.position_x))+"," +I2S(R2I(.position_y))+")")
			//! runtextmacro Field_Field_open("+1","+0")
			//! runtextmacro Field_Field_open("+0","-1")
			//! runtextmacro Field_Field_open("-1","+0")
			//! runtextmacro Field_Field_open("+0","+1")
			// call BJDebugMsg("//")
			/**/
			call setState(1)
		endmethod

		method openWithWaygate takes nothing returns nothing
			call open()
			call Waygate.create(.x,.y)
			call WarpWidget.create(.x,.y)
		endmethod

		static method create takes rect r, integer px, integer py returns thistype
			local thistype this = .COUNT
			set .x = GetRectCenterX(r)
			set .y = GetRectCenterY(r)
			set .position_x = px
			set .position_y = py
			set .switches = Array.create()
			set .hash_w = Hash.allocate()
			set .hash_p = Hash.allocate()
			set .icon = null
			set .state = -1
			call setState(0)
			call HASH_WALL.setInteger(this,.hash_w)
			call positionRegister()
			set .COUNT = .COUNT + 1
			return this
		endmethod

		static method openCallback takes nothing returns nothing
			local WallSwitch ws = 0
			local thistype this = 0
			if myrespond.RESPOND_TYPE != myrespond.TYPE_FIELD_OPEN then
				return
			endif
			set ws = myrespond.RESPOND_VALUE
			set this = ws.destination
			call open()
			set myrespond.RESPOND_RESULT = true
		endmethod

		static method onInit takes nothing returns nothing
			call TriggerAddCondition(myrespond.RESPOND,function thistype.openCallback)
		endmethod

		/*external call*/
		static method init takes nothing returns nothing
			local integer i = 1
			set .HASH_WALL = Hash.allocate()
			set .HASH_POSITION = Hash.allocate()
			/*일단 필드 생성*/
			call create(gg_rct_Warp001,0,0)
			call create(gg_rct_Warp002,1,0)
			call create(gg_rct_Warp003,2,0)
			call create(gg_rct_Warp004,3,0)
			call create(gg_rct_Warp005,4,0)
			call create(gg_rct_Warp006,0,1)
			call create(gg_rct_Warp007,1,1)
			call create(gg_rct_Warp008,3,1)
			call create(gg_rct_Warp009,4,1)
			call create(gg_rct_Warp010,0,2)
			call create(gg_rct_Warp011,4,2)
			call create(gg_rct_Warp012,0,3)
			call create(gg_rct_Warp013,1,3)
			call create(gg_rct_Warp014,3,3)
			call create(gg_rct_Warp015,4,3)
			call create(gg_rct_Warp016,0,4)
			call create(gg_rct_Warp017,1,4)
			call create(gg_rct_Warp018,2,4)
			call create(gg_rct_Warp019,3,4)
			call create(gg_rct_Warp020,4,4)
			/*이후에 벽 수동링크*/
			call link(1,2,Wall.create(gg_rct_Wall001))
			call link(2,3,Wall.create(gg_rct_Wall002))
			call link(3,4,Wall.create(gg_rct_Wall003))
			call link(4,5,Wall.create(gg_rct_Wall004))
			//
			call link(1,6,Wall.create(gg_rct_Wall005))
			call link(2,7,Wall.create(gg_rct_Wall006))
			call link(4,8,Wall.create(gg_rct_Wall007))
			call link(5,9,Wall.create(gg_rct_Wall008))
			//
			call link(6,7,Wall.create(gg_rct_Wall009))
			call link(8,9,Wall.create(gg_rct_Wall010))
			call link(6,10,Wall.create(gg_rct_Wall011))
			call link(9,11,Wall.create(gg_rct_Wall012))
			//
			call link(10,12,Wall.create(gg_rct_Wall013))
			call link(11,15,Wall.create(gg_rct_Wall014))
			call link(12,13,Wall.create(gg_rct_Wall015))
			call link(14,15,Wall.create(gg_rct_Wall016))
			//
			call link(12,16,Wall.create(gg_rct_Wall017))
			call link(13,17,Wall.create(gg_rct_Wall018))
			call link(14,19,Wall.create(gg_rct_Wall019))
			call link(15,20,Wall.create(gg_rct_Wall020))
			//
			call link(16,17,Wall.create(gg_rct_Wall021))
			call link(17,18,Wall.create(gg_rct_Wall022))
			call link(18,19,Wall.create(gg_rct_Wall023))
			call link(19,20,Wall.create(gg_rct_Wall024))
		endmethod

	endstruct
	

endlibrary

//! import "Navigator.j"