library CameraSetup

	struct CameraSetup extends array

		static method create takes player p returns thistype
			local thistype this = GetPlayerId(p)
			return this
		endmethod

	endstruct

endlibrary