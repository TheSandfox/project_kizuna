library Tip

	struct Tip

		static trigger TRIGGER = CreateTrigger()
		static string array TIPS
		static integer TIP_MAX = 0
		static real TIP_INTERVAL = 60.

		static method act takes nothing returns nothing
			call DisplayTimedTextToPlayer(GetLocalPlayer(),0.,0.,10.,"\n|cffffcc00정보 : |r"+TIPS[GetRandomInt(0,TIP_MAX-1)])
			call PlaySoundBJ(gg_snd_Hint)
		endmethod

		static method addTip takes string tip returns nothing
			set TIPS[TIP_MAX] = tip
			set TIP_MAX = TIP_MAX + 1
		endmethod

		static method init takes nothing returns nothing
			call TriggerRegisterTimerEvent(TRIGGER,TIP_INTERVAL,true)
			call TriggerAddCondition(TRIGGER,function thistype.act)
			call addTip("|cffffcc00Ctrl + 스킬 단축키 입력으로 빠른 시전 설정을 할 수 있습니다.|r"+/*
			*/"\n|cff999999사용 안함|r |cffffcc00-> 사거리 표시 ->|r |cff00ffff즉시 사용|r |cffffcc00순으로 변경됩니다.|r")
			call addTip("|cffffcc00Shift + 스킬 단축키 입력으로 특수 상호작용이 가능한 스킬이 일부 존재합니다.|r")
			call addTip(CUSTOM_STRING_CAST_TYPE_NAME[CONFIG_CAST_TYPE_WEAPON]+"|cffffcc00는 동시에 한 종류만 사용할 수 있습니다.|r")
			call addTip("|cffffcc00스킬마다 최소 재사용 대기시간이 존재하며 해당 시간보다 재사용 시간을 적게 줄일 수 없습니다.|r")
			call addTip("|cffffcc00캐릭터가 최초로 보유한 스킬은 캐릭터의 레벨이 올라갈 때 마다 같이 레벨이 상승합니다.|r")
			call addTip("|cffffcc00장착중인 |r"+CUSTOM_STRING_CAST_TYPE_NAME[CONFIG_CAST_TYPE_WEAPON]+"|cffffcc00는 Ctrl + 스킬 단축키 입력으로 장착 해제할 수 있습니다.|r")
			call addTip("S|cffffcc00버튼 입력 시 자동공격이 비활성화된 상태로 정지합니다. |rH|cffffcc00버튼 입력 시 자동공격이 활성화된 상태로 정지합니다.|r")
			call addTip("빠른시전 설정 여부와 관계없이 단축키 입력 시 항상 즉발되는 스킬들이 일부 존재합니다.")
			call addTip("최대레벨을 초과하는 스킬 레벨합성 시 초과분에 해당하는 강화재화가 환급됩니다.")
		endmethod

	endstruct

endlibrary