library CloseUI requires UI

	struct CloseUI extends array

		private static trigger ESC_TRIGGER

		delegate Array list

		static constant integer ORDER_INVENTORY_DIALOG = 1
		static constant integer ORDER_NUMBERPAD = 2
		static constant integer ORDER_INVENTORY = 3
		static constant integer ORDER_STAT_INDICATOR = 4
		static constant integer ORDER_SLOT_CHANGER = 5
		static constant integer ORDER_SKILL_SHOP = 6
		static constant integer ORDER_WARP = 7
		static constant integer ORDER_ABILITY_MANAGER = 8

		method close takes integer order returns nothing
			if order == ORDER_INVENTORY_DIALOG then
				call Inventory(this).close()
				return
			endif
			if order == ORDER_NUMBERPAD then
				call Numberpad(this).close()	
				return
			endif
			if order == ORDER_INVENTORY then
				call Inventory(this).close()
				return
			endif
			if order == ORDER_STAT_INDICATOR then
				call StatIndicator(this).close()
				return
			endif
			if order == ORDER_SLOT_CHANGER then
				call SlotChanger(this).close()
				return
			endif
			if order == ORDER_SKILL_SHOP then
				call SkillShop(this).close()
				return
			endif
			if order == ORDER_WARP then
				call WarpWidget.show(Player(this),false)
			endif
			if order == ORDER_ABILITY_MANAGER then
				call AbilityManager(this).close()
				return
			endif
		endmethod

		static method act takes nothing returns nothing
			local thistype this = GetPlayerId(GetTriggerPlayer())
			call close(getValue(/*.list*/.size-1))
		endmethod

		static method create takes player p returns thistype
			local thistype this = GetPlayerId(p)
			call BlzTriggerRegisterPlayerKeyEvent(ESC_TRIGGER,p,OSKEY_ESCAPE,0,true)
			set .list = Array.create()
			return this
		endmethod

		static method onInit takes nothing returns nothing
			set ESC_TRIGGER = CreateTrigger()
			call TriggerAddCondition(ESC_TRIGGER,function thistype.act)
		endmethod

	endstruct

endlibrary