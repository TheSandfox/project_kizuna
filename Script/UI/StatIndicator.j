struct StatIcon extends array

	static constant integer HEIGHT = 32
	static constant integer WIDTH = 128
	static constant integer PER_COL = 7
	static constant integer INSET_X = 32
	static constant integer INSET_Y = -80
	static constant integer COUNTS = 21

	private static boolean array FLAG_FRAME[32]

	player owner
	integer stat_index
	integer index
	integer format		/*0 int, 1 real, 2 percent*/
	Unit target

	private static framehandle array BACKDROP[32]
	private static framehandle array TEXT[32]
	private static framehandle array MOUSEOVER[32]
	private static framehandle array TOOLTIP_CONTAINER[32]
	private static framehandle array TOOLTIP_BACKDROP[32]
	private static framehandle array TOOLTIP_TEXT[32]

	static integer array COUNTER[32]

	method refresh takes nothing returns nothing
		local real r = 0.
		local real r2 = 0.
		local string col = ""
		local string tooltip = ""
		// call BJDebugMsg("옹")
		set r = .target.getCarculatedStatValue(.stat_index) - .target.getPureStatValue(.stat_index)
		if r <= -0.01 then
			/*음수*/
			set col = "|cffff0000"
		elseif r >= 0.01 then
			/*양수*/
			set col = "|cff00ff00"
		else
			/*0.*/
			set col = "|cffffcc00"
		endif
		/*스탯텍스트*/
		if GetLocalPlayer() == .owner then
			if .format == 0 then
				/*정수*/
				call BlzFrameSetText(TEXT[.index],col+I2S(MathRound(.target.getCarculatedStatValue(.stat_index)))+"|r")
			elseif .format == 1 then
				/*소숫점한개*/
				call BlzFrameSetText(TEXT[.index],col+R2SW(.target.getCarculatedStatValue(.stat_index),1,1)+"|r")
			elseif .format == 2 then
				/*퍼센트*/
				call BlzFrameSetText(TEXT[.index],col+I2S(MathRound(.target.getCarculatedStatValue(.stat_index)*100.))+"%|r")
			endif
		endif
		/*툴팁*/
		if GetLocalPlayer() == .owner then
			/*스텟인덱스별로 분기*/
			if .stat_index == ENUM_STAT_ATTACK then
				/*공격력*/
				set tooltip = " - 일부 공격의 피해량이 증가합니다."
			elseif .stat_index == ENUM_STAT_MAGICPOWER then
				/*주문력*/
				set tooltip = " - 일부 공격의 피해량이 증가합니다."
			elseif .stat_index == ENUM_STAT_ACCURACY then
				/*정확도*/
				set tooltip = " - 대상에게 입힐 수 있는 최소피해가 증가합니다.\n대상의 "+CONSTANT_STAT_COLOR[ENUM_STAT_EVASION]+CONSTANT_STAT_NAME[ENUM_STAT_EVASION]+"|r"/*
				*/+"에 따라 감소할 수 있습니다."
			elseif .stat_index == ENUM_STAT_EVASION then
				/*정확도*/
				set tooltip = " - 다른 대상에게 받을 수 있는 최소피해가 감소합니다.\n대상의 "+CONSTANT_STAT_COLOR[ENUM_STAT_ACCURACY]+CONSTANT_STAT_NAME[ENUM_STAT_ACCURACY]+"|r"/*
				*/+"에 따라 증가할 수 있습니다."
			elseif .stat_index == ENUM_STAT_LOVE then
				/*애정*/
				set r2 = .target.getCarculatedStatValue(ENUM_STAT_LOVE)
				if r2 >= 0. then
					/*애정 양수값*/
					set r = ((100.0+r2)/100.0) - 1.0
					set r2 = 1.0 - (100.0/(100.0+r2))
				else
					/*애정 음수값*/
					set r = (100.0/(100.0+r2)) - 1.0
					set r2 = 0.0
				endif
				set tooltip = " - 다른 대상과 주고받는 회복 및 보호막 양이 "+CONSTANT_STAT_COLOR[ENUM_STAT_LOVE]+R2SW(r*100,2,2)+"%|r 증가합니다.(곱적용)\n"+/*
				*/" - 다른 대상에게 주는 피해가 "+CONSTANT_STAT_COLOR[ENUM_STAT_LOVE]+R2SW(r2*100,2,2)+"%|r 감소합니다.(곱적용)"
			else

			endif
			/*적용하기*/
			call BlzFrameSetText(TOOLTIP_TEXT[.index],/*
				*/CONSTANT_STAT_COLOR[.stat_index]+CONSTANT_STAT_NAME[.stat_index]+"|r\n\n"+tooltip/*
			*/)
		endif
	endmethod

	method setTarget takes Unit nt returns nothing
		set .target = nt
	endmethod

	static method initFrames takes integer index, integer stat_index, framehandle parent returns nothing
		set BACKDROP[index] = BlzCreateFrameByType("BACKDROP","",parent,"",0)
		call BlzFrameSetPoint(BACKDROP[index],FRAMEPOINT_TOPLEFT,parent,FRAMEPOINT_TOPLEFT,/*
			*/Math.px2Size(WIDTH)*(index/PER_COL)+Math.px2Size(INSET_X),/*
			*/-Math.px2Size(HEIGHT)*ModuloInteger(index,PER_COL)+Math.px2Size(INSET_Y))
		call BlzFrameSetTexture(BACKDROP[index],CONSTANT_STAT_ICON[stat_index],0,true)
		call BlzFrameSetSize(BACKDROP[index],Math.px2Size(HEIGHT-8),Math.px2Size(HEIGHT-8))
		set TEXT[index] = BlzCreateFrame("MyText",parent,0,0)
		call BlzFrameSetPoint(TEXT[index],FRAMEPOINT_BOTTOMLEFT,BACKDROP[index],FRAMEPOINT_BOTTOMRIGHT,0.005,0.)
		call BlzFrameSetTextAlignment(TEXT[index],TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_LEFT)
		set MOUSEOVER[index] = BlzCreateFrameByType("FRAME","",BACKDROP[index],"",0)
		call BlzFrameSetPoint(MOUSEOVER[index],FRAMEPOINT_BOTTOMRIGHT,BACKDROP[index],FRAMEPOINT_BOTTOMRIGHT,0.,0.)
		call BlzFrameSetSize(MOUSEOVER[index],Math.px2Size(20),Math.px2Size(20))
		set TOOLTIP_CONTAINER[index] = BlzCreateFrameByType("BACKDROP","",MOUSEOVER[index],"",0)
		call BlzFrameSetPoint(TOOLTIP_CONTAINER[index],FRAMEPOINT_BOTTOMLEFT,FRAME_ORIGIN,FRAMEPOINT_BOTTOMLEFT,0.0,0.0)
		call BlzFrameSetTooltip(MOUSEOVER[index],TOOLTIP_CONTAINER[index])
		set TOOLTIP_BACKDROP[index] = BlzCreateFrameByType("BACKDROP","",TOOLTIP_CONTAINER[index],"",0)
		call BlzFrameSetTexture(TOOLTIP_BACKDROP[index],"replaceabletextures\\teamcolor\\teamcolor27.blp",0,true)
		call BlzFrameSetAlpha(TOOLTIP_BACKDROP[index],200)
		set TOOLTIP_TEXT[index] = BlzCreateFrame("MyText",TOOLTIP_CONTAINER[index],0,0)
		call BlzFrameSetText(TOOLTIP_TEXT[index],"")
		call BlzFrameSetTextAlignment(TOOLTIP_TEXT[index],TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_LEFT)
		call BlzFrameSetPoint(TOOLTIP_TEXT[index],FRAMEPOINT_BOTTOMLEFT,MOUSEOVER[index],FRAMEPOINT_BOTTOMRIGHT,0.005,0.005)
		call BlzFrameSetPoint(TOOLTIP_BACKDROP[index],FRAMEPOINT_BOTTOMLEFT,TOOLTIP_TEXT[index],FRAMEPOINT_BOTTOMLEFT,-0.005,-0.005)
		call BlzFrameSetPoint(TOOLTIP_BACKDROP[index],FRAMEPOINT_TOPRIGHT,TOOLTIP_TEXT[index],FRAMEPOINT_TOPRIGHT,0.005,0.005)
		set FLAG_FRAME[index] = true
	endmethod

	static method create takes framehandle parent, integer stat_index, player owner returns thistype
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
			call initFrames(.index,.stat_index,parent)
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
		loop
			exitwhen i >= StatIcon.COUNTS
			call StatIcon.get(this,i).setTarget(target)
			set i = i + 1
		endloop
	endmethod

	method refresh takes nothing returns nothing
		local integer i = 0
		if (not .visible) then
			return
		endif
		loop
			exitwhen i >= StatIcon.COUNTS
			call StatIcon.get(this,i).refresh()
			set i = i + 1
		endloop
	endmethod

	method show takes boolean flag returns nothing
		if GetLocalPlayer() == Player(this) then
			call BlzFrameSetVisible(.parent,flag)
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
			set this = GetPlayerId(CUSTOM_RESPOND_KEYPRESS_PLAYER)
			if CUSTOM_RESPOND_KEYPRESS_KEY == OSKEY_C and CUSTOM_RESPOND_KEYPRESS_PRESS then
				call switch()
				return
			endif
			return
		endif
		set this = GetPlayerId(p)
		if BlzGetTriggerFrameEvent() == FRAMEEVENT_CONTROL_CLICK then
			/*클로즈 버튼 클릭*/
			call DisableTrigger(GetTriggeringTrigger())
			if GetLocalPlayer() == GetTriggerPlayer() then
				call BlzFrameSetEnable(BlzGetTriggerFrame(),false)
				call BlzFrameSetEnable(BlzGetTriggerFrame(),true)
			endif
			call EnableTrigger(GetTriggeringTrigger())
			call close()
		elseif BlzGetTriggerFrameEvent() == FRAMEEVENT_MOUSE_LEAVE then
			/*클로즈 버튼 마우스리브*/
			if GetLocalPlayer() == GetTriggerPlayer() then
				call BlzFrameSetEnable(BlzGetTriggerFrame(),false)
				call BlzFrameSetEnable(BlzGetTriggerFrame(),true)
			endif
		else
			/*C 프레스*/
			call switch()
		endif
	endmethod

	static method initFrame takes framehandle parent returns nothing
		set CLOSE = BlzCreateFrame("GenericCloseButton",parent,0,0)
		call BlzFrameSetPointPixel(CLOSE,FRAMEPOINT_TOPRIGHT,parent,FRAMEPOINT_TOPRIGHT,-16,-16)
	endmethod

	static method create takes player p, framehandle parent returns thistype
		local thistype this = GetPlayerId(p)
		if not .INIT_FRAME then
			call initFrame(parent)
			set .INIT_FRAME = true
		endif
		//
		/*스탯*/
		//1열
		call StatIcon.create(parent,ENUM_STAT_MAXHP,p)
		call StatIcon.create(parent,ENUM_STAT_MAXMP,p)
		call StatIcon.create(parent,ENUM_STAT_ATTACK,p)
		call StatIcon.create(parent,ENUM_STAT_MAGICPOWER,p)
		call StatIcon.create(parent,ENUM_STAT_ACCURACY,p)
		call StatIcon.create(parent,ENUM_STAT_RODONG,p)
		call StatIcon.create(parent,ENUM_STAT_MOVEMENT_SPEED,p)
		//2열
		call StatIcon.create(parent,ENUM_STAT_HPREGEN,p)
		call StatIcon.create(parent,ENUM_STAT_MPREGEN,p)
		call StatIcon.create(parent,ENUM_STAT_DEFENSE,p)
		call StatIcon.create(parent,ENUM_STAT_RESISTANCE,p)
		call StatIcon.create(parent,ENUM_STAT_EVASION,p)
		call StatIcon.create(parent,ENUM_STAT_LOVE,p)
		call StatIcon.create(parent,ENUM_STAT_ATTACK_SPEED,p)
		//3열
		call StatIcon.create(parent,ENUM_STAT_LUCK,p)
		call StatIcon.create(parent,ENUM_STAT_INSIGHT,p)
		call StatIcon.create(parent,ENUM_STAT_ARMOR_PENET,p)
		call StatIcon.create(parent,ENUM_STAT_MAGIC_PENET,p)
		call StatIcon.create(parent,ENUM_STAT_SPELL_BOOST,p)
		call StatIcon.create(parent,ENUM_STAT_GREED,p)
		call StatIcon.create(parent,ENUM_STAT_ATTACK_RANGE,p)
		//
		call BlzTriggerRegisterFrameEvent(KEYPRESS,CLOSE,FRAMEEVENT_CONTROL_CLICK)
		call BlzTriggerRegisterFrameEvent(KEYPRESS,CLOSE,FRAMEEVENT_MOUSE_LEAVE)
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