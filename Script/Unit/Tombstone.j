library Tombstone

	struct Tombstone extends array

		static boolean GAME_OVER = false
		static constant string EFFECT_PATH1 = "Doodads\\Northrend\\Props\\NorthrendTombstone\\NorthrendTombstone2.mdl"
		static constant string EFFECT_PATH2 = "Abilities\\Spells\\Orc\\Reincarnation\\ReincarnationTarget.mdl"
		static constant real TICK = 0.1
		static constant real HEAL_PER_SEC = 0.04

		static trigger DECAY_TRIGGER = null
		static trigger REVIVE_TRIGGER = null
		static trigger DEATH_TRIGGER = null

		boolean exists
		Effect ef
		Unit owner
		timer main_timer
		framehandle text

		static method timerAction takes nothing returns nothing
			local thistype this = Timer.getData(GetExpiredTimer())
			local real val = 0.
			/*가시성처리*/
			if GetLocalPlayer() == .owner.owner then
				call BlzFrameSetVisible(.text,User.getFocusUnit(.owner.owner) == .owner)
			endif
			if GAME_OVER then
				set .owner.hp = 1.
				call BlzFrameSetText(.text,"|cffff0000∞|r")
				call BlzFrameSetScale(.text,2.0)
				set .text = null
				return
			else
				call .owner.healUnit(.owner,.owner.maxhp*HEAL_PER_SEC*TICK)
				/*부활 예상시간 계산*/
				set val = (.owner.maxhp - .owner.hp) / ( (.owner.maxhp*HEAL_PER_SEC+.owner.hpregen)*.owner.getCarculatedStatValue(ENUM_STAT_HEAL_AMP) )
				call BlzFrameSetText(.text,"|cffff0000"+I2S(R2I(val)+1)+"|r")
			endif
		endmethod

		static method create takes Unit u returns thistype
			local thistype this = 0
			if not u.is_revive then
				return 0
			endif
			set this = u
			set .exists = true
			set .owner = u
			set .ef = Effect.create(EFFECT_PATH1,.owner.x,.owner.y,0.,270.)
			set .main_timer = Timer.new(this)
			call Timer.start(.main_timer,TICK,true,function thistype.timerAction)
			set .text = BlzCreateFrame("MyTextLarge",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],0,0)
			call BlzFrameSetPoint(.text,FRAMEPOINT_CENTER,FRAME_PORTRAIT_BACKDROP,FRAMEPOINT_CENTER,0.,0.)
			call BlzFrameSetVisible(.text,GetLocalPlayer() == .owner.owner)
			return this
		endmethod

		method destroy takes nothing returns nothing
			local Effect eff = Effect.create(EFFECT_PATH2,.owner.x,.owner.y,0.,270.).setAnim(ANIM_TYPE_DEATH).setDuration(3.33)
			set eff.want_remove = true
			call Timer.release(.main_timer)
			set .main_timer = null
			set .ef.want_remove = true
			call .ef.destroy()
			set .ef = 0
			set .exists = false
			//! runtextmacro destroyFrame(".text")
			/**/
		endmethod

		static method death takes nothing returns nothing
			if CUSTOM_RESPOND_DEATH_UNIT <= 0 then
				return
			endif
			if not thistype(CUSTOM_RESPOND_DEATH_UNIT).exists then
				call create(CUSTOM_RESPOND_DEATH_UNIT)
			endif
		endmethod

		static method revive takes nothing returns nothing
			if CUSTOM_RESPOND_REVIVE_UNIT <= 0 then
				return
			endif
			if thistype(CUSTOM_RESPOND_REVIVE_UNIT).exists then
				call thistype(CUSTOM_RESPOND_REVIVE_UNIT).destroy()
			endif
		endmethod

		static method decay takes nothing returns nothing
			if CUSTOM_RESPOND_DECAY_UNIT <= 0 then
				return
			endif
			if thistype(CUSTOM_RESPOND_DECAY_UNIT).exists then
				call thistype(CUSTOM_RESPOND_DECAY_UNIT).destroy()
			endif
		endmethod

		static method onInit takes nothing returns nothing
			set DEATH_TRIGGER = CreateTrigger()
			call Event.register(DEATH_TRIGGER,ENUM_EVENT_DEATH)
			call TriggerAddCondition(DEATH_TRIGGER,function thistype.death)
			set REVIVE_TRIGGER = CreateTrigger()
			call Event.register(REVIVE_TRIGGER,ENUM_EVENT_REVIVE)
			call TriggerAddCondition(REVIVE_TRIGGER,function thistype.revive)
			set DECAY_TRIGGER = CreateTrigger()
			call Event.register(DECAY_TRIGGER,ENUM_EVENT_DECAY)
			call TriggerAddCondition(DECAY_TRIGGER,function thistype.decay)
		endmethod

	endstruct

endlibrary