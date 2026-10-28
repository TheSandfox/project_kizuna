library Boss requires Frame

	struct Boss_prototype extends Unit	
		
		/*BossUI에서 읽어야 하는 멤버들 입력할 것*/

		static method create takes integer id, real x, real y returns thistype
			local thistype this = allocate(CONFIG_PLAYER_MONSTER,id,x,y,270.)
			return this
		endmethod
		
	endstruct

	/*체력바 감소 이펙트*/
	struct BarHPLoss

		static constant real DURATION = 0.25
		static constant real Y_AXIS = 2.0

		static integer COUNTER = 0
		static Array ARR = 0
		static timer TIMER = null

		framehandle backdrop = null
		framehandle pivot = null
		real x = 0.
		real y = 0.
		real alpha = 1.0

		method refresh takes nothing returns nothing
			set .alpha = .alpha - TIMER_TICK/DURATION
			call BlzFrameSetAlpha(.backdrop,R2I(.alpha*255))
			set .y = .y - (TIMER_TICK*Y_AXIS)/DURATION
			call BlzFrameSetPointPixel(.backdrop,FRAMEPOINT_TOPLEFT,.pivot,FRAMEPOINT_TOPLEFT,.x,.y)
			if .alpha <= 0. then
				call .ARR.setValue(.ARR.seek(this),0)
				call destroy()
			endif
		endmethod

		static method timerCallback takes nothing returns nothing
			local integer i = 0
			local thistype this = 0
			local boolean result = true
			loop
				exitwhen i >= .ARR.size
				set this = .ARR.getValue(i)
				call refresh()
				set i = i + 1
			endloop
			call .ARR.removeFor(0)
		endmethod

		method register takes nothing returns nothing
			call .ARR.add(this)
			set .COUNTER = .COUNTER + 1
			if .COUNTER == 1 then
				call Timer.start(.TIMER,TIMER_TICK,true,function thistype.timerCallback)
			endif
		endmethod

		method unregister takes nothing returns nothing
			//call .ARR.remove(this)//refresh내부에서
			set .COUNTER = .COUNTER - 1
			if .COUNTER <= 0 then
				call Timer.pause(.TIMER)
			endif
		endmethod

		static method create takes framehandle parent, framehandle pivot, real xoffset, real width, real height returns thistype
			local thistype this = allocate()
			set .x = xoffset
			set .pivot = pivot
			set .backdrop = BlzCreateFrameByType("BACKDROP","",parent,"",0)
			call BlzFrameSetPointPixel(.backdrop,FRAMEPOINT_TOPLEFT,pivot,FRAMEPOINT_TOPLEFT,xoffset,0)
			call BlzFrameSetSizePixel(.backdrop,width,height)
			call BlzFrameSetTexture(.backdrop,"textures\\white.blp",0,true)
			call register()
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			call unregister()
			//! runtextmacro destroyFrame(".backdrop")
			set .pivot = null
		endmethod

		static method onInit takes nothing returns nothing
			set .ARR = Array.create()
			set .TIMER = Timer.new(0)
		endmethod

	endstruct

	struct BossUI

		Boss_prototype owner = 0
		UnitActor actor = 0
		timer main_timer = null
		delegate Hash visible_flag = 0
		framehandle container = null
		framehandle name = null

		stub method refresh takes nothing returns nothing

		endmethod

		method clearVisibleFlag takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen i >= CONFIG_PLAYER_MAX
				call setInteger(i,0)
				set i = i + 1
			endloop
		endmethod

		method addVisibleFlag takes player p returns nothing
			local integer pid = GetPlayerId(p)
			call setInteger(pid,getInteger(pid)+1)
		endmethod

		method adjustVisibility takes nothing returns nothing
			call BlzFrameSetVisible(.container,getInteger(GetPlayerId(GetLocalPlayer()))>0)
		endmethod

		static method refreshCallback takes nothing returns nothing
			local thistype this = Timer.getData(GetExpiredTimer())
			call refresh()
		endmethod

		method awake takes nothing returns nothing
			call refresh()
			call Timer.start(.main_timer,TIMER_TICK,true,function thistype.refreshCallback)
		endmethod

		method sleep takes nothing returns nothing
			call Timer.pause(.main_timer)
		endmethod

		static method create takes Boss_prototype owner returns thistype
			local thistype this = allocate()
			set .owner = owner
			set .actor = 0
			set .main_timer = Timer.new(this)
			set .visible_flag = Hash.allocate()
			set .container = BlzCreateFrameByType("FRAME","",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],"",0)
			set .name = BlzCreateFrame("MyTextLarge",.container,0,0)
			call BlzFrameSetPointPixel(.name,FRAMEPOINT_TOP,FRAME_ORIGIN,FRAMEPOINT_TOP,0.,-64)
			call BlzFrameSetTextAlignment(.name,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_CENTER)
			call BlzFrameSetText(.name,.owner.name)
			call BlzFrameSetVisible(.container,false)
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			call .visible_flag.deallocate()
			set .visible_flag = 0
			call Timer.release(.main_timer)
			set .main_timer = null
			//! runtextmacro destroyFrame(".name")
			//! runtextmacro destroyFrame(".container")
		endmethod

	endstruct

	struct Boss extends Boss_prototype

		group enemies = null
		/*ZONE*/
		static constant real ZONE_SIZE = 512.*6.
		rect zone = null
		/*DAMAGE_TRIGGER*/
		Trigger damage_trigger = 0
		/*TIMER*/
		static constant integer TIMER_STATE_COMBAT = 0
		static constant integer TIMER_STATE_RETREAT = 1
		static constant integer TIMER_STATE_SLEEP = 2
		static constant real RETREAT_TIMEOUT = 2.0
		timer boss_timer = null
		integer timer_state = TIMER_STATE_SLEEP
		real retreat_timeout = RETREAT_TIMEOUT
		/*BAR*/
		BossUI ui = 0
		/*pattern*/
		integer pattern_running = 0

		method getNearest takes nothing returns Unit
			local unit u = Group.getNearest(.enemies,.x,.y,null)
			local Unit uu = 0
			set uu = Unit.get(u)
			set u = null
			return uu
		endmethod

		method getFurthest takes nothing returns Unit
			local unit u = Group.getFurthest(.enemies,.x,.y,null)
			local Unit uu = 0
			set uu = Unit.get(u)
			set u = null
			return uu
		endmethod

		method countUnits takes nothing returns integer
			// local integer sum = 0
			local integer i = 0
			local unit u = null
			local Unit uu = 0
			call Group.clear(.enemies)
			call GroupEnumUnitsInRect(.enemies,.zone,null)
			call .ui.clearVisibleFlag()
			loop
				set u = BlzGroupUnitAt(.enemies,i)
				exitwhen u == null
				set uu = Unit.get(u)
				if uu > 0 and (not uu.isUnitType(UNIT_TYPE_DEAD)) and uu.isEnemy(.owner) then
					call .ui.addVisibleFlag(uu.owner)
					// set sum = sum + 1
					set i = i + 1
				else
					call GroupRemoveUnit(.enemies,u)
				endif
			endloop
			call .ui.adjustVisibility()
			set u = null
			return i
		endmethod

		stub method onSleep takes nothing returns nothing

		endmethod

		stub method doPattern takes nothing returns nothing

		endmethod

		/*보스 전역타이머*/
		private static method bossTimerCallback takes nothing returns nothing
			local thistype this = Timer.getData(GetExpiredTimer())
			/*죽었으면 중단*/
			if getStatus(ENUM_STATUS_DEAD) > 0 then
				call Timer.pause(.boss_timer)
				call .ui.clearVisibleFlag()
				call .ui.adjustVisibility()
				call .ui.sleep()
				return 
			endif
			/*전투중(패턴수행,유닛개수,도망치기 등)*/
			if .timer_state == .TIMER_STATE_COMBAT then
				/*패턴수행중이 아님&그로기가 아님*/
				if .pattern_running <= 0 and getStatus(ENUM_STATUS_UNSTOP) > 0 then
					/*구역 내에 적이 없음*/
					if countUnits() <= 0 then
						set .retreat_timeout = .retreat_timeout - 0.5
						/*인내심이 바닥났음*/
						if .retreat_timeout <= 0. then
							set .retreat_timeout = .RETREAT_TIMEOUT
							set .timer_state = .TIMER_STATE_RETREAT
							// call BJDebugMsg("니게룽다요")
						endif
					/*구역 내에 적이 있음*/
					else
						set .retreat_timeout = .RETREAT_TIMEOUT
						call doPattern()
					endif
				/*패턴 수행중임or그로기*/
				else

				endif
			/*도망치는중(원위치에 갔으면&만피이면 슬립)*/
			elseif .timer_state == .TIMER_STATE_RETREAT then
				/*도착시 슬립*/
				if Math.distancePoints(.x,.y,GetRectCenterX(.zone),GetRectCenterY(.zone)) <= 16.0 and .hp >= .maxhp then
					call SetUnitFacing(.origin_unit,270.0)
					set .timer_state = .TIMER_STATE_SLEEP
					call Timer.pause(.boss_timer)
					call .damage_trigger.enable()
					call countUnits()
					call onSleep()
					call .ui.sleep()
					// call BJDebugMsg("쿨쿨")
				/*도착 못했으면 이동*/
				else
					if Math.distancePoints(.x,.y,GetRectCenterX(.zone),GetRectCenterY(.zone)) > 16.0 then
						call issuePointOrder("smart",GetRectCenterX(.zone),GetRectCenterY(.zone))
					endif
					call healUnit(this,.maxhp*0.25*0.5)
				endif
			endif
		endmethod

		/*휴식중에 피격 시 전투 시작*/
		private static method damageCallback takes nothing returns nothing
			local thistype this = Trigger.getData(GetTriggeringTrigger())
			if CUSTOM_RESPOND_DAMAGE_TARGET != this then
				return
			endif
			// call BJDebugMsg("데미지콜백")
			if countUnits() > 0 then
				set .timer_state = .TIMER_STATE_COMBAT
				call Timer.start(.boss_timer,0.5,true,function thistype.bossTimerCallback)
				call .damage_trigger.disable()
				call .ui.awake()
				// call BJDebugMsg("전투시작")
			else
				set .hp = .maxhp
			endif
		endmethod

		static method create takes integer id, integer level, real x, real y returns thistype
			local thistype this = allocate(id,x,y)
			call issueImmediateOrder("stop")
			/*존*/
			set .zone = Rect(x-(.ZONE_SIZE/2.),y-(.ZONE_SIZE/2.),x+(.ZONE_SIZE/2.),y+(.ZONE_SIZE/2.))
			/*타이머*/
			set .boss_timer = Timer.new(this)
			/*트리거*/
			set .damage_trigger = Trigger.create(this)
			call Event.register(.damage_trigger.main_trigger,ENUM_EVENT_DAMAGE_MODIFY_STAT)
			call .damage_trigger.addCondition(function thistype.damageCallback)
			/*그룹*/
			set .enemies = Group.new()
			set .level = level
			/*체젠감소*/
			call divideStatValue(ENUM_STAT_HEAL_AMP,4.)
			/*클래스*/
			call UnitClass(this).plusClass(ENUM_UNIT_CLASS_BOSS)
			/*무장해제*/
			call plusStatus(ENUM_STATUS_DISARM)
			/*저지불가*/
			call plusStatus(ENUM_STATUS_UNSTOP)
			/*충돌 off*/
			call plusStatus(ENUM_STATUS_GHOST)
			/*스케일링*/
			call setScale(2.0)
			call setBarScale(1.5*2.0)
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			/*존*/
			call RemoveRect(.zone)
			set .zone = null
			/*타이머*/
			call Timer.release(.boss_timer)
			set .boss_timer = null
			/*트리거*/
			call .damage_trigger.destroy()
			set .damage_trigger = 0
			/*그룹*/
			call Group.release(.enemies)
			set .enemies = null
			/*보스바*/
			if .ui > 0 then
				call .ui.destroy()
			endif
		endmethod

	endstruct

	struct BossActor extends UnitActor

		method operator boss takes nothing returns Boss
			return Boss(.caster)
		endmethod

		static method create takes Boss caster, Unit target, real x, real y, integer level, real duration, boolean channeling returns thistype
			local thistype this = allocate(caster,target,x,y,level,duration,channeling)
			set Boss(.caster).pattern_running =  Boss(.caster).pattern_running + 1
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			set Boss(.caster).pattern_running =  Boss(.caster).pattern_running - 1
		endmethod

	endstruct

	struct BossActorIdle extends BossActor

		method periodicAction takes nothing returns nothing
			if .target > 0 then
				call SetUnitFacing(.caster.origin_unit,Math.anglePoints(.caster.x,.caster.y,.target.x,.target.y))
			endif
			call .caster.restoreMP(.caster.maxmp*TIMER_TICK*0.33)
		endmethod

		static method create takes Boss caster, Unit target, real duration returns thistype
			local thistype this = allocate(caster,0,0,0,0,duration,false)
			call .caster.setAnim("stand ready")
			call .caster.queueAnim("stand ready")
			return this
		endmethod

	endstruct

	//! import "BossPatternIndicator.j"
	//! import "BossData.j"

endlibrary
