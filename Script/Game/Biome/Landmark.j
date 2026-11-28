library Landmark requires NPC

  globals
    private trigger P_PROPS_CALLBACK = null
    private integer P_PROPS_INSTANCE_ID = -1
  endglobals

  struct LandmarkProps extends array

    real hp
    real hp_max

    static method create takes integer instanceId returns thistype
      local thistype this = instanceId
      set .hp = 0.
      set .hp_max = 1.
      return instantceId
    endmethod

    method destroy takes nothing returns nothing
      set .hp = 0.
      set .maxhp = 0.
    endmethod

  endstruct

  struct LandmarkRebuild extends UnitActor
    
    method onComplete takes nothing returns nothing
  
    endmethod

    static method create takes Unit caster, integer targetLandmark returns thistype

    endmethod

    method onDestroy takes nothing returns nothing

    endmethod

  endstruct

  struct Landmark extends NPC

    delegate LandmarkProps props

    method onInteract takes Unit caster returns nothing
			call BJDebugMsg("랜드마크와 상호작용")
		endmethod

		static method create takes integer unitId, real x, real y returns thistype
			local thistype this = allocate(unitId,x,y,1.25)
			// set .level = 10
			return this
		endmethod

    method onDestroy takes nothing returns nothing
      call .props.destroy()
    endmethod

    /*PROPS 변경 시 콜백*/
    static method propsCallback takes nothing returns nothing
      local thistype this = P_PROPS_INSTANCE_ID
      if P_PROPS_INSTANCE_ID <= 0 then
        return
      endif
    endmethod

    
    static method init takes nothing returns nothing
      /*PROPS 변경 시 콜백*/
      set P_PROPS_CALLBACK = CreateTrigger()
      call TriggerAddCondition(P_PROPS_CALLBACK,function thistype.propsCallback)
    endmethod 

  endstruct

endlibrary