library MonsterReward requires Monster

  globals
    private constant string P_FX_PATH_EXP = "Units/Human/HeroBloodElf/BloodElfBall.mdl"
    private constant string P_FX_PATH_EXP_LUCKY = "Abilities/Weapons/FaerieDragonMissile/FaerieDragonMissile.mdl"
  endglobals

  struct MonsterRewardMissile extends Missile

    Unit buffredTarget = 0
    AttatchedEffect afx = 0

    method onBound takes nothing returns nothing
      local real dist = 0.
      call setTarget(.buffredTarget)
      set dist = Math.distancePoints(.x,.y,.target.x,.target.y)
      /*바운스관련 속성 제거*/
      set .z_velo = 0.
      set .gravity = 0.
      /*커브*/
			set .curve = CurveBezier2.create(.x,.y,0.,.target.x,.target.y,0.)
			set .curve.overtime = GetRandomReal(0.5,0.75)/*일단하드코딩*/
			call CurveBezier2(.curve).setX(0,.x)
			call CurveBezier2(.curve).setY(0,.y)
			call CurveBezier2(.curve).setZ(0,0.)
			call CurveBezier2(.curve).setX(1,.target.x)
			call CurveBezier2(.curve).setY(1,.target.y)
			call CurveBezier2(.curve).setZ(1,0.)
			call CurveBezier2(.curve).setProjectedControlPoint(0,0.5*dist,300+GetRandomReal(0.25,0.5)*dist,GetRandomReal(30,150))
    endmethod

		static method create takes Unit owner, string fxPath, real x, real y, real z, Unit target returns thistype
			local thistype this = allocate(owner,fxPath,x,y,z,GetRandomReal(0.0,360.0))
      /*튕기기 파라미터*/
      set .velo = GetRandomReal(50,150)
      set .z_velo = 1500.+GetRandomReal(-100.0,100.0)
      set .gravity = .z_velo * (3.5+GetRandomReal(-0.25,0.25))
      /*튕기는 시점에 설정해줄 타겟*/
      set .buffredTarget = target
			return this
		endmethod

		method onDestroy takes nothing returns nothing
      if .afx > 0 then
        call .afx.kill()
      endif
      set .afx = 0
		endmethod

	endstruct

  /*경험치보상*/
  struct MonsterRewardExpMissile extends MonsterRewardMissile

    boolean isLucky = false

    stub method executeTarget takes Unit target returns nothing
      local real expValue = 5.+I2R(.owner.level)
      if .isLucky then
        set InstantText.SIZE = 8
        call InstantText.createForPlayer(target.x+GetRandomReal(-32,32),target.y+GetRandomReal(-32,32),target.z,UDG_STAT_COLOR[ENUM_STAT_LUCK]+"x2|r",target.owner)
        call target.addExp(expValue*2)
      else
        call target.addExp(expValue)
      endif
    endmethod

    static method create takes Unit owner, real x, real y, real z, Unit target returns thistype
      local thistype this = allocate(owner, P_FX_PATH_EXP, x, y, z, target)
      set .isLucky = target.luckyTest(target.getCalculatedStatValue(ENUM_STAT_LUCK),0.10,100)
      if .isLucky then
        set .afx = AttatchedEffect.create(P_FX_PATH_EXP_LUCKY,this)
      endif
      return this
    endmethod

  endstruct

  struct MonsterReward extends array

    /*특정 몬스터가 사망함*/
    static method deathCallback takes nothing returns nothing
      local Unit deadUnit = EVT_DEATH_UNIT
      local Unit killer = EVT_DEATH_KILLER
      if (killer <= 0) or (deadUnit <=0) or (deadUnit.class != UDG_UNIT_CLASS_NAME[ENUM_UNIT_CLASS_MONSTER]) then
        return
      endif
      call MonsterRewardExpMissile.create(deadUnit,deadUnit.x,deadUnit.y,deadUnit.z,killer)
      call MonsterRewardExpMissile.create(deadUnit,deadUnit.x,deadUnit.y,deadUnit.z,killer)
      call MonsterRewardExpMissile.create(deadUnit,deadUnit.x,deadUnit.y,deadUnit.z,killer)
      call MonsterRewardExpMissile.create(deadUnit,deadUnit.x,deadUnit.y,deadUnit.z,killer)
      call MonsterRewardExpMissile.create(deadUnit,deadUnit.x,deadUnit.y,deadUnit.z,killer)
    endmethod

    static method init takes nothing returns nothing
      local trigger t = null
      /*임의의 유닛이 사망함*/
      set t = CreateTrigger()
      call Event.register(t,ENUM_EVENT_DEATH)
      call TriggerAddCondition(t,function thistype.deathCallback)
      /**/
      set t = null
    endmethod

  endstruct

endlibrary