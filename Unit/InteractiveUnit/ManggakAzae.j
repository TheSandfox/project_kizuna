library ManggakAzae

	globals
		private constant integer UNIT_ID = 'NP00'
	endglobals

	struct ManggakAzae extends InteractiveUnit

		method onInteract takes Unit caster returns nothing
			call BJDebugMsg("나는 "+.name)
		endmethod

		static method create takes real x, real y returns thistype
			local thistype this = allocate(CONFIG_PLAYER_NPC,UNIT_ID,x,y,270.)
			call plusAvul()
			set .level = 10
			return this
		endmethod

		static method init takes nothing returns nothing
			call create(GetRectCenterX(gg_rct_NPCManggakAzae),GetRectCenterY(gg_rct_NPCManggakAzae))
		endmethod

	endstruct

endlibrary
