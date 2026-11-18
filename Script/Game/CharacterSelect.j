library CharacterSelect requires UnitData

	globals
		public integer array ID
		private boolean array READY

		private trigger MAIN_TRIGGER = null
		private triggercondition MAIN_COND = null
		private integer TIME = 60

		private framehandle BACKGROUND = null
		private framehandle FADE = null
	endglobals

	struct CharacterSelect extends array

		static method checkReadyState takes nothing returns boolean
			local integer i = 0
			loop
				exitwhen i >= CONFIG_PLAYER_MAX
				if not READY[i] then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		static method leavePlayer takes integer pid returns nothing
			set READY[pid] = true
			if checkReadyState() then
				call finish()
			endif
		endmethod

		/*페이드프레임 제거 콜백*/
		static method removeFade takes nothing returns nothing
			//! runtextmacro destroyFrame("FADE")
			call DestroyTrigger(GetTriggeringTrigger())
		endmethod

		/*REPLACE DESTROY()*/
		static method end takes nothing returns nothing
			local integer i = 0
			local trigger t = CreateTrigger()
			/* TODO Game 객체의 초기화 실행*/
			call Event.activate(ENUM_EVENT_CHARACTERSELECT_END)
			call DestroyTrigger(GetTriggeringTrigger())
			/* 페이드 프레임 제거 타이머 작동 */
			call TriggerRegisterTimerEvent(t,2.,false)
			call TriggerAddCondition(t,function thistype.removeFade)
			set t = null
		endmethod

		/*배경제거 콜백*/
		static method removeBackground takes nothing returns nothing
			static if not GAME_DEBUG then
				//! runtextmacro destroyFrame("BACKGROUND")
			endif
			call DestroyTrigger(GetTriggeringTrigger())
		endmethod

		/*선택 종료 시(페이드아웃이 종료된건 아님)*/
		static method finish takes nothing returns nothing
			local trigger t = CreateTrigger()
			/* 백그라운드 제거 타이머*/
			call TriggerRegisterTimerEvent(t,1.,false)
			call TriggerAddCondition(t,function thistype.removeBackground)
			/* 페이드 후 게임을 시작(end 콜백에 작성) */
			set t = CreateTrigger()
			call TriggerRegisterTimerEvent(t,2.,false)
			call TriggerAddCondition(t,function thistype.end)
			/* 페이드인 전용 프레임 생성(end 콜백에서 제거) */
			set FADE = BlzCreateFrameByType("SPRITE","",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),"",0)
			call BlzFrameSetModel(FADE,"ui\\characterselectfade.mdl",0)
			call BlzFrameSetAbsPoint(FADE,FRAMEPOINT_BOTTOMLEFT,0.,0.)
			call BlzFrameSetSize(FADE,1.,1.)
			set t = null
		endmethod

		static method init takes nothing returns nothing
			call finish()
		endmethod

		private static method onInit takes nothing returns nothing
			static if not GAME_DEBUG then
				set BACKGROUND = BlzCreateFrameByType("SPRITE","",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),"",0)
				call BlzFrameSetModel(BACKGROUND,"ui\\characterselectbackground.mdl",0)
				call BlzFrameSetAbsPoint(BACKGROUND,FRAMEPOINT_BOTTOMLEFT,0.,0.)
				call BlzFrameSetSize(BACKGROUND,1,1)
			endif
		endmethod

	endstruct

endlibrary