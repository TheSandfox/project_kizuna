library Undead requires Unit

	globals
		public trigger CREATE_REQUEST = CreateTrigger()
		public real CREATE_X = 0.
		public real CREATE_Y = 0.
		public integer CREATE_ID = 0
		public integer CREATE_POSITION = 0
		public integer LAST_CREATED = 0

		trigger UNREGISTER_GROUP = null
		public group GROUP = null
		private boolean HELPCALL_PREVENT_LOOP = false
	endglobals

	struct Undead extends Unit

		static constant real AI_TICK = 1.
		static constant real AI_TICK_RANDOM = 0.25
		static trigger DAMAGE_TRIGGER = null
		static integer COUNTER = 0

		timer ai_timer = null

		Unit target = 0
		boolean target_is_different = true
		integer position = 0
		boolean running = false
		real acquire_range = 600.

		method timerBreak takes nothing returns nothing
			set .target = 0
			call Timer.pause(.ai_timer)
			set .running = false
		endmethod

		/*공격할 수 있는 적이 아무도 없을 때 본진돌격*/
		/*본진돌격 안하면 해당함수 실행하지 말 것*/
		method goToSpawnLocation takes nothing returns nothing
			call issuePointOrder("attack",GetRectCenterX(gg_rct_TreeOfLife),GetRectCenterY(gg_rct_TreeOfLife))
			call timerBreak()
		endmethod

		/*중심원 바깥에 있으면서 자기 포지션의 수호자가 살아있는지 체크*/
		/*수호자 무시 시 항상 false*/
		stub method isGuardianAlive takes nothing returns boolean
			return not Guardians.GUARDIAN[.position].isUnitType(UNIT_TYPE_DEAD) and /*
			*/Math.distancePoints(.x,.y,GetRectCenterX(gg_rct_Spawn),GetRectCenterY(gg_rct_Spawn)) > 768.
		endmethod

		method unitCondition takes Unit u returns boolean
			if not u.isEnemy(.owner) then
				/*아군이면 거름*/
				return false
			elseif not u.inRange(.x,.y,.acquire_range) then
				/*사거리 밖이면 거름*/
				return false
			elseif u.isUnitType(UNIT_TYPE_DEAD) then
				/*시체는 거름*/
				return false
			elseif not u.isVisible(.owner) then
				/*안보이면 거름*/
				return false
			elseif GetUnitAbilityLevel(u.origin_unit,'Avul') > 0 then
				/*무적이면 거름*/
				return false
			endif
			return true
		endmethod

		/*영웅을 무시하고 싶으면 항상 0을 리턴하게 할 것*/
		stub method getNearestHero takes nothing returns Unit
			local integer i = 0
			local unit g = null
			local Unit r = 0
			local real dist = 0.
			loop
				set g = BlzGroupUnitAt(UnitPrototype_GROUP,i)
				exitwhen g == null
				if unitCondition(Unit.get(g)) then
					if i == 0 or r == 0 then
						set r = Unit.get(g)
						set dist = Math.distancePoints(.x,.y,GetUnitX(g),GetUnitY(g))
					elseif Math.distancePoints(.x,.y,GetUnitX(g),GetUnitY(g)) < dist then
						set r = Unit.get(g)
						set dist = Math.distancePoints(.x,.y,GetUnitX(g),GetUnitY(g))
					endif
				endif
				set i = i + 1
			endloop
			set g = null
			return r
		endmethod

		/*수호자를 무시하고 싶으면 항상 0을 리턴하게 할 것*/
		stub method getNearestGuardian takes nothing returns Unit
			local integer i = 0
			local Unit g = 0
			local Unit r = 0
			local real dist = 0.
			loop
				exitwhen i >= 4
				set g = Guardians.GUARDIAN[i]
				if unitCondition(g) then
					if i == 0 or r == 0 then
						set r = g
						set dist = Math.distancePoints(.x,.y,g.x,g.y)
					elseif Math.distancePoints(.x,.y,g.x,g.y) < dist then
						set r = g
						set dist = Math.distancePoints(.x,.y,g.x,g.y)
					endif
				endif
				set i = i + 1
			endloop
			return r
		endmethod

		method getNearestEnemy takes nothing returns Unit
			local Unit u1 = getNearestHero()
			local Unit u2 = getNearestGuardian()
			if u1 > 0 and u2 > 0 then
				if Math.distancePoints(.x,.y,u1.x,u1.y) >= Math.distancePoints(.x,.y,u2.x,u2.y) then
					return u2
				else
					return u1
				endif
			elseif u1 > 0 then
				return u1
			elseif u2 > 0 then
				return u2
			else
				return 0
			endif
		endmethod

		stub method onSetTarget takes nothing returns nothing
			if .target_is_different then
				call issueTargetOrder("attack",.target.origin_unit)
			endif
		endmethod

		/*생명의 나무로 돌격 안하는 언데드는 이 함수의 내용을 재정의할 것*/
		stub method onFreeTarget takes nothing returns nothing
			call goToSpawnLocation()
		endmethod

		method setTarget takes Unit u returns nothing
			set .target_is_different = u != .target
			set .target = u
			if .target > 0 then
				call onSetTarget()
			else
				call onFreeTarget()
			endif
		endmethod

		stub method refreshTarget takes nothing returns nothing
			local Unit u = 0
			/*근처에 살아있는 수호자가 없으면*/
			set u = getNearestGuardian()
			if u == 0 then
				/*근처에 살아있는 플레이어가 없으면*/
				set u = getNearestHero()
				if u == 0 then
					/*자기 포지션에 살아있는 가디언이 있으면*/
					if isGuardianAlive() then
						call setTarget(Guardians.GUARDIAN[.position])
					/*자기 포지션에 살아있는 가디언이 없으면*/
					else
						/*본진으로 돌격*/
						call setTarget(0)
					endif
				/*근처에 살아있는 플레이어가 있으면*/
				else
					call setTarget(u)
				endif
			/*근처에 살아있는 수호자가 있으면*/
			else
				call setTarget(u)
			endif
		endmethod

		method getTarget takes nothing returns Unit
			local Unit u = 0
			if .target != 0 then
				if not unitCondition(.target) then
					call refreshTarget()
				elseif .target.class != "Guardian" then
					set u = getNearestGuardian()
					if u > 0 then
						call setTarget(u)
					endif
				endif
			else
				call refreshTarget()
			endif
			return .target
		endmethod

		stub method periodicAction takes nothing returns nothing
			local Ability a = 0
			local integer i = 0
			local integer j = GetRandomInt(0,CONFIG_ABILITY_SIZE-1)
			local integer k = 0
			local integer reverse = GetRandomInt(0,1) * 2 - 1 
			if getTarget() > 0 then
				loop
					exitwhen i >= CONFIG_ABILITY_SIZE
					set k = j + i*reverse
					if k < 0 then
						loop
							exitwhen k >= 0
							set k = k + CONFIG_ABILITY_SIZE
						endloop
					elseif k >= CONFIG_ABILITY_SIZE then
						loop
							exitwhen k < CONFIG_ABILITY_SIZE
							set k = k - CONFIG_ABILITY_SIZE
						endloop
					endif
					set a = getAbility(k)
					if a > 0 then
						set a.command_target = .target.origin_unit
						if a.executeAI() then
							return
						endif
					endif	
					set i = i + 1
				endloop
			endif
		endmethod

		private static method timerAction takes nothing returns nothing
			local thistype this = Timer.getData(GetExpiredTimer())
			call Timer.start(.ai_timer,AI_TICK+GetRandomReal(-AI_TICK_RANDOM,AI_TICK_RANDOM),false,function thistype.timerAction)
			call periodicAction()
		endmethod

		stub method onDamaged takes nothing returns nothing

		endmethod

		method encount takes nothing returns nothing
			if not .running then
				call refreshTarget()
				set .running = true
				call Timer.start(.ai_timer,AI_TICK+GetRandomReal(-AI_TICK_RANDOM,AI_TICK_RANDOM),false,function thistype.timerAction)
			endif
		endmethod

		method helpCall takes nothing returns nothing
			local integer i = 0
			local unit u = null
			local Undead ud = 0
			/*도움요청*/
			loop
				set u = BlzGroupUnitAt(GROUP,i)
				exitwhen u == null
				if u != .origin_unit then
					/*일정 거리 내 아군에게 헬프콜*/
					if Math.distancePoints(GetUnitX(u),GetUnitY(u),.x,.y) <= 400. then
						set ud = Undead.get(u)
						call ud.encount()
					endif
				endif
				set i = i + 1
			endloop
			set u = null
		endmethod

		static method cond takes nothing returns nothing
			local thistype this = 0
			if Unit(CUSTOM_RESPOND_DAMAGE_ATTACKER).class == "Undead" then
				set this = CUSTOM_RESPOND_DAMAGE_ATTACKER
			elseif Unit(CUSTOM_RESPOND_DAMAGE_TARGET).class == "Undead" then
				set this = CUSTOM_RESPOND_DAMAGE_TARGET
			else
				return
			endif
			call encount()
			call helpCall()
			call onDamaged()
		endmethod

		stub method init takes nothing returns nothing

		endmethod

		static method adjustCounter takes boolean flag returns nothing
			if flag then
				set COUNTER = COUNTER + 1
				if COUNTER == 1 then
					call EnableTrigger(DAMAGE_TRIGGER)
				endif
			else
				set COUNTER = COUNTER - 1
				if COUNTER == 0 then
					call DisableTrigger(DAMAGE_TRIGGER)
				endif
			endif
		endmethod

		static method create takes integer uid, real x, real y, real yaw, integer position returns thistype
			local thistype this = allocate(CONFIG_PLAYER_UNDEAD,uid,x,y,yaw)
			local integer i = 0
			local Ability a = 0
			call GroupAddUnit(GROUP,.origin_unit)
			set .position = position
			set .ai_timer = Timer.new(this)
			set .class = "Undead"
			loop
				exitwhen getAbility(i) <= 0
				set a = getAbility(i)
				set a.is_ai = true
				set i = i + 1
			endloop
			call adjustCounter(true)
			call UnitClass(this).plusClass(ENUM_UNIT_CLASS_UNDEAD)
			return this
		endmethod

		static method new takes integer uid, real x, real y, integer position returns thistype
			set LAST_CREATED = 0
			set CREATE_ID = uid
			set CREATE_X = x
			set CREATE_Y = y
			set CREATE_POSITION = position
			call TriggerEvaluate(CREATE_REQUEST)
			return LAST_CREATED
		endmethod

		static method unregister2 takes nothing returns nothing
			if CUSTOM_RESPOND_UNREGISTER_GROUP_UNIT == null then
				return
			else
				call GroupRemoveUnit(GROUP,CUSTOM_RESPOND_UNREGISTER_GROUP_UNIT)
			endif
		endmethod

		method onDestroy takes nothing returns nothing
			call Timer.release(.ai_timer)
			set .ai_timer = null
			call adjustCounter(false)
			call UnitClass(this).minusClass(ENUM_UNIT_CLASS_UNDEAD)
		endmethod

		static method onInit takes nothing returns nothing
			set GROUP = Group.new()
			set UNREGISTER_GROUP = CreateTrigger()
			call Event.register(UNREGISTER_GROUP,ENUM_EVENT_UNREGISTER_GROUP)
			call TriggerAddCondition(UNREGISTER_GROUP,function thistype.unregister2)
			set DAMAGE_TRIGGER = CreateTrigger()
			call Event.register(DAMAGE_TRIGGER,ENUM_EVENT_DAMAGE_BEFORE_HPREDUCE)
			call TriggerAddCondition(DAMAGE_TRIGGER,function thistype.cond)
			call DisableTrigger(DAMAGE_TRIGGER)
		endmethod

	endstruct

endlibrary

//! textmacro undeadHeader takes id
struct Undead$id$ extends Undead

	private static constant integer ID = '$id$'
//! endtextmacro

//! textmacro undeadEnd

	static method create takes real x, real y, integer position returns thistype
		local thistype this = allocate(ID,x,y,Math.anglePoints(x,y,GetRectCenterX(gg_rct_Spawn),GetRectCenterY(gg_rct_Spawn)),position)
		return this
	endmethod

	private static method request takes nothing returns nothing
		if Undead_CREATE_ID == ID then
			set Undead_LAST_CREATED = create(Undead_CREATE_X,Undead_CREATE_Y,Undead_CREATE_POSITION)
			call thistype(Undead_LAST_CREATED).init()
		endif
	endmethod

	private static method onInit takes nothing returns nothing
		call TriggerAddCondition(Undead_CREATE_REQUEST,function thistype.request)
	endmethod

endstruct
//! endtextmacro

//! import "UndeadData.j"