//! import "NPC\NPC.j"
//! import "Moolgun\Moolgun.j"

library Interactive

	struct Interactive extends array

		static method init takes nothing returns nothing
			/*NPC*/
			call Fisher.init()
			call ManggakAzae.init()
			call Lumberman.init()
			call Miner.init()
			call Mine.init()
			call Refinery.init()
			call Blacksmith.init()
			/*Moolgun*/
			call Hellgate.init()
			call Waygate.init()
		endmethod

	endstruct

endlibrary
