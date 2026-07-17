library Summon requires Unit

	private struct summonflag extends array

		boolean flag

	endstruct

	struct Summon extends Unit

		private static constant real MANA_TICK = 0.25
		private static constant real MANA_MAX = 100.

		static timer MAIN_TIMER = null
		static Array MAIN_ARRAY = 0
		static integer COUNTER = 0
		static trigger DEATH_TRIGGER = null

		Unit caster = 0
		boolean hide_when_dead = true

		method durationTest takes nothing returns nothing
			if .mp <= 0 and getStatus(CONFIG_STATUS_DEAD) <= 0 then
				call kill()		
			endif
		endmethod

		method manaBurn takes Unit caster, real v returns nothing
			set .mp = .mp - ( v * (10+caster.level) / (10+.level) )
			call durationTest()
		endmethod

		method setDuration takes real r returns nothing
			if not UnitClass(this).isClass(CONFIG_UNIT_CLASS_SUMMON) then
				return
			endif
			call setStatValue(CONFIG_STAT_MAXMP,CONFIG_STAT_INDEX_BASE,r)
			call refreshStatValue(CONFIG_STAT_MAXMP)
		endmethod

		method restoreDuration takes real r returns nothing
			if not UnitClass(this).isClass(CONFIG_UNIT_CLASS_SUMMON) then
				return
			endif
			set .mp = .mp + r
		endmethod

		method addDuration takes real r returns nothing
			local real diff = 0.
			if not UnitClass(this).isClass(CONFIG_UNIT_CLASS_SUMMON) then
				return
			endif
			set diff = .maxmp - .mp
			call setDuration(getStatValue(CONFIG_STAT_MAXMP,CONFIG_STAT_INDEX_BASE)+r)
			set .mp = .maxmp - diff
		endmethod

		/*소환물이 죽었을 때*/
		private method summonDeathEssential takes nothing returns nothing
			if .hide_when_dead and not .is_revive then
				call ShowUnit(.origin_unit,false)
			endif
			call clearAbility()
		endmethod

		stub method summonDeath takes nothing returns nothing

		endmethod

		static method manaTimerCallback takes nothing returns nothing
			local integer i = 0
			local thistype this = 0
			loop
				set this = MAIN_ARRAY.getValue(i)
				exitwhen this <= 0
				set .mp = .mp - 1.0*MANA_TICK
				call durationTest()
				set i = i + 1
			endloop
		endmethod

		static method activate takes boolean flag returns nothing
			if flag then
				/*트리거&타이머 가동*/
				call Timer.start(MAIN_TIMER,MANA_TICK,true,function thistype.manaTimerCallback)
				call EnableTrigger(DEATH_TRIGGER)
			else
				/*트리거&타이머 비활성화*/
				call Timer.pause(MAIN_TIMER)
				call DisableTrigger(DEATH_TRIGGER)
			endif
		endmethod

		static method plusCounter takes nothing returns nothing
			set COUNTER = COUNTER + 1
			if COUNTER == 1 then
				call activate(true)
			endif
		endmethod

		static method minusCounter takes nothing returns nothing
			set COUNTER = COUNTER - 1
			if COUNTER == 0 then
				call activate(false)
			endif
		endmethod

		private method summonRegister takes nothing returns nothing
			if not summonflag(this).flag then
				/*리스트*/
				call MAIN_ARRAY.add(this)
				/*플래그*/
				set summonflag(this).flag = true
				/*인스턴스 카운터*/
				call plusCounter()
			endif
		endmethod

		private method summonUnregister takes nothing returns nothing
			if summonflag(this).flag then 
				/*리스트*/
				call MAIN_ARRAY.eraseFor(this)
				/*플래그*/
				set summonflag(this).flag = false
				/*인스턴스 카운터*/
				call minusCounter()
			endif
		endmethod

		static method create takes Unit caster, integer uid, real x, real y, real yaw, integer level, real duration returns thistype
			local thistype this = allocate(caster.owner,uid,x,y,yaw)
			set .caster = caster
			call summonRegister()
			/*클래스*/
			call UnitClass(this).plusClass(CONFIG_UNIT_CLASS_SUMMON)
			/*소환시간로직때문에 마나재생 0으로., 마나최대치는 100으로.*/
			call setStatValue(CONFIG_STAT_MPREGEN,CONFIG_STAT_INDEX_BASE,0.)
			call setStatValue(CONFIG_STAT_MPREGEN,CONFIG_STAT_INDEX_LEVEL,0.)
			call setStatValue(CONFIG_STAT_MAXMP,CONFIG_STAT_INDEX_BASE,MANA_MAX)
			call setStatValue(CONFIG_STAT_MAXMP,CONFIG_STAT_INDEX_LEVEL,0.)
			call refreshStatValue(CONFIG_STAT_MPREGEN)
			call refreshStatValue(CONFIG_STAT_MAXMP)
			/*레벨, 지속시간*/
			set .level = level
			call setDuration(duration)
			/*마나회복정지*/
			set .restore_mp = false
			/*체력바 스케일링*/
			call setBarScale(1.5)
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			if summonflag(this).flag then
				call summonUnregister()
			endif
			call UnitClass(this).minusClass(CONFIG_UNIT_CLASS_SUMMON)
		endmethod

		private static method deathCallback takes nothing returns nothing
			local thistype this = 0
			if UnitClass(CUSTOM_RESPOND_DEATH_UNIT).isClass(CONFIG_UNIT_CLASS_SUMMON) then
				set this = CUSTOM_RESPOND_DEATH_UNIT
				call summonDeathEssential()
				call summonDeath()
				call summonUnregister()
			endif
		endmethod

		static method onInit takes nothing returns nothing
			set MAIN_TIMER = Timer.new(0)
			set MAIN_ARRAY = Array.create()
			set DEATH_TRIGGER = CreateTrigger()
			call Event.register(DEATH_TRIGGER,CONFIG_EVENT_BEFORE_DEATH)
			call TriggerAddCondition(DEATH_TRIGGER,function thistype.deathCallback)
			call DisableTrigger(DEATH_TRIGGER)
		endmethod

	endstruct

	private struct illusionflag extends array

		boolean flag

	endstruct

	struct Illusion extends Summon

		static method isUnitIllusion takes Unit u returns boolean
			return illusionflag(u).flag
		endmethod

		method summonDeath takes nothing returns nothing
			call Effect.create("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageDeathCaster.mdl",.x,.y,.z+.pivot_z,270.).kill()
		endmethod

		static method create takes Unit caster, integer uid, real x, real y, real yaw, integer level, real duration returns thistype
			local thistype this = 0
			set .LOAD_ABILITY = false
			set this = allocate(caster,uid,x,y,yaw,level,duration)
			set .LOAD_ABILITY = true
			call plusStatus(CONFIG_STATUS_GHOST)
			call setPosition(x,y)
			call SetUnitVertexColor(.origin_unit,32,32,255,192)
			call setScale(caster.getScale())
			set illusionflag(this).flag = true
			/*클래스*/
			call UnitClass(this).plusClass(CONFIG_UNIT_CLASS_ILLUSION)
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			set illusionflag(this).flag = false
			call UnitClass(this).minusClass(CONFIG_UNIT_CLASS_ILLUSION)
		endmethod

	endstruct

endlibrary