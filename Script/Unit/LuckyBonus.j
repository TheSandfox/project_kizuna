library LuckyBonus requires Unit

	struct LuckyBonus extends array

		static method create takes Unit caster returns thistype
			set InstantText.SIZE = 10.
			call InstantText.create(caster.x,caster.y,caster.z+125.,CustomString.statString(ENUM_STAT_LUCK,"행운 보너스!"))
			return 0
		endmethod

	endstruct

endlibrary