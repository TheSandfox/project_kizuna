library Blacksmith

	struct Blacksmith extends NPC

		static method create takes integer uid, real x, real y returns thistype
			local thistype this = allocate(uid,x,y,2.75)
			set .level = 10
			return this
		endmethod

		static method init takes nothing returns nothing
			call create('NS02',GetRectCenterX(gg_rct_NPCBlacksmith1),GetRectCenterY(gg_rct_NPCBlacksmith1))
			call create('NS02',GetRectCenterX(gg_rct_NPCBlacksmith2),GetRectCenterY(gg_rct_NPCBlacksmith2))
			call create('NS02',GetRectCenterX(gg_rct_NPCBlacksmith3),GetRectCenterY(gg_rct_NPCBlacksmith3))
			call create('NS02',GetRectCenterX(gg_rct_NPCBlacksmith4),GetRectCenterY(gg_rct_NPCBlacksmith4))
		endmethod

	endstruct

endlibrary