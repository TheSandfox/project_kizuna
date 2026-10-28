scope BossB000

	globals
		private trigger MY_RESPOND = CreateTrigger()
		private integer MY_RESPOND_VAL = 0
		private string MY_RESPOND_TYPE = ""
		private constant integer ID1 = 'B000'
		private constant integer ID2 = 'B001'
	endglobals

	/*체력바*/
	//! import "B000_bar.j"

	/*대지강타*/
	//! import "B000_bash.j"

	/*돌굴리기*/
	//! import "B000_rollingstone.j"

	struct BossB000 extends Boss

		integer phase = 0
		boolean divide = false

		method onSleep takes nothing returns nothing
			set .mp = .maxmp
			set .divide = false
			set .phase = 0
		endmethod

		method doPattern takes nothing returns nothing
			local Unit u = 0//
			local integer rand = 0
			/*체력 일정치 미만 도달 시 무조건 분열*/
			if .phase < 2 and not .divide and (.hp/.maxhp)<=0.33*(2-.phase) then
				//createdivide
				set .divide = true
				return
			endif
			set u = getNearest()
			/*패턴에너지 없으면 휴식*/
			if .mp <= 80. then
				//createidle
				call BossActorIdle.create(this,u,GetRandomReal(1.5,3.0))
				return
			endif
			/*있으면 패턴후 에너지 감소*/
			if u > 0 then
				if .mp >= .maxmp*0.99 then
					call rollingstone.create(this,u)
				else
					call sanrengeki.create(this,u)
				endif
				set .mp = .mp - 75.
			endif
		endmethod

		static method create takes integer level, real x, real y returns thistype
			local thistype this = allocate('B000',level,x,y)
			/*자동으로 삭제됨*/
			set .ui = mybar.create(this)
			return this
		endmethod

		static method myCallback takes nothing returns nothing
			local thistype this = MY_RESPOND_VAL
			if MY_RESPOND_TYPE == "divide_end" then
				set .divide = false
				set .phase = .phase + 1
			endif
		endmethod

		static method onInit takes nothing returns nothing
			call TriggerAddCondition(MY_RESPOND,function thistype.myCallback)
		endmethod

	endstruct

endscope