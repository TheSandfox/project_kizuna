library PowerupUI requires UI, Ability, Unit, PowerupManager

	globals
		private framehandle P_WIDGET_CONTAINER
		private constant integer P_WIDGET_COUNT = 5
		private constant integer P_WIDGET_GAP = 20
		private constant integer P_WIDGET_ICON_SIZE = 96
		private constant integer P_WIDGET_CONTAINER_OFFSET_Y = -160 //컨테이너 상단으로부터
		private constant integer P_WIDGET_CONTAINER_WIDTH = 940
		private constant integer P_WIDGET_CONTAINER_HEIGHT = 368
		private trigger P_UI_CALLBACK
		private trigger P_WIDGET_CALLBACK
	endglobals

	struct PowerupItemWidget extends array


		player owner /*어느 플레이어에게 보여지고있는가*/
		integer index /*몇 번쨰 칸인지*/
		PowerupItem target /*겜끝날때까지 안변함*/

		static boolean array P_FRAME_CREATED
		static framehandle array P_WIDGET
		static framehandle array P_ICON
		static framehandle array P_BTN
		static framehandle array P_TYPE_LABEL
		static framehandle array P_TYPE_LABEL_TEXT
		static framehandle array P_TITLE
		static framehandle array P_DESC

		/*UI 새로고침*/
		method refresh takes nothing returns nothing
			local string s = ""
			local integer p_item_type = target.getType()
			local integer p_item_value = target.getValue()
			if GetLocalPlayer() == .owner then
				if p_item_type > -1 then /*비어있지 않은 슬롯*/
					/*라벨*/
					call BlzFrameSetVisible(P_TYPE_LABEL[.index],true)
					call BlzFrameSetText(P_TYPE_LABEL_TEXT[.index],UDG_POWERUP_ITEM_TYPE_COLOR[p_item_type]+UDG_POWERUP_ITEM_TYPE_NAME[p_item_type]+"|r")
					/*아이콘*/
					call BlzFrameSetVisible(P_ICON[.index],true)
					/*스킬획득*/
					if p_item_type == ENUM_POWERUP_ITEM_TYPE_ABILITY then
						/*아이콘*/
						call BlzFrameSetTexture(P_ICON[.index],Ability.getTypeIconPath(p_item_value),0,true)
						/*타이틀*/
						call BlzFrameSetText(P_TITLE[.index],Ability.getTypeName(p_item_value))
						/*설명*/
						call BlzFrameSetText(P_DESC[.index],Ability.getTypeTooltip(p_item_value))
						/*스탯증강*/
					elseif p_item_type == ENUM_POWERUP_ITEM_TYPE_STAT then
						/*아이콘*/
						call BlzFrameSetTexture(P_ICON[.index],UDG_STAT_ICON[p_item_value],0,true)
						/*타이틀*/
						call BlzFrameSetText(P_TITLE[.index],/*
							*/UDG_STAT_COLOR[p_item_value]+UDG_STAT_NAME[p_item_value]+"|r |cffffff00+"+I2S(R2I(CONFIG_POWERUP_STAT_AMOUNT*UDG_STAT_NORMAL_VALUE[p_item_value]))+"|r"/*
						*/)
						/*설명*/
						call BlzFrameSetText(P_DESC[.index],UDG_STAT_DESC[p_item_value])
					endif
					/*타이틀표시*/
					call BlzFrameSetVisible(P_TITLE[.index],true)
					/*설명표시*/
					call BlzFrameSetVisible(P_DESC[.index],true)
					/*버튼활성화*/
					call BlzFrameSetVisible(P_BTN[.index],true)
				else /*빈 슬롯*/
					/*라벨*/
					call BlzFrameSetVisible(P_TYPE_LABEL[.index],false)
					/*아이콘 숨기기*/
					call BlzFrameSetVisible(P_ICON[.index],false)
					/*버튼비활성화*/
					call BlzFrameSetVisible(P_BTN[.index],false)
					/*타이틀숨기기*/
					call BlzFrameSetVisible(P_TITLE[.index],false)
					/*설명숨기기*/
					call BlzFrameSetVisible(P_DESC[.index],false)
				endif
			endif
		endmethod

		static method press takes nothing returns nothing
			local thistype this = 0
			local integer j = 0
			local Ability i = 0
			local PowerupManager p_manager = 0
			/*어떤 버튼이 눌렸는지*/
			loop
				exitwhen j >= P_WIDGET_COUNT
				exitwhen BlzGetTriggerFrame() == P_BTN[j]
				set j = j + 1
			endloop
			set this = GetPlayerId(GetTriggerPlayer()) * P_WIDGET_COUNT + j
			/*클릭 시 파워업 적용*/
			if BlzGetTriggerFrameEvent() == FRAMEEVENT_CONTROL_CLICK then
				/*j = 눌린 버튼 인덱스임*/
				set p_manager = PowerupManager(GetPlayerId(.owner))
				call p_manager.applyPowerupItem(User.getFocusUnit(.owner),j)
			endif
		endmethod

		static method initFrames takes integer index returns nothing
			local framehandle f = null
			local integer approxwidth = (P_WIDGET_CONTAINER_WIDTH-(P_WIDGET_GAP*(P_WIDGET_COUNT-1)))/P_WIDGET_COUNT
			local integer nx = (approxwidth+P_WIDGET_GAP)*index
			local integer ny = 0
			/*프레임초기화(파워업아이템 위젯)*/
			set P_WIDGET[index] = BlzCreateFrame("CPowerupUIWidget",P_WIDGET_CONTAINER,0,index)
			call BlzFrameSetPointPixel(P_WIDGET[index],FRAMEPOINT_TOPLEFT,P_WIDGET_CONTAINER,FRAMEPOINT_TOPLEFT,/*
				*/nx,/*
				*/ny/*
			*/)
			call BlzFrameSetPointPixel(P_WIDGET[index],FRAMEPOINT_BOTTOMRIGHT,P_WIDGET_CONTAINER,FRAMEPOINT_TOPLEFT,/*
				*/nx+approxwidth,/*
				*/ny-P_WIDGET_CONTAINER_HEIGHT/*
			*/)
			/*좌상단라벨*/
			set P_TYPE_LABEL[index] = BlzGetFrameByName("CPowerupUIWidgetTypeLabel",index)
			set P_TYPE_LABEL_TEXT[index] = BlzGetFrameByName("CPowerupUIWidgetTypeLabelText",index)
			set f = BlzGetFrameByName("CPowerupUIWidgetTypeLabelBackground",index)
			call BlzFrameSetPoint(f,FRAMEPOINT_TOPLEFT,P_TYPE_LABEL_TEXT[index],FRAMEPOINT_TOPLEFT,-0.002,0.002)
			call BlzFrameSetPoint(f,FRAMEPOINT_BOTTOMRIGHT,P_TYPE_LABEL_TEXT[index],FRAMEPOINT_BOTTOMRIGHT,0.002,-0.002)
			call BlzFrameSetVisible(P_TYPE_LABEL[index],false)
			/*아이콘*/
			set P_ICON[index] = BlzGetFrameByName("CPowerupUIWidgetIcon",index)
			call BlzFrameSetPointPixel(P_ICON[index],FRAMEPOINT_TOP,P_WIDGET[index],FRAMEPOINT_TOP,0,-(approxwidth-P_WIDGET_ICON_SIZE)/2)
			call BlzFrameSetSizePixel(P_ICON[index],P_WIDGET_ICON_SIZE,P_WIDGET_ICON_SIZE)
			/*타이틀*/
			set P_TITLE[index] = BlzGetFrameByName("CPowerupUIWidgetTitle",index)
			call BlzFrameSetVisible(P_TITLE[index],false)
			/*설명*/
			set P_DESC[index] = BlzGetFrameByName("CPowerupUIWidgetDesc",index)
			call BlzFrameSetVisible(P_DESC[index],false)
			call BlzFrameSetPointPixel(P_DESC[index],FRAMEPOINT_TOPLEFT,P_TITLE[index],FRAMEPOINT_BOTTOM,-approxwidth/2,-16)
			call BlzFrameSetPointPixel(P_DESC[index],FRAMEPOINT_BOTTOMRIGHT,P_WIDGET[index],FRAMEPOINT_BOTTOMRIGHT,0,0)
			/*버튼*/
			set P_BTN[index] = BlzCreateSimpleFrame("CPowerupUIWidgetButton",FRAME_POWERUP_UI,index)
			call BlzFrameSetAllPoints(P_BTN[index],P_WIDGET[index])
			set f = BlzGetFrameByName("CPowerupUIWidgetButtonBackground",index)
			call BlzFrameSetVertexColor(f,BlzConvertColor(128,255,255,255))
			/*위젯 추가 후 찐컨테이너 다시 숨김*/
			call BlzFrameSetVisible(P_WIDGET_CONTAINER,false)
			/*공용트리거*/
			call BlzTriggerRegisterFrameEvent(P_WIDGET_CALLBACK,P_BTN[index],FRAMEEVENT_CONTROL_CLICK)
			/**/
			set f = null
		endmethod

		static method create takes player owner, integer index returns thistype
			local thistype this = GetPlayerId(owner) * P_WIDGET_COUNT + index
			local PowerupManager p_manager = PowerupManager(GetPlayerId(owner))
			set .owner = owner
			set .index = index
			/*공용프레임 초기화*/
			if not P_FRAME_CREATED[.index] then
				call initFrames(.index)
				set P_FRAME_CREATED[.index] = true
			endif
			/*가리키는 파워업아이템 설정*/
			set .target = p_manager.getPowerupItem(index)
			return this
		endmethod

		method destroy takes nothing returns nothing
			
		endmethod

		static method onInit takes nothing returns nothing
			set P_WIDGET_CALLBACK = CreateTrigger()
			call TriggerAddCondition(P_WIDGET_CALLBACK,function thistype.press)
		endmethod

		static method get takes player p, integer index returns thistype
			return GetPlayerId(p) * P_WIDGET_COUNT + index
		endmethod

	endstruct

	struct PowerupUI extends array

		private static string array P_NOTICE_COLORS
		private static integer P_NOTICE_COLORS_COUNT = 16
		private static boolean P_FRAME_CREATED = false
		private static framehandle P_FRAME_INFO = null
		private static framehandle P_FRAME_INFO_TEXT = null
		private static framehandle P_FRAME_PLACEHOLDER = null
		private static framehandle P_FRAME_ICON_LEFT = null
		private static framehandle P_FRAME_ICON_RIGHT = null
		private static framehandle P_FRAME_BTN_REROLL = null
		private static framehandle P_FRAME_BTN_SELL = null
		private static framehandle P_FRAME_BTN_CLOSE = null
		private static framehandle P_FRAME_BTN_CLOSE_SECONDARY = null
		private static framehandle P_FRAME_NOTICE = null
		private static framehandle P_FRAME_NOTICE_TEXT = null

		private static real P_FADE_TICK = 0.025
		private static integer P_FADE_VALUE_PER_TICK = R2I(P_FADE_TICK*(255.0/0.3/* FADETIME */))

		boolean visible_flag
		timer fade_timer
		integer fade_value /* MAX 255 */
		timer notice_timer
		integer notice_color_index

		method operator owner takes nothing returns player
			return Player(this)
		endmethod

		method refresh takes nothing returns nothing
			local integer i = 0
			local PowerupItemWidget wd = 0
			local PowerupManager p_manager = PowerupManager(GetPlayerId(owner))
			local Powerup pup = 0
			/*TODO REDRAW(플레이스홀더, 파워업이름 등..)*/
			/*파워업 타이틀*/
			if p_manager.isEmpty() then
				/*비어있을 때*/
				if GetLocalPlayer() == .owner then
					/*찐컨테이너 비표시*/
					call BlzFrameSetVisible(P_WIDGET_CONTAINER,false)
					/*타이틀 변경*/
					call BlzFrameSetVisible(P_FRAME_INFO,false)
					/*플레이스홀더*/
					call BlzFrameSetVisible(P_FRAME_PLACEHOLDER,true)
					/*새로고침버튼*/
					call BlzFrameSetEnable(P_FRAME_BTN_REROLL,false)
					call BlzFrameSetEnable(P_FRAME_BTN_SELL,false)
				endif
			else
				/*비어있지 않을 때*/
				set pup = Powerup(p_manager.getValue(0))
				if GetLocalPlayer() == .owner then
					/*찐컨테이너 표시*/
					call BlzFrameSetVisible(P_WIDGET_CONTAINER,true)
					/*타이틀 변경*/
					call BlzFrameSetVisible(P_FRAME_INFO,true)
					if pup.type == ENUM_POWERUP_TYPE_LEVEL then
						call BlzFrameSetText(P_FRAME_INFO_TEXT,UDG_POWERUP_TYPE_COLOR[pup.type]+"레벨 "+I2S(pup.value)+" 달성 보상|r")
					else
						call BlzFrameSetText(P_FRAME_INFO_TEXT,UDG_POWERUP_TYPE_COLOR[pup.type]+UDG_POWERUP_TYPE_NAME[pup.type]+" 보상|r")
					endif
					/*아이콘 변경*/
					call BlzFrameSetTexture(P_FRAME_ICON_LEFT,UDG_POWERUP_TYPE_ICON[pup.type],0,true)
					call BlzFrameSetTexture(P_FRAME_ICON_RIGHT,UDG_POWERUP_TYPE_ICON[pup.type],0,true)
					/*플레이스홀더*/
					call BlzFrameSetVisible(P_FRAME_PLACEHOLDER,false)
					/*새로고침버튼+매각버튼*/
					call BlzFrameSetEnable(P_FRAME_BTN_REROLL,true)
					call BlzFrameSetEnable(P_FRAME_BTN_SELL,true)
				endif
			endif
			/*파워업 아이템 위젯들*/
			loop
				exitwhen i >= P_WIDGET_COUNT
				set wd = PowerupItemWidget.get(.owner,i)
				call wd.refresh()
				set i = i + 1
			endloop
		endmethod

		method fadeRefresh takes integer alpha returns nothing
			/*페이드에 의한 투명도*/
			if GetLocalPlayer() == .owner then
				/*정보창*/
				call BlzFrameSetAlpha(P_FRAME_INFO,alpha)
				call BlzFrameSetAlpha(P_WIDGET_CONTAINER,alpha)
			endif
		endmethod

		static method fadeAction takes nothing returns nothing
			local thistype this = Timer.getData(GetExpiredTimer())
			set .fade_value = .fade_value + P_FADE_VALUE_PER_TICK
			if .fade_value >= 255 then
				set .fade_value = 255
				call Timer.pause(.fade_timer)
			endif
			call fadeRefresh(.fade_value)
		endmethod

		method fadeIn takes nothing returns nothing
			set .fade_value = 0
			call fadeRefresh(0)
			call Timer.start(.fade_timer,P_FADE_TICK,true,function thistype.fadeAction)
		endmethod

		static method noticeAction takes nothing returns nothing
			local thistype this = Timer.getData(GetExpiredTimer())
			if GetLocalPlayer() == .owner then
				call BlzFrameSetText(P_FRAME_NOTICE_TEXT,P_NOTICE_COLORS[.notice_color_index]+"◆|r")
			endif
			set .notice_color_index = .notice_color_index + 1
			if .notice_color_index >= P_NOTICE_COLORS_COUNT then
				set .notice_color_index = 0
			endif
		endmethod

		method runNotice takes boolean flag returns nothing
			if GetLocalPlayer() == .owner then
				/*레드닷프레임 가시성처리*/
				call BlzFrameSetVisible(P_FRAME_NOTICE,flag)
			endif
			if flag then
				/*타이머 on*/
				call Timer.start(.notice_timer,0.05,true,function thistype.noticeAction)
			else
				/*타이머 off*/
				call Timer.pause(.notice_timer)
			endif
		endmethod

		method visibleForPlayer takes boolean flag returns nothing
			if .visible_flag != flag then
				if flag then
					if User.getCurrentInputLayer(.owner) > CONFIG_INPUT_LAYER_POWERUP_UI then
						return
					endif
					/*CLOSEUI*/
					call CloseUI(this).add(CloseUI.ORDER_POWERUP_UI)
					call refresh()
					call Ability.cancleUnitAbilityAll(User.getFocusUnit(.owner))
					call User.addInputLayer(.owner,CONFIG_INPUT_LAYER_POWERUP_UI)
				else
					/*CLOSEUI*/
					call CloseUI(this).eraseFor(CloseUI.ORDER_POWERUP_UI)
					call User.removeInputLayer(.owner,CONFIG_INPUT_LAYER_POWERUP_UI)
				endif
			endif
			set .visible_flag = flag
			if GetLocalPlayer()==.owner then
				call PlaySoundBJ(gg_snd_BigButtonClick)
				call BlzFrameSetVisible(FRAME_POWERUP_UI,flag)
				call BlzFrameSetVisible(P_WIDGET_CONTAINER,flag)
			endif
		endmethod

		method close takes nothing returns boolean
			if .visible_flag then
				call visibleForPlayer(false)
				return true
			else
				return false
			endif
		endmethod

		method switch takes nothing returns nothing
			call visibleForPlayer(not .visible_flag)
		endmethod

		static method uiCallback takes nothing returns nothing
			local thistype this = 0
			local player p = GetTriggerPlayer()
			local integer i = 0
			/*UI 여닫 단축키*/
			if Event.getValue() == ENUM_EVENT_KEYPRESS then
				set this = GetPlayerId(EVT_KEYPRESS_PLAYER)
				if EVT_KEYPRESS_KEY == OSKEY_T and EVT_KEYPRESS_PRESS then
					call switch()
					return
				endif
				return
			endif
			/**/
			set this = GetPlayerId(p)
			if BlzGetTriggerFrame() != null then
				/*버튼별 분기*/
				if BlzGetTriggerFrameEvent() == FRAMEEVENT_CONTROL_CLICK then
					if BlzGetTriggerFrame() == P_FRAME_BTN_CLOSE or BlzGetTriggerFrame() == P_FRAME_BTN_CLOSE_SECONDARY then
						/*TODO 닫기*/
						call close()
						return
					elseif BlzGetTriggerFrame() == P_FRAME_BTN_REROLL then
						/*TODO 새로고침*/
						return
					endif
				endif
			endif
		endmethod

		static method refreshCallback takes nothing returns nothing
			local thistype this = GetPlayerId(EVT_UI_REFRESH_PLAYER)
			if this >= CONFIG_PLAYER_MAX then
				return
			endif
			if not .visible_flag then
				return
			else
				call refresh()
			endif
		endmethod

		static method powerupCallback takes nothing returns nothing
			local thistype this = GetPlayerId(EVT_POWERUP_PLAYER)
			local PowerupManager p_manager = PowerupManager(this)
			if .visible_flag then
				if p_manager.size > 0 then
					/*남은 파워업이 있으면 페이드연출*/
					call fadeIn()
				else
					/*없으면 파워업 UI 닫기*/
					call visibleForPlayer(false)
				endif
			endif
			if p_manager.size <= 0 then
				/*지랄발광타이머 끄기*/
				call runNotice(false)
			endif
		endmethod

		static method powerupAddCallback takes nothing returns nothing
			local thistype this = GetPlayerId(EVT_POWERUP_PLAYER)
			local PowerupManager p_manager = PowerupManager(this)
			if p_manager.size == 1 then
				/*없었다가 생긴 케이스*/
				if .visible_flag then
					/*켜져있으면 페이드연출*/
					call fadeIn()
					call refresh()
				endif
				/*지랄발광타이머 on*/
				call runNotice(true)
			endif
		endmethod

		/*상위 UI 활성화 시 닫힘*/
		static method inputLayerChangeCallback takes nothing returns nothing
			local thistype this = GetPlayerId(EVT_INPUT_LAYER_CHANGE_PLAYER)
			if this >= CONFIG_PLAYER_MAX then
				return
			endif
			if EVT_INPUT_LAYER_CHANGE_LAYER > CONFIG_INPUT_LAYER_POWERUP_UI and /*
			*/.visible_flag then
				call DisableTrigger(GetTriggeringTrigger())
				call visibleForPlayer(false)
				call EnableTrigger(GetTriggeringTrigger())
			endif
		endmethod

		static method menuButtonCallback takes nothing returns nothing
			local thistype this = GetPlayerId(GetTriggerPlayer())
			if this >= CONFIG_PLAYER_MAX then
				return
			endif
			call switch()
		endmethod

		static method initFrames takes nothing returns nothing
			local trigger t = null
			local framehandle f = null
			/*트리거*/
			set P_UI_CALLBACK = CreateTrigger()
			/*찐 프레임(4:3영역 밖에 배치 불가)*/
			set P_WIDGET_CONTAINER = BlzCreateFrame("CPowerupUIWidgetContainer",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_WINDOW],0,0)
			call BlzFrameSetPointPixel(P_WIDGET_CONTAINER,FRAMEPOINT_TOPLEFT,FRAME_POWERUP_UI,FRAMEPOINT_TOP,-P_WIDGET_CONTAINER_WIDTH/2,P_WIDGET_CONTAINER_OFFSET_Y)
			call BlzFrameSetPointPixel(P_WIDGET_CONTAINER,FRAMEPOINT_BOTTOMRIGHT,FRAME_POWERUP_UI,FRAMEPOINT_TOP,P_WIDGET_CONTAINER_WIDTH/2,P_WIDGET_CONTAINER_OFFSET_Y-P_WIDGET_CONTAINER_HEIGHT)
			call BlzFrameSetVisible(P_WIDGET_CONTAINER,false)
			/*파워업유형-텍스트*/
			set P_FRAME_INFO = BlzGetFrameByName("CPowerupUIInfo",0)
			set P_FRAME_INFO_TEXT = BlzGetFrameByName("CPowerupUIInfoText",0)
			/*파워업유형-아이콘*/
			set P_FRAME_ICON_LEFT = BlzGetFrameByName("CPowerupUIInfoIconLeft",0)
			set P_FRAME_ICON_RIGHT = BlzGetFrameByName("CPowerupUIInfoIconRight",0)
			set f = BlzGetFrameByName("CPowerupUIInfoBackground",0)
			call BlzFrameSetVertexColor(f,BlzConvertColor(128,255,255,255))
			/*플레이스홀더*/
			set P_FRAME_PLACEHOLDER = BlzGetFrameByName("CPowerupUIPlaceholder",0)
			set f = BlzGetFrameByName("CPowerupUIPlaceholderBackground",0)
			call BlzFrameSetVertexColor(f,BlzConvertColor(128,255,255,255))
			/*새로고침버튼*/
			set P_FRAME_BTN_REROLL = BlzGetFrameByName("CPowerupUIRerollButton",0)
			/*매각버튼*/
			set P_FRAME_BTN_SELL = BlzGetFrameByName("CPowerupUISellButton",0)
			/*닫기버튼*/
			set P_FRAME_BTN_CLOSE = BlzGetFrameByName("CPowerupUICloseButton",0)
			set P_FRAME_BTN_CLOSE_SECONDARY = BlzGetFrameByName("CPowerupUICloseButton2",0)
			/*레드닷*/
			set P_FRAME_NOTICE = BlzGetFrameByName("CPowerupUIButtonNotice",0)
			set P_FRAME_NOTICE_TEXT = BlzGetFrameByName("CPowerupUIButtonNoticeText",0)
			call BlzFrameSetVisible(P_FRAME_NOTICE,false)
			/*누름 콜백*/
			call BlzTriggerRegisterFrameEvent(P_UI_CALLBACK,P_FRAME_BTN_CLOSE,FRAMEEVENT_CONTROL_CLICK)
			call BlzTriggerRegisterFrameEvent(P_UI_CALLBACK,P_FRAME_BTN_CLOSE_SECONDARY,FRAMEEVENT_CONTROL_CLICK)
			call TriggerAddCondition(P_UI_CALLBACK,function thistype.uiCallback)
			call Event.register(P_UI_CALLBACK,ENUM_EVENT_KEYPRESS)
			/*메뉴버튼클릭*/
			set t = CreateTrigger()
			call BlzTriggerRegisterFrameEvent(t,BlzGetFrameByName("CPowerupUIButton",0),FRAMEEVENT_CONTROL_CLICK)
			call TriggerAddCondition(t,function thistype.menuButtonCallback)
			/**/
			set t = null
			set f = null
		endmethod

		static method create takes player p returns thistype
			local thistype this = GetPlayerId(p)
			local integer i = 0
			set .visible_flag = false
			set .notice_color_index = 0
			/*타이머 생성*/
			set .fade_timer = Timer.new(this)
			set .notice_timer = Timer.new(this)
			/*프레임 초기화*/
			if not P_FRAME_CREATED then
				call initFrames()
				set P_FRAME_CREATED = true
			endif
			/*위젯 초기화*/
			loop
				exitwhen i >= P_WIDGET_COUNT
				call PowerupItemWidget.create(Player(this),i)
				set i = i + 1
			endloop
			/*리프레시 한 번*/
			call refresh()
			return this
		endmethod

		method destroy takes nothing returns nothing

		endmethod

		private static method onInit takes nothing returns nothing
			local trigger t
			/*랜덤색상초기화*/
			set P_NOTICE_COLORS[0]  = "|cffff0000"
			set P_NOTICE_COLORS[1]  = "|cffff2424"
			set P_NOTICE_COLORS[2]  = "|cffff4949"
			set P_NOTICE_COLORS[3]  = "|cffff6d6d"
			set P_NOTICE_COLORS[4]  = "|cffff9292"
			set P_NOTICE_COLORS[5]  = "|cffffb6b6"
			set P_NOTICE_COLORS[6]  = "|cffffdbdb"
			set P_NOTICE_COLORS[7]  = "|cffffffff"
			set P_NOTICE_COLORS[8]  = "|cffffffff"
			set P_NOTICE_COLORS[9]  = "|cffffdbdb"
			set P_NOTICE_COLORS[10] = "|cffffb6b6"
			set P_NOTICE_COLORS[11] = "|cffff9292"
			set P_NOTICE_COLORS[12] = "|cffff6d6d"
			set P_NOTICE_COLORS[13] = "|cffff4949"
			set P_NOTICE_COLORS[14] = "|cffff2424"
			set P_NOTICE_COLORS[15] = "|cffff0000"
			/*UI리프레시*/
			set t = CreateTrigger()
			call Event.register(t,ENUM_EVENT_ABILITY_UI_REFRESH)
			call TriggerAddCondition(t,function thistype.refreshCallback)
			/*파워업 시 페이드*/
			set t = CreateTrigger()
			call Event.register(t,ENUM_EVENT_POWERUP)
			call TriggerAddCondition(t,function thistype.powerupCallback)
			/*파워업 획득 시 페이드*/
			set t = CreateTrigger()
			call Event.register(t,ENUM_EVENT_POWERUP_ADD)
			call TriggerAddCondition(t,function thistype.powerupAddCallback)
			/*인풋레이어 변경시*/
			set t = CreateTrigger()
			call Event.register(t,ENUM_EVENT_INPUT_LAYER_CHANGE)
			call TriggerAddCondition(t,function thistype.inputLayerChangeCallback)
			/**/
			set t = null
		endmethod

	endstruct

endlibrary