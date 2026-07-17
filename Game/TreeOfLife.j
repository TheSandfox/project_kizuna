library TreeOfLife
	
	struct TreeOfLife

		static constant integer WIDTH = 360
		static constant integer HEIGHT = 16
		static constant integer INSET = 8
		static constant integer ICON_SIZE = 48
		static constant string EFFECT_PATH1 = "buildings\\nightelf\\TreeofLife\\TreeofLife.mdl"
		static constant string EFFECT_PATH2 = "Objects\\Spawnmodels\\Undead\\UndeadDissipate\\UndeadDissipate.mdl"

		static real RANGE = 400.
		static integer LEVEL = 1
		static Unit UNIT = 0
		private static constant real TICK = 0.5
		private static real MAXHP_TRUE = 10000.
		private static real HP_TRUE = 10000.
		static timer MAIN_TIMER = null
		static framehandle BACKDROP = null
		static framehandle BUTTON = null
		static framehandle ICON = null
		static framehandle NAME = null
		static framehandle DEATH_OVERLAY = null
		static framehandle GAUGE_BACKDROP = null
		static framehandle GAUGE_FILL = null
		static framehandle HP_TEXT = null
		static boolean IN = false /*local*/
		static trigger MAIN_TRIGGER = null
		static triggercondition MAIN_COND = null

		static method operator X takes nothing returns real
			return GetRectCenterX(gg_rct_TreeOfLife)
		endmethod

		static method operator Y takes nothing returns real
			return GetRectCenterY(gg_rct_TreeOfLife)
		endmethod

		static method refreshFrame takes nothing returns nothing
			local real v = UNIT.hp/UNIT.maxhp
			call BlzFrameSetVisible(DEATH_OVERLAY,UNIT.hp <= 0.)
			call BlzFrameSetVisible(GAUGE_FILL,v > 0.025)
			call BlzFrameSetSizePixel(GAUGE_FILL,(WIDTH-ICON_SIZE-INSET*2)*v,HEIGHT)
			call BlzFrameSetText(HP_TEXT,I2S(R2I(UNIT.hp))+" / "+I2S(R2I(UNIT.maxhp)))
		endmethod

		static method operator HP= takes real nv returns nothing
			set UNIT.hp = nv
			call refreshFrame()
		endmethod

		static method operator HP takes nothing returns real
			return UNIT.hp
		endmethod

		static method operator MAXHP takes nothing returns real
			return UNIT.maxhp
		endmethod

		static method addLevel takes nothing returns nothing
			set UNIT.level = UNIT.level + 1
		endmethod

		static method timerAction takes nothing returns nothing
			local integer i = GetRandomInt(0,2)
			local unit u = null
			local Unit ud = 0
			local real r = 0.
			local Effect ef = 0
			local string s
			set i = 0
			loop
				set u = BlzGroupUnitAt(Undead_GROUP,i)
				//exitwhen i >= BlzGroupGetSize(Undead_GROUP)
				exitwhen u == null
				set ud = Unit_prototype.get(u)
				if ud.inRange(X,Y,RANGE) and not ud.isUnitType(UNIT_TYPE_DEAD) then
					set r = Damage.damageTarget(ud,ud.maxhp*0.1)
					set HP = HP - r
					call Effect.create(EFFECT_PATH2,ud.x,ud.y,0.,270.).setScale(0.75).kill()
				endif
				set i = i + 1
				set u = null
			endloop
			call refreshFrame()
			if UNIT.isUnitType(UNIT_TYPE_DEAD) then
				call end()
			endif
			set u = null
		endmethod

		static method cond takes nothing returns nothing
			if GetTriggerPlayer() == GetLocalPlayer() then
				call BlzFrameSetEnable(BUTTON,false)
				call BlzFrameSetEnable(BUTTON,true)
				if BlzGetTriggerFrameEvent() == FRAMEEVENT_MOUSE_ENTER then
					set IN = true
				elseif BlzGetTriggerFrameEvent() == FRAMEEVENT_MOUSE_LEAVE then
					set IN = false
				elseif BlzGetTriggerPlayerMouseButton() == MOUSE_BUTTON_TYPE_LEFT then
					if IN then
						call PanCameraToTimed(X,Y,0.)
					endif
				endif
			endif
		endmethod

		static method init takes nothing returns nothing
			local integer i = 0
			set MAIN_TRIGGER = Trigger.new(0)
			set MAIN_COND = TriggerAddCondition(MAIN_TRIGGER,function thistype.cond)
			set UNIT = Unit.create(CONFIG_PLAYER_GUARDIANS,'G001',X,Y,270.)
			//나무 능력치
			call UNIT.setStatValue(CONFIG_STAT_MAXHP,CONFIG_STAT_INDEX_BASE,10000.0)
			call UNIT.setStatValue(CONFIG_STAT_MAXHP,CONFIG_STAT_INDEX_LEVEL,1000.0)
			call UNIT.refreshStatValue(CONFIG_STAT_MAXHP)
			call UNIT.setStatValue(CONFIG_STAT_HPREGEN,CONFIG_STAT_INDEX_BASE,40.0)
			call UNIT.setStatValue(CONFIG_STAT_HPREGEN,CONFIG_STAT_INDEX_LEVEL,4.0)
			//
			call UNIT.setAnim("stand alternate upgrade first second")
			call UNIT.plusStatus(CONFIG_STATUS_CAST)
			call UNIT.plusStatus(CONFIG_STATUS_INVINCIBLE)
			call UNIT.facing_circle.setScale(128./100.)
			set UNIT.x = X
			set UNIT.y = Y
			set MAIN_TIMER = Timer.new(0)
			call Timer.start(MAIN_TIMER,TICK,true,function thistype.timerAction)
			/*프레임*/
			set BACKDROP = BlzCreateFrameByType("BACKDROP","",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],"",0)
			call BlzFrameSetPointPixel(BACKDROP,FRAMEPOINT_BOTTOMLEFT,FRAME_PORTRAIT_BACKDROP,FRAMEPOINT_TOPLEFT,0,0)
			call BlzFrameSetSizePixel(BACKDROP,WIDTH,ICON_SIZE+INSET*2)
			call BlzFrameSetTexture(BACKDROP,"Textures\\black32.blp",0,true)
			call BlzFrameSetAlpha(BACKDROP,64)
			set ICON = BlzCreateFrameByType("BACKDROP","",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],"",0)
			call BlzFrameSetPointPixel(ICON,FRAMEPOINT_TOPLEFT,BACKDROP,FRAMEPOINT_TOPLEFT,INSET,-INSET)
			call BlzFrameSetSizePixel(ICON,ICON_SIZE,ICON_SIZE)
			call BlzFrameSetTexture(ICON,"ReplaceableTextures\\CommandButtons\\BTNTreeOfLife.blp",0,true)
			set DEATH_OVERLAY = BlzCreateFrameByType("BACKDROP","",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],"",0)
			call BlzFrameSetAllPoints(DEATH_OVERLAY,ICON)
			call BlzFrameSetTexture(DEATH_OVERLAY,"ReplaceableTextures\\teamcolor\\teamcolor00.blp",0,true)
			call BlzFrameSetAlpha(DEATH_OVERLAY,128)
			call BlzFrameSetVisible(DEATH_OVERLAY,false)
			set BUTTON = BlzCreateFrameByType("BUTTON","",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],"",0)
			call BlzFrameSetAllPoints(BUTTON,ICON)
			call BlzTriggerRegisterFrameEvent(MAIN_TRIGGER,BUTTON,FRAMEEVENT_MOUSE_LEAVE)
			call BlzTriggerRegisterFrameEvent(MAIN_TRIGGER,BUTTON,FRAMEEVENT_MOUSE_ENTER)
			loop
				exitwhen i >= CONFIG_PLAYER_MAX
				call TriggerRegisterPlayerEvent(MAIN_TRIGGER,Player(i),EVENT_PLAYER_MOUSE_DOWN)
				set i = i + 1
			endloop
			set GAUGE_BACKDROP = BlzCreateFrameByType("BACKDROP","",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],"",0)
			call BlzFrameSetPoint(GAUGE_BACKDROP,FRAMEPOINT_BOTTOMLEFT,ICON,FRAMEPOINT_BOTTOMRIGHT,0.,0.)
			call BlzFrameSetSizePixel(GAUGE_BACKDROP,WIDTH-ICON_SIZE-INSET*2,HEIGHT)
			call BlzFrameSetTexture(GAUGE_BACKDROP,"ReplaceableTextures\\teamcolor\\teamcolor00.blp",0,true)
			call BlzFrameSetAlpha(GAUGE_BACKDROP,128)
			set GAUGE_FILL = BlzCreateFrameByType("BACKDROP","",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],"",0)
			call BlzFrameSetPoint(GAUGE_FILL,FRAMEPOINT_BOTTOMLEFT,GAUGE_BACKDROP,FRAMEPOINT_BOTTOMLEFT,0.,0.)
			call BlzFrameSetTexture(GAUGE_FILL,"ReplaceableTextures\\teamcolor\\teamcolor06.blp",0,true)
			call BlzFrameSetVisible(GAUGE_FILL,false)
			set HP_TEXT = BlzCreateFrame("MyText",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],0,0)
			call BlzFrameSetPoint(HP_TEXT,FRAMEPOINT_CENTER,GAUGE_BACKDROP,FRAMEPOINT_CENTER,0.,0.)
			call refreshFrame()
			set NAME = BlzCreateFrame("MyText",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],0,0)
			call BlzFrameSetPointPixel(NAME,FRAMEPOINT_CENTER,BACKDROP,FRAMEPOINT_CENTER,ICON_SIZE/2,8)
			call BlzFrameSetTextAlignment(NAME,TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_MIDDLE)
			call BlzFrameSetText(NAME,"생명의 나무")
		endmethod

		static method end takes nothing returns nothing
			call Timer.pause(MAIN_TIMER)
			call Game.defeat()
		endmethod

	endstruct

endlibrary