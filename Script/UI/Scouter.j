library Scouter

	globals
		private framehandle MY_CONTAINER = null
		private framehandle MY_TEAMCOLOR = null
		private framehandle MY_ICON = null
		private framehandle MY_DEATH_OVERLAY = null
		private framehandle MY_NAME = null
		private framehandle MY_HP_BACKDROP = null
		private framehandle MY_HP_FILL = null
		private framehandle MY_SP_FILL = null
		private framehandle MY_HP_TEXT = null
		private framehandle MY_MP_BACKDROP = null
		private framehandle MY_MP_FILL = null
		private framehandle MY_MP_TEXT = null
	endglobals

	globals
		private constant integer PADDING = 0
		//! runtextmacro BuffIndicator_globals()
		// private constant integer BUFF_ICONS_MAX = 16
		// private constant integer PER_ROW = 10
		// private constant integer SIZE = 36
		// private constant integer INSET = 2
		// private framehandle MY_BUFF_CONTAINER = null
		// private framehandle array MY_ICON_OUTLINE
		// private framehandle array MY_ICON_BACKDROP
		// private framehandle array MY_ICON_COOLDOWN
		// private framehandle array MY_ICON_MOUSEOVER
		// private framehandle array MY_TOOLTIP_CONTAINER
		// private framehandle array MY_TOOLTIP_BACKDROP
		// private framehandle array MY_TOOLTIP_TEXT
	endglobals

	struct BuffIndicatorForScouter extends array

		static boolean INIT = false

		Unit target

		//! runtextmacro buffIndicatorSetIconTarget()

		method refreshIconsTarget takes nothing returns nothing
			local integer j = 0
			local Buff b = Buff.getUnitRootBuff(.target)
			/*타겟의 루트버프를 먼저 따와서 쭉 리프레시*/
			loop
				exitwhen j >= BUFF_ICONS_MAX or b <= 0
				if b.icon_display then
					call setIconTarget(j,b)
					set j = j + 1
				endif
				set b = b.node_next
			endloop
			/*나머지 공백*/
			loop
				exitwhen j >= BUFF_ICONS_MAX
				call setIconTarget(j,0)
				set j = j + 1
			endloop
		endmethod

		method setTarget takes Unit u returns nothing
			set .target = u
			if GetLocalPlayer() == Player(this) then
				call BlzFrameSetVisible(MY_BUFF_CONTAINER,u>0)
			endif
			if u > 0 then
				call refreshIconsTarget()
			endif
		endmethod

		static method initFrames takes nothing returns nothing
			local integer i = 0
			set MY_BUFF_CONTAINER = BlzCreateFrame("NonFocusFrame",MY_CONTAINER,0,0)
			call BlzFrameSetPointPixel(MY_BUFF_CONTAINER,FRAMEPOINT_TOPLEFT,MY_CONTAINER,FRAMEPOINT_BOTTOMLEFT,0.,0)
			call BlzFrameSetSizePixel(MY_BUFF_CONTAINER,16,16)
			loop
				exitwhen i >= BUFF_ICONS_MAX
				set MY_ICON_OUTLINE[i] = BlzCreateFrameByType("BACKDROP","",MY_BUFF_CONTAINER,"",0)
				call BlzFrameSetPointPixel(MY_ICON_OUTLINE[i],FRAMEPOINT_TOPLEFT,MY_BUFF_CONTAINER,FRAMEPOINT_TOPLEFT,/*
				*/(SIZE+PADDING)*ModuloInteger(i,PER_ROW)+PADDING,-(SIZE+PADDING)*R2I(i/PER_ROW)/*
				*/)
				call BlzFrameSetSizePixel(MY_ICON_OUTLINE[i],SIZE,SIZE)
				set MY_ICON_COOLDOWN[i] = BlzCreateFrameByType("BACKDROP","",MY_ICON_OUTLINE[i],"",0)
				call BlzFrameSetPointPixel(MY_ICON_COOLDOWN[i],FRAMEPOINT_BOTTOMLEFT,MY_ICON_OUTLINE[i],FRAMEPOINT_BOTTOMLEFT,0,0)
				call BlzFrameSetTexture(MY_ICON_COOLDOWN[i],"textures\\white.blp",0,true)
				set MY_ICON_BACKDROP[i] = BlzCreateFrameByType("BACKDROP","",MY_ICON_OUTLINE[i],"",0)
				call BlzFrameSetPointPixel(MY_ICON_BACKDROP[i],FRAMEPOINT_TOPLEFT,MY_ICON_OUTLINE[i],FRAMEPOINT_TOPLEFT,INSET,-INSET)
				call BlzFrameSetPointPixel(MY_ICON_BACKDROP[i],FRAMEPOINT_BOTTOMRIGHT,MY_ICON_OUTLINE[i],FRAMEPOINT_BOTTOMRIGHT,-INSET,INSET)
				set MY_ICON_EX_BACKDROP[i] = BlzCreateFrameByType("BACKDROP","",MY_ICON_OUTLINE[i],"",0)
				call BlzFrameSetTexture(MY_ICON_EX_BACKDROP[i],"textures\\black32.blp",0,true)
				call BlzFrameSetAlpha(MY_ICON_EX_BACKDROP[i],128)
				set MY_ICON_EX_TEXT[i] = BlzCreateFrame("MyTextSmall",MY_ICON_OUTLINE[i],0,0)
				call BlzFrameSetPoint(MY_ICON_EX_TEXT[i],FRAMEPOINT_BOTTOMRIGHT,MY_ICON_BACKDROP[i],FRAMEPOINT_BOTTOMRIGHT,-0.002,0.002)
				call BlzFrameSetTextAlignment(MY_ICON_EX_TEXT[i],TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_RIGHT)
				call BlzFrameSetPoint(MY_ICON_EX_BACKDROP[i],FRAMEPOINT_BOTTOMRIGHT,MY_ICON_EX_TEXT[i],FRAMEPOINT_BOTTOMRIGHT,0.002,-0.002)
				call BlzFrameSetPoint(MY_ICON_EX_BACKDROP[i],FRAMEPOINT_TOPLEFT,MY_ICON_EX_TEXT[i],FRAMEPOINT_TOPLEFT,-0.002,0.002)
				call BlzFrameSetVisible(MY_ICON_EX_BACKDROP[i],false)
				set MY_ICON_MOUSEOVER[i] = BlzCreateFrameByType("FRAME","",MY_ICON_OUTLINE[i],"",0)
				call BlzFrameSetAllPoints(MY_ICON_MOUSEOVER[i],MY_ICON_OUTLINE[i])
				set MY_TOOLTIP_CONTAINER[i] = BlzCreateFrameByType("FRAME","",MY_ICON_OUTLINE[i],"",0)
				call BlzFrameSetTooltip(MY_ICON_MOUSEOVER[i],MY_TOOLTIP_CONTAINER[i])
				set MY_TOOLTIP_BACKDROP[i] = BlzCreateFrameByType("BACKDROP","",MY_TOOLTIP_CONTAINER[i],"",0)
				call BlzFrameSetTexture(MY_TOOLTIP_BACKDROP[i],"textures\\black32.blp",0,true)
				call BlzFrameSetAlpha(MY_TOOLTIP_BACKDROP[i],128)
				set MY_TOOLTIP_TEXT[i] = BlzCreateFrame("MyText",MY_TOOLTIP_CONTAINER[i],0,0)
				call BlzFrameSetPoint(MY_TOOLTIP_TEXT[i],FRAMEPOINT_TOPRIGHT,MY_ICON_OUTLINE[i],FRAMEPOINT_BOTTOMRIGHT,-0.004,-0.004)
				call BlzFrameSetTextAlignment(MY_TOOLTIP_TEXT[i],TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_LEFT)
				call BlzFrameSetPoint(MY_TOOLTIP_BACKDROP[i],FRAMEPOINT_BOTTOMLEFT,MY_TOOLTIP_TEXT[i],FRAMEPOINT_BOTTOMLEFT,-0.004,-0.004)
				call BlzFrameSetPoint(MY_TOOLTIP_BACKDROP[i],FRAMEPOINT_TOPRIGHT,MY_TOOLTIP_TEXT[i],FRAMEPOINT_TOPRIGHT,0.004,0.004)
				set i = i + 1
			endloop
		endmethod

		static method create takes player p returns thistype
			local thistype this = GetPlayerId(p)
			if not INIT then
				call initFrames()
				set INIT = true
			endif
			set .target = 0
			return this
		endmethod

	endstruct

	struct Scouter extends array

		private static constant integer WIDTH = 360
		private static constant integer INSET = 16
		private static constant integer MY_ICON_SIZE = 64
		private static constant integer HEIGHT = 64 + 16 + 16
		private static constant integer BAR_WIDTH = 360 - 16 - 16 - 64
		private static constant integer BAR_HEIGHT = 16
		private static constant integer MY_NAME_HEIGHT = (64+16+16) - 16 - 16 - 16 - 16

		static boolean INIT = false
		static trigger CLICK_TRIGGER = null

		timer main_timer
		boolean timer_running
		Unit target
		boolean fix

		method refreshPeriodic takes nothing returns nothing
			local real max = 0.
			local real pos = 0.
			/*체력바 조작*/
			set max = .target.maxhp + Shield(.target).shield_amount
			set pos = .target.hp / max
			if GetLocalPlayer() == Player(this) then
				/*쉴드게이지 없으면 숨김*/
				call BlzFrameSetVisible(MY_SP_FILL,Shield(.target).shield_amount > 0.)
				call BlzFrameClearAllPoints(MY_SP_FILL)
				call BlzFrameSetPointPixel(MY_SP_FILL,FRAMEPOINT_LEFT,MY_HP_BACKDROP,FRAMEPOINT_LEFT,BAR_WIDTH*pos,0.)
				call BlzFrameSetSizePixel(MY_SP_FILL,BAR_WIDTH*(Shield(.target).shield_amount/max),BAR_HEIGHT)
				/*체력바*/
				call BlzFrameSetVisible(MY_HP_FILL,pos>0.005)
				call BlzFrameSetSizePixel(MY_HP_FILL,BAR_WIDTH*pos,BAR_HEIGHT)
				call BlzFrameSetText(MY_HP_TEXT,I2S(MathRound(.target.hp))+" / "+I2S(MathRound(.target.maxhp)))
			endif
			/*마나바*/
			set max = .target.maxmp
			set pos = .target.mp / max
			if GetLocalPlayer() == Player(this) then
				if max > 0. then
					call BlzFrameSetVisible(MY_MP_FILL,pos>0.005)
					call BlzFrameSetSizePixel(MY_MP_FILL,BAR_WIDTH*pos,BAR_HEIGHT)
				else
					call BlzFrameSetVisible(MY_MP_FILL,false)
				endif
				call BlzFrameSetText(MY_MP_TEXT,I2S(MathRound(.target.mp))+" / "+I2S(MathRound(.target.maxmp)))
			endif
			/*사망했으면*/
			if GetLocalPlayer() == Player(this) then
				call BlzFrameSetVisible(MY_DEATH_OVERLAY,.target.isUnitType(UNIT_TYPE_DEAD))
			endif
			/*버프인디케이터*/
			call BuffIndicatorForScouter(this).refreshIconsTarget()
		endmethod

		method refresh takes nothing returns nothing
			/*유닛 아이콘&이름 변경*/
			if GetLocalPlayer() == Player(this) then
				call BlzFrameSetTexture(MY_ICON,UnitData.getIconPath(.target.id),0,true)
				call BlzFrameSetText(MY_NAME,.target.origin_name)
				call BlzFrameSetTexture(MY_TEAMCOLOR,User.teamColorTexture(.target.owner),0,true)
			endif
			call refreshPeriodic()
		endmethod

		method show takes boolean flag returns nothing
			if GetLocalPlayer() == Player(this) then
				call BlzFrameSetVisible(MY_CONTAINER,flag)
			endif
		endmethod

		method cancleFilter takes nothing returns boolean
			if .target <= 0 then
				return true
			endif
			if not .target.is_revive and .target.isUnitType(UNIT_TYPE_DEAD) then
				return true
			endif
			if not .target.isVisible(Player(this)) then
				return true
			endif
			return false
		endmethod

		static method timerCallback takes nothing returns nothing
			local thistype this = Timer.getData(GetExpiredTimer())
			if cancleFilter() then
				call setTarget(0)
				return
			endif
			call refreshPeriodic()
		endmethod

		method runTimer takes boolean b returns nothing
			if b then
				if not .timer_running then
					call Timer.start(.main_timer,0.1,true,function thistype.timerCallback)
				endif
				set .timer_running = true
			else
				call Timer.pause(.main_timer)
				set .timer_running = false
			endif
		endmethod

		method setTarget takes Unit u returns nothing
			set .target = u
			if u <= 0 then
				/*숨기기&타이머정지*/
				call show(false)
				call runTimer(false)
			else
				/*보이기&타이머 가동*/
				call show(true)
				call runTimer(true)
				call refresh()
			endif
			call BuffIndicatorForScouter(this).setTarget(u)
		endmethod

		static method clickCallback takes nothing returns nothing
			local thistype this = GetPlayerId(CUSTOM_RESPOND_CLICK_PLAYER)
			local Unit u = 0
			if GetUnitAbilityLevel(CUSTOM_RESPOND_CLICK_TARGET,CONFIG_ABILITY_ID_CLASS_NONUNIT) != 0 then
				/*논유닛이면 컷*/
				return
			endif
			if CUSTOM_RESPOND_CLICK_BUTTON_TYPE == MOUSE_BUTTON_TYPE_LEFT then
				set u = Unit_prototype.get(CUSTOM_RESPOND_CLICK_TARGET)
				if u > 0 /*and UnitClass(u).getClass(ENUM_UNIT_CLASS_BOSS) <= 0*/ then
					call setTarget(u)
				endif
			endif
		endmethod

		static method initFrames takes nothing returns nothing
			/*트리거*/
			set CLICK_TRIGGER = CreateTrigger()
			call Event.register(CLICK_TRIGGER,ENUM_EVENT_CLICK)
			call TriggerAddCondition(CLICK_TRIGGER,function thistype.clickCallback)
			/*컨테이너*/
			set MY_CONTAINER = BlzCreateFrame("MBEdge",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],0,0)
			call BlzFrameSetSizePixel(MY_CONTAINER,WIDTH,HEIGHT)
			call BlzFrameSetPoint(MY_CONTAINER,FRAMEPOINT_TOPRIGHT,FRAME_ORIGIN,FRAMEPOINT_TOPRIGHT,0.,0.)
			set MY_TEAMCOLOR = BlzCreateFrameByType("BACKDROP","",MY_CONTAINER,"",0)
			call BlzFrameSetPointPixel(MY_TEAMCOLOR,FRAMEPOINT_TOPLEFT,MY_CONTAINER,FRAMEPOINT_TOPLEFT,INSET,-INSET)
			call BlzFrameSetPointPixel(MY_TEAMCOLOR,FRAMEPOINT_BOTTOMRIGHT,MY_CONTAINER,FRAMEPOINT_BOTTOMRIGHT,-INSET,INSET)
			call BlzFrameSetAlpha(MY_TEAMCOLOR,128)
			set MY_ICON = BlzCreateFrameByType("BACKDROP","",MY_CONTAINER,"",0)
			call BlzFrameSetPointPixel(MY_ICON,FRAMEPOINT_TOPLEFT,MY_CONTAINER,FRAMEPOINT_TOPLEFT,INSET,-INSET)
			call BlzFrameSetSizePixel(MY_ICON,MY_ICON_SIZE,MY_ICON_SIZE)
			set MY_DEATH_OVERLAY = BlzCreateFrameByType("BACKDROP","",MY_CONTAINER,"",0)
			call BlzFrameSetAllPoints(MY_DEATH_OVERLAY,MY_ICON)
			call BlzFrameSetTexture(MY_DEATH_OVERLAY,"textures\\black32.blp",0,true)
			call BlzFrameSetAlpha(MY_DEATH_OVERLAY,192)
			call BlzFrameSetVisible(MY_DEATH_OVERLAY,false)
			set MY_MP_BACKDROP = BlzCreateFrameByType("BACKDROP","",MY_CONTAINER,"",0)
			call BlzFrameSetPointPixel(MY_MP_BACKDROP,FRAMEPOINT_BOTTOMLEFT,MY_ICON,FRAMEPOINT_BOTTOMRIGHT,0.,0.)
			call BlzFrameSetSizePixel(MY_MP_BACKDROP,BAR_WIDTH,BAR_HEIGHT)
			call BlzFrameSetTexture(MY_MP_BACKDROP,"ReplaceableTextures\\teamcolor\\teamcolor13.blp",0,true)
			set MY_MP_FILL = BlzCreateFrameByType("BACKDROP","",MY_CONTAINER,"",0)
			call BlzFrameSetPointPixel(MY_MP_FILL,FRAMEPOINT_BOTTOMLEFT,MY_MP_BACKDROP,FRAMEPOINT_BOTTOMLEFT,0.,0.)
			call BlzFrameSetTexture(MY_MP_FILL,"replaceabletextures\\teamcolor\\teamcolor01.blp",0,true)
			set MY_MP_TEXT = BlzCreateFrame("MyTextSmall",MY_CONTAINER,0,0)
			call BlzFrameSetPoint(MY_MP_TEXT,FRAMEPOINT_CENTER,MY_MP_BACKDROP,FRAMEPOINT_CENTER,0,0)
			set MY_HP_BACKDROP = BlzCreateFrameByType("BACKDROP","",MY_CONTAINER,"",0)
			call BlzFrameSetPointPixel(MY_HP_BACKDROP,FRAMEPOINT_BOTTOMLEFT,MY_MP_BACKDROP,FRAMEPOINT_TOPLEFT,0.,0.)
			call BlzFrameSetSizePixel(MY_HP_BACKDROP,BAR_WIDTH,BAR_HEIGHT)
			call BlzFrameSetTexture(MY_HP_BACKDROP,"ReplaceableTextures\\teamcolor\\teamcolor10.blp",0,true)
			set MY_HP_FILL = BlzCreateFrameByType("BACKDROP","",MY_CONTAINER,"",0)
			call BlzFrameSetPointPixel(MY_HP_FILL,FRAMEPOINT_BOTTOMLEFT,MY_HP_BACKDROP,FRAMEPOINT_BOTTOMLEFT,0.,0.)
			call BlzFrameSetTexture(MY_HP_FILL,"replaceabletextures\\teamcolor\\teamcolor06.blp",0,true)
			set MY_SP_FILL = BlzCreateFrameByType("BACKDROP","",MY_CONTAINER,"",0)
			call BlzFrameSetPointPixel(MY_SP_FILL,FRAMEPOINT_LEFT,MY_HP_FILL,FRAMEPOINT_RIGHT,0.,0.)
			call BlzFrameSetTexture(MY_SP_FILL,"replaceabletextures\\teamcolor\\teamcolor19.blp",0,true)
			set MY_HP_TEXT = BlzCreateFrame("MyTextSmall",MY_CONTAINER,0,0)
			call BlzFrameSetPoint(MY_HP_TEXT,FRAMEPOINT_CENTER,MY_HP_BACKDROP,FRAMEPOINT_CENTER,0,0)
			set MY_NAME = BlzCreateFrame("MyText",MY_CONTAINER,0,0)
			call BlzFrameSetPointPixel(MY_NAME,FRAMEPOINT_CENTER,MY_HP_BACKDROP,FRAMEPOINT_TOP,0,MY_NAME_HEIGHT/2)
			call BlzFrameSetSizePixel(MY_NAME,BAR_WIDTH,MY_NAME_HEIGHT)
			/*일단 숨김*/
			call BlzFrameSetVisible(MY_CONTAINER,false)
		endmethod

		static method create takes player p returns thistype
			local thistype this = GetPlayerId(p)
			if not INIT then
				call initFrames()
				set INIT = true
			endif
			set .main_timer = Timer.new(this)
			set .timer_running = false
			set .fix = true
			call BuffIndicatorForScouter.create(p)
			return this
		endmethod

		method destroy takes nothing returns nothing
			call Timer.release(.main_timer)
			set .main_timer = null
			set .timer_running = false
		endmethod

	endstruct

endlibrary