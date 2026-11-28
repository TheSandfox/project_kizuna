library Monster requires Unit

	globals
		private constant integer P_MONSTER_CAMP_RADIUS_MAX = 1024+128
    private constant integer P_MONSTER_CAMP_RADIUS_MIN = 512
		private constant integer P_IDLE_SLOW = 100 /*배회 시 이속감소량*/
		private constant real P_AI_TICK = 1.
		private constant real P_AI_TICK_RANDOM = 0.25
		private constant real P_AI_BREAK_TICK = 0.25
		private constant real P_AI_IDLE_TICK = 3.0
		private constant real P_AI_IDLE_TICK_RANDOM = 1.0
		private constant real P_BREAK_HEAL_PER_SEC = 0.5
		private constant integer P_TIMERSTATE_DEFAULT = 0
		private constant integer P_TIMERSTATE_IDLE = 1
		private constant integer P_TIMERSTATE_COMBAT = 2
		private constant integer P_TIMERSTATE_BREAK = 3

		private trigger P_TIMERSTATE_CHANGE_CALLBACK = null
		private integer P_TIMERSTATE_CHANGE_UNIT = 0
		private integer P_TIMERSTATE_CHANGE_COMBAT_TARGET = 0
		private integer P_TIMERSTATE_CHANGE_STATE = 0
	endglobals

	struct Monster extends Unit

		static real S_RANDOM_X = 0.
    static real S_RANDOM_Y = 0.

		timer ai_timer = null /*ai타이머*/
		trigger damaged_trigger = null /*데미지입음 개별트리거*/
		Unit target = 0 /*현재 추적중인 대상*/
		integer camp_id = 0 /*캠프ID(이벤트응답에활용)*/
		rect camp_rect = null
		real camp_x = 0. /*생성좌표*/
		real camp_y = 0. /*생성좌표*/
		real camp_angle = 0. /*생성FACING*/
		real camp_range = 600.

		integer timer_state = P_TIMERSTATE_DEFAULT
		real acquire_range = 1200.

		/*대상이 싸울 수 있는 상태인가?(조건 불일치 시 원래자리로 복귀해야함)*/
		method targetCondition takes Unit u returns boolean
			if not u.isEnemy(.owner) then
				/*아군이면 거름*/
				return false
			elseif not u.inRange(.x,.y,.acquire_range) then
				/*대상이 사거리 밖이면 거름*/
				return false
			// elseif not inRange(.camp_x,.camp_y,.camp_range) then
			// 	/*이 몬스터가 캠프 밖을 나갔으면 응답X*/
			// 	return false
			elseif u.isUnitType(UNIT_TYPE_DEAD) then
				/*시체는 거름*/
				return false
			endif
			return true
		endmethod

		method setTarget takes Unit target returns nothing
			/*일부러 빈 유닛을 지정하였음*/
			if target == 0 then
				set .target = 0
				return
			endif
			/*빈 유닛이 아닌 경우*/
			if targetCondition(target) then
				set .target = target
				call issueTargetOrder("attack",target.origin_unit)
			else
				set .target = 0
			endif
		endmethod

		method findNewTarget takes nothing returns Unit
			local group g = Group.new()
			local unit unitHandle = null
			local Unit u = 0
			local integer i = 0
			// if .camp_rect == null then
			// 	call setTarget(0)
			// 	return
			// endif
			call GroupEnumUnitsInRange(g,.x,.y,.acquire_range*2.,null)
			loop
				set unitHandle = BlzGroupUnitAt(g,i)
				exitwhen unitHandle == null
				set u = Unit.get(unitHandle)
				if u <= 0 or not targetCondition(u) then
					call GroupRemoveUnit(g,unitHandle)
				else
					set i = i + 1
				endif
			endloop
			if BlzGroupGetSize(g) <= 0 then
				set u = 0
			else
				set u = Unit.get(Group.getNearest(g,.x,.y,null))
			endif
			call Group.release(g)
			set unitHandle = null
			set g = null
			return u
		endmethod

		method refreshRandomIdlePosition takes nothing returns nothing
			local real rMin = I2R(P_MONSTER_CAMP_RADIUS_MIN)
			local real rMax = I2R(P_MONSTER_CAMP_RADIUS_MAX)
			local real u = GetRandomReal(0., 1.)
			local real radius = SquareRoot(rMin * rMin + u * (rMax * rMax - rMin * rMin))
			local real angle = GetRandomReal(0., 2. * bj_PI)
			set S_RANDOM_X = GetRectCenterX(.camp_rect) + radius * Cos(angle)
			set S_RANDOM_Y = GetRectCenterY(.camp_rect) + radius * Sin(angle)
		endmethod

		method periodicAction takes nothing returns nothing
			local real rx = 0.
			local real ry = 0.
			local integer idleDiceNum = 0
			local Unit newTarget = 0
			if .timer_state == P_TIMERSTATE_COMBAT then
				/*전투중*/
				if .target <= 0 or not targetCondition(.target) then
					/*우선 다른 대상이 있는지 찾아봐야함*/
					set newTarget = findNewTarget()
					if newTarget > 0 then
						/*새 대상 찾음*/
						call setTarget(newTarget)
					else
						/*대상없음*/
						/*타이머 상태변경 콜백 작동 - 휴식*/
						set P_TIMERSTATE_CHANGE_UNIT = this
						set P_TIMERSTATE_CHANGE_STATE = P_TIMERSTATE_BREAK
						call TriggerEvaluate(P_TIMERSTATE_CHANGE_CALLBACK)
					endif
				endif
			elseif .timer_state == P_TIMERSTATE_BREAK then
				/*휴식중*/
				call healUnit(this,.maxhp*P_BREAK_HEAL_PER_SEC*P_AI_BREAK_TICK)
				set .mp = .mp + .maxmp*P_BREAK_HEAL_PER_SEC*P_AI_BREAK_TICK
				/*무빙 방해받았을 경우 다시 무빙명령*/
				if GetUnitCurrentOrder(.origin_unit) != OrderId(CONFIG_ORDER_STRING_CUSTOM_MOVE) then
					call issuePointOrder(CONFIG_ORDER_STRING_CUSTOM_MOVE,.camp_x,.camp_y)
				endif
				/*휴식완료조건 체크*/
				if (.hp >= (.maxhp*0.99)) and Math.distancePoints(.x,.y,.camp_x,.camp_y) <= 32. then
					/*타이머 상태변경 콜백 작동 - 타이머정지*/
					set P_TIMERSTATE_CHANGE_UNIT = this
					set P_TIMERSTATE_CHANGE_STATE = P_TIMERSTATE_IDLE
					call TriggerEvaluate(P_TIMERSTATE_CHANGE_CALLBACK)
				endif
			elseif .timer_state == P_TIMERSTATE_IDLE then
				set idleDiceNum = GetRandomInt(0,3)
				/*움직이거나 제자리에 머물거나*/
				if idleDiceNum <= 1 then
					// call BJDebugMsg("배회중")
					call refreshRandomIdlePosition()
					set rx = S_RANDOM_X
					set ry = S_RANDOM_Y
					set .camp_x = rx
					set .camp_y = ry
					call issuePointOrder(CONFIG_ORDER_STRING_CUSTOM_MOVE,rx,ry)
				else 
					// call BJDebugMsg("멈춰섬")
					set .camp_x = .x
					set .camp_y = .y
					call issueImmediateOrder(CONFIG_ORDER_STRING_CUSTOM_STOP)
				endif
				set P_TIMERSTATE_CHANGE_UNIT = this
				set P_TIMERSTATE_CHANGE_STATE = P_TIMERSTATE_IDLE
				call TriggerEvaluate(P_TIMERSTATE_CHANGE_CALLBACK)
			endif
		endmethod

		private static method aiTimerAction takes nothing returns nothing
			local thistype this = Timer.getData(GetExpiredTimer())
			call periodicAction()
		endmethod

		/*타이머 상태 바꾸기 직전 처라*/
		method stateChange takes integer newState returns nothing
			local integer oldState = .timer_state
			/*똑같은상태면 처리안함*/
			if oldState == newState then
				return
			endif
			/*상태 벗어남*/
			if oldState == P_TIMERSTATE_DEFAULT then
				/*초기상태*/
			elseif oldState == P_TIMERSTATE_DEFAULT then
				/*아이들 상태에서 벗어나는 경우*/
				call minusStatus(ENUM_STATUS_DISARM)
				call minusStatValue(ENUM_STAT_MOVEMENT_SPEED,-P_IDLE_SLOW)
			elseif oldState == P_TIMERSTATE_DEFAULT then
				/*전투 상태에서 벗어나는 경우*/
			elseif oldState == P_TIMERSTATE_DEFAULT then
				/*휴식 상태에서 벗어나는 경우*/
				call minusStatus(ENUM_STATUS_DISARM)
			endif
			/*상태 지정*/
			if newState == P_TIMERSTATE_DEFAULT then
				/*초기상태(쓸일없을듯?)*/
			elseif newState == P_TIMERSTATE_DEFAULT then
				/*아이들 상태로 진입하는 경우*/
				call setTarget(0)
				call plusStatus(ENUM_STATUS_DISARM)
				call minusStatValue(ENUM_STAT_MOVEMENT_SPEED,P_IDLE_SLOW)
			elseif newState == P_TIMERSTATE_DEFAULT then
				/*전투 상태로 진입하는 경우*/
			elseif newState == P_TIMERSTATE_DEFAULT then
				/*휴식 상태로 진입하는 경우*/
				call plusStatus(ENUM_STATUS_DISARM)
				call issuePointOrder(CONFIG_ORDER_STRING_CUSTOM_MOVE,.camp_x,.camp_y)
			endif
			set .timer_state = newState
		endmethod

		/*타이머정지*/
		method aiTimerIdle takes nothing returns nothing
			// call BJDebugMsg("배회 시작: "+.name)
			call stateChange(P_TIMERSTATE_IDLE)
			call Timer.start(.ai_timer,P_AI_IDLE_TICK+GetRandomReal(-P_AI_IDLE_TICK_RANDOM,P_AI_IDLE_TICK_RANDOM),false,function thistype.aiTimerAction)
		endmethod

		method aiTimerBreak takes nothing returns nothing
			// call BJDebugMsg("휴식 시작: "+.name)
			call stateChange(P_TIMERSTATE_BREAK)
			call Timer.start(.ai_timer,P_AI_BREAK_TICK,true,function thistype.aiTimerAction)
		endmethod
		
		method aiTimerCombat takes Unit target returns nothing
			// call BJDebugMsg("전투 시작: "+.name+"("+target.name+"을(를) 공격)")
			call stateChange(P_TIMERSTATE_COMBAT)
			call setTarget(target)
			call Timer.start(.ai_timer,P_AI_TICK,true,function thistype.aiTimerAction)
		endmethod

		method encount takes Unit target returns nothing
			/*타이머가 정지상태임+때린놈이 적합한 전투대상인지 판별*/
			if .timer_state == P_TIMERSTATE_IDLE then
				if target > 0 and targetCondition(target) then
					/*적절한 대상이면 전투*/
					call aiTimerCombat(target)
				else
					/*적절한 대상이 아닐 경우, 체력이 상했을 수 있으므로 휴식에 돌입*/
					call aiTimerBreak()
				endif
			endif
		endmethod

		static method damagedCallback takes nothing returns nothing
			local thistype this = Trigger.getData(GetTriggeringTrigger())
			if this != EVT_DAMAGE_TARGET then
				return
			endif 
			call encount(EVT_DAMAGE_ATTACKER)
		endmethod

		static method create takes integer campId, integer uid, real x, real y, real yaw returns thistype
			local thistype this = allocate(CONFIG_PLAYER_MONSTER,uid,x,y,yaw)
			local integer i = 0
			/**/
			set .camp_id = campId
			set .camp_x = x
			set .camp_y = y
			set .camp_angle = yaw
			set .ai_timer = Timer.new(this)
			set .class = UDG_UNIT_CLASS_NAME[ENUM_UNIT_CLASS_MONSTER]
			/*유닛유형설정*/
			call UnitClass(this).plusClass(ENUM_UNIT_CLASS_MONSTER)
			/*개별트리거(데미지입음)*/
			set .damaged_trigger = Trigger.new(this)
			call Event.register(.damaged_trigger,ENUM_EVENT_DAMAGE_BEFORE_HPREDUCE)
			call TriggerAddCondition(.damaged_trigger,function thistype.damagedCallback)
			/*일단 아이들상태로*/
			call issueImmediateOrder(CONFIG_ORDER_STRING_CUSTOM_STOP)
			call aiTimerIdle()
			/*미니맵 아이콘 변경*/
			call BlzSetUnitBooleanField(.origin_unit,UNIT_BF_HERO_HIDE_HERO_MINIMAP_DISPLAY,true)
			return this
		endmethod

		static method timerStateChangeCallback takes nothing returns nothing
			local thistype this = P_TIMERSTATE_CHANGE_UNIT
			if P_TIMERSTATE_CHANGE_STATE == P_TIMERSTATE_IDLE then
				call aiTimerIdle()
			elseif P_TIMERSTATE_CHANGE_STATE == P_TIMERSTATE_COMBAT then
				call aiTimerCombat(P_TIMERSTATE_CHANGE_COMBAT_TARGET)
			elseif P_TIMERSTATE_CHANGE_STATE == P_TIMERSTATE_BREAK then
				call aiTimerBreak()
			endif
		endmethod

		method onDestroy takes nothing returns nothing
			/*타이머제거*/
			call Timer.release(.ai_timer)
			set .ai_timer = null
			/*개별트리거 제거*/
			call Trigger.remove(.damaged_trigger)
			set .damaged_trigger = null
			/*유닛유형 리셋*/
			call UnitClass(this).minusClass(ENUM_UNIT_CLASS_MONSTER)
			/**/
			set .camp_rect = null
		endmethod

		static method onInit takes nothing returns nothing
			set P_TIMERSTATE_CHANGE_CALLBACK = CreateTrigger()
			call TriggerAddCondition(P_TIMERSTATE_CHANGE_CALLBACK,function thistype.timerStateChangeCallback)
		endmethod

	endstruct

endlibrary