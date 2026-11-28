//! import "Waygate.j"
//! import "Landmark.j"
//! import "MonsterCamp.j"
//! import "MonsterReward.j"

library Biome requires MonsterCamp

  globals
    private hashtable P_TABLE = InitHashtable()
  endglobals

  struct Biome

    integer biome_id = -1
    thistype next_biome = 0 /*특정조건 만족 시 개방할 다음 바이옴*/
    boolean is_awake = false
    rect camp_rect = null
    rect boss_rect = null

    MonsterCamp camp = 0
    Boss boss = 0
    Landmark landmark = 0

    method createLandmark takes nothing returns Landmark
      if .camp_rect == null then
        return 0
      endif
      set .landmark = Landmark.create('NS00',GetRectCenterX(.camp_rect),GetRectCenterY(.camp_rect))
      return .landmark
    endmethod

    method createMonsterCamp takes nothing returns MonsterCamp
      if .camp_rect == null then
        return 0
      endif
      set .camp = MonsterCamp.create(.biome_id, .camp_rect)
      return .camp
    endmethod

    method createWaygate takes real x, real y returns Waygate
      local Waygate newGate = Waygate.create(x,y)
      return newGate
    endmethod

    method createWarpDestination takes real x, real y returns WarpDestination
      local WarpDestination newDest = WarpDestination.create(x,y)
      return newDest
    endmethod

    /*최초에는 휴면상태임(캠프, 재건 건축물, 보스 등이 생성되지 않은 상태)*/
    /*이전 바이옴에서 특정 조건을 달성할 때 해당 메서드를 이용해서 활성화하면될듯*/
    method awake takes nothing returns nothing
      set .is_awake = true
      /*캠프활성화*/
      if .camp_rect != null then
        /*워프도착지 활성화*/
        call createWarpDestination(GetRectCenterX(.camp_rect),GetRectMinY(.camp_rect)+1024)
        /*몬스터캠프생성*/
        call createMonsterCamp()
      endif
      /*보스존활성화*/
      if .boss_rect != null then
        /*워프도착지 활성화*/
        call createWarpDestination(GetRectCenterX(.boss_rect),GetRectMinY(.boss_rect)+1024)
        /*TODO 보스생성하기*/
      endif
    endmethod

    method initDefault takes nothing returns nothing
      /*차원문은 버그 등으로 잘못 들어갔을 때 대비해서 미리 깔아놔야합니다.*/
      if .camp_rect != null then
        call createWaygate(GetRectMaxX(.camp_rect)-1024,GetRectMinY(.camp_rect)+1024)
      endif
      if .boss_rect != null then
        call createWaygate(GetRectMaxX(.boss_rect)-1024,GetRectMinY(.boss_rect)+1024)
      endif
    endmethod

    static method create takes integer biomeId, rect campRect, rect bossRect returns thistype
      local thistype this = allocate()
      set .biome_id = biomeId
      set .camp_rect = campRect
      set .boss_rect = bossRect
      /**/
      call initDefault()
      /**/
      return this
    endmethod

    static method init takes nothing returns nothing
      local thistype newBiome = 0
      /*의존성*/
      call Waygate.init()
      call MonsterCamp.init()
      call MonsterReward.init()
      call Landmark.init()
      /*초기바이옴*/
      set newBiome = Biome.create(ENUM_BIOME_FOREST,UDG_RECT_RECT[ENUM_RECT_12],UDG_RECT_RECT[ENUM_RECT_7])
			call newBiome.awake()
      set newBiome = Biome.create(ENUM_BIOME_STARTER,UDG_RECT_RECT[ENUM_RECT_11],null)
			call newBiome.awake()
    endmethod

  endstruct

endlibrary