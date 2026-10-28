library Navigator requires Field

	struct Navigator extends array

		static method init takes nothing returns nothing
			call Field.getRandomWaygateField().openWithWaygate()
		endmethod

	endstruct

endlibrary