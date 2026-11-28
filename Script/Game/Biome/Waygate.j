library Waygate requires User

	globals
		private trigger REMOVE_ACTOR = null
		private integer REMOVE_ACTOR_ID = -1
		private boolean CLOSE_FROM_FRAME = false

		private integer P_MINIMAP_SIZE = 512
		private trigger P_END_FREEZE_CALLBACK = null
		private player P_END_FREEZE_CALLBACK_PLAYER = null
		private integer array P_FREEZE_ACTOR
		private framehandle P_WIDGET_CONTAINER = null
	endglobals

struct WarpWarp extends UnitActor

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
			set .suspend_ability = true
			set .ef = Effect.create(EFFECT_PATH1,.caster.x,.caster.y,.0,270.)
			set .progress_bar = ProgressBar.create("차원문 이동",.caster.owner)
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			call .ef.kill()
		endmethod

	endstruct

	struct WarpFreeze extends UnitActor

		static method create takes Unit caster returns thistype
			local thistype this = allocate(caster,0,0.,0.,0,-1,true)
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			set P_END_FREEZE_CALLBACK_PLAYER = .caster.owner
			call .caster.issueImmediateOrder("stop")
			call TriggerEvaluate(P_END_FREEZE_CALLBACK)
		endmethod

	endstruct

	struct WarpDestination extends array

		static integer S_COUNTER = 0
		static integer S_ICON_SIZE = 40
		
		framehandle btn /*버튼프레임*/
		real x /*목적지좌표*/
		real y /*목적지좌표*/
		trigger press_trigger

		method getFreezeActor takes player p returns UnitActor
			return P_FREEZE_ACTOR[GetPlayerId(p)]
		endmethod

		static method pressCallback takes nothing returns nothing
			local thistype this = Trigger.getData(GetTriggeringTrigger())
			local UnitActor freeze_actor = getFreezeActor(GetTriggerPlayer())
			local Unit caster
			if freeze_actor > 0 then
				set caster = freeze_actor.caster
				call freeze_actor.destroy()
				call WarpWarp.create(caster,.x,.y,true)
			endif
		endmethod

		method initFrames takes nothing returns nothing
			local framehandle f = null
			local real newX = (R2I(((.x - CONFIG_MIN_X) / (CONFIG_MAX_X - CONFIG_MIN_X))*5)+0.5)/5.0
			local real newY = (R2I(((.y - CONFIG_MIN_Y) / (CONFIG_MAX_Y - CONFIG_MIN_Y))*5)+0.5)/5.0
			/**/
			set .btn = BlzCreateSimpleFrame("CWarpUIWidget",P_WIDGET_CONTAINER,this)
			call BlzFrameSetPointPixel(.btn,FRAMEPOINT_TOPLEFT,FRAME_WARP_UI_MINIMAP,FRAMEPOINT_BOTTOMLEFT,/*
				*/(-S_ICON_SIZE/2)+P_MINIMAP_SIZE*newX,/*
				*/(-S_ICON_SIZE/2)+S_ICON_SIZE+P_MINIMAP_SIZE*newY/*
			*/)
			call BlzFrameSetPointPixel(.btn,FRAMEPOINT_BOTTOMRIGHT,FRAME_WARP_UI_MINIMAP,FRAMEPOINT_BOTTOMLEFT,/*
				*/(-S_ICON_SIZE/2)+S_ICON_SIZE+P_MINIMAP_SIZE*newX,/*
				*/(-S_ICON_SIZE/2)+P_MINIMAP_SIZE*newY/*
			*/)
			/**/
			call BlzTriggerRegisterFrameEvent(.press_trigger,.btn,FRAMEEVENT_CONTROL_CLICK)
			call TriggerAddCondition(.press_trigger,function thistype.pressCallback)
			/**/
			set f = null
		endmethod

		static method create takes real x, real y returns thistype
			local thistype this = S_COUNTER
			set .x = x
			set .y = y
			set .press_trigger = Trigger.new(this)
			call initFrames()
			set S_COUNTER = S_COUNTER + 1
			return this
		endmethod

		method destroy takes nothing returns nothing
			call BlzDestroyFrame(.btn)
			set .btn = null
			call Trigger.remove(.press_trigger)
			set .press_trigger = null
		endmethod

	endstruct

	struct WarpUI extends array

		private static boolean S_INIT_FRAME = false
		private static framehandle S_BTN_CLOSE = null

		boolean visible_flag
		
		method operator owner takes nothing returns player
			return Player(this)
		endmethod

		method operator freeze_actor takes nothing returns UnitActor
			return UnitActor(P_FREEZE_ACTOR[this])
		endmethod

		method operator freeze_actor= takes UnitActor act returns nothing
			set P_FREEZE_ACTOR[this] = act
		endmethod
		
		method visibleForPlayer takes boolean flag returns nothing
			if .visible_flag != flag then
				if flag then
					if User.getCurrentInputLayer(.owner) <= CONFIG_INPUT_LAYER_WARP_UI then
						/*열림*/
						call CloseUI(this).add(CloseUI.ORDER_WARP)
						call User.addInputLayer(.owner,CONFIG_INPUT_LAYER_WARP_UI)
					else
						return
					endif
				else
					/*닫힘*/
					call CloseUI(this).eraseFor(CloseUI.ORDER_WARP)
					call User.removeInputLayer(.owner,CONFIG_INPUT_LAYER_WARP_UI)
					if .freeze_actor > 0 then
						call DisableTrigger(P_END_FREEZE_CALLBACK)
						call .freeze_actor.destroy()
						set .freeze_actor = 0
						call EnableTrigger(P_END_FREEZE_CALLBACK)
					endif
				endif
			endif
			set .visible_flag = flag
			if GetLocalPlayer() == Player(this) then
				call BlzFrameSetVisible(FRAME_WARP_UI,flag)
				call PlaySoundBJ(gg_snd_BigButtonClick)
			endif
		endmethod

		method open takes Unit caster returns nothing
			/*이미 차원문을 연 유닛이 있으면 중단(플레이어별)*/
			if .freeze_actor > 0 then
				return
			endif
			/*부활 가능한 유닛만 열 수 있음*/
			if not caster.is_revive then
				return
			endif
			call visibleForPlayer(true)
			set .freeze_actor = WarpFreeze.create(caster)
		endmethod

		method close takes nothing returns boolean
			if .visible_flag then
				call visibleForPlayer(false)
				return true
			else
				return false
			endif
		endmethod

		static method buttonCallback takes nothing returns nothing
			local thistype this = GetPlayerId(GetTriggerPlayer())
			if .freeze_actor > 0 then
				call .freeze_actor.destroy()
				set .freeze_actor = 0
			else
				call visibleForPlayer(false)
			endif
		endmethod

		static method initFrames takes nothing returns nothing
			local trigger t = CreateTrigger()
			/*닫기버튼*/
			set S_BTN_CLOSE = BlzGetFrameByName("CWarpUICloseButton",0)
			call BlzTriggerRegisterFrameEvent(t,S_BTN_CLOSE,FRAMEEVENT_CONTROL_CLICK)
			call TriggerAddCondition(t,function thistype.buttonCallback)
			/*위젯컨테이너 배치*/
			set P_WIDGET_CONTAINER = BlzGetFrameByName("CWarpUIWidgetContainer",0)
			call BlzFrameSetPoint(P_WIDGET_CONTAINER,FRAMEPOINT_TOPLEFT,FRAME_WARP_UI_MINIMAP,FRAMEPOINT_TOPLEFT,0.0,0.0)
			call BlzFrameSetPoint(P_WIDGET_CONTAINER,FRAMEPOINT_BOTTOMRIGHT,FRAME_WARP_UI_MINIMAP,FRAMEPOINT_BOTTOMRIGHT,0.0,0.0)
			/*미니맵 사이즈 조정*/
			call BlzFrameSetPointPixel(FRAME_WARP_UI_MINIMAP,FRAMEPOINT_TOPLEFT,FRAME_WARP_UI,FRAMEPOINT_CENTER,-P_MINIMAP_SIZE/2,P_MINIMAP_SIZE/2)
			call BlzFrameSetPointPixel(FRAME_WARP_UI_MINIMAP,FRAMEPOINT_BOTTOMRIGHT,FRAME_WARP_UI,FRAMEPOINT_CENTER,P_MINIMAP_SIZE/2,-P_MINIMAP_SIZE/2)
			/**/
			set t = null
		endmethod

		static method create takes player p returns thistype
			local thistype this = GetPlayerId(p)
			set .visible_flag = false
			set .freeze_actor = 0
			if not S_INIT_FRAME then
				call initFrames()
				set S_INIT_FRAME = true
			endif
			return this
		endmethod

		static method endFreezeCallback takes nothing returns nothing
			local thistype this = GetPlayerId(P_END_FREEZE_CALLBACK_PLAYER)
			if not IsTriggerEnabled(P_END_FREEZE_CALLBACK) then
				return
			endif
			set .freeze_actor = 0
			call visibleForPlayer(false)
		endmethod

		static method onInit takes nothing returns nothing
			/*얼리기 행위자 소멸 시*/
			set P_END_FREEZE_CALLBACK = CreateTrigger()
			call TriggerAddCondition(P_END_FREEZE_CALLBACK,function thistype.endFreezeCallback)
		endmethod

	endstruct

	struct Waygate extends NPC

		method onInteract takes Unit caster returns nothing
			if User.getCurrentInputLayer(caster.owner) <= CONFIG_INPUT_LAYER_WARP_UI then
				call WarpUI(GetPlayerId(caster.owner)).open(caster)
			endif
			//call warp.create(caster,GetRectCenterX(.target_rect),GetRectCenterY(.target_rect),Math.anglePoints(.x,.y,GetRectCenterX(.target_rect),GetRectCenterY(.target_rect)))
		endmethod

		static method create takes real x, real y returns thistype
			local thistype this = allocate('NS03',x,y,1.25)
			// set .level = 10
			call setAnim("Stand Alternate")
			return this
		endmethod

		static method init takes nothing returns nothing

		endmethod

	endstruct

endlibrary