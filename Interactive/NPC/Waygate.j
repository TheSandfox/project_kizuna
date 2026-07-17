library Waygate requires User

	globals
		private constant integer WIDGET_SIZE = 64
		private constant integer SIZE = 512
		private constant integer INSET = 96
		private constant integer OFFSET_Y = 96
		private trigger REMOVE_ACTOR = null
		private integer REMOVE_ACTOR_ID = -1
		private boolean CLOSE_FROM_FRAME = false
	endglobals

	private struct p_warp extends UnitActor

		static constant string EFFECT_PATH1 = "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTo.mdl"
		static constant string EFFECT_PATH2 = "Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl"

		Effect ef = 0
		boolean move = false

		method onComplete takes nothing returns nothing
			call .caster.warp(.x,.y)
			/*set .caster.x = .x
			set .caster.y = .y*/
			call Effect.create(EFFECT_PATH2,.caster.x,.caster.y,0.,270.).setDuration(2.)
			call .caster.issueImmediateOrder("stop")
			/*카메라이동*/
			if .move then
				if GetLocalPlayer() == .caster.owner then
					call PanCameraToTimed(.caster.x,.caster.y,0.)
				endif	
			endif
			/*핑*/
			if GetLocalPlayer() == .caster.owner then
				call PingMinimapEx(.caster.x,.caster.y,1.5,0,128,255,false)
			endif
		endmethod

		static method create takes Unit caster, real x, real y, boolean move returns thistype
			local thistype this = allocate(caster,0,x,y,0,3.,true)
			set .move = move
			set .suspend_rclick = true
			set .suspend_stop = true
			set .ef = Effect.create(EFFECT_PATH1,.caster.x,.caster.y,.0,270.)
			set .progress_bar = ProgressBar.create("차원문 이동",.caster.owner)
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			call .ef.kill()
		endmethod

	endstruct

	struct WarpWidget extends array

		static integer COUNTER = 0
		static framehandle CONTAINER = null
		static framehandle BACKDROP = null
		static framehandle CHECKBOX = null
		static framehandle CLOSE_BUTTON = null
		static boolean array VISIBLE
		static integer array CASTER
		static integer array ACTOR_ID
		static boolean array MOVE_CAMERA
		static trigger BTN_PRESS = null

		real x
		real y
		framehandle btn

		static method show takes player p, boolean flag returns nothing
			local integer i = 0
			local thistype this = 0
			if p == null or GetLocalPlayer() == p then
				call BlzFrameSetVisible(CONTAINER,flag)
			endif
			loop
				exitwhen i >= COUNTER
				set this = i
				if p == null or GetLocalPlayer() == p then
					call BlzFrameSetVisible(.btn,flag)
				endif
				set i = i + 1
			endloop
			set i = 0
			if VISIBLE[GetPlayerId(p)] != flag then
				if flag then
					/*열림*/
					call CloseUI(GetPlayerId(p)).add(CloseUI.ORDER_WARP)
					call User.enableAbilityHotkey(p,false)
				else
					/*닫힘*/
					call CloseUI(GetPlayerId(p)).eraseFor(CloseUI.ORDER_WARP)
					call User.enableAbilityHotkey(p,true)
				endif
			endif
			set VISIBLE[GetPlayerId(p)] = flag
			if not flag and IsTriggerEnabled(REMOVE_ACTOR) then
				/*제거시킬 ACTOR의 아이디를 기록*/
				set REMOVE_ACTOR_ID = ACTOR_ID[GetPlayerId(p)]
				/*ACTOR 제거 트리거 Evaluate*/
				call TriggerEvaluate(REMOVE_ACTOR)
			endif
		endmethod

		static method setMoveCameraButtonState takes player p, boolean flag returns nothing
			set MOVE_CAMERA[GetPlayerId(p)] = flag
			if flag then
				if GetLocalPlayer() == p then
					call BlzFrameSetText(BlzGetFrameByName("WarpMoveCameraToggleButtonText",0),"카메라 이동 : |cff00ff00활성화|r")
				endif
			else
				if GetLocalPlayer() == p then
					call BlzFrameSetText(BlzGetFrameByName("WarpMoveCameraToggleButtonText",0),"카메라 이동 : |cff999999비활성화|r")
				endif
			endif
		endmethod

		static method setCaster takes player p, Unit caster, integer actorinstance returns nothing
			if ACTOR_ID[GetPlayerId(p)] > 0 and actorinstance > 0 then
				set UnitActor(ACTOR_ID[GetPlayerId(p)]).suspend_rclick = true
			endif
			set CASTER[GetPlayerId(p)] = caster
			set ACTOR_ID[GetPlayerId(p)] = actorinstance
			call caster.releaseAbilityAll()
		endmethod

		static method press takes nothing returns nothing
			local thistype this = -1
			local integer i = 0
			/*리셋포커스*/
			if BlzGetTriggerFrameEvent() == FRAMEEVENT_CONTROL_CLICK then
				call DisableTrigger(GetTriggeringTrigger())
				if GetLocalPlayer() == GetTriggerPlayer() then
					call BlzFrameSetEnable(BlzGetTriggerFrame(),false)
					call BlzFrameSetEnable(BlzGetTriggerFrame(),true)
				endif
				call EnableTrigger(GetTriggeringTrigger())
			elseif BlzGetTriggerFrameEvent() == FRAMEEVENT_MOUSE_LEAVE then
				if GetLocalPlayer() == GetTriggerPlayer() then
					call BlzFrameSetEnable(BlzGetTriggerFrame(),false)
					call BlzFrameSetEnable(BlzGetTriggerFrame(),true)
				endif
			endif
			/*아래 액션들은 CLICK 일 때만 실행*/
			if BlzGetTriggerFrameEvent() != FRAMEEVENT_CONTROL_CLICK then
				return
			endif
			/*닫기버튼이면 닫고 리턴*/
			if BlzGetTriggerFrame() == CLOSE_BUTTON then
				call show(GetTriggerPlayer(),false)
				return
			endif
			/*체크박스면 카메라이동여부 바꾸고 리턴*/
			if BlzGetTriggerFrame() == CHECKBOX then
				call setMoveCameraButtonState(GetTriggerPlayer(),not MOVE_CAMERA[GetPlayerId(GetTriggerPlayer())])
				return
			endif
			/*위젯이 눌렸으면 어느 위젯인지*/
			loop
				exitwhen i >= COUNTER
				if thistype(i).btn == BlzGetTriggerFrame() then
					set this = i
					exitwhen true
				endif
				set i = i + 1
			endloop
			/*위젯이 안나왔으면 리턴*/
			if this < 0 then
				return
			endif
			/*누른 플레이어의 CASTER가 비어있으면 빠꾸*/
			if CASTER[GetPlayerId(GetTriggerPlayer())] < 1 then
				return
			endif
			/*'워프' 인스턴스 생성*/
			call p_warp.create(CASTER[GetPlayerId(GetTriggerPlayer())],.x,.y,MOVE_CAMERA[GetPlayerId(GetTriggerPlayer())])
			/*제거시킬 ACTOR의 아이디를 기록*/
			set REMOVE_ACTOR_ID = ACTOR_ID[GetPlayerId(GetTriggerPlayer())]
			/*ACTOR 제거 트리거 Evaluate*/
			call TriggerEvaluate(REMOVE_ACTOR)
			set CASTER[GetPlayerId(GetTriggerPlayer())] = -1
			set ACTOR_ID[GetPlayerId(GetTriggerPlayer())] = -1
			set REMOVE_ACTOR_ID = -1
		endmethod

		static method init takes nothing returns nothing
			local integer i = 0
			set CONTAINER = BlzCreateFrame("MBEdge",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_WINDOW],0,0)
			call BlzFrameSetPointPixel(CONTAINER,FRAMEPOINT_CENTER,FRAME_ORIGIN,FRAMEPOINT_CENTER,0.,OFFSET_Y)
			call BlzFrameSetSizePixel(CONTAINER,SIZE+INSET*2,SIZE+INSET*2)
			call BlzFrameSetVisible(CONTAINER,false)
			set BACKDROP = BlzCreateFrameByType("BACKDROP","",CONTAINER,"",0)
			call BlzFrameSetPointPixel(BACKDROP,FRAMEPOINT_TOP,CONTAINER,FRAMEPOINT_TOP,0,-INSET)
			call BlzFrameSetSizePixel(BACKDROP,SIZE,SIZE)
			call BlzFrameSetTexture(BACKDROP,"war3mapMap.blp",0,true)
			set CHECKBOX = BlzCreateFrame("WarpMoveCameraToggleButton",CONTAINER,0,0)
			call BlzFrameSetPointPixel(CHECKBOX,FRAMEPOINT_BOTTOMLEFT,CONTAINER,FRAMEPOINT_BOTTOMLEFT,16,16)
			call BlzFrameSetSizePixel(CHECKBOX,240,56)
			set CLOSE_BUTTON = BlzCreateFrame("GenericCloseButton",CONTAINER,0,0)
			call BlzFrameSetPointPixel(CLOSE_BUTTON,FRAMEPOINT_TOPRIGHT,CONTAINER,FRAMEPOINT_TOPRIGHT,-16,-16)
			loop
				exitwhen i >= CONFIG_PLAYER_MAX
				call setMoveCameraButtonState(Player(i),true)
				set i = i + 1
			endloop
			set BTN_PRESS = CreateTrigger()
			call BlzTriggerRegisterFrameEvent(BTN_PRESS,CHECKBOX,FRAMEEVENT_CONTROL_CLICK)
			call BlzTriggerRegisterFrameEvent(BTN_PRESS,CHECKBOX,FRAMEEVENT_MOUSE_LEAVE)
			call BlzTriggerRegisterFrameEvent(BTN_PRESS,CLOSE_BUTTON,FRAMEEVENT_CONTROL_CLICK)
			call BlzTriggerRegisterFrameEvent(BTN_PRESS,CLOSE_BUTTON,FRAMEEVENT_MOUSE_LEAVE)
			call TriggerAddCondition(BTN_PRESS,function thistype.press)
			call TriggerAddCondition(BTN_PRESS,function Frame.resetFocus)
		endmethod

		static method create takes real x, real y returns thistype
			local thistype this = COUNTER
			if COUNTER == 0 then
				call init()
			endif
			set .x = x
			set .y = y
			/*버튼프레임*/
			set .btn = BlzCreateFrame("WarpButton",BACKDROP,0,this)
			call BlzFrameSetPointPixel(.btn,FRAMEPOINT_CENTER,BACKDROP,FRAMEPOINT_BOTTOMLEFT,/*
				*/SIZE*((.x-CONFIG_MIN_X)/(CONFIG_MAX_X-CONFIG_MIN_X)),/*
				*/SIZE*((.y-CONFIG_MIN_Y)/(CONFIG_MAX_Y-CONFIG_MIN_Y))/*
			*/)
			call BlzFrameSetSizePixel(.btn,64,64)
			/*버튼아이콘*/
			call BlzFrameSetTexture(BlzGetFrameByName("WarpButtonIcon",this),"ReplaceableTextures\\CommandButtons\\BTNWaygate.blp",0,true)
			/*최초에는 숨김*/
			set VISIBLE[this] = false
			call show(Player(this),false)
			/*트리거*/
			//! runtextmacro triggerRegisterFrameEventSimple("BTN_PRESS",".btn")
			set COUNTER = COUNTER + 1
			return this
		endmethod

	endstruct

	public struct select_destination extends UnitActor

		static method respond takes nothing returns nothing
			local thistype this = REMOVE_ACTOR_ID
			if REMOVE_ACTOR_ID < 1 then
				return
			endif
			call destroy()
		endmethod

		static method create takes Unit caster returns thistype
			local thistype this = allocate(caster,0,0.,0.,0,-1,true)
			//set .suspend_rclick = true
			set .suspend_stop = true
			call WarpWidget.show(.caster.owner,true)
			call WarpWidget.setCaster(.caster.owner,.caster,this)
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			if not .suspend_rclick then
				call DisableTrigger(REMOVE_ACTOR)
				call WarpWidget.show(.caster.owner,false)
				call EnableTrigger(REMOVE_ACTOR)
				call WarpWidget.setCaster(.caster.owner,0,0)
				call .caster.issueImmediateOrder("stop")
			endif
		endmethod

		static method onInit takes nothing returns nothing
			set REMOVE_ACTOR = CreateTrigger()
			call TriggerAddCondition(REMOVE_ACTOR,function thistype.respond)
		endmethod

	endstruct

	struct Waygate extends NPC

		method onInteract takes Unit caster returns nothing
			call select_destination.create(caster)
			//call warp.create(caster,GetRectCenterX(.target_rect),GetRectCenterY(.target_rect),Math.anglePoints(.x,.y,GetRectCenterX(.target_rect),GetRectCenterY(.target_rect)))
		endmethod

		static method create takes real x, real y returns thistype
			local thistype this = allocate('NS03',x,y,2.25)
			set .level = 10
			call setAnim("Stand Alternate")
			return this
		endmethod

		static method init takes nothing returns nothing
			/*생명의 나무쪽 두개*/
			call create(GetRectCenterX(gg_rct_WaygateV1),GetRectCenterY(gg_rct_WaygateV1))
			call create(GetRectCenterX(gg_rct_WaygateV2),GetRectCenterY(gg_rct_WaygateV2))
			/*워프도착지*/
			call WarpWidget.create(GetRectCenterX(gg_rct_WarpV1),GetRectCenterY(gg_rct_WarpV1))
		endmethod

	endstruct

endlibrary