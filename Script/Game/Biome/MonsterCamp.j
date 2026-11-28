library MonsterCamp initializer init requires Monster

  globals
    private hashtable P_MONSTER_SPAWN_TABLE = InitHashtable()/*랜덤몬스터 리스트 초기화할 때 필요한 테이블*/
    private string array P_MONSTER_SPAWN_FX

    private constant integer P_MONSTER_CAMP_RADIUS_MAX = 1024+128
    private constant integer P_MONSTER_CAMP_RADIUS_MIN = 512
    private constant integer P_MONSTER_COUNT_MAX = 10 /*필드상에 존재할 수 있는 몬스터 개체수*/
    private constant integer P_MONSTER_STACK_MAX = 3 /*몬스터 예비 스택 수*/
    // private constant real P_MONSTER_SPAWN_TIME = 20. /*몬스터 재생성 시간*/
    // private constant real P_MONSTER_SPAWN_TIME_FAST = 5. /*예비 스택 수가 있을 때 몬스터 재생성 시간*/
    private constant real P_MONSTER_SPAWN_TIME = 2. /*몬스터 재생성 시간*/
    private constant real P_MONSTER_SPAWN_TIME_FAST = 1. /*예비 스택 수가 있을 때 몬스터 재생성 시간*/
    private constant integer P_SPAWN_SECTOR_DIVITION = 8
  endglobals

  struct MonsterCamp

    static real S_RANDOM_X = 0.
    static real S_RANDOM_Y = 0.

    integer biome_id = -1
    rect camp_rect = null
    delegate Array monster_id_list = 0
    timer spawn_timer = null
    boolean spawn_timer_running = false
    Array monster_list
    integer monster_count_max = P_MONSTER_COUNT_MAX
    integer monster_stack = 0
    integer monster_stack_max = P_MONSTER_STACK_MAX
    integer sector_current = 0

    /*라디안값 넣어야함 주의*/
    method refreshRandomPosition takes real minAngle, real maxAngle returns nothing
      local real centerX = GetRectCenterX(.camp_rect)
      local real centerY = GetRectCenterY(.camp_rect)
      local real rMin = I2R(P_MONSTER_CAMP_RADIUS_MIN)
      local real rMax = I2R(P_MONSTER_CAMP_RADIUS_MAX)
      local real u = GetRandomReal(0., 1.)
      local real radius = SquareRoot(rMin * rMin + u * (rMax * rMax - rMin * rMin))
      local real angle = GetRandomReal(minAngle, maxAngle)
      set thistype.S_RANDOM_X = centerX + radius * Cos(angle)
      set thistype.S_RANDOM_Y = centerY + radius * Sin(angle)
    endmethod

    method getRandomX takes nothing returns real
      return S_RANDOM_X
    endmethod

    method getRandomY takes nothing returns real
      return S_RANDOM_Y
    endmethod

    /*디버그용*/
    method displayCounts takes nothing returns nothing
      // call BJDebugMsg("필드 위 개체수: "+I2S(.monster_list.size)+" / 예비 개체수: "+I2S(.monster_stack))
    endmethod

    /*몬스터를 생성하는 함수*/
    method spawn takes nothing returns nothing
      local real rx = 0.
      local real ry = 0.
      local real sectorStep = (2. * bj_PI) / I2R(P_SPAWN_SECTOR_DIVITION)
      local real minAngle = I2R(.sector_current) * sectorStep
      local real maxAngle = I2R(.sector_current + 1) * sectorStep
      local Monster newMon = 0
      if .monster_id_list.size <= 0 then
        call BJDebugMsg("몬스터 스폰 테이블 정보가 없습니다")
        return
      endif
      /*랜덤도넛좌표설정*/
      call refreshRandomPosition(minAngle, maxAngle)
      set rx = getRandomX()
      set ry = getRandomY()
      set .sector_current = .sector_current + 1
      if .sector_current >= P_SPAWN_SECTOR_DIVITION then
        set .sector_current = 0
      endif
      /*스폰시킬 무작위 몬스터 id 결정*/
      call shuffle()
      /*몬스터 생성*/
      set newMon = Monster.create(this,.monster_id_list.getValue(0),rx,ry,/*
        */Math.anglePoints(rx,ry,GetRectCenterX(.camp_rect),GetRectCenterY(.camp_rect))+GetRandomReal(-30.0,30)/*
      */)
      set newMon.camp_rect = .camp_rect
      /*개체수 증가*/
      call .monster_list.add(newMon)
      /*리젠이펙트*/
      call Effect.create(P_MONSTER_SPAWN_FX[.biome_id],rx,ry,0,270.0).kill()
      // call BJDebugMsg("====스폰 작동")
      call displayCounts()
    endmethod
    
    method addStack takes nothing returns nothing
      set .monster_stack = .monster_stack + 1
      // call BJDebugMsg("====스택 추가")
      call displayCounts()
    endmethod

    /*채우기 타이머 정지*/
    method stopSpawnTimer takes nothing returns nothing
      // call BJDebugMsg("====꽉차서 타이머 정지")
      set .spawn_timer_running = false
      call Timer.pause(.spawn_timer)
    endmethod

    static method spawnTimerCallback takes nothing returns nothing
      local thistype this = Timer.getData(GetExpiredTimer())
      if .monster_list.size < .monster_count_max then
        call spawn()
      elseif .monster_stack < .monster_stack_max then
        call addStack()
      endif
      if .monster_list.size >= .monster_count_max and .monster_stack >= .monster_stack_max then
        call stopSpawnTimer()
      endif
    endmethod

    /*채우기 타이머 스타트*/
    method runSpawnTimer takes nothing returns nothing
      set .spawn_timer_running = true
      call Timer.start(.spawn_timer,P_MONSTER_SPAWN_TIME,true,function thistype.spawnTimerCallback)
    endmethod

    static method fastCreationCallback takes nothing returns nothing
      local timer timerHandle = GetExpiredTimer()
      local thistype this = Timer.getData(timerHandle)
      // call BJDebugMsg("빠른리젠 작동")
      call spawn()
      call Timer.release(timerHandle)
      set timerHandle = null
    endmethod

    /*빠른리젠 타이머 생성*/
    method runFastCreation takes nothing returns nothing
      /*1회용 타이머 생성, 콜백함수에서 반드시 release해줘야함.*/
      local timer fTimer = Timer.new(this)
      set .monster_stack = .monster_stack - 1
      call Timer.start(fTimer,P_MONSTER_SPAWN_TIME_FAST,false,function thistype.fastCreationCallback)
      set fTimer = null
    endmethod

    /*사망한 유닛을 인자로 받아오긴 하는데 뭐 안할수도*/
    method monsterDeath takes Monster target returns nothing
      // call BJDebugMsg("몬스터가주것슴다 -ㅁ-: "+target.name)
      call .monster_list.removeFor(target)
      if not .spawn_timer_running then
        call runSpawnTimer()
      endif
      if .monster_stack > 0 then
        call runFastCreation()
      endif
    endmethod

    static method create takes integer biomeId, rect targetRect returns thistype
      local thistype this = allocate()
      local integer i = 0
      /*바이옴id*/
      set .biome_id = biomeId
      /*스폰타이머*/
      set .spawn_timer = Timer.new(this)
      /*스폰할 몬스터 id들*/
      set .monster_id_list = Array.create()
      loop
        /*랜덤몬스터 정보 가져오기*/
        exitwhen not HaveSavedInteger(P_MONSTER_SPAWN_TABLE,biomeId,i)
        call .monster_id_list.add(LoadInteger(P_MONSTER_SPAWN_TABLE,biomeId,i))
        set i = i + 1
      endloop
      /*스폰된 몬스터 그룹*/
      set .monster_list = Array.create()
      /*구역참조*/
      set .camp_rect = targetRect
      /*처음에는 스폰타이머 작동*/
      call runSpawnTimer()
      return this
    endmethod

    method onDestroy takes nothing returns nothing
      /*타이머파괴*/
      call Timer.release(.spawn_timer)
      /*리스트 제거*/
      call .monster_id_list.destroy()
      call .monster_list.destroy()
      /*구역참조해제*/
      set .camp_rect = null
    endmethod

    static method deathCallback takes nothing returns nothing
      local Monster targetUnit = EVT_DEATH_UNIT
      local thistype this = 0
      if UnitClass(targetUnit).getClass(ENUM_UNIT_CLASS_MONSTER) <= 0 then
        return
      endif
      set this = thistype(targetUnit.camp_id)
      call monsterDeath(targetUnit)
    endmethod

    static method init takes nothing returns nothing
      local trigger t = CreateTrigger()
      call Event.register(t,ENUM_EVENT_DEATH)
      call TriggerAddCondition(t,function thistype.deathCallback)
      set t = null
    endmethod

  endstruct

  /*일단하드코딩으로*/
  private function init takes nothing returns nothing
    /*시작마을*/
    call SaveInteger(P_MONSTER_SPAWN_TABLE,ENUM_BIOME_STARTER,0,'M000')
    call SaveInteger(P_MONSTER_SPAWN_TABLE,ENUM_BIOME_STARTER,1,'M000')
    call SaveInteger(P_MONSTER_SPAWN_TABLE,ENUM_BIOME_STARTER,2,'M000')
    /*숲*/
    call SaveInteger(P_MONSTER_SPAWN_TABLE,ENUM_BIOME_FOREST,0,'M000')
    call SaveInteger(P_MONSTER_SPAWN_TABLE,ENUM_BIOME_FOREST,1,'M001')
    call SaveInteger(P_MONSTER_SPAWN_TABLE,ENUM_BIOME_FOREST,2,'M002')
    /*산지*/
    call SaveInteger(P_MONSTER_SPAWN_TABLE,ENUM_BIOME_MOUNTAIN,0,'M000')
    call SaveInteger(P_MONSTER_SPAWN_TABLE,ENUM_BIOME_MOUNTAIN,1,'M000')
    call SaveInteger(P_MONSTER_SPAWN_TABLE,ENUM_BIOME_MOUNTAIN,2,'M000')
    /*화산*/
    call SaveInteger(P_MONSTER_SPAWN_TABLE,ENUM_BIOME_VOLCANIC,0,'M000')
    call SaveInteger(P_MONSTER_SPAWN_TABLE,ENUM_BIOME_VOLCANIC,1,'M000')
    call SaveInteger(P_MONSTER_SPAWN_TABLE,ENUM_BIOME_VOLCANIC,2,'M000')
    /*리젠이펙트*/
    set P_MONSTER_SPAWN_FX[ENUM_BIOME_STARTER] = "Objects/Spawnmodels/NightElf/EntBirthTarget/EntBirthTarget.mdl"
    set P_MONSTER_SPAWN_FX[ENUM_BIOME_FOREST] = "Objects/Spawnmodels/NightElf/EntBirthTarget/EntBirthTarget.mdl"
    set P_MONSTER_SPAWN_FX[ENUM_BIOME_MOUNTAIN] = "Objects/Spawnmodels/NightElf/EntBirthTarget/EntBirthTarget.mdl"
    set P_MONSTER_SPAWN_FX[ENUM_BIOME_VOLCANIC] = "Objects/Spawnmodels/NightElf/EntBirthTarget/EntBirthTarget.mdl"
  endfunction

endlibrary