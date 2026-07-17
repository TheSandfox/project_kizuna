//! import "Camera.j"
//! import "CustomString.j"
//! import "Tip.j"
//! import "CharacterSelect.j"
//! import "Wave.j"
//! import "Guardians.j"
//! import "Round.j"
//! import "TreeOfLife.j"
//! import "Shuffle.j"

library Game requires Unit, UI

	globals
		private trigger LEAVE_TRIGGER = CreateTrigger()	
		private integer TEST_UNIT_ID = 'HR00'
		private integer DUMMY_UNIT_ID1 = 'U001'
		private integer DUMMY_UNIT_ID2 = 'U004'
		private constant boolean GAME_DEBUG = true
		private constant real CAMERA_DISTANCE = 2425.0
	endglobals

	struct Game extends array

		static method playerLeave takes nothing returns nothing
			if SkillShop(GetPlayerId(GetTriggerPlayer())) > 0 then
				call SkillShop(GetPlayerId(GetTriggerPlayer())).destroy()
			endif
			if UI(GetPlayerId(GetTriggerPlayer())) > 0 then
				call UI(GetPlayerId(GetTriggerPlayer())).destroy()
			endif
			if SlotChanger(GetPlayerId(GetTriggerPlayer())) > 0 then
				call SlotChanger(GetPlayerId(GetTriggerPlayer())).destroy()
			endif
			if Inventory(GetPlayerId(GetTriggerPlayer())) > 0 then
				call Inventory(GetPlayerId(GetTriggerPlayer())).destroy()
			endif
			if User.getFocusUnit(GetTriggerPlayer()) > 0 then
				set User.getFocusUnit(GetTriggerPlayer()).is_revive = false
				call User.setFocusUnit(GetTriggerPlayer(),0)
			endif
		endmethod

		static method defeat takes nothing returns nothing
			local integer i = 0
			local Unit u = 0
			set Tombstone.GAME_OVER = true
			call Guardians.kill()
			loop
				exitwhen i >= 4
				set u = User.getFocusUnit(Player(i))
				call u.kill()
				call u.clearAbility()
				set i = i + 1
			endloop
			call Timer.pause(Round.TIMER)
			set SkillShop.DEFEAT = true
		endmethod

		static method systemMessage takes string msg returns nothing
			call BlzDisplayChatMessage(CONFIG_PLAYER_SYSTEM,0,msg)
		endmethod

		static method addLevel takes nothing returns nothing
			local integer i = 0
			local Unit u = 0
			loop
				exitwhen i >= 4
				call User.addGold(Player(i),5)
				set u = User.getFocusUnit(Player(i))
				if u > 0 then
					call Effect.createAttatched("Abilities\\Spells\\Other\\Levelup\\LevelupCaster.mdl",u.origin_unit,"origin").setDuration(1.5)
					set u.level = u.level + 1
				endif
				set i = i + 1
			endloop
		endmethod

		private static method initForPlayer takes player p, integer uid, integer chingho returns nothing
			local Unit u = Unit.create(p,uid,Math.pPX(GetRectCenterX(gg_rct_Spawn),128,GetRandomReal(0.,360.)),Math.pPY(GetRectCenterY(gg_rct_Spawn),128,GetRandomReal(0.,360.)),270.)
			set u.is_revive = true
			/*카메라*/
			call FixCamSetup(p,gg_cam_Cam00,true)
			call FixCamSetField(p,CAMERA_FIELD_TARGET_DISTANCE,CAMERA_DISTANCE)
			call FixCamResetPosition(p)
			if GetLocalPlayer() == p then
				call PanCameraToTimed(u.x,u.y,0.)
			endif
			/*마우스 리프레셔 작동*/
			call Mouse.activateRefresher(p)
			/*프로필 초기화*/
			call User.new(p)
			call User.setFocusUnit(p,u)
			call User.selectFocusUnit(p)
			/*어빌리티테이블*/
			call AbilityTable.createExtra(GetPlayerId(p),uid)
			/*칭호 추가*/
			call u.setChingho(chingho)
			/*메인 UI*/
			call UI.create(p)
			/*초기소지금*/
			if GAME_DEBUG then
				call User.addGold(p,5000)
			else
				call User.addGold(p,5)
			endif
			set u.level = 5
			/*칭호 어빌 추가*/
			//call u.addAbility(chingho)
			//call u.swapAbility(2,9)
		endmethod

		static method endSelect takes nothing returns nothing
			local integer i = 0
			/*꿀팁 활성화*/
			call Tip.init()
			/*프레임관련*/
			call UI.init()
			call Inventory.init()
			call Numberpad.init()
			/*플레이어별 초기화*/
			loop
				exitwhen i >= CONFIG_PLAYER_MAX
				if GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(Player(i)) == MAP_CONTROL_USER then
					call initForPlayer(Player(i),CharacterSelect_ID[i],CharacterSelect_CHINGHO_ID[i])
					call TriggerRegisterPlayerEventLeave(LEAVE_TRIGGER,Player(i))
				endif
				set i = i + 1
			endloop
			/*생명의 나무*/
			call TreeOfLife.init()
			/*수호자 초기화*/
			call Guardians.init()
			/*웨이브 가동*/
			call Round.init()
			/*상호작용물*/
			call Interactive.init()
			/*필드*/
			call Field.init()
			/*내비게이터*/
			call Navigator.init()
			/*탈주트리거*/
			call TriggerAddCondition(LEAVE_TRIGGER,function thistype.playerLeave)
		endmethod

		private static method start takes nothing returns nothing
			local Unit u = 0
			local trigger t = null
			local integer i = 0
			if GAME_DEBUG then
				/*꿀팁 활성화*/
				//call Tip.init()
				/*프레임관련*/
				call UI.init()
				call Inventory.init()
				call Numberpad.init()
				/*플레이어별 초기화*/
				loop
					exitwhen i >= CONFIG_PLAYER_MAX
					if GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING then
						call initForPlayer(Player(i),TEST_UNIT_ID,'C000')
					endif
					//call initForPlayer(Player(1),'HR09','C000')
					set i = i + 1
				endloop
				/*생명의 나무*/
				call TreeOfLife.init()
				/*수호자 초기화*/
				//call Guardians.init()
				/*웨이브 가동*/
				//call Round.init()
				/*상호작용물*/
				// call Interactive.init()
				/*필드*/
				// call Field.init()
				/*내비게이터*/
				// call Navigator.init()
				/*임시*/
				// call SkillShop(0).setLevel(10)
				// call SkillShop(0).refresh()
				/**/
			else
				/*캐릭터셀렉트*/
				call CharacterSelect.init()
			endif
			call DestroyTrigger(GetTriggeringTrigger())
			set t = null
		endmethod

		static method initAlly takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen i >= CONFIG_PLAYER_MAX
				call SetPlayerAllianceStateBJ(Player(i),CONFIG_PLAYER_GUARDIANS,bj_ALLIANCE_ALLIED_VISION)
				call SetPlayerAllianceStateBJ(CONFIG_PLAYER_GUARDIANS,Player(i),bj_ALLIANCE_ALLIED_VISION)
				call SetPlayerAllianceStateBJ(Player(i),CONFIG_PLAYER_ITEM,bj_ALLIANCE_ALLIED_VISION)
				call SetPlayerAllianceStateBJ(CONFIG_PLAYER_ITEM,Player(i),bj_ALLIANCE_ALLIED_VISION)
				set i = i + 1
			endloop
			call SetPlayerAllianceStateBJ(CONFIG_PLAYER_MONSTER,CONFIG_PLAYER_UNDEAD,bj_ALLIANCE_ALLIED_VISION)
			call SetPlayerAllianceStateBJ(CONFIG_PLAYER_UNDEAD,CONFIG_PLAYER_MONSTER,bj_ALLIANCE_ALLIED_VISION)
			call SetPlayerAllianceStateBJ(CONFIG_PLAYER_ITEM,CONFIG_PLAYER_UNDEAD,bj_ALLIANCE_ALLIED_VISION)
			call SetPlayerAllianceStateBJ(CONFIG_PLAYER_UNDEAD,CONFIG_PLAYER_ITEM,bj_ALLIANCE_ALLIED_VISION)
			call SetPlayerAllianceStateBJ(CONFIG_PLAYER_ITEM,CONFIG_PLAYER_MONSTER,bj_ALLIANCE_ALLIED_VISION)
			call SetPlayerAllianceStateBJ(CONFIG_PLAYER_MONSTER,CONFIG_PLAYER_ITEM,bj_ALLIANCE_ALLIED_VISION)
		endmethod

		private static method onInit takes nothing returns nothing
			/*시간차 init*/
			local trigger t = CreateTrigger()
			call TriggerRegisterTimerEvent(t,0.5,false)
			call TriggerAddAction(t,function thistype.start)
			/*기본 게임설정*/
			call BlzLoadTOCFile("ui\\framedef\\myframes\\MyFrames.toc")
			/*프레임 숨기기*/
			call BlzHideOriginFrames(true)
			call BlzFrameClearAllPoints(BlzGetFrameByName("ConsoleUIBackdrop",0))
			/*상단바*/
			// call BlzFrameClearAllPoints(BlzGetFrameByName("ConsoleTopBar",0))
			call BlzFrameSetVisible(BlzGetFrameByName("ConsoleTopBar",0),false)
			/*명령창 포인트 클리어*/
			call BlzFrameClearAllPoints(BlzGetFrameByName("CommandBarFrame",0))
			call BlzFrameClearAllPoints(BlzFrameGetParent(BlzGetFrameByName("CommandBarFrame",0)))
			/*디버그창*/
			call BlzFrameSetAbsPoint(BlzGetOriginFrame(ORIGIN_FRAME_UNIT_MSG,0),FRAMEPOINT_BOTTOMLEFT,0.,0.205)
			call BlzFrameSetSize(BlzGetOriginFrame(ORIGIN_FRAME_UNIT_MSG,0),1,1)
			/*채팅창 살리기*/
			call BlzFrameSetAbsPoint(BlzGetOriginFrame(ORIGIN_FRAME_CHAT_MSG,0),FRAMEPOINT_BOTTOMLEFT,0.,0.165)
			call BlzFrameSetSize(BlzGetOriginFrame(ORIGIN_FRAME_CHAT_MSG,0),1,1)
			/*유닛선택못하게*/
			call BlzEnableSelections(false,false)
			/*전장의 안개 끄기*/
			call FogMaskEnable(false)
			call FogEnable(false)
			/*시간 고정시키기*/
			call SetTimeOfDay(12.)
   			call SetTimeOfDayScalePercentBJ(0.)
			/*카메라*/
			call Camera.init()
			/*플레이어 이름 설정*/
			call SetPlayerName(CONFIG_PLAYER_GUARDIANS,"수호자")
			call SetPlayerName(CONFIG_PLAYER_MONSTER,"숲의 괴물들")
			call SetPlayerName(CONFIG_PLAYER_UNDEAD,"언데드 침략자")
			call SetPlayerName(CONFIG_PLAYER_SYSTEM,"|cffffcc00시스템|r")
			/*동맹설정*/
			call initAlly()
			/*백그라운드*/
			if not GAME_DEBUG then
				/*CreateBackground*/
				set CharacterSelect_BACKGROUND = BlzCreateFrameByType("SPRITE","",BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0),"",0)
				call BlzFrameSetModel(CharacterSelect_BACKGROUND,"ui\\characterselectbackground.mdl",0)
				call BlzFrameSetAbsPoint(CharacterSelect_BACKGROUND,FRAMEPOINT_BOTTOMLEFT,0.,0.)
				call BlzFrameSetSize(CharacterSelect_BACKGROUND,1,1)
			endif
			/**/
			set t = null
		endmethod

	endstruct

	struct Cheat extends array

		private static trigger CHEAT

		private static method cheatCallback takes nothing returns nothing
			local integer i = 0
			local Unit u = 0
			if BlzGetTriggerPlayerKey() == OSKEY_O then
				/*더미소환*/
				loop
					exitwhen i >= 1
					set u = Unit.create(CONFIG_PLAYER_UNDEAD,DUMMY_UNIT_ID1,Mouse.getX(Player(0)),Mouse.getY(Player(0)),0)
					call u.plusStatValue(CONFIG_STAT_HPREGEN,100.)
					call u.plusStatus(CONFIG_STATUS_CAST)
					set i = i + 1
				endloop
				call BossB000.create(15,GetRectCenterX(gg_rct_Warp006),GetRectCenterY(gg_rct_Warp006))
			elseif BlzGetTriggerPlayerKey() == OSKEY_P then
				/*디버그절취선*/
				call BJDebugMsg("================디버그절취선================")
			elseif BlzGetTriggerPlayerKey() == OSKEY_7 then
				/*렙업*/
				set User.getFocusUnit(Player(0)).level = User.getFocusUnit(Player(0)).level + 1
			elseif BlzGetTriggerPlayerKey() == OSKEY_8 then
				/*어빌리티샤드 드랍*/
				set i = AbilityShard.create(AbilityTable.getRandomAbility(0,AbilityTable.TIER_1)).addLevel(4).addUpgradePoint(AbilityShard.getRandomUpgradeType(),4*1)
				call AbilityShard(i).drop(Mouse.getX(Player(0)),Mouse.getY(Player(0)))
			endif
		endmethod

		static method onInit takes nothing returns nothing
			static if GAME_DEBUG then
				set CHEAT = CreateTrigger()
				call BlzTriggerRegisterPlayerKeyEvent(CHEAT,Player(0),OSKEY_7,0,true)
				call BlzTriggerRegisterPlayerKeyEvent(CHEAT,Player(0),OSKEY_8,0,true)
				call BlzTriggerRegisterPlayerKeyEvent(CHEAT,Player(0),OSKEY_9,0,true)
				call BlzTriggerRegisterPlayerKeyEvent(CHEAT,Player(0),OSKEY_0,0,true)
				call BlzTriggerRegisterPlayerKeyEvent(CHEAT,Player(0),OSKEY_O,0,true)
				call BlzTriggerRegisterPlayerKeyEvent(CHEAT,Player(0),OSKEY_P,0,true)
				call TriggerAddCondition(CHEAT,function thistype.cheatCallback)
			endif
		endmethod

	endstruct

endlibrary