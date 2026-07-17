library NPCUI requires User

	struct NPCUI extends array

		static framehandle array CHILD
		static integer CHILD_COUNT = 0
		static framehandle CONTAINER

		timer main_timer
		Unit caster
		NPC npc

		static method registerChild takes framehandle container returns nothing
			set CHILD[CHILD_COUNT] = container
			set CHILD_COUNT = CHILD_COUNT + 1
		endmethod

		method break takes nothing returns nothing
			local integer i = 0
			if GetLocalPlayer() == Player(this) then
				call BlzFrameSetVisible(CONTAINER,false)
			endif
			loop
				exitwhen i >= CHILD_COUNT
				if GetLocalPlayer() == Player(this) then
					call BlzFrameSetVisible(CHILD[i],false)
				endif
				set i = i + 1
			endloop
			call Timer.pause(.main_timer)
			set .caster = 0
			set .npc = 0
		endmethod

		static method timerAction takes nothing returns nothing
			local thistype this = Timer.getData(GetExpiredTimer())
			if .caster <= 0 or .npc <= 0 then
				/*정지*/
				call break()
				return
			endif
			if Math.distancePoints(.caster.x,.caster.y,.npc.x,.npc.y) > 512. then
				call break()
				return
			endif
		endmethod

		method runTimer takes nothing returns nothing
			if .main_timer == null then
				set .main_timer = Timer.new(this)
			endif
			call Timer.start(.main_timer,0.5,true,function thistype.timerAction)
		endmethod

		method show takes boolean flag, Unit caster, NPC npc returns nothing
			call break()
			set .caster = caster
			set .npc = npc
			if flag then
				if GetLocalPlayer() == Player(this) then
					call BlzFrameSetVisible(CONTAINER,true)
				endif
				call runTimer()
			endif
		endmethod

		static method init takes framehandle parent returns nothing
			local integer i = 0
			set CONTAINER = BlzCreateFrameByType("FRAME","NPCUI",parent,"",0)
			loop
				exitwhen i >= bj_MAX_PLAYER_SLOTS
				set thistype(i).main_timer = null
				set thistype(i).caster = 0
				set thistype(i).npc = 0
				set i = i + 1
			endloop
		endmethod

	endstruct

endlibrary