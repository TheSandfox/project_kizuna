library AbilityManager requires Frame

	globals
		private trigger KEYPRESS = null
		private framehandle CONTAINER = null
		private framehandle CLOSE_BUTTON = null
		private framehandle SUB_PANEL = null
		private framehandle SKILLPOINT_BACKDROP = null
		private framehandle SKILLPOINT_TEXT = null
		private framehandle SKILLPOINT_SMALL_BACKDROP = null
		private framehandle SKILLPOINT_SMALL_TEXT = null
		private framehandle array PAGE
		private framehandle array PAGE_BUTTON
		private framehandle array PAGE_BUTTON_TEXT
		private string array	PAGE_BUTTON_STRING
		private framehandle array ABILITY_ICON
		private framehandle array ABILITY_TIER_BORDER
		private framehandle ABILITY_LEVEL_BUTTON_CONTAINER = null
		private framehandle array ABILITY_LEVEL_TEXT
		private framehandle array ABILITY_LEVEL_BUTTON
		private framehandle ABILITY_REMOVE_BUTTON_CONTAINER = null
		private framehandle array ABILITY_REMOVE_TEXT
		private framehandle array ABILITY_REMOVE_BUTTON
		/*모드체인지(강화)*/
		private framehandle UPGRADE_MODE_CHANGE = null
		/*도움말*/
		private framehandle HELP_BACKDROP = null
		private framehandle HELP_TEXT = null
		private framehandle HELP_MOUSEOVER = null
		private framehandle HELP_TOOLTIP_CONTAINER = null
		private framehandle HELP_TOOLTIP_BACKDROP = null
		private framehandle HELP_TOOLTIP_TEXT = null
		/*합성 아이콘(3개)*/
		private framehandle array ABILITY_MIX_BACKDROP
		private framehandle array ABILITY_MIX_TIER_BORDER
		private framehandle array ABILITY_MIX_REMOVE
		private framehandle array ABILITY_MIX_TOP
		private framehandle array ABILITY_MIX_SUB
		private framehandle ABILITY_MIX_CONFIRM = null
		/*합성 추천레시피*/
		private framehandle RECIPE_CONTAINER = null
		private framehandle RECIPE_BACKDROP = null
		private framehandle RECIPE_TITLE = null
		private framehandle array RECIPE_ROW[4]
		private framehandle array RECIPE_MAIN[4]
		private framehandle array RECIPE_MAIN_BORDER[4]
		private framehandle array RECIPE_PLUS[4]
		private framehandle array RECIPE_SUB[4]
		private framehandle array RECIPE_SUB_BORDER[4]
		private framehandle array RECIPE_EQUAL[4]
		private framehandle array RECIPE_RESULT[4]
		private framehandle array RECIPE_RESULT_BORDER[4]
		/*어빌리티 믹스용 임시변수*/
		private integer array MY_RESPOND_ABILITY_MIX_UPGRADE_POINTS

		/*최대 페이지 수(강화,합성,제거 합쳐서 3개)*/
		private constant integer PAGE_MAX = 3

		private player P = null
	endglobals

	struct AbilityManager extends array

		private static boolean INIT = true 

		static constant integer PAGE_UPGRADE = 0
		static constant integer PAGE_MIX = 1
		static constant integer PAGE_EXTRACT = 2

		static trigger REFRESH_SKILLPOINT_TRIGGER = null
		static player REFRESH_SKILLPOINT_PLAYER = null

		boolean visible_flag
		Unit target
		SimpleList list
		integer page
		AbilityMixElement ability_mix_element1
		AbilityMixElement ability_mix_element2
		integer upgrade_mode	/*업그레이드에서 사용할 재화*/

		method operator owner takes nothing returns player
			return Player(this)
		endmethod

		method refreshSkillpoint takes nothing returns nothing
			if GetLocalPlayer() == Player(this) then
				/*UI버튼 위 스몰*/
				call BlzFrameSetVisible(SKILLPOINT_SMALL_TEXT,.target.getUpgradePoint(.upgrade_mode)>0)
				call BlzFrameSetVisible(SKILLPOINT_SMALL_BACKDROP,.target.getUpgradePoint(.upgrade_mode)>0)
				call BlzFrameSetText(SKILLPOINT_SMALL_TEXT,"|cffff9900+"+I2S(.target.getUpgradePoint(.upgrade_mode))+"|r")
				if .page == PAGE_UPGRADE then
					/*페이지 0일 때 스킬포인트 표시*/
					if .upgrade_mode == ENUM_ABILITY_UPGRADE_TYPE_RED then
						call BlzFrameSetTexture(SKILLPOINT_BACKDROP,"replaceabletextures\\commandbuttons\\BTNAbility_Gem_Orange.blp",0,true)
					elseif .upgrade_mode == ENUM_ABILITY_UPGRADE_TYPE_GREEN then
						call BlzFrameSetTexture(SKILLPOINT_BACKDROP,"replaceabletextures\\commandbuttons\\BTNAbility_Gem_Green.blp",0,true)
					elseif .upgrade_mode == ENUM_ABILITY_UPGRADE_TYPE_BLUE then
						call BlzFrameSetTexture(SKILLPOINT_BACKDROP,"replaceabletextures\\commandbuttons\\BTNAbility_Gem_Blue.blp",0,true)
					endif
					call BlzFrameSetText(SKILLPOINT_TEXT,CONSTANT_ABILITY_UPGRADE_TYPE_COLOR[.upgrade_mode]+CONSTANT_ABILITY_UPGRADE_TYPE_NAME[.upgrade_mode]+":\n\n"+I2S(.target.getUpgradePoint(.upgrade_mode))+"|r")
				elseif .page == PAGE_EXTRACT then
					/*페이지 2일 때 망각의 가루 표시*/
					call BlzFrameSetTexture(SKILLPOINT_BACKDROP,"replaceabletextures\\commandbuttons\\BTNAbility_Gem_Purple.blp",0,true)
					call BlzFrameSetText(SKILLPOINT_TEXT,"|cffcc00cc망각의 파편:\n\n"+I2S(.target.removepoint)+"|r")
				endif
			endif
		endmethod

		static method refreshSkillpointCallback takes nothing returns nothing
			local thistype this = GetPlayerId(REFRESH_SKILLPOINT_PLAYER)
			call refreshSkillpoint()
		endmethod

		method refreshAbilityIcons takes nothing returns nothing
			local integer i = 0
			local Ability a = 0
			local framehandle f = null
			/*어빌리티 레벨*/
			loop
				exitwhen i >= CONFIG_ABILITY_SIZE
				set a = .list.get(i)
				if a <= 0 then
					/*빈 어빌리티*/
					if GetLocalPlayer() == Player(this) then
						call BlzFrameSetTexture(ABILITY_ICON[i],"Icons\\BTNBlackIcon.blp",0,true)
						call BlzFrameSetVisible(ABILITY_LEVEL_TEXT[i],false)
						call BlzFrameSetVisible(ABILITY_LEVEL_BUTTON[i],false)
						call BlzFrameSetVisible(ABILITY_TIER_BORDER[i],false)
						call BlzFrameSetVisible(ABILITY_REMOVE_BUTTON[i],false)
					endif
				else
					/*어빌리티 존재*/
					if GetLocalPlayer() == Player(this) then
						call BlzFrameSetTexture(ABILITY_ICON[i],Ability.getTypeIconPath(a.id),0,true)
						call BlzFrameSetVisible(ABILITY_LEVEL_TEXT[i],true)
						call BlzFrameSetVisible(ABILITY_LEVEL_BUTTON[i],true)
						call BlzFrameSetVisible(ABILITY_TIER_BORDER[i],true)
						call BlzFrameSetTexture(ABILITY_TIER_BORDER[i],"Textures\\ability_border_tier"+I2S(Ability.getTypeTier(a.id))+".blp",0,true)
					endif
					if .page == PAGE_UPGRADE then
						/*업그레이드 모드*/
						/*스킬레벨표기*/
						if a.level >= a.level_max then
							if GetLocalPlayer() == Player(this) then
								call BlzFrameSetText(ABILITY_LEVEL_TEXT[i],"|cffffff00Lv. Max|r")
							endif
						else
							if GetLocalPlayer() == Player(this) then
								call BlzFrameSetText(ABILITY_LEVEL_TEXT[i],"|cffffffffLv. "+I2S(a.level)+"|r|cff999999/"+I2S(a.level_max)+"|r")
							endif
						endif
					elseif .page == PAGE_EXTRACT then
						/*제거 모드*/
						/*레벨 표기*/
						if GetLocalPlayer() == Player(this) then
							if a.signature then
								call BlzFrameSetText(ABILITY_LEVEL_TEXT[i],"|cffcc0000제거 불가|r")
							else
								call BlzFrameSetText(ABILITY_LEVEL_TEXT[i],/*
									*/"Lv. "+I2S(a.level)/*
								*/)
							endif
						endif
					endif
					/*레벨업 버튼*/
					set f = BlzGetFrameByName("AbilityManagerLevelUpButtonText",i)
					if Ability.getTypeTier(a.id) <= 0 or a.level >= a.level_max or .target.getUpgradePoint(.upgrade_mode) < Ability.getTypeTier(a.id) then
						/*만렙이거나 0티어 스킬이거나 스킬포인트가 없으면 비활성화*/
						if GetLocalPlayer() == Player(this) then
							call BlzFrameSetEnable(ABILITY_LEVEL_BUTTON[i],false)
							call BlzFrameSetText(f,"|cff999999▲"+I2S(Ability.getTypeTier(a.id))+"|r")
						endif
					else
						/*아니면 활성화*/
						if GetLocalPlayer() == Player(this) then
							call BlzFrameSetEnable(ABILITY_LEVEL_BUTTON[i],true)
							call BlzFrameSetText(f,CONSTANT_ABILITY_UPGRADE_TYPE_COLOR[.upgrade_mode]+"▲"+I2S(Ability.getTypeTier(a.id))+"|r")
						endif
					endif
					/*제거버튼*/
					set f = BlzGetFrameByName("AbilityManagerRemoveButtonText",i)
					if a.level * Ability.getTypeTier(a.id) > 0 and not a.signature then
						/*골드사용량+스킬포인트 사용량 > 0 & 고유능력이 아닐 것*/
						if GetLocalPlayer() == Player(this) then
							call BlzFrameSetVisible(ABILITY_REMOVE_BUTTON[i],true)
							if .target.removepoint >= a.level * Ability.getTypeTier(a.id) then
								call BlzFrameSetText(f,"|cffcc00cc▼"+I2S(a.level * Ability.getTypeTier(a.id))+"|r")
								call BlzFrameSetEnable(ABILITY_REMOVE_BUTTON[i],true)
							else
								call BlzFrameSetText(f,"|cff999999▼"+I2S(a.level * Ability.getTypeTier(a.id))+"|r")
								call BlzFrameSetEnable(ABILITY_REMOVE_BUTTON[i],false)
							endif
						endif
					else
						if GetLocalPlayer() == Player(this) then
							call BlzFrameSetVisible(ABILITY_REMOVE_BUTTON[i],false)
						endif
					endif
				endif
				set i = i + 1
			endloop
			/*남은 스킬포인트*/
			call refreshSkillpoint()
			set f = null
		endmethod

		method loadAbility takes nothing returns nothing
			local integer i = 0
			if .target <= 0 then
				call .list.clear()
			else
				loop
					exitwhen i >= CONFIG_ABILITY_SIZE
					call .list.setData(i,.target.getAbility(i))
					set i = i + 1
				endloop
			endif
			call refreshAbilityIcons()
		endmethod

		method setTarget takes Unit u returns nothing
			set .target = u
			call loadAbility()
		endmethod

		method levelButtonPress takes integer index, integer upgrade_type returns nothing
			local Ability a = .list.get(index)
			if a <= 0 then
				/*빈 어빌리티*/
				return
			else
				/*안비어있으면 코스트책정*/
				if a.level >= a.level_max then
					/*만렙이라 못올림*/
					return
				endif
				if .target.getUpgradePoint(upgrade_type) < Ability.getTypeTier(a.id) then
					/*스킬포인트 부족*/
					return
				endif
				/**/call .target.setUpgradePoint(upgrade_type,.target.getUpgradePoint(upgrade_type) - Ability.getTypeTier(a.id))
				/**/call a.setUpgradePoint(upgrade_type,a.getUpgradePoint(upgrade_type) + Ability.getTypeTier(a.id))
				/**/call a.addLevel(1)
				/*이펙트출력*/
				call AttatchedEffect.create("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl",.target).setDuration(2.0)
				/**/set CUSTOM_RESPOND_UI_REFRESH_PLAYER = .owner
				/**/call Event.activate(ENUM_EVENT_ABILITY_UI_REFRESH)
				/**/set CUSTOM_RESPOND_UI_REFRESH_PLAYER = null
				return
			endif
		endmethod

		method removeButtonPress takes integer index returns nothing
			local Ability a = .list.get(index)
			local boolean result
			if a <= 0 then
				/*빈 어빌리티*/
				return
			else
				if a.signature then
					/*고유능력은 제거할 수 없음*/
					return
				endif
				if .target.removepoint < a.level * Ability.getTypeTier(a.id) then
					/*망각의 파편 부족*/
					return
				endif
				set result = AbilityMix.extract(a)
				if result then
					set .target.removepoint = .target.removepoint - (a.level * Ability.getTypeTier(a.id))
				endif
				return
			endif
		endmethod

		method setAbilityMixResult takes integer aid returns nothing
			local integer i = 0
			local AbilityMix recipe = 0
			/**/
			if aid == AbilityMix.LEVEL then
				/*레벨업 합성*/
				set i = .ability_mix_element1.getLevel()+.ability_mix_element2.getLevel()
				if i > Ability.getTypeMaxLevel(.ability_mix_element1.getId()) then
					set i = Ability.getTypeMaxLevel(.ability_mix_element1.getId())
				endif
			elseif aid == AbilityMix.RANDOM then
				/*랜덤합성*/
				set i = AbilityMix.carculateMixLevel(.ability_mix_element1,.ability_mix_element2)
			elseif aid > 0 then
				/*레시피 있음*/
				set i = AbilityMix.carculateMixLevel(.ability_mix_element1,.ability_mix_element2)
				set recipe = AbilityMix.getRecipe(.ability_mix_element1.getId(),.ability_mix_element2.getId())
			endif
			/*로컬*/
			if GetLocalPlayer() == Player(this) then
				if aid == AbilityMix.EMPTY then
					/*하나 비어있음*/
					call BlzFrameSetTexture(ABILITY_MIX_BACKDROP[2],"Icons\\BTNBlackIcon.blp",0,true)
					call BlzFrameSetVisible(ABILITY_MIX_TIER_BORDER[2],false)
					call BlzFrameSetText(ABILITY_MIX_SUB[0],"Lv. "+I2S(.ability_mix_element1.getLevel())+" "+.ability_mix_element1.getName())
					call BlzFrameSetText(ABILITY_MIX_SUB[1],"Lv. "+I2S(.ability_mix_element2.getLevel())+" "+.ability_mix_element2.getName())
					call BlzFrameSetText(ABILITY_MIX_SUB[2],"")
				elseif aid == AbilityMix.LEVEL then
					/*레벨업*/
					call BlzFrameSetTexture(ABILITY_MIX_BACKDROP[2],Ability.getTypeIconPath(.ability_mix_element1.getId()),0,true)
					call BlzFrameSetTexture(ABILITY_MIX_TIER_BORDER[2],"Textures\\ability_border_tier"+I2S(Ability.getTypeTier(.ability_mix_element1.getId()))+".blp",0,true)
					call BlzFrameSetVisible(ABILITY_MIX_TIER_BORDER[2],true)
					call BlzFrameSetText(ABILITY_MIX_SUB[0],"Lv. "+I2S(.ability_mix_element1.getLevel())+" "+.ability_mix_element1.getName())
					call BlzFrameSetText(ABILITY_MIX_SUB[1],"Lv. "+I2S(.ability_mix_element2.getLevel())+" "+.ability_mix_element2.getName())
					call BlzFrameSetText(ABILITY_MIX_SUB[2],"Lv. "+I2S(i/*최대레벨을 초과하지 않은 레벨합계임*/)+" "+.ability_mix_element1.getName())
				elseif aid == AbilityMix.DISABLED then
					/*합성불가능(합계 티어 초과)*/
					call BlzFrameSetTexture(ABILITY_MIX_BACKDROP[2],"ReplaceableTextures\\CommandButtons\\BTNCancel.blp",0,true)
					call BlzFrameSetVisible(ABILITY_MIX_TIER_BORDER[2],false)
					call BlzFrameSetText(ABILITY_MIX_SUB[0],"Lv. "+I2S(.ability_mix_element1.getLevel())+" "+.ability_mix_element1.getName())
					call BlzFrameSetText(ABILITY_MIX_SUB[1],"Lv. "+I2S(.ability_mix_element2.getLevel())+" "+.ability_mix_element2.getName())
					call BlzFrameSetText(ABILITY_MIX_SUB[2],"|cffff0000합성 불가|r")
				elseif aid == AbilityMix.RANDOM then
					/*랜덤합성*/
					call BlzFrameSetTexture(ABILITY_MIX_BACKDROP[2],"ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",0,true)
					call BlzFrameSetTexture(ABILITY_MIX_TIER_BORDER[2],"Textures\\ability_border_tier"+I2S(.ability_mix_element1.getTier()+.ability_mix_element2.getTier())+".blp",0,true)
					call BlzFrameSetVisible(ABILITY_MIX_TIER_BORDER[2],true)
					call BlzFrameSetText(ABILITY_MIX_SUB[0],"Lv. "+I2S(.ability_mix_element1.getLevel())+" "+.ability_mix_element1.getName()+"\n(필요 레벨 : "+I2S(AbilityMix.LEVEL_REQUIRE)+")")
					call BlzFrameSetText(ABILITY_MIX_SUB[1],"Lv. "+I2S(.ability_mix_element2.getLevel())+" "+.ability_mix_element2.getName()+"\n(필요 레벨 : "+I2S(AbilityMix.LEVEL_REQUIRE)+")")
					call BlzFrameSetText(ABILITY_MIX_SUB[2],"Lv. "+I2S(i)+" ???")
				else
					/*레시피가 있음*/
					call BlzFrameSetTexture(ABILITY_MIX_BACKDROP[2],Ability.getTypeIconPath(aid),0,true)
					call BlzFrameSetTexture(ABILITY_MIX_TIER_BORDER[2],"Textures\\ability_border_tier"+I2S(Ability.getTypeTier(aid))+".blp",0,true)
					call BlzFrameSetVisible(ABILITY_MIX_TIER_BORDER[2],true)
					call BlzFrameSetText(ABILITY_MIX_SUB[0],"Lv. "+I2S(.ability_mix_element1.getLevel())+" "+.ability_mix_element1.getName()+"\n(필요 레벨 : "+I2S(recipe.main_level)+")")
					call BlzFrameSetText(ABILITY_MIX_SUB[1],"Lv. "+I2S(.ability_mix_element2.getLevel())+" "+.ability_mix_element2.getName()+"\n(필요 레벨 : "+I2S(recipe.sub_level)+")")
					call BlzFrameSetText(ABILITY_MIX_SUB[2],"Lv. "+I2S(i)+" "+Ability.getTypeName(aid))
				endif
			endif
			set i = 0
		endmethod

		/*합성 추천 레시피(레시피 참조 시 제로베이스임에 주의)*/
		method refreshRecipe takes nothing returns nothing
			local integer i = 0
			local AbilityMix recipe = AbilityMix.getRecommendRecipe(.ability_mix_element1.getId(),0)
			if GetLocalPlayer() == Player(this) then
				call BlzFrameSetVisible(RECIPE_CONTAINER,.ability_mix_element1 > 0 and /*
				*/ recipe >= 0 /*
				*/)
			endif
			loop
				exitwhen i >= 4
				set recipe = AbilityMix.getRecommendRecipe(.ability_mix_element1.getId(),i)
				if GetLocalPlayer() == Player(this) then
					call BlzFrameSetVisible(RECIPE_ROW[i],recipe >= 0)
					if recipe >= 0 then
						/*레시피 있음*/
						call BlzFrameSetTexture(RECIPE_MAIN[i],Ability.getTypeIconPath(recipe.main),0,true)
						call BlzFrameSetTexture(RECIPE_MAIN_BORDER[i],Ability.getTierBorder(Ability.getTypeTier(recipe.main)),0,true)
						call BlzFrameSetTexture(RECIPE_SUB[i],Ability.getTypeIconPath(recipe.sub),0,true)
						call BlzFrameSetTexture(RECIPE_SUB_BORDER[i],Ability.getTierBorder(Ability.getTypeTier(recipe.sub)),0,true)
						call BlzFrameSetTexture(RECIPE_RESULT[i],Ability.getTypeIconPath(recipe.result),0,true)
						call BlzFrameSetTexture(RECIPE_RESULT_BORDER[i],Ability.getTierBorder(Ability.getTypeTier(recipe.result)),0,true)
					endif
				endif
				set i = i + 1
			endloop
		endmethod

		/*합성 재료 등록*/
		method setAbilityMixTarget takes integer index, AbilityMixElement am returns nothing
			local integer aid1 = 0
			local integer aid2 = 0
			if index == 0 then
				if .ability_mix_element1 > 0 then
					call .ability_mix_element1.destroy()
				endif
				set .ability_mix_element1 = am
			elseif index == 1 then
				if .ability_mix_element2 > 0 then
					call .ability_mix_element2.destroy()
				endif
				set .ability_mix_element2 = am
			endif
			if GetLocalPlayer() == Player(this) then
				if am <= 0 then
					call BlzFrameSetTexture(ABILITY_MIX_BACKDROP[index],"Icons\\BTNBlackIcon.blp",0,true)
					call BlzFrameSetVisible(ABILITY_MIX_TIER_BORDER[index],false)
					call BlzFrameSetVisible(ABILITY_MIX_REMOVE[index],false)
				else
					call BlzFrameSetTexture(ABILITY_MIX_BACKDROP[index],am.getIconPath(),0,true)
					call BlzFrameSetTexture(ABILITY_MIX_TIER_BORDER[index],"Textures\\ability_border_tier"+I2S(am.getTier())+".blp",0,true)
					call BlzFrameSetVisible(ABILITY_MIX_TIER_BORDER[index],true)
					call BlzFrameSetVisible(ABILITY_MIX_REMOVE[index],true)
				endif
			endif
			set aid1 = .ability_mix_element1.getId()
			set aid2 = .ability_mix_element2.getId()
			call refreshRecipe()
			call setAbilityMixResult(AbilityMix.getResult(aid1,aid2))
		endmethod

		method abilityMixConfirm takes nothing returns nothing
			local AbilityMixElement am1 = .ability_mix_element1
			local AbilityMixElement am2 = .ability_mix_element2
			local integer ar/*믹스테이블ID*/ = AbilityMix.getResult(am1.getId(),am2.getId()) 
			local boolean result = false
			if am2.element_type == AbilityMixElement.TYPE_ABILITY then
				/*보유중인 스킬은 부재료로 못씀*/
				set CUSTOM_RESPOND_ERROR_PLAYER = .owner
				set CUSTOM_RESPOND_ERROR_MESSAGE = "보유중인 스킬은 부 재료로 등록할 수 없습니다."
				call Event.activate(ENUM_EVENT_ERROR)
				return
			endif
			if ar == AbilityMix.EMPTY then
				/*비어있어서 컷*/
				/*에러표시 따로 안 함*/
				return
			elseif ar == AbilityMix.DISABLED then
				/*티어합계초과*/
				/*에러표시 따로 안 함(조합 불가능 여부를 표시하고 있음)*/
				return
			elseif ar == AbilityMix.LEVEL then
				/*레벨합성*/
				set result = AbilityMix.mixLevel(Unit(User.getFocusUnit(.owner)),am1,am2)
			elseif ar == AbilityMix.RANDOM then
				/*랜덤합성*/
				set result = AbilityMix.mixRandom(Unit(User.getFocusUnit(.owner)),am1,am2)
			elseif ar > 0 then
				/*레시피합성*/
				set result = AbilityMix.mix(Unit(User.getFocusUnit(.owner)),am1,am2)
			endif
			if result then
				/*클리어*/
				if ar != AbilityMix.LEVEL then
					/*레벨합성이면 1번슬롯 그대로 냅두기*/
					call setAbilityMixTarget(0,0)
				endif
				call setAbilityMixTarget(1,0)
				set CUSTOM_RESPOND_UI_REFRESH_PLAYER = .owner
				call Event.activate(ENUM_EVENT_ABILITY_UI_REFRESH)
				set CUSTOM_RESPOND_UI_REFRESH_PLAYER = null
			endif
		endmethod

		method abilityMixRegisterRequest takes integer id, integer et returns nothing
			local AbilityMixElement am = 0
			if .ability_mix_element1 <= 0 then
				if et == AbilityMixElement.TYPE_ABILITY then
					set am = AbilityMixElement.createFromAbility(id)
				elseif et == AbilityMixElement.TYPE_ABILITY_SHARD then
					set am = AbilityMixElement.createFromAbilityShard(id)
				endif
				if .ability_mix_element2 > 0 and am.element_type == .ability_mix_element2.element_type and am.instance_id == .ability_mix_element2.instance_id then
					/*엘리먼트2랑 완전중복이면 컷*/
					call am.destroy()
					/*에러는 따로 표시 안 함*/
				else
					/*중복 아니면 등록해주기*/
					call setAbilityMixTarget(0,am)
				endif
			elseif .ability_mix_element2 <= 0 then
				if et == AbilityMixElement.TYPE_ABILITY then
					/*보유중인 스킬은 부 재료로 등록 불가*/
					set CUSTOM_RESPOND_ERROR_PLAYER = .owner
					set CUSTOM_RESPOND_ERROR_MESSAGE = "보유중인 스킬은 부 재료로 등록할 수 없습니다."
					call Event.activate(ENUM_EVENT_ERROR)
					return
				elseif et == AbilityMixElement.TYPE_ABILITY_SHARD then
					set am = AbilityMixElement.createFromAbilityShard(id)
				endif
				if am.element_type == .ability_mix_element1.element_type and am.instance_id == .ability_mix_element1.instance_id then
					/*엘리먼트1이랑 완전중복이면 컷*/
					call am.destroy()
					/*에러는 따로 표시 안 함*/
				else
					/*중복 아니면 등록해주기*/
					call setAbilityMixTarget(1,am)
				endif
			endif
		endmethod

		method show takes boolean flag returns nothing
			if GetLocalPlayer() == Player(this) then
				call BlzFrameSetVisible(CONTAINER,flag)
			endif
			if .visible_flag != flag then
				if flag then
					/*능력 불러오기*/
					call loadAbility()
					/*믹스엘리먼트 초기화*/
					call setAbilityMixTarget(0,0)
					call setAbilityMixTarget(1,0)
					/*인벤토리 닫혀있으면 열기*/
					if .page == PAGE_MIX and not Inventory(this).visible_flag then
						call Inventory(this).visibleForPlayer(true)
					endif
					/*CLOSEUI*/
					call CloseUI(this).add(CloseUI.ORDER_ABILITY_MANAGER)
					/*아이템 떨구기 비활성화*/
					call Inventory(this).disableDrop()
				else
					/*CLOSEUI*/
					call CloseUI(this).eraseFor(CloseUI.ORDER_ABILITY_MANAGER)
					/*아이템 떨구기 재활성화*/
					call Inventory(this).enableDrop()
				endif
				/*어빌리티 단축키 사용여부 스위칭*/
				call User.enableAbilityHotkey(.owner,not flag)
				/*어빌리티 아이콘 우클릭 가능여부 스위칭*/
				call User.enableAbilityRightClick(.owner,not flag)
			endif
			set .visible_flag = flag
		endmethod

		method setPage takes integer index returns nothing
			local integer i = 0
			set .page = index
			/*페이지버튼*/
			loop
				exitwhen i >= PAGE_MAX
				if GetLocalPlayer() == .owner then
					call BlzFrameSetVisible(PAGE[i],false)
					call BlzFrameSetEnable(PAGE_BUTTON[i],i!=index)
					if index == i then
						call BlzFrameSetText(PAGE_BUTTON_TEXT[i],"|cff00ff00"+PAGE_BUTTON_STRING[i]+"|r")
					else
						call BlzFrameSetText(PAGE_BUTTON_TEXT[i],"|cffffffff"+PAGE_BUTTON_STRING[i]+"|r")
					endif
				endif
				set i = i + 1
			endloop
			if index == PAGE_MIX then
				/*믹스엘리먼트 초기화*/
				call setAbilityMixTarget(0,0)
				call setAbilityMixTarget(1,0)
				/*인벤토리 닫혀있으면 열기*/
				if not Inventory(this).visible_flag then
					call Inventory(this).visibleForPlayer(true)
				endif
			endif
			/*로컬*/
			if GetLocalPlayer() == .owner then
				call BlzFrameSetVisible(ABILITY_LEVEL_BUTTON_CONTAINER,false)
				call BlzFrameSetVisible(ABILITY_REMOVE_BUTTON_CONTAINER,false)
				if index == PAGE_UPGRADE or index == PAGE_EXTRACT then
					/*레벨업or제거 항목에서는 페이지1출력*/
					call BlzFrameSetVisible(PAGE[PAGE_UPGRADE],true)
					if index ==  PAGE_UPGRADE then
						/*레벨업 버튼*/
						call BlzFrameSetVisible(ABILITY_LEVEL_BUTTON_CONTAINER,true)
						/*도움말*/
						call BlzFrameSetText(HELP_TOOLTIP_TEXT,/*
							*/CONSTANT_ABILITY_UPGRADE_TYPE_NAME[ENUM_ABILITY_UPGRADE_TYPE_RED]+", "+CONSTANT_ABILITY_UPGRADE_TYPE_NAME[ENUM_ABILITY_UPGRADE_TYPE_GREEN]+", "+CONSTANT_ABILITY_UPGRADE_TYPE_NAME[ENUM_ABILITY_UPGRADE_TYPE_BLUE]+"를 사용해서 선택한 스킬의 레벨을 상승시킵니다.\n해당 스킬의 등급(티어)에 따라 소모되는 재화의 갯수가 결정됩니다."/*
						*/)
					elseif index == PAGE_EXTRACT then
						/*제거 버튼*/
						call BlzFrameSetVisible(ABILITY_REMOVE_BUTTON_CONTAINER,true)
						/*도움말*/
						call BlzFrameSetText(HELP_TOOLTIP_TEXT,"망각의 파편을 사용해서 선택한 스킬을 제거하여 스킬 파편을 만듭니다.\n고유 스킬은 제거할 수 없습니다.")
					endif
				elseif index == PAGE_MIX then
					/*어빌리티 합성*/
					/*레시피 일단 날리기*/
					call BlzFrameSetVisible(RECIPE_CONTAINER,false)
					/*도움말*/
					call BlzFrameSetText(HELP_TOOLTIP_TEXT,"보유한 스킬이나 소지하고 있는 스킬파편을 우클릭하여 재료로 등록한 뒤 합성을 진행합니다.\n\n - 같은 종류의 재료를 등록하면 주 재료의 레벨을 상승시킵니다.\n - 레시피에 맞는 재료를 등록하면 레시피 결과물을 생성합니다.\n - 레시피에 맞지 않는 재료를 등록하면 두 재료의 티어합계에 해당하는 무작위 결과물을 생성합니다.")
					call BlzFrameSetVisible(PAGE[PAGE_MIX],true)
				endif
			endif
			call refreshAbilityIcons()
		endmethod

		method switch takes nothing returns nothing
			call show(not .visible_flag)
		endmethod

		method close takes nothing returns nothing
			call show(false)
		endmethod

		method upgradeModeChange takes nothing returns nothing
			if .upgrade_mode == ENUM_ABILITY_UPGRADE_TYPE_RED then
				set .upgrade_mode = ENUM_ABILITY_UPGRADE_TYPE_GREEN
			elseif .upgrade_mode == ENUM_ABILITY_UPGRADE_TYPE_GREEN then
				set .upgrade_mode = ENUM_ABILITY_UPGRADE_TYPE_BLUE
			elseif .upgrade_mode == ENUM_ABILITY_UPGRADE_TYPE_BLUE then
				set .upgrade_mode = ENUM_ABILITY_UPGRADE_TYPE_RED
			endif
			call refreshAbilityIcons()
		endmethod

		static method keypressCallback takes nothing returns nothing
			local thistype this = 0
			local integer i = 0
			local boolean b = false
			/*V키 입력*/
			if Event.getValue() == ENUM_EVENT_KEYPRESS then
				set this = GetPlayerId(CUSTOM_RESPOND_KEYPRESS_PLAYER)
				if CUSTOM_RESPOND_KEYPRESS_KEY == OSKEY_V and CUSTOM_RESPOND_KEYPRESS_PRESS then
					call switch()
					return
				endif
				return
			endif
			/*리셋포커스, 버튼 클릭*/
			set this = GetPlayerId(GetTriggerPlayer())
			if BlzGetTriggerFrame() != null then
				/*리셋포커스*/
				if GetLocalPlayer() == Player(this) then
					if BlzFrameGetEnable(BlzGetTriggerFrame()) then
						call BlzFrameSetEnable(BlzGetTriggerFrame(),false)
						call BlzFrameSetEnable(BlzGetTriggerFrame(),true)
					endif
				endif
				/*버튼클릭 아니면 컷*/
				if BlzGetTriggerFrameEvent() != FRAMEEVENT_CONTROL_CLICK then
					return
				endif
				/*닫기버튼 눌렀으면 닫고 리턴*/
				if BlzGetTriggerFrame() == CLOSE_BUTTON then
					call close()
					return
				elseif BlzGetTriggerFrame() == UPGRADE_MODE_CHANGE then
					call upgradeModeChange()
					return
				else
					/*페이지버튼*/
					loop
						exitwhen i >= PAGE_MAX
						if BlzGetTriggerFrame() == PAGE_BUTTON[i] then
							call setPage(i)
							return
						endif 
						set i = i + 1
					endloop
					set i = 0
					/*페이지별 분기*/
					if .page == PAGE_UPGRADE then
						/*레벨업버튼(P0)*/
						loop
							exitwhen i >= CONFIG_ABILITY_SIZE
							if BlzGetTriggerFrame() == ABILITY_LEVEL_BUTTON[i] then
								call levelButtonPress(i,.upgrade_mode)
								return
							endif
							set i = i + 1
						endloop
						return
					elseif .page == PAGE_MIX then
						/*믹스 제거(P1)*/
						loop
							exitwhen i >= 2/*재료1, 2만 체크하면됨*/
							if BlzGetTriggerFrame() == ABILITY_MIX_REMOVE[i] then
								call setAbilityMixTarget(i,0)
								return
							endif
							set i = i + 1
						endloop
						/*믹스 컨펌*/
						if BlzGetTriggerFrame() == ABILITY_MIX_CONFIRM then
							call abilityMixConfirm()
							return
						endif
						//
						return
					elseif .page == PAGE_EXTRACT then
						/*제거버튼(P2)*/
						loop
							exitwhen i >= CONFIG_ABILITY_SIZE
							if BlzGetTriggerFrame() == ABILITY_REMOVE_BUTTON[i] then
								call removeButtonPress(i)
								return
							endif
							set i = i + 1
						endloop
						return
					endif
					return
				endif
			endif
		endmethod

		static method initFrames takes nothing returns nothing
			local integer i = 0
			local real width = 0
			local real icon_size = 0
			local real v1 = 0
			local framehandle f = null
			set CONTAINER = FRAME_ABILITY_MANAGER
			set width = (BlzFrameGetWidth(CONTAINER)-Math.px2Size(64))
			set icon_size = Math.px2Size(48)
			set v1 = ((width - icon_size*6)/5)+icon_size
			/*닫기버튼*/
			set CLOSE_BUTTON = BlzCreateFrame("GenericCloseButton",CONTAINER,0,0)
			call BlzFrameSetPointPixel(CLOSE_BUTTON,FRAMEPOINT_TOPRIGHT,CONTAINER,FRAMEPOINT_TOPRIGHT,-16,-16)
			call BlzTriggerRegisterFrameEvent(KEYPRESS,CLOSE_BUTTON,FRAMEEVENT_CONTROL_CLICK)
			call BlzTriggerRegisterFrameEvent(KEYPRESS,CLOSE_BUTTON,FRAMEEVENT_MOUSE_LEAVE)
			/*서브패널*/
			set SUB_PANEL = BlzCreateFrame("MyTextBox",CONTAINER,0,0)
			call BlzFrameSetPointPixel(SUB_PANEL,FRAMEPOINT_BOTTOMLEFT,CONTAINER,FRAMEPOINT_BOTTOMLEFT,8,8)
			call BlzFrameSetPointPixel(SUB_PANEL,FRAMEPOINT_TOPRIGHT,CONTAINER,FRAMEPOINT_TOPRIGHT,-8,-8-112)
			/*페이지버튼*/
			loop
				exitwhen i >= PAGE_MAX
				set PAGE[i] = BlzCreateFrameByType("FRAME","",CONTAINER,"",i)
				set PAGE_BUTTON[i] = BlzCreateFrame("AbilityManagerPageButton",CONTAINER,0,i)
				set PAGE_BUTTON_TEXT[i] = BlzGetFrameByName("AbilityManagerPageButtonText",i)
				if i == 0 then
					call BlzFrameSetPoint(PAGE_BUTTON[i],FRAMEPOINT_BOTTOMLEFT,SUB_PANEL,FRAMEPOINT_TOPLEFT,0,0)
				else
					call BlzFrameSetPoint(PAGE_BUTTON[i],FRAMEPOINT_BOTTOMLEFT,PAGE_BUTTON[i-1],FRAMEPOINT_BOTTOMRIGHT,0,0)
				endif
				call BlzTriggerRegisterFrameEvent(KEYPRESS,PAGE_BUTTON[i],FRAMEEVENT_CONTROL_CLICK)
				call BlzTriggerRegisterFrameEvent(KEYPRESS,PAGE_BUTTON[i],FRAMEEVENT_MOUSE_LEAVE)
				set i = i + 1
			endloop
			set PAGE_BUTTON_STRING[0] = "강화"
			set PAGE_BUTTON_STRING[1] = "합성"
			set PAGE_BUTTON_STRING[2] = "제거"
			call BlzFrameSetTexture(BlzGetFrameByName("AbilityManagerPageButtonIcon",0),"replaceableTextures\\commandbuttons\\btnability_gem_orange.blp",0,true)
			call BlzFrameSetTexture(BlzGetFrameByName("AbilityManagerPageButtonIcon",1),"ReplaceableTextures\\CommandButtons\\BTN3M3.blp",0,true)
			call BlzFrameSetTexture(BlzGetFrameByName("AbilityManagerPageButtonIcon",2),"ReplaceableTextures\\CommandButtons\\btnability_gem_purple.blp",0,true)
			set i = 0
			/*렙업버튼(P0)&제거버튼(P2) 아이콘 하단의 버튼은 페이지별로 다름*/
			set ABILITY_LEVEL_BUTTON_CONTAINER = BlzCreateFrameByType("FRAME","",PAGE[PAGE_UPGRADE],"",0)
			set ABILITY_REMOVE_BUTTON_CONTAINER = BlzCreateFrameByType("FRAME","",PAGE[PAGE_UPGRADE],"",0)
			call BlzFrameSetVisible(ABILITY_REMOVE_BUTTON_CONTAINER,false)
			loop
				exitwhen i >= CONFIG_ABILITY_SIZE
				set ABILITY_ICON[i] = BlzCreateFrameByType("BACKDROP","",PAGE[PAGE_UPGRADE],"",i)
				if i < 6 then
					call BlzFrameSetPoint(ABILITY_ICON[i],FRAMEPOINT_TOPLEFT,CONTAINER,FRAMEPOINT_TOPLEFT,/*
						*/Math.px2Size(32)+v1*i,/*
						*/Math.px2Size(-144-40)/*
					*/)
				else
					call BlzFrameSetPoint(ABILITY_ICON[i],FRAMEPOINT_TOPLEFT,CONTAINER,FRAMEPOINT_TOPLEFT,/*
						*/Math.px2Size(32)+v1*(i-6+0.5),/*
						*/Math.px2Size(-272-40)/*
					*/)
				endif
				call BlzFrameSetTexture(ABILITY_ICON[i],"Icons\\BTNBlackIcon.blp",0,true)
				call BlzFrameSetSizePixel(ABILITY_ICON[i],48,48)
				set ABILITY_TIER_BORDER[i] = BlzCreateFrameByType("BACKDROP","",PAGE[PAGE_UPGRADE],"",i)
				call BlzFrameSetAllPoints(ABILITY_TIER_BORDER[i],ABILITY_ICON[i])
				call BlzFrameSetVisible(ABILITY_TIER_BORDER[i],false)
				set ABILITY_LEVEL_TEXT[i] = BlzCreateFrame("MyTextSmall",PAGE[PAGE_UPGRADE],0,0)
				call BlzFrameSetPointPixel(ABILITY_LEVEL_TEXT[i],FRAMEPOINT_TOP,ABILITY_ICON[i],FRAMEPOINT_BOTTOM,0,-4)
				call BlzFrameSetText(ABILITY_LEVEL_TEXT[i],"Lv. NaN")
				set ABILITY_LEVEL_BUTTON[i] = BlzCreateFrame("AbilityManagerLevelUpButton",ABILITY_LEVEL_BUTTON_CONTAINER,0,i)
				call BlzFrameSetPointPixel(ABILITY_LEVEL_BUTTON[i],FRAMEPOINT_TOP,ABILITY_ICON[i],FRAMEPOINT_BOTTOM,0,-16)
				set ABILITY_REMOVE_BUTTON[i] = BlzCreateFrame("AbilityManagerRemoveButton",ABILITY_REMOVE_BUTTON_CONTAINER,0,i)
				call BlzFrameSetPointPixel(ABILITY_REMOVE_BUTTON[i],FRAMEPOINT_TOP,ABILITY_ICON[i],FRAMEPOINT_BOTTOM,0,-16)
				/**/
				call BlzTriggerRegisterFrameEvent(KEYPRESS,ABILITY_LEVEL_BUTTON[i],FRAMEEVENT_CONTROL_CLICK)
				call BlzTriggerRegisterFrameEvent(KEYPRESS,ABILITY_LEVEL_BUTTON[i],FRAMEEVENT_MOUSE_LEAVE)
				call BlzTriggerRegisterFrameEvent(KEYPRESS,ABILITY_REMOVE_BUTTON[i],FRAMEEVENT_CONTROL_CLICK)
				call BlzTriggerRegisterFrameEvent(KEYPRESS,ABILITY_REMOVE_BUTTON[i],FRAMEEVENT_MOUSE_LEAVE)
				set i = i + 1
			endloop
			/*남은 스킬포인트(P0)*/
			set SKILLPOINT_BACKDROP = BlzCreateFrameByType("BACKDROP","",PAGE[PAGE_UPGRADE],"",0)
			call BlzFrameSetPoint(SKILLPOINT_BACKDROP,FRAMEPOINT_TOPLEFT,ABILITY_ICON[i-1],FRAMEPOINT_TOPLEFT,v1,0.)
			call BlzFrameSetTexture(SKILLPOINT_BACKDROP,"replaceabletextures\\commandbuttons\\BTNStatUp.blp",0,true)
			call BlzFrameSetSizePixel(SKILLPOINT_BACKDROP,48,48)
			set SKILLPOINT_TEXT = BlzCreateFrame("MyTextSmall",PAGE[PAGE_UPGRADE],0,0)
			call BlzFrameSetPointPixel(SKILLPOINT_TEXT,FRAMEPOINT_TOP,SKILLPOINT_BACKDROP,FRAMEPOINT_BOTTOM,0,-4)
			call BlzFrameSetText(SKILLPOINT_TEXT,"|cffffcc00스킬포인트:\n\n0|r")
			call BlzFrameSetTextAlignment(SKILLPOINT_TEXT,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_CENTER)
			set SKILLPOINT_SMALL_BACKDROP = BlzCreateFrameByType("BACKDROP","",FRAME_ABILITY_MANAGER_BUTTON,"",0)
			call BlzFrameSetTexture(SKILLPOINT_SMALL_BACKDROP,"textures\\black32.blp",0,true)
			call BlzFrameSetAlpha(SKILLPOINT_SMALL_BACKDROP,192)
			set SKILLPOINT_SMALL_TEXT = BlzCreateFrame("MyTextSmall",FRAME_ABILITY_MANAGER_BUTTON,0,0)
			call BlzFrameSetPoint(SKILLPOINT_SMALL_TEXT,FRAMEPOINT_TOP,FRAME_ABILITY_MANAGER_BUTTON,FRAMEPOINT_BOTTOM,0,0.)
			call BlzFrameSetTextAlignment(SKILLPOINT_SMALL_TEXT,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_CENTER)
			call BlzFrameSetPoint(SKILLPOINT_SMALL_BACKDROP,FRAMEPOINT_TOPLEFT,SKILLPOINT_SMALL_TEXT,FRAMEPOINT_TOPLEFT,-0.002,0.002)
			call BlzFrameSetPoint(SKILLPOINT_SMALL_BACKDROP,FRAMEPOINT_BOTTOMRIGHT,SKILLPOINT_SMALL_TEXT,FRAMEPOINT_BOTTOMRIGHT,0.002,-0.002)
			/*강화 모드체인지(강화 탭에서만 표시)*/
			set UPGRADE_MODE_CHANGE = BlzCreateFrame("AbilityManagerUpgradeModeChangeButton",ABILITY_LEVEL_BUTTON_CONTAINER,0,0)
			call BlzFrameSetPointPixel(UPGRADE_MODE_CHANGE,FRAMEPOINT_LEFT,SKILLPOINT_BACKDROP,FRAMEPOINT_RIGHT,4,0)
			call BlzTriggerRegisterFrameEvent(KEYPRESS,UPGRADE_MODE_CHANGE,FRAMEEVENT_CONTROL_CLICK)
			call BlzTriggerRegisterFrameEvent(KEYPRESS,UPGRADE_MODE_CHANGE,FRAMEEVENT_MOUSE_LEAVE)
			call Frame.addTooltipSimple(FRAMEPOINT_BOTTOMLEFT,UPGRADE_MODE_CHANGE,FRAMEPOINT_BOTTOMRIGHT,"사용 재화 변경",0,0)
			/*도움말(P0)*/
			set HELP_BACKDROP = BlzCreateFrameByType("BACKDROP","",SUB_PANEL,"",0)
			call BlzFrameSetPointPixel(HELP_BACKDROP,FRAMEPOINT_TOPRIGHT,SUB_PANEL,FRAMEPOINT_TOPRIGHT,-16,-16)
			call BlzFrameSetSizePixel(HELP_BACKDROP,32,32)
			call BlzFrameSetTexture(HELP_BACKDROP,"ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp",0,true)
			set HELP_TEXT = BlzCreateFrame("MyText",SUB_PANEL,0,0)
			call BlzFrameSetPointPixel(HELP_TEXT,FRAMEPOINT_RIGHT,HELP_BACKDROP,FRAMEPOINT_LEFT,-8,0)
			call BlzFrameSetTextAlignment(HELP_TEXT,TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_RIGHT)
			call BlzFrameSetText(HELP_TEXT,"도움말")
			set HELP_MOUSEOVER = BlzCreateFrameByType("FRAME","",HELP_BACKDROP,"",0)
			call BlzFrameSetAllPoints(HELP_MOUSEOVER,HELP_BACKDROP)
			set HELP_TOOLTIP_CONTAINER = BlzCreateFrameByType("FRAME","",HELP_MOUSEOVER,"",0)
			call BlzFrameSetTooltip(HELP_MOUSEOVER,HELP_TOOLTIP_CONTAINER)
			set HELP_TOOLTIP_BACKDROP = BlzCreateFrame("MyTextBox",HELP_TOOLTIP_CONTAINER,0,0)
			set HELP_TOOLTIP_TEXT = BlzCreateFrame("MyText",HELP_TOOLTIP_CONTAINER,0,0)
			call BlzFrameSetPoint(HELP_TOOLTIP_TEXT,FRAMEPOINT_BOTTOMRIGHT,HELP_BACKDROP,FRAMEPOINT_TOPRIGHT,-0.004,0.004)
			call BlzFrameSetTextAlignment(HELP_TOOLTIP_TEXT,TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_LEFT)
			call BlzFrameSetPoint(HELP_TOOLTIP_BACKDROP,FRAMEPOINT_TOPLEFT,HELP_TOOLTIP_TEXT,FRAMEPOINT_TOPLEFT,-0.004,0.004)
			call BlzFrameSetPoint(HELP_TOOLTIP_BACKDROP,FRAMEPOINT_BOTTOMRIGHT,HELP_TOOLTIP_TEXT,FRAMEPOINT_BOTTOMRIGHT,0.004,-0.004)
			/*합성 아이콘(P1)*/
			set i = 0
			set width = (BlzFrameGetWidth(CONTAINER)-Math.px2Size(16))
			set v1 = (((Math.size2Px(width)-64.)/3.)-80.)/2.0
			loop
				exitwhen i >= 3
				set ABILITY_MIX_BACKDROP[i] = BlzCreateFrameByType("BACKDROP","",PAGE[PAGE_MIX],"",0)
				set ABILITY_MIX_TIER_BORDER[i] = BlzCreateFrameByType("BACKDROP","",ABILITY_MIX_BACKDROP[i],"",0)
				set ABILITY_MIX_REMOVE[i] = BlzCreateFrame("GenericCloseButton",ABILITY_MIX_BACKDROP[i],0,0)
				set ABILITY_MIX_TOP[i] = BlzCreateFrame("MyTextSmall",ABILITY_MIX_BACKDROP[i],0,0)
				set ABILITY_MIX_SUB[i] = BlzCreateFrame("MyTextSmall",ABILITY_MIX_BACKDROP[i],0,0)
				call BlzFrameSetPointPixel(ABILITY_MIX_BACKDROP[i],FRAMEPOINT_TOPLEFT,SUB_PANEL,FRAMEPOINT_TOPLEFT,/*
					*/v1+32+((Math.size2Px(width)-64.)*i/3.0)/*
					*/,-104/*
				*/)
				call BlzFrameSetSizePixel(ABILITY_MIX_BACKDROP[i],80,80)
				call BlzFrameSetTexture(ABILITY_MIX_BACKDROP[i],"Icons\\BTNBlackIcon.blp",0,true)
				call BlzFrameSetAllPoints(ABILITY_MIX_TIER_BORDER[i],ABILITY_MIX_BACKDROP[i])
				call BlzFrameSetVisible(ABILITY_MIX_TIER_BORDER[i],false)
				call BlzFrameSetPointPixel(ABILITY_MIX_REMOVE[i],FRAMEPOINT_BOTTOMRIGHT,ABILITY_MIX_BACKDROP[i],FRAMEPOINT_BOTTOMRIGHT,8,-8)
				call BlzFrameSetVisible(ABILITY_MIX_REMOVE[i],false)
				call BlzFrameSetPointPixel(ABILITY_MIX_TOP[i],FRAMEPOINT_BOTTOM,ABILITY_MIX_BACKDROP[i],FRAMEPOINT_TOP,0,8.0)
				call BlzFrameSetTextAlignment(ABILITY_MIX_TOP[i],TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_CENTER)
				call BlzFrameSetPointPixel(ABILITY_MIX_SUB[i],FRAMEPOINT_TOP,ABILITY_MIX_BACKDROP[i],FRAMEPOINT_BOTTOM,0,-8)
				call BlzFrameSetTextAlignment(ABILITY_MIX_SUB[i],TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_CENTER)
				call BlzTriggerRegisterFrameEvent(KEYPRESS,ABILITY_MIX_REMOVE[i],FRAMEEVENT_CONTROL_CLICK)
				call BlzTriggerRegisterFrameEvent(KEYPRESS,ABILITY_MIX_REMOVE[i],FRAMEEVENT_MOUSE_LEAVE)
				set i = i + 1
			endloop
			/*더하기*/
			set f = BlzCreateFrame("MyText",PAGE[PAGE_MIX],0,0)
			call BlzFrameSetPoint(f,FRAMEPOINT_LEFT,ABILITY_MIX_BACKDROP[0],FRAMEPOINT_RIGHT,0,0)
			call BlzFrameSetPoint(f,FRAMEPOINT_RIGHT,ABILITY_MIX_BACKDROP[1],FRAMEPOINT_LEFT,0,0)
			call BlzFrameSetTextAlignment(f,TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_CENTER)
			call BlzFrameSetText(f,"+")
			call BlzFrameSetScale(f,2.0)
			/*는*/
			set f = BlzCreateFrame("MyText",PAGE[PAGE_MIX],0,0)
			call BlzFrameSetPoint(f,FRAMEPOINT_LEFT,ABILITY_MIX_BACKDROP[1],FRAMEPOINT_RIGHT,0,0)
			call BlzFrameSetPoint(f,FRAMEPOINT_RIGHT,ABILITY_MIX_BACKDROP[2],FRAMEPOINT_LEFT,0,0)
			call BlzFrameSetTextAlignment(f,TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_CENTER)
			call BlzFrameSetText(f,"=")
			call BlzFrameSetScale(f,2.0)
			/*타이틀*/
			call BlzFrameSetText(ABILITY_MIX_TOP[0],"주 재료")
			call BlzFrameSetText(ABILITY_MIX_TOP[1],"부 재료")
			call BlzFrameSetText(ABILITY_MIX_TOP[2],"결과물")
			set ABILITY_MIX_CONFIRM = BlzCreateFrame("AbilityMixConfirmButton",PAGE[PAGE_MIX],0,0)
			call BlzFrameSetPointPixel(ABILITY_MIX_CONFIRM,FRAMEPOINT_BOTTOM,SUB_PANEL,FRAMEPOINT_BOTTOM,0.,32)
			call BlzTriggerRegisterFrameEvent(KEYPRESS,ABILITY_MIX_CONFIRM,FRAMEEVENT_CONTROL_CLICK)
			call BlzTriggerRegisterFrameEvent(KEYPRESS,ABILITY_MIX_CONFIRM,FRAMEEVENT_MOUSE_LEAVE)
			/*합성 추천레시피*/
			set RECIPE_CONTAINER = BlzCreateFrameByType("FRAME","",PAGE[PAGE_MIX],"",0)
			set RECIPE_BACKDROP = BlzCreateFrame("MyTextBox",RECIPE_CONTAINER,0,0)
			call BlzFrameSetPoint(RECIPE_BACKDROP,FRAMEPOINT_BOTTOMRIGHT,CONTAINER,FRAMEPOINT_BOTTOMLEFT,0,0)
			call BlzFrameSetSizePixel(RECIPE_BACKDROP,/*
			*/16/*INSETLEFT*/+16/*INSETRIGHT*/+32/*ICON1*/+24/*PLUS*/+32/*ICON2*/+24/*PLUS*/+32/*ICON3*/,/*
			*/16/*INSETTOP*/+16/*INSETBOTTOM*/+48/*TITILEHEIGHT*/+8/*TITLEMARGINBOTTOM*/+32*4/*ROWS*/+16*3/*MARGINS*//*
			*/)
			/**/
			set RECIPE_TITLE = BlzCreateFrame("MyText",RECIPE_CONTAINER,0,0)
			call BlzFrameSetPointPixel(RECIPE_TITLE,FRAMEPOINT_TOPLEFT,RECIPE_BACKDROP,FRAMEPOINT_TOPLEFT,0,0)
			call BlzFrameSetPointPixel(RECIPE_TITLE,FRAMEPOINT_BOTTOMRIGHT,RECIPE_BACKDROP,FRAMEPOINT_TOPRIGHT,0,-48)
			call BlzFrameSetTextAlignment(RECIPE_TITLE,TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_CENTER)
			call BlzFrameSetText(RECIPE_TITLE,"조합 가능 레시피")
			set i = 0
			loop
				exitwhen i >= 4
				set RECIPE_ROW[i] = BlzCreateFrameByType("FRAME","",RECIPE_CONTAINER,"",0)
				set RECIPE_MAIN[i] = BlzCreateFrameByType("BACKDROP","",RECIPE_ROW[i],"",i)
				set RECIPE_MAIN_BORDER[i] = BlzCreateFrameByType("BACKDROP","",RECIPE_ROW[i],"",i)
				set RECIPE_PLUS[i] = BlzCreateFrame("MyTextSmall",RECIPE_ROW[i],0,i)
				set RECIPE_SUB[i] = BlzCreateFrameByType("BACKDROP","",RECIPE_ROW[i],"",i)
				set RECIPE_SUB_BORDER[i] = BlzCreateFrameByType("BACKDROP","",RECIPE_ROW[i],"",i)
				set RECIPE_EQUAL[i] = BlzCreateFrame("MyTextSmall",RECIPE_ROW[i],0,i)
				set RECIPE_RESULT[i] = BlzCreateFrameByType("BACKDROP","",RECIPE_ROW[i],"",i)
				set RECIPE_RESULT_BORDER[i] = BlzCreateFrameByType("BACKDROP","",RECIPE_ROW[i],"",i)
				/*주재료*/
				call BlzFrameSetPointPixel(RECIPE_MAIN[i],FRAMEPOINT_TOPLEFT,RECIPE_TITLE,FRAMEPOINT_BOTTOMLEFT,16,-8-(32+16)*i)
				call BlzFrameSetSizePixel(RECIPE_MAIN[i],32,32)
				call BlzFrameSetAllPoints(RECIPE_MAIN_BORDER[i],RECIPE_MAIN[i])
				/*더하기*/
				call BlzFrameSetPointPixel(RECIPE_PLUS[i],FRAMEPOINT_LEFT,RECIPE_MAIN[i],FRAMEPOINT_RIGHT,0,0)
				call BlzFrameSetSizePixel(RECIPE_PLUS[i],24,24)
				call BlzFrameSetTextAlignment(RECIPE_PLUS[i],TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_CENTER)
				call BlzFrameSetText(RECIPE_PLUS[i],"+")
				/*부재료*/
				call BlzFrameSetPointPixel(RECIPE_SUB[i],FRAMEPOINT_LEFT,RECIPE_PLUS[i],FRAMEPOINT_RIGHT,0,0)
				call BlzFrameSetSizePixel(RECIPE_SUB[i],32,32)
				call BlzFrameSetAllPoints(RECIPE_SUB_BORDER[i],RECIPE_SUB[i])
				/*는*/
				call BlzFrameSetPointPixel(RECIPE_EQUAL[i],FRAMEPOINT_LEFT,RECIPE_SUB[i],FRAMEPOINT_RIGHT,0,0)
				call BlzFrameSetSizePixel(RECIPE_EQUAL[i],24,24)
				call BlzFrameSetTextAlignment(RECIPE_EQUAL[i],TEXT_JUSTIFY_MIDDLE,TEXT_JUSTIFY_CENTER)
				call BlzFrameSetText(RECIPE_EQUAL[i],"=")
				/*결과물*/
				call BlzFrameSetPointPixel(RECIPE_RESULT[i],FRAMEPOINT_LEFT,RECIPE_EQUAL[i],FRAMEPOINT_RIGHT,0,0)
				call BlzFrameSetSizePixel(RECIPE_RESULT[i],32,32)
				call BlzFrameSetAllPoints(RECIPE_RESULT_BORDER[i],RECIPE_RESULT[i])
				/*일단숨김*/
				call BlzFrameSetVisible(RECIPE_ROW[i],false)
				set i = i + 1
			endloop
			set f = null
		endmethod

		static method create takes player p returns thistype
			local thistype this = GetPlayerId(p)
			if .INIT then
				call initFrames()
				set .INIT = false
			endif
			set .visible_flag = false
			set .list = SimpleList.create(CONFIG_ABILITY_SIZE)
			set .ability_mix_element1 = 0
			set .ability_mix_element2 = 0
			set .upgrade_mode = ENUM_ABILITY_UPGRADE_TYPE_RED
			call setTarget(User.getFocusUnit(.owner))
			call setPage(0)
			return this
		endmethod

		static method onInit takes nothing returns nothing
			set KEYPRESS = CreateTrigger()
			call TriggerAddCondition(KEYPRESS,function thistype.keypressCallback)
			call Event.register(KEYPRESS,ENUM_EVENT_KEYPRESS)
			set REFRESH_SKILLPOINT_TRIGGER = CreateTrigger()
			call TriggerAddCondition(REFRESH_SKILLPOINT_TRIGGER,function thistype.refreshSkillpointCallback)
		endmethod

	endstruct

endlibrary