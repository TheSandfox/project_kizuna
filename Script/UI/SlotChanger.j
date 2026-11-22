library SlotChanger requires UI

	struct SlotChanger extends array

		boolean visible_flag
		
		integer state	/*0:기본상태, 1:임시변경중*/
		integer first_index
		Trigger keypress_trigger

		static integer array ABILITY_TEMP[10]
		static integer array MAP

		static framehandle array BUTTON[10]
		private static integer P_BUTTON_GAP = 4
		private static integer P_BUTTON_SIZE = 64
		private static integer P_BUTTON_OFFSET_Y = 88//하단에서부터

		static framehandle CONFIRM_BUTTON = null
		static framehandle CONFIRM_BUTTON_TEXT = null
		static framehandle CLOSE_BUTTON = null
		static boolean ACTIVATED = false
		private static trigger P_KEYPRESS_CALLBACK = null
		private static trigger P_ICON_CLICK_CALLBACK = null

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
				set a = Ability(User.getFocusUnit(.owner).getAbility(getMap(i)))
				/*아이콘 설정*/
				set f = BlzGetFrameByName("CSlotChangerButtonIcon",i)
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
							call BlzFrameSetText(BlzGetFrameByName("CSlotChangerButtonHotkeyText",i),"|cff999999"+CONSTANT_ABILITY_HOTKEY_NAME[i]+"|r")
						endif
					/*비어있지 않은 어빌리티의 위치에만 시작지 버튼 출력*/
					else
						if GetLocalPlayer() == Player(this) then
							call BlzFrameSetEnable(f,true)
							if .state == 0 then
								call BlzFrameSetText(BlzGetFrameByName("CSlotChangerButtonHotkeyText",i),"|cffffcc00"+CONSTANT_ABILITY_HOTKEY_NAME[i]+"|r")
							elseif .state == 2 then
								call BlzFrameSetText(BlzGetFrameByName("CSlotChangerButtonHotkeyText",i),"|cff00ccff"+CONSTANT_ABILITY_HOTKEY_NAME[i]+"|r")
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
						set bf = BlzGetFrameByName("CSlotChangerButtonHotkeyText",i)
						if GetLocalPlayer() == Player(this) then
							call BlzFrameSetEnable(f,true)
							if i == .first_index then
								call BlzFrameSetText(bf,"|cffffff00"+CONSTANT_ABILITY_HOTKEY_NAME[i]+"|r")
							else
								call BlzFrameSetText(bf,"|cff00cc00"+CONSTANT_ABILITY_HOTKEY_NAME[i]+"|r")
							endif
						endif
					endif
				endif
				set i = i + 1
			endloop
			/*적용버튼 리프레시*/
			if .state == 0 or .state == 1 then
				set f = CONFIRM_BUTTON_TEXT
				if GetLocalPlayer() == Player(this) then
					call BlzFrameSetText(f,"|cff999999적용|r")
					call BlzFrameSetEnable(CONFIRM_BUTTON,false)
				endif
			elseif .state == 2 then
				set f = CONFIRM_BUTTON_TEXT
				if GetLocalPlayer() == Player(this) then
					call BlzFrameSetText(f,"|cff00ccff적용 ("+CONSTANT_HOTKEY_NAME[ENUM_HOTKEY_SLOT_CHANGER]+")|r")
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
						call Ability.releaseUnitAbilityAll(User.getFocusUnit(.owner))
					endif
					call EnableTrigger(.keypress_trigger.main_trigger)
					/*CLOSEUI*/
					call CloseUI(this).add(CloseUI.ORDER_SLOT_CHANGER)
					call User.addInputLayer(.owner,ENUM_INPUT_LAYER_SLOT_CHANGER)
				else
					/*닫힘*/
					call DisableTrigger(.keypress_trigger.main_trigger)
					/*CLOSEUI*/
					call CloseUI(this).eraseFor(CloseUI.ORDER_SLOT_CHANGER)
					call User.removeInputLayer(.owner,ENUM_INPUT_LAYER_SLOT_CHANGER)
				endif
				// call User.enableAbilityHotkey(.owner,not flag)
			endif
			if GetLocalPlayer() == Player(this) then
				call BlzFrameSetVisible(FRAME_SLOT_CHANGER,flag)
				call PlaySoundBJ(gg_snd_BigButtonClick)
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
			/**/call Event.activate(ENUM_EVENT_ABILITY_UI_REFRESH)
			/**/set CUSTOM_RESPOND_UI_REFRESH_PLAYER = null
			// call UI(GetPlayerId(.owner)).refreshAbilityIconsTarget()
			// call stateDefault()
		endmethod

		method switch takes nothing returns nothing
			call visibleForPlayer(not .visible_flag)
		endmethod

		method widgetPress takes integer i returns nothing
			if i < 0 then
				return
			endif
			if .state == 0 or .state == 2 then
				if User.getFocusUnit(.owner).getAbility(getMap(i)) <= 0 then
					return
				endif
				call stateSelectFirst(i)
				return
			elseif .state == 1 then
				/*TODO TEMPORARY CHANGE*/
				/* if .first_index == i then
					return
				endif */
				call stateEdited(i)
				return
			endif
		endmethod

		static method act takes nothing returns nothing
			local thistype this = 0
			local player p = GetTriggerPlayer()
			local integer i = 0
			if Event.getValue() == ENUM_EVENT_KEYPRESS then
				set this = GetPlayerId(CUSTOM_RESPOND_KEYPRESS_PLAYER)
				if CUSTOM_RESPOND_KEYPRESS_KEY == CONSTANT_HOTKEY_OSKEY[ENUM_HOTKEY_SLOT_CHANGER] and CUSTOM_RESPOND_KEYPRESS_PRESS then
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
				if BlzGetTriggerFrameEvent() != FRAMEEVENT_CONTROL_CLICK then
					return
				endif
				/* 버튼소리재생 */
				if GetLocalPlayer() == p then
          call PlaySoundBJ(gg_snd_BigButtonClick)
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
			local integer buttonsTotalWidth = P_BUTTON_SIZE * 10 + P_BUTTON_GAP * 9
			local integer buttonX = 0
			local integer buttonY = 0
			local framehandle f = null
			/**/
			loop
				exitwhen i >= CONFIG_ABILITY_SIZE
				/*버튼프레임*/
				set f = BlzCreateSimpleFrame("CSlotChangerButton",FRAME_SLOT_CHANGER,i)
				set buttonX = (-buttonsTotalWidth/2) + (P_BUTTON_SIZE*i) + (P_BUTTON_GAP*i)
				set buttonY = P_BUTTON_OFFSET_Y
				call BlzFrameSetPointPixel(f,FRAMEPOINT_TOPLEFT,FRAME_SLOT_CHANGER,FRAMEPOINT_BOTTOM,buttonX,buttonY+P_BUTTON_SIZE)
				call BlzFrameSetPointPixel(f,FRAMEPOINT_BOTTOMRIGHT,FRAME_SLOT_CHANGER,FRAMEPOINT_BOTTOM,buttonX+P_BUTTON_SIZE,buttonY)
				call BlzTriggerRegisterFrameEvent(P_KEYPRESS_CALLBACK,f,FRAMEEVENT_CONTROL_CLICK)
				set BUTTON[i] = f
				/*버튼텍스트*/
				set f = BlzGetFrameByName("CSlotChangerButtonHotkeyText",i)
				call BlzFrameSetText(f,"|cffffcc00"+CONSTANT_ABILITY_HOTKEY_NAME[i]+"|r")
				set i = i + 1
			endloop
			/*컨펌버튼*/
			set CONFIRM_BUTTON = BlzGetFrameByName("CSlotChangerConfirmButton",0)
			call BlzTriggerRegisterFrameEvent(P_KEYPRESS_CALLBACK,CONFIRM_BUTTON,FRAMEEVENT_CONTROL_CLICK)
			set CONFIRM_BUTTON_TEXT = BlzGetFrameByName("CSlotChangerConfirmButtonText",0)
			call BlzFrameSetText(CONFIRM_BUTTON_TEXT,"|cff999999적용|r")
			call BlzFrameSetEnable(CONFIRM_BUTTON,false)
			/*닫기버튼*/
			set CLOSE_BUTTON = BlzGetFrameByName("CSlotChangerCloseButton",0)
			call BlzTriggerRegisterFrameEvent(P_KEYPRESS_CALLBACK,CLOSE_BUTTON,FRAMEEVENT_CONTROL_CLICK)
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
			call Event.register(.keypress_trigger.main_trigger,ENUM_EVENT_KEYPRESS)
			call DisableTrigger(.keypress_trigger.main_trigger)
			/**/
			set f = null
			return this
		endmethod

		method destroy takes nothing returns nothing
			call .keypress_trigger.destroy()
		endmethod

		static method onInit takes nothing returns nothing
			/*키입력*/
			set P_KEYPRESS_CALLBACK = CreateTrigger()
			call TriggerAddCondition(P_KEYPRESS_CALLBACK,function thistype.act)
			call Event.register(P_KEYPRESS_CALLBACK,ENUM_EVENT_KEYPRESS)
			/*어빌아이콘 클릭*/
			// set P_ICON_CLICK_CALLBACK = CreateTrigger()
			// call TriggerAddCondition(P_ICON_CLICK_CALLBACK,function thistype.iconClickCallback)
			// call Event.register(P_ICON_CLICK_CALLBACK,ENUM_EVENT_ABILITY_ICON_CLICK)
		endmethod

	endstruct

endlibrary