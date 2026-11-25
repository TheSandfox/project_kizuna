globals
    constant integer ENUM_UNIT_PARAM_ID = 0
    constant integer ENUM_UNIT_PARAM_NAME = 1
    constant integer ENUM_UNIT_PARAM_ICON_PATH = 2
    constant integer ENUM_UNIT_PARAM_INITIAL_ABILITY = 3
    constant integer ENUM_UNIT_PARAM_TOOLTIP = 4
endglobals

scope UnitHR00 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('HR00',ENUM_UNIT_PARAM_ID,'HR00')
		call UnitData.setString('HR00',ENUM_UNIT_PARAM_NAME,"전사")
		call UnitData.setString('HR00',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNFootman.blp")
		call UnitData.setInteger('HR00',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10a0')
		call UnitData.setString('HR00',ENUM_UNIT_PARAM_TOOLTIP,"도내 SSR급 굳건이")
	endfunction
endscope

scope UnitHR01 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('HR01',ENUM_UNIT_PARAM_ID,'HR01')
		call UnitData.setString('HR01',ENUM_UNIT_PARAM_NAME,"총잡이")
		call UnitData.setString('HR01',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNRifleMan.blp")
		call UnitData.setInteger('HR01',ENUM_UNIT_PARAM_INITIAL_ABILITY,'1020')
		call UnitData.setString('HR01',ENUM_UNIT_PARAM_TOOLTIP,"칼 든 사람보다 무서운 총 든 사람")
	endfunction
endscope

scope UnitHR02 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('HR02',ENUM_UNIT_PARAM_ID,'HR02')
		call UnitData.setString('HR02',ENUM_UNIT_PARAM_NAME,"붉은기사")
		call UnitData.setString('HR02',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNUnit_RedFootman.blp")
		call UnitData.setInteger('HR02',ENUM_UNIT_PARAM_INITIAL_ABILITY,'1090')
		call UnitData.setString('HR02',ENUM_UNIT_PARAM_TOOLTIP,"몽둥이가 압권인 전사")
	endfunction
endscope

scope UnitHR03 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('HR03',ENUM_UNIT_PARAM_ID,'HR03')
		call UnitData.setString('HR03',ENUM_UNIT_PARAM_NAME,"어둠추적자")
		call UnitData.setString('HR03',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNSatyrTrickster.blp")
		call UnitData.setInteger('HR03',ENUM_UNIT_PARAM_INITIAL_ABILITY,'1070')
		call UnitData.setString('HR03',ENUM_UNIT_PARAM_TOOLTIP,"현실세계에선 스토커였던 내가 이세계에서는 0티어 도적?")
	endfunction
endscope

scope UnitHR04 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('HR04',ENUM_UNIT_PARAM_ID,'HR04')
		call UnitData.setString('HR04',ENUM_UNIT_PARAM_NAME,"흑마법사")
		call UnitData.setString('HR04',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNGuldan.blp")
		call UnitData.setInteger('HR04',ENUM_UNIT_PARAM_INITIAL_ABILITY,'1030')
		call UnitData.setString('HR04',ENUM_UNIT_PARAM_TOOLTIP,"정말로 강한 마법사이다. 왜 강한지는…")
	endfunction
endscope

scope UnitHR05 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('HR05',ENUM_UNIT_PARAM_ID,'HR05')
		call UnitData.setString('HR05',ENUM_UNIT_PARAM_NAME,"해병")
		call UnitData.setString('HR05',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNMarine.blp")
		call UnitData.setInteger('HR05',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10i0')
		call UnitData.setString('HR05',ENUM_UNIT_PARAM_TOOLTIP,"전우애로 똘똘 뭉친 사람")
	endfunction
endscope

scope UnitHR06 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('HR06',ENUM_UNIT_PARAM_ID,'HR06')
		call UnitData.setString('HR06',ENUM_UNIT_PARAM_NAME,"트롤 광전사")
		call UnitData.setString('HR06',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNForestTrollTrapper.blp")
		call UnitData.setInteger('HR06',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10h0')
		call UnitData.setString('HR06',ENUM_UNIT_PARAM_TOOLTIP,"트롤인데다 광전사이다.")
	endfunction
endscope

scope UnitHR07 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('HR07',ENUM_UNIT_PARAM_ID,'HR07')
		call UnitData.setString('HR07',ENUM_UNIT_PARAM_NAME,"자객")
		call UnitData.setString('HR07',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNCultAssassin.blp")
		call UnitData.setInteger('HR07',ENUM_UNIT_PARAM_INITIAL_ABILITY,'1070')
		call UnitData.setString('HR07',ENUM_UNIT_PARAM_TOOLTIP,"벼르고 있는 사람들이 많다. 잡히면 어떻게 될까?")
	endfunction
endscope

scope UnitHR08 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('HR08',ENUM_UNIT_PARAM_ID,'HR08')
		call UnitData.setString('HR08',ENUM_UNIT_PARAM_NAME,"주술사")
		call UnitData.setString('HR08',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNShaman.blp")
		call UnitData.setInteger('HR08',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10n0')
		call UnitData.setString('HR08',ENUM_UNIT_PARAM_TOOLTIP,"현실에선 주술이라고는 인디안식 기우제밖에 몰랐지만 여기선 다르다.")
	endfunction
endscope

scope UnitHR09 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('HR09',ENUM_UNIT_PARAM_ID,'HR09')
		call UnitData.setString('HR09',ENUM_UNIT_PARAM_NAME,"마술사")
		call UnitData.setString('HR09',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNVillagerMan1.blp")
		call UnitData.setInteger('HR09',ENUM_UNIT_PARAM_INITIAL_ABILITY,'1060')
		call UnitData.setString('HR09',ENUM_UNIT_PARAM_TOOLTIP,"[카드값]이 많이 나오는 사람")
	endfunction
endscope

scope UnitHR0a initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('HR0a',ENUM_UNIT_PARAM_ID,'HR0a')
		call UnitData.setString('HR0a',ENUM_UNIT_PARAM_NAME,"불한당")
		call UnitData.setString('HR0a',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNBandit.blp")
		call UnitData.setInteger('HR0a',ENUM_UNIT_PARAM_INITIAL_ABILITY,'1000')
		call UnitData.setString('HR0a',ENUM_UNIT_PARAM_TOOLTIP,"물하기싫으니불한당")
	endfunction
endscope

scope UnitHR0b initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('HR0b',ENUM_UNIT_PARAM_ID,'HR0b')
		call UnitData.setString('HR0b',ENUM_UNIT_PARAM_NAME,"바다사냥꾼")
		call UnitData.setString('HR0b',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNSeaWitch.blp")
		call UnitData.setInteger('HR0b',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10g0')
		call UnitData.setString('HR0b',ENUM_UNIT_PARAM_TOOLTIP,"해녀라고 부르면 화를 낸다.")
	endfunction
endscope

scope UnitHR0c initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('HR0c',ENUM_UNIT_PARAM_ID,'HR0c')
		call UnitData.setString('HR0c',ENUM_UNIT_PARAM_NAME,"주문파괴자")
		call UnitData.setString('HR0c',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNSpellBreaker.blp")
		call UnitData.setInteger('HR0c',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10f0')
		call UnitData.setString('HR0c',ENUM_UNIT_PARAM_TOOLTIP,"마법이 소용없다고 주장하는 사람")
	endfunction
endscope

scope UnitHR0d initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('HR0d',ENUM_UNIT_PARAM_ID,'HR0d')
		call UnitData.setString('HR0d',ENUM_UNIT_PARAM_NAME,"기술자")
		call UnitData.setString('HR0d',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNPeasant.blp")
		call UnitData.setInteger('HR0d',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10l0')
		call UnitData.setString('HR0d',ENUM_UNIT_PARAM_TOOLTIP,"지상 최강의 막노동꾼")
	endfunction
endscope

scope UnitHR0e initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('HR0e',ENUM_UNIT_PARAM_ID,'HR0e')
		call UnitData.setString('HR0e',ENUM_UNIT_PARAM_NAME,"돼지술사")
		call UnitData.setString('HR0e',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNRazorback.blp")
		call UnitData.setInteger('HR0e',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10d0')
		call UnitData.setString('HR0e',ENUM_UNIT_PARAM_TOOLTIP,"대지마법을 사용할 수 있다는 오해를 자주 산다.")
	endfunction
endscope

scope UnitHR0f initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('HR0f',ENUM_UNIT_PARAM_ID,'HR0f')
		call UnitData.setString('HR0f',ENUM_UNIT_PARAM_NAME,"요정용")
		call UnitData.setString('HR0f',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNFaerieDragon.blp")
		call UnitData.setInteger('HR0f',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10j0')
		call UnitData.setString('HR0f',ENUM_UNIT_PARAM_TOOLTIP,"뀨")
	endfunction
endscope

scope UnitHR0g initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('HR0g',ENUM_UNIT_PARAM_ID,'HR0g')
		call UnitData.setString('HR0g',ENUM_UNIT_PARAM_NAME,"성기사")
		call UnitData.setString('HR0g',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNTheCaptain.blp")
		call UnitData.setInteger('HR0g',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10a0')
		call UnitData.setString('HR0g',ENUM_UNIT_PARAM_TOOLTIP,"도내 SSR급 굳건이")
	endfunction
endscope

scope UnitSP00 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('SP00',ENUM_UNIT_PARAM_ID,'SP00')
		call UnitData.setString('SP00',ENUM_UNIT_PARAM_NAME,"군마")
		call UnitData.setString('SP00',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNRiderlessHorse.blp")
		call UnitData.setInteger('SP00',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10b0')
		call UnitData.setString('SP00',ENUM_UNIT_PARAM_TOOLTIP,"탑승감 좋은 군마")
	endfunction
endscope

scope UnitSP03 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('SP03',ENUM_UNIT_PARAM_ID,'SP03')
		call UnitData.setString('SP03',ENUM_UNIT_PARAM_NAME,"돼지")
		call UnitData.setString('SP03',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNRazorback.blp")
		call UnitData.setInteger('SP03',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10c0')
		call UnitData.setString('SP03',ENUM_UNIT_PARAM_TOOLTIP,"꾸이이익")
	endfunction
endscope

scope UnitSP04 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('SP04',ENUM_UNIT_PARAM_ID,'SP04')
		call UnitData.setString('SP04',ENUM_UNIT_PARAM_NAME,"해골 전사")
		call UnitData.setString('SP04',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNSkeletonWarrior.blp")
		call UnitData.setInteger('SP04',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10a0')
		call UnitData.setString('SP04',ENUM_UNIT_PARAM_TOOLTIP,"지성도 없고 고통도 모르니 가장 무서운 존재가 아닐까?")
	endfunction
endscope

scope UnitSP05 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('SP05',ENUM_UNIT_PARAM_ID,'SP05')
		call UnitData.setString('SP05',ENUM_UNIT_PARAM_NAME,"정찰탑")
		call UnitData.setString('SP05',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNHumanWatchTower.blp")
		call UnitData.setInteger('SP05',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10k0')
		call UnitData.setString('SP05',ENUM_UNIT_PARAM_TOOLTIP,"튼튼한 정찰탑")
	endfunction
endscope

scope UnitSP06 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('SP06',ENUM_UNIT_PARAM_ID,'SP06')
		call UnitData.setString('SP06',ENUM_UNIT_PARAM_NAME,"전기충격기")
		call UnitData.setString('SP06',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNPowerGenerator.blp")
		call UnitData.setInteger('SP06',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10m0')
		call UnitData.setString('SP06',ENUM_UNIT_PARAM_TOOLTIP,"이세계에서도 범죄자 소탕에 많이 활용되는 기구")
	endfunction
endscope

scope UnitSP07 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('SP07',ENUM_UNIT_PARAM_ID,'SP07')
		call UnitData.setString('SP07',ENUM_UNIT_PARAM_NAME,"늑대정령")
		call UnitData.setString('SP07',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNSpiritWolf.blp")
		call UnitData.setInteger('SP07',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10n0')
		call UnitData.setString('SP07',ENUM_UNIT_PARAM_TOOLTIP,"늑대의 형상을 한 정령")
	endfunction
endscope

scope UnitSP08 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('SP08',ENUM_UNIT_PARAM_ID,'SP08')
		call UnitData.setString('SP08',ENUM_UNIT_PARAM_NAME,"고대 코끼리")
		call UnitData.setString('SP08',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNBlackMammoth.blp")
		call UnitData.setInteger('SP08',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10b0')
		call UnitData.setString('SP08',ENUM_UNIT_PARAM_TOOLTIP,"싫어하는 학교는 연세대학교")
	endfunction
endscope

scope UnitSP09 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('SP09',ENUM_UNIT_PARAM_ID,'SP09')
		call UnitData.setString('SP09',ENUM_UNIT_PARAM_NAME,"마법 금고")
		call UnitData.setString('SP09',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNMagicVault.blp")
		call UnitData.setInteger('SP09',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10o0')
		call UnitData.setString('SP09',ENUM_UNIT_PARAM_TOOLTIP,"귀엽고 든든한 마법 금고")
	endfunction
endscope

scope UnitNP00 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('NP00',ENUM_UNIT_PARAM_ID,'NP00')
		call UnitData.setString('NP00',ENUM_UNIT_PARAM_NAME,"망각술사")
		call UnitData.setString('NP00',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNAcolyte.blp")
		call UnitData.setInteger('NP00',ENUM_UNIT_PARAM_INITIAL_ABILITY,0)
		call UnitData.setString('NP00',ENUM_UNIT_PARAM_TOOLTIP,"무슨 설명을 적어놓으려고 했더라?")
	endfunction
endscope

scope UnitNP01 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('NP01',ENUM_UNIT_PARAM_ID,'NP01')
		call UnitData.setString('NP01',ENUM_UNIT_PARAM_NAME,"낚시꾼")
		call UnitData.setString('NP01',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNHeadhunter.blp")
		call UnitData.setInteger('NP01',ENUM_UNIT_PARAM_INITIAL_ABILITY,0)
		call UnitData.setString('NP01',ENUM_UNIT_PARAM_TOOLTIP,"물고기 잡는 법 보다 더 중요한 것은 낚시대를 만드는 법")
	endfunction
endscope

scope UnitNP02 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('NP02',ENUM_UNIT_PARAM_ID,'NP02')
		call UnitData.setString('NP02',ENUM_UNIT_PARAM_NAME,"병참장교")
		call UnitData.setString('NP02',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNTheCaptain.blp")
		call UnitData.setInteger('NP02',ENUM_UNIT_PARAM_INITIAL_ABILITY,0)
		call UnitData.setString('NP02',ENUM_UNIT_PARAM_TOOLTIP,"")
	endfunction
endscope

scope UnitNP03 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('NP03',ENUM_UNIT_PARAM_ID,'NP03')
		call UnitData.setString('NP03',ENUM_UNIT_PARAM_NAME,"나무꾼")
		call UnitData.setString('NP03',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNGrunt.blp")
		call UnitData.setInteger('NP03',ENUM_UNIT_PARAM_INITIAL_ABILITY,0)
		call UnitData.setString('NP03',ENUM_UNIT_PARAM_TOOLTIP,"")
	endfunction
endscope

scope UnitNP04 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('NP04',ENUM_UNIT_PARAM_ID,'NP04')
		call UnitData.setString('NP04',ENUM_UNIT_PARAM_NAME,"광부")
		call UnitData.setString('NP04',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNChaosPeon.blp")
		call UnitData.setInteger('NP04',ENUM_UNIT_PARAM_INITIAL_ABILITY,0)
		call UnitData.setString('NP04',ENUM_UNIT_PARAM_TOOLTIP,"")
	endfunction
endscope

scope UnitU000 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('U000',ENUM_UNIT_PARAM_ID,'U000')
		call UnitData.setString('U000',ENUM_UNIT_PARAM_NAME,"구울")
		call UnitData.setString('U000',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNGhoul.blp")
		call UnitData.setInteger('U000',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10u0')
		call UnitData.setString('U000',ENUM_UNIT_PARAM_TOOLTIP,"")
	endfunction
endscope

scope UnitU001 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('U001',ENUM_UNIT_PARAM_ID,'U001')
		call UnitData.setString('U001',ENUM_UNIT_PARAM_NAME,"지하마귀")
		call UnitData.setString('U001',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNCryptFiend.blp")
		call UnitData.setInteger('U001',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10v0')
		call UnitData.setString('U001',ENUM_UNIT_PARAM_TOOLTIP,"")
	endfunction
endscope

scope UnitU002 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('U002',ENUM_UNIT_PARAM_ID,'U002')
		call UnitData.setString('U002',ENUM_UNIT_PARAM_NAME,"가고일")
		call UnitData.setString('U002',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNGargoyle.blp")
		call UnitData.setInteger('U002',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10w0')
		call UnitData.setString('U002',ENUM_UNIT_PARAM_TOOLTIP,"")
	endfunction
endscope

scope UnitU003 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('U003',ENUM_UNIT_PARAM_ID,'U003')
		call UnitData.setString('U003',ENUM_UNIT_PARAM_NAME,"강령술사")
		call UnitData.setString('U003',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNNecromancer.blp")
		call UnitData.setInteger('U003',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10x0')
		call UnitData.setString('U003',ENUM_UNIT_PARAM_TOOLTIP,"")
	endfunction
endscope

scope UnitU004 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('U004',ENUM_UNIT_PARAM_ID,'U004')
		call UnitData.setString('U004',ENUM_UNIT_PARAM_NAME,"살덩이 골렘")
		call UnitData.setString('U004',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNAbomination.blp")
		call UnitData.setInteger('U004',ENUM_UNIT_PARAM_INITIAL_ABILITY,'10y0')
		call UnitData.setString('U004',ENUM_UNIT_PARAM_TOOLTIP,"")
	endfunction
endscope

scope UnitM000 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('M000',ENUM_UNIT_PARAM_ID,'M000')
		call UnitData.setString('M000',ENUM_UNIT_PARAM_NAME,"나무정령")
		call UnitData.setString('M000',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNEnt.blp")
		call UnitData.setInteger('M000',ENUM_UNIT_PARAM_INITIAL_ABILITY,'1000')
		call UnitData.setString('M000',ENUM_UNIT_PARAM_TOOLTIP,"")
	endfunction
endscope

scope UnitM001 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('M001',ENUM_UNIT_PARAM_ID,'M001')
		call UnitData.setString('M001',ENUM_UNIT_PARAM_NAME,"숲거미")
		call UnitData.setString('M001',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNSpiderGreen.blp")
		call UnitData.setInteger('M001',ENUM_UNIT_PARAM_INITIAL_ABILITY,'1000')
		call UnitData.setString('M001',ENUM_UNIT_PARAM_TOOLTIP,"")
	endfunction
endscope

scope UnitM002 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('M002',ENUM_UNIT_PARAM_ID,'M002')
		call UnitData.setString('M002',ENUM_UNIT_PARAM_NAME,"곰돌이")
		call UnitData.setString('M002',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNFurbolg.blp")
		call UnitData.setInteger('M002',ENUM_UNIT_PARAM_INITIAL_ABILITY,'1000')
		call UnitData.setString('M002',ENUM_UNIT_PARAM_TOOLTIP,"[죽음을 각오한 인간]보다 조금 더 강하다고 알려진다.")
	endfunction
endscope

scope UnitB000 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('B000',ENUM_UNIT_PARAM_ID,'B000')
		call UnitData.setString('B000',ENUM_UNIT_PARAM_NAME,"대지령")
		call UnitData.setString('B000',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNRockGolem.blp")
		call UnitData.setInteger('B000',ENUM_UNIT_PARAM_INITIAL_ABILITY,0)
		call UnitData.setString('B000',ENUM_UNIT_PARAM_TOOLTIP,"")
	endfunction
endscope

scope UnitB001 initializer init
	private function init takes nothing returns nothing
		call UnitData.setInteger('B001',ENUM_UNIT_PARAM_ID,'B001')
		call UnitData.setString('B001',ENUM_UNIT_PARAM_NAME,"기계난동꾼")
		call UnitData.setString('B001',ENUM_UNIT_PARAM_ICON_PATH,"ReplaceableTextures\\CommandButtons\\BTNROBOGOBLIN.blp")
		call UnitData.setInteger('B001',ENUM_UNIT_PARAM_INITIAL_ABILITY,0)
		call UnitData.setString('B001',ENUM_UNIT_PARAM_TOOLTIP,"")
	endfunction
endscope
