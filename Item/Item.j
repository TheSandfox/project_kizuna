library Item requires Frame

	globals
		private hashtable HASH = InitHashtable()
		private constant integer INDEX_NAME = 0
		private constant integer INDEX_ICON = 1
		private constant integer INDEX_DESC = 2
		private constant integer INDEX_SETNUM = 3
		private constant integer INDEX_ITEMTYPE = 4
		private constant integer INDEX_STACKABLE = 5
		private constant integer INDEX_CREATE_TRIGGER = 6

		string array ITEMTYPE_ICON
		string array ITEMTYPE_NAME

		private texttag ITEM_NAME_INDICATOR = null
		private trigger ITEM_NAME_INDICATOR_TRIGGER = null
	endglobals

	struct Shuffle extends Shuffle_prototype

		static method shuffleRandomStat takes nothing returns nothing
			call reset()
			call addValue(CONFIG_STAT_MAXHP)
			call addValue(CONFIG_STAT_MAXMP)
			call addValue(CONFIG_STAT_ATTACK)
			call addValue(CONFIG_STAT_DEFENSE)
			call addValue(CONFIG_STAT_MAGICPOWER)
			call addValue(CONFIG_STAT_RESISTANCE)
			call addValue(CONFIG_STAT_ACCURACY)
			call addValue(CONFIG_STAT_EVASION)
			call addValue(CONFIG_STAT_ARMOR_PENET)
			call addValue(CONFIG_STAT_MAGIC_PENET)
			call addValue(CONFIG_STAT_SPELL_BOOST)
			call addValue(CONFIG_STAT_LUCK)
			call addValue(CONFIG_STAT_HPREGEN)
			call addValue(CONFIG_STAT_MPREGEN)
		endmethod

	endstruct

	struct ItemTooltip extends array

		static thistype NORMAL = 0

		framehandle container
		framehandle backdrop_outline
		framehandle backdrop_box
		framehandle text

		/*PIXEL,BOTTOMRIGHT*/
		method setPoint takes framehandle pivot, framepointtype pfpt, real x, real y returns nothing
			call BlzFrameClearAllPoints(.text)
			call BlzFrameSetPoint(.text,FRAMEPOINT_BOTTOMRIGHT,pivot,pfpt,Math.px2Size(x)-0.005,Math.px2Size(y)+0.005)
		endmethod

		method show takes boolean flag returns nothing
			call BlzFrameSetVisible(.container,flag)
		endmethod

		static method create takes integer index returns thistype
			local thistype this = index
			set .container = BlzCreateFrameByType("FRAME","",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_TOOLTIP],"",0)
			set	.backdrop_outline = BlzCreateFrameByType("BACKDROP","",.container,"",0)
			call BlzFrameSetTexture(.backdrop_outline,"replaceabletextures\\teamcolor\\teamcolor16.blp",0,true)
			set .backdrop_box = BlzCreateFrameByType("BACKDROP","",.container,"",0)
			call BlzFrameSetTexture(.backdrop_box,"replaceabletextures\\teamcolor\\teamcolor24.blp",0,true)
			set .text = BlzCreateFrame("MyItemTooltip",.container,0,0)
			call BlzFrameSetTextAlignment(.text,TEXT_JUSTIFY_BOTTOM,TEXT_JUSTIFY_LEFT)
			call BlzFrameSetPoint(.text,FRAMEPOINT_BOTTOM,FRAME_ORIGIN,FRAMEPOINT_BOTTOM,0.,0.)
			//
			call BlzFrameSetPoint(.backdrop_outline,FRAMEPOINT_BOTTOMLEFT,.text,FRAMEPOINT_BOTTOMLEFT,-.005,-.005)
			call BlzFrameSetPoint(.backdrop_outline,FRAMEPOINT_TOPRIGHT,.text,FRAMEPOINT_TOPRIGHT,.005,.005)
			call BlzFrameSetPoint(.backdrop_box,FRAMEPOINT_BOTTOMLEFT,.text,FRAMEPOINT_BOTTOMLEFT,-.004,-.004)
			call BlzFrameSetPoint(.backdrop_box,FRAMEPOINT_TOPRIGHT,.text,FRAMEPOINT_TOPRIGHT,.004,.004)
			call BlzFrameSetVisible(.container,false)
			return this
		endmethod

		static method delayedInit takes nothing returns nothing
			call DestroyTrigger(GetTriggeringTrigger())
			/*DO NOT USE 0 INDEX*/
			set NORMAL = create(1)
		endmethod

		static method onInit takes nothing returns nothing
			local trigger t = CreateTrigger()
			call TriggerRegisterTimerEvent(t,0.01,false)
			call TriggerAddCondition(t,function thistype.delayedInit)
			set t = null
		endmethod

	endstruct

	struct Item extends Item_prototype

		static integer LAST_CREATED = 0

		integer tier = 0

		ItemTooltip tooltip = 0

		string description = ""

		static method getTypeName takes integer iid returns string
			return LoadStr(HASH,iid,INDEX_NAME)
		endmethod

		static method setTypeName takes integer iid, string nv returns nothing
			call SaveStr(HASH,iid,INDEX_NAME,nv)
		endmethod

		static method getTypeDesc takes integer iid returns string
			return LoadStr(HASH,iid,INDEX_DESC)
		endmethod

		static method setTypeDesc takes integer iid, string nv returns nothing
			call SaveStr(HASH,iid,INDEX_DESC,nv)
		endmethod

		static method getTypeIconPath takes integer iid returns string
			if HaveSavedString(HASH,iid,INDEX_ICON) then
				return LoadStr(HASH,iid,INDEX_ICON)
			else
				return "icons\\btnblackicon.blp"
			endif
		endmethod

		static method setTypeIconPath takes integer iid, string path returns nothing
			call SaveStr(HASH,iid,INDEX_ICON,path)
		endmethod

		static method getTypeSetNum takes integer iid returns integer
			if HaveSavedInteger(HASH,iid,INDEX_SETNUM) then
				return LoadInteger(HASH,iid,INDEX_SETNUM)
			else
				return -1
			endif
		endmethod

		static method setTypeSetNum takes integer iid, integer val returns nothing
			call SaveInteger(HASH,iid,INDEX_SETNUM,val)
		endmethod

		static method getUnitSetNum takes Unit_prototype target, integer setnum returns integer
			if HaveSavedInteger(HASH,target,setnum) then
				return LoadInteger(HASH,target,setnum)
			else
				return 0
			endif
		endmethod

		static method setUnitSetNum takes Unit_prototype target, integer setnum, integer val returns nothing
			call SaveInteger(HASH,target,setnum,val)
		endmethod

		static method getTypeItemType takes integer iid returns integer
			return LoadInteger(HASH,iid,INDEX_ITEMTYPE)
		endmethod

		static method setTypeItemType takes integer iid, integer it returns nothing
			call SaveInteger(HASH,iid,INDEX_ITEMTYPE,it)
		endmethod

		static method getTypeStackable takes integer iid returns boolean
			return LoadBoolean(HASH,iid,INDEX_STACKABLE)
		endmethod

		static method setTypeStackable takes integer iid, boolean b returns nothing
			call SaveBoolean(HASH,iid,INDEX_STACKABLE,b)
		endmethod

		static method getTypeCreateTrigger takes integer iid returns trigger
			return LoadTriggerHandle(HASH,iid,INDEX_CREATE_TRIGGER)
		endmethod

		static method setTypeCreateTrigger takes integer iid, trigger tr returns nothing
			call SaveTriggerHandle(HASH,iid,INDEX_CREATE_TRIGGER,tr)
		endmethod

		stub method getIconPath takes nothing returns string
			return getTypeIconPath(.id)
		endmethod

		method divide takes integer i returns thistype
			local Item nit = 0
			if .count <= 1 or i <= 0 then
				return 0
			endif
			set nit = new(.id)
			if i >= .count then
				set nit.count = .count - 1
				set .count = 1
			else
				set nit.count = i
				set .count = .count - i
			endif
			return nit
		endmethod
		
		stub method onUseCount takes integer i returns nothing

		endmethod

		method useCount takes integer i returns nothing
			if i <= 0 then
				return
			endif
			set .count = .count - i
			call onUseCount(i)
			if .count <= 0 then
				call destroy()
			endif
		endmethod

		stub method getExtraText takes nothing returns string
			return ""
		endmethod

		stub method getDialogText takes nothing returns string
			return "Tooltip Missing"
		endmethod

		stub method relativeTooltip takes nothing returns string
			return "Tooltip Missing"
		endmethod

		stub method onRightClick takes nothing returns boolean
			return true
		endmethod

		stub method onLeftClick takes nothing returns boolean
			return true
		endmethod

		stub method getDropName takes nothing returns string
			return CUSTOM_STRING_TIER_COLOR[getTypeTier(.id)]+.name +" x"+I2S(.count)
		endmethod
		
		method showTooltip takes nothing returns nothing
			if .tooltip > 0 then
				/*DO REFRESH*/
				call BlzFrameSetText(.tooltip.text,relativeTooltip())
				/**/
				call .tooltip.show(true)
			endif
		endmethod

		method hideTooltip takes nothing returns nothing
			if .tooltip > 0 then
				call .tooltip.show(false)
			endif
		endmethod

		method setTooltip takes ItemTooltip itip returns thistype
			set .tooltip = itip
			return this
		endmethod

		method initialize takes nothing returns nothing
			
		endmethod

		static method new takes integer iid returns thistype
			set LAST_CREATED = 0
			call TriggerEvaluate(getTypeCreateTrigger(iid))
			if LAST_CREATED > 0 then
				call thistype(LAST_CREATED).initialize()
			endif
			return LAST_CREATED
		endmethod

		method onDestroy takes nothing returns nothing
			set .tooltip = 0
		endmethod

		static method genericConfiguration takes integer iid, trigger trig, code cond, string name returns nothing  
			call setTypeCreateTrigger(iid,trig)
			call TriggerAddCondition(trig,Condition(cond))
			call setTypeName(iid,name)
		endmethod

		static method refreshItemNameIndicator takes player p returns nothing
			if GetLocalPlayer() == p then
				if BlzGetMouseFocusUnit() == null then
					call SetTextTagVisibility(ITEM_NAME_INDICATOR,false)
					return
				endif
				if GetUnitTypeId(BlzGetMouseFocusUnit()) != 'idum' then
					call SetTextTagVisibility(ITEM_NAME_INDICATOR,false)
					return
				endif
				call SetTextTagText(ITEM_NAME_INDICATOR,GetUnitName(BlzGetMouseFocusUnit()),0.02)
				call SetTextTagVisibility(ITEM_NAME_INDICATOR,true)
				call SetTextTagPos(ITEM_NAME_INDICATOR,GetUnitX(BlzGetMouseFocusUnit()),GetUnitY(BlzGetMouseFocusUnit()),65.)
			endif
		endmethod

		static method refreshItemNameCallback takes nothing returns nothing
			local integer i = 0
			if GetTriggerEventId() == EVENT_PLAYER_MOUSE_MOVE then
				call refreshItemNameIndicator(GetTriggerPlayer())
			elseif GetTriggerEventId() == EVENT_GAME_TIMER_EXPIRED then
				loop
					exitwhen i >= bj_MAX_PLAYERS
					call refreshItemNameIndicator(Player(i))
					set i = i + 1
				endloop
			endif
		endmethod

		static method onInit takes nothing returns nothing
			local integer i = 0
			/*INIT ITEM NAME INDICATOR*/
			set ITEM_NAME_INDICATOR = CreateTextTag()
			call SetTextTagPermanent(ITEM_NAME_INDICATOR,true)
			call SetTextTagVisibility(ITEM_NAME_INDICATOR,false)
			set ITEM_NAME_INDICATOR_TRIGGER = CreateTrigger()
			loop
				exitwhen i >= bj_MAX_PLAYERS
				call TriggerRegisterPlayerEvent(ITEM_NAME_INDICATOR_TRIGGER,Player(i),EVENT_PLAYER_MOUSE_MOVE)
				set i = i + 1
			endloop
			call TriggerRegisterTimerEvent(ITEM_NAME_INDICATOR_TRIGGER,0.05,true)
			call TriggerAddCondition(ITEM_NAME_INDICATOR_TRIGGER,function thistype.refreshItemNameCallback)
		endmethod

	endstruct

	struct ItemDynamicDrop

		Item it = 0
		Curve cv = 0
		timer main_timer = null
		Unit target = 0

		static method timerAction takes nothing returns nothing
			local thistype this = Timer.getData(GetExpiredTimer())
			set .cv.value = .cv.value + TIMER_TICK/.cv.overtime
			if .cv.value >= 1. then
				call destroy()
				return
			else
				if .target > 0 then
					call .cv.setX(1,.target.x)
					call .cv.setY(1,.target.y)
					call .cv.setZ(1,.target.z)
				endif
				set .it.x = .cv.x
				set .it.y = .cv.y
				set .it.z = .cv.z
			endif
		endmethod

		static method create takes Item it, real x1 , real y1, real x2, real y2, real overtime returns thistype
			local thistype this = allocate()
			set .it = it
			call .it.drop(x1,y1)
			call .it.showWidget(false)
			/*커브*/
			call LocationEx.collisionProjection(x2,y2)
			set x2 = LocationEx.X
			set y2 = LocationEx.Y
			set .cv = CurveBezier2.create(x1,y1,0.,x2,y2,0.)
			set .cv.overtime = overtime
			call CurveBezier2(.cv).setX(0,x1)
			call CurveBezier2(.cv).setY(0,y1)
			call CurveBezier2(.cv).setZ(0,0.)
			call CurveBezier2(.cv).setX(1,x2)
			call CurveBezier2(.cv).setY(1,y2)
			call CurveBezier2(.cv).setZ(1,0.)
			call CurveBezier2(.cv).setProjectedControlPoint(0,Math.distancePoints(x1,y1,x2,y2),GetRandomReal(800,1000),GetRandomReal(75,105))
			set .main_timer = Timer.new(this)
			call Timer.start(.main_timer,TIMER_TICK,true,function thistype.timerAction)
			return this
		endmethod

		method onDestroy takes nothing returns nothing
			call .it.showWidget(true)
			set .it.z = 0.
			call Timer.release(.main_timer)
			set .main_timer = null
			call .cv.destroy()
			if .target > 0 then
				call .it.pick(.target)
			endif
			set .target = 0
		endmethod

	endstruct

endlibrary