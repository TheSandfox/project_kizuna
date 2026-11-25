library UnitData

	struct UnitData extends array

		private static hashtable P_HASH = InitHashtable()

		static method getInteger takes integer unitid, integer index returns integer
			return LoadInteger(P_HASH, unitid, index)
		endmethod

		static method setInteger takes integer unitid, integer index, integer value returns nothing
			call SaveInteger(P_HASH, unitid, index, value)
		endmethod

		static method getReal takes integer unitid, integer index returns real
			return LoadReal(P_HASH, unitid, index)
		endmethod

		static method setReal takes integer unitid, integer index, real value returns nothing
			call SaveReal(P_HASH, unitid, index, value)
		endmethod

		static method getString takes integer unitid, integer index returns string
			return LoadStr(P_HASH, unitid, index)
		endmethod

		static method setString takes integer unitid, integer index, string value returns nothing
			call SaveStr(P_HASH, unitid, index, value)
		endmethod

	endstruct

endlibrary

//! import "GeneratedUnitParams.j"