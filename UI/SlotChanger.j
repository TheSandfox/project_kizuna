library SlotChanger requires UI

	struct SlotChanger extends array

		boolean visible_flag
		
		integer state	/*0:기본상태, 1:임시변경중*/
		integer first_index
		Trigger keypress_trigger

		static integer array ABILITY_TEMP[10]
		static integer array MAP

		static framehandle array BUTTON[10]

		static framehandle CONTAINER = null
		static framehandle CONFIRM_BUTTON = null
		static framehandle CLOSE_BUTTON = null
		static boolean ACTIVATED = false
		private static trigger KEYPRESS = null

		method getMap takes integer index returns integer
			return MAP[this*10 + index]
		endmethod

		method setMap takes integer index, integer val returns nothing
			set MAP[this*10 + index] = val
		endmethod

		method operator owner takes nothing returns player
			return Player(this)
		endmethod

		method refresh takes nothing returns nothing
			local integer i = 0
			local framehandle f = null
			local framehandle bf = null
			local Ability a = 0
			/*위젯 리프레시*/
			set i = 0
			loop
				exitwhen i >= 10
				/*유닛어빌리티 가져오기*/
				set a = User.getFocusUnit(.owner).getAbility(getMap(i))
				/*아이콘 설정*/
				set f = BlzGetFrameByName("SlotChangerButtonIcon",i)
				if User.getFocusUnit(.owner) <= 0 or a <= 0 then
					if GetLocalPlayer() == Player(this) then
						call BlzFrameSetTexture(f,"Icons\\BTNBlackIcon.blp",0,true)
					endif
				else
					if GetLocalPlayer() == Player(this) then
						call BlzFrameSetTexture(f,Ability.getTypeIconPath(a.id),0,true)
					endif
				endif
				/*버튼프레임 상태 설정*/
				set f = BUTTON[i]
				/*시작지 버튼 프레임 출력*/
				if .state == 0 or .state == 2 then
					/*빈 어빌리티면 표시 안함*/
					if User.getFocusUnit(.owner) <= 0 or a <= 0 then
						if GetLocalPlayer() == Player(this) then
							call BlzFrameSetEnable(f,false)
							call BlzFrameSetText(BlzGetFrameByName("SlotChangerButtonText",i),"|cff999999"+User.OSKEY_INDEX_TO_STRING[i]+"|r")
						endif
					/*비어있지 않은 어빌리티의 위치에만 시작지 버튼 출력*/
					else
						if GetLocalPlayer() == Player(this) then
							call BlzFrameSetEnable(f,true)
							if .state == 0 then
								call BlzFrameSetText(BlzGetFrameByName("SlotChangerButtonText",i),"|cffffcc00"+User.OSKEY_INDEX_TO_STRING[i]+"|r")
							elseif .state == 2 then
								call BlzFrameSetText(BlzGetFrameByName("SlotChangerButtonText",i),"|cff00ccff"+User.OSKEY_INDEX_TO_STRING[i]+"|r")
							endif
						endif
					endif
				/*목적지 버튼 프레임 출력*/
				else
					if User.getFocusUnit(.owner) <= 0 then
						if GetLocalPlayer() == Player(this) then
							call BlzFrameSetEnable(f,false)
						endif
					/*어빌리티가 비어있어도 목적지 버튼 출력*/
					else
						set bf = BlzGetFrameByName("SlotChangerButtonText",i)
						if GetLocalPlayer() == Player(this) then
							call BlzFrameSetEnable(f,true)
							if i == .first_index then
								call BlzFrameSetText(bf,"|cffffff00"+User.OSKEY_INDEX_TO_STRING[i]+"|r")
							else
								call BlzFrameSetText(bf,"|cff00cc00"+User.OSKEY_INDEX_TO_STRING[i]+"|r")
							endif
						endif
					endif
				endif
				set i = i + 1
			endloop
			/*적용버튼 리프레시*/
			if .state == 0 or .state == 1 then
				set f = BlzGetFrameByName("SlotChangerConfirmButtonText",0)
				if GetLocalPlayer() == Player(this) then
					call BlzFrameSetText(f,"|cff999999적용|r")
					call BlzFrameSetEnable(CONFIRM_BUTTON,false)
				endif
			elseif .state == 2 then
				set f = BlzGetFrameByName("SlotChangerConfirmButtonText",0)
				if GetLocalPlayer() == Player(this) then
					call BlzFrameSetText(f,"|cff00ccff적용 (G)|r")
					call BlzFrameSetEnable(CONFIRM_BUTTON,true)
				endif
			endif
			set f = null
			set bf = null
		endmethod

		method stateEdited takes integer target_index returns nothing
			local integer i = getMap(.first_index)
			call setMap(.first_index,getMap(target_index))
			call setMap(target_index,i)
			set .state = 2
			call refresh()
		endmethod

		method stateSelectFirst takes integer first_index returns nothing
			set .first_index = first_index
			set .state = 1
			call refresh()
		endmethod

		method stateDefault takes nothing returns nothing
			local integer i = 0
			set .state = 0
			set .first_index = -1
			loop
				exitwhen i >= 10
				call setMap(i,i)
				set i = i + 1
			endloop
			call refresh()
		endmethod

		method visibleForPlayer takes boolean flag returns nothing
			if .visible_flag != flag then
				if flag then
					/*열림*/
					call stateDefault()
					if User.getFocusUnit(.owner) > 0 then
						call User.getFocusUnit(.owner).releaseAbilityAll()
					endif
					call EnableTrigger(.keypress_trigger.main_trigger)
					/*CLOSEUI*/
					call CloseUI(this).add(CloseUI.ORDER_SLOT_CHANGER)
				else
					/*닫힘*/
					call DisableTrigger(.keypress_trigger.main_trigger)
					/*CLOSEUI*/
					call CloseUI(this).eraseFor(CloseUI.ORDER_SLOT_CHANGER)
				endif
				call User.enableAbilityHotkey(.owner,not flag)
			endif
			if GetLocalPlayer() == Player(this) then
				call BlzFrameSetVisible(FRAME_SLOT_CHANGER,flag)
			endif
			set .visible_flag = flag
		endmethod

		method close takes nothing returns boolean
			if .visible_flag then
				call visibleForPlayer(false)
				return true
			else
				return false
			endif
		endmethod

		method confirm takes nothing returns nothing
			local integer i = 0
			local Unit u = User.getFocusUnit(.owner)
			if .state != 2 then
				return
			endif
			loop
				exitwhen i >= 10
				set ABILITY_TEMP[i] = u.getAbility(getMap(i))
				set i = i + 1
			endloop
			set i = 0
			loop
				exitwhen i >= 10
				call u.setAbility(i,ABILITY_TEMP[i])
				set i = i + 1
			endloop
			/**/set CUSTOM_RESPOND_UI_REFRESH_PLAYER = .owner
			/**/call Event.activate(CONFIG_EVENT_ABILITY_UI_REFRESH)
			/**/set CUSTOM_RESPOND_UI_REFRESH_PLAYER = null
			//call UI(GetPlayerId(.owner)).refreshAbilityIconsTarget()
			//call stateDefault()
		endmethod

		method switch takes nothing returns nothing
			call visibleForPlayer(not .visible_flag)
		endmethod

		method widgetPress takes integer i returns nothing
			if .state == 0 or .state == 2 then
				if User.getFocusUnit(.owner).getAbility(getMap(i)) <= 0 then
					return
				endif
				call stateSelectFirst(i)
				return
			elseif .state == 1 then
				/*TODO TEMPORARY CHANGE*/
				/*if .first_index == i then
					return
				endif*/
				call stateEdited(i)
				return
			endif
		endmethod

		static method act takes nothing returns nothing
			local thistype this = 0
			local player p = GetTriggerPlayer()
			local integer i = 0
			if Event.getValue() == CONFIG_EVENT_KEYPRESS then
				set this = GetPlayerId(CUSTOM_RESPOND_KEYPRESS_PLAYER)
				if CUSTOM_RESPOND_KEYPRESS_KEY == OSKEY_G and CUSTOM_RESPOND_KEYPRESS_PRESS then
					if .state == 2 and .visible_flag then
						call confirm()
					endif
					call switch()
					return
				endif
				return
			endif
			set this = GetPlayerId(p)
			if BlzGetTriggerFrame() != null then
				if GetLocalPlayer() == Player(this) then
					if BlzFrameGetEnable(BlzGetTriggerFrame()) then
						call BlzFrameSetEnable(BlzGetTriggerFrame(),false)
						call BlzFrameSetEnable(BlzGetTriggerFrame(),true)
					endif
				endif
				if BlzGetTriggerFrameEvent() != FRAMEEVENT_CONTROL_CLICK then
					return
				endif
				if BlzGetTriggerFrame() == CLOSE_BUTTON then
					call close()
					return
				endif
				if BlzGetTriggerFrame() == CONFIRM_BUTTON then
					call confirm()
					call close()
					return
				endif
				loop
					exitwhen i >= 10
					if BlzGetTriggerFrame() == BUTTON[i] then
						call widgetPress(i)
						return
					endif
					set i = i + 1
				endloop
				return
			endif
		endmethod

		static method keypressCallback takes nothing returns nothing
			local thistype this = Trigger.getData(GetTriggeringTrigger())
			if CUSTOM_RESPOND_KEYPRESS_PLAYER != .owner then
				return
			endif
			if User.oskey2Index(CUSTOM_RESPOND_KEYPRESS_KEY) <= CONFIG_ABILITY_SIZE and CUSTOM_RESPOND_KEYPRESS_PRESS then
				call widgetPress(User.oskey2Index(CUSTOM_RESPOND_KEYPRESS_KEY))
				return
			endif
			return
		endmethod

		static method initFrames takes nothing returns nothing
			local integer i = 0
			local framehandle f = null
			set CONTAINER = BlzCreateFrameByType("FRAME","",FRAME_SLOT_CHANGER,"",0)
			call BlzFrameSetPoint(CONTAINER,FRAMEPOINT_TOPLEFT,FRAME_SLOT_CHANGER,FRAMEPOINT_TOPLEFT,0.,0.)
			/**/
			loop
				exitwhen i >= 10
				/*버튼프레임*/
				set f = BlzCreateFrame("SlotChangerButton",CONTAINER,0,i)
				call BlzFrameSetAllPoints(f,FRAME_ABILITY_ICON[i])
				//call BlzFrameSetPointPixel(f,FRAMEPOINT_BOTTOMLEFT,LoadFrameHandle(UI.HASH,this,UI.INDEX_SLOT_CHANGER_ICON+i),FRAMEPOINT_BOTTOMLEFT,-4,-4/*Math.px2Size(16)*/)
				//call BlzFrameSetSize(f,Math.px2Size(48),Math.px2Size(48))
				call BlzTriggerRegisterFrameEvent(.KEYPRESS,f,FRAMEEVENT_CONTROL_CLICK)
				call BlzTriggerRegisterFrameEvent(.KEYPRESS,f,FRAMEEVENT_MOUSE_LEAVE)
				set BUTTON[i] = f
				/*버튼아이콘*/
				set f = BlzGetFrameByName("SlotChangerButtonIcon",i)
				call BlzFrameSetSizePixel(f,48,48)
				/*버튼텍스트백드롭*/
				set f = BlzGetFrameByName("SlotChangerButtonTextBackdrop",i)
				call BlzFrameSetSizePixel(f,20,20)
				//call BlzFrameSetAlpha(f,192)
				/*버튼텍스트*/
				set f = BlzGetFrameByName("SlotChangerButtonText",i)
				call BlzFrameSetText(f,"|cffffcc00"+User.OSKEY_INDEX_TO_STRING[i]+"|r")
				call BlzFrameSetTextAlignment(f,TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_CENTER)
				set i = i + 1
			endloop
			/*컨펌버튼*/
			set CONFIRM_BUTTON = BlzCreateFrame("SlotChangerConfirmButton",CONTAINER,0,0)
			call BlzFrameSetPoint(CONFIRM_BUTTON,FRAMEPOINT_TOP,FRAME_SLOT_CHANGER,FRAMEPOINT_TOP,0,-Math.px2Size(12))
			call BlzFrameSetSize(CONFIRM_BUTTON,Math.px2Size(192),Math.px2Size(48))
			call BlzTriggerRegisterFrameEvent(.KEYPRESS,CONFIRM_BUTTON,FRAMEEVENT_CONTROL_CLICK)
			call BlzTriggerRegisterFrameEvent(.KEYPRESS,CONFIRM_BUTTON,FRAMEEVENT_MOUSE_LEAVE)
			set f = BlzGetFrameByName("SlotChangerConfirmButtonText",0)
			call BlzFrameSetPoint(f,FRAMEPOINT_CENTER,CONFIRM_BUTTON,FRAMEPOINT_CENTER,0,0)
			call BlzFrameSetTextAlignment(f,TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_CENTER)
			call BlzFrameSetText(f,"|cff999999적용|r")
			call BlzFrameSetEnable(CONFIRM_BUTTON,false)
			/*닫기버튼*/
			set CLOSE_BUTTON = BlzCreateFrame("GenericCloseButton",CONTAINER,0,0)
			call BlzFrameSetPointPixel(CLOSE_BUTTON,FRAMEPOINT_TOPRIGHT,FRAME_SLOT_CHANGER,FRAMEPOINT_TOPRIGHT,-12,-12)
			call BlzTriggerRegisterFrameEvent(.KEYPRESS,CLOSE_BUTTON,FRAMEEVENT_CONTROL_CLICK)
			call BlzTriggerRegisterFrameEvent(.KEYPRESS,CLOSE_BUTTON,FRAMEEVENT_MOUSE_LEAVE)
			set f = null
		endmethod

		static method create takes player p returns thistype
			local thistype this = GetPlayerId(p)
			local framehandle f = null
			local integer i = 0
			set .state = 0
			set .first_index = -1
			set .visible_flag = false
			loop
				exitwhen i >= 10
				call setMap(i,i)
				set i = i + 1
			endloop
			/**/
			if not ACTIVATED then
				call initFrames()
				set ACTIVATED = true
			endif
			/*트리거*/
			set .keypress_trigger = Trigger.create(this)
			call .keypress_trigger.addCondition(function thistype.keypressCallback)
			call Event.register(.keypress_trigger.main_trigger,CONFIG_EVENT_KEYPRESS)
			call DisableTrigger(.keypress_trigger.main_trigger)
			/**/
			set f = null
			return this
		endmethod

		method destroy takes nothing returns nothing
			call .keypress_trigger.destroy()
		endmethod

		static method onInit takes nothing returns nothing
			set .KEYPRESS = CreateTrigger()
			call TriggerAddCondition(.KEYPRESS,function thistype.act)
			call Event.register(.KEYPRESS,CONFIG_EVENT_KEYPRESS)
		endmethod

	endstruct

endlibrary