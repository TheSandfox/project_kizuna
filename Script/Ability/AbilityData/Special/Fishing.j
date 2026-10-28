scope Ability2080 initializer init

		//! runtextmacro abilityParam2080()

		globals
			private constant string EFFECT_PATH1 = "Abilities\\Spells\\Orc\\Ensnare\\EnsnareMissile.mdl"
			private constant string EFFECT_PATH2 = "Abilities\\Weapons\\WaterElementalMissile\\WaterElementalMissile.mdl"
			private constant string EFFECT_PATH3 = "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl"
			private constant string EFFECT_PATH4 = "Doodads\\Ruins\\Water\\BubbleGeyser\\BubbleGeyser"
		endglobals

		private struct ui extends array

			static constant integer WIDTH = 480
			static constant integer HEIGHT = 16
			static constant integer OFFSET_Y = 336-96/*FROM BOTTOM*/
			static constant integer INSET = 10
			static constant integer INSET2 = 6

			boolean activated
			framehandle container
			framehandle field
			framehandle cursor
			framehandle gauge_backdrop
			framehandle gauge_fill

			method refreshGauge takes real r returns nothing
				call BlzFrameSetVisible(.gauge_fill,r>=0.05)
				call BlzFrameSetSizePixel(.gauge_fill,r*WIDTH,HEIGHT/2)
			endmethod

			method adjustCursor takes real r returns nothing
				call BlzFrameSetPointPixel(.cursor,FRAMEPOINT_CENTER,.container,FRAMEPOINT_LEFT,r*WIDTH+INSET,0.)
			endmethod

			method adjustField takes real r, real width returns nothing
				call BlzFrameSetPointPixel(.field,FRAMEPOINT_CENTER,.container,FRAMEPOINT_LEFT,r*WIDTH+INSET,0.)
				call BlzFrameSetSizePixel(.field,width*2.*WIDTH,HEIGHT)
			endmethod

			method init takes nothing returns nothing
				set .container 	= 	BlzCreateFrame("MBEdge",FRAME_GAME_UI[CONFIG_FRAME_LEVEL_BASIC],0,this)
				set .field 		= 	BlzCreateFrameByType("BACKDROP","",.container,"",this)
				set .cursor		=	BlzCreateFrameByType("BACKDROP","",.container,"",this)
				set .gauge_backdrop	=	BlzCreateFrame("MyTextBox",.container,0,this)
				set .gauge_fill		=	BlzCreateFrameByType("BACKDROP","",.container,"",this)
				call BlzFrameSetPointPixel(.container,FRAMEPOINT_CENTER,FRAME_ORIGIN,FRAMEPOINT_BOTTOM,-INSET,OFFSET_Y)
				call BlzFrameSetSizePixel(.container,WIDTH+INSET*2,HEIGHT+INSET*2)
				//call BlzFrameSetTexture(.container,"replaceabletextures\\teamcolor\\teamcolor08.blp",0,true)
				call BlzFrameSetPointPixel(.field,FRAMEPOINT_CENTER,.container,FRAMEPOINT_LEFT,0.,0.)
				call BlzFrameSetSizePixel(.field,96,HEIGHT)
				call BlzFrameSetTexture(.field,"replaceabletextures\\teamcolor\\teamcolor17.blp",0,true)
				call BlzFrameSetPointPixel(.cursor,FRAMEPOINT_CENTER,.container,FRAMEPOINT_LEFT,0.,0.)
				call BlzFrameSetSizePixel(.cursor,HEIGHT*2,HEIGHT*2)
				call BlzFrameSetTexture(.cursor,"ui\\widgets\\escmenu\\human\\radiobutton-backgroundpressed.blp",0,true)
				call BlzFrameSetVisible(.container,false)
				call BlzFrameSetPointPixel(.gauge_backdrop,FRAMEPOINT_TOP,.container,FRAMEPOINT_BOTTOM,0.,-INSET+INSET2)
				call BlzFrameSetSizePixel(.gauge_backdrop,WIDTH+INSET2*2,HEIGHT/2+INSET2*2)
				call BlzFrameSetPointPixel(.gauge_fill,FRAMEPOINT_TOPLEFT,.gauge_backdrop,FRAMEPOINT_TOPLEFT,INSET2,-INSET2)
				call BlzFrameSetVisible(.gauge_fill,false)
				call BlzFrameSetTexture(.gauge_fill,"replaceabletextures\\teamcolor\\teamcolor16.blp",0,true)
				set .activated = true
			endmethod

			method show takes boolean flag returns nothing
				if not .activated then
					call init()
				endif
				if GetLocalPlayer() == Player(this) then
					call BlzFrameSetVisible(.container,flag)
				endif
			endmethod

			static method onInit takes nothing returns nothing
				local integer i = 0
				loop
					exitwhen i >= CONFIG_PLAYER_MAX
					set thistype(i).activated = false
					set i = i + 1
				endloop
			endmethod

		endstruct

		private struct fishing extends UnitActor

			static constant real FIELD_RADIUS = 0.125
			static constant real CURSOR_SPEED = 0.45
			static constant real GAUGE_INCREASE = 0.25
			static constant real GAUGE_DECREASE = 0.05

			real cursor_x = 0.5	/*0.~1.*/
			real dest_x = 0.
			real gauge = 0.
			integer pressed = -1

			Trigger lclick = 0
			Lightning l = 0
			Effect ef = 0

			private method pick takes nothing returns nothing
				set ItemDynamicDrop.create(AbilityShard.create(AbilityTable.getRandomAbility(GetPlayerId(.caster.owner),AbilityTable.FISHING_1)),.x,.y,.caster.x,.caster.y,1.5).target = .caster
				call Effect.create(EFFECT_PATH3,.x,.y,0.,270.).kill()
				call .caster.setAnim("attack")
				call .caster.queueAnim("stand")
				//set .want_destroy = true
				call resetDestination()
			endmethod

			method setCursor takes real r returns nothing
				set .cursor_x = r
				if r < 0. then
					set .cursor_x = 0.
				elseif r > 1. then
					set .cursor_x = 1.
				endif
				call ui(GetPlayerId(.caster.owner)).adjustCursor(.cursor_x)
			endmethod

			method resetDestination takes nothing returns nothing
				set .dest_x = GetRandomReal(0.+FIELD_RADIUS,1.-FIELD_RADIUS)
				call ui(GetPlayerId(.caster.owner)).adjustField(.dest_x,FIELD_RADIUS)
			endmethod

			method periodicAction takes nothing returns nothing
				call setCursor(.cursor_x+CURSOR_SPEED*.pressed*TIMER_TICK)
				if .cursor_x >= .dest_x - FIELD_RADIUS and /*
					*/.cursor_x <= .dest_x + FIELD_RADIUS then
					set .gauge = .gauge + GAUGE_INCREASE * TIMER_TICK
					if .gauge >= 1. then
						set .gauge = .gauge - 1.
						call pick()
					endif
				else
					set .gauge = .gauge - GAUGE_DECREASE * TIMER_TICK
					if .gauge <= 0. then
						set .gauge = 0.
					endif
				endif
				call ui(GetPlayerId(.caster.owner)).refreshGauge(.gauge)
			endmethod
			
			static method click takes nothing returns nothing
				local thistype this = 0
				if BlzGetTriggerPlayerMouseButton() != MOUSE_BUTTON_TYPE_LEFT then
					return
				endif
				set this = Trigger.getData(GetTriggeringTrigger())
				if GetTriggerEventId() == EVENT_PLAYER_MOUSE_DOWN then
					set .pressed = 1
				elseif GetTriggerEventId() == EVENT_PLAYER_MOUSE_UP then
					set .pressed = -1
				endif
			endmethod

			static method create takes Unit caster, real x, real y, integer level returns thistype
				local thistype this = allocate(caster,0,x,y,level,-1.,true)
				call Effect.create(EFFECT_PATH2,x,y,0.,0.).setDuration(0.05)
				set .suspend_rclick = true
				set .suspend_ability = true
				call ui(GetPlayerId(.caster.owner)).show(true)
				call ui(GetPlayerId(.caster.owner)).refreshGauge(0.)
				call resetDestination()
				call setCursor(0.5)
				set .lclick = Trigger.create(this)
				call TriggerRegisterPlayerEvent(.lclick.main_trigger,.caster.owner,EVENT_PLAYER_MOUSE_DOWN)
				call TriggerRegisterPlayerEvent(.lclick.main_trigger,.caster.owner,EVENT_PLAYER_MOUSE_UP)
				call .lclick.addCondition(function thistype.click)
				set .l = Lightning.create("DRAM",.caster.x,.caster.y,.caster.z+.caster.pivot_z+75.,.x,.y,.0)
				set .l.oz1 = 100.
				call .l.setTarget1(.caster)
				set .ef = Effect.create(EFFECT_PATH4,.x,.y,0.,270.)
				call .ef.setScale(2.5)
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .l.destroy()
				call .ef.kill()
				call ui(GetPlayerId(.caster.owner)).show(false)
				call .lclick.destroy()
			endmethod

		endstruct

		private struct missile extends Missile

			private Trigger main_trigger = 0
			boolean click = false

			method afterExplosion takes nothing returns nothing
				if GetTerrainCliffLevel(.curve.getX(Curve.POINT_LAST),.curve.getY(Curve.POINT_LAST)) < CONFIG_CLIFF_HEIGHT_DEFAULT and /*
				*/not .click then
					call fishing.create(.owner,.curve.getX(Curve.POINT_LAST),.curve.getY(Curve.POINT_LAST),.level)
				endif
			endmethod

			static method record takes nothing returns nothing
				local thistype this = Trigger.getData(GetTriggeringTrigger())
				if CUSTOM_RESPOND_CLICK_BUTTON_TYPE == MOUSE_BUTTON_TYPE_RIGHT then
					set .click = true
				endif
			endmethod

			static method create takes Unit caster, real x, real y, integer level returns thistype
				local real a = Math.anglePoints(caster.x,caster.y,x,y)
				local thistype this = allocate(caster,EFFECT_PATH1,caster.x,caster.y,caster.z+caster.pivot_z,a)
				set .level = level
				set .curve = CurveBezier3.create(.owner.x,.owner.y,.z,x,y,0.)
				set .curve.overtime = 0.75
				call .curve.setProjectedControlPoint(0,0., 650, 90.)
				call .curve.setProjectedControlPoint(1,Math.distancePoints(.owner.x,.owner.y,.x,.y), 650, 90.)
				call .owner.plusStatus(ENUM_STATUS_CAST)
				call setExplosion(1.)
				set .affect_enemy = false
				set .main_trigger = Trigger.create(this)
				call .main_trigger.addCondition(function thistype.record)
				call Event.register(.main_trigger.main_trigger,ENUM_EVENT_CLICK)
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .owner.minusStatus(ENUM_STATUS_CAST)
				call .main_trigger.destroy()
			endmethod

		endstruct

		private struct actor extends UnitActor

			method onComplete takes nothing returns nothing
				call missile.create(.caster,.x,.y,.level)
			endmethod

			static method create takes Unit caster, real x, real y, integer level returns thistype
				local thistype this = allocate(caster,0,x,y,level,CAST,true)
				call .caster.setAnim("attack")
				call SetUnitFacing(.caster.origin_unit,Math.anglePoints(.caster.x,.caster.y,x,y))
				return this
			endmethod

			method onDestroy takes nothing returns nothing
				call .caster.queueAnim("stand")
			endmethod

		endstruct

		public struct main extends Ability

			// method relativeTooltip takes nothing returns string
			// 	return "물가에 사용시 낚시를 시작합니다.|r"
			// endmethod
	
			//! runtextmacro abilityTooltip2080()

			method releaseFilter takes nothing returns boolean
				if GetTerrainCliffLevel(.command_x,.command_y) < CONFIG_CLIFF_HEIGHT_DEFAULT then
					return true
				else
					set CUSTOM_RESPOND_ERROR_MESSAGE = "해당 지점에 사용할 수 없습니다."
					return false
				endif
			endmethod

			method execute takes nothing returns nothing
				call actor.create(.owner,.command_x,.command_y,.level)
			endmethod
	
			method init takes nothing returns nothing
				//! runtextmacro abilitySetup()
				set .is_active = true
				set .cast_range = RANGE
				set .preserve_order = false
				set .indicator = AbilityIndicator.create(this,.owner.owner)
				call plusBaseStatValue(5)
			endmethod
	
			static method onInit takes nothing returns nothing
				call Ability.setTypeTooltip(ID,"낚시하기\n ")
			endmethod
	
		endstruct
	
	//! runtextmacro abilityDataEnd()
endscope