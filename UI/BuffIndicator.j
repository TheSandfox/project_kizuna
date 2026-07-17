library BuffIndicator requires Frame

	globals
		//! textmacro BuffIndicator_globals
		private constant integer BUFF_ICONS_MAX = 20
		private constant integer PER_ROW = 10
		private constant integer SIZE = 36
		private constant integer INSET = 2
		private framehandle MY_BUFF_CONTAINER = null
		private framehandle array MY_ICON_OUTLINE
		private framehandle array MY_ICON_BACKDROP
		private framehandle array MY_ICON_COOLDOWN
		private framehandle array MY_ICON_MOUSEOVER
		private framehandle array MY_ICON_EX_BACKDROP
		private framehandle array MY_ICON_EX_TEXT
		private framehandle array MY_TOOLTIP_CONTAINER
		private framehandle array MY_TOOLTIP_BACKDROP
		private framehandle array MY_TOOLTIP_TEXT
		//! endtextmacro
		//! runtextmacro BuffIndicator_globals()
	endglobals

	struct BuffIndicator extends array

		static boolean INIT = false

		Unit target
		timer main_timer

		//! textmacro buffIndicatorSetIconTarget
		method setIconTarget takes integer index, Buff b returns nothing
			if b <= 0 then
				if GetLocalPlayer() == Player(this) then
					call BlzFrameSetVisible(MY_ICON_OUTLINE[index],false)
				endif
				return
			endif	
			if GetLocalPlayer() == Player(this) then
				call BlzFrameSetVisible(MY_ICON_OUTLINE[index],true)
				if b.positive == 1 then
					/*양성버프*/
					call BlzFrameSetTexture(MY_ICON_OUTLINE[index],"replaceabletextures\\teamcolor\\teamcolor22.blp",0,true)
					call BlzFrameSetTexture(MY_ICON_COOLDOWN[index],"replaceabletextures\\teamcolor\\teamcolor06.blp",0,true)
					/*툴팁*/
					call BlzFrameSetText(MY_TOOLTIP_TEXT[index],"|cff00ff00"+b.name+"|r\n\n"+b.relativeTooltip())
				elseif b.positive == 0 then
					/*음성버프*/
					call BlzFrameSetTexture(MY_ICON_OUTLINE[index],"replaceabletextures\\teamcolor\\teamcolor12.blp",0,true)
					call BlzFrameSetTexture(MY_ICON_COOLDOWN[index],"replaceabletextures\\teamcolor\\teamcolor00.blp",0,true)
					/*툴팁*/
					call BlzFrameSetText(MY_TOOLTIP_TEXT[index],"|cffff0000"+b.name+"|r\n\n"+b.relativeTooltip())
				else
					/*중성버프*/
					call BlzFrameSetTexture(MY_ICON_OUTLINE[index],"replaceabletextures\\teamcolor\\teamcolor08.blp",0,true)
					call BlzFrameSetTexture(MY_ICON_COOLDOWN[index],"replaceabletextures\\teamcolor\\teamcolor21.blp",0,true)
					/*툴팁*/
					call BlzFrameSetText(MY_TOOLTIP_TEXT[index],b.name+"\n\n"+b.relativeTooltip())
				endif
				/*엑스트라*/
				call BlzFrameSetVisible(MY_ICON_EX_BACKDROP[index],b.extra!="")
				call BlzFrameSetText(MY_ICON_EX_TEXT[index],b.extra)
				/*아이콘*/
				call BlzFrameSetTexture(MY_ICON_BACKDROP[index],Buff.getTypeIconPath(b.id),0,true)
				/*쿨다운*/
				if b.duration_max > 0. then
					call BlzFrameSetPointPixel(MY_ICON_COOLDOWN[index],FRAMEPOINT_TOPRIGHT,MY_ICON_OUTLINE[index],FRAMEPOINT_BOTTOMRIGHT,0.,SIZE*b.duration/b.duration_max)
				else
					call BlzFrameSetPointPixel(MY_ICON_COOLDOWN[index],FRAMEPOINT_TOPRIGHT,MY_ICON_OUTLINE[index],FRAMEPOINT_BOTTOMRIGHT,0.,SIZE)
				endif
			endif
		endmethod
		//! endtextmacro

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

		static method timerCallback takes nothing returns nothing
			local thistype this = Timer.getData(GetExpiredTimer())
			call refreshIconsTarget()
		endmethod

		method runTimer takes boolean flag returns nothing
			if flag then
				call Timer.start(.main_timer,0.1,true,function thistype.timerCallback)
			else
				call Timer.pause(.main_timer)
			endif
		endmethod

		method setTarget takes Unit u returns nothing
			set .target = u
			if GetLocalPlayer() == Player(this) then
				call BlzFrameSetVisible(MY_BUFF_CONTAINER,u>0)
			endif
			if u > 0 then
				call refreshIconsTarget()
				call runTimer(true)
			else
				call runTimer(false)
			endif
		endmethod

		static method initFrames takes nothing returns nothing
			local integer i = 0
			set MY_BUFF_CONTAINER = BlzCreateFrame("NonFocusFrame",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],0,0)
			call BlzFrameSetPointPixel(MY_BUFF_CONTAINER,FRAMEPOINT_BOTTOMLEFT,FRAME_SP_BAR,FRAMEPOINT_TOPLEFT,0.,4)
			call BlzFrameSetSizePixel(MY_BUFF_CONTAINER,16,16)
			loop
				exitwhen i >= BUFF_ICONS_MAX
				set MY_ICON_OUTLINE[i] = BlzCreateFrameByType("BACKDROP","",MY_BUFF_CONTAINER,"",0)
				call BlzFrameSetPointPixel(MY_ICON_OUTLINE[i],FRAMEPOINT_BOTTOMLEFT,MY_BUFF_CONTAINER,FRAMEPOINT_BOTTOMLEFT,/*
				*/(SIZE+INSET)*ModuloInteger(i,PER_ROW)+INSET,(SIZE+INSET)*R2I(i/PER_ROW)+INSET/*
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
				call BlzFrameSetPoint(MY_TOOLTIP_TEXT[i],FRAMEPOINT_BOTTOMLEFT,MY_ICON_OUTLINE[i],FRAMEPOINT_TOPLEFT,0.004,0.004)
				call BlzFrameSetTextAlignment(MY_TOOLTIP_TEXT[i],TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_LEFT)
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
			set .main_timer = Timer.new(this)
			return this
		endmethod

	endstruct

endlibrary