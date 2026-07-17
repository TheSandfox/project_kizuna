library ExtraAbilityIcon requires UI

	globals
		private constant real SIZE = 48
		private constant real INSET = 8
		private constant real OFFSET_Y = 16
	endglobals

	struct ExtraAbilityIcon

		/*플레이어 당 하나의 배열리스트*/
		static ArrayList array ICONS[CONFIG_PLAYER_MAX]
		/*플레이어 당 하나의 타이머*/
		static timer array TIMERS[CONFIG_PLAYER_MAX]
		/*플레이어의 인스턴스 갯수*/
		static integer array COUNTER[CONFIG_PLAYER_MAX]

		integer pid = -1
		Ability target = 0

		framehandle container = null
		framehandle icon_backdrop = null
		framehandle icon_backdrop2 = null
		framehandle cooldown_backdrop = null
		framehandle cooldown_backdrop2 = null
		framehandle nem_backdrop = null

		method setPosition takes integer pos returns nothing
			/*TODO SET FRAME POSITION*/
			call BlzFrameSetPointPixel(.icon_backdrop,FRAMEPOINT_BOTTOMRIGHT,FRAME_HP_BAR,FRAMEPOINT_TOPRIGHT,-((SIZE+INSET)*pos),OFFSET_Y)
			/**/
		endmethod

		method refresh takes nothing returns nothing
			/*TODO REFRESH FRAME*/
			call BlzFrameSetVisible(.container,GetLocalPlayer() == Player(.pid))
			/*쿨다운*/
			call BlzFrameSetVisible(.cooldown_backdrop,.target.getUICooldown()>0. and .target.getCarculatedMaxCooldown() > 0.)
			call BlzFrameSetVisible(.cooldown_backdrop2,.target.getUICooldown()>0. and .target.getCarculatedMaxCooldown() > 0.)
			if .target.getCount() == 0 then
				call BlzFrameSetAlpha(.cooldown_backdrop,64)
			endif
			if .target.getCarculatedMaxCooldown() > 0. then
				call BlzFrameSetPointPixel(.cooldown_backdrop2,FRAMEPOINT_TOPLEFT,.icon_backdrop,FRAMEPOINT_BOTTOMRIGHT,/*
					*/-SIZE,SIZE*(.target.getUICooldown()/.target.getCarculatedMaxCooldown()))
			endif
			/*낫이너프마나*/
			call BlzFrameSetVisible(.nem_backdrop,.target.owner.mp < .target.getCarculatedManacost())
			/**/
		endmethod

		static method refreshIcons takes nothing returns nothing
			local thistype this = 0
			local integer i = 0
			loop
				set this = ICONS[Timer.getData(GetExpiredTimer())].get(i)
				exitwhen this <= 0
				call setPosition(i) 
				call refresh()
				set i = i + 1
			endloop
		endmethod

		static method create takes player p, Ability target returns thistype
			local thistype this = 0
			if GetPlayerId(p) >= CONFIG_PLAYER_MAX then
				return 0
			endif
			set this = allocate()
			set .pid = GetPlayerId(p)
			set .target = target
			/*TODO INIT FRAME*/
			set .container = BlzCreateFrameByType("FRAME","",FRAME_STAT1,"",this)
			set .icon_backdrop = BlzCreateFrameByType("BACKDROP","",.container,"",this)
			call BlzFrameSetTexture(.icon_backdrop,Ability.getTypeIconPath(.target.id),0,true)
			call BlzFrameSetSizePixel(.icon_backdrop,SIZE,SIZE)
			set .cooldown_backdrop = BlzCreateFrameByType("BACKDROP","",.container,"",this)
			call BlzFrameSetAllPoints(.cooldown_backdrop,.icon_backdrop)
			call BlzFrameSetTexture(.cooldown_backdrop,"Textures\\Black32.blp",0,true)
			set .cooldown_backdrop2 = BlzCreateFrameByType("BACKDROP","",.container,"",this)
			call BlzFrameSetAllPoints(.cooldown_backdrop2,.icon_backdrop)
			call BlzFrameSetTexture(.cooldown_backdrop2,"Textures\\Black32.blp",0,true)
			call BlzFrameSetAlpha(.cooldown_backdrop2,200)
			set .nem_backdrop = BlzCreateFrameByType("BACKDROP","",.container,"",this)
			call BlzFrameSetAllPoints(.nem_backdrop,.icon_backdrop)
			call BlzFrameSetTexture(.nem_backdrop,"ReplaceableTextures\\teamcolor\\teamcolor14.blp",0,true)
        	call BlzFrameSetAlpha(.nem_backdrop,168)
			call BlzFrameSetVisible(.container,false)
			set .icon_backdrop2 = BlzCreateFrameByType("BACKDROP","",.container,"",this)
			call BlzFrameSetTexture(.icon_backdrop2,UnitData.getIconPath(.target.owner.id),0,true)
			call BlzFrameSetSizePixel(.icon_backdrop2,SIZE*0.5,SIZE*0.5)
			call BlzFrameSetPointPixel(.icon_backdrop2,FRAMEPOINT_BOTTOMRIGHT,.icon_backdrop,FRAMEPOINT_BOTTOMRIGHT,0,0)
			/*ARRAY*/
			call ICONS[.pid].add(this)
			/*INSTANCE COUNTER*/
			set COUNTER[.pid] = COUNTER[.pid] + 1
			if COUNTER[.pid] == 1 then
				call Timer.start(TIMERS[.pid],0.1,true,function thistype.refreshIcons)
			endif
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			/*TODO DESTROY FRAME*/
			//! runtextmacro destroyFrame(".nem_backdrop")
			//! runtextmacro destroyFrame(".cooldown_backdrop")
			//! runtextmacro destroyFrame(".cooldown_backdrop2")
			//! runtextmacro destroyFrame(".icon_backdrop2")
			//! runtextmacro destroyFrame(".icon_backdrop")
			//! runtextmacro destroyFrame(".container")
			/*ARRAY*/
			call ICONS[.pid].pull(ICONS[.pid].seek(this))
			/*INSTANCE COUNTER*/
			set COUNTER[.pid] = COUNTER[.pid] - 1
			if COUNTER[.pid] == 0 then
				call Timer.pause(TIMERS[.pid])
			endif
		endmethod

		static method onInit takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen i >= CONFIG_PLAYER_MAX
				/*플레이어 당 하나의 배열리스트*/
				set ICONS[i] = ArrayList.create()
				/*플레이어 당 하나의 타이머*/
				set TIMERS[i] = Timer.new(i)
				/*플레이어의 인스턴스 갯수*/
				set COUNTER[i] = 0
				set i = i + 1
			endloop
		endmethod

	endstruct

endlibrary