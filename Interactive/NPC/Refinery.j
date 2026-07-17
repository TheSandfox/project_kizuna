library Refinery

	struct Refinery extends NPC

		static method create takes integer uid, real x, real y returns thistype
			local thistype this = allocate(uid,x,y,2.75)
			set .level = 10
			return this
		endmethod

		static method init takes nothing returns nothing
			call create('NS01',GetRectCenterX(gg_rct_NPCRefinery1),GetRectCenterY(gg_rct_NPCRefinery1))
			call create('NS01',GetRectCenterX(gg_rct_NPCRefinery2),GetRectCenterY(gg_rct_NPCRefinery2))
			call create('NS01',GetRectCenterX(gg_rct_NPCRefinery3),GetRectCenterY(gg_rct_NPCRefinery3))
			call create('NS01',GetRectCenterX(gg_rct_NPCRefinery4),GetRectCenterY(gg_rct_NPCRefinery4))
		endmethod

	endstruct

endlibrary