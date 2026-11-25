/**
C버튼 누르면 나오는 그거(스탯창)
*/

struct StatItem extends array

	static constant integer STAT_ITEM_OFFSET_Y = 64/* 박스최상단에서부터 */
	static constant integer STAT_ITEM_HEIGHT = 24 /* 아이템 한개 높이 */
	static constant integer STAT_ITEM_INSET_HORIZONTAL = 24 /* 인디케이터 전체 박스 기준 좌우 인셋 */
	static constant integer STAT_ITEM_GAP = 8 /* 아이템들 간 상하간격 */
	static constant integer COUNTS = 21

	private static boolean array FLAG_FRAME[32] //스탯아이콘(단일)초기화여부

	player owner
	integer stat_index
	integer index
	integer format		/*0 int, 1 real, 2 percent*/
	Unit target


	private static framehandle array STAT_ITEM[32]
	private static framehandle array STAT_ICON[32]
	private static framehandle array STAT_NAME[32]
	private static framehandle array STAT_VALUE[32]
	private static framehandle P_BUTTON_CLOSE = null

	static integer array COUNTER[32]

	method refresh takes nothing returns nothing
		local real r = 0.
		// local real r2 = 0.
		local string color = ""
		// local string tooltip = ""
		// // call BJDebugMsg("옹")
		set r = .target.getCalculatedStatValue(.stat_index) - .target.getPureStatValue(.stat_index)
		if r <= -0.01 then
			/*음수*/
			set color = "|cffff0000"
		elseif r >= 0.01 then
			/*양수*/
			set color = "|cff00ff00"
		else
			/*0.*/
			set color = "|cffffcc00"
		endif
		/*스탯텍스트*/
		if GetLocalPlayer() == .owner then
			if .format == 0 then
				/*정수*/
				call BlzFrameSetText(STAT_VALUE[.index],color+I2S(MathRound(.target.getCalculatedStatValue(.stat_index)))+"|r")
			elseif .format == 1 then
				/*소숫점한개*/
				call BlzFrameSetText(STAT_VALUE[.index],color+R2SW(.target.getCalculatedStatValue(.stat_index),1,1)+"|r")
			elseif .format == 2 then
				/*퍼센트*/
				call BlzFrameSetText(STAT_VALUE[.index],color+I2S(MathRound(.target.getCalculatedStatValue(.stat_index)*100.))+"%|r")
			endif
		endif
		// /*툴팁*/
		// if GetLocalPlayer() == .owner then
		// 	/*스텟인덱스별로 분기*/
		// 	if .stat_index == ENUM_STAT_ATTACK then
		// 		/*공격력*/
		// 		set tooltip = " - 일부 공격의 피해량이 증가합니다."
		// 	elseif .stat_index == ENUM_STAT_MAGICPOWER then
		// 		/*주문력*/
		// 		set tooltip = " - 일부 공격의 피해량이 증가합니다."
		// 	elseif .stat_index == ENUM_STAT_ACCURACY then
		// 		/*정확도*/
		// 		set tooltip = " - 대상에게 입힐 수 있는 최소피해가 증가합니다.\n대상의 "+CONSTANT_STAT_COLOR[ENUM_STAT_EVASION]+CONSTANT_STAT_NAME[ENUM_STAT_EVASION]+"|r"/*
		// 		*/+"에 따라 감소할 수 있습니다."
		// 	elseif .stat_index == ENUM_STAT_EVASION then
		// 		/*정확도*/
		// 		set tooltip = " - 다른 대상에게 받을 수 있는 최소피해가 감소합니다.\n대상의 "+CONSTANT_STAT_COLOR[ENUM_STAT_ACCURACY]+CONSTANT_STAT_NAME[ENUM_STAT_ACCURACY]+"|r"/*
		// 		*/+"에 따라 증가할 수 있습니다."
		// 	elseif .stat_index == ENUM_STAT_LOVE then
		// 		/*애정*/
		// 		set r2 = .target.getCalculatedStatValue(ENUM_STAT_LOVE)
		// 		if r2 >= 0. then
		// 			/*애정 양수값*/
		// 			set r = ((100.0+r2)/100.0) - 1.0
		// 			set r2 = 1.0 - (100.0/(100.0+r2))
		// 		else
		// 			/*애정 음수값*/
		// 			set r = (100.0/(100.0+r2)) - 1.0
		// 			set r2 = 0.0
		// 		endif
		// 		set tooltip = " - 다른 대상과 주고받는 회복 및 보호막 양이 "+CONSTANT_STAT_COLOR[ENUM_STAT_LOVE]+R2SW(r*100,2,2)+"%|r 증가합니다.(곱적용)\n"+/*
		// 		*/" - 다른 대상에게 주는 피해가 "+CONSTANT_STAT_COLOR[ENUM_STAT_LOVE]+R2SW(r2*100,2,2)+"%|r 감소합니다.(곱적용)"
		// 	else

		// 	endif
		// 	/*적용하기*/
		// 	call BlzFrameSetText(TOOLTIP_TEXT[.index],/*
		// 		*/CONSTANT_STAT_COLOR[.stat_index]+CONSTANT_STAT_NAME[.stat_index]+"|r\n\n"+tooltip/*
		// 	*/)
		// endif
	endmethod

	method setTarget takes Unit nt returns nothing
		set .target = nt
	endmethod

	/*스탯아이콘 프레임 초기화(최초 1회만 실행)*/
	static method initFrames takes integer index, integer stat_index returns nothing
		local framehandle f = null
		set STAT_ITEM[index] = BlzCreateSimpleFrame("CStatIndicatorItem",FRAME_STAT_INDICATOR,index)
		call BlzFrameSetPointPixel(STAT_ITEM[index],FRAMEPOINT_TOPLEFT,FRAME_STAT_INDICATOR,FRAMEPOINT_TOPLEFT,/*
			*/STAT_ITEM_INSET_HORIZONTAL,/*
			*/-STAT_ITEM_OFFSET_Y-(STAT_ITEM_HEIGHT*index)-(STAT_ITEM_GAP*index)/*
		*/)
		call BlzFrameSetPointPixel(STAT_ITEM[index],FRAMEPOINT_BOTTOMRIGHT,FRAME_STAT_INDICATOR,FRAMEPOINT_TOPRIGHT,/*
			*/-STAT_ITEM_INSET_HORIZONTAL,/*
			*/-STAT_ITEM_OFFSET_Y-(STAT_ITEM_HEIGHT*index)-(STAT_ITEM_GAP*index)-STAT_ITEM_HEIGHT/*
		*/)
		/* 스탯아이템 - 아이콘 */
		set STAT_ICON[index] = BlzGetFrameByName("CStatIndicatorItemIcon",index)
		call BlzFrameSetTexture(STAT_ICON[index],CONSTANT_STAT_ICON[stat_index],0,true)
		/* 스탯아이템 - 스탯이름 */
		set STAT_NAME[index] = BlzGetFrameByName("CStatIndicatorItemName",index)
		call BlzFrameSetText(STAT_NAME[index],CONSTANT_STAT_NAME[stat_index])
		/* 스탯아이템 - 스탯값 */
		set STAT_VALUE[index] = BlzGetFrameByName("CStatIndicatorItemValue",index)
		/* 스탯아이템 - 밑줄컬러링(fdf에서 안됨)*/
		set f = BlzGetFrameByName("CStatIndicatorItemUnderline",index)
		call BlzFrameSetVertexColor(f,BlzConvertColor(R2I(255*0.25),R2I(255*1.0),R2I(255*0.8),0))
		//
		set FLAG_FRAME[index] = true
		set f = null
	endmethod

	static method create takes integer stat_index, player owner returns thistype
		local thistype this = GetPlayerId(owner)*.COUNTS + COUNTER[GetPlayerId(owner)]
		set .owner = owner
		set .stat_index = stat_index
		set .index = COUNTER[GetPlayerId(owner)]
		/*FORMAT*/
		if .stat_index == ENUM_STAT_ATTACK_SPEED then
			set .format = 2
		elseif .stat_index == ENUM_STAT_HPREGEN or /*
			*/.stat_index == ENUM_STAT_MPREGEN or /*
			*/.stat_index == ENUM_STAT_ARMOR_PENET or /*
			*/.stat_index == ENUM_STAT_MAGIC_PENET then
			set .format = 1
		endif
		/**/
		if not FLAG_FRAME[.index] then
			call initFrames(.index,.stat_index)
		endif
		set COUNTER[GetPlayerId(owner)] = COUNTER[GetPlayerId(owner)] + 1
		return this
	endmethod

	static method get takes integer pid, integer index returns thistype
		return pid*.COUNTS + index
	endmethod

	static method onInit takes nothing returns nothing
		local integer i = 0
		loop
			exitwhen i >= 32
			set FLAG_FRAME[i] = false
			set COUNTER[i] = 0
			set i = i + 1
		endloop
	endmethod

