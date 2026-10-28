library SkillShop requires UI

	globals
		integer array CHANCE_TIER1
		integer array CHANCE_TIER2
		integer array CHANCE_TIER3
		integer array CHANCE_TIER4
		integer array CHANCE_TIER5
		integer array CHANCE_TOTAL
		private constant real LUCKY_INITIAL = 5.
		private constant real LUCKY_BONUS = 0.3
		constant integer CHANCE_LEVEL_MAX = 11
		private integer array MAX_EXP
		constant integer LEVEL_MAX = 11
		private constant integer WIDGET_COUNT = 5
		private constant integer DONATE_COST = 2
		private constant integer DONATE_EXP = 4
		private constant integer LUMBER_MAX = 8
	endglobals

	struct SkillShopWidget extends array

		static constant integer ICON_SIZE = 96

		player owner
		boolean lucky
		integer index
		integer id
		static trigger BTN_TRIGGER
		static boolean array ACTIVATED
		static framehandle array CONTAINER
		static framehandle array ICON
		static framehandle array TIER_BORDER
		static framehandle array NAME
		static framehandle array TAG
		static framehandle array BTN
		static framehandle array BONUS_STAT1
		static framehandle array BONUS_STAT2
		static framehandle array INFO_WEAPON_BACKDROP
		static framehandle array INFO_LUCKY_BACKDROP
		static framehandle array INFO_LUCKY_MODEL

		method setTarget takes integer id returns nothing
			local integer i = 0
			local integer j = 0
			local string s = ""
			set .id = id
			set .lucky = false
			if GetLocalPlayer() == .owner then
				/*어빌리티 버튼*/
				call BlzFrameSetEnable(BTN[.index],id > 0)
				call BlzFrameSetVisible(BlzGetFrameByName("SkillShopBuyButtonIcon",.index),id > 0)
				/*능력치보너스*/
				call BlzFrameSetVisible(BONUS_STAT1[.index],id > 0)
				call BlzFrameSetVisible(BONUS_STAT2[.index],id > 0)
			endif
			if id <= 0 then		/*빈칸*/
				if GetLocalPlayer() == .owner then
					call BlzFrameSetTexture(ICON[.index],"Icons\\BTNBlackIcon.blp",0,true)
					call BlzFrameSetVisible(TIER_BORDER[.index],false)
					call BlzFrameSetVisible(INFO_WEAPON_BACKDROP[.index],false)
					call BlzFrameSetVisible(INFO_LUCKY_BACKDROP[.index],false)
					call BlzFrameSetVisible(INFO_LUCKY_MODEL[.index],false)
					call BlzFrameSetText(NAME[.index],"")
					call BlzFrameSetText(TAG[.index],"")
					call BlzFrameSetPointPixel(BlzGetFrameByName("SkillShopBuyButtonText",.index),FRAMEPOINT_BOTTOM,BTN[.index],FRAMEPOINT_BOTTOM,0,24)
					call BlzFrameSetPointPixel(BlzGetFrameByName("SkillShopBuyButtonText",.index),FRAMEPOINT_TOP,BTN[.index],FRAMEPOINT_BOTTOM,0,40)
					call BlzFrameSetText(BlzGetFrameByName("SkillShopBuyButtonText",.index),"|c99999999판매됨|r")
				endif
			else	/*그 외*/
				/*럭키보너스*/
				set .lucky = GetRandomReal(0.,100.) < /*
				*/(LUCKY_INITIAL + User.getFocusUnit(.owner).getCarculatedStatValue(ENUM_STAT_LUCK) * LUCKY_BONUS) / Ability.getTypeTier(id)
				if GetLocalPlayer() == .owner then
					call BlzFrameSetVisible(INFO_LUCKY_BACKDROP[.index],.lucky)
					call BlzFrameSetVisible(INFO_LUCKY_MODEL[.index],.lucky)
					/*어빌리티 아이콘*/
					call BlzFrameSetTexture(ICON[.index],Ability.getTypeIconPath(id),0,true)
					call BlzFrameSetTexture(TIER_BORDER[.index],"Textures\\ability_border_tier"+I2S(Ability.getTypeTier(id))+".blp",0,true)
					call BlzFrameSetVisible(TIER_BORDER[.index],true)
					/*무기변형이면*/
					call BlzFrameSetVisible(INFO_WEAPON_BACKDROP[.index],Ability.getTypeIsWeapon(id))
				endif
				/*어빌리티 이름*/
				if .lucky then
					if GetLocalPlayer() == .owner then
						call BlzFrameSetText(NAME[.index],CONSTANT_TIER_COLOR[Ability.getTypeTier(id)]+Ability.getTypeName(id)+"|r"+/*
						*/CONSTANT_STAT_COLOR[ENUM_STAT_LUCK]+" x2|r")
					endif
				else
					if GetLocalPlayer() == .owner then
						call BlzFrameSetText(NAME[.index],CONSTANT_TIER_COLOR[Ability.getTypeTier(id)]+Ability.getTypeName(id)+"|r")
					endif
				endif
				/*어빌리티태그*/
				/*set i = 0
				loop
					set j = DamageTag.get(id,i)
					exitwhen j < 0
					if i <= 0 then
						set s = s + CONSTANT_ABILITY_TAG_NAME[j]
					else
						set s = s + ", " + CONSTANT_ABILITY_TAG_NAME[j]
					endif
					set i = i + 1
				endloop*/
				/*간이툴팁*/
				set s = s + Ability.getTypeTooltip(id)
				if GetLocalPlayer() == .owner then
					/*능력치보너스*/
					call BlzFrameSetText(TAG[.index],s)
					call BlzFrameSetTexture(BONUS_STAT1[.index],CONSTANT_STAT_ICON[Ability.getTypeBonusStatIndex(id,0)],0,true)
					call BlzFrameSetTexture(BONUS_STAT2[.index],CONSTANT_STAT_ICON[Ability.getTypeBonusStatIndex(id,1)],0,true)
					/*구매버튼*/
					call BlzFrameSetPointPixel(BlzGetFrameByName("SkillShopBuyButtonText",.index),FRAMEPOINT_BOTTOM,BTN[.index],FRAMEPOINT_BOTTOM,12,24)
					call BlzFrameSetPointPixel(BlzGetFrameByName("SkillShopBuyButtonText",.index),FRAMEPOINT_TOP,BTN[.index],FRAMEPOINT_BOTTOM,12,40)
					call BlzFrameSetText(BlzGetFrameByName("SkillShopBuyButtonText",.index),"|cffffcc00"+I2S(Ability.getTypeCost(id))+"|r")
				endif
			endif
		endmethod

		static method press takes nothing returns nothing
			local thistype this = 0
			local integer j = 0
			local Ability i = 0
			/*어떤 버튼이 눌렸는지*/
			loop
				exitwhen j >= WIDGET_COUNT
				exitwhen BlzGetTriggerFrame() == BTN[j]
				set j = j + 1
			endloop
			set this = GetPlayerId(GetTriggerPlayer()) * WIDGET_COUNT + j
			if GetLocalPlayer() == .owner then
				call BlzFrameSetEnable(BlzGetTriggerFrame(),false)
				call BlzFrameSetEnable(BlzGetTriggerFrame(),.id > 0)
			endif
			/*클릭 시 스킬 구매*/
			if BlzGetTriggerFrameEvent() == FRAMEEVENT_CONTROL_CLICK then
				/*소지금 검사*/
				if User.getGold(.owner) >= Ability.getTypeCost(.id) then
					set i = User.getFocusUnit(.owner).getAbilityById(.id)
					/*이미 있는 경우*/
					if i > 0 then
						/*만렙이라서 더 올릴 수 없음(리턴)*/
						if i.level >= i.level_max then
							set CUSTOM_RESPOND_ERROR_MESSAGE = "이미 최대 레벨에 도달한 능력입니다."
							set CUSTOM_RESPOND_ERROR_PLAYER = .owner
							call Event.activate(ENUM_EVENT_ERROR)
							if GetLocalPlayer() == .owner then
								call PlaySoundBJ(gg_snd_Error)
							endif
							return
						/*만렙 아니면 올려주기(OK)*/
						else
							/*OK================================*/
							/**/call i.addLevel(1)
							/**/call i.setUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_RED,i.getUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_RED) + Ability.getTypeCost(.id))
							/*OK================================*/
						endif
					/*공간 있으면 추가(OK)*/
					elseif i == 0 then
						/*OK================================*/
						/**/set i = User.getFocusUnit(.owner).addAbility(.id)
						/**/call i.setUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_RED,i.getUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_RED) + Ability.getTypeCost(.id))
						/*OK================================*/
					/*자리 없음(리턴)*/
					else
						set CUSTOM_RESPOND_ERROR_MESSAGE = "더이상 능력을 배울 수 없습니다."
						set CUSTOM_RESPOND_ERROR_PLAYER = .owner
						call Event.activate(ENUM_EVENT_ERROR)
						if GetLocalPlayer() == .owner then
							call PlaySoundBJ(gg_snd_Error)
						endif
						return
					endif
					/*OK================================*/
					/**//*행운보너스 적용*/
					/**/if .lucky then
					/**/	/*레벨초과분 환급*/
					/**/	if i.level >= i.level_max then
					/**/		call Unit(User.getFocusUnit(.owner)).addUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_GREEN,Ability.getTypeCost(.id))
					/**/	/*아닐 경우 그냥 레벨업&행운누적치 적립*/
					/**/	else
					/**/		call i.addLevel(1)
					/**/		call i.setUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_GREEN,i.getUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_GREEN) + Ability.getTypeCost(.id))
					/**/		/*공짜레벨업은 소멸 시 환급x*/
					/**/		//set i.upgrade_gold = i.upgrade_gold + Ability.getTypeCost(.id)
					/**/	endif
					/**/endif
					/**//*장착중인 무기가 없으면 배운 능력으로*/
					/**/if Ability.getTypeIsWeapon(i.id) then
					/**/	if i.level == 1 and i.owner.weapon_ability == 0 then
					/**/		call i.owner.setWeaponAbility(i)
					/**/	endif
					/**/endif
					/**//*빈 슬롯으로 만들어 주기 전에 골드 차감*/
					/**/call User.addGold(.owner,-1*Ability.getTypeCost(.id))
					/**//*빈 슬롯으로 만든 후 리프레시*/
					/**/call setTarget(0)
					/**/set CUSTOM_RESPOND_UI_REFRESH_PLAYER = .owner
					/**/call Event.activate(ENUM_EVENT_ABILITY_UI_REFRESH)
					/**/set CUSTOM_RESPOND_UI_REFRESH_PLAYER = null
					/*OK================================*/
				/*돈 부족하면(리턴)*/
				else
					set CUSTOM_RESPOND_ERROR_MESSAGE = "금화가 부족합니다."
					set CUSTOM_RESPOND_ERROR_PLAYER = .owner
					call Event.activate(ENUM_EVENT_ERROR)
					if GetLocalPlayer() == .owner then
						call PlaySoundBJ(gg_snd_Error)
					endif
					return
				endif
			endif
		endmethod

		static method initFrames takes framehandle parent, integer index returns nothing
			set CONTAINER[index] = BlzCreateFrameByType("BACKDROP","",parent,"",0)
			call BlzFrameSetPoint(CONTAINER[index],FRAMEPOINT_TOPLEFT,FRAME_SKILL_SHOP,FRAMEPOINT_TOPLEFT,index*BlzFrameGetWidth(FRAME_SKILL_SHOP)/5,0.)
			call BlzFrameSetSize(CONTAINER[index],BlzFrameGetWidth(FRAME_SKILL_SHOP)/5,BlzFrameGetHeight(FRAME_SKILL_SHOP))
			call BlzFrameSetTexture(CONTAINER[index],"Textures\\black32.blp",0,true)
			/*버튼*/
			set BTN[index] = BlzCreateFrame("SkillShopBuyButton",CONTAINER[index],0,index)
			call BlzFrameSetPointPixel(BTN[index],FRAMEPOINT_BOTTOM,CONTAINER[index],FRAMEPOINT_BOTTOM,0.,0.)
			call BlzFrameSetSizePixel(BTN[index],1280/5-16,396-64)
			call BlzFrameClearAllPoints(BlzGetFrameByName("SkillShopBuyButtonText",index))
			call BlzFrameSetPointPixel(BlzGetFrameByName("SkillShopBuyButtonText",index),FRAMEPOINT_BOTTOM,BTN[index],FRAMEPOINT_BOTTOM,12,24)
			call BlzFrameSetPointPixel(BlzGetFrameByName("SkillShopBuyButtonText",index),FRAMEPOINT_TOP,BTN[index],FRAMEPOINT_BOTTOM,12,40)
			call BlzFrameSetTextAlignment(BlzGetFrameByName("SkillShopBuyButtonText",index),TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_CENTER)
			call BlzFrameSetTexture(BlzGetFrameByName("SkillShopBuyButtonIcon",index),"ui\\widgets\\tooltips\\human\\tooltipgoldicon.blp",0,true)
			call BlzFrameSetPoint(BlzGetFrameByName("SkillShopBuyButtonIcon",index),FRAMEPOINT_RIGHT,BlzGetFrameByName("SkillShopBuyButtonText",index),FRAMEPOINT_LEFT,-0.005,0.)
			call BlzFrameSetSize(BlzGetFrameByName("SkillShopBuyButtonIcon",index),Math.px2Size(24),Math.px2Size(24))
			/*아이콘*/
			set ICON[index] = BlzCreateFrameByType("BACKDROP","",CONTAINER[index],"",0)
			call BlzFrameSetPointPixel(ICON[index],FRAMEPOINT_TOP,CONTAINER[index],FRAMEPOINT_TOP,0.,-32)
			call BlzFrameSetSizePixel(ICON[index],ICON_SIZE,ICON_SIZE)
			set TIER_BORDER[index] = BlzCreateFrameByType("BACKDROP","",CONTAINER[index],"",0)
			call BlzFrameSetAllPoints(TIER_BORDER[index],ICON[index])
			call BlzFrameSetTexture(TIER_BORDER[index],"Textures\\ability_border_tier1.blp",0,true)
			call BlzFrameSetVisible(TIER_BORDER[index],false)
			/*무기변형아이콘*/
			set INFO_WEAPON_BACKDROP[index] = BlzCreateFrameByType("BACKDROP","",CONTAINER[index],"",0)
			call BlzFrameSetPoint(INFO_WEAPON_BACKDROP[index],FRAMEPOINT_BOTTOMLEFT,ICON[index],FRAMEPOINT_BOTTOMRIGHT,0.,0.)
			call BlzFrameSetSizePixel(INFO_WEAPON_BACKDROP[index],32,32)
			call BlzFrameSetTexture(INFO_WEAPON_BACKDROP[index],"ui\\widgets\\tooltips\\human\\tooltipweaponicon.blp",0,true)
			/*행운보너스*/
			set INFO_LUCKY_BACKDROP[index] = BlzCreateFrameByType("BACKDROP","",CONTAINER[index],"",0)
			call BlzFrameSetPoint(INFO_LUCKY_BACKDROP[index],FRAMEPOINT_BOTTOMRIGHT,ICON[index],FRAMEPOINT_BOTTOMRIGHT,0.,0.)
			call BlzFrameSetSizePixel(INFO_LUCKY_BACKDROP[index],32,32)
			call BlzFrameSetTexture(INFO_LUCKY_BACKDROP[index],CONSTANT_STAT_ICON[ENUM_STAT_LUCK],0,true)
			set INFO_LUCKY_MODEL[index] = BlzCreateFrameByType("SPRITE","",CONTAINER[index],"",0)
			call BlzFrameSetPoint(INFO_LUCKY_MODEL[index],FRAMEPOINT_BOTTOMLEFT,ICON[index],FRAMEPOINT_BOTTOMLEFT,0.,0.)
			call BlzFrameSetSize(INFO_LUCKY_MODEL[index],0.0001,0.0001)
			call BlzFrameSetModel(INFO_LUCKY_MODEL[index],"ui\\ui_skillshop_lucky_emitter.mdl",0)
			/**/
			set NAME[index] = BlzCreateFrame("MyTextLarge",CONTAINER[index],0,0)
			call BlzFrameSetPoint(NAME[index],FRAMEPOINT_TOP,ICON[index],FRAMEPOINT_BOTTOM,0.,-0.005)
			call BlzFrameSetTextAlignment(NAME[index],TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_CENTER)
			call BlzFrameSetText(NAME[index],"어빌리티 이름")
			set TAG[index] = BlzCreateFrame("MyText",CONTAINER[index],0,0)
			call BlzFrameSetPoint(TAG[index],FRAMEPOINT_TOP,NAME[index],FRAMEPOINT_BOTTOM,0.,-0.005)
			call BlzFrameSetTextAlignment(TAG[index],TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_CENTER)
			call BlzFrameSetText(TAG[index],"")
			/*스탯 보너스 아이콘*/
			set BONUS_STAT1[index] = BlzCreateFrameByType("BACKDROP","",CONTAINER[index],"",0)
			call BlzFrameSetPointPixel(BONUS_STAT1[index],FRAMEPOINT_BOTTOMRIGHT,BTN[index],FRAMEPOINT_BOTTOM,-8,64)
			call BlzFrameSetSize(BONUS_STAT1[index],Math.px2Size(32),Math.px2Size(32))
			set BONUS_STAT2[index] = BlzCreateFrameByType("BACKDROP","",CONTAINER[index],"",0)
			call BlzFrameSetPointPixel(BONUS_STAT2[index],FRAMEPOINT_BOTTOMLEFT,BTN[index],FRAMEPOINT_BOTTOM,8,64)
			call BlzFrameSetSize(BONUS_STAT2[index],Math.px2Size(32),Math.px2Size(32))
			/*공용트리거*/
			call BlzTriggerRegisterFrameEvent(BTN_TRIGGER,BTN[index],FRAMEEVENT_CONTROL_CLICK)
			call BlzTriggerRegisterFrameEvent(BTN_TRIGGER,BTN[index],FRAMEEVENT_MOUSE_LEAVE)
		endmethod

		static method create takes framehandle parent, player owner, integer index returns thistype
			local thistype this = GetPlayerId(owner) * WIDGET_COUNT + index
			set .id = 0
			set .owner = owner
			set .index = index
			set .lucky = false
			/*공용프레임 초기화*/
			if not ACTIVATED[.index] then
				call initFrames(parent,.index)
				set ACTIVATED[.index] = true
			endif
			/**/
			call setTarget(0)
			return this
		endmethod

		method destroy takes nothing returns nothing
			
		endmethod

		static method onInit takes nothing returns nothing
			set BTN_TRIGGER = CreateTrigger()
			call TriggerAddCondition(BTN_TRIGGER,function thistype.press)
		endmethod

		static method get takes player p, integer index returns thistype
			return GetPlayerId(p) * WIDGET_COUNT + index
		endmethod

	endstruct

	struct SkillShop extends array

		static constant integer LUMBER_ADD_TIME = 30
		static constant real EXP_GAUGE_WIDTH = 256-4-32-32	/*아웃라인 말고 내부게이지 기준*/
		static boolean DEFEAT = false
		static boolean ACTIVATED = false

		integer level
		integer exp
		integer exp_max

		static trigger KEYPRESS
		static framehandle CONTAINER
		static framehandle BTN_REFRESH
		static framehandle BTN_LUMBER_REFRESH
		static framehandle BTN_DONATE
		static framehandle EXP_OUTLINE
		static framehandle EXP_BACKDROP
		static framehandle EXP_FILL
		static framehandle EXP_TEXT
		static framehandle LEVEL_BACKDROP
		static framehandle LEVEL_TEXT
		static framehandle LUMBER_REFRESH_TEXT_BACKDROP
		static framehandle LUMBER_REFRESH_TEXT
		static framehandle GOLD_BACKDROP
		static framehandle GOLD_ICON
		static framehandle GOLD_TEXT
		static framehandle CHANCE_BACKDROP
		static framehandle CHANCE_TEXT
		static framehandle BTN_CLOSE
		static framehandle LUMBER_SMALL_TIMER_BACKDROP
		static framehandle LUMBER_SMALL_TIMER_TEXT
		
		boolean autorefresh
		integer lumber_add_time

		boolean visible_flag

		method operator owner takes nothing returns player
			return Player(this)
		endmethod

		method carculatedTier takes nothing returns integer
			local integer r = 0
			local integer i = 0
			local integer current_chance = 0
			if .level >= 1 and .level <= CHANCE_LEVEL_MAX then
				set r = GetRandomInt(1,CHANCE_TOTAL[.level])
				/**/
				set current_chance = current_chance + CHANCE_TIER1[.level]
				if r <= current_chance then
					return 1
				endif
				set current_chance = current_chance + CHANCE_TIER2[.level]
				if r <= current_chance then
					return 2
				endif
				set current_chance = current_chance + CHANCE_TIER3[.level]
				if r <= current_chance then
					return 3
				endif
				set current_chance = current_chance + CHANCE_TIER4[.level]
				if r <= current_chance then
					return 4
				endif
				set current_chance = current_chance + CHANCE_TIER5[.level]
				if r <= current_chance then
					return 5
				endif
			endif
			return 0
		endmethod

		method refreshChanceText takes nothing returns nothing
			if GetLocalPlayer() == Player(this) then
				/*확률정보*/
				call BlzFrameSetText(CHANCE_TEXT,CONSTANT_TIER_COLOR[1]+I2S(R2I(getTierChance(.level,1)*100/CHANCE_TOTAL[.level]))+"%|r    "+/*
				*/CONSTANT_TIER_COLOR[2]+I2S(R2I(getTierChance(.level,2)*100/CHANCE_TOTAL[.level]))+"%|r    "+/*
				*/CONSTANT_TIER_COLOR[3]+I2S(R2I(getTierChance(.level,3)*100/CHANCE_TOTAL[.level]))+"%|r    "+/*
				*/CONSTANT_TIER_COLOR[4]+I2S(R2I(getTierChance(.level,4)*100/CHANCE_TOTAL[.level]))+"%|r    "+/*
				*/CONSTANT_TIER_COLOR[5]+I2S(R2I(getTierChance(.level,5)*100/CHANCE_TOTAL[.level]))+"%|r"/*
				*/)
			endif
		endmethod

		method refreshLevelState takes nothing returns nothing
			if .level >= LEVEL_MAX then
				if GetLocalPlayer() == Player(this) then
					call BlzFrameSetVisible(EXP_FILL,true)
					call BlzFrameSetText(LEVEL_TEXT,I2S(LEVEL_MAX))
					call BlzFrameSetText(EXP_TEXT,"MAX")
					call BlzFrameSetPointPixel(EXP_FILL,FRAMEPOINT_TOPRIGHT,EXP_BACKDROP,FRAMEPOINT_TOPRIGHT,0.,0.)
				endif
			else
				if GetLocalPlayer() == Player(this) then
					call BlzFrameSetVisible(EXP_FILL,.exp > 0)
					call BlzFrameSetText(LEVEL_TEXT,I2S(.level))
					call BlzFrameSetText(EXP_TEXT,I2S(.exp)+" / "+I2S(.exp_max))
					call BlzFrameSetPointPixel(EXP_FILL,FRAMEPOINT_TOPRIGHT,EXP_BACKDROP,FRAMEPOINT_TOPLEFT,EXP_GAUGE_WIDTH*(I2R(.exp)/I2R(.exp_max)),0.)
				endif
			endif
		endmethod

		method setLevel takes integer nv returns nothing
			set .level = nv
			set .exp_max = MAX_EXP[.level]
			if GetLocalPlayer() == Player(this) then
				call BlzFrameSetVisible(BTN_DONATE,.level > 1)
				call BlzFrameSetVisible(BTN_REFRESH,.level > 1)
			endif
			call refreshChanceText()
		endmethod

		method addExp takes integer v returns nothing
			set .exp = .exp + v
			loop
				exitwhen .exp < .exp_max or .level == LEVEL_MAX
				if .exp >= .exp_max then
					set .exp = .exp - .exp_max
					call setLevel(.level+1)
				endif
			endloop
			call refreshLevelState()
		endmethod

		static method addLevel takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen i >= CONFIG_PLAYER_MAX
				call thistype(i).addExp(2)
				set i = i + 1
			endloop
		endmethod

		method refreshGold takes nothing returns nothing
			if GetLocalPlayer() == Player(this) then
				call BlzFrameSetText(GOLD_TEXT,"|cffffcc00"+I2S(User.getGold(.owner))+"|r")
			endif
		endmethod

		method visibleForPlayer takes boolean flag returns nothing
			if .visible_flag != flag then
				if flag then
					/*CLOSEUI*/
					call CloseUI(this).add(CloseUI.ORDER_SKILL_SHOP)
				else
					/*CLOSEUI*/
					call CloseUI(this).eraseFor(CloseUI.ORDER_SKILL_SHOP)
				endif
			endif
			set .visible_flag = flag
			if GetLocalPlayer()==.owner then
				call BlzFrameSetVisible(FRAME_SKILL_SHOP_BACKDROP,flag)
			endif
			if .visible_flag then
				call refreshChanceText()
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

		method isWidgetEmpty takes nothing returns boolean
			local integer i = 0
			loop
				exitwhen i >= 5
				if SkillShopWidget.get(.owner,i).id > 0 then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		method refreshLumberRefresh takes nothing returns nothing
			local integer minitue = .lumber_add_time / 60
			local string second = ""
			if .lumber_add_time - 60*minitue >= 10 then
				set second = I2S(.lumber_add_time - 60*minitue)
			else
				set second = "0"+I2S(.lumber_add_time - 60*minitue)
			endif
			if GetLocalPlayer() == Player(this) then
				call BlzFrameSetText(BlzGetFrameByName("SkillShopLumberRefreshButtonText",0),/*
					*/"|cff00cc001|r |cffffffff: 새로고침|r |cff00cc00("+I2S(User.getLumber(Player(this)))+"/"+I2S(LUMBER_MAX)+")|r"/*
				*/)
				call BlzFrameSetText(LUMBER_SMALL_TIMER_TEXT,"|cff00cc00("+I2S(User.getLumber(Player(this)))+"/"+I2S(LUMBER_MAX)+")|r")
				if User.getLumber(Player(this)) >= LUMBER_MAX then 
					call BlzFrameSetVisible(LUMBER_REFRESH_TEXT,false)
					call BlzFrameSetVisible(LUMBER_REFRESH_TEXT_BACKDROP,false)
				else
					call BlzFrameSetText(LUMBER_REFRESH_TEXT,"|cff00cc00목재 지급 "+I2S(minitue)+":"+second+"|r")
					call BlzFrameSetVisible(LUMBER_REFRESH_TEXT,true)
					call BlzFrameSetVisible(LUMBER_REFRESH_TEXT_BACKDROP,true)
				endif
			endif
		endmethod

		method refresh takes nothing returns nothing
			local SkillShopWidget sw = 0
			local integer i = 0
			loop
				exitwhen i >= WIDGET_COUNT
				set sw = (this*WIDGET_COUNT)+i
				call sw.setTarget(AbilityTable.getRandomAbility(this,ENUM_TIER_0+carculatedTier()))
				set i = i + 1
			endloop
			call refreshChanceText()
			call refreshLevelState()
		endmethod

		method switch takes nothing returns nothing
			call visibleForPlayer(not .visible_flag)
		endmethod

		static method press takes nothing returns nothing
			local thistype this = 0
			local player p = GetTriggerPlayer()
			local integer i = 0
			if Event.getValue() == ENUM_EVENT_KEYPRESS then
				set this = GetPlayerId(CUSTOM_RESPOND_KEYPRESS_PLAYER)
				if CUSTOM_RESPOND_KEYPRESS_KEY == OSKEY_T and CUSTOM_RESPOND_KEYPRESS_PRESS then
					call switch()
					return
				endif
				return
			endif
			set this = GetPlayerId(p)
			if BlzGetTriggerFrame() != null then
				if GetLocalPlayer() == Player(this) then
					call BlzFrameSetEnable(BlzGetTriggerFrame(),false)
					call BlzFrameSetEnable(BlzGetTriggerFrame(),true)
				endif
				if BlzGetTriggerFrameEvent() == FRAMEEVENT_CONTROL_CLICK then
					if BlzGetTriggerFrame() == BTN_CLOSE then
						/*닫기*/
						call close()
						return
					elseif BlzGetTriggerFrame() == BTN_REFRESH then
						/*골드로 리롤*/
						if User.getGold(.owner) >= 2 then
							call User.addGold(.owner,-2)
							call refresh()
							call refreshLumberRefresh()
						/*돈 부족하면*/
						else
							set CUSTOM_RESPOND_ERROR_MESSAGE = "금화가 부족합니다."
							set CUSTOM_RESPOND_ERROR_PLAYER = .owner
							call Event.activate(ENUM_EVENT_ERROR)
							if GetLocalPlayer() == Player(this) then
								call PlaySoundBJ(gg_snd_Error)
							endif
						endif
						return
					elseif BlzGetTriggerFrame() == BTN_LUMBER_REFRESH then
						/*목재로 리롤*/
						if User.getLumber(.owner) >= 1 then
							call User.addLumber(.owner,-1)
							call refresh()
							call refreshLumberRefresh()
						/*목재 부족하면*/
						else
							set CUSTOM_RESPOND_ERROR_MESSAGE = "목재가 부족합니다."
							set CUSTOM_RESPOND_ERROR_PLAYER = .owner
							call Event.activate(ENUM_EVENT_ERROR)
							if GetLocalPlayer() == Player(this) then
								call PlaySoundBJ(gg_snd_Error)
							endif
						endif
						return
					elseif BlzGetTriggerFrame() == BTN_DONATE then
						/*TODO donate*/
						if User.getGold(.owner) >= DONATE_COST and .level < LEVEL_MAX then
							call addExp(DONATE_EXP)
							call User.addGold(.owner,-DONATE_COST)
						/*상점 레벨업 골드 부족*/
						elseif User.getGold(.owner) < DONATE_COST then
							set CUSTOM_RESPOND_ERROR_MESSAGE = "금화가 부족합니다."
							set CUSTOM_RESPOND_ERROR_PLAYER = .owner
							call Event.activate(ENUM_EVENT_ERROR)
							if GetLocalPlayer() == Player(this) then
								call PlaySoundBJ(gg_snd_Error)
							endif
						/*상점 레벨업 이미 최대레벨*/
						elseif .level >= LEVEL_MAX then
							set CUSTOM_RESPOND_ERROR_MESSAGE = "더 이상 기부할 수 없습니다."
							set CUSTOM_RESPOND_ERROR_PLAYER = .owner
							call Event.activate(ENUM_EVENT_ERROR)
							if GetLocalPlayer() == Player(this) then
								call PlaySoundBJ(gg_snd_Error)
							endif
						endif
						return
					endif
				endif
			elseif not DEFEAT then
				/*PERIODIC*/
				set i = 0 
				loop
					exitwhen i >= CONFIG_PLAYER_MAX
					set this = i
					if User.getLumber(Player(this)) < LUMBER_MAX then
						/*목재가 꽉차있지 않음*/
						set .lumber_add_time = .lumber_add_time - 1
						if .lumber_add_time <= 0 then
							call User.addLumber(Player(this),1)
							set .lumber_add_time = LUMBER_ADD_TIME
						endif
					else
						/*목재가 꽉차있음*/
						set .lumber_add_time = LUMBER_ADD_TIME
					endif
					call refreshLumberRefresh()
					set i = i + 1
				endloop
			endif
		endmethod

		static method initFrames takes nothing returns nothing
			set CONTAINER = BlzCreateFrameByType("FRAME","",FRAME_SKILL_SHOP_BACKDROP,"",0)
			call BlzFrameSetPoint(CONTAINER,FRAMEPOINT_TOPLEFT,FRAME_SKILL_SHOP,FRAMEPOINT_TOPLEFT,0.,0.)
			/*목재로 리프레시*/
			set BTN_LUMBER_REFRESH = BlzCreateFrame("SkillShopLumberRefreshButton",CONTAINER,0,0)
			call BlzFrameSetPoint(BTN_LUMBER_REFRESH,FRAMEPOINT_TOPRIGHT,FRAME_SKILL_SHOP_BACKDROP,FRAMEPOINT_BOTTOMRIGHT,0.,0.)
			call BlzFrameSetSizePixel(BTN_LUMBER_REFRESH,240,56)
			call BlzFrameClearAllPoints(BlzGetFrameByName("SkillShopLumberRefreshButtonText",0))
			call BlzFrameSetPoint(BlzGetFrameByName("SkillShopLumberRefreshButtonText",0),FRAMEPOINT_CENTER,BTN_LUMBER_REFRESH,FRAMEPOINT_CENTER,Math.px2Size(12),0.)
			call BlzFrameSetTextAlignment(BlzGetFrameByName("SkillShopLumberRefreshButtonText",0),TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_CENTER)
			call BlzFrameSetTexture(BlzGetFrameByName("SkillShopLumberRefreshButtonIcon",0),"ui\\widgets\\tooltips\\human\\tooltiplumbericon.blp",0,true)
			call BlzFrameSetPoint(BlzGetFrameByName("SkillShopLumberRefreshButtonIcon",0),FRAMEPOINT_RIGHT,BlzGetFrameByName("SkillShopLumberRefreshButtonText",0),FRAMEPOINT_LEFT,-0.005,0.)
			call BlzFrameSetSize(BlzGetFrameByName("SkillShopLumberRefreshButtonIcon",0),Math.px2Size(24),Math.px2Size(24))
			/*리프레시타이머*/
			set LUMBER_REFRESH_TEXT_BACKDROP = BlzCreateFrame("MyTextBox",BTN_LUMBER_REFRESH,0,0)
			call BlzFrameSetPoint(LUMBER_REFRESH_TEXT_BACKDROP,FRAMEPOINT_BOTTOM,BTN_LUMBER_REFRESH,FRAMEPOINT_TOP,0.,-0.0025)
			call BlzFrameSetSize(LUMBER_REFRESH_TEXT_BACKDROP,0.09,0.015)
			set LUMBER_REFRESH_TEXT = BlzCreateFrame("MyText",LUMBER_REFRESH_TEXT_BACKDROP,0,0)
			call BlzFrameSetPoint(LUMBER_REFRESH_TEXT,FRAMEPOINT_CENTER,LUMBER_REFRESH_TEXT_BACKDROP,FRAMEPOINT_CENTER,0,0)
			call BlzFrameSetTextAlignment(LUMBER_REFRESH_TEXT,TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_CENTER)
			set LUMBER_SMALL_TIMER_BACKDROP = BlzCreateFrameByType("BACKDROP","",FRAME_SKILL_SHOP_BUTTON,"",0)
			call BlzFrameSetTexture(LUMBER_SMALL_TIMER_BACKDROP,"textures\\black32.blp",0,true)
			call BlzFrameSetAlpha(LUMBER_SMALL_TIMER_BACKDROP,192)
			set LUMBER_SMALL_TIMER_TEXT = BlzCreateFrame("MyTextSmall",FRAME_SKILL_SHOP_BUTTON,0,0)
			call BlzFrameSetPoint(LUMBER_SMALL_TIMER_TEXT,FRAMEPOINT_TOP,FRAME_SKILL_SHOP_BUTTON,FRAMEPOINT_BOTTOM,0,0.)
			call BlzFrameSetTextAlignment(LUMBER_SMALL_TIMER_TEXT,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_CENTER)
			call BlzFrameSetPoint(LUMBER_SMALL_TIMER_BACKDROP,FRAMEPOINT_TOPLEFT,LUMBER_SMALL_TIMER_TEXT,FRAMEPOINT_TOPLEFT,-0.002,0.002)
			call BlzFrameSetPoint(LUMBER_SMALL_TIMER_BACKDROP,FRAMEPOINT_BOTTOMRIGHT,LUMBER_SMALL_TIMER_TEXT,FRAMEPOINT_BOTTOMRIGHT,0.002,-0.002)
			/*리프레시버튼*/
			set BTN_REFRESH = BlzCreateFrame("SkillShopRefreshButton",CONTAINER,0,0)
			call BlzFrameSetPoint(BTN_REFRESH,FRAMEPOINT_TOPRIGHT,BTN_LUMBER_REFRESH,FRAMEPOINT_TOPLEFT,0.,0.)
			call BlzFrameSetSizePixel(BTN_REFRESH,240,56)
			call BlzFrameClearAllPoints(BlzGetFrameByName("SkillShopRefreshButtonText",0))
			call BlzFrameSetPoint(BlzGetFrameByName("SkillShopRefreshButtonText",0),FRAMEPOINT_CENTER,BTN_REFRESH,FRAMEPOINT_CENTER,Math.px2Size(12),0.)
			call BlzFrameSetTextAlignment(BlzGetFrameByName("SkillShopRefreshButtonText",0),TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_CENTER)
			call BlzFrameSetText(BlzGetFrameByName("SkillShopRefreshButtonText",0),"|cffffcc002|r |cffffffff: 새로고침|r")
			call BlzFrameSetTexture(BlzGetFrameByName("SkillShopRefreshButtonIcon",0),"ui\\widgets\\tooltips\\human\\tooltipgoldicon.blp",0,true)
			call BlzFrameSetPoint(BlzGetFrameByName("SkillShopRefreshButtonIcon",0),FRAMEPOINT_RIGHT,BlzGetFrameByName("SkillShopRefreshButtonText",0),FRAMEPOINT_LEFT,-0.005,0.)
			call BlzFrameSetSize(BlzGetFrameByName("SkillShopRefreshButtonIcon",0),Math.px2Size(24),Math.px2Size(24))
			/*도네이션*/
			set BTN_DONATE = BlzCreateFrame("SkillShopDonateButton",CONTAINER,0,0)
			call BlzFrameSetPoint(BTN_DONATE,FRAMEPOINT_TOPLEFT,FRAME_SKILL_SHOP_BACKDROP,FRAMEPOINT_BOTTOMLEFT,0.,0.)
			call BlzFrameSetSizePixel(BTN_DONATE,256,56)
			call BlzFrameClearAllPoints(BlzGetFrameByName("SkillShopDonateButtonText",0))
			call BlzFrameSetPoint(BlzGetFrameByName("SkillShopDonateButtonText",0),FRAMEPOINT_CENTER,BTN_DONATE,FRAMEPOINT_CENTER,Math.px2Size(12),0.)
			call BlzFrameSetTextAlignment(BlzGetFrameByName("SkillShopDonateButtonText",0),TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_CENTER)
			call BlzFrameSetText(BlzGetFrameByName("SkillShopDonateButtonText",0),"|cffffcc002|r |cffffffff: 기부하기 (품질 상승)|r")
			call BlzFrameSetTexture(BlzGetFrameByName("SkillShopDonateButtonIcon",0),"ui\\widgets\\tooltips\\human\\tooltipgoldicon.blp",0,true)
			call BlzFrameSetPoint(BlzGetFrameByName("SkillShopDonateButtonIcon",0),FRAMEPOINT_RIGHT,BlzGetFrameByName("SkillShopDonateButtonText",0),FRAMEPOINT_LEFT,-0.005,0.)
			call BlzFrameSetSize(BlzGetFrameByName("SkillShopDonateButtonIcon",0),Math.px2Size(24),Math.px2Size(24))
			/*상점경험치*/
			set EXP_OUTLINE = BlzCreateFrameByType("BACKDROP","",BTN_DONATE,"",0)
			call BlzFrameSetTexture(EXP_OUTLINE,"replaceabletextures\\teamcolor\\teamcolor16.blp",0,true)
			set EXP_BACKDROP = BlzCreateFrameByType("BACKDROP","",BTN_DONATE,"",0)
			call BlzFrameSetPointPixel(EXP_BACKDROP,FRAMEPOINT_BOTTOMLEFT,BTN_DONATE,FRAMEPOINT_TOPLEFT,2+32,2)
			call BlzFrameSetSizePixel(EXP_BACKDROP,EXP_GAUGE_WIDTH,16-4)
			call BlzFrameSetTexture(EXP_BACKDROP,"replaceabletextures\\teamcolor\\teamcolor26.blp",0,true)
			call BlzFrameSetAlpha(EXP_BACKDROP,200)
			set EXP_FILL = BlzCreateFrameByType("BACKDROP","",BTN_DONATE,"",0)
			call BlzFrameSetPoint(EXP_FILL,FRAMEPOINT_BOTTOMLEFT,EXP_BACKDROP,FRAMEPOINT_BOTTOMLEFT,0.,0.)
			call BlzFrameSetTexture(EXP_FILL,"replaceabletextures\\teamcolor\\teamcolor23.blp",0,true)
			call BlzFrameSetVisible(EXP_FILL,false)
			set EXP_TEXT = BlzCreateFrame("MyText",BTN_DONATE,0,0)
			call BlzFrameSetPoint(EXP_TEXT,FRAMEPOINT_CENTER,EXP_BACKDROP,FRAMEPOINT_CENTER,0.,0.)
			call BlzFrameSetPointPixel(EXP_OUTLINE,FRAMEPOINT_TOPLEFT,EXP_BACKDROP,FRAMEPOINT_TOPLEFT,-2,2)
			call BlzFrameSetPointPixel(EXP_OUTLINE,FRAMEPOINT_BOTTOMRIGHT,EXP_BACKDROP,FRAMEPOINT_BOTTOMRIGHT,2,-2)
			set LEVEL_BACKDROP = BlzCreateFrameByType("BACKDROP","",BTN_DONATE,"",0)
			call BlzFrameSetSizePixel(LEVEL_BACKDROP,32,32)
			call BlzFrameSetPoint(LEVEL_BACKDROP,FRAMEPOINT_BOTTOMRIGHT,EXP_OUTLINE,FRAMEPOINT_BOTTOMLEFT,0.,0.)
			call BlzFrameSetTexture(LEVEL_BACKDROP,"ui\\console\\human\\human-transport-slot.blp",0,true)
			set LEVEL_TEXT = BlzCreateFrame("MyText",BTN_DONATE,0,0)
			call BlzFrameSetPoint(LEVEL_TEXT,FRAMEPOINT_CENTER,LEVEL_BACKDROP,FRAMEPOINT_CENTER,0.,0.)
			call BlzFrameSetTextAlignment(LEVEL_TEXT,TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_CENTER)
			/*소지금*/
			set GOLD_BACKDROP = BlzCreateFrameByType("BACKDROP","",CONTAINER,"",0)
			call BlzFrameSetTexture(GOLD_BACKDROP,"Textures\\black32.blp",0,true)
			call BlzFrameSetAlpha(GOLD_BACKDROP,128)
			set GOLD_TEXT = BlzCreateFrame("MyTextLarge",CONTAINER,0,0)
			call BlzFrameSetPoint(GOLD_TEXT,FRAMEPOINT_TOP,FRAME_SKILL_SHOP_BACKDROP,FRAMEPOINT_BOTTOM,0.0025+Math.px2Size(16),-0.005)
			call BlzFrameSetTextAlignment(GOLD_TEXT,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_CENTER)
			call BlzFrameSetText(GOLD_TEXT,"")
			set GOLD_ICON = BlzCreateFrameByType("BACKDROP","",CONTAINER,"",0)
			call BlzFrameSetTexture(GOLD_ICON,"ui\\widgets\\tooltips\\human\\tooltipgoldicon.blp",0,true)
			call BlzFrameSetPoint(GOLD_ICON,FRAMEPOINT_RIGHT,GOLD_TEXT,FRAMEPOINT_LEFT,-0.005,0.)
			call BlzFrameSetSize(GOLD_ICON,Math.px2Size(32),Math.px2Size(32))
			/*setPoint*/
			call BlzFrameSetPoint(GOLD_BACKDROP,FRAMEPOINT_TOPRIGHT,GOLD_TEXT,FRAMEPOINT_TOPRIGHT,0.005,0.005)
			call BlzFrameSetPoint(GOLD_BACKDROP,FRAMEPOINT_BOTTOMLEFT,GOLD_TEXT,FRAMEPOINT_BOTTOMLEFT,-0.005-0.005-Math.px2Size(32),-0.005)
			/*확률정보*/
			set CHANCE_BACKDROP = BlzCreateFrame("MyTextBox",BTN_DONATE,0,0)
			set CHANCE_TEXT = BlzCreateFrame("MyTextSmall",BTN_DONATE,0,0)
			call BlzFrameSetPoint(CHANCE_TEXT,FRAMEPOINT_LEFT,BTN_DONATE,FRAMEPOINT_RIGHT,0.005+Math.px2Size(16),0.)
			call BlzFrameSetPoint(CHANCE_BACKDROP,FRAMEPOINT_TOPLEFT,CHANCE_TEXT,FRAMEPOINT_TOPLEFT,-0.005,0.005)
			call BlzFrameSetPoint(CHANCE_BACKDROP,FRAMEPOINT_BOTTOMRIGHT,CHANCE_TEXT,FRAMEPOINT_BOTTOMRIGHT,0.005,-0.005)
			/*닫기버튼*/
			set BTN_CLOSE = BlzCreateFrame("GenericCloseButton",CONTAINER,0,0)
			call BlzFrameSetPointPixel(BTN_CLOSE,FRAMEPOINT_TOPLEFT,FRAME_SKILL_SHOP_BACKDROP,FRAMEPOINT_TOPRIGHT,0,0)
			/*공용트리거*/
			set KEYPRESS = CreateTrigger()
			call BlzTriggerRegisterFrameEvent(KEYPRESS,BTN_REFRESH,FRAMEEVENT_CONTROL_CLICK)
			call BlzTriggerRegisterFrameEvent(KEYPRESS,BTN_REFRESH,FRAMEEVENT_MOUSE_LEAVE)
			call BlzTriggerRegisterFrameEvent(KEYPRESS,BTN_LUMBER_REFRESH,FRAMEEVENT_CONTROL_CLICK)
			call BlzTriggerRegisterFrameEvent(KEYPRESS,BTN_LUMBER_REFRESH,FRAMEEVENT_MOUSE_LEAVE)
			call BlzTriggerRegisterFrameEvent(KEYPRESS,BTN_DONATE,FRAMEEVENT_CONTROL_CLICK)
			call BlzTriggerRegisterFrameEvent(KEYPRESS,BTN_DONATE,FRAMEEVENT_MOUSE_LEAVE)
			call BlzTriggerRegisterFrameEvent(KEYPRESS,BTN_CLOSE,FRAMEEVENT_CONTROL_CLICK)
			call BlzTriggerRegisterFrameEvent(KEYPRESS,BTN_CLOSE,FRAMEEVENT_MOUSE_LEAVE)
			call TriggerRegisterTimerEvent(KEYPRESS,1.0,true)
			call TriggerAddCondition(KEYPRESS,function thistype.press)
			call Event.register(KEYPRESS,ENUM_EVENT_KEYPRESS)
			/**/
		endmethod

		static method create takes player p returns thistype
			local thistype this = GetPlayerId(p)
			local integer i = 0
			/*set default*/
			set .level = 1
			set .exp = 0
			set .exp_max = 2
			set .autorefresh = true
			set .lumber_add_time = LUMBER_ADD_TIME
			set .visible_flag = false
			/**/
			if not ACTIVATED then
				call initFrames()
				set ACTIVATED = true
			endif
			/*위젯 초기화*/
			loop
				exitwhen i >= WIDGET_COUNT
				call SkillShopWidget.create(CONTAINER,Player(this),i)
				set i = i + 1
			endloop
			/*리프레시 한 번*/
			call refreshLumberRefresh()
			call setLevel(1)
			call refresh()
			call refreshGold()
			return this
		endmethod

		method destroy takes nothing returns nothing

		endmethod

		static method staticRefreshGold takes nothing returns nothing
			local thistype this = GetPlayerId(GOLD_REFRESH_PLAYER)
			call refreshGold()
		endmethod

		static method getTierChance takes integer level, integer tier returns integer
			local integer i = level
			if i > CHANCE_LEVEL_MAX then
				set i = CHANCE_LEVEL_MAX
			endif
			if tier == 1 then
				return CHANCE_TIER1[i]
			elseif tier == 2 then
				return CHANCE_TIER2[i]
			elseif tier == 3 then
				return CHANCE_TIER3[i]
			elseif tier == 4 then
				return CHANCE_TIER4[i]
			elseif tier == 5 then
				return CHANCE_TIER5[i]
			endif
			return 0
		endmethod

		static method initTierChance takes integer level, integer t1, integer t2, integer t3, integer t4, integer t5 returns nothing
			if level < 0 then
				return
			endif
			/*확률치 설정 (레벨기반이라 제로베이스 아님 주의)*/
			set CHANCE_TIER1[level] = t1
			set CHANCE_TIER2[level] = t2
			set CHANCE_TIER3[level] = t3
			set CHANCE_TIER4[level] = t4
			set CHANCE_TIER5[level] = t5
		endmethod

		static method onInit takes nothing returns nothing
			local integer i = 1
			call TriggerAddCondition(GOLD_REFRESH_TRIGGER,function thistype.staticRefreshGold)
			/*확률치 설정 (레벨기반이라 제로베이스 아님 주의)*/
			call initTierChance(1	,80	,20	,0	,0	,0	)
			call initTierChance(2	,75	,25	,0	,0	,0	)
			call initTierChance(3	,70	,25	,5	,0	,0	)
			call initTierChance(4	,60	,30	,10	,0	,0	)
			call initTierChance(5	,55	,30	,10	,5	,0	)
			call initTierChance(6	,54	,25	,15 ,5	,1	)
			call initTierChance(7	,43	,25	,20	,7	,5	)
			call initTierChance(8	,40	,25	,20	,10	,5	)
			call initTierChance(9	,40	,25	,20	,10	,5	)
			call initTierChance(10	,30	,20	,25	,15	,10	)
			call initTierChance(11	,20	,20	,25	,20	,15	)
			/*확률치 합*/
			loop
				/*레벨[~~] 까지*/
				exitwhen i > CHANCE_LEVEL_MAX
				set CHANCE_TOTAL[i] = CHANCE_TIER1[i] + CHANCE_TIER2[i] + CHANCE_TIER3[i] + CHANCE_TIER4[i] + CHANCE_TIER5[i]
				set i = i + 1
			endloop
			/*경험치테이블*/
			set MAX_EXP[1] = 1
			set MAX_EXP[2] = 3
			set MAX_EXP[3] = 5
			set MAX_EXP[4] = 10
			set MAX_EXP[5] = 18
			set MAX_EXP[6] = 28
			set MAX_EXP[7] = 40
			set MAX_EXP[8] = 56
			set MAX_EXP[9] = 72
			set MAX_EXP[10] = 88
			set MAX_EXP[11] = 105
		endmethod

	endstruct

endlibrary