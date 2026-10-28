library UI requires User, Frame

	globals
		private trigger FRAME_BUTTON_TRIGGER = null

		framehandle FRAME_MINIMAP = null
		framehandle FRAME_MINIMAP_BACKDROP = null
		framehandle FRAME_PORTRAIT = null
		framehandle FRAME_PORTRAIT_BACKDROP = null
		framehandle FRAME_HP_BAR = null
		framehandle FRAME_MP_BAR = null
		framehandle FRAME_SP_BAR = null
		framehandle FRAME_ABILITY_CONTAINER = null
		framehandle FRAME_STAT1	= null
		framehandle FRAME_STAT2	= null
		framehandle FRAME_STAT_INDICATOR_BUTTON = null
		framehandle FRAME_EXP_BAR = null
		framehandle FRAME_SKILL_SHOP = null
		framehandle FRAME_SKILL_SHOP_BACKDROP = null
		framehandle FRAME_SKILL_SHOP_BUTTON = null
		framehandle FRAME_SLOT_CHANGER = null
		framehandle FRAME_SLOT_CHANGER_BUTTON = null
		framehandle FRAME_INVENTORY = null
		framehandle FRAME_INVENTORY_BUTTON = null
		framehandle FRAME_CRAFT = null
		framehandle FRAME_CRAFT_BUTTON = null
		framehandle FRAME_CRAFT_BUTTON_TOOLTIP = null
		//framehandle FRAME_MAKE_POTION = null
		framehandle FRAME_UNRIDE_ICON = null
		framehandle FRAME_UNRIDE_ICON_BACKDROP = null
		framehandle FRAME_UNGRAB_ICON = null
		framehandle FRAME_UNGRAB_ICON_BACKDROP = null
		framehandle FRAME_ABILITY_MANAGER = null
		framehandle FRAME_ABILITY_MANAGER_BUTTON = null
		framehandle array FRAME_ABILITY_ICON[10]
		framehandle array FRAME_INVENTORY_CATEGORY_BUTTON
		framehandle array FRAME_INVENTORY_CATEGORY_HIGHTLIGHT

		private constant integer PORTRAIT_SIZE = 96
		private constant integer PORTRAIT_OFFSET_Y = 64//160
		private constant integer PORTRAIT_OFFSET_X = -360-96-264
		private constant integer PORTRAIT_BORDER = 0
		private constant integer BAR_WIDTH = 720
		private constant integer BAR_HEIGHT = 24
		private constant integer HP_BAR_OFFSET_Y = 136
		private constant integer MP_BAR_OFFSET_Y = 112
		private constant integer SP_BAR_OFFSET_Y = 160
		private constant integer ABILITY_CONTAINER_WIDTH = 720
		private constant integer ABILITY_CONTAINER_HEIGHT = 96
		private constant integer ABILITY_CONTAINER_OFFSET_Y = 16
		private constant integer ABILITY_ICON_SIZE = 64
		private constant integer ABILITY_TOOLTIP_OFFSET_Y = 160
		private constant integer CHINGHO_HEIGHT = 32
		private constant integer STAT1_WIDTH = 264
		private constant integer STAT2_WIDTH = 48*8 + 64//640 -32 -32 -32
		private constant integer STAT2_HEIGHT = 48*4 + 64 + 64
		private constant integer EXP_BAR_HEIGHT = 12
		private constant integer SKILL_SHOP_OFFSET_Y = -16	/*FROM TOP*/
		private constant integer SKILL_SHOP_WIDTH = 1280
		private constant integer SKILL_SHOP_HEIGHT = 396
		private constant integer SKILL_SHOP_INSET = 32
		private constant integer INVENTORY_WIDTH = 48*8 + 64	/* 64*8 + 64*/	
		private constant integer INVENTORY_HEIGHT = 48*4 + 64 + 40 /* 64*8 + 64 + 40 */
		private constant integer INVENTORY_OFFSET_X = 0
		private constant integer INVENTORY_OFFSET_Y = 16+96+24+24+96
		private constant integer CRAFT_WIDTH = 480
		private constant integer ABILITY_ERROR_OFFSET_Y = 268-96 /*FROM BOTTOM*/
		private constant integer SLOT_CHANGER_WIDTH = 720//(64*10)+16
		private constant integer SLOT_CHANGER_HEIGHT = 96 + 24 + 24 //(64*3)+16
		private constant integer SLOT_CHANGER_OFFSET_Y = 16 /*FROM BOTTOM*/
		private constant integer ABILITY_MANAGER_WIDTH = 1440 - STAT2_WIDTH - INVENTORY_WIDTH
		private constant integer ABILITY_MANAGER_HEIGHT = 440
	endglobals

	struct ChinghoFrame

		integer id = 0

		framehandle backdrop = null
		framehandle icon1 = null
		framehandle icon2 = null
		framehandle name = null

		method setTarget takes integer cid returns nothing
			set .id = cid
			if cid > 0 then
				call BlzFrameSetTexture(.icon1,Ability.getTypeIconPath(cid),0,true)
				call BlzFrameSetTexture(.icon2,Ability.getTypeIconPath(cid),0,true)
				call BlzFrameSetText(.name,Ability.getTypeName(cid))
			elseif cid < 0 then
				call BlzFrameSetTexture(.icon1,"ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",0,true)
				call BlzFrameSetTexture(.icon2,"ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",0,true)
				call BlzFrameSetText(.name,"???")
			else
				call BlzFrameSetTexture(.icon1,"Icons\\BTNBlackIcon.blp",0,true)
				call BlzFrameSetTexture(.icon2,"Icons\\BTNBlackIcon.blp",0,true)
				call BlzFrameSetText(.name,"")
			endif
		endmethod

		static method create takes framehandle parent, framehandle pivot returns thistype
			local thistype this = allocate()
			set .backdrop = BlzCreateFrameByType("BACKDROP","",parent,"",0)
			call BlzFrameSetPoint(.backdrop,FRAMEPOINT_TOPLEFT,pivot,FRAMEPOINT_TOPLEFT,0.,0.)
			call BlzFrameSetSize(.backdrop,Math.px2Size(STAT1_WIDTH),Math.px2Size(CHINGHO_HEIGHT))
			call BlzFrameSetTexture(.backdrop,"textures\\black32.blp",0,true)
			set .icon1 = BlzCreateFrameByType("BACKDROP","",.backdrop,"",0)
			call BlzFrameSetPoint(.icon1,FRAMEPOINT_TOPLEFT,.backdrop,FRAMEPOINT_TOPLEFT,0.,0.)
			call BlzFrameSetSize(.icon1,Math.px2Size(CHINGHO_HEIGHT),Math.px2Size(CHINGHO_HEIGHT))
			call BlzFrameSetTexture(.icon1,"textures\\black32.blp",0,true)
			set .icon2 = BlzCreateFrameByType("BACKDROP","",.backdrop,"",0)
			call BlzFrameSetPoint(.icon2,FRAMEPOINT_TOPRIGHT,.backdrop,FRAMEPOINT_TOPRIGHT,0.,0.)
			call BlzFrameSetSize(.icon2,Math.px2Size(CHINGHO_HEIGHT),Math.px2Size(CHINGHO_HEIGHT))
			call BlzFrameSetTexture(.icon2,"textures\\black32.blp",0,true)
			set .name = BlzCreateFrame("MyTextSmall",.backdrop,0,0)
			call BlzFrameSetAllPoints(.name,.backdrop)
			call BlzFrameSetTextAlignment(.name,TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_CENTER)
			call setTarget(0)
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			//! runtextmacro destroyFrame(".backdrop")
			//! runtextmacro destroyFrame(".icon1")
			//! runtextmacro destroyFrame(".icon2")
			//! runtextmacro destroyFrame(".name")
		endmethod

	endstruct

	struct IconFrame

	endstruct

	struct BuffIcon extends IconFrame

	endstruct

	//! import "AbilityIcon.j"

	//! import "StatIndicator.j"

	struct UI extends array

		private static boolean FLAG_FRAME = false
		
		private static framehandle CONTAINER
		private static framehandle HP_FILL
		private static framehandle HP_TEXT
		private static framehandle HP_ICON
		private static framehandle MP_FILL
		private static framehandle MP_TEXT
		private static framehandle MP_ICON
		private static framehandle SP_FILL
		private static framehandle SP_TEXT
		private static framehandle LEVEL_BACKDROP
		private static framehandle LEVEL_TEXT
		private static framehandle EXP_FILL
		private static framehandle EXP_TEXT
		private static framehandle NAME
		private static framehandle ABILITY_ERROR

		Unit target

		timer main_timer
		
		ChinghoFrame chingho		
		
		real ability_error_lifespan 

		method owner takes nothing returns player
			return Player(this)
		endmethod

		method displayError takes nothing returns nothing
			if GetLocalPlayer() == Player(this) then
				call BlzFrameSetText(ABILITY_ERROR,CUSTOM_RESPOND_ERROR_MESSAGE)
				call PlaySoundBJ(gg_snd_Error)
			endif
			if CUSTOM_RESPOND_ERROR_TIME <= 0. then
				set .ability_error_lifespan = 2.0
			else
				set .ability_error_lifespan = CUSTOM_RESPOND_ERROR_TIME
			endif
		endmethod

		static method errorCondition takes nothing returns nothing
			local thistype this = GetPlayerId(CUSTOM_RESPOND_ERROR_PLAYER)
			call displayError()
		endmethod

		method refreshName takes nothing returns nothing
			if GetLocalPlayer() == Player(this) then
				call BlzFrameSetVisible(NAME,.target > 0)
				call BlzFrameSetText(NAME,.target.origin_name)
			endif
		endmethod

		method refreshStatIconsTarget takes nothing returns nothing
			call StatIndicator(this).refreshTarget(.target)
			// local integer i = 0
			// loop
			// 	exitwhen i >= STAT_ICONS_SIZE
			// 	call StatIcon.get(Player(this),i).setTarget(.target)
			// 	set i = i + 1
			// endloop
		endmethod

		method refreshStatIcons takes nothing returns nothing
			call StatIndicator(this).refresh()
			// local integer i = 0
			// if not StatIndicator(this).visible then
			// 	return
			// endif
			// loop
			// 	exitwhen i >= STAT_ICONS_SIZE
			// 	call StatIcon.get(Player(this),i).refresh()
			// 	set i = i + 1
			// endloop
		endmethod

		method refreshAbilityIconsTarget takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen i >= 10
				call AbilityIcon.getPlayerIcon(Player(this),i).setTarget(.target.getAbility(i))
				set i = i + 1
			endloop
		endmethod

		method refreshAbilityIcons takes nothing returns nothing
			local integer i = 0
			local AbilityIcon ai = 0
			loop
				exitwhen i >= 10
				set ai = AbilityIcon.getPlayerIcon(Player(this),i)
				call ai.refresh()
				if ai.mouse_in then
					call ai.refreshTooltip()
				endif
				set i = i + 1
			endloop
		endmethod

		method refreshPeriodic takes nothing returns nothing
			if GetLocalPlayer() == Player(this) then
				/*체력바*/
				call BlzFrameSetVisible(HP_FILL,.target.maxhp > 0.)
				call BlzFrameSetPoint(HP_FILL,FRAMEPOINT_TOPRIGHT,FRAME_HP_BAR,FRAMEPOINT_TOPLEFT,Math.px2Size(BAR_WIDTH)*(.target.hp/.target.maxhp),0.)
				call BlzFrameSetVisible(MP_FILL,.target.maxmp > 0.)
				if .target.maxmp > 0. then
					call BlzFrameSetPoint(MP_FILL,FRAMEPOINT_TOPRIGHT,FRAME_MP_BAR,FRAMEPOINT_TOPLEFT,Math.px2Size(BAR_WIDTH)*(.target.mp/.target.maxmp),0.)
				endif
				call BlzFrameSetText(HP_TEXT,I2S(MathRound(.target.hp))+" / "+I2S(MathRound(.target.maxhp))+" (+"+R2SW(.target.hpregen,1,1)+")")
				call BlzFrameSetVisible(MP_TEXT,.target.maxmp > 0.)
				call BlzFrameSetText(MP_TEXT,I2S(MathRound(.target.mp))+" / "+I2S(MathRound(.target.maxmp))+" (+"+R2SW(.target.mpregen,1,1)+")")
				/*쉴드게이지*/
				call BlzFrameSetVisible(FRAME_SP_BAR,Shield(.target).count > 0)
				call BlzFrameSetVisible(SP_FILL,Shield(.target).shield_max > 0.)
				if Shield(.target).shield_max > 0. then
					call BlzFrameSetPoint(SP_FILL,FRAMEPOINT_TOPRIGHT,FRAME_SP_BAR,FRAMEPOINT_TOPLEFT,Math.px2Size(BAR_WIDTH)*(Shield(.target).shield_amount/Shield(.target).shield_max),0.)
				endif
				call BlzFrameSetVisible(SP_TEXT,Shield(.target).count > 0)
				call BlzFrameSetText(SP_TEXT,I2S(MathRound(Shield(.target).shield_amount))+" / "+I2S(MathRound(Shield(.target).shield_max)))
				/*레벨*/
				call BlzFrameSetText(LEVEL_TEXT," Lv."+I2S(.target.level)+" ")
				/*경험치*/
				call BlzFrameSetVisible(EXP_FILL,.target.exp > 0.)
				call BlzFrameSetPoint(EXP_FILL,FRAMEPOINT_TOPRIGHT,FRAME_EXP_BAR,FRAMEPOINT_TOPLEFT,Math.px2Size(STAT1_WIDTH)*(I2R(.target.exp)/I2R(.target.exp_max)),0.)
				call BlzFrameSetText(EXP_TEXT,"|cff000000"+R2SW(I2R(.target.exp)/I2R(.target.exp_max),1,1)+"%|r")
			endif
			/*어빌아이콘*/
			call refreshAbilityIcons()
			/*스탯아이콘*/
			call refreshStatIcons()
			/*어빌리티 에러*/
			if .ability_error_lifespan > 0. then
				set .ability_error_lifespan = .ability_error_lifespan - 0.1
				if .ability_error_lifespan < 0. then
					set .ability_error_lifespan = 0.
					if GetLocalPlayer() == Player(this) then
						call BlzFrameSetText(ABILITY_ERROR,"")
					endif
				endif
			endif
		endmethod

		method setTarget takes Unit nt returns nothing
			set .target = nt
			call BuffIndicator(this).setTarget(nt)
			call refreshAbilityIconsTarget()
			call refreshStatIconsTarget()
			call refreshName()
			call .chingho.setTarget(.target.chingho.id)
			call refreshPeriodic()
		endmethod

		static method timerAction takes nothing returns nothing
			local thistype this = Timer.getData(GetExpiredTimer())
			call refreshPeriodic()
		endmethod

		static method onLevel takes nothing returns nothing
			local Unit u = CUSTOM_RESPOND_LEVEL_UNIT
			local thistype this = 0
			if CUSTOM_RESPOND_LEVEL_UNIT <= 0 then
				return
			endif
			set this = GetPlayerId(u.owner)
			call setTarget(.target)
		endmethod

		static method create takes player p returns thistype
			local thistype this = GetPlayerId(p)
			local integer i = 0
			local AbilityIcon ia = 0
			local StatIcon sa = 0
			set .main_timer = Timer.new(this)
			/*칭호*/
			set .chingho = ChinghoFrame.create(CONTAINER,FRAME_STAT1)
			/*어빌아이콘*/
			loop
				exitwhen i >= 10
				set ia = AbilityIcon.create(i,CONTAINER,p)
				//call ia.setTarget(target.getAbility(i))
				set i = i + 1
			endloop
			/*외부프레임*/
			call SkillShop.create(p)
			call SlotChanger.create(p)
			call CloseUI.create(p)
			call Inventory.create(p)
			call Numberpad.create(p)
			call StatIndicator.create(p,FRAME_STAT2)
			call Scouter.create(p)
			call CameraSetup.create(p)
			call BuffIndicator.create(p)
			call AbilityManager.create(p)
			/*타겟리프레시*/
			call setTarget(User.getFocusUnit(p))
			/*타이머*/
			call Timer.start(.main_timer,0.1,true,function thistype.timerAction)
			return this
		endmethod

		method destroy takes nothing returns nothing
			local integer i = 0
			local IconFrame ii = 0
			if .chingho > 0 then
				call .chingho.destroy()
			endif
			call Timer.release(.main_timer)
			set .main_timer = null
		endmethod

		private static method genericButtonAction takes nothing returns nothing
			if GetLocalPlayer() == GetTriggerPlayer() then
				call BlzFrameSetEnable(BlzGetTriggerFrame(),false)
				call BlzFrameSetEnable(BlzGetTriggerFrame(),true)
			endif
			if BlzGetTriggerFrameEvent() != FRAMEEVENT_CONTROL_CLICK then
				return
			endif
			if BlzGetTriggerFrame() == FRAME_SKILL_SHOP_BUTTON then
				call SkillShop(GetPlayerId(GetTriggerPlayer())).switch()
				return
			elseif BlzGetTriggerFrame() == FRAME_SLOT_CHANGER_BUTTON then
				call SlotChanger(GetPlayerId(GetTriggerPlayer())).switch()
				return
			elseif BlzGetTriggerFrame() == FRAME_INVENTORY_BUTTON then
				call Inventory(GetPlayerId(GetTriggerPlayer())).switch()
				return
			elseif BlzGetTriggerFrame() == FRAME_STAT_INDICATOR_BUTTON then
				call StatIndicator(GetPlayerId(GetTriggerPlayer())).switch()
				return
			elseif BlzGetTriggerFrame() == FRAME_ABILITY_MANAGER_BUTTON then
				call AbilityManager(GetPlayerId(GetTriggerPlayer())).switch()
				return
			// elseif BlzGetTriggerFrame() == FRAME_INVENTORY_CATEGORY_BUTTON[0] then
			// 	call Inventory(GetPlayerId(GetTriggerPlayer())).changeCategory(0)
			// 	return
			// elseif BlzGetTriggerFrame() == FRAME_INVENTORY_CATEGORY_BUTTON[ITEMTYPE_FOOD] then
			// 	call Inventory(GetPlayerId(GetTriggerPlayer())).changeCategory(ITEMTYPE_FOOD)
			// 	return
			// elseif BlzGetTriggerFrame() == FRAME_INVENTORY_CATEGORY_BUTTON[ITEMTYPE_GACHA] then
			// 	call Inventory(GetPlayerId(GetTriggerPlayer())).changeCategory(ITEMTYPE_GACHA)
			// 	return
			endif
		endmethod

		static method init takes nothing returns nothing
			local framehandle f = null
			local framehandle bf = null
			local integer i = 0
			local real c_inset = Math.px2Size(ABILITY_CONTAINER_HEIGHT-ABILITY_ICON_SIZE)/2.
			local real c_width = Math.px2Size(ABILITY_CONTAINER_WIDTH)-(c_inset*2)
			local real c_cell = c_width/10.
			local real c_padding = c_cell-Math.px2Size(ABILITY_ICON_SIZE)
			local trigger t = null
			/*미니맵*/
			set FRAME_MINIMAP = BlzGetOriginFrame(ORIGIN_FRAME_MINIMAP,0)
			set FRAME_MINIMAP_BACKDROP = BlzCreateFrame("MBEdge",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC]/*BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME,0)*/,0,0)
			call BlzFrameSetParent(FRAME_MINIMAP,FRAME_MINIMAP_BACKDROP)
			call BlzFrameClearAllPoints(FRAME_MINIMAP)
			call BlzFrameSetPointPixel(FRAME_MINIMAP,FRAMEPOINT_BOTTOMRIGHT,FRAME_ORIGIN,FRAMEPOINT_BOTTOMRIGHT,0.,CONFIG_MINIMAP_OFFSET_Y)
			call BlzFrameSetPointPixel(FRAME_MINIMAP,FRAMEPOINT_TOPLEFT,FRAME_ORIGIN,FRAMEPOINT_BOTTOMRIGHT,-CONFIG_MINIMAP_SIZE,CONFIG_MINIMAP_SIZE+CONFIG_MINIMAP_OFFSET_Y)
			call BlzFrameSetPointPixel(FRAME_MINIMAP_BACKDROP,FRAMEPOINT_BOTTOMRIGHT,FRAME_ORIGIN,FRAMEPOINT_BOTTOMRIGHT,0,CONFIG_MINIMAP_OFFSET_Y)
			call BlzFrameSetSizePixel(FRAME_MINIMAP_BACKDROP,CONFIG_MINIMAP_SIZE,CONFIG_MINIMAP_SIZE)
			call BlzFrameSetEnable(FRAME_MINIMAP,true)
			call BlzFrameSetVisible(FRAME_MINIMAP,true)
			/*포트레이트*/
			set FRAME_PORTRAIT_BACKDROP = BlzCreateFrameByType("BACKDROP","",BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME,0),"",0)
			call BlzFrameSetPoint(FRAME_PORTRAIT_BACKDROP,FRAMEPOINT_TOPLEFT,FRAME_ORIGIN,FRAMEPOINT_BOTTOM,/*
				*/Math.px2Size(PORTRAIT_OFFSET_X),Math.px2Size(PORTRAIT_OFFSET_Y+PORTRAIT_BORDER+PORTRAIT_SIZE))
			call BlzFrameSetSize(FRAME_PORTRAIT_BACKDROP,Math.px2Size(PORTRAIT_SIZE),Math.px2Size(PORTRAIT_SIZE))
			call BlzFrameSetTexture(FRAME_PORTRAIT_BACKDROP,"ReplaceableTextures\\teamcolor\\teamcolor27.blp",0,true)
			call BlzFrameSetAlpha(FRAME_PORTRAIT_BACKDROP,128)
			set FRAME_PORTRAIT = BlzGetOriginFrame(ORIGIN_FRAME_PORTRAIT,0)
			call BlzFrameSetVisible(FRAME_PORTRAIT,true)
			call BlzFrameClearAllPoints(FRAME_PORTRAIT)
			call BlzFrameSetAbsPoint(FRAME_PORTRAIT,FRAMEPOINT_TOPLEFT,Math.px2Size((1920/2)+PORTRAIT_OFFSET_X)*0.75,Math.px2Size(PORTRAIT_OFFSET_Y+PORTRAIT_BORDER+PORTRAIT_SIZE))
			call BlzFrameSetAbsPoint(FRAME_PORTRAIT,FRAMEPOINT_BOTTOMRIGHT,Math.px2Size((1920/2)+PORTRAIT_SIZE+PORTRAIT_OFFSET_X)*0.75,Math.px2Size(PORTRAIT_OFFSET_Y+PORTRAIT_BORDER))
			/*어빌리티박스*/
			set FRAME_ABILITY_CONTAINER = BlzCreateFrameByType("BACKDROP","",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],"",0)
			call BlzFrameSetPoint(FRAME_ABILITY_CONTAINER,FRAMEPOINT_BOTTOMLEFT,FRAME_ORIGIN,FRAMEPOINT_BOTTOM,/*
				*/Math.px2Size(-ABILITY_CONTAINER_WIDTH/2),Math.px2Size(ABILITY_CONTAINER_OFFSET_Y))
			call BlzFrameSetSize(FRAME_ABILITY_CONTAINER,Math.px2Size(ABILITY_CONTAINER_WIDTH),Math.px2Size(ABILITY_CONTAINER_HEIGHT))
			call BlzFrameSetTexture(FRAME_ABILITY_CONTAINER,"Textures\\Black32.blp",0,true)
			call BlzFrameSetAlpha(FRAME_ABILITY_CONTAINER,128)
			/*어빌아이콘*/
			loop
				exitwhen i >= CONFIG_ABILITY_SIZE
				set FRAME_ABILITY_ICON[i] = BlzCreateFrameByType("BACKDROP","",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],"",0)
				call BlzFrameSetPoint(FRAME_ABILITY_ICON[i],FRAMEPOINT_TOPLEFT,FRAME_ABILITY_CONTAINER,FRAMEPOINT_TOPLEFT,/*
					*/c_inset+(c_padding/2.)+(i*c_cell),/*
					*/Math.px2Size(-(ABILITY_CONTAINER_HEIGHT-ABILITY_ICON_SIZE)/2))
				call BlzFrameSetSize(FRAME_ABILITY_ICON[i],Math.px2Size(ABILITY_ICON_SIZE),Math.px2Size(ABILITY_ICON_SIZE))
				call BlzFrameSetTexture(FRAME_ABILITY_ICON[i],"Icons\\BTNBlackIcon.blp",0,true)
				set f = BlzCreateFrame("MyTextLarge",FRAME_ABILITY_ICON[i],0,0)
				call BlzFrameSetAllPoints(f,FRAME_ABILITY_ICON[i])
				if i < 4 then
					call BlzFrameSetText(f,"|cff663333"+CONSTANT_ABILITY_HOTKEY_NAME[i]+"|r")
				elseif i < 6 then
					call BlzFrameSetText(f,"|cff333366"+CONSTANT_ABILITY_HOTKEY_NAME[i]+"|r")
				else
					call BlzFrameSetText(f,"|cff336633"+CONSTANT_ABILITY_HOTKEY_NAME[i]+"|r")
				endif
				call BlzFrameSetTextAlignment(f,TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_CENTER)
				set i = i + 1
			endloop
			/*내리기 아이콘*/
			set FRAME_UNRIDE_ICON = BlzCreateFrameByType("FRAME","",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],"",0)
			call BlzFrameSetPointPixel(FRAME_UNRIDE_ICON,FRAMEPOINT_BOTTOMRIGHT,FRAME_ABILITY_CONTAINER,FRAMEPOINT_BOTTOMLEFT,-48,0.)
			call BlzFrameSetSizePixel(FRAME_UNRIDE_ICON,48,48)
			set f = BlzCreateFrameByType("BACKDROP","",FRAME_UNRIDE_ICON,"",0)
			call BlzFrameSetAllPoints(f,FRAME_UNRIDE_ICON)
			call BlzFrameSetTexture(f,"ReplaceableTextures\\CommandButtonsDisabled\\DISBTNUnLoad.blp",0,true)
			set FRAME_UNRIDE_ICON_BACKDROP = f
			set bf = f
			set f = BlzCreateFrameByType("BACKDROP","",bf,"",0)
			call BlzFrameSetPoint(f,FRAMEPOINT_TOPLEFT,bf,FRAMEPOINT_TOPLEFT,0.,0.)
			call BlzFrameSetSizePixel(f,20,20)
			call BlzFrameSetTexture(f,"ui\\console\\human\\human-transport-slot.blp",0,true)
			call BlzFrameSetAlpha(f,200)
			set f = BlzCreateFrame("MyText",bf,0,0)
			call BlzFrameSetPoint(f,FRAMEPOINT_TOPLEFT,bf,FRAMEPOINT_TOPLEFT,0.,0.)
			call BlzFrameSetSizePixel(f,20,20)
			call BlzFrameSetTextAlignment(f,TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_CENTER)
			call BlzFrameSetText(f,"|cffffcc00"+CONSTANT_ABILITY_HOTKEY_NAME[ENUM_ABILITY_HOTKEY_UNRIDE]+"|r")
			call Frame.addTooltipSimple(FRAMEPOINT_BOTTOMLEFT,FRAME_UNRIDE_ICON,FRAMEPOINT_TOPLEFT,"내리기|cffffcc00(Z)|r",0.,0.)
			/*내려놓기 아이콘*/
			set FRAME_UNGRAB_ICON = BlzCreateFrameByType("FRAME","",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],"",0)
			call BlzFrameSetPointPixel(FRAME_UNGRAB_ICON,FRAMEPOINT_BOTTOMRIGHT,FRAME_ABILITY_CONTAINER,FRAMEPOINT_BOTTOMLEFT,0.,0.)
			call BlzFrameSetSizePixel(FRAME_UNGRAB_ICON,48,48)
			set f = BlzCreateFrameByType("BACKDROP","",FRAME_UNGRAB_ICON,"",0)
			call BlzFrameSetAllPoints(f,FRAME_UNGRAB_ICON)
			call BlzFrameSetTexture(f,"ReplaceableTextures\\CommandButtonsDisabled\\DISBTNPickUpItem.blp",0,true)
			set FRAME_UNGRAB_ICON_BACKDROP = f
			set bf = f
			set f = BlzCreateFrameByType("BACKDROP","",bf,"",0)
			call BlzFrameSetPoint(f,FRAMEPOINT_TOPLEFT,bf,FRAMEPOINT_TOPLEFT,0.,0.)
			call BlzFrameSetSizePixel(f,20,20)
			call BlzFrameSetTexture(f,"ui\\console\\human\\human-transport-slot.blp",0,true)
			call BlzFrameSetAlpha(f,200)
			set f = BlzCreateFrame("MyText",bf,0,0)
			call BlzFrameSetPoint(f,FRAMEPOINT_TOPLEFT,bf,FRAMEPOINT_TOPLEFT,0.,0.)
			call BlzFrameSetSizePixel(f,20,20)
			call BlzFrameSetTextAlignment(f,TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_CENTER)
			call BlzFrameSetText(f,"|cffffcc00"+CONSTANT_ABILITY_HOTKEY_NAME[ENUM_ABILITY_HOTKEY_UNGRAB]+"|r")
			call Frame.addTooltipSimple(FRAMEPOINT_BOTTOMLEFT,FRAME_UNGRAB_ICON,FRAMEPOINT_TOPLEFT,"내려놓기|cffffcc00(X)|r",0.,0.)
			/*스탯박스1*/
			set FRAME_STAT1 = BlzCreateFrameByType("BACKDROP","",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],"",0)
			call BlzFrameSetPoint(FRAME_STAT1,FRAMEPOINT_TOPLEFT,FRAME_PORTRAIT_BACKDROP,FRAMEPOINT_TOPRIGHT,0.,0.)
			call BlzFrameSetPoint(FRAME_STAT1,FRAMEPOINT_BOTTOMRIGHT,FRAME_PORTRAIT_BACKDROP,FRAMEPOINT_BOTTOMRIGHT,Math.px2Size(STAT1_WIDTH),0.)
			call BlzFrameSetTexture(FRAME_STAT1,"replaceabletextures\\teamcolor\\teamcolor27.blp",0,true)
			call BlzFrameSetAlpha(FRAME_STAT1,200)
			set FRAME_STAT2 = BlzCreateFrame("MBEdge",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_WINDOW],0,0)
			call BlzFrameSetPointPixel(FRAME_STAT2,FRAMEPOINT_BOTTOMLEFT,FRAME_PORTRAIT_BACKDROP,FRAMEPOINT_TOPLEFT,0.,96)
			call BlzFrameSetSizePixel(FRAME_STAT2,STAT2_WIDTH,STAT2_HEIGHT)
			call BlzFrameSetVisible(FRAME_STAT2,false)
			set f = BlzCreateFrameByType("FRAME","",FRAME_STAT2,"",0)
			call BlzFrameSetAllPoints(f,FRAME_STAT2)
			set f = BlzCreateFrame("MyTextLarge",FRAME_STAT2,0,0)
			call BlzFrameSetPointPixel(f,FRAMEPOINT_TOP,FRAME_STAT2,FRAMEPOINT_TOP,0.,-32)
			call BlzFrameSetText(f,"|cffffcc00능력치 (C)|r")
			/*체력바 마나바*/
			set FRAME_HP_BAR = BlzCreateFrameByType("FRAME","",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],"",0)
			call BlzFrameSetPoint(FRAME_HP_BAR,FRAMEPOINT_BOTTOMLEFT,FRAME_ORIGIN,FRAMEPOINT_BOTTOM,/*
				*/Math.px2Size(-BAR_WIDTH/2),Math.px2Size(HP_BAR_OFFSET_Y))
			call BlzFrameSetSize(FRAME_HP_BAR,Math.px2Size(BAR_WIDTH),Math.px2Size(BAR_HEIGHT))
			set f = BlzCreateFrameByType("BACKDROP","",FRAME_HP_BAR,"",0)
			call BlzFrameSetTexture(f,"ReplaceableTextures\\teamcolor\\teamcolor10.blp",0,true)
			call BlzFrameSetAlpha(f,96)
			call BlzFrameSetAllPoints(f,FRAME_HP_BAR)
			set FRAME_MP_BAR = BlzCreateFrameByType("FRAME","",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],"",0)
			call BlzFrameSetPoint(FRAME_MP_BAR,FRAMEPOINT_BOTTOMLEFT,FRAME_ORIGIN,FRAMEPOINT_BOTTOM,/*
				*/Math.px2Size(-BAR_WIDTH/2),Math.px2Size(MP_BAR_OFFSET_Y))
			call BlzFrameSetSize(FRAME_MP_BAR,Math.px2Size(BAR_WIDTH),Math.px2Size(BAR_HEIGHT))
			set f = BlzCreateFrameByType("BACKDROP","",FRAME_MP_BAR,"",0)
			call BlzFrameSetTexture(f,"ReplaceableTextures\\teamcolor\\teamcolor13.blp",0,true)
			call BlzFrameSetAlpha(f,96)
			call BlzFrameSetAllPoints(f,FRAME_MP_BAR)
			set FRAME_SP_BAR = BlzCreateFrameByType("FRAME","",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],"",0)
			call BlzFrameSetPoint(FRAME_SP_BAR,FRAMEPOINT_BOTTOMLEFT,FRAME_ORIGIN,FRAMEPOINT_BOTTOM,/*
				*/Math.px2Size(-BAR_WIDTH/2),Math.px2Size(SP_BAR_OFFSET_Y))
			call BlzFrameSetSize(FRAME_SP_BAR,Math.px2Size(BAR_WIDTH),Math.px2Size(BAR_HEIGHT/2))
			set f = BlzCreateFrameByType("BACKDROP","",FRAME_SP_BAR,"",0)
			call BlzFrameSetTexture(f,"ReplaceableTextures\\teamcolor\\teamcolor15.blp",0,true)
			call BlzFrameSetAlpha(f,96)
			call BlzFrameSetAllPoints(f,FRAME_SP_BAR)
			/*경험치바*/
			set FRAME_EXP_BAR = BlzCreateFrameByType("BACKDROP","",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],"",0)
			call BlzFrameSetPoint(FRAME_EXP_BAR,FRAMEPOINT_BOTTOMLEFT,FRAME_STAT1,FRAMEPOINT_BOTTOMLEFT,0.,0.)
			call BlzFrameSetPoint(FRAME_EXP_BAR,FRAMEPOINT_TOPRIGHT,FRAME_STAT1,FRAMEPOINT_BOTTOMRIGHT,0.,Math.px2Size(EXP_BAR_HEIGHT))
			call BlzFrameSetTexture(FRAME_EXP_BAR,"replaceabletextures\\teamcolor\\teamcolor03.blp",0,true)
			call BlzFrameSetVisible(FRAME_EXP_BAR,false)
			/*스탯UI*/
			/*컨테이너*/
			set CONTAINER = BlzCreateFrameByType("FRAME","",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],"",0)
			call BlzFrameSetPoint(CONTAINER,FRAMEPOINT_BOTTOMLEFT,FRAME_ORIGIN,FRAMEPOINT_BOTTOMLEFT,0.,0.)
			/*체력바 마나바*/
			set HP_FILL = BlzCreateFrameByType("BACKDROP","",FRAME_HP_BAR,"",0)
			call BlzFrameSetPoint(HP_FILL,FRAMEPOINT_BOTTOMLEFT,FRAME_HP_BAR,FRAMEPOINT_BOTTOMLEFT,0.,0.)
			call BlzFrameSetTexture(HP_FILL,"replaceabletextures\\teamcolor\\teamcolor06.blp",0,true)
			set HP_TEXT = BlzCreateFrame("MyText",FRAME_HP_BAR,0,0)
			call BlzFrameSetAllPoints(HP_TEXT,FRAME_HP_BAR)
			call BlzFrameSetTextAlignment(HP_TEXT,TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_CENTER)
			set HP_ICON = BlzCreateFrameByType("BACKDROP","",HP_FILL,"",0)
			call BlzFrameSetPoint(HP_ICON,FRAMEPOINT_TOPLEFT,HP_TEXT,FRAMEPOINT_TOPLEFT,Math.px2Size(BAR_HEIGHT-20)/2,-Math.px2Size(BAR_HEIGHT-20)/2)
			call BlzFrameSetSize(HP_ICON,Math.px2Size(20),Math.px2Size(20))
			call BlzFrameSetTexture(HP_ICON,CONSTANT_STAT_ICON[ENUM_STAT_MAXHP],0,true)
			set MP_FILL = BlzCreateFrameByType("BACKDROP","",FRAME_MP_BAR,"",0)
			call BlzFrameSetPoint(MP_FILL,FRAMEPOINT_BOTTOMLEFT,FRAME_MP_BAR,FRAMEPOINT_BOTTOMLEFT,0.,0.)
			call BlzFrameSetTexture(MP_FILL,"replaceabletextures\\teamcolor\\teamcolor01.blp",0,true)
			set MP_TEXT = BlzCreateFrame("MyText",FRAME_MP_BAR,0,0)
			call BlzFrameSetAllPoints(MP_TEXT,FRAME_MP_BAR)
			call BlzFrameSetTextAlignment(MP_TEXT,TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_CENTER)
			set MP_ICON = BlzCreateFrameByType("BACKDROP","",MP_FILL,"",0)
			call BlzFrameSetPoint(MP_ICON,FRAMEPOINT_TOPLEFT,MP_TEXT,FRAMEPOINT_TOPLEFT,Math.px2Size(BAR_HEIGHT-20)/2,-Math.px2Size(BAR_HEIGHT-20)/2)
			call BlzFrameSetSize(MP_ICON,Math.px2Size(20),Math.px2Size(20))
			call BlzFrameSetTexture(MP_ICON,CONSTANT_STAT_ICON[ENUM_STAT_MAXMP],0,true)
			set SP_FILL = BlzCreateFrameByType("BACKDROP","",FRAME_SP_BAR,"",0)
			call BlzFrameSetPoint(SP_FILL,FRAMEPOINT_BOTTOMLEFT,FRAME_SP_BAR,FRAMEPOINT_BOTTOMLEFT,0.,0.)
			call BlzFrameSetTexture(SP_FILL,"replaceabletextures\\teamcolor\\teamcolor19.blp",0,true)
			set SP_TEXT = BlzCreateFrame("MyTextSmall",FRAME_SP_BAR,0,0)
			call BlzFrameSetAllPoints(SP_TEXT,FRAME_SP_BAR)
			call BlzFrameSetTextAlignment(SP_TEXT,TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_CENTER)
			/*레벨*/
			set LEVEL_BACKDROP = BlzCreateFrameByType("BACKDROP","",CONTAINER,"",0)
			call BlzFrameSetTexture(LEVEL_BACKDROP,"ui\\console\\human\\human-transport-slot.blp",0,true)
			set LEVEL_TEXT	= BlzCreateFrame("MyText",CONTAINER,0,0)
			call BlzFrameSetPoint(LEVEL_TEXT,FRAMEPOINT_BOTTOMRIGHT,FRAME_EXP_BAR,FRAMEPOINT_BOTTOMLEFT,0.,0.)
			call BlzFrameSetAllPoints(LEVEL_BACKDROP,LEVEL_TEXT)
			call BlzFrameSetTextAlignment(LEVEL_TEXT,TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_RIGHT)
			/*경험치바*/
			set EXP_FILL = BlzCreateFrameByType("BACKDROP","",CONTAINER,"",0)
			call BlzFrameSetPoint(EXP_FILL,FRAMEPOINT_BOTTOMLEFT,FRAME_EXP_BAR,FRAMEPOINT_BOTTOMLEFT,0.,0.)
			call BlzFrameSetTexture(EXP_FILL,"replaceabletextures\\teamcolor\\teamcolor15.blp",0,true)
			call BlzFrameSetPoint(EXP_FILL,FRAMEPOINT_TOPRIGHT,FRAME_EXP_BAR,FRAMEPOINT_TOPLEFT,Math.px2Size(STAT1_WIDTH)*0.5,0.)
			set EXP_TEXT = BlzCreateFrame("MyTextSmall",CONTAINER,0,0)
			call BlzFrameSetPoint(EXP_TEXT,FRAMEPOINT_BOTTOM,FRAME_EXP_BAR,FRAMEPOINT_BOTTOM,0.,0.)
			call BlzFrameSetTextAlignment(EXP_TEXT,TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_CENTER)
			call BlzFrameSetText(EXP_TEXT,"0%")
			call BlzFrameSetVisible(EXP_FILL,false)
			call BlzFrameSetVisible(EXP_TEXT,false)
			/*유닛이름*/
			set NAME = BlzCreateFrame("MyTextLarge",CONTAINER,0,0)
			call BlzFrameSetPoint(NAME,FRAMEPOINT_TOPLEFT,FRAME_EXP_BAR,FRAMEPOINT_TOPLEFT,0.,Math.px2Size(PORTRAIT_SIZE-CHINGHO_HEIGHT))
			call BlzFrameSetPoint(NAME,FRAMEPOINT_BOTTOMRIGHT,FRAME_EXP_BAR,FRAMEPOINT_TOPRIGHT,0.,0.)
			call BlzFrameSetTextAlignment(NAME,TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_CENTER)
			/*포션제조*/
			/*set FRAME_MAKE_POTION = BlzCreateFrameByType("FRAME","",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_WINDOW],"",0)
			call BlzFrameSetPoint(FRAME_MAKE_POTION,FRAMEPOINT_BOTTOMRIGHT,FRAME_HP_BAR,FRAMEPOINT_TOPRIGHT,0,0)*/
			/*스킬상점*/
			set FRAME_SKILL_SHOP_BACKDROP = BlzCreateFrame("EMEdge",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_WINDOW],0,0)
			call BlzFrameSetPoint(FRAME_SKILL_SHOP_BACKDROP,FRAMEPOINT_TOP,FRAME_ORIGIN,FRAMEPOINT_TOP,0.,Math.px2Size(SKILL_SHOP_OFFSET_Y))
			call BlzFrameSetSize(FRAME_SKILL_SHOP_BACKDROP,Math.px2Size(SKILL_SHOP_WIDTH),Math.px2Size(SKILL_SHOP_HEIGHT))
			set f = BlzCreateFrame("MyTextBox",FRAME_SKILL_SHOP_BACKDROP,0,0)
			set bf = f
			set f = BlzCreateFrame("MyTextLarge",FRAME_SKILL_SHOP_BACKDROP,0,0)
			call BlzFrameSetPoint(f,FRAMEPOINT_BOTTOM,FRAME_SKILL_SHOP_BACKDROP,FRAMEPOINT_TOP,0.,-0.0125)
			call BlzFrameSetTextAlignment(f,TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_CENTER)
			call BlzFrameSetText(f,"상점 (T)")
			call BlzFrameSetPoint(bf,FRAMEPOINT_BOTTOMLEFT,f,FRAMEPOINT_BOTTOMLEFT,-0.005,-0.005)
			call BlzFrameSetPoint(bf,FRAMEPOINT_TOPRIGHT,f,FRAMEPOINT_TOPRIGHT,0.005,0.005)
			set FRAME_SKILL_SHOP = BlzCreateFrameByType("BACKDROP","",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_WINDOW],"",0)
			call BlzFrameSetPoint(FRAME_SKILL_SHOP,FRAMEPOINT_TOP,FRAME_SKILL_SHOP_BACKDROP,FRAMEPOINT_TOP,0.,-Math.px2Size(SKILL_SHOP_INSET))
			call BlzFrameSetSize(FRAME_SKILL_SHOP,Math.px2Size(SKILL_SHOP_WIDTH-SKILL_SHOP_INSET*2),Math.px2Size(SKILL_SHOP_HEIGHT-SKILL_SHOP_INSET*2))
			call BlzFrameSetAlpha(FRAME_SKILL_SHOP,0)
			call BlzFrameSetVisible(FRAME_SKILL_SHOP_BACKDROP,false)
			/*슬롯체인저*/
			set FRAME_SLOT_CHANGER = BlzCreateFrame("MBEdge",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_WINDOW],0,0)
			call BlzFrameSetPoint(FRAME_SLOT_CHANGER,FRAMEPOINT_BOTTOM,FRAME_ORIGIN,FRAMEPOINT_BOTTOM,0.,Math.px2Size(SLOT_CHANGER_OFFSET_Y))
			call BlzFrameSetSize(FRAME_SLOT_CHANGER,Math.px2Size(SLOT_CHANGER_WIDTH),Math.px2Size(SLOT_CHANGER_HEIGHT))
			call BlzFrameSetVisible(FRAME_SLOT_CHANGER,false)
			set f = BlzCreateFrameByType("FRAME","",FRAME_SLOT_CHANGER,"",0)
			call BlzFrameSetAllPoints(f,FRAME_SLOT_CHANGER)
			set f = BlzCreateFrameByType("BACKDROP","",FRAME_SLOT_CHANGER,"",0)
			call BlzFrameSetPointPixel(f,FRAMEPOINT_BOTTOMLEFT,FRAME_SLOT_CHANGER,FRAMEPOINT_BOTTOMLEFT,12,12)
			call BlzFrameSetPointPixel(f,FRAMEPOINT_TOPRIGHT,FRAME_SLOT_CHANGER,FRAMEPOINT_TOPRIGHT,-12,-12)
			call BlzFrameSetTexture(f,"textures\\black32.blp",0,true)
			set f = BlzCreateFrame("MyText",FRAME_SLOT_CHANGER,0,0)
			call BlzFrameSetPointPixel(f,FRAMEPOINT_TOPLEFT,FRAME_SLOT_CHANGER,FRAMEPOINT_TOPLEFT,16,-16)
			call BlzFrameSetTextAlignment(f,TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_CENTER)
			call BlzFrameSetText(f,"|cffffcc00단축키 변경 (G)|r")
			/*인벤토리*/
			set FRAME_INVENTORY = BlzCreateFrame("MBEdge",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_WINDOW],0,0)
			call BlzFrameSetPointPixel(FRAME_INVENTORY,FRAMEPOINT_BOTTOMRIGHT,FRAME_ORIGIN,FRAMEPOINT_BOTTOMRIGHT,INVENTORY_OFFSET_X,INVENTORY_OFFSET_Y)
			call BlzFrameSetSizePixel(FRAME_INVENTORY,INVENTORY_WIDTH,INVENTORY_HEIGHT)
			call BlzFrameSetVisible(FRAME_INVENTORY,false)
			set f = BlzCreateFrameByType("FRAME","",FRAME_INVENTORY,"",0)
			call BlzFrameSetAllPoints(f,FRAME_INVENTORY)
			set f = BlzCreateFrame("MyTextLarge",FRAME_INVENTORY,0,0)
			call BlzFrameSetPointPixel(f,FRAMEPOINT_TOP,FRAME_INVENTORY,FRAMEPOINT_TOP,0.,-32)
			call BlzFrameSetText(f,"|cffffcc00소지품 (B)|r")
				/*카테고리버튼*/
			//! textmacro inventoryCategoryButton takes typeprime, typecapital, xoffset
				set FRAME_INVENTORY_CATEGORY_BUTTON[ITEMTYPE_$typeprime$] = BlzCreateFrame("InventoryCategory$typecapital$Button",FRAME_INVENTORY,0,0)
				call BlzFrameSetPointPixel(FRAME_INVENTORY_CATEGORY_BUTTON[ITEMTYPE_$typeprime$],FRAMEPOINT_TOPLEFT,FRAME_INVENTORY,FRAMEPOINT_TOPLEFT,32+$xoffset$,-32)
				call BlzFrameSetSizePixel(FRAME_INVENTORY_CATEGORY_BUTTON[ITEMTYPE_$typeprime$],32,32)
				set FRAME_INVENTORY_CATEGORY_HIGHTLIGHT[ITEMTYPE_$typeprime$] = BlzCreateFrameByType("BACKDROP","",FRAME_INVENTORY_CATEGORY_BUTTON[ITEMTYPE_$typeprime$],"",0)
				call BlzFrameSetAllPoints(FRAME_INVENTORY_CATEGORY_HIGHTLIGHT[ITEMTYPE_$typeprime$],FRAME_INVENTORY_CATEGORY_BUTTON[ITEMTYPE_$typeprime$])
				call BlzFrameSetTexture(FRAME_INVENTORY_CATEGORY_HIGHTLIGHT[ITEMTYPE_$typeprime$],"ui\\widgets\\tooltips\\human\\Tooltip$typecapital$IconHighlight.blp",0,true)
				call BlzFrameSetVisible(FRAME_INVENTORY_CATEGORY_HIGHTLIGHT[ITEMTYPE_$typeprime$],false)
				call Frame.addTooltipSimple(FRAMEPOINT_BOTTOMLEFT,FRAME_INVENTORY_CATEGORY_BUTTON[ITEMTYPE_$typeprime$],FRAMEPOINT_TOPLEFT,ITEMTYPE_NAME[ITEMTYPE_$typeprime$],0.,0.)
				//! endtextmacro
				////! runtextmacro inventoryCategoryButton("MATERIAL","Material","0")
				////! runtextmacro inventoryCategoryButton("FOOD","Food","80")
				////! runtextmacro inventoryCategoryButton("GACHA","Gacha","120")
			/*공방*/
			set FRAME_CRAFT = BlzCreateFrame("MBEdge",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_WINDOW],0,0)
			call BlzFrameSetPoint(FRAME_CRAFT,FRAMEPOINT_BOTTOMRIGHT,FRAME_INVENTORY,FRAMEPOINT_BOTTOMLEFT,0.,0.)
			call BlzFrameSetSizePixel(FRAME_CRAFT,CRAFT_WIDTH,INVENTORY_HEIGHT)
			call BlzFrameSetVisible(FRAME_CRAFT,false)
			set f = BlzCreateFrameByType("FRAME","",FRAME_CRAFT,"",0)
			call BlzFrameSetAllPoints(f,FRAME_CRAFT)
			set f = BlzCreateFrame("MyTextLarge",FRAME_CRAFT,0,0)
			call BlzFrameSetPointPixel(f,FRAMEPOINT_TOP,FRAME_CRAFT,FRAMEPOINT_TOP,0.,-32)
			call BlzFrameSetText(f,"|cffffcc00공방|r")
			/*어빌리티 매니저*/
			set FRAME_ABILITY_MANAGER = BlzCreateFrame("MBEdge", FRAME_GAME_UI[CONFIG_FRAME_LEVEL_WINDOW],0,0)
			call BlzFrameSetVisible(FRAME_ABILITY_MANAGER,false)
			call BlzFrameSetPoint(FRAME_ABILITY_MANAGER,FRAMEPOINT_BOTTOM,FRAME_HP_BAR,FRAMEPOINT_TOP,0,0)
			call BlzFrameSetSizePixel(FRAME_ABILITY_MANAGER,ABILITY_MANAGER_WIDTH,ABILITY_MANAGER_HEIGHT)
			set f = BlzCreateFrameByType("FRAME","",FRAME_ABILITY_MANAGER,"",0)
			call BlzFrameSetAllPoints(f,FRAME_ABILITY_MANAGER)
			set f = BlzCreateFrame("MyTextLarge",FRAME_ABILITY_MANAGER,0,0)
			call BlzFrameSetPointPixel(f,FRAMEPOINT_TOP,FRAME_ABILITY_MANAGER,FRAMEPOINT_TOP,0.,-32)
			call BlzFrameSetText(f,"|cffffcc00스킬 관리 (V)|r")
			/*UI버튼*/
			//! textmacro createUIButton takes prime, const, icon, hangul, shortcut
				set FRAME_$const$_BUTTON = BlzCreateFrame("$prime$UIButton",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],0,0)
				call BlzFrameSetSizePixel(FRAME_$const$_BUTTON,48,48)
				set f = BlzGetFrameByName("$prime$UIButtonIcon",0)
				call BlzFrameSetPointPixel(f,FRAMEPOINT_CENTER,FRAME_$const$_BUTTON,FRAMEPOINT_CENTER,0,0)
				call BlzFrameSetSizePixel(f,32,32)
				call BlzFrameSetTexture(f,"replaceabletextures\\commandbuttons\\$icon$.blp",0,true)
				call Frame.addTooltipSimple(FRAMEPOINT_BOTTOMLEFT,FRAME_$const$_BUTTON,FRAMEPOINT_TOPLEFT,"|cffffcc00$hangul$|r |cffffffff($shortcut$)|r",0.,0.)
			//! endtextmacro
			//! runtextmacro createUIButton("Inventory","INVENTORY","btnUI_bag_08","소지품","B")
			//! runtextmacro createUIButton("SlotChanger","SLOT_CHANGER","BTNEngineeringUpgrade","단축키 변경","G")
			//! runtextmacro createUIButton("SkillShop","SKILL_SHOP","BTNMerchant","상점","T")
			//! runtextmacro createUIButton("StatIndicator","STAT_INDICATOR","BTNStatUp","능력치","C")
			//! runtextmacro createUIButton("AbilityManager","ABILITY_MANAGER","BTNSpellBookBLS","스킬 관리","V")
				/*SET POINT*/
			call BlzFrameSetPointPixel(FRAME_SKILL_SHOP_BUTTON,FRAMEPOINT_TOPLEFT,FRAME_PORTRAIT_BACKDROP,FRAMEPOINT_BOTTOMLEFT,0,0)
			call BlzFrameSetPointPixel(FRAME_SLOT_CHANGER_BUTTON,FRAMEPOINT_BOTTOMLEFT,FRAME_SKILL_SHOP_BUTTON,FRAMEPOINT_BOTTOMRIGHT,0,0)
			call BlzFrameSetPointPixel(FRAME_INVENTORY_BUTTON,FRAMEPOINT_BOTTOMLEFT,FRAME_SLOT_CHANGER_BUTTON,FRAMEPOINT_BOTTOMRIGHT,0,0)
			call BlzFrameSetPointPixel(FRAME_STAT_INDICATOR_BUTTON,FRAMEPOINT_BOTTOMLEFT,FRAME_INVENTORY_BUTTON,FRAMEPOINT_BOTTOMRIGHT,0,0)
			call BlzFrameSetPointPixel(FRAME_ABILITY_MANAGER_BUTTON,FRAMEPOINT_BOTTOMLEFT,FRAME_STAT_INDICATOR_BUTTON,FRAMEPOINT_BOTTOMRIGHT,0,0)
			/*어빌리티 에러*/
			set ABILITY_ERROR = BlzCreateFrame("MyText",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_POPUP],0,0)
			call BlzFrameSetPoint(ABILITY_ERROR,FRAMEPOINT_BOTTOM,FRAME_ORIGIN,FRAMEPOINT_BOTTOM,0.,Math.px2Size(ABILITY_ERROR_OFFSET_Y))
			call BlzFrameSetTextAlignment(ABILITY_ERROR,TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_CENTER)
			/*트리거*/
			set FRAME_BUTTON_TRIGGER = CreateTrigger()
			call BlzTriggerRegisterFrameEvent(FRAME_BUTTON_TRIGGER,FRAME_INVENTORY_BUTTON,FRAMEEVENT_CONTROL_CLICK)
			call BlzTriggerRegisterFrameEvent(FRAME_BUTTON_TRIGGER,FRAME_INVENTORY_BUTTON,FRAMEEVENT_MOUSE_LEAVE)
			call BlzTriggerRegisterFrameEvent(FRAME_BUTTON_TRIGGER,FRAME_SLOT_CHANGER_BUTTON,FRAMEEVENT_CONTROL_CLICK)
			call BlzTriggerRegisterFrameEvent(FRAME_BUTTON_TRIGGER,FRAME_SLOT_CHANGER_BUTTON,FRAMEEVENT_MOUSE_LEAVE)
			call BlzTriggerRegisterFrameEvent(FRAME_BUTTON_TRIGGER,FRAME_SKILL_SHOP_BUTTON,FRAMEEVENT_CONTROL_CLICK)
			call BlzTriggerRegisterFrameEvent(FRAME_BUTTON_TRIGGER,FRAME_SKILL_SHOP_BUTTON,FRAMEEVENT_MOUSE_LEAVE)
			call BlzTriggerRegisterFrameEvent(FRAME_BUTTON_TRIGGER,FRAME_STAT_INDICATOR_BUTTON,FRAMEEVENT_CONTROL_CLICK)
			call BlzTriggerRegisterFrameEvent(FRAME_BUTTON_TRIGGER,FRAME_STAT_INDICATOR_BUTTON,FRAMEEVENT_MOUSE_LEAVE)
			call BlzTriggerRegisterFrameEvent(FRAME_BUTTON_TRIGGER,FRAME_ABILITY_MANAGER_BUTTON,FRAMEEVENT_CONTROL_CLICK)
			call BlzTriggerRegisterFrameEvent(FRAME_BUTTON_TRIGGER,FRAME_ABILITY_MANAGER_BUTTON,FRAMEEVENT_MOUSE_LEAVE)
			call BlzTriggerRegisterFrameEvent(FRAME_BUTTON_TRIGGER,FRAME_INVENTORY_CATEGORY_BUTTON[0],FRAMEEVENT_CONTROL_CLICK)
			call BlzTriggerRegisterFrameEvent(FRAME_BUTTON_TRIGGER,FRAME_INVENTORY_CATEGORY_BUTTON[0],FRAMEEVENT_MOUSE_LEAVE)
			call TriggerAddCondition(FRAME_BUTTON_TRIGGER,function thistype.genericButtonAction)
			/*외부프레임*/
			call NPCUI.init(FRAME_GAME_UI[CONFIG_FRAME_LEVEL_WINDOW])
			/*핸들프리*/
			set bf = null
			set f = null
			set t = null
		endmethod

		private static method refreshCond takes nothing returns nothing
			local thistype this = GetPlayerId(CUSTOM_RESPOND_UI_REFRESH_PLAYER)
			call refreshAbilityIconsTarget()
			call SlotChanger(this).stateDefault()
			call AbilityManager(this).loadAbility()
			call Inventory(this).refresh()
		endmethod

		private static method itemDestroyRespond takes nothing returns nothing
			local thistype this = 0
			if CUSTOM_RESPOND_ITEM_DESTROY_ADDRESS1 != ItemAddress.UNIT then
				return
			endif
			set this = GetPlayerId(Unit(CUSTOM_RESPOND_ITEM_DESTROY_ADDRESS2).owner)
		endmethod

		private static method ridingCallback takes nothing returns nothing
			local thistype this = GetPlayerId(Unit_prototype(CUSTOM_RESPOND_RIDING_CASTER).owner)
			if GetLocalPlayer() == Player(this) then
				if CUSTOM_RESPOND_RIDING_FLAG then
					call BlzFrameSetTexture(FRAME_UNRIDE_ICON_BACKDROP,"ReplaceableTextures\\CommandButtons\\BTNUnLoad.blp",0,true)
				else
					call BlzFrameSetTexture(FRAME_UNRIDE_ICON_BACKDROP,"ReplaceableTextures\\CommandButtonsDisabled\\DISBTNUnLoad.blp",0,true)
				endif
			endif
		endmethod

		private static method grabbingCallback takes nothing returns nothing
			local thistype this = GetPlayerId(Unit_prototype(CUSTOM_RESPOND_GRABBING_CASTER).owner)
			if GetLocalPlayer() == Player(this) then
				if CUSTOM_RESPOND_GRABBING_FLAG then
					if CUSTOM_RESPOND_GRABBING_REFRESH_UI then
						call BlzFrameSetTexture(FRAME_UNGRAB_ICON_BACKDROP,"ReplaceableTextures\\CommandButtons\\BTNPickUpItem.blp",0,true)
					else
						call BlzFrameSetTexture(FRAME_UNGRAB_ICON_BACKDROP,"ReplaceableTextures\\CommandButtonsDisabled\\DISBTNPickUpItem.blp",0,true)
					endif
				else
					call BlzFrameSetTexture(FRAME_UNGRAB_ICON_BACKDROP,"ReplaceableTextures\\CommandButtonsDisabled\\DISBTNPickUpItem.blp",0,true)
				endif
			endif
		endmethod

		private static method onInit takes nothing returns nothing
			local trigger t = null
			set t = CreateTrigger()
			call Event.register(t,ENUM_EVENT_ERROR)
			call TriggerAddCondition(t,function thistype.errorCondition)
			set t = CreateTrigger()
			call Event.register(t,ENUM_EVENT_ABILITY_UI_REFRESH)
			call TriggerAddCondition(t,function thistype.refreshCond)
			//
			set t = CreateTrigger()
			call Event.register(t,ENUM_EVENT_ITEM_DESTROY)
			call TriggerAddCondition(t,function thistype.itemDestroyRespond)
			set t = CreateTrigger()
			call Event.register(t,ENUM_EVENT_RIDING)
			call TriggerAddCondition(t,function thistype.ridingCallback)
			set t = CreateTrigger()
			call Event.register(t,ENUM_EVENT_GRABBING)
			call TriggerAddCondition(t,function thistype.grabbingCallback)
			set t = null
		endmethod

	endstruct

endlibrary

//! import "SkillShop.j"
//! import "CloseUI.j"
//! import "SlotChanger.j"
//! import "Inventory.j"
//! import "Numberpad.j"
//! import "ExtraAbilityIcon.j"
//! import "Scouter.j"
//! import "CameraSetup.j"
//! import "BuffIndicator.j"
//! import "AbilityManager.j"