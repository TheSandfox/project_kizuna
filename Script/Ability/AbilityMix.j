library AbilityMix initializer init

	globals
		private hashtable HASH = InitHashtable()
		private hashtable HASH2 = InitHashtable()
		/*렙업이펙트*/
		private constant string EFFECT_PATH1 = "Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl"/*렙업합성*/
		private constant string EFFECT_PATH2 = "Abilities\\Spells\\Items\\AIim\\AIimTarget.mdl"/*랜덤합성*/
		private constant string EFFECT_PATH3 = "Abilities\\Spells\\Items\\AIam\\AIamTarget.mdl"/*레시피합성*/
		private constant string EFFECT_PATH4 = "Abilities\\Spells\\Items\\AIlm\\AIlmTarget.mdl"/*파편 우클릭으로 습득 시*/
	endglobals

	struct AbilityShard extends Item
		
		private static hashtable HASH = InitHashtable()
		static player USER = null

		integer level = 1
		integer ability_id = 0

		/*Override*/
		method getIconPath takes nothing returns string
			return Ability.getTypeIconPath(.ability_id)
		endmethod

		method getName takes nothing returns string
			return Ability.getTypeName(.ability_id)
		endmethod

		method getUpgradePoint takes integer index returns integer
			if HaveSavedInteger(HASH,this,index) then
				return LoadInteger(HASH,this,index)
			else
				return 0
			endif
		endmethod

		method setUpgradePoint takes integer index, integer val returns integer
			call SaveInteger(HASH,this,index,val)
			return this
		endmethod

		method addUpgradePoint takes integer index, integer val returns integer
			call setUpgradePoint(index,getUpgradePoint(index)+val)
			return this
		endmethod

		method addLevel takes integer val returns thistype
			/*레벨 더하기*/
			set .level = .level + val
			call refreshDropName()
			return this
		endmethod

		/*Override*/
		method onRightClick takes nothing returns boolean
			local boolean result = false
			local Ability na = 0
			local integer i = 0
			local Ability oa = 0
			if AbilityManager(GetPlayerId(USER)).visible_flag then
				call AbilityManager(GetPlayerId(USER)).abilityMixRegisterRequest(this,AbilityMixElement.TYPE_ABILITY_SHARD)
				return true
			else
				return false
			endif
		endmethod

		/*Override*/
		method onLeftClick takes nothing returns boolean
			local boolean result = false
			local Ability na = 0
			local integer i = 0
			local Ability oa = 0
			/*유효하지 않은 플레이어*/
			if USER == null then
				return false
			endif
			/*어빌창 열면 습득안됨*/
			if AbilityManager(GetPlayerId(USER)).visible_flag then
				set USER = null
				return false
			endif
			/*어빌리티추가해주기..*/
			/*이미 갖고있지 않으면서 슬롯도 있는지*/
			/*빈 공간이 있어야만 0을 반환함*/
			set oa = User.getFocusUnit(USER).getAbilityById(.ability_id)
			if oa == 0 then
				/*어빌추가 OK*/
				set na = User.getFocusUnit(USER).addAbility(.ability_id)
				if na > 0 then
					/*레벨복사*/
					call na.addLevel(.level-1)
					/*재화복사*/
					loop
						exitwhen i >= ENUM_ABILITY_UPGRADE_TYPE_MAX
						call na.setUpgradePoint(i,getUpgradePoint(i))
						set i = i + 1
					endloop
					call destroy()
					/*이펙트출력*/
					call AttatchedEffect.create(EFFECT_PATH4,User.getFocusUnit(USER)).setDuration(2.0)
					/*UI리프레시*/
					set CUSTOM_RESPOND_UI_REFRESH_PLAYER = USER
					call Event.activate(ENUM_EVENT_ABILITY_UI_REFRESH)
					set CUSTOM_RESPOND_UI_REFRESH_PLAYER = null
					set result = true
				else
					set result = false
				endif
			elseif oa == -1 then
				/*공간없음*/
				set CUSTOM_RESPOND_ERROR_PLAYER = USER
				set CUSTOM_RESPOND_ERROR_MESSAGE = "더이상 스킬을 습득할 수 없습니다."
				call Event.activate(ENUM_EVENT_ERROR)
				set result = false
			else
				/*이미 보유한 능력*/
				set CUSTOM_RESPOND_ERROR_PLAYER = USER
				set CUSTOM_RESPOND_ERROR_MESSAGE = "이미 해당 유형의 스킬을 보유하고 있습니다.\n스킬 파편을 이용한 레벨업은 '스킬 관리(V) > 합성' 탭을 이용해주세요."
				set CUSTOM_RESPOND_ERROR_TIME = 3.0
				call Event.activate(ENUM_EVENT_ERROR)
				set CUSTOM_RESPOND_ERROR_TIME = 0.
				set result = false
			endif
			set USER = null
			return result
		endmethod

		static method getRandomUpgradeType takes nothing returns integer
			local integer i = GetRandomInt(0,2)
			if i == 0 then
				return ENUM_ABILITY_UPGRADE_TYPE_RED
			elseif i == 1 then
				return ENUM_ABILITY_UPGRADE_TYPE_GREEN
			elseif i == 2 then
				return ENUM_ABILITY_UPGRADE_TYPE_BLUE
			endif
			return ENUM_ABILITY_UPGRADE_TYPE_RED
		endmethod

		/*Override*/
		method getExtraText takes nothing returns string
			return "lv"+I2S(.level)
		endmethod

		/*Override*/
		method getTier takes nothing returns integer
			return Ability.getTypeTier(.ability_id)
		endmethod

		/*Override*/
		method getModelPath takes nothing returns string
			return "Models\\Items\\item_cube_tier"+I2S(getTier())+".mdl"
		endmethod

		/*Override*/
		method getDropName takes nothing returns string
			return Ability.getTypeName(.ability_id)+"(Lv. "+I2S(.level)+")"
		endmethod

		/*Override*/
		method relativeTooltip takes nothing returns string
			return "[스킬파편] Lv. "+I2S(.level)+" "+Ability.getTypeName(.ability_id)+"\n"+/*
			*/CONSTANT_ABILITY_UPGRADE_TYPE_COLOR[ENUM_ABILITY_UPGRADE_TYPE_RED]+I2S(getUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_RED))+"|r/"+/*
			*/CONSTANT_ABILITY_UPGRADE_TYPE_COLOR[ENUM_ABILITY_UPGRADE_TYPE_RED]+I2S(getUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_RED))+"|r/"+/*
			*/CONSTANT_ABILITY_UPGRADE_TYPE_COLOR[ENUM_ABILITY_UPGRADE_TYPE_GREEN]+I2S(getUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_GREEN))+"|r/"+/*
			*/CONSTANT_ABILITY_UPGRADE_TYPE_COLOR[ENUM_ABILITY_UPGRADE_TYPE_BLUE]+I2S(getUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_BLUE))+"|r\n\n|cff999999"+/*
			*/"클릭하여 습득"
		endmethod
		
		static method create takes integer aid returns thistype
			local thistype this = allocate()
			set .ability_id = aid
			call addUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_GREEN/*getRandomUpgradeType()*/,getTier()*1)
			/*툴팁지정*/
			call setTooltip(ItemTooltip.NORMAL)
			return this
		endmethod

		static method createFromAbility takes Ability targetabil returns thistype
			local thistype this = 0
			local integer i = 0
			if targetabil <= 0 then
				return 0
			endif
			set this = create(targetabil.id)
			/*레벨복사*/
			call addLevel(targetabil.level-1)
			/*업글상태 복사*/
			loop
				exitwhen i >= ENUM_ABILITY_UPGRADE_TYPE_MAX
				call setUpgradePoint(i,targetabil.getUpgradePoint(i))
				set i = i + 1
			endloop
			/*능력소유주에게 주기*/
			call pick(targetabil.owner)
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen i >= ENUM_ABILITY_UPGRADE_TYPE_MAX
				call setUpgradePoint(i,0)
				set i = i + 1
			endloop
		endmethod

	endstruct

	struct AbilityMixElement

		static constant integer TYPE_ABILITY = 1
		static constant integer TYPE_ABILITY_SHARD = 2

		integer element_type = 0
		integer instance_id = 0

		method isSignature takes nothing returns boolean
			if this <= 0 then
				return false
			endif
			if .element_type == TYPE_ABILITY then
				/*어빌리티 참조 상태에서는 해당 어빌리티가 고유능력인지 여부를 리턴*/
				return Ability(.instance_id).signature
			else
				/*샤드는 그런거 없음*/
				return false
			endif
		endmethod

		method getName takes nothing returns string
			if this <= 0 then
				return ""
			endif
			if .element_type == TYPE_ABILITY then
				return Ability(.instance_id).name
			elseif .element_type == TYPE_ABILITY_SHARD then
				return AbilityShard(.instance_id).getName()
			endif
			return ""
		endmethod

		method getTier takes nothing returns integer
			if this <= 0 then
				return 0
			endif
			if .element_type == TYPE_ABILITY then
				return Ability.getTypeTier(Ability(.instance_id).id)
			elseif .element_type == TYPE_ABILITY_SHARD then
				return AbilityShard(.instance_id).getTier()
			endif
			return 0
		endmethod

		method getCount takes nothing returns integer
			if this <= 0 then
				return 0
			endif
			if .element_type == TYPE_ABILITY then
				return 0
			elseif .element_type == TYPE_ABILITY_SHARD then
				return AbilityShard(.instance_id).count
			endif
			return 0
		endmethod

		method getIconPath takes nothing returns string
			if this <= 0 then
				return ""
			endif
			if .element_type == TYPE_ABILITY then
				return Ability.getTypeIconPath(Ability(.instance_id).id)
			elseif .element_type == TYPE_ABILITY_SHARD then
				return AbilityShard(.instance_id).getIconPath()
			endif
			return ""
		endmethod

		method getId takes nothing returns integer
			if this <= 0 then
				return 0
			endif
			if .element_type == TYPE_ABILITY then
				return Ability(.instance_id).id
			elseif .element_type == TYPE_ABILITY_SHARD then
				return AbilityShard(.instance_id).ability_id
			endif
			return 0
		endmethod

		method getLevel takes nothing returns integer
			if this <= 0 then
				return 0
			endif
			if .element_type == TYPE_ABILITY then
				return Ability(.instance_id).level
			elseif .element_type == TYPE_ABILITY_SHARD then
				return AbilityShard(.instance_id).level
			endif
			return 0
		endmethod

		method addLevel takes integer val returns nothing
			if this <= 0 then
				return
			endif
			if .element_type == TYPE_ABILITY then
				call Ability(.instance_id).addLevel(val)
			elseif .element_type == TYPE_ABILITY_SHARD then
				call AbilityShard(.instance_id).addLevel(val)
			endif
		endmethod

		method getUpgradePoint takes integer index returns integer
			if this <= 0 then
				return 0
			endif
			if .element_type == TYPE_ABILITY then
				return Ability(.instance_id).getUpgradePoint(index)
			elseif .element_type == TYPE_ABILITY_SHARD then
				return AbilityShard(.instance_id).getUpgradePoint(index)
			endif
			return 0
		endmethod

		method setUpgradePoint takes integer index, integer val returns nothing
			if this <= 0 then
				return
			endif
			if .element_type == TYPE_ABILITY then
				call Ability(.instance_id).setUpgradePoint(index,val)
			elseif .element_type == TYPE_ABILITY_SHARD then
				call AbilityShard(.instance_id).setUpgradePoint(index,val)
			endif
		endmethod

		method addUpgradePoint takes integer index, integer val returns nothing
			if this <= 0 then
				return
			endif
			if .element_type == TYPE_ABILITY then
				call Ability(.instance_id).addUpgradePoint(index,val)
			elseif .element_type == TYPE_ABILITY_SHARD then
				call AbilityShard(.instance_id).addUpgradePoint(index,val)
			endif
		endmethod

		method kill takes nothing returns nothing
			if this <= 0 then
				return
			endif
			if .element_type == TYPE_ABILITY then
				call Ability(.instance_id).kill()
			elseif .element_type == TYPE_ABILITY_SHARD then
				call AbilityShard(.instance_id).destroy()
			endif
		endmethod

		static method createFromAbility takes Ability a returns thistype
			local thistype this = allocate()
			set .element_type = TYPE_ABILITY
			set .instance_id = a
			return this
		endmethod

		static method createFromAbilityShard takes AbilityShard as returns thistype
			local thistype this = allocate()
			set .element_type = TYPE_ABILITY_SHARD
			set .instance_id = as
			return this
		endmethod

	endstruct

	struct AbilityMix extends array

		private static integer COUNTER = 0

		/*요구레벨*/
		static constant integer LEVEL_REQUIRE = 10

		/*비어있음 */
		static constant integer EMPTY = -1
		/*레시피 없음 = 랜덤합성*/
		static constant integer RANDOM = -3
		/*최대티어 초과 = 합성불가*/
		static constant integer DISABLED = -4
		/*같은 종류 = 레벨상승*/
		static constant integer LEVEL = -5

		/*업글포인트상태,반환재료(이벤트응답)*/
		static integer array UPGRADE
		static integer array REFUND

		integer main
		integer sub
		integer main_level
		integer sub_level
		integer result

		method addRecommendRecipe takes nothing returns nothing
			local integer i = 0
			loop
				if not HaveSavedInteger(HASH2,.main,i) then
					call SaveInteger(HASH2,.main,i,this)
					exitwhen true
				endif
				set i = i + 1
			endloop
			loop
				if not HaveSavedInteger(HASH2,.sub,i) then
					call SaveInteger(HASH2,.sub,i,this)
					exitwhen true
				endif
				set i = i + 1
			endloop
		endmethod

		static method getRecommendRecipe takes integer aid, integer index returns thistype
			if HaveSavedInteger(HASH2,aid,index) then
				return LoadInteger(HASH2,aid,index)
			else
				return -1
			endif
		endmethod

		method registerRecipe takes nothing returns nothing
			call SaveInteger(HASH,.main,.sub,this)
			call SaveInteger(HASH,.sub,.main,this)
		endmethod

		static method getTier takes integer base, integer material returns integer
			return Ability.getTypeTier(base) + Ability.getTypeTier(material)
		endmethod

		static method getRecipe takes integer base, integer material returns thistype
			if HaveSavedInteger(HASH,base,material) then
				/*레시피 있음(레시피 인스턴스id)*/
				return LoadInteger(HASH,base,material)
			else
				/*레시피 없음(0)*/
				return 0
			endif
		endmethod

		static method getResult takes integer base, integer material returns integer
			if base <=0 or material <=0 then
				/*둘 중 하나라도 유효한 값이 아니면 EMPTY*/
				return EMPTY
			/*같은어빌끼리합성*/
			elseif base==material then
				/*0티어끼리는 합성불가*/
				if Ability.getTypeTier(base) <= 0 then
					return DISABLED
				/*그게 아니면 레벨합성*/
				else
					return LEVEL
				endif
			elseif getTier(base,material) < ENUM_TIER_MAX then
				/*레시피 있음*/
				if getRecipe(base,material) > 0 then
					return getRecipe(base,material).result
				/*레시피 없음*/
				else
					/*0티어끼고 랜덤합성 안됨*/
					if Ability.getTypeTier(base) <= 0 or Ability.getTypeTier(material) <= 0 then
						return DISABLED
					/*그 외엔 랜덤합성 허용*/
					else
						return RANDOM
					endif
				endif
			else
				/*티어합계초과(합성불가)*/
				return DISABLED
			endif
		endmethod

		/*랜덤합성, 레시피합성 예상 레벨 출력용임 레벨합성에는 이 함수 활용 안 함(레벨합성에는 티어합산 로직을 안 씀)*/
		static method carculateMixLevel takes AbilityMixElement am1, AbilityMixElement am2 returns integer
			local integer i = 0
			local integer sum = 0
			if am1 <= 0 or am2 <= 0 then
				return 0
			endif
			loop
				exitwhen i >= ENUM_ABILITY_UPGRADE_TYPE_MAX
				set sum = sum + (am1.getUpgradePoint(i) + am2.getUpgradePoint(i))/(am1.getTier()+am2.getTier())
				set i = i + 1
			endloop
			return sum
		endmethod

		/*리턴형 함수가 아니라 계산결과를 정적배열 REFUND, UPGRADE에 저장하는친구임 사용에 주의를 요함*/
		/*Local Scope에서 사용 시 각별히 주의*/
		static method carculateUpgradePoint takes AbilityMixElement am1, AbilityMixElement am2 returns nothing
			local integer i = 0
			if am1 <= 0 or am2 <= 0 then
				loop
					exitwhen i >= ENUM_ABILITY_UPGRADE_TYPE_MAX
					set UPGRADE[i] = 0
					set REFUND[i] = 0
					set i = i + 1
				endloop
			else
				loop
					exitwhen i >= ENUM_ABILITY_UPGRADE_TYPE_MAX
					set UPGRADE[i] = ((am1.getUpgradePoint(i)+am2.getUpgradePoint(i)) / (am1.getTier()+am2.getTier())) * (am1.getTier()+am2.getTier())
					set REFUND[i] = (am1.getUpgradePoint(i)+am2.getUpgradePoint(i)) - UPGRADE[i]
					// call BJDebugMsg(I2S(am1.getUpgradePoint(i))+"+"+I2S(am2.getUpgradePoint(i))+"=|cff00ff00"+I2S(UPGRADE[i])+"|r, |cffff0000"+I2S(REFUND[i])+"|r")
					set i = i + 1
				endloop
			endif
		endmethod

		/*레시피 합성*/
		static method mix takes Unit target, AbilityMixElement am1, AbilityMixElement am2 returns boolean
			local integer i = 0		/*정수임시 */
			local Ability ab = 0	/*어빌리티임시변수 */
			local thistype recipe = 0 /*레시피*/
			local integer na = 0	/*신규어빌리티or신규파편*/
			local integer nlv = 0	/*신규어빌리티의 레벨*/
			local boolean nsignature = false /*신규어빌이 고유인가*/
			local boolean result = false
			set recipe = getRecipe(am1.getId(),am2.getId())
			/*유효하지 않은 레시피임*/
			if recipe.result <= 0 then
				set CUSTOM_RESPOND_ERROR_PLAYER = target.owner
				set CUSTOM_RESPOND_ERROR_MESSAGE = "유효하지 않은 레시피입니다."
				call Event.activate(ENUM_EVENT_ERROR)
				return false
			endif
			/*레벨부족*/
			if am1.getLevel() < LEVEL_REQUIRE or am2.getLevel() < LEVEL_REQUIRE then
				set CUSTOM_RESPOND_ERROR_PLAYER = target.owner
				set CUSTOM_RESPOND_ERROR_MESSAGE = "스킬,스킬 파편의 레벨이 부족합니다."
				call Event.activate(ENUM_EVENT_ERROR)
				return false
			endif
			/*보유중인 어빌리티는 부재료로 쓸 수 없음*/
			if am2.element_type == AbilityMixElement.TYPE_ABILITY then
				set CUSTOM_RESPOND_ERROR_PLAYER = target.owner
				set CUSTOM_RESPOND_ERROR_MESSAGE = "보유중인 스킬은 부 재료로 등록할 수 없습니다."
				call Event.activate(ENUM_EVENT_ERROR)
				return false
			endif
			/*주재료가 어빌리티이면서 이미 레시피에 해당하는 어빌리티를 가지고 있음*/
			if am1.element_type == AbilityMixElement.TYPE_ABILITY and target.getAbilityById(recipe.result) > 0 then
				set CUSTOM_RESPOND_ERROR_PLAYER = target.owner
				set CUSTOM_RESPOND_ERROR_MESSAGE = "해당 유형의 스킬을 이미 보유하고 있습니다."
				call Event.activate(ENUM_EVENT_ERROR)
				return false
			endif
			/*재료 파괴*/
			set nlv = carculateMixLevel(am1,am2)/*파괴하기 전에 레벨 기록*/
			call carculateUpgradePoint(am1,am2)/*파괴하기 전에 업글상태 기록(전역배열에 저장)*/
			set nsignature = am1.isSignature()/*파괴하기 전에 고유능력여부 기록*/
			call am1.kill()
			call am2.kill()
			if am1.element_type == AbilityMixElement.TYPE_ABILITY then
				/*새 어빌리티 주기*/
				set na = target.addAbility(recipe.result)
				/*새 어빌리티 레벨 설정*/
				call Ability(na).addLevel(nlv-1)
				/*새 어빌리티 고유능력 여부*/
				set Ability(na).signature = nsignature
				/*새 어빌리티 업글상태 설정&환불*/
				set i = 0
				loop
					exitwhen i >= ENUM_ABILITY_UPGRADE_TYPE_MAX
					call Ability(na).setUpgradePoint(i,UPGRADE[i])
					call target.addUpgradePoint(i,REFUND[i])
					set i = i + 1
				endloop
				/*골드는 플레이어에게로 환수*/
				call User.addGold(target.owner,target.getUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_RED))
				call target.setUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_RED,0)
			else
				/*새 파편 주기*/
				set na = AbilityShard.create(recipe.result)
				call AbilityShard(na).pick(target)
				/*새 파편 레벨 설정*/
				call AbilityShard(na).addLevel(nlv-1)
				/*새 파편 업글상태 설정&환불*/
				set i = 0
				loop
					exitwhen i >= ENUM_ABILITY_UPGRADE_TYPE_MAX
					call AbilityShard(na).setUpgradePoint(i,UPGRADE[i])
					call target.addUpgradePoint(i,REFUND[i])
					set i = i + 1
				endloop
				/*골드는 플레이어에게로 환수*/
				call User.addGold(target.owner,target.getUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_RED))
				call target.setUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_RED,0)
			endif
			/*성공이펙트*/
			call AttatchedEffect.create(EFFECT_PATH3,target).setDuration(2.0)
			return true
		endmethod

		/*랜덤합성*/
		static method mixRandom takes Unit target, AbilityMixElement am1, AbilityMixElement am2 returns boolean
			local integer i = 0
			local Array table = 0
			local Ability ab = 0
			local integer na = 0	/*신규어빌리티or신규파편*/
			local integer nlv = 0	/*신규어빌리티의 레벨*/
			local boolean nsignature = false /*신규어빌이 고유인가*/
			local integer rabil = 0	/*뽑인 무작위 어빌리티ID*/
			local boolean result = false
			/*고유 능력은 랜덤합성을 진행할 수 없음*/
			if am1.isSignature() then
				set CUSTOM_RESPOND_ERROR_PLAYER = target.owner
				set CUSTOM_RESPOND_ERROR_MESSAGE = "고유 스킬은 랜덤 합성이 불가능합니다."
				call Event.activate(ENUM_EVENT_ERROR)
				return false
			endif
			/*보유중인 어빌리티는 부재료로 쓸 수 없음*/
			if am2.element_type == AbilityMixElement.TYPE_ABILITY then
				set CUSTOM_RESPOND_ERROR_PLAYER = target.owner
				set CUSTOM_RESPOND_ERROR_MESSAGE = "보유중인 스킬은 부 재료로 등록할 수 없습니다."
				call Event.activate(ENUM_EVENT_ERROR)
				return false
			endif
			/*레벨부족*/
			if am1.getLevel() < LEVEL_REQUIRE or am2.getLevel() < LEVEL_REQUIRE then
				set CUSTOM_RESPOND_ERROR_PLAYER = target.owner
				set CUSTOM_RESPOND_ERROR_MESSAGE = "스킬,스킬 파편의 레벨이 부족합니다."
				call Event.activate(ENUM_EVENT_ERROR)
				return false
			endif
			/*어빌합계에 상응하는 티어의 테이블 복사*/
			set table = AbilityTable.copyTable(am1.getTier()+am2.getTier())
			/*주재료가 어빌리티일 때에만*/
			if am1.element_type == AbilityMixElement.TYPE_ABILITY then
				/*보유중인 어빌리티는 테이블에서 제외*/
				set i = 0
				loop
					exitwhen i >= CONFIG_ABILITY_SIZE
					set ab = target.getAbility(i)
					if ab > 0 then
						call table.eraseFor(ab.id)
					endif
					set i = i + 1
				endloop
			endif
			/*무작위 어빌리티 산정*/
			set rabil = table.getRandom()
			/*테이블에 든 게 없음...*/
			if rabil <= 0 then
				if am1.element_type == AbilityMixElement.TYPE_ABILITY then
					set CUSTOM_RESPOND_ERROR_PLAYER = target.owner
					set CUSTOM_RESPOND_ERROR_MESSAGE = "이미 해당 티어의 스킬을 모두 습득했습니다."
					call Event.activate(ENUM_EVENT_ERROR)
				else
					set CUSTOM_RESPOND_ERROR_PLAYER = target.owner
					set CUSTOM_RESPOND_ERROR_MESSAGE = "합성할 수 있는 무작위 스킬 레시피가 없습니다."
					call Event.activate(ENUM_EVENT_ERROR)
				endif
				set result = false
			/*든 게 있으면*/
			else
				/*재료 파괴*/
				set nlv = carculateMixLevel(am1,am2)/*파괴하기 전에 레벨 기록*/
				call carculateUpgradePoint(am1,am2)/*파괴하기 전에 업글상태 기록(전역배열에 저장)*/
				set nsignature = am1.isSignature()/*파괴하기 전에 고유능력여부 기록*/
				call am1.kill()
				call am2.kill()
				if am1.element_type == AbilityMixElement.TYPE_ABILITY then
					/*새 어빌리티 주기*/
					set na = target.addAbility(rabil)
					/*새 어빌리티 레벨 설정*/
					call Ability(na).addLevel(nlv-1)
					/*새 어빌리티 고유능력 여부*/
					set Ability(na).signature = nsignature
					/*새 어빌리티 업글상태 설정&환불*/
					set i = 0
					loop
						exitwhen i >= ENUM_ABILITY_UPGRADE_TYPE_MAX
						call Ability(na).setUpgradePoint(i,UPGRADE[i])
						call target.addUpgradePoint(i,REFUND[i])
						set i = i + 1
					endloop
					/*골드는 플레이어에게로 환수*/
					call User.addGold(target.owner,target.getUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_RED))
					call target.setUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_RED,0)
				else
					/*새 파편 주기*/
					set na = AbilityShard.create(rabil)
					call AbilityShard(na).pick(target)
					/*새 파편 레벨 설정*/
					call AbilityShard(na).addLevel(nlv-1)
					/*새 파편 업글상태 설정&환불*/
					set i = 0
					loop
						exitwhen i >= ENUM_ABILITY_UPGRADE_TYPE_MAX
						call AbilityShard(na).setUpgradePoint(i,UPGRADE[i])
						call target.addUpgradePoint(i,REFUND[i])
						set i = i + 1
					endloop
					/*골드는 플레이어에게로 환수*/
					call User.addGold(target.owner,target.getUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_RED))
					call target.setUpgradePoint(ENUM_ABILITY_UPGRADE_TYPE_RED,0)
				endif
				/*성공이펙트*/
				call AttatchedEffect.create(EFFECT_PATH2,target).setDuration(2.0)
				set result = true
			endif
			/*다 쓴 테이블 파괴*/
			if table > 0 then
				call table.destroy()
			endif
			return result
		endmethod

		/*레벨업 합성*/
		static method mixLevel takes Unit target, AbilityMixElement am1, AbilityMixElement am2 returns boolean
			local integer maxlv = Ability.getTypeMaxLevel(am1.getId())
			local integer i = 0
			local integer currentlv = am1.getLevel()
			/*이미 만렙임*/
			if am1.getLevel() >= maxlv then
				set CUSTOM_RESPOND_ERROR_PLAYER = target.owner
				set CUSTOM_RESPOND_ERROR_MESSAGE = "최대레벨에 도달한 스킬은 레벨업 합성이 불가능합니다."
				call Event.activate(ENUM_EVENT_ERROR)
				return false
			/*레벨업시키기*/
			else
				/*예상레벨이 맥스레벨 초과 시*/
				if am1.getLevel() + am2.getLevel() > maxlv then
					/*업글재화 순차적으로 더하기*/
					loop
						exitwhen currentlv >= maxlv
						set i = 0
						/*더해줄 수 있는 재화 찾기*/
						loop
							exitwhen am2.getUpgradePoint(i) >= am2.getTier() or i >= ENUM_ABILITY_UPGRADE_TYPE_MAX
							set i = i + 1
						endloop
						if i < ENUM_ABILITY_UPGRADE_TYPE_MAX then
							/*재화를 찾았으면*/
							call am1.addUpgradePoint(i,am2.getTier())
							call am2.addUpgradePoint(i,-am2.getTier())
							set currentlv = currentlv + 1
						else
							/*못찾았으면 브레이크*/
							exitwhen true
						endif
					endloop
					/*재화환급(부 재료에 남아있는거 다 털기)*/
					set i = 0
					loop
						exitwhen i >= ENUM_ABILITY_UPGRADE_TYPE_MAX
						call target.addUpgradePoint(i,am2.getUpgradePoint(i))
						set i = i + 1
					endloop
					/*레벨더하기*/
					call am1.addLevel(currentlv-am1.getLevel())
				else
					/*레벨 초과 안되면 업글포인트 다 더해주기*/
					set i = 0
					loop
						exitwhen i >= ENUM_ABILITY_UPGRADE_TYPE_MAX
						call am1.addUpgradePoint(i,am2.getUpgradePoint(i))
						set i = i + 1
					endloop
					/*레벨더하기*/
					call am1.addLevel(am2.getLevel())
				endif
				/*부재료 파괴*/
				call am2.kill()
				/*성공이펙트*/
				call AttatchedEffect.create(EFFECT_PATH1,target).setDuration(2.0)
				return true
			endif
		endmethod

		/*추출*/
		static method extract takes Ability a returns boolean
			if a.signature then
				/*고유능력은 추출불가*/
				return false
			endif
			call AbilityShard.createFromAbility(a)
			call a.kill()
			/*추출이펙트*/
			call AttatchedEffect.create("Abilities\\Spells\\Human\\DispelMagic\\DispelMagicTarget.mdl",a.owner).setDuration(2.0)
			call AttatchedEffect.create("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl",a.owner).setDuration(2.0)
			set CUSTOM_RESPOND_UI_REFRESH_PLAYER = a.owner.owner
			call Event.activate(ENUM_EVENT_ABILITY_UI_REFRESH)
			set CUSTOM_RESPOND_UI_REFRESH_PLAYER = null
			return true
		endmethod

		static method create takes integer base, integer material, integer result returns thistype
			local thistype this = COUNTER
			set .main = base
			set .main_level = LEVEL_REQUIRE
			set .sub = material
			set .sub_level = LEVEL_REQUIRE
			set .result = result
			call registerRecipe()
			call addRecommendRecipe()
			set COUNTER = COUNTER + 1
			return this
		endmethod

		static method onInit takes nothing returns nothing
			local integer i = 0 
			loop
				exitwhen i >= ENUM_ABILITY_UPGRADE_TYPE_MAX
				set REFUND[i] = 0
				set UPGRADE[i] = 0
				set i = i + 1
			endloop
		endmethod

	endstruct

	private function init takes nothing returns nothing
		//! import "GeneratedAbilityMix.j"
	endfunction

endlibrary