endstruct

struct StatIndicator extends array

	
	static trigger KEYPRESS = null
	static boolean INIT_FRAME = false
	static framehandle CLOSE = null
	
	boolean visible
	framehandle parent

	method refreshTarget takes Unit target returns nothing
		local integer i = 0
		/*개별 스탯아이콘들 리프레시*/
		loop
			exitwhen i >= StatItem.COUNTS
			call StatItem.get(this,i).setTarget(target)
			set i = i + 1
		endloop
	endmethod

	method refresh takes nothing returns nothing
		local integer i = 0
		if (not .visible) then
			return
		endif
		/*개별스탯아이콘들 리프레시*/
		loop
			exitwhen i >= StatItem.COUNTS
			call StatItem.get(this,i).refresh()
			set i = i + 1
		endloop
	endmethod

	method show takes boolean flag returns nothing
		if GetLocalPlayer() == Player(this) then
			call BlzFrameSetVisible(.parent,flag)
			call PlaySoundBJ(gg_snd_BigButtonClick)
		endif
		if .visible != flag then
			if flag then
				/*CLOSEUI*/
				call CloseUI(this).add(CloseUI.ORDER_STAT_INDICATOR)
			else
				/*CLOSEUI*/
				call CloseUI(this).eraseFor(CloseUI.ORDER_STAT_INDICATOR)
			endif
		endif
		set .visible = flag
		/*보임 상태면 스탯아이콘들 리프레시*/
		call refresh()
	endmethod

	method switch takes nothing returns nothing
		call show(not .visible)
	endmethod

	method close takes nothing returns boolean
		if .visible then
			call show(false)
			return true
		endif
		return false
	endmethod

	static method keypress takes nothing returns nothing
		local thistype this = 0
		local player p = GetTriggerPlayer()
		if Event.getValue() == ENUM_EVENT_KEYPRESS then
			set this = GetPlayerId(EVT_KEYPRESS_PLAYER)
			if EVT_KEYPRESS_KEY == OSKEY_C and EVT_KEYPRESS_PRESS then
				call switch()
				return
			endif
			return
		endif
		set this = GetPlayerId(p)
		if BlzGetTriggerFrameEvent() == FRAMEEVENT_CONTROL_CLICK then
			/*클로즈 버튼 클릭*/
			/* 버튼소리재생 */
			if GetLocalPlayer() == p then
				call PlaySoundBJ(gg_snd_BigButtonClick)
			endif
			call close()
		else
			/*C 프레스*/
			call switch()
		endif
	endmethod

	static method initFrame takes nothing returns nothing
		// 닫기버튼
		set CLOSE = BlzGetFrameByName("CStatIndicatorCloseButton",0)
	endmethod

	static method create takes player p, framehandle parent returns thistype
		local thistype this = GetPlayerId(p)
		if not .INIT_FRAME then
			call initFrame()
			set .INIT_FRAME = true
		endif
		//
		/*스탯*/
		call StatItem.create(ENUM_STAT_MAXHP,p)
		call StatItem.create(ENUM_STAT_HPREGEN,p)
		call StatItem.create(ENUM_STAT_MAXMP,p)
		call StatItem.create(ENUM_STAT_MPREGEN,p)
		call StatItem.create(ENUM_STAT_ATTACK,p)
		call StatItem.create(ENUM_STAT_DEFENSE,p)
		call StatItem.create(ENUM_STAT_ARMOR_PENET,p)
		call StatItem.create(ENUM_STAT_MAGICPOWER,p)
		call StatItem.create(ENUM_STAT_RESISTANCE,p)
		call StatItem.create(ENUM_STAT_MAGIC_PENET,p)
		call StatItem.create(ENUM_STAT_ACCURACY,p)
		call StatItem.create(ENUM_STAT_EVASION,p)
		call StatItem.create(ENUM_STAT_SPELL_BOOST,p)
		call StatItem.create(ENUM_STAT_LUCK,p)
		call StatItem.create(ENUM_STAT_RODONG,p)
		call StatItem.create(ENUM_STAT_INSIGHT,p)
		call StatItem.create(ENUM_STAT_LOVE,p)
		call StatItem.create(ENUM_STAT_GREED,p)
		call StatItem.create(ENUM_STAT_MOVEMENT_SPEED,p)
		call StatItem.create(ENUM_STAT_ATTACK_SPEED,p)
		call StatItem.create(ENUM_STAT_ATTACK_RANGE,p)
		//
		call BlzTriggerRegisterFrameEvent(KEYPRESS,CLOSE,FRAMEEVENT_CONTROL_CLICK)
		set .visible = false
		set .parent = parent
		return this
	endmethod

	static method onInit takes nothing returns nothing
		set KEYPRESS = CreateTrigger()
		call TriggerAddCondition(KEYPRESS,function thistype.keypress)
		call Event.register(KEYPRESS,ENUM_EVENT_KEYPRESS)
	endmethod

endstruct