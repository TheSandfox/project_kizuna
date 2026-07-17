struct AbilityIcon extends array

    private static constant integer TOOLTIP_SUB_WIDTH = 64
    private static constant integer TOOLTIP_SUB_HEIGHT = 20
    private static constant integer TOOLTIP_HEADER_HEIGHT = 96
    private static constant integer TOOLTIP_ICON_SIZE = 48
    private static constant integer TOOLTIP_STAT_BONUS_HEIGHT = 40
	private static constant integer TOOLTIP_DETAIL_HEIGHT = 48

    private static framehandle array ICON_CONTAINER[CONFIG_ABILITY_SIZE]
    private static framehandle array ICON_BACKDROP[CONFIG_ABILITY_SIZE]
    private static framehandle array ICON_BORDER[CONFIG_ABILITY_SIZE]
	private static framehandle array DISABLED_BACKDROP[CONFIG_ABILITY_SIZE]
    private static framehandle array NEM_BACKDROP[CONFIG_ABILITY_SIZE]
    private static framehandle array COOLDOWN_BACKDROP[CONFIG_ABILITY_SIZE]
    private static framehandle array COOLDOWN_TEXT[CONFIG_ABILITY_SIZE]
    private static framehandle array COOLDOWN_TEXT_BACKDROP[CONFIG_ABILITY_SIZE]
    private static framehandle array HOTKEY_BACKDROP[CONFIG_ABILITY_SIZE]
    private static framehandle array HOTKEY_TEXT[CONFIG_ABILITY_SIZE]
    private static framehandle array GAUGE_BACKDROP[CONFIG_ABILITY_SIZE]
    private static framehandle array GAUGE_FILL[CONFIG_ABILITY_SIZE]
    private static framehandle array EXTRA_BACKDROP[CONFIG_ABILITY_SIZE]
    private static framehandle array EXTRA_TEXT[CONFIG_ABILITY_SIZE]
    private static framehandle array WEAPON_PARTICLE[CONFIG_ABILITY_SIZE]
    private static framehandle array TOOLTIP_MOUSEOVER[CONFIG_ABILITY_SIZE]
    private static framehandle array TOOLTIP_CONTAINER[CONFIG_ABILITY_SIZE]
    private static framehandle array TOOLTIP_OUTLINE[CONFIG_ABILITY_SIZE]
    private static framehandle array TOOLTIP_BACKDROP[CONFIG_ABILITY_SIZE]
    private static framehandle array TOOLTIP_TEXT[CONFIG_ABILITY_SIZE]
    private static framehandle array TOOLTIP_STAT_BONUS_ICON1[CONFIG_ABILITY_SIZE]
    private static framehandle array TOOLTIP_STAT_BONUS_ICON2[CONFIG_ABILITY_SIZE]
    private static framehandle array TOOLTIP_STAT_BONUS_TEXT1[CONFIG_ABILITY_SIZE]
    private static framehandle array TOOLTIP_STAT_BONUS_TEXT2[CONFIG_ABILITY_SIZE]
	private static framehandle array TOOLTIP_COST_SPEND_BACKDROP1[CONFIG_ABILITY_SIZE]
	private static framehandle array TOOLTIP_COST_SPEND_BACKDROP2[CONFIG_ABILITY_SIZE]
	private static framehandle array TOOLTIP_COST_SPEND_BACKDROP3[CONFIG_ABILITY_SIZE]
	private static framehandle array TOOLTIP_COST_SPEND_BACKDROP4[CONFIG_ABILITY_SIZE]
	private static framehandle array TOOLTIP_COST_SPEND_TEXT1[CONFIG_ABILITY_SIZE]
	private static framehandle array TOOLTIP_COST_SPEND_TEXT2[CONFIG_ABILITY_SIZE]
	private static framehandle array TOOLTIP_COST_SPEND_TEXT3[CONFIG_ABILITY_SIZE]
	private static framehandle array TOOLTIP_COST_SPEND_TEXT4[CONFIG_ABILITY_SIZE]
    private static framehandle array TOOLTIP_HEADER[CONFIG_ABILITY_SIZE]
    private static framehandle array TOOLTIP_ICON[CONFIG_ABILITY_SIZE]
    private static framehandle array TOOLTIP_ICON_BORDER[CONFIG_ABILITY_SIZE]
    private static framehandle array TOOLTIP_ICON_WEAPON[CONFIG_ABILITY_SIZE]
    private static framehandle array TOOLTIP_NAME[CONFIG_ABILITY_SIZE]
    private static framehandle array TOOLTIP_TAG[CONFIG_ABILITY_SIZE]
    private static framehandle array TOOLTIP_CASTTYPE[CONFIG_ABILITY_SIZE]
    private static framehandle array TOOLTIP_MANACOST_BACKDROP[CONFIG_ABILITY_SIZE]
    private static framehandle array TOOLTIP_MANACOST_TEXT[CONFIG_ABILITY_SIZE]
    private static framehandle array TOOLTIP_COOLDOWN_BACKDROP[CONFIG_ABILITY_SIZE]
    private static framehandle array TOOLTIP_COOLDOWN_TEXT[CONFIG_ABILITY_SIZE]
	private static framehandle array TOOLTIP_CUSTOM_COST_TEXT[CONFIG_ABILITY_SIZE]
	private static framehandle array TOOLTIP_DETAIL[CONFIG_ABILITY_SIZE]
	private static framehandle array UNIQUE_BACKDROP[CONFIG_ABILITY_SIZE]
    private static framehandle array UNIQUE[CONFIG_ABILITY_SIZE]
	private static trigger array BTN_TRIGGER[CONFIG_ABILITY_SIZE]
    private static boolean array FLAG_FRAME[CONFIG_ABILITY_SIZE]

	static trigger REFRESH = null

    integer index
    boolean mouse_in
	player owner
	Ability target

	static method getPlayerIcon takes player p, integer index returns thistype
		return GetPlayerId(p)*CONFIG_ABILITY_SIZE + index
	endmethod

	method refreshTooltip takes nothing returns nothing
		if .target > 0 and GetLocalPlayer() == .owner then
			/*툴팁텍스트 & 스탯보너스*/
			if Ability.getTypeTier(.target.id) > 0 then
				call BlzFrameSetText(TOOLTIP_TEXT[.index],.target.relativeTooltip(.target.owner)+"\n\n|cff00ffff스탯 보너스 : |r")
				/*스탯보너스*/
				call BlzFrameSetText(TOOLTIP_STAT_BONUS_TEXT1[.index],CUSTOM_STRING_STAT_NAME[Ability.getTypeBonusStatIndex(.target.id,0)] + " +"+ /*
				*/CustomString.statStringReal(Ability.getTypeBonusStatIndex(.target.id,0),.target.stat_bonus1,1))
				call BlzFrameSetText(TOOLTIP_STAT_BONUS_TEXT2[.index],CUSTOM_STRING_STAT_NAME[Ability.getTypeBonusStatIndex(.target.id,1)] + " +"+ /*
				*/CustomString.statStringReal(Ability.getTypeBonusStatIndex(.target.id,1),.target.stat_bonus2,1))
				call BlzFrameSetVisible(TOOLTIP_STAT_BONUS_TEXT1[.index],true)
				call BlzFrameSetVisible(TOOLTIP_STAT_BONUS_TEXT2[.index],true)
			else
				call BlzFrameSetText(TOOLTIP_TEXT[.index],.target.relativeTooltip(.target.owner))
				call BlzFrameSetVisible(TOOLTIP_STAT_BONUS_TEXT1[.index],false)
				call BlzFrameSetVisible(TOOLTIP_STAT_BONUS_TEXT2[.index],false)
			endif
			/*무기사거리 & 무기딜레이*/
			if Ability.getTypeIsWeapon(.target.id) then
				call BlzFrameSetText(TOOLTIP_MANACOST_TEXT[.index],"|cff00ffff"+I2S(R2I(.target.weapon_range))+"|r")
				call BlzFrameSetText(TOOLTIP_COOLDOWN_TEXT[.index],"|cffffff99"+R2SW(.target.weapon_delay / .target.getAttackSpeedValue(.target.owner.getCarculatedStatValue(CONFIG_STAT_ATTACK_SPEED)),2,2)+"|r")
			/*마나코스트 & 쿨다운*/
			else
				call BlzFrameSetText(TOOLTIP_MANACOST_TEXT[.index],"|cff0099ff"+I2S(R2I(.target.getCarculatedManacost()))+"|r")
				call BlzFrameSetText(TOOLTIP_COOLDOWN_TEXT[.index],"|cffffff99"+R2SW(.target.getCarculatedMaxCooldown(),2,2)+"|r\n"+/*
					*/"|cff999999/"+R2SW(.target.cooldown_min,2,2)+"|r")
			endif
			/*커스텀 코스트*/
			call BlzFrameSetText(TOOLTIP_CUSTOM_COST_TEXT[.index],.target.customCostTooltip())
		endif
	endmethod

    method refresh takes nothing returns nothing
        if .target > 0 and GetLocalPlayer() == .owner then
			/*쿨타임 백드롭*/
			call BlzFrameSetVisible(COOLDOWN_TEXT[.index],.target.getUICooldown()>0.)
			call BlzFrameSetVisible(COOLDOWN_TEXT_BACKDROP[.index],.target.getUICooldown()>0.)
			call BlzFrameSetVisible(COOLDOWN_BACKDROP[.index],.target.getUICooldown()>0. and .target.getCarculatedMaxCooldown() > 0.)
			call BlzFrameSetText(COOLDOWN_TEXT[.index],R2SW(.target.getUICooldown(),1,1))
			if .target.getCount() == 0 then
				call BlzFrameSetAlpha(COOLDOWN_BACKDROP[.index],128)
			else
				call BlzFrameSetAlpha(COOLDOWN_BACKDROP[.index],32)
			endif
			if .target.getCarculatedMaxCooldown() > 0. then
				call BlzFrameSetPoint(COOLDOWN_BACKDROP[.index],FRAMEPOINT_TOPRIGHT,ICON_BACKDROP[.index],FRAMEPOINT_BOTTOMRIGHT,/*
					*/0.,Math.px2Size(ABILITY_ICON_SIZE)*(.target.getUICooldown()/.target.getCarculatedMaxCooldown()))
			endif
			/*디저블 백드롭*/
			call BlzFrameSetVisible(DISABLED_BACKDROP[.index],not (.target.enableFilter() and .target.useFilterAdditional()))
			/*마나부족백드롭*/
			call BlzFrameSetVisible(NEM_BACKDROP[.index],.target.owner.mp < .target.getCarculatedManacost())
			/*엑스트라밸류*/
			call BlzFrameSetVisible(EXTRA_BACKDROP[.index],.target.count_max > 1)
			call BlzFrameSetVisible(EXTRA_TEXT[.index],.target.count_max > 1)
			call BlzFrameSetText(EXTRA_TEXT[.index],I2S(.target.count))
			/*게이지*/
			call BlzFrameSetVisible(GAUGE_BACKDROP[.index],.target.gauge>0.)
			call BlzFrameSetPoint(GAUGE_FILL[.index],FRAMEPOINT_BOTTOMRIGHT,GAUGE_BACKDROP[.index],FRAMEPOINT_BOTTOMLEFT,Math.px2Size(ABILITY_ICON_SIZE)*.target.gauge,0)
        endif
    endmethod

	method showTooltip takes boolean flag returns nothing
		if GetLocalPlayer() == .owner then
			call BlzFrameSetVisible(TOOLTIP_CONTAINER[.index],flag)
            if flag then
                call refreshTooltip()
            endif
		endif
	endmethod

    method setTarget takes Ability na returns nothing
        local integer i = 0
        local integer j = 0
        local string s = "|cffffff00"
        set .target = na
        if GetLocalPlayer() == .owner then
            /*타겟이 유효할때만 아이콘 표시*/
            call BlzFrameSetVisible(ICON_CONTAINER[.index],.target > 0)
        endif
        if .target > 0 then
            if GetLocalPlayer() == .owner then
                /*아이콘바꾸기*/
                call BlzFrameSetTexture(ICON_BACKDROP[.index],.target.icon,0,true)
                if .target.is_active then
                    call BlzFrameSetVisible(ICON_BORDER[.index],true)
					call BlzFrameSetTexture(ICON_BORDER[.index],"ReplaceableTextures\\CommandButtons\\bm_btn.blp",0,true)
                else
                    call BlzFrameSetVisible(ICON_BORDER[.index],true)
                    call BlzFrameSetTexture(ICON_BORDER[.index],"ReplaceableTextures\\CommandButtons\\bm_pasbtn.blp",0,true)
                endif
                call BlzFrameSetTexture(TOOLTIP_ICON[.index],.target.icon,0,true)
                call BlzFrameSetTexture(TOOLTIP_ICON_BORDER[.index],"Textures\\ability_border_tier"+I2S(Ability.getTypeTier(.target.id))+".blp",0,true)
				/*상세툴팁(일반스킬/무기스킬)*/
				if Ability.getTypeIsWeapon(.target.id) then
					call BlzFrameSetText(TOOLTIP_DETAIL[.index],"|cff999999Shift : 자세히 보기\nCtrl + 단축키 : 장착 해제|r")
				else
					call BlzFrameSetText(TOOLTIP_DETAIL[.index],"|cff999999Shift : 자세히 보기\nCtrl + 단축키 : 빠른 시전(스마트캐스트) 설정 변경|r")
				endif
                /*툴팁 스킬이름*/
				if Ability.getTypeTier(.target.id) > 0 then
                	call BlzFrameSetText(TOOLTIP_NAME[.index],CUSTOM_STRING_TIER_COLOR[Ability.getTypeTier(.target.id)]+.target.name+"|r |cffffff00Lv. "+I2S(.target.level)+"|r|cff999999/"+I2S(.target.level_max)+"|r")
				else
					call BlzFrameSetText(TOOLTIP_NAME[.index],CUSTOM_STRING_TIER_COLOR[0]+.target.name+"|r")
				endif
                /*단축키색깔(스마트여부)*/
                if Ability.getTypeIsWeapon(.target.id) then
					/*무기*/
                    call BlzFrameSetText(HOTKEY_TEXT[.index],"|cffcc0000"+User.oskeyIndex2String(.index)+"|r")
                else
                    if .target.smart == 0 then
                        call BlzFrameSetText(HOTKEY_TEXT[.index],"|cff999999"+User.oskeyIndex2String(.index)+"|r")
                    elseif .target.smart == 1 then
                        call BlzFrameSetText(HOTKEY_TEXT[.index],"|cffffcc00"+User.oskeyIndex2String(.index)+"|r")
                    elseif .target.smart == 2 then
                        call BlzFrameSetText(HOTKEY_TEXT[.index],"|cff00ffff"+User.oskeyIndex2String(.index)+"|r")
                    endif
                endif
                /*어빌리티 캐스트타입*/
                call BlzFrameSetText(TOOLTIP_CASTTYPE[.index],"|cff00ffff"+CUSTOM_STRING_CAST_TYPE_NAME[Ability.getTypeCastType(.target.id)]+"|r")
                /*무기어빌리티면 모델프레임 표시*/
                call BlzFrameSetVisible(WEAPON_PARTICLE[.index],.target == .target.owner.weapon_ability)
                /*무기어빌리티면 마나코스트 아이콘 바꾸기*/
                if Ability.getTypeIsWeapon(.target.id) then
                    call BlzFrameSetVisible(TOOLTIP_ICON_WEAPON[.index],true)
                    call BlzFrameSetTexture(TOOLTIP_MANACOST_BACKDROP[.index],CUSTOM_STRING_STAT_ICON[CONFIG_STAT_ATTACK_RANGE],0,true)
                else
                    call BlzFrameSetVisible(TOOLTIP_ICON_WEAPON[.index],false)
                    call BlzFrameSetTexture(TOOLTIP_MANACOST_BACKDROP[.index],CUSTOM_STRING_STAT_ICON[CONFIG_STAT_MAXMP],0,true)
                endif
            endif
            /*어빌리티 태그*/
            loop
                set j = DamageTag.get(.target.id,i)
                exitwhen j < 0
                if i > 0 then
                    set s = s + ", " + CUSTOM_STRING_ABILITY_TAG_NAME[j]
                else
                    set s = s + CUSTOM_STRING_ABILITY_TAG_NAME[j]
                endif
                set i = i + 1
            endloop
            set s = s + "|r"
            if GetLocalPlayer() == .owner then
                call BlzFrameSetText(TOOLTIP_TAG[.index],s)
                /*스탯보너스*/
				call BlzFrameSetVisible(TOOLTIP_STAT_BONUS_ICON1[.index],Ability.getTypeTier(.target.id)>0)
				call BlzFrameSetVisible(TOOLTIP_STAT_BONUS_ICON2[.index],Ability.getTypeTier(.target.id)>0)
                call BlzFrameSetTexture(TOOLTIP_STAT_BONUS_ICON1[.index],CUSTOM_STRING_STAT_ICON[Ability.getTypeBonusStatIndex(.target.id,0)],0,true)
                call BlzFrameSetTexture(TOOLTIP_STAT_BONUS_ICON2[.index],CUSTOM_STRING_STAT_ICON[Ability.getTypeBonusStatIndex(.target.id,1)],0,true)
                /*시그니쳐일 경우 텍스트 표시*/
                call BlzFrameSetVisible(UNIQUE[.index],.target.signature)
				call BlzFrameSetVisible(UNIQUE_BACKDROP[.index],.target.signature)
				/*골드사용량*/
				if .target.getUpgradePoint(CONFIG_UPGRADE_GOLD) <= 0 then
					call BlzFrameSetText(TOOLTIP_COST_SPEND_TEXT1[.index],"|cff9999990|r")
				else
					call BlzFrameSetText(TOOLTIP_COST_SPEND_TEXT1[.index],"|cffffcc00"+I2S(.target.getUpgradePoint(CONFIG_UPGRADE_GOLD))+"|r")
				endif
				/*스킬포인트사용량*/
				if .target.getUpgradePoint(CONFIG_UPGRADE_SKILL_POINT) <= 0 then
					call BlzFrameSetText(TOOLTIP_COST_SPEND_TEXT2[.index],"|cff9999990|r")
				else
					call BlzFrameSetText(TOOLTIP_COST_SPEND_TEXT2[.index],"|cffff9900"+I2S(.target.getUpgradePoint(CONFIG_UPGRADE_SKILL_POINT))+"|r")
				endif
				/*행운누적량*/
				if .target.getUpgradePoint(CONFIG_UPGRADE_LUCK) <= 0 then
					call BlzFrameSetText(TOOLTIP_COST_SPEND_TEXT3[.index],"|cff9999990|r")
				else
					call BlzFrameSetText(TOOLTIP_COST_SPEND_TEXT3[.index],"|cff00cc00"+I2S(.target.getUpgradePoint(CONFIG_UPGRADE_LUCK))+"|r")
				endif
				/*EXP누적량*/
				if .target.getUpgradePoint(CONFIG_UPGRADE_EXP) <= 0 then
					call BlzFrameSetText(TOOLTIP_COST_SPEND_TEXT4[.index],"|cff9999990|r")
				else
					call BlzFrameSetText(TOOLTIP_COST_SPEND_TEXT4[.index],"|cff0099cc"+I2S(.target.getUpgradePoint(CONFIG_UPGRADE_EXP))+"|r")
				endif
            endif
            /*최종 리프레시*/
            call refresh()
			call refreshTooltip()
            /*버튼 활성화*/
            if GetLocalPlayer() == .owner then
				call BlzFrameSetVisible(TOOLTIP_MOUSEOVER[.index],true)
			endif
        else
            /*버튼 비활성화*/
            set .mouse_in = false
            /*버튼 활성화*/
            if GetLocalPlayer() == .owner then
				call BlzFrameSetVisible(TOOLTIP_MOUSEOVER[.index],false)
			endif
        endif
    endmethod

    static method click takes nothing returns nothing
        local thistype this = GetPlayerId(GetTriggerPlayer())*CONFIG_ABILITY_SIZE + Trigger.getData(GetTriggeringTrigger())
        /*다른 플레이어가 한거면 컷*/
        if GetTriggerPlayer() != .owner then
            return
        endif
        if BlzGetTriggerFrame() != null and GetLocalPlayer() == .owner then
			if BlzGetTriggerFrameEvent() != FRAMEEVENT_MOUSE_ENTER then
				call BlzFrameSetEnable(BlzGetTriggerFrame(),false)
				call BlzFrameSetEnable(BlzGetTriggerFrame(),true)
			endif
        endif
        if BlzGetTriggerFrameEvent() == FRAMEEVENT_CONTROL_CLICK then
            if .target > 0 then
                call .target.iconClick()
                if GetLocalPlayer() == GetTriggerPlayer() then
                    call PlaySoundBJ(gg_snd_BigButtonClick)
                endif
                call setTarget(.target)
            endif
            return
        elseif BlzGetTriggerPlayerMouseButton() == MOUSE_BUTTON_TYPE_RIGHT then
            if .mouse_in and .target > 0 then
				call .target.iconRightClick()
                call setTarget(.target)
            endif
        elseif BlzGetTriggerFrameEvent() == FRAMEEVENT_MOUSE_ENTER then
            set .mouse_in = true
			call showTooltip(true)
        elseif BlzGetTriggerFrameEvent() == FRAMEEVENT_MOUSE_LEAVE then
            set .mouse_in = false
			call showTooltip(false)
        endif
    endmethod

    static method initFrames takes integer index, framehandle parent returns nothing
        local framehandle pivot = FRAME_ABILITY_ICON[index]
        /*아이콘 콘테이너*/
        set ICON_CONTAINER[index] = BlzCreateFrameByType("BACKDROP","",parent,"",0)
        call BlzFrameSetPoint(ICON_CONTAINER[index],FRAMEPOINT_BOTTOMLEFT,pivot,FRAMEPOINT_BOTTOMLEFT,0.,0.)
        set ICON_BACKDROP[index] = BlzCreateFrameByType("BACKDROP","",ICON_CONTAINER[index],"",0)
        call BlzFrameSetAllPoints(ICON_BACKDROP[index],pivot)
        call BlzFrameSetTexture(ICON_BACKDROP[index],"ReplaceableTextures\\CommandButtons\\BTNBlackIcon.blp",0,true)
        set ICON_BORDER[index] = BlzCreateFrameByType("BACKDROP","",ICON_CONTAINER[index],"",0)
        call BlzFrameSetAllPoints(ICON_BORDER[index],ICON_BACKDROP[index])
        call BlzFrameSetTexture(ICON_BACKDROP[index],"ReplaceableTextures\\CommandButtons\\bm_btn.blp",0,true)
        call BlzFrameSetVisible(ICON_BORDER[index],false)
		/*디저블*/
		set DISABLED_BACKDROP[index] = BlzCreateFrameByType("BACKDROP","",ICON_CONTAINER[index],"",0)
		call BlzFrameSetAllPoints(DISABLED_BACKDROP[index],pivot)
		call BlzFrameSetTexture(DISABLED_BACKDROP[index],"ReplaceableTextures\\CommandButtons\\bm_disbtn2.blp",0,true)
		call BlzFrameSetVisible(DISABLED_BACKDROP[index],false)
		/*낫이너프마나*/
        set NEM_BACKDROP[index] = BlzCreateFrameByType("BACKDROP","",ICON_CONTAINER[index],"",0)
        call BlzFrameSetAllPoints(NEM_BACKDROP[index],pivot)
        call BlzFrameSetTexture(NEM_BACKDROP[index],"ReplaceableTextures\\teamcolor\\teamcolor14.blp",0,true)
        call BlzFrameSetAlpha(NEM_BACKDROP[index],168)
        call BlzFrameSetVisible(NEM_BACKDROP[index],false)
		/*쿨다운*/
        set COOLDOWN_BACKDROP[index] = BlzCreateFrameByType("BACKDROP","",ICON_CONTAINER[index],"",0)
        call BlzFrameSetPoint(COOLDOWN_BACKDROP[index],FRAMEPOINT_BOTTOMLEFT,pivot,FRAMEPOINT_BOTTOMLEFT,0.,0.)
        call BlzFrameSetPoint(COOLDOWN_BACKDROP[index],FRAMEPOINT_TOPRIGHT,pivot,FRAMEPOINT_BOTTOMLEFT,Math.px2Size(ABILITY_ICON_SIZE),Math.px2Size(ABILITY_ICON_SIZE)/2)
        call BlzFrameSetTexture(COOLDOWN_BACKDROP[index],"Textures\\Black32.blp",0,true)
        call BlzFrameSetAlpha(COOLDOWN_BACKDROP[index],128)
        set COOLDOWN_TEXT_BACKDROP[index] = BlzCreateFrameByType("BACKDROP","",ICON_CONTAINER[index],"",0)
        call BlzFrameSetTexture(COOLDOWN_TEXT_BACKDROP[index],"Textures\\Black32.blp",0,true)
        call BlzFrameSetAlpha(COOLDOWN_TEXT_BACKDROP[index],128)
        set COOLDOWN_TEXT[index] = BlzCreateFrame("MyText",ICON_CONTAINER[index],0,0)
        call BlzFrameSetPoint(COOLDOWN_TEXT[index],FRAMEPOINT_CENTER,ICON_BACKDROP[index],FRAMEPOINT_CENTER,0.,0.)
        call BlzFrameSetTextAlignment(COOLDOWN_TEXT[index],TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_CENTER)
        call BlzFrameSetText(COOLDOWN_TEXT[index],"0.00")
        call BlzFrameSetAllPoints(COOLDOWN_TEXT_BACKDROP[index],COOLDOWN_TEXT[index])
		/*단축키(아이콘 위)*/
        set HOTKEY_BACKDROP[index] = BlzCreateFrameByType("BACKDROP","",ICON_CONTAINER[index],"",0)
        call BlzFrameSetPoint(HOTKEY_BACKDROP[index],FRAMEPOINT_TOPLEFT,pivot,FRAMEPOINT_TOPLEFT,0.,0.)
        call BlzFrameSetSize(HOTKEY_BACKDROP[index],Math.px2Size(20),Math.px2Size(20))
        call BlzFrameSetTexture(HOTKEY_BACKDROP[index],"ui\\console\\human\\human-transport-slot.blp",0,true)
        call BlzFrameSetAlpha(HOTKEY_BACKDROP[index],200)
        set HOTKEY_TEXT[index] = BlzCreateFrame("MyText",ICON_CONTAINER[index],0,0)
        call BlzFrameSetAllPoints(HOTKEY_TEXT[index],HOTKEY_BACKDROP[index])
        call BlzFrameSetTextAlignment(HOTKEY_TEXT[index],TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_CENTER)
        call BlzFrameSetText(HOTKEY_TEXT[index],"|cffffcc00"+User.oskeyIndex2String(index)+"|r")
		/*게이지*/
        set GAUGE_BACKDROP[index] = BlzCreateFrameByType("BACKDROP","",ICON_CONTAINER[index],"",0)
        call BlzFrameSetPoint(GAUGE_BACKDROP[index],FRAMEPOINT_TOPLEFT,pivot,FRAMEPOINT_BOTTOMLEFT,0.,0.)
        call BlzFrameSetSize(GAUGE_BACKDROP[index],Math.px2Size(ABILITY_ICON_SIZE),Math.px2Size(8))
        call BlzFrameSetTexture(GAUGE_BACKDROP[index],"ui\\feedback\\buildprogressbar\\min-hud-human-buildprogressbar-border.blp",0,true)
        set GAUGE_FILL[index] = BlzCreateFrameByType("BACKDROP","",GAUGE_BACKDROP[index],"",0)
        call BlzFrameSetPoint(GAUGE_FILL[index],FRAMEPOINT_TOPLEFT,GAUGE_BACKDROP[index],FRAMEPOINT_TOPLEFT,0.,0.)
        call BlzFrameSetSize(GAUGE_FILL[index],Math.px2Size(ABILITY_ICON_SIZE/2),Math.px2Size(8))
        call BlzFrameSetTexture(GAUGE_FILL[index],"ui\\feedback\\buildprogressbar\\min-hud-human-buildprogressbar-fill.blp",0,true)
		/*충전량*/
        set EXTRA_BACKDROP[index] = BlzCreateFrameByType("BACKDROP","",ICON_CONTAINER[index],"",0)
        call BlzFrameSetPoint(EXTRA_BACKDROP[index],FRAMEPOINT_BOTTOMRIGHT,pivot,FRAMEPOINT_BOTTOMRIGHT,0.,0.)
        call BlzFrameSetSize(EXTRA_BACKDROP[index],Math.px2Size(20),Math.px2Size(20))
        call BlzFrameSetTexture(EXTRA_BACKDROP[index],"Textures\\black32.blp",0,true)
        call BlzFrameSetAlpha(EXTRA_BACKDROP[index],200)
        set EXTRA_TEXT[index] = BlzCreateFrame("MyText",ICON_CONTAINER[index],0,0)
        call BlzFrameSetAllPoints(EXTRA_TEXT[index],EXTRA_BACKDROP[index])
        call BlzFrameSetTextAlignment(EXTRA_TEXT[index],TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_CENTER)
        call BlzFrameSetText(EXTRA_TEXT[index],"Ex")
        /*무기어빌리티 모델프레임*/
        set WEAPON_PARTICLE[index] = BlzCreateFrameByType("SPRITE","",ICON_CONTAINER[index],"",0)
        call BlzFrameSetPoint(WEAPON_PARTICLE[index],FRAMEPOINT_BOTTOMLEFT,ICON_BACKDROP[index],FRAMEPOINT_BOTTOMLEFT,0.,0.)
        call BlzFrameSetModel(WEAPON_PARTICLE[index],"UI\\Feedback\\ui-weaponabilityparticle.mdl",0)
        call BlzFrameSetSize(WEAPON_PARTICLE[index],Math.px2Size(ABILITY_ICON_SIZE),Math.px2Size(ABILITY_ICON_SIZE))
        call BlzFrameSetVisible(WEAPON_PARTICLE[index],false)
        /*툴팁*/
        // set TOOLTIP_MOUSEOVER[index] = BlzCreateFrameByType("BUTTON","AbilityIconMouseover"+I2S(index),ICON_CONTAINER[index],"",index)
        set TOOLTIP_MOUSEOVER[index] = BlzCreateSimpleFrame("AbilityButtonWrapper",ICON_CONTAINER[index],index)
        call BlzFrameSetAllPoints(TOOLTIP_MOUSEOVER[index],pivot)
        //set TOOLTIP_CONTAINER[index] = BlzCreateFrameByType("FRAME","",TOOLTIP_MOUSEOVER[index],"",0)
		set TOOLTIP_CONTAINER[index] = BlzCreateFrameByType("FRAME","",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_TOOLTIP],"",0)
        call BlzFrameSetPoint(TOOLTIP_CONTAINER[index],FRAMEPOINT_BOTTOMLEFT,FRAME_ORIGIN,FRAMEPOINT_BOTTOMLEFT,0.,0.)
        set	TOOLTIP_OUTLINE[index] = BlzCreateFrameByType("BACKDROP","",TOOLTIP_CONTAINER[index],"",0)
        call BlzFrameSetTexture(TOOLTIP_OUTLINE[index],"replaceabletextures\\teamcolor\\teamcolor16.blp",0,true)
        set TOOLTIP_BACKDROP[index] = BlzCreateFrameByType("BACKDROP","",TOOLTIP_CONTAINER[index],"",0)
        call BlzFrameSetTexture(TOOLTIP_BACKDROP[index],"replaceabletextures\\teamcolor\\teamcolor24.blp",0,true)
        set TOOLTIP_TEXT[index] = BlzCreateFrame("MyAbilTooltip",TOOLTIP_CONTAINER[index],0,0)
        call BlzFrameSetTextAlignment(TOOLTIP_TEXT[index],TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_LEFT)
        call BlzFrameSetPoint(TOOLTIP_TEXT[index],FRAMEPOINT_BOTTOM,FRAME_ORIGIN,FRAMEPOINT_BOTTOM,0.,Math.px2Size(ABILITY_TOOLTIP_OFFSET_Y+TOOLTIP_STAT_BONUS_HEIGHT+TOOLTIP_DETAIL_HEIGHT)+0.005)
        set TOOLTIP_HEADER[index] = BlzCreateFrameByType("FRAME","",TOOLTIP_CONTAINER[index],"",0)
        call BlzFrameSetPoint(TOOLTIP_HEADER[index],FRAMEPOINT_BOTTOMLEFT,TOOLTIP_TEXT[index],FRAMEPOINT_TOPLEFT,0.,0.)
        call BlzFrameSetPoint(TOOLTIP_HEADER[index],FRAMEPOINT_TOPRIGHT,TOOLTIP_TEXT[index],FRAMEPOINT_TOPRIGHT,0.,Math.px2Size(TOOLTIP_HEADER_HEIGHT))
        set TOOLTIP_ICON[index] = BlzCreateFrameByType("BACKDROP","",TOOLTIP_CONTAINER[index],"",0)
        call BlzFrameSetPoint(TOOLTIP_ICON[index],FRAMEPOINT_TOPLEFT,TOOLTIP_HEADER[index],FRAMEPOINT_TOPLEFT,0.,0.)
        call BlzFrameSetSize(TOOLTIP_ICON[index],Math.px2Size(TOOLTIP_ICON_SIZE),Math.px2Size(TOOLTIP_ICON_SIZE))
        set TOOLTIP_ICON_BORDER[index] = BlzCreateFrameByType("BACKDROP","",TOOLTIP_CONTAINER[index],"",0)
        call BlzFrameSetAllPoints(TOOLTIP_ICON_BORDER[index],TOOLTIP_ICON[index])
        call BlzFrameSetTexture(TOOLTIP_ICON_BORDER[index],"Textures\\ability_border_tier1.blp",0,true)
        set TOOLTIP_ICON_WEAPON[index] = BlzCreateFrameByType("BACKDROP","",TOOLTIP_CONTAINER[index],"",0)
        call BlzFrameSetPoint(TOOLTIP_ICON_WEAPON[index],FRAMEPOINT_BOTTOMLEFT,TOOLTIP_ICON[index],FRAMEPOINT_BOTTOMLEFT,0.,0.)
        call BlzFrameSetSizePixel(TOOLTIP_ICON_WEAPON[index],20,20)
        call BlzFrameSetVisible(TOOLTIP_ICON_WEAPON[index],false)
        call BlzFrameSetTexture(TOOLTIP_ICON_WEAPON[index],"ui\\widgets\\tooltips\\human\\tooltipweaponicon.blp",0,true)
        set TOOLTIP_NAME[index] = BlzCreateFrame("MyTextLarge",TOOLTIP_CONTAINER[index],0,0)
        call BlzFrameSetPoint(TOOLTIP_NAME[index],FRAMEPOINT_LEFT,TOOLTIP_ICON[index],FRAMEPOINT_RIGHT,0.01,0.)
        call BlzFrameSetTextAlignment(TOOLTIP_NAME[index],TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_LEFT)
        set TOOLTIP_TAG[index] = BlzCreateFrame("MyText",TOOLTIP_CONTAINER[index],0,0)
        call BlzFrameSetPoint(TOOLTIP_TAG[index],FRAMEPOINT_BOTTOMLEFT,TOOLTIP_NAME[index],FRAMEPOINT_BOTTOMRIGHT,0.01,0)
        set TOOLTIP_CASTTYPE[index] = BlzCreateFrame("MyText",TOOLTIP_CONTAINER[index],0,0)
        call BlzFrameSetPoint(TOOLTIP_CASTTYPE[index],FRAMEPOINT_BOTTOMLEFT,TOOLTIP_HEADER[index],FRAMEPOINT_BOTTOMLEFT,0.,0.)
        call BlzFrameSetPoint(TOOLTIP_CASTTYPE[index],FRAMEPOINT_TOPRIGHT,TOOLTIP_ICON[index],FRAMEPOINT_BOTTOMRIGHT,0.5,0)
        call BlzFrameSetTextAlignment(TOOLTIP_CASTTYPE[index],TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_LEFT)
        set TOOLTIP_MANACOST_TEXT[index] = BlzCreateFrame("MyText",TOOLTIP_CONTAINER[index],0,0)
        call BlzFrameSetPoint(TOOLTIP_MANACOST_TEXT[index],FRAMEPOINT_TOPRIGHT,TOOLTIP_HEADER[index],FRAMEPOINT_TOPRIGHT,0.,0.)
        call BlzFrameSetSize(TOOLTIP_MANACOST_TEXT[index],Math.px2Size(TOOLTIP_SUB_WIDTH),Math.px2Size(TOOLTIP_SUB_HEIGHT))
        call BlzFrameSetTextAlignment(TOOLTIP_MANACOST_TEXT[index],TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_RIGHT)
        set TOOLTIP_MANACOST_BACKDROP[index] = BlzCreateFrameByType("BACKDROP","",TOOLTIP_CONTAINER[index],"",0)
        call BlzFrameSetPoint(TOOLTIP_MANACOST_BACKDROP[index],FRAMEPOINT_TOPRIGHT,TOOLTIP_MANACOST_TEXT[index],FRAMEPOINT_TOPLEFT,0.,0.)
        call BlzFrameSetSize(TOOLTIP_MANACOST_BACKDROP[index],Math.px2Size(TOOLTIP_SUB_HEIGHT),Math.px2Size(TOOLTIP_SUB_HEIGHT))
        call BlzFrameSetTexture(TOOLTIP_MANACOST_BACKDROP[index],"ui\\widgets\\tooltips\\human\\tooltipmanaicon.blp",0,true)
        set TOOLTIP_COOLDOWN_TEXT[index] = BlzCreateFrame("MyText",TOOLTIP_CONTAINER[index],0,0)
        call BlzFrameSetPoint(TOOLTIP_COOLDOWN_TEXT[index],FRAMEPOINT_TOPRIGHT,TOOLTIP_MANACOST_TEXT[index],FRAMEPOINT_BOTTOMRIGHT,0.,-0.003)
        call BlzFrameSetSize(TOOLTIP_COOLDOWN_TEXT[index],Math.px2Size(TOOLTIP_SUB_WIDTH),Math.px2Size(TOOLTIP_SUB_HEIGHT)*2)
        call BlzFrameSetTextAlignment(TOOLTIP_COOLDOWN_TEXT[index],TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_RIGHT)
        set TOOLTIP_COOLDOWN_BACKDROP[index] = BlzCreateFrameByType("BACKDROP","",TOOLTIP_CONTAINER[index],"",0)
        call BlzFrameSetPoint(TOOLTIP_COOLDOWN_BACKDROP[index],FRAMEPOINT_TOPRIGHT,TOOLTIP_COOLDOWN_TEXT[index],FRAMEPOINT_TOPLEFT,0.,0.)
        call BlzFrameSetSize(TOOLTIP_COOLDOWN_BACKDROP[index],Math.px2Size(TOOLTIP_SUB_HEIGHT),Math.px2Size(TOOLTIP_SUB_HEIGHT))
        call BlzFrameSetTexture(TOOLTIP_COOLDOWN_BACKDROP[index],"ui\\widgets\\tooltips\\human\\tooltipcooldownicon.blp",0,true)
		set TOOLTIP_CUSTOM_COST_TEXT[index] = BlzCreateFrame("MyText",TOOLTIP_CONTAINER[index],0,0)
		call BlzFrameSetPoint(TOOLTIP_CUSTOM_COST_TEXT[index],FRAMEPOINT_TOPRIGHT,TOOLTIP_COOLDOWN_TEXT[index],FRAMEPOINT_BOTTOMRIGHT,0.,0.)
		call BlzFrameSetTextAlignment(TOOLTIP_CUSTOM_COST_TEXT[index],TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_RIGHT)
		/*골드 사용량*/
		set TOOLTIP_COST_SPEND_TEXT1[index] = BlzCreateFrame("MyText",TOOLTIP_CONTAINER[index],0,0)
		call BlzFrameSetTextAlignment(TOOLTIP_COST_SPEND_TEXT1[index],TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_RIGHT)
		set TOOLTIP_COST_SPEND_BACKDROP1[index] = BlzCreateFrameByType("BACKDROP","",TOOLTIP_CONTAINER[index],"",0)
		call BlzFrameSetSize(TOOLTIP_COST_SPEND_BACKDROP1[index],Math.px2Size(TOOLTIP_SUB_HEIGHT),Math.px2Size(TOOLTIP_SUB_HEIGHT))
		call BlzFrameSetTexture(TOOLTIP_COST_SPEND_BACKDROP1[index],"ui\\widgets\\tooltips\\human\\tooltipgemgoldicon.blp",0,true)
		/*스킬포인트 사용량*/
		set TOOLTIP_COST_SPEND_TEXT2[index] = BlzCreateFrame("MyText",TOOLTIP_CONTAINER[index],0,0)
		call BlzFrameSetTextAlignment(TOOLTIP_COST_SPEND_TEXT2[index],TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_RIGHT)
		set TOOLTIP_COST_SPEND_BACKDROP2[index] = BlzCreateFrameByType("BACKDROP","",TOOLTIP_CONTAINER[index],"",0)
		call BlzFrameSetSize(TOOLTIP_COST_SPEND_BACKDROP2[index],Math.px2Size(TOOLTIP_SUB_HEIGHT),Math.px2Size(TOOLTIP_SUB_HEIGHT))
		call BlzFrameSetTexture(TOOLTIP_COST_SPEND_BACKDROP2[index],"ui\\widgets\\tooltips\\human\\tooltipgemorangeicon.blp",0,true)
		/*행운누적*/
		set TOOLTIP_COST_SPEND_TEXT3[index] = BlzCreateFrame("MyText",TOOLTIP_CONTAINER[index],0,0)
		call BlzFrameSetTextAlignment(TOOLTIP_COST_SPEND_TEXT3[index],TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_RIGHT)
		set TOOLTIP_COST_SPEND_BACKDROP3[index] = BlzCreateFrameByType("BACKDROP","",TOOLTIP_CONTAINER[index],"",0)
		call BlzFrameSetSize(TOOLTIP_COST_SPEND_BACKDROP3[index],Math.px2Size(TOOLTIP_SUB_HEIGHT),Math.px2Size(TOOLTIP_SUB_HEIGHT))
		call BlzFrameSetTexture(TOOLTIP_COST_SPEND_BACKDROP3[index],"ui\\widgets\\tooltips\\human\\tooltipgemgreenicon.blp",0,true)
		/*EXP누적*/
		set TOOLTIP_COST_SPEND_TEXT4[index] = BlzCreateFrame("MyText",TOOLTIP_CONTAINER[index],0,0)
		call BlzFrameSetTextAlignment(TOOLTIP_COST_SPEND_TEXT4[index],TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_RIGHT)
		set TOOLTIP_COST_SPEND_BACKDROP4[index] = BlzCreateFrameByType("BACKDROP","",TOOLTIP_CONTAINER[index],"",0)
		call BlzFrameSetSize(TOOLTIP_COST_SPEND_BACKDROP4[index],Math.px2Size(TOOLTIP_SUB_HEIGHT),Math.px2Size(TOOLTIP_SUB_HEIGHT))
		call BlzFrameSetTexture(TOOLTIP_COST_SPEND_BACKDROP4[index],"ui\\widgets\\tooltips\\human\\tooltipgemblueicon.blp",0,true)
		/*사용량_포인트설정*/
		call BlzFrameSetPoint(TOOLTIP_COST_SPEND_TEXT1[index],FRAMEPOINT_BOTTOMRIGHT,TOOLTIP_COST_SPEND_BACKDROP2[index],FRAMEPOINT_BOTTOMLEFT,-0.004,0.)
		call BlzFrameSetPoint(TOOLTIP_COST_SPEND_TEXT2[index],FRAMEPOINT_BOTTOMRIGHT,TOOLTIP_COST_SPEND_BACKDROP3[index],FRAMEPOINT_BOTTOMLEFT,-0.004,0.)
		call BlzFrameSetPoint(TOOLTIP_COST_SPEND_TEXT3[index],FRAMEPOINT_BOTTOMRIGHT,TOOLTIP_COST_SPEND_BACKDROP4[index],FRAMEPOINT_BOTTOMLEFT,-0.004,0.)
		call BlzFrameSetPoint(TOOLTIP_COST_SPEND_TEXT4[index],FRAMEPOINT_BOTTOMRIGHT,TOOLTIP_BACKDROP[index],FRAMEPOINT_BOTTOMRIGHT,-0.004,0.004)
		call BlzFrameSetPoint(TOOLTIP_COST_SPEND_BACKDROP1[index],FRAMEPOINT_BOTTOMRIGHT,TOOLTIP_COST_SPEND_TEXT1[index],FRAMEPOINT_BOTTOMLEFT,-0.004,0.)
		call BlzFrameSetPoint(TOOLTIP_COST_SPEND_BACKDROP2[index],FRAMEPOINT_BOTTOMRIGHT,TOOLTIP_COST_SPEND_TEXT2[index],FRAMEPOINT_BOTTOMLEFT,-0.004,0.)
		call BlzFrameSetPoint(TOOLTIP_COST_SPEND_BACKDROP3[index],FRAMEPOINT_BOTTOMRIGHT,TOOLTIP_COST_SPEND_TEXT3[index],FRAMEPOINT_BOTTOMLEFT,-0.004,0.)
		call BlzFrameSetPoint(TOOLTIP_COST_SPEND_BACKDROP4[index],FRAMEPOINT_BOTTOMRIGHT,TOOLTIP_COST_SPEND_TEXT4[index],FRAMEPOINT_BOTTOMLEFT,-0.004,0.)
		/*스탯보너스*/
        set TOOLTIP_STAT_BONUS_ICON1[index] = BlzCreateFrameByType("BACKDROP","",TOOLTIP_CONTAINER[index],"",0)
        call BlzFrameSetPoint(TOOLTIP_STAT_BONUS_ICON1[index],FRAMEPOINT_TOPLEFT,TOOLTIP_TEXT[index],FRAMEPOINT_BOTTOMLEFT,Math.px2Size(0),Math.px2Size(-8))
        call BlzFrameSetSize(TOOLTIP_STAT_BONUS_ICON1[index],Math.px2Size(32),Math.px2Size(32))
        set TOOLTIP_STAT_BONUS_ICON2[index] = BlzCreateFrameByType("BACKDROP","",TOOLTIP_CONTAINER[index],"",0)
        call BlzFrameSetPoint(TOOLTIP_STAT_BONUS_ICON2[index],FRAMEPOINT_TOPLEFT,TOOLTIP_TEXT[index],FRAMEPOINT_BOTTOMLEFT,Math.px2Size(0+192),Math.px2Size(-8))
        call BlzFrameSetSize(TOOLTIP_STAT_BONUS_ICON2[index],Math.px2Size(32),Math.px2Size(32))
        set TOOLTIP_STAT_BONUS_TEXT1[index] = BlzCreateFrame("MyText",TOOLTIP_CONTAINER[index],0,0)
        call BlzFrameSetPoint(TOOLTIP_STAT_BONUS_TEXT1[index],FRAMEPOINT_LEFT,TOOLTIP_STAT_BONUS_ICON1[index],FRAMEPOINT_RIGHT,Math.px2Size(8),0.)
        call BlzFrameSetTextAlignment(TOOLTIP_STAT_BONUS_TEXT1[index],TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_LEFT)
        set TOOLTIP_STAT_BONUS_TEXT2[index] = BlzCreateFrame("MyText",TOOLTIP_CONTAINER[index],0,0)
        call BlzFrameSetPoint(TOOLTIP_STAT_BONUS_TEXT2[index],FRAMEPOINT_LEFT,TOOLTIP_STAT_BONUS_ICON2[index],FRAMEPOINT_RIGHT,Math.px2Size(8),0.)
        call BlzFrameSetTextAlignment(TOOLTIP_STAT_BONUS_TEXT2[index],TEXT_JUSTIFY_CENTER,TEXT_JUSTIFY_LEFT)
		set TOOLTIP_DETAIL[index] = BlzCreateFrame("MyTextSmall",TOOLTIP_CONTAINER[index],0,0)
		call BlzFrameSetPointPixel(TOOLTIP_DETAIL[index],FRAMEPOINT_TOPLEFT,TOOLTIP_STAT_BONUS_ICON1[index],FRAMEPOINT_BOTTOMLEFT,0,-16)
		call BlzFrameSetTextAlignment(TOOLTIP_DETAIL[index],TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_LEFT)
		call BlzFrameSetText(TOOLTIP_DETAIL[index],"|cff999999Shift : 자세히 보기\nCtrl + 단축키 : 빠른 시전(스마트캐스트) 설정 변경|r")
		set UNIQUE_BACKDROP[index] = BlzCreateFrameByType("BACKDROP","",TOOLTIP_CONTAINER[index],"",0)
		call BlzFrameSetTexture(UNIQUE_BACKDROP[index],"textures\\black32.blp",0,true)
		call BlzFrameSetAlpha(UNIQUE_BACKDROP[index],192)
        set UNIQUE[index] = BlzCreateFrame("MyText",TOOLTIP_CONTAINER[index],0,0)
        call BlzFrameSetText(UNIQUE[index],"|cffffcc00고유 스킬|r")
        call BlzFrameSetVisible(UNIQUE[index],false)
        /*SET POINT*/
        call BlzFrameSetPoint(TOOLTIP_OUTLINE[index],FRAMEPOINT_BOTTOMLEFT,TOOLTIP_TEXT[index],FRAMEPOINT_BOTTOMLEFT,-.005,-.005-Math.px2Size(TOOLTIP_STAT_BONUS_HEIGHT+TOOLTIP_DETAIL_HEIGHT))
        call BlzFrameSetPoint(TOOLTIP_OUTLINE[index],FRAMEPOINT_TOPRIGHT,TOOLTIP_HEADER[index],FRAMEPOINT_TOPRIGHT,.005,.005)
        call BlzFrameSetPoint(TOOLTIP_BACKDROP[index],FRAMEPOINT_BOTTOMLEFT,TOOLTIP_TEXT[index],FRAMEPOINT_BOTTOMLEFT,-.004,-.004-Math.px2Size(TOOLTIP_STAT_BONUS_HEIGHT+TOOLTIP_DETAIL_HEIGHT))
        call BlzFrameSetPoint(TOOLTIP_BACKDROP[index],FRAMEPOINT_TOPRIGHT,TOOLTIP_HEADER[index],FRAMEPOINT_TOPRIGHT,.004,.004)
        call BlzFrameSetPoint(UNIQUE[index],FRAMEPOINT_BOTTOMLEFT,TOOLTIP_OUTLINE[index],FRAMEPOINT_TOPLEFT,0.004,0.004)
		call BlzFrameSetPoint(UNIQUE_BACKDROP[index],FRAMEPOINT_BOTTOMLEFT,UNIQUE[index],FRAMEPOINT_BOTTOMLEFT,-0.004,-0.004)
		call BlzFrameSetPoint(UNIQUE_BACKDROP[index],FRAMEPOINT_TOPRIGHT,UNIQUE[index],FRAMEPOINT_TOPRIGHT,0.004,0.004)
        /*툴팁설정*/
        //call BlzFrameSetTooltip(TOOLTIP_MOUSEOVER[index],TOOLTIP_CONTAINER[index])
		call BlzFrameSetVisible(TOOLTIP_CONTAINER[index],false)
		/*트리거*/
		set BTN_TRIGGER[index] = Trigger.new(index)
		call BlzTriggerRegisterFrameEvent(BTN_TRIGGER[index],TOOLTIP_MOUSEOVER[index],FRAMEEVENT_CONTROL_CLICK)
        call BlzTriggerRegisterFrameEvent(BTN_TRIGGER[index],TOOLTIP_MOUSEOVER[index],FRAMEEVENT_MOUSE_ENTER)
        call BlzTriggerRegisterFrameEvent(BTN_TRIGGER[index],TOOLTIP_MOUSEOVER[index],FRAMEEVENT_MOUSE_LEAVE)
		call TriggerAddCondition(BTN_TRIGGER[index],function thistype.click)
        /*프레임이 초기화돼있음을 기록*/
        set FLAG_FRAME[index] = true
        set pivot = null
    endmethod

	static method forceRefresh takes nothing returns nothing
		local thistype this = 0
		local integer i = 0
		if CUSTOM_RESPOND_UI_REFRESH_PLAYER == null then
			return
		endif
		if CUSTOM_RESPOND_UI_REFRESH_SLOT < 0 then
			/*특정 '어빌리티 인스턴스' 리프레시*/
			if CUSTOM_RESPOND_UI_REFRESH_ABILITY <= 0 then
				return
			endif
			loop
				exitwhen i >= CONFIG_ABILITY_SIZE
				set this = GetPlayerId(CUSTOM_RESPOND_UI_REFRESH_PLAYER)*CONFIG_ABILITY_SIZE + i
				if .target == CUSTOM_RESPOND_UI_REFRESH_ABILITY then
					call setTarget(.target)
					return
				endif
				set i = i + 1
			endloop
		else
			/*특정 '인덱스' 리프레시*/
			set this = GetPlayerId(CUSTOM_RESPOND_UI_REFRESH_PLAYER)*CONFIG_ABILITY_SIZE + CUSTOM_RESPOND_UI_REFRESH_SLOT
			call setTarget(.target)
		endif
	endmethod

    static method create takes integer index, framehandle parent, player owner returns thistype
        local thistype this = GetPlayerId(owner)*CONFIG_ABILITY_SIZE + index
        set .owner = owner
        set .index = index
		set .mouse_in = false
		set .target = 0
        if not FLAG_FRAME[.index] then
            /*프레임 초기화 안돼있으면 초기화*/
            call initFrames(.index,parent)
        endif
        /*단일 플레이어를 대상으로 한 이벤트 추가이므로 바깥으로 뺐음.*/
        call TriggerRegisterPlayerEvent(BTN_TRIGGER[index],.owner,EVENT_PLAYER_MOUSE_DOWN)
        /**/
        return this
    endmethod

    method destroy takes nothing returns nothing

    endmethod

    static method onInit takes nothing returns nothing
		local integer i = 0
		loop
			exitwhen i >= CONFIG_ABILITY_SIZE
			set FLAG_FRAME[i] = false
			set i = i + 1
		endloop
		set REFRESH = CreateTrigger()
		call Event.register(REFRESH,CONFIG_EVENT_ABILITY_UI_REFRESH)
		call TriggerAddCondition(REFRESH,function thistype.forceRefresh)
    endmethod

endstruct