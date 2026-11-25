library PowerupManager initializer init requires Object, Ability, User, Table 

  globals
    private integer array P_RANDOM_STAT
    private integer P_RANDOM_STAT_SIZE = 0
  endglobals

  /*최대로 동시에 플레이어 수*출력할 파워업아이템개수 만큼 존재할 수 있다.*/
  struct PowerupItem extends array
    private integer type
    private integer value

    method setEmpty takes nothing returns nothing
      set .type = -1
      set .value = -1
    endmethod

    method setType takes integer newType returns nothing
      set .type = newType
    endmethod

    method setValue takes integer newValue returns nothing
      set .value = newValue
    endmethod

    method getType takes nothing returns integer
      return .type
    endmethod

    method getValue takes nothing returns integer
      return .value
    endmethod

    method isEmpty takes nothing returns boolean
      return .type < 0
    endmethod

    /*유닛에게 파워업 적용하기*/
    method apply takes Unit target returns boolean
      local integer ability_create_result = 0
      if isEmpty() or target <= 0 then
        return false
      endif
      /*TODO 파워업아이템 유형에 따라 실행*/
      if .type == ENUM_POWERUP_ITEM_TYPE_ABILITY then
        /*TODO 어빌리티 배우기*/
        set ability_create_result = Ability.addUnitAbility(target,.value)
        if ability_create_result < 0 then
          /*공간없어서실패*/
          return false
        endif
      elseif .type == ENUM_POWERUP_ITEM_TYPE_STAT then
        /*TODO 스탯증가*/
        call target.plusBaseStatValue(.value,CONFIG_POWERUP_STAT_AMOUNT*CONSTANT_STAT_NORMAL_VALUE[.value])
      else
      endif
      return true
    endmethod

  endstruct

  //! runtextmacro demonicAllocateSimple("Powerup")

  /*매우 많이 존재할 수 있다.(extends array 사용 x)*/
  struct Powerup
    private static trigger P_CALLBACK
    
    integer type = -1
    integer value = 0 /*캐릭터 몇 레벨 달성 증강인지, 채집된 채집물 id, 토벌된 보스 id 등..*/

    static method create takes integer ptype, integer newVal returns thistype
      local thistype this = Powerup_demonicAllocate()
      set .type = ptype
      set .value = newVal
      return this
    endmethod

    static method onInit takes nothing returns nothing
      set P_CALLBACK = CreateTrigger()
    endmethod

  endstruct

  /*플레이어 수 만큼 존재할 수 있다.*/
  struct PowerupManager extends array

    player owner
    delegate Array powerup_list
    Array random_stat_list

    method getPowerupItem takes integer index returns PowerupItem
      return PowerupItem(CONFIG_POWERUP_ITEM_MAX*GetPlayerId(owner)+index)
    endmethod

    method extract takes nothing returns nothing
      local Powerup pu = Powerup(getValue(0))
      local integer i = 0
      if pu > 0 then
        call .random_stat_list.shuffle()
        /*TODO 파워업아이템들 조정하기*/
        loop
          exitwhen i >= CONFIG_POWERUP_ITEM_MAX
          // call getPowerupItem(i).setType(ENUM_POWERUP_ITEM_TYPE_ABILITY)
          // call getPowerupItem(i).setValue('1000')
          call getPowerupItem(i).setType(ENUM_POWERUP_ITEM_TYPE_STAT)
          call getPowerupItem(i).setValue(.random_stat_list.getValue(i))
          set i = i + 1
        endloop
      endif
    endmethod

    /*파워업 추가하기*/
    method addPowerup takes Powerup pw returns nothing
      call add(pw)
      /*없었다가 생기면 바로 추출*/
      if .size == 1 then
        call extract()
      endif
      set EVT_POWERUP_ADD_PLAYER = .owner
      set EVT_POWERUP_ADD_UNIT = User.getFocusUnit(.owner)
      call Event.activate(ENUM_EVENT_POWERUP_ADD)
    endmethod

    /*첫 칸의 파워업 제거하고 땡겨오기*/
    method removePowerup takes nothing returns nothing
      local Powerup pu = Powerup(getValue(0))
      if .size > 0 and pu > 0 then
        call pu.destroy()
        call remove(0)
        set pu = Powerup(getValue(0))
        if pu > 0 then
          call extract()
        endif
      endif
    endmethod

    method applyPowerupItem takes Unit target, integer slot returns nothing
      local boolean result = false
      local PowerupItem pitem = getPowerupItem(slot)
      local integer i = 0
      /*해당 슬롯에 파워업아이템이 없음*/
      if pitem.isEmpty() then
        return
      endif
      /*선택한 파워업아이템을 적용*/
      set result = pitem.apply(target)
      if not result then
        /*TODO SEND ERROR*/
        return
      endif
      /*파워업아이템 슬롯 비우기*/
      loop 
        exitwhen i >= CONFIG_POWERUP_ITEM_MAX
        call getPowerupItem(i).setEmpty()
        set i = i + 1
      endloop
      /*현재파워업을 제거*/
      call removePowerup()
      /*적용 성공 시*/
      if result then
        set EVT_POWERUP_PLAYER = .owner
        set EVT_POWERUP_UNIT = target
        call Event.activate(ENUM_EVENT_POWERUP)
        if GetLocalPlayer() == .owner then
          call PlaySoundBJ(gg_snd_BigButtonClick)
        endif
      endif
      /*UIREFRESH*/
      set EVT_UI_REFRESH_ABILITY = -1
      set EVT_UI_REFRESH_PLAYER = .owner
      set EVT_UI_REFRESH_SLOT = -1
      call Event.activate(ENUM_EVENT_ABILITY_UI_REFRESH)
    endmethod

    method isEmpty takes nothing returns boolean
      return .size <= 0
    endmethod

    static method create takes player owner returns thistype
      local integer i = 0
      local thistype this = GetPlayerId(owner)
      set .owner = owner
      /*파워업 배열 초기화*/
      set .powerup_list = Array.create()
      /*랜덤스탯 배열 초기화(스탯증강 능력치 선택할 때 필요함)*/
      set .random_stat_list = Array.create()
      loop
        exitwhen i >= P_RANDOM_STAT_SIZE
        call .random_stat_list.add(P_RANDOM_STAT[i])
        set i = i + 1
      endloop
      return this
    endmethod

    /*레벨업 콜백*/
    static method levelCallback takes nothing returns nothing
      local Unit u = Unit(EVT_LEVEL_UNIT)
      local integer diff = EVT_LEVEL_LEVEL
      local thistype this = 0
      local integer i = 0
      if GetPlayerId(u.owner) < CONFIG_PLAYER_MAX and diff > 0 then
        set this = GetPlayerId(u.owner)
        /*상승한 레벨만큼 파워업 추가*/
        loop
          exitwhen i >= diff
          call addPowerup(Powerup.create(ENUM_POWERUP_TYPE_LEVEL,u.level-diff+i+1))
          set i = i + 1
        endloop
      endif
    endmethod

    private static method onInit takes nothing returns nothing
      local trigger t = CreateTrigger()
      /*유닛 레벨업 시*/
      call Event.register(t,ENUM_EVENT_LEVEL)
      call TriggerAddCondition(t,function thistype.levelCallback)
      set t = null
    endmethod

  endstruct

  /*랜덤스탯으로 줄거 초기화*/
  private function init takes nothing returns nothing
    set P_RANDOM_STAT_SIZE = 0
    /**/
    set P_RANDOM_STAT[P_RANDOM_STAT_SIZE] = ENUM_STAT_MAXMP
    set P_RANDOM_STAT_SIZE = P_RANDOM_STAT_SIZE + 1
    set P_RANDOM_STAT[P_RANDOM_STAT_SIZE] = ENUM_STAT_HPREGEN
    set P_RANDOM_STAT_SIZE = P_RANDOM_STAT_SIZE + 1
    set P_RANDOM_STAT[P_RANDOM_STAT_SIZE] = ENUM_STAT_MAXMP
    set P_RANDOM_STAT_SIZE = P_RANDOM_STAT_SIZE + 1
    set P_RANDOM_STAT[P_RANDOM_STAT_SIZE] = ENUM_STAT_MPREGEN
    set P_RANDOM_STAT_SIZE = P_RANDOM_STAT_SIZE + 1
    set P_RANDOM_STAT[P_RANDOM_STAT_SIZE] = ENUM_STAT_ATTACK
    set P_RANDOM_STAT_SIZE = P_RANDOM_STAT_SIZE + 1
    set P_RANDOM_STAT[P_RANDOM_STAT_SIZE] = ENUM_STAT_DEFENSE
    set P_RANDOM_STAT_SIZE = P_RANDOM_STAT_SIZE + 1
    set P_RANDOM_STAT[P_RANDOM_STAT_SIZE] = ENUM_STAT_ARMOR_PENET
    set P_RANDOM_STAT_SIZE = P_RANDOM_STAT_SIZE + 1
    set P_RANDOM_STAT[P_RANDOM_STAT_SIZE] = ENUM_STAT_MAGICPOWER
    set P_RANDOM_STAT_SIZE = P_RANDOM_STAT_SIZE + 1
    set P_RANDOM_STAT[P_RANDOM_STAT_SIZE] = ENUM_STAT_RESISTANCE
    set P_RANDOM_STAT_SIZE = P_RANDOM_STAT_SIZE + 1
    set P_RANDOM_STAT[P_RANDOM_STAT_SIZE] = ENUM_STAT_MAGIC_PENET
    set P_RANDOM_STAT_SIZE = P_RANDOM_STAT_SIZE + 1
    set P_RANDOM_STAT[P_RANDOM_STAT_SIZE] = ENUM_STAT_ACCURACY
    set P_RANDOM_STAT_SIZE = P_RANDOM_STAT_SIZE + 1
    set P_RANDOM_STAT[P_RANDOM_STAT_SIZE] = ENUM_STAT_EVASION
    set P_RANDOM_STAT_SIZE = P_RANDOM_STAT_SIZE + 1
    set P_RANDOM_STAT[P_RANDOM_STAT_SIZE] = ENUM_STAT_SPELL_BOOST
    set P_RANDOM_STAT_SIZE = P_RANDOM_STAT_SIZE + 1
    set P_RANDOM_STAT[P_RANDOM_STAT_SIZE] = ENUM_STAT_LUCK
    set P_RANDOM_STAT_SIZE = P_RANDOM_STAT_SIZE + 1
    set P_RANDOM_STAT[P_RANDOM_STAT_SIZE] = ENUM_STAT_RODONG
    set P_RANDOM_STAT_SIZE = P_RANDOM_STAT_SIZE + 1
    set P_RANDOM_STAT[P_RANDOM_STAT_SIZE] = ENUM_STAT_INSIGHT
    set P_RANDOM_STAT_SIZE = P_RANDOM_STAT_SIZE + 1
    set P_RANDOM_STAT[P_RANDOM_STAT_SIZE] = ENUM_STAT_LOVE
    set P_RANDOM_STAT_SIZE = P_RANDOM_STAT_SIZE + 1
    set P_RANDOM_STAT[P_RANDOM_STAT_SIZE] = ENUM_STAT_GREED
    set P_RANDOM_STAT_SIZE = P_RANDOM_STAT_SIZE + 1
  endfunction

endlibrary