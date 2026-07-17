library AbilityTable initializer init

	globals
		private hashtable HASH = InitHashtable()
	endglobals

	struct AbilityTable extends array

		static integer array TABLE_SIZE
		static constant integer TABLE_INDEX_LIMIT = 1024

		/*사실상 공백*/
		static constant integer TIER_0 = 0
		/*여기부터*/
		static constant integer TIER_1 = 1
		static constant integer TIER_2 = 2
		static constant integer TIER_3 = 3
		static constant integer TIER_4 = 4
		static constant integer TIER_5 = 5
		static constant integer FISHING_1 = 6
		static constant integer FISHING_2 = 7
		static constant integer FISHING_3 = 8
		static constant integer FISHING_4 = 9
		static constant integer FISHING_5 = 10
		
		Array extra
		
		method addExtraAbility takes integer tindex, integer aid returns nothing
			if tindex == 0 then
				return
			endif
			call Array(.extra.getValue(tindex)).add(aid)
		endmethod

		method getExtraAbility takes integer tindex, integer index returns integer
			return Array(.extra.getValue(tindex)).getValue(index)
		endmethod

		static method addAbility takes integer tablenum, integer id returns nothing
			if tablenum < TABLE_INDEX_LIMIT and tablenum >= 0 then
				call SaveInteger(HASH,tablenum,TABLE_SIZE[tablenum],id)
				set TABLE_SIZE[tablenum] = TABLE_SIZE[tablenum] + 1
			endif
		endmethod

		static method getAbility takes integer tablenum, integer index returns integer
			if HaveSavedInteger(HASH,tablenum,index) then
				return LoadInteger(HASH,tablenum,index)
			else
				return 0
			endif
		endmethod

		static method getRandomAbility takes integer pid, integer tablenum returns integer
			local integer this = pid
			local integer size = TABLE_SIZE[tablenum]
			local integer i = GetRandomInt(0,size+Array(.extra.getValue(tablenum)).size-1)
			if i < size then
				return LoadInteger(HASH,tablenum,i)
			else
				return getExtraAbility(tablenum,i-size)
			endif
		endmethod

		static method copyTable takes integer tablenum returns Array
			local Array list = Array.create()
			local integer i = 0
			loop
				exitwhen i >= TABLE_SIZE[tablenum]
				call list.add(getAbility(tablenum,i))
				set i = i + 1
			endloop
			return list
		endmethod

		static method initex takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen i >= TABLE_INDEX_LIMIT
				set TABLE_SIZE[i] = 0
				set i = i + 1
			endloop
		endmethod

		static method createExtra takes integer pid, integer uid returns nothing
			local thistype this = pid
			local integer i = 0
			local integer aid = 0
			set .extra = Array.create()
			call .extra.add(0)/*제로베이스 아님 주의*/
			call .extra.add(Array.create())
			call .extra.add(Array.create())
			call .extra.add(Array.create())
			call .extra.add(Array.create())
			call .extra.add(Array.create())
			loop
				exitwhen i >= 8
				set aid = UnitData.getExtraAbility(uid,i)
				if aid != 0 then
					call Array(.extra.getValue(Ability.getTypeTier(aid))).add(aid)
					// call BJDebugMsg(Ability.getTypeName(aid))
				endif
				set i = i + 1
			endloop
		endmethod

	endstruct

	private function init takes nothing returns nothing
		call AbilityTable.initex()
		//! import "GeneratedAbilityTable.j"
	endfunction

endlibrary