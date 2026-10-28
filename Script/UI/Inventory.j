library Inventory requires UI, User

	globals
		private constant integer PER_ROW = 8
		private constant integer PER_COL = 4
		public constant integer SLOT = PER_ROW * PER_COL
		private constant integer CATEGORY = 8
		private constant integer INSET_Y = 40
		private constant integer SIZE = 48
		trigger INVENTORY_CLICK_TRIGGER = CreateTrigger()
		integer INVENTORY_CLICK_INDEX = -1
		integer INVENTORY_CLICK_BUTTON = 0	/*0LEFT, 1RIGHT*/
		player INVENTORY_CLICK_PLAYER = null
		player INVENTORY_ITEM_USE_PLAYER = null

		private boolean INVENTORY_ITEM_MERGE = true

		private trigger INVENTORY_ICON_RESET_FOCUS = CreateTrigger()
		private trigger INVENTORY_GENERIC_FRAME_TRIGGER = CreateTrigger()
		private framehandle INVENTORY_CLOSE_BUTTON = null
		private framehandle array INVENTORY_ICON_ICON
		private framehandle array INVENTORY_ICON_TIER_BORDER
		private framehandle array INVENTORY_ICON_BTN
		private framehandle array INVENTORY_ICON_EXTRA_BACKDROP
		private framehandle array INVENTORY_ICON_EXTRA_TEXT
	endglobals

	struct Inventory_prototype extends array

		static integer array DISABLE_DROP

		static method onInit takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen i >= CONFIG_PLAYER_MAX
				set DISABLE_DROP[i] = 0
				set i = i + 1
			endloop
		endmethod

	endstruct

	struct InventoryIcon extends array

		integer index

		Item target
		ItemTooltip tooltip
		player owner

		trigger main_trigger
		triggercondition main_cond
		boolean in

		method showTooltip takes nothing returns nothing
			if .target > 0 then
				set .tooltip = .target.tooltip
				if GetLocalPlayer() == .owner and .tooltip > 0 then
					call .tooltip.setPoint(INVENTORY_ICON_BTN[.index],FRAMEPOINT_BOTTOMLEFT,0.,0.)
					call .target.showTooltip()
				endif
			endif
		endmethod

		method hideTooltip takes nothing returns nothing
			if .tooltip > 0 then
				if GetLocalPlayer() == .owner then
					call .tooltip.show(false)
				endif
			endif
		endmethod

		method setTarget takes Item target returns nothing
			local string s = ""
			if GetLocalPlayer() == .owner then
				call BlzFrameSetVisible(INVENTORY_ICON_TIER_BORDER[.index],false)
				call BlzFrameSetVisible(INVENTORY_ICON_EXTRA_BACKDROP[.index],false)
				call BlzFrameSetVisible(INVENTORY_ICON_EXTRA_TEXT[.index],false)
			endif
			if target <= 0 then
				if GetLocalPlayer() == .owner then
					call BlzFrameSetTexture(INVENTORY_ICON_ICON[.index],"icons\\btnblackicon.blp",0,true)
					call BlzFrameSetAlpha(INVENTORY_ICON_ICON[.index],64)
				endif
				/*트리거&프레임 비활성화*/
				set .in = false
				if GetLocalPlayer() == .owner then
					call BlzFrameSetVisible(INVENTORY_ICON_BTN[.index],false)
				endif
				call DisableTrigger(.main_trigger)
				call hideTooltip()
			else
				/*아이콘*/
				if GetLocalPlayer() == .owner then
					call BlzFrameSetTexture(INVENTORY_ICON_ICON[.index],target.getIconPath(),0,true)
					call BlzFrameSetAlpha(INVENTORY_ICON_ICON[.index],255)
					call BlzFrameSetVisible(INVENTORY_ICON_TIER_BORDER[.index],true)
					call BlzFrameSetTexture(INVENTORY_ICON_TIER_BORDER[.index],"Textures\\ability_border_tier"+I2S(target.getTier())+".blp",0,true)
				endif
				set .tooltip = target.tooltip
				/*엑스트라텍스트*/
				set s = AbilityShard(target).getExtraText()
				if s != "" and GetLocalPlayer() == .owner then
					call BlzFrameSetVisible(INVENTORY_ICON_EXTRA_BACKDROP[.index],true)
					call BlzFrameSetVisible(INVENTORY_ICON_EXTRA_TEXT[.index],true)
					call BlzFrameSetText(INVENTORY_ICON_EXTRA_TEXT[.index],s)
				endif
				/*트리거&프레임 활성화*/
				if GetLocalPlayer() == .owner then
					call BlzFrameSetVisible(INVENTORY_ICON_BTN[.index],true)
				endif
				call EnableTrigger(.main_trigger)
			endif
			set .target = target
		endmethod

		static method cond takes nothing returns nothing
			local thistype this = Trigger.getData(GetTriggeringTrigger())
			if GetTriggerPlayer() != .owner then
				return
			endif
			if BlzGetTriggerFrameEvent() == FRAMEEVENT_MOUSE_ENTER then
				call showTooltip()
				set .in = true
				return
			elseif BlzGetTriggerFrameEvent() == FRAMEEVENT_MOUSE_LEAVE then
				call BlzFrameResetFocus(BlzGetTriggerFrame(),.owner)
				call hideTooltip()
				set .in = false
				return
			elseif BlzGetTriggerFrameEvent() == FRAMEEVENT_CONTROL_CLICK then
				call BlzFrameResetFocus(BlzGetTriggerFrame(),.owner)
				set INVENTORY_CLICK_INDEX = .index
				set INVENTORY_CLICK_PLAYER = .owner
				set INVENTORY_CLICK_BUTTON = 0
				call TriggerEvaluate(INVENTORY_CLICK_TRIGGER)
				return
			elseif .in and BlzGetTriggerPlayerMouseButton() == MOUSE_BUTTON_TYPE_RIGHT then
				if .target > 0 then
					/*SHIFT우클릭 : 나누기*/
					if User.getKeyState(.owner,OSKEY_LSHIFT) then
						if .target.count > 1 then
							call Numberpad(GetPlayerId(.owner)).open("INV_DIV#"+I2S(.target))
							call Numberpad(GetPlayerId(.owner)).setPoint(FRAMEPOINT_RIGHT,INVENTORY_ICON_ICON[.index],FRAMEPOINT_RIGHT,0.,0.)
							call Numberpad(GetPlayerId(.owner)).setInitialValue("1")
						endif
						return
					/*CONTROL우클릭 : 떨구기*/
					elseif User.getKeyState(.owner,OSKEY_LCONTROL) then
						if Inventory_prototype.DISABLE_DROP[GetPlayerId(.owner)] <= 0 then
							/*인벤토리의 드롭 기능이 활성화 시에만*/
							call Numberpad.customSummit(.owner,"INV_DROP",I2S(.index))
						endif
						return
					/*그냥 우클릭 : 사용요청*/
					else
						set INVENTORY_CLICK_INDEX = .index
						set INVENTORY_CLICK_PLAYER = .owner
						set INVENTORY_CLICK_BUTTON = 1
						call TriggerEvaluate(INVENTORY_CLICK_TRIGGER)
						return
					endif
					return
				endif
			endif
		endmethod

		static method create takes player owner, integer index returns thistype
			local thistype this = GetPlayerId(owner)*SLOT + index
			set .index = index
			set .owner = owner
			set .target = -1
			set .in = false
			set .main_trigger = Trigger.new(this)
			set .main_cond = TriggerAddCondition(.main_trigger,function thistype.cond)
			call BlzTriggerRegisterFrameEvent(.main_trigger,INVENTORY_ICON_BTN[.index],FRAMEEVENT_MOUSE_ENTER)
			call BlzTriggerRegisterFrameEvent(.main_trigger,INVENTORY_ICON_BTN[.index],FRAMEEVENT_MOUSE_LEAVE)
			call BlzTriggerRegisterFrameEvent(.main_trigger,INVENTORY_ICON_BTN[.index],FRAMEEVENT_CONTROL_CLICK)
			call TriggerRegisterPlayerEvent(.main_trigger,.owner,EVENT_PLAYER_MOUSE_DOWN)
			//
			call setTarget(0)
			return this
		endmethod

		method destroy takes nothing returns nothing
			//! runtextmacro destroyTriggerAndCondition(".main_trigger",".main_cond")
			set .owner = null
		endmethod

	endstruct

	private struct ItemList

		delegate Array list

		integer inventory_address = 0

		method add takes integer val returns nothing
			local Item it = Item(val)
			call .list.add(val)
			set it.index = .size-1
			set it.address1 = ItemAddress.INVENTORY
			set it.address2 = .inventory_address
		endmethod

		static method create takes integer address returns thistype
			local thistype this = allocate()
			set .inventory_address = address
			set .list = Array.create()
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			call .list.destroy()
		endmethod

	endstruct

	private struct Inventories

		delegate Array list

		method remove takes integer val returns nothing
			call ItemList(val).destroy()
			call .list.remove(val)
		endmethod

		static method create takes nothing returns thistype
			local thistype this = allocate()
			set .list = Array.create()
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			call .list.destroy()
		endmethod

	endstruct

	struct Inventory extends array

		private static hashtable HASH = InitHashtable()

		static integer CATEGORY_MATERIAL 	= 0
		static integer CATEGORY_ARTIFACT 	= 1

		static constant integer DIALOG_WIDTH = 480
		static constant integer DIALOG_HEIGHT = 192

		trigger keypress
		triggercondition keypress_cond
		boolean visible_flag
		integer category
		/*컨테이너*/
		framehandle container
		/*마우스가리개*/
		framehandle mouseover_above
		/*Dialog*/
		framehandle dialog_backdrop
		framehandle dialog_text
		framehandle dialog_btn_confirm
		framehandle dialog_btn_cancle
		boolean dialog_visible
		integer dialog_category
		integer dialog_index
		/*인벤토리 리스트(ItemList들을 담고있는 ArrayList)*/
		Inventories inventories
		/**/

		method operator owner takes nothing returns player
			return Player(this)
		endmethod

		method disableDrop takes nothing returns nothing
			set Inventory_prototype.DISABLE_DROP[this] = Inventory_prototype.DISABLE_DROP[this] + 1
		endmethod

		method enableDrop takes nothing returns nothing
			set Inventory_prototype.DISABLE_DROP[this] = Inventory_prototype.DISABLE_DROP[this] - 1
		endmethod

		/*method setItem takes integer category, integer index, Item it returns nothing
			call .inventories.get(category).add(it)
			call SaveInteger(HASH,this,index+category*SLOT,it)
			if it > 0 then
				set it.index = index+category*SLOT
				set it.address1 = ItemAddress.INVENTORY
				set it.address2 = this
			endif
		endmethod*/

		method getItem takes integer category, integer index returns Item
			return ItemList(.inventories.getValue(category)).getValue(index)
			/*if index < 0 then
				return 0
			endif
			if HaveSavedInteger(HASH,this,index+category*SLOT) then
				return LoadInteger(HASH,this,index+category*SLOT)
			else
				return 0
			endif*/
		endmethod

		method spaceExists takes integer category returns boolean
			return ItemList(.inventories.getValue(category)).size < SLOT
			/*return getItem(category,SLOT-1) == 0*/
		endmethod

		method getItemIndexById takes integer iid returns integer
			local integer cat = 0// Item.getTypeItemType(iid)
			local integer i = 0
			local Item it = 0
			loop
				exitwhen i >= SLOT
				set it = getItem(cat,i)
				if it > 0 then
					if it.id == iid then
						return i
					endif
				endif
				set i = i + 1
			endloop
			return -1
		endmethod

		method closeDialog takes nothing returns nothing
			set .dialog_category = -1
			set .dialog_index = -1
			call BlzFrameSetVisible(.dialog_backdrop,false)
			call BlzFrameSetVisible(.mouseover_above,false)
			if .dialog_visible then
				/*CLOSEUI*/
				call CloseUI(this).eraseFor(CloseUI.ORDER_INVENTORY_DIALOG)
			endif
			set .dialog_visible = false
		endmethod

		method useRequest takes integer category, integer index, integer buttontype returns nothing
			set INVENTORY_ITEM_USE_PLAYER = .owner
			set AbilityShard.USER = .owner
			if buttontype == 0 then
				call getItem(category,index).onLeftClick()
			else
				call getItem(category,index).onRightClick()
			endif
		endmethod

		method dialogConfirm takes nothing returns nothing
			if .dialog_category < 0 or .dialog_index < 0 then
				return
			endif
			call useRequest(.dialog_category,.dialog_index,0)
		endmethod

		method showDialog takes integer category, integer index returns nothing
			set .dialog_category = category
			set .dialog_index = index
			call getIcon(index).hideTooltip()
			call BlzFrameSetText(.dialog_text,getItem(.dialog_category,.dialog_index).getDialogText())
			call BlzFrameSetVisible(.dialog_backdrop,GetLocalPlayer() == Player(this))
			call BlzFrameSetVisible(.mouseover_above,GetLocalPlayer() == Player(this))
			if not .dialog_visible then
				/*CLOSEUI*/
				call CloseUI(this).add(CloseUI.ORDER_INVENTORY_DIALOG)
			endif
			set .dialog_visible = true
		endmethod

		/*아이콘 타겟을 갱신하는 용도*/
		private method refreshIcons takes integer category, integer from returns nothing
			local integer i = from
			local Item it = -1
			if .category != category then
				return
			endif
			loop
				set it = getItem(category,i)
				exitwhen i >= SLOT
				call getIcon(i).setTarget(it)
				set i = i + 1
			endloop
		endmethod

		method pull takes integer category, integer index returns nothing
			call ItemList(.inventories.getValue(category)).remove(index)
			call refreshIcons(category,index)
		endmethod

		method refresh takes nothing returns nothing
			call refreshIcons(.category,0)
		endmethod

		method drop takes integer index returns nothing
			local Item it = getItem(.category,index)
			if it > 0 then
				call it.drop(User.getFocusUnit(.owner).x,User.getFocusUnit(.owner).y)
				//call setItem(.category,index,0)
				call pull(.category,index)
			else
			endif
		endmethod

		method addItem takes Item it returns boolean
			local integer i = 0
			local integer iidx = 0
			local integer category = 0// Item.getTypeItemType(it.id)
			/*아이템 합치는 로직 임시 비활성화(어빌 파편만 다룰거라서)*/
			// if Item.getTypeStackable(it.id) and INVENTORY_ITEM_MERGE then
			// 	set iidx = getItemIndexById(it.id)
			// 	if iidx > -1 then
			// 		call it.merge(getItem(category,iidx))
			// 		if category == .category then
			// 			call getIcon(iidx).setTarget(getItem(category,iidx))
			// 		endif
			// 		call refreshIcons(category,0)
			// 		return true
			// 	endif
			// endif
			if spaceExists(category) then
				call ItemList(.inventories.getValue(category)).add(it)
				call refreshIcons(category,0)
				return true
			else
				call it.drop(User.getFocusUnit(.owner).x,User.getFocusUnit(.owner).y)
				call refreshIcons(category,0)
				return false
			endif
			return false
		endmethod

		method divide takes Item it, integer count returns boolean
			local Item nit = 0
			local integer cat = 0
			local integer tidx = -1
			if it <= 0 then
				return true
			endif
			if it.count <= 1 then
				return true
			endif
			set cat = 0// Item.getTypeItemType(it.id)
			set tidx = getItemIndexById(it.id)
			if tidx > -1 then
				set nit = it.divide(count)
				if nit > 0 then
					set INVENTORY_ITEM_MERGE = false
					call addItem(nit)
					set INVENTORY_ITEM_MERGE = true
					call refreshIcons(cat,0)
					return true
				else
					return false
				endif
			endif
			return true
		endmethod

		method changeCategory takes integer category returns nothing
			local integer i = 0
			if .dialog_visible then
				return
			endif
			if category != .category then
				loop
					exitwhen i >= 1/*ITEMTYPE_MAX*/
					if GetLocalPlayer() == Player(this) then
						call BlzFrameSetVisible(FRAME_INVENTORY_CATEGORY_HIGHTLIGHT[i], i == category)
					endif
					set i = i + 1
				endloop
				set i = 0
				loop
					exitwhen i >= SLOT
					call getIcon(i).setTarget(getItem(category,i))
					set i = i + 1
				endloop
			endif
			set .category = category
		endmethod

		method getIcon takes integer index returns InventoryIcon
			return InventoryIcon(this*SLOT+index)
		endmethod

		/*method consume takes integer iid, integer count returns nothing*/
			/*local Item it = 0
			local integer category = 0
			local integer index = 0
			if iid <= 0 or count <= 0 then
				return
			endif
			set category = Item.getTypeItemType(iid)
			set index = getItemIndexById(iid)
			set it = getItem(category,index)
			if it <= 0 then
				return
			endif
			if it.count <= count then
				call it.useCount(count)
				call pull(category,index)
			else
				call it.useCount(count)
				if .category == category then
					call getIcon(index).setTarget(it)
				endif
			endif*/
		/*endmethod*/

		static method consumeRespond takes nothing returns nothing
			local thistype this = 0
			local integer cat = 0
			local integer index = 0
			if CUSTOM_RESPOND_ITEM_DESTROY_ADDRESS1 != ItemAddress.INVENTORY then
				return
			endif
			set this = CUSTOM_RESPOND_ITEM_DESTROY_ADDRESS2
			set cat = 0 //Item.getTypeItemType(Item(CUSTOM_RESPOND_ITEM_DESTROY_ITEM).id)
			set index = ItemList(.inventories.getValue(cat)).seek(CUSTOM_RESPOND_ITEM_DESTROY_ITEM)
			if index > -1 then
				call pull(cat,index)
			endif
		endmethod

		method visibleForPlayer takes boolean flag returns nothing
			if .visible_flag != flag then
				if flag then
					/*CLOSEUI*/
					call CloseUI(this).add(CloseUI.ORDER_INVENTORY)
				else
					/*CLOSEUI*/
					call CloseUI(this).eraseFor(CloseUI.ORDER_INVENTORY)
				endif
			endif
			set .visible_flag = flag
			if GetLocalPlayer()==.owner then
				call BlzFrameSetVisible(FRAME_INVENTORY,flag)
			endif
			if .visible_flag then
				//TODO REFRESH
			else
				call closeDialog()
			endif
		endmethod

		method switch takes nothing returns nothing
			call visibleForPlayer(not .visible_flag)
		endmethod

		method close takes nothing returns boolean
			if .visible_flag then
				if .dialog_visible then
					call closeDialog()
					return true
				else
					call visibleForPlayer(false)
					return true
				endif
			endif
			return false
		endmethod

		static method press takes nothing returns nothing
			local thistype this = Trigger.getData(GetTriggeringTrigger())
			if Event.getValue() == ENUM_EVENT_KEYPRESS then
				if CUSTOM_RESPOND_KEYPRESS_PLAYER != .owner then
					return
				endif
				if CUSTOM_RESPOND_KEYPRESS_KEY == OSKEY_B and CUSTOM_RESPOND_KEYPRESS_PRESS then
					call switch()
					return
				endif
				return
			endif
			if BlzGetTriggerFrame() != null then
				call BlzFrameSetEnable(BlzGetTriggerFrame(),false)
				call BlzFrameSetEnable(BlzGetTriggerFrame(),true)
				if BlzGetTriggerFrameEvent() == FRAMEEVENT_CONTROL_CLICK then
					if BlzGetTriggerFrame() == .dialog_btn_confirm then
						call dialogConfirm()
					elseif BlzGetTriggerFrame() == .dialog_btn_cancle then
						call closeDialog()
					endif
				endif
				return 
			endif
		endmethod

		static method create takes player p returns thistype
			local thistype this = GetPlayerId(p)
			local integer i = 0
			/*트리거*/
			set .visible_flag = false
			set .dialog_visible = false
			set .keypress = Trigger.new(this)
			call Event.register(.keypress,ENUM_EVENT_KEYPRESS)
			set .keypress_cond = TriggerAddCondition(.keypress,function thistype.press)
			/*아이콘*/
			loop
				exitwhen i >= SLOT
				call InventoryIcon.create(p,i)
				set i = i + 1
			endloop
			/*마우스오버*/
			set .mouseover_above = BlzCreateFrameByType("FRAME","",FRAME_INVENTORY,"",0)
			call BlzFrameSetAllPoints(.mouseover_above,FRAME_INVENTORY)
			call BlzFrameSetVisible(.mouseover_above,false)
			/*다이얼로그*/
			set .dialog_backdrop = BlzCreateFrame("MBEdge",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_POPUP],0,0)
			call BlzFrameSetPoint(.dialog_backdrop,FRAMEPOINT_CENTER,FRAME_ORIGIN,FRAMEPOINT_CENTER,0.,0.)
			call BlzFrameSetSizePixel(.dialog_backdrop,DIALOG_WIDTH,DIALOG_HEIGHT)
			call closeDialog()
			set .dialog_text = BlzCreateFrame("MyText",.dialog_backdrop,0,0)
			call BlzFrameSetPointPixel(.dialog_text,FRAMEPOINT_TOPLEFT,.dialog_backdrop,FRAMEPOINT_TOPLEFT,32,-32)
			call BlzFrameSetPointPixel(.dialog_text,FRAMEPOINT_BOTTOMRIGHT,.dialog_backdrop,FRAMEPOINT_BOTTOMRIGHT,-32,32)
			call BlzFrameSetTextAlignment(.dialog_text,TEXT_JUSTIFY_TOP,TEXT_JUSTIFY_CENTER)
			set .dialog_btn_confirm = BlzCreateFrame("InventoryDialogConfirmButton",.dialog_backdrop,0,0)
			call BlzFrameSetPointPixel(.dialog_btn_confirm,FRAMEPOINT_BOTTOMRIGHT,.dialog_backdrop,FRAMEPOINT_BOTTOM,-16,16)
			call BlzFrameSetSizePixel(.dialog_btn_confirm,192,48)
			call BlzTriggerRegisterFrameEvent(.keypress,.dialog_btn_confirm,FRAMEEVENT_CONTROL_CLICK)
			call BlzTriggerRegisterFrameEvent(.keypress,.dialog_btn_confirm,FRAMEEVENT_MOUSE_ENTER)
			call BlzTriggerRegisterFrameEvent(.keypress,.dialog_btn_confirm,FRAMEEVENT_MOUSE_LEAVE)
			set .dialog_btn_cancle = BlzCreateFrame("InventoryDialogCancleButton",.dialog_backdrop,0,0)
			call BlzFrameSetPointPixel(.dialog_btn_cancle,FRAMEPOINT_BOTTOMLEFT,.dialog_backdrop,FRAMEPOINT_BOTTOM,16,16)
			call BlzFrameSetSizePixel(.dialog_btn_cancle,192,48)
			call BlzTriggerRegisterFrameEvent(.keypress,.dialog_btn_cancle,FRAMEEVENT_CONTROL_CLICK)
			call BlzTriggerRegisterFrameEvent(.keypress,.dialog_btn_cancle,FRAMEEVENT_MOUSE_ENTER)
			call BlzTriggerRegisterFrameEvent(.keypress,.dialog_btn_cancle,FRAMEEVENT_MOUSE_LEAVE)
			/*리스트 생성*/
			set .inventories = Inventories.create()
			set i = 0
			loop
				exitwhen i >= CATEGORY
				call .inventories.add(ItemList.create(this))
				set i = i + 1
			endloop
			/*테스트용*/
			/* if .owner == Player(0) then
				call addItem(Item.new('a000'))
				call addItem(Item.new('a001'))
				call addItem(Item.new('a002'))
				call addItem(Item.new('a003'))
				call addItem(Item.new('m000'))
				call addItem(Item.new('m100'))
				call addItem(Item.new('m200'))
				call addItem(Item.new('m307'))
			endif
			if .owner == Player(1) then

			endif */
			/*call Item.new('m000').drop(0,-300)
			call Item.new('m000').drop(0,-300)
			call Item.new('m000').drop(0,-300)
			call Item.new('m000').drop(0,-300)*/
			/*디폴트 카테고리*/
			call changeCategory(CATEGORY_MATERIAL)
			return this
		endmethod

		method destroy takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen i >= SLOT
				call getIcon(i).destroy()
				set i = i + 1
			endloop
			//! runtextmacro destroyFrame(".container")
			//! runtextmacro destroyFrame(".dialog_backdrop")
			//! runtextmacro destroyFrame(".dialog_text")
			//! runtextmacro destroyFrame(".dialog_btn_confirm")
			//! runtextmacro destroyFrame(".dialog_btn_cancle")
			//! runtextmacro destroyFrame(".mouseover_above")
			//! runtextmacro destroyTriggerAndCondition(".keypress",".keypress_cond")
		endmethod

		static method rightClickRequest takes nothing returns nothing
			local thistype this = thistype(GetPlayerId(INVENTORY_CLICK_PLAYER))
			call useRequest(.category,INVENTORY_CLICK_INDEX,INVENTORY_CLICK_BUTTON)
		endmethod

		/*Item.pick(유닛)의 콜백*/
		static method itemPick takes nothing returns nothing
			local Unit picker = Unit(CUSTOM_RESPOND_ITEM_PICK_UNIT)
			local thistype this = GetPlayerId(picker.owner)
			local Item it = CUSTOM_RESPOND_ITEM_PICK_ITEM
			/*포커스 유닛이 주운게 아니면 인벤으로 안들어감*/
			if it <= 0 or User.getFocusUnit(picker.owner) != picker then
				set CUSTOM_RESPOND_ITEM_PICK_RESULT = false
				return
			endif
			/*자리없으면 떨구는 코드 내장돼있음*/
			call addItem(it)
			set CUSTOM_RESPOND_ITEM_PICK_RESULT = true
		endmethod

		static method numberpadSummit takes nothing returns nothing
			if NUMBERPAD_REFINED_PREFIX == "INV_DIV" then
				set NUMBERPAD_SUMMIT_RESULT = thistype(GetPlayerId(NUMBERPAD_SUMMIT_PLAYER)).divide(Item(S2I(NUMBERPAD_REFINED_SUBFIX)),S2I(NUMBERPAD_SUMMIT_VALUE))
				return
			endif
			if NUMBERPAD_SUMMIT_PREFIX == "INV_DROP" then
				call thistype(GetPlayerId(NUMBERPAD_SUMMIT_PLAYER)).drop(S2I(NUMBERPAD_SUMMIT_VALUE))
				return
			endif
			if NUMBERPAD_REFINED_PREFIX == "INV_DIVDROP" then
				call thistype(GetPlayerId(NUMBERPAD_SUMMIT_PLAYER)).divide(Item(S2I(NUMBERPAD_REFINED_SUBFIX)),1)
				return
			endif
		endmethod

		static method genericFrameCallback takes nothing returns nothing
			local thistype this = GetPlayerId(GetTriggerPlayer())
			if BlzGetTriggerFrame() == INVENTORY_CLOSE_BUTTON then
				call close()
				return
			endif
		endmethod

		static method onInit takes nothing returns nothing
			call TriggerAddCondition(INVENTORY_CLICK_TRIGGER,function thistype.rightClickRequest)
			call TriggerAddCondition(NUMBERPAD_SUMMIT_TRIGGER,function thistype.numberpadSummit)
		endmethod

		static method init takes nothing returns nothing
			local integer i = 0
			local trigger t = null
			set INVENTORY_CLOSE_BUTTON = BlzCreateFrame("GenericCloseButton",FRAME_INVENTORY,0,0)
			call BlzFrameSetPointPixel(INVENTORY_CLOSE_BUTTON,FRAMEPOINT_TOPRIGHT,FRAME_INVENTORY,FRAMEPOINT_TOPRIGHT,-16,-16)
			//! runtextmacro triggerRegisterFrameEventSimple("INVENTORY_ICON_RESET_FOCUS","INVENTORY_CLOSE_BUTTON")
			call BlzTriggerRegisterFrameEvent(INVENTORY_GENERIC_FRAME_TRIGGER,INVENTORY_CLOSE_BUTTON,FRAMEEVENT_CONTROL_CLICK)
			loop
				exitwhen i >= SLOT
				set INVENTORY_ICON_ICON[i] = BlzCreateFrameByType("BACKDROP","",FRAME_INVENTORY,"",0)
				call BlzFrameSetPointPixel(INVENTORY_ICON_ICON[i],FRAMEPOINT_TOPLEFT,FRAME_INVENTORY,FRAMEPOINT_TOPLEFT,32+ModuloInteger(i,PER_ROW)*SIZE,-32-INSET_Y-R2I(i/PER_ROW)*SIZE)
				call BlzFrameSetSizePixel(INVENTORY_ICON_ICON[i],SIZE,SIZE)
				set INVENTORY_ICON_TIER_BORDER[i] = BlzCreateFrameByType("BACKDROP","",INVENTORY_ICON_ICON[i],"",0)
				call BlzFrameSetAllPoints(INVENTORY_ICON_TIER_BORDER[i],INVENTORY_ICON_ICON[i])
				set INVENTORY_ICON_EXTRA_BACKDROP[i] = BlzCreateFrameByType("BACKDROP","",INVENTORY_ICON_ICON[i],"",0)
				call BlzFrameSetAlpha(INVENTORY_ICON_EXTRA_BACKDROP[i],128)
				call BlzFrameSetTexture(INVENTORY_ICON_EXTRA_BACKDROP[i],"textures\\black32.blp",0,true)
				set INVENTORY_ICON_EXTRA_TEXT[i] = BlzCreateFrame("MyTextSmall",INVENTORY_ICON_ICON[i],0,0)
				call BlzFrameSetPointPixel(INVENTORY_ICON_EXTRA_TEXT[i],FRAMEPOINT_BOTTOMRIGHT,INVENTORY_ICON_ICON[i],FRAMEPOINT_BOTTOMRIGHT,-2,2)
				call BlzFrameSetPointPixel(INVENTORY_ICON_EXTRA_BACKDROP[i],FRAMEPOINT_BOTTOMRIGHT,INVENTORY_ICON_EXTRA_TEXT[i],FRAMEPOINT_BOTTOMRIGHT,2,-2)
				call BlzFrameSetPointPixel(INVENTORY_ICON_EXTRA_BACKDROP[i],FRAMEPOINT_TOPLEFT,INVENTORY_ICON_EXTRA_TEXT[i],FRAMEPOINT_TOPLEFT,-2,2)
				call BlzFrameSetVisible(INVENTORY_ICON_EXTRA_BACKDROP[i],false)
				call BlzFrameSetVisible(INVENTORY_ICON_EXTRA_TEXT[i],false)
				set INVENTORY_ICON_BTN[i] = BlzCreateFrameByType("BUTTON","",FRAME_INVENTORY,"",0)
				call BlzFrameSetAllPoints(INVENTORY_ICON_BTN[i],INVENTORY_ICON_ICON[i])
				call BlzTriggerRegisterFrameEvent(INVENTORY_ICON_RESET_FOCUS,INVENTORY_ICON_BTN[i],FRAMEEVENT_MOUSE_ENTER)
				call BlzTriggerRegisterFrameEvent(INVENTORY_ICON_RESET_FOCUS,INVENTORY_ICON_BTN[i],FRAMEEVENT_MOUSE_LEAVE)
				call BlzTriggerRegisterFrameEvent(INVENTORY_ICON_RESET_FOCUS,INVENTORY_ICON_BTN[i],FRAMEEVENT_CONTROL_CLICK)
				set i = i + 1
			endloop
			call TriggerAddCondition(INVENTORY_ICON_RESET_FOCUS,function Frame.resetFocus)
			call TriggerAddCondition(INVENTORY_GENERIC_FRAME_TRIGGER,function thistype.genericFrameCallback)
			set t = CreateTrigger()
			call Event.register(t,ENUM_EVENT_ITEM_DESTROY)
			call TriggerAddCondition(t,function thistype.consumeRespond)
			set t = CreateTrigger()
			call Event.register(t,ENUM_EVENT_ITEM_PICK)
			call TriggerAddCondition(t,function thistype.itemPick)
			set t = null
		endmethod	

	endstruct

endlibrary