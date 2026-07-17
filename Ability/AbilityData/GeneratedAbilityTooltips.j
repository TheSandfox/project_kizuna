
//! textmacro abilityTooltip1000
method relativeTooltip takes Unit caster returns string
	return "지정한 방향으로 약진하여 충돌하는 대상과 대상 주변의 적들에게 "+"|cffff9900"+R2SW(1.5*caster.getCarculatedStatValue(CONFIG_STAT_DEFENSE)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_DEFENSE)+"의 피해를 입히고 밀쳐냅니다. 가장 가까운 적에게는 "+"|cffffffff"+"133%"+"|r"+"의 피해를 입힙니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip1010
method relativeTooltip takes Unit caster returns string
	return "지정 범위 내의 적들에게 "+"|cff9999ff"+R2SW(2.25*caster.getCarculatedStatValue(CONFIG_STAT_MAGICPOWER)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAGICPOWER)+"의 피해를 입힙니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip1020
method relativeTooltip takes Unit caster returns string
	return "|cffffffff"+"2.0초"+"|r"+" 동안 정신집중 후 대상에게 "+"|cffff9900"+R2SW(2.25*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK_SPEED)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입힙니다."+"\n"+"\n"+"|cff999999"+"고정된 공격속도를 가집니다."+"|r"
endmethod
//! endtextmacro
//! textmacro abilityTooltip1030
method relativeTooltip takes Unit caster returns string
	return "지정한 방향으로 화염구를 발사하여 처음 적중한 대상과 주변의 적들에게 "+"|cff9999ff"+R2SW(2.25*caster.getCarculatedStatValue(CONFIG_STAT_MAGICPOWER)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAGICPOWER)+"의 피해를 입힙니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip1040
method relativeTooltip takes Unit caster returns string
	return "대상을 포함한 최대 "+"|cffffffff"+"4"+"기"+"|r"+"의 적들에게 "+"|cff9999ff"+R2SW(1.55*caster.getCarculatedStatValue(CONFIG_STAT_MAGICPOWER)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAGICPOWER)+"의 피해를 입힙니다."+"\n"+"첫 대상에게는 피해량이 "+"|cffff00ff"+R2SW(0.85*caster.getCarculatedStatValue(CONFIG_STAT_ACCURACY)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ACCURACY)+" 증가합니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip1050
method relativeTooltip takes Unit caster returns string
	return "대상의 "+"|cff00ff00"+"체력"+"을 "+R2SW((0.0325*caster.getCarculatedStatValue(CONFIG_STAT_MAXHP)+0.85*caster.getCarculatedStatValue(CONFIG_STAT_MAGICPOWER))*(1+0.06*.level)+(9.0*caster.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAXHP)+CustomString.shiftStatTooltip(CONFIG_STAT_MAGICPOWER)+CustomString.shiftStatTooltip(CONFIG_STAT_UNIT_LEVEL)+" 회복시킵니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip1060
method relativeTooltip takes Unit caster returns string
	return "선택한 지점으로 순간이동 합니다."+"\n"+"\n"+" - 다른 행동 중에도 사용할 수 있습니다."+"\n"+" - 스킬 레벨에 비례해 재사용 대기시간이 감소합니다."+"\n"+" - "+"|cff00ffff탑승|r"+" 상태에서 사용 시 해당 "+"|cff00ffff탑승|r"+" 효과가 취소됩니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip1070
method relativeTooltip takes Unit caster returns string
	return "지정한 위치로 순간이동한 뒤 경로상의 적들에게 "+"|cffff9900"+R2SW((1.25*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)+0.35*caster.getCarculatedStatValue(CONFIG_STAT_ACCURACY))*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+CustomString.shiftStatTooltip(CONFIG_STAT_ACCURACY)+"의 피해를 입힙니다. 한 기 이상의 적에게 적중하면 "+"|cff0099ff"+"마나"+"를 "+R2SW(24.0,1,1)+"|r"+" 회복합니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip1080
method relativeTooltip takes Unit caster returns string
	return "지정한 방향으로 "+"|cffffffff"+"5"+"개"+"|r"+"의 화살을 일제히 발사하여 처음 맞힌 적에게 각각 "+"|cffff9900"+R2SW(1.68*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입힙니다. 같은 유닛에 여러 화살을 맞추는 경우 두 번째 화살부터 "+"|cffffffff"+"15%"+"|r"+"의 피해를 입힙니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip1090
method relativeTooltip takes Unit caster returns string
	return "대상을 후려쳐 "+"|cffff9900"+R2SW((0.85*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)+0.015*caster.getCarculatedStatValue(CONFIG_STAT_MAXHP))*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+CustomString.shiftStatTooltip(CONFIG_STAT_MAXHP)+"의 피해를 입힙니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10a0
method relativeTooltip takes Unit caster returns string
	return "검을 휘둘러 대상에게 "+"|cffff9900"+R2SW(1.15*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입힙니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10b0
method relativeTooltip takes Unit caster returns string
	return "대상을 짓눌러 "+"|cffff9900"+R2SW((0.65*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)+0.0275*caster.getCarculatedStatValue(CONFIG_STAT_MAXHP))*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+CustomString.shiftStatTooltip(CONFIG_STAT_MAXHP)+"의 피해를 입힙니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10c0
method relativeTooltip takes Unit caster returns string
	return "대상에게 가시를 발사하여 "+"|cffff9900"+R2SW(1.1*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입힙니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10d0
method relativeTooltip takes Unit caster returns string
	return "|cffffffff"+"8.0초"+"|r"+" 동안 자신을 제외한 주변 아군들의 "+"|cff00dd00체력재생|r"+"|cff00dd00"+"이 "+R2SW((0.5*caster.getCarculatedStatValue(CONFIG_STAT_HPREGEN))*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_HPREGEN)+", "+"|cffff9900공격력|r"+"|cffff9900"+"이 "+R2SW((15+.level*1),1,1)+"%"+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_SKILL_LEVEL)+" 증가합니다. 대상이 "+"|cff00ffff소환물|r"+"일 경우 "+"|cffc3dbff소환 지속시간|r"+"|cffc3dbff"+"을 "+"5.0초"+"|r"+" 연장시킵니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10e0
method relativeTooltip takes Unit caster returns string
	return "대상을 들이받아 "+"|cffff9900"+R2SW((1.0*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)+0.2*caster.getCarculatedStatValue(CONFIG_STAT_DEFENSE))*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+CustomString.shiftStatTooltip(CONFIG_STAT_DEFENSE)+"의 피해를 입힙니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10f0
method relativeTooltip takes Unit caster returns string
	return "대상에게 "+"|cffff9900"+R2SW((0.65*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)+0.3*caster.getCarculatedStatValue(CONFIG_STAT_MAGICPOWER))*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+CustomString.shiftStatTooltip(CONFIG_STAT_MAGICPOWER)+"의 피해를 입히고 "+"|cff0099ff마나|r"+"|cff0099ff"+"를 "+R2SW((10.0+2.0*caster.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_SKILL_LEVEL)+" 감소시키며 대상이 "+"|cff00ffff소환물|r"+"일 경우 "+"|cffc3dbff소환 지속시간|r"+"|cffc3dbff"+"을 "+"3.5초"+"|r"+" 감소시킵니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10g0
method relativeTooltip takes Unit caster returns string
	return "그물을 던져 처음 적중한 적에게 "+"|cffff9900"+R2SW(0.5*caster.getCarculatedStatValue(CONFIG_STAT_ACCURACY)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ACCURACY)+"의 피해를 입힙니다. 적중당한 대상은 "+"|cffffffff"+"4.0초"+"|r"+" 동안 "+"|cff99ccff회피치|r"+"|cff99ccff"+"가 "+R2SW(0.2*caster.getCarculatedStatValue(CONFIG_STAT_ACCURACY)*(1+0.06*.level),2,2)+"|r"+" 감소하고 "+"|cffffff99이동속도|r"+"|cffffff99"+"가 "+"33%"+"|r"+" 감소하며 이동기 사용이 제한됩니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10h0
method relativeTooltip takes Unit caster returns string
	return "대상에게 "+"|cffffffff"+"2개"+"|r"+"의 도끼를 던져 각각 "+"|cffff9900"+R2SW(0.5*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입힙니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10i0
method relativeTooltip takes Unit caster returns string
	return "대상을 향해 "+"|cffffffff"+"3발"+"|r"+"의 탄환을 발사하여 각각 처음 적중하는 적에게 "+"|cffff9900"+R2SW(0.4*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입힙니다."+"\n"+"\n"+" - 첫 탄환만 적중 시 발생효과를 발생시킵니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10j0
method relativeTooltip takes Unit caster returns string
	return "주변의 적들에게 "+"|cff9999ff"+R2SW((0.0375*caster.getCarculatedStatValue(CONFIG_STAT_MAXHP)+0.075*caster.getCarculatedStatValue(CONFIG_STAT_MAXMP))*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAXHP)+CustomString.shiftStatTooltip(CONFIG_STAT_MAXMP)+"의 피해를 입힙니다. "+"|cff00ffff탑승|r"+" 상태에서 사용 시 탑승물의 위치를 기준으로 사용합니다."
endmethod
method customCostTooltip takes nothing returns string
	return "|cffff3333"+"현재 체력"+"의 "+"12%"+" 소모"+"|r"
endmethod
//! endtextmacro
//! textmacro abilityTooltip10k0
method relativeTooltip takes Unit caster returns string
	return "대상에게 화살을 발사하여 "+"|cffff9900"+R2SW(1.1*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입힙니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10l0
method relativeTooltip takes Unit caster returns string
	return "|cffffffff"+"레벨 "+I2S(1*.level)+"|r"+" "+"전기충격기"+"를 건설합니다. "+"전기충격기"+"는 "+"|cffff9900"+"기본"+"공격으로 가하는 피해가 "+"50%"+"|r"+" 증가하고 "+"|cffc3dbff"+"10.0초"+"|r"+" 동안 지속됩니다."+"\n"+"\n"+"|cff00ffff"+"전기충격기"+" 사용 무기 : "+"|r"+"|cffffffff"+"레벨 "+I2S(1*.level)+" "+"전기충격"+"|r"
endmethod
method customCostTooltip takes nothing returns string
	return "|cffff3333"+"현재 체력"+"의 "+"10%"+" 소모"+"|r"
endmethod
//! endtextmacro
//! textmacro abilityTooltip10m0
method relativeTooltip takes Unit caster returns string
	return "대상을 포함한 최대 "+"|cffffffff"+"4"+"기"+"|r"+"의 적들에게 "+"|cff9999ff"+R2SW(0.65*caster.getCarculatedStatValue(CONFIG_STAT_MAGICPOWER)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAGICPOWER)+"의 피해를 입힙니다."+"\n"+"첫 대상에게는 피해량이 "+"|cffff00ff"+R2SW(0.35*caster.getCarculatedStatValue(CONFIG_STAT_ACCURACY)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ACCURACY)+" 증가합니다."+"\n"+"\n"+"- 첫 대상에게만 적중 시 발생효과를 발생시킵니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10n0
method relativeTooltip takes Unit caster returns string
	return "대상에게 "+"|cffff9900"+R2SW((0.55*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)+0.55*caster.getCarculatedStatValue(CONFIG_STAT_MAGICPOWER))*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+CustomString.shiftStatTooltip(CONFIG_STAT_MAGICPOWER)+"의 피해를 입힙니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10o0
method relativeTooltip takes Unit caster returns string
	return "대상에게 금화를 던져 "+"|cffff9900"+R2SW(1.0*caster.getCarculatedStatValue(CONFIG_STAT_LUCK)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_LUCK)+"의 피해를 입히고 "+"|cff00cc00"+R2SW(caster.getLuckyPercent(0.1,300.0)*100.,1,1)+"%|r"+CustomString.shiftStatTooltip(CONFIG_STAT_LUCK)+" 확률로 "+"|cffffcc00"+"금화"+"를 "+"1"+"|r"+" 획득합니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10p0
method relativeTooltip takes Unit caster returns string
	return "지정한 방향으로 돌진하여 충돌하는 적들에게 "+"|cffff9900"+R2SW(0.075*caster.getCarculatedStatValue(CONFIG_STAT_MAXHP)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAXHP)+"의 피해를 입힙니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10q0
method relativeTooltip takes Unit caster returns string
	return "단검으로 공격해 대상에게 "+"|cffff9900"+R2SW(0.7*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입힙니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10r0
method relativeTooltip takes Unit caster returns string
	return "|cffffff00강한타격|r"+"계열 공격과 "+"|cff00ffff"+"근접"+"공격"+"|r"+"의 피해량이 "+"|cffffffff"+R2SW((10+1*.level),1,1)+"%"+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_SKILL_LEVEL)+" 증가합니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10s0
method relativeTooltip takes Unit caster returns string
	return "|cffffff00참격|r"+", "+"|cffffff00관통|r"+"계열 공격의 피해량이 "+"|cffffffff"+R2SW((10+1*.level),1,1)+"%"+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_SKILL_LEVEL)+" 증가합니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10t0
method relativeTooltip takes Unit caster returns string
	return "|cff00dd00"+"체력재생"+"이 "+R2SW((15+1*.level),1,1)+"%"+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_SKILL_LEVEL)+" 증가합니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10u0
method relativeTooltip takes Unit caster returns string
	return "대상에게 뛰어들어 "+"|cffff9900"+R2SW(2.0*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입힙니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10v0
method relativeTooltip takes Unit caster returns string
	return "대상에게 "+"|cffff9900"+R2SW(1.05*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입히는 거미뗴를 날립니다. 적중당한 대상은 "+"|cffffffff"+"4.0초"+"|r"+" 동안 "+"|cffff9900공격력|r"+"|cffff9900"+"이 "+R2SW(0.03*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.06*.level),2,2)+"|r"+" 감소하고 "+"|cffffff99이동속도|r"+"|cffffff99"+"가 "+"5.0"+"|r"+" 감소합니다."+"\n"+"\n"+" - 해당 약화효과는 중첩됩니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10w0
method relativeTooltip takes Unit caster returns string
	return "대상에게 달려들어 "+"|cffff9900"+R2SW(1.55*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입힌 뒤 다시 후퇴합니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10x0
method relativeTooltip takes Unit caster returns string
	return "대상에게 "+"|cff9999ff"+R2SW(1.0*caster.getCarculatedStatValue(CONFIG_STAT_MAGICPOWER)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAGICPOWER)+"의 피해를 입히는 투사체를 발사합니다. 적중 시 "+"|cff0099ff마나|r"+"|cff0099ff"+"를 "+R2SW(caster.getCarculatedStatValue(CONFIG_STAT_MAGICPOWER)*0.2,1,1)+"|r"+" 회복합니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10y0
method relativeTooltip takes Unit caster returns string
	return "대상에게 "+"|cffff9900"+R2SW((0.75*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)+0.01*caster.getCarculatedStatValue(CONFIG_STAT_MAXHP))*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+CustomString.shiftStatTooltip(CONFIG_STAT_MAXHP)+"의 피해를 입힙니다. 대상은 "+"|cffffffff"+"4.0초"+"|r"+" 동안 "+"|cff00ff00최대체력|r"+"|cff00ff00"+"이 "+R2SW(0.025*caster.getCarculatedStatValue(CONFIG_STAT_MAXHP)*(1+0.06*.level),2,2)+"|r"+" 감소합니다."+"\n"+"\n"+" - 해당 약화효과는 중첩됩니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10z0
method relativeTooltip takes Unit caster returns string
	return "|cffffffff"+"20.0초"+"|r"+"에 걸쳐 "+"|cff0099ff"+"마나"+"가 "+R2SW(20.0*(1+0.06*.level),1,1)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_SKILL_LEVEL)+" 회복되며 "+"|cff00ffff"+"포만감"+"이 "+"50"+"|r"+" 증가합니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10A0
method relativeTooltip takes Unit caster returns string
	return "|cffffffff"+"20.0초"+"|r"+"에 걸쳐 "+"|cff00ff00"+"체력"+"이 "+R2SW(50.0*(1+0.06*.level),1,1)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_SKILL_LEVEL)+" 회복되며 "+"|cff00ffff"+"포만감"+"이 "+"50"+"|r"+" 증가합니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip10B0
method relativeTooltip takes Unit caster returns string
	return "다음 조건을 만족할 때마다 "+"|cffffffff"+"1의 충전"+"|r"+"을 획득합니다."+"\n"+"\n"+" - 매 "+"|cffffffff"+"30.0초"+"|r"+" 경과"+"\n"+" - (추가 작성 필요)"+"\n"+"\n"+"이 스킬이 제거, 합성되면 "+"|cff00cc00"+"충전 수치 만큼의 "+"행운포인트"+"|r"+"를 획득합니다. (충전한도 : "+"|cffffffff"+I2S(10+2*.level)+"|r"+")"+CustomString.shiftStatTooltip(CONFIG_STAT_SKILL_LEVEL)
endmethod
//! endtextmacro
//! textmacro abilityTooltip10C0
method relativeTooltip takes Unit caster returns string
	return "대상에게 "+"|cffff9900"+R2SW(1.1*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입힙니다. "+"|cff00ffff광물|r"+"타입의 적에게는 "+"|cffff9900"+R2SW(3.0*1.1*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.06*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입힙니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip2000
method relativeTooltip takes Unit caster returns string
	return "|cffffffff"+"5.0초"+"|r"+" 동안 "+"|cffffff99공격속도|r"+"|cffffff99"+"가 "+"30%"+"|r"+", "+"|cffffff99이동속도|r"+"|cffffff99"+"가 "+"10%"+"|r"+" 증가하며 "+"|cffff9900기본|r"+"|cffff9900"+"공격의 적중 피해량이 "+R2SW(0.175*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"증가합니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip2030
method relativeTooltip takes Unit caster returns string
	return "주변의 적들을 무자비하게 도륙하여 "+"|cffffffff"+"0.25초"+"|r"+" 마다 "+"|cffff9900"+R2SW(0.3*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입힙니다. 총 "+"|cffffffff"+"8"+"회"+"|r"+" 공격합니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip2040
method relativeTooltip takes Unit caster returns string
	return "대상에게 "+"|cffffffff"+R2SW(0.6*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입히는 무작위 카드를 투척합니다. "+"|cff00cc00"+R2SW(caster.getLuckyPercent(0.25,255.0)*100.,1,1)+"%|r"+CustomString.shiftStatTooltip(CONFIG_STAT_LUCK)+" 확률로 한 장의 카드를 추가로 투척합니다. 피해유형과 공격유형이 카드의 색깔에 따라 달라집니다."+"\n"+"\n"+"|cffff0000"+"빨간색 카드 : "+"|r"+"|cffff9900물리|r"+", "+"|cffff9900기본|r"+"\n"+"|cff3333ff"+"파란색 카드 : "+"|r"+"|cff9999ff마법|r"+", "+"|cffff9900기본|r"+"\n"+"|cffffff00"+"황금색 카드 : "+"|r"+"|cffff9900물리|r"+", "+"|cff9999ff스킬|r"+"\n"+"|cffff00ff"+"보라색 카드 : "+"|r"+"|cff9999ff마법|r"+", "+"|cff9999ff스킬|r"
endmethod
//! endtextmacro
//! textmacro abilityTooltip2050
method relativeTooltip takes Unit caster returns string
	return "직선 범위 내의 적들에게 "+"|cff9999ff"+R2SW(2.65*caster.getCarculatedStatValue(CONFIG_STAT_MAGICPOWER)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAGICPOWER)+"의 피해를 입힙니다. 스킬 버튼을 길게 누를 시 사거리가 증가합니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip2060
method relativeTooltip takes Unit caster returns string
	return "지정한 방향으로 수리검 "+"|cffffffff"+"3"+"개"+"|r"+"를 투척하여 적중 시 각각 "+"|cffff9900"+R2SW((0.15*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)+0.05*caster.getCarculatedStatValue(CONFIG_STAT_ACCURACY))*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+CustomString.shiftStatTooltip(CONFIG_STAT_ACCURACY)+"의 피해를 입힙니다. 최대 "+"|cffffffff"+"3"+"회"+"|r"+" 충전됩니다."+"\n"+"\n"+" - 사용 중에 움직일 수 있습니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip2070
method relativeTooltip takes Unit caster returns string
	return "대상에게 "+"|cffff9900"+R2SW(1.2*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입힙니다. "+"|cffffffff"+"3"+"번째"+"|r"+" 공격은 "+"|cffffffff"+"5.0초"+"|r"+" 동안 대상을 불태워 매 초 "+"|cff9999ff"+R2SW(0.85*caster.getCarculatedStatValue(CONFIG_STAT_HPREGEN)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_HPREGEN)+"|cff9999ff"+"+(대상의 "+"체력재생"+"*"+"1.0"+")"+"|r"+" 에 해당하는 "+"|cffffff00화염|r"+"계열 피해를 입힙니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip2080
method relativeTooltip takes Unit caster returns string
	return "물가에 사용하여 낚시를 시작합니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip2090
method relativeTooltip takes Unit caster returns string
	return "지정한 방향으로 돌진하여 충돌하는 적들에게 "+"|cffff9900"+R2SW(0.1175*caster.getCarculatedStatValue(CONFIG_STAT_MAXHP)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAXHP)+"의 피해를 입힙니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip20a0
method relativeTooltip takes Unit caster returns string
	return "|cffc3dbff"+"5.0초"+"|r"+" 동안 대상을 공격하는 "+"|cffffffff"+"레벨 "+I2S(1*caster.level)+"|r"+" "+"돼지"+"를 소환합니다. "+"돼지"+"는 "+"|cffff9900"+"공격력"+"이 "+R2SW(caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK_SPEED)*(0.2+0.02*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK_SPEED)+" 증가하는 대신 적에게 "+"|cffffffff"+"50%"+"|r"+"의 피해를 입히며 소멸할 때 "+"|cffff3333"+"잃은 체력"+"의 "+"25%"+"|r"+"에 해당하는 만큼 시전자가 "+"|cffff3333"+"체력"+"을 "+"2.5초"+"에 걸쳐 잃습니다."+"|r"+"\n"+"\n"+"|cff00ffff"+"돼지"+" 사용 무기 : "+"|r"+"|cffffffff"+"레벨 "+I2S(1*caster.level)+" "+"뾰족한 가시"+"|r"+"\n"+"\n"+"|cff999999"+"고정된 공격속도를 가집니다."+"|r"
endmethod
//! endtextmacro
//! textmacro abilityTooltip20b0
method relativeTooltip takes Unit caster returns string
	return "|cffffffff"+"9.0초"+"|r"+" 동안 "+"|cffc690e1"+"내구도 "+R2SW(1.65*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.07*.level),1,1)+"의 "+"보호막"+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"을 전개합니다. 보호막이 지속되는 동안 "+"|cff00ff99"+"저항력"+"이 "+R2SW(0.45*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.07*.level),1,1)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+", "+"|cffffff99"+"공격속도"+"가 "+"20%"+"|r"+" 증가합니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip20c0
method relativeTooltip takes Unit caster returns string
	return "대상에게 "+"|cffff9900"+R2SW(1.05*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입히고 "+"|cffffffff"+"5.0초"+"|r"+" 동안 대상을 중독시켜 매 초 "+"|cffff9900"+R2SW(0.2*caster.getCarculatedStatValue(CONFIG_STAT_ACCURACY)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ACCURACY)+" 에 해당하는 "+"|cffffff00독성|r"+"계열 피해를 입힙니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip20d0
method relativeTooltip takes Unit caster returns string
	return "|cffffffff"+"1.5초"+"|r"+" 동안 "+"|cffffff99이동속도|r"+"가 대폭 감소하며 해당 효과가 만료되면 "+"|cffffffff"+"5.0초"+"|r"+" 내에 적중하는 다음 "+"|cffff9900"+"기본"+"공격의 피해량이 "+R2SW(1.25*caster.getCarculatedStatValue(CONFIG_STAT_ACCURACY)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ACCURACY)+" 증가합니다."+"\n"+"\n"+" - 다른 행동 중에 사용할 수 있습니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip20e0
method relativeTooltip takes Unit caster returns string
	return "선택한 지점으로 도약하여 착지 시 주변 적들에게 "+"|cffff9900"+R2SW((1.8*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)+0.03*caster.getCarculatedStatValue(CONFIG_STAT_MAXHP))*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+CustomString.shiftStatTooltip(CONFIG_STAT_MAXHP)+"의 피해를 입힙니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip20f0
method relativeTooltip takes Unit caster returns string
	return "대상에게 "+"|cffff9900"+R2SW(0.7*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입히고 "+"|cff00cc00"+R2SW(caster.getLuckyPercent(0.25,200.0)*100.,1,1)+"%|r"+CustomString.shiftStatTooltip(CONFIG_STAT_LUCK)+" 확률로 "+"|cffffffff"+"레벨 "+I2S(1*.level)+"|r"+" 공격자의 환영을 만들어 공격하게 합니다. 환영은 최대 "+"|cffc3dbff"+"3.0초"+"|r"+" 지속됩니다."+"\n"+"\n"+"|cff00ffff"+"환영 : "+"|r"+"|cffff9900"+R2SW(0.3*caster.getCarculatedStatValue(CONFIG_STAT_ACCURACY)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ACCURACY)+"|cffff9900"+"의 증가된 "+"공격력"+"|r"+"을 가지며 "+"|cffffffff"+"33%"+"|r"+"의 피해를 입힘"
endmethod
//! endtextmacro
//! textmacro abilityTooltip20g0
method relativeTooltip takes Unit caster returns string
	return "|cffffffff"+"4.0초"+"|r"+" 동안 "+"|cffffff99"+"공격속도"+"가 "+"50%"+"|r"+" 증가하고 "+"|cffff9900"+"기본"+"공격의 피해량이 "+R2SW(0.15*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+" 증가합니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip20h0
method relativeTooltip takes Unit caster returns string
	return "선택한 아군 유닛과 결속하여("+"|cff00ffff탑승|r"+" 상태로 간주) 매 초 대상의 "+"|cff00ff00"+"체력"+"을 "+R2SW(0.027*caster.getCarculatedStatValue(CONFIG_STAT_MAXHP)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAXHP)+", "+"|cff0099ff"+"마나"+"를 "+R2SW(0.022*caster.getCarculatedStatValue(CONFIG_STAT_MAXMP)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAXMP)+" 회복시킵니다. 대상이 플레이어 소유일 경우 우클릭으로 조종할 수 있습니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip20i0
method relativeTooltip takes Unit caster returns string
	return "선택한 지점에 "+"|cffffffff"+"레벨 "+I2S(1*.level)+"|r"+" "+"정찰탑"+"을 건설합니다. 최대 한 기의 아군 유닛이 내부에 들어갈 수 있습니다.("+"|cff00ffff탑승|r"+" 상태로 간주)"+"\n"+"\n"+" - "+"정찰탑"+"은 최대 한 개만 존재할 수 있습니다."+"\n"+"\n"+"|cff00ffff"+"정찰탑"+" 사용 무기 : "+"|r"+"|cffffffff"+"레벨 "+I2S(1*.level)+" "+"사냥꾼의 장궁"+"|r"
endmethod
method customCostTooltip takes nothing returns string
	return "|cffff3333"+"현재 체력"+"의 "+"25%"+" 소모"+"|r"
endmethod
//! endtextmacro
//! textmacro abilityTooltip20j0
method relativeTooltip takes Unit caster returns string
	return "늑대정령으로 변신합니다. "+"|cffffff99"+"이동속도"+"가 "+I2S(60)+"|r"+", "+"|cffffff99"+"공격속도"+"가 "+R2SW((13.5+.level*1.5),1,1)+"%"+"|r"+" 증가하며 "+"|cffff9900"+"근접"+" "+"기본"+"공격 적중 시 피해량이 "+R2SW(0.225*caster.getCarculatedStatValue(CONFIG_STAT_MAGICPOWER)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAGICPOWER)+" 증가하고 "+"|cff0099ff"+"마나"+"를 "+"3"+"|r"+" 회복합니다."
endmethod
method customCostTooltip takes nothing returns string
	return "|cff0099ff"+"매 초 "+"마나"+"소모 "+"3"+"|r"
endmethod
//! endtextmacro
//! textmacro abilityTooltip20k0
method relativeTooltip takes Unit caster returns string
	return "고대 코끼리로 변신합니다. "+"|cffffff99"+"이동속도"+"가 "+I2S(20)+"|r"+", "+"|cff00ff00"+"최대체력"+"이 "+"25%"+"|r"+" 증가하며 "+"|cffff9900"+"근접"+" "+"기본"+"공격 적중 시 피해량이 "+R2SW(0.0175*caster.getCarculatedStatValue(CONFIG_STAT_MAXHP)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAXHP)+" 증가합니다."
endmethod
method customCostTooltip takes nothing returns string
	return "|cff0099ff"+"매 초 "+"마나"+"소모 "+"3"+"|r"
endmethod
//! endtextmacro
//! textmacro abilityTooltip20l0
method relativeTooltip takes Unit caster returns string
	return "대상에게 글레이브를 던져 "+"|cffff9900"+R2SW(1.1*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입힙니다. 글레이브는 적중한 뒤 가까운 다른 대상에게 튕겨 "+"|cffffffff"+"이전 피해량의 "+"75%"+"|r"+"에 해당하는 피해를 입힙니다. 튕김 횟수가 남은 상태에서 튕길 대상이 없을 경우 마지막으로 타격한 적을 한 번 더 타격하여 "+"|cffffffff"+"이전 피해량의 "+"40%"+"|r"+"에 해당하는 피해를 입히고 소멸합니다."+"\n"+"\n"+" - 주 대상을 포함하여 최대 "+"|cffffffff"+"3"+"기"+"|r"+"의 대상을 공격할 수 있습니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip20m0
method relativeTooltip takes Unit caster returns string
	return "대상에게 "+"|cffff9900"+R2SW(1.25*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입히는 창을 던집니다. 빈 땅을 우클릭하면 창을 던진 뒤 지정한 방향으로 짧은 거리 도약합니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip20n0
method relativeTooltip takes Unit caster returns string
	return "|cffffffff"+"3.5초"+"|r"+" 동안 "+"|cffffcc99방어력|r"+"과 "+"|cff00ff99저항력|r"+"이 "+"|cffffffff"+R2SW((35+.level*1.5),1,1)+"%"+"|r"+" 증가합니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip20o0
method relativeTooltip takes Unit caster returns string
	return "|cffffffff"+"3.0초"+"|r"+" 동안 "+"|cffffff99"+"공격속도"+"가 "+"60%"+"|r"+" 증가하고 "+"|cffff9900"+"기본"+"공격의 피해량이 "+R2SW(0.05*caster.getCarculatedStatValue(CONFIG_STAT_MAXHP)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAXHP)+" 증가하는 대신 공격 시 "+"|cffff3333"+"5%"+"의 "+"체력"+"을 소모"+"|r"+"합니다."+"\n"+"\n"+" - 해당 체력감소 효과로 "+"|cff00ff00"+"체력"+"이 "+"10%"+" 미만"+"|r"+"으로 내려가지 않습니다."+"\n"+" - 근접 무기 장착 시에만 사용할 수 있습니다."+"\n"+" - 무기교체 시 강화효과가 사라집니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip20p0
method relativeTooltip takes Unit caster returns string
	return "지정한 방향으로 거미줄을 발사하여 처음 적중하는 적에게 "+"|cffff9900"+R2SW(0.75*caster.getCarculatedStatValue(CONFIG_STAT_ACCURACY)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ACCURACY)+"의 피해를 입히고 "+"|cffffffff"+"5.0초"+"|r"+" 동안 "+"|cffffff99"+"이동속도"+"를 "+"33%"+"|r"+", "+"|cffffcc99"+"방어력"+"을 "+R2SW(0.4*caster.getCarculatedStatValue(CONFIG_STAT_ACCURACY)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ACCURACY)+" 감소시키며 이동기 사용을 제한합니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip20q0
method relativeTooltip takes Unit caster returns string
	return "대상에게 "+"|cffff9900"+R2SW(1.25*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입히는 투사체를 발사하며 적중 시 "+"|cff00cc00"+R2SW(caster.getLuckyPercent(0.25,166.0)*100.,1,1)+"%|r"+CustomString.shiftStatTooltip(CONFIG_STAT_LUCK)+" 확률로 "+"|cffffffff"+"레벨 "+I2S(1*.level)+"|r"+" 대상의 환영을 만들어 공격하게 합니다. 환영은 최대 "+"|cffc3dbff"+"3.0초"+"|r"+" 지속됩니다."+"\n"+"\n"+"|cff00ffff"+"환영 : "+"|r"+"|cffff9900"+R2SW(0.3*caster.getCarculatedStatValue(CONFIG_STAT_ACCURACY)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ACCURACY)+"|cffff9900"+"의 증가된 "+"공격력"+"|r"+"을 가지며 "+"|cffffffff"+"33%"+"|r"+"의 피해를 입힘"
endmethod
//! endtextmacro
//! textmacro abilityTooltip20r0
method relativeTooltip takes Unit caster returns string
	return "|cffc3dbff"+"15.0초"+"|r"+" 동안 지속되는 "+"|cffffffff"+"1"+"기"+"|r"+"의 "+"해골 전사"+"를 소환하여 지정한 방향으로 진격시킵니다. "+"해골 전사"+"는 "+"|cffff9900"+"공격력"+"이 "+R2SW(0.2*caster.getCarculatedStatValue(CONFIG_STAT_MAGICPOWER)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAGICPOWER)+", "+"|cff00ff00"+"최대체력"+"이 "+R2SW(0.2*caster.getCarculatedStatValue(CONFIG_STAT_MAXHP)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAXHP)+" 증가하고 적에게 "+"|cffffffff"+"66%"+"|r"+"의 피해를 입힙니다."+"\n"+"\n"+"|cff00ffff"+"해골 전사"+" 사용 무기 : "+"|r"+"|cffffffff"+"레벨 "+I2S(1*.level)+" "+"조잡한 검"+"|r"
endmethod
//! endtextmacro
//! textmacro abilityTooltip20s0
method relativeTooltip takes Unit caster returns string
	return "적에게 공격받으면 "+"|cffffffff"+"0.5초"+"|r"+"마다 주변 적들에게 "+"|cff9999ff"+R2SW(1.25*caster.getCarculatedStatValue(CONFIG_STAT_HPREGEN)*(1+0.07*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_HPREGEN)+"의 피해를 입히고 "+"|cffffffff"+"1.5초"+"|r"+" 동안 "+"|cffff3333"+"받는 회복량"+"을 "+"75%"+"|r"+"감소시킵니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip3000
method relativeTooltip takes Unit caster returns string
	return "지정한 방향으로 "+"|cffffffff"+"10"+"발"+"|r"+"의 탄환을 발사하여 발 당 "+"|cffff9900"+R2SW(0.45*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.08*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입힙니다."+"\n"+"\n"+" - 발사 간격 : "+"|cffffffff"+"0.125초"+"|r"+"\n"+"\n"+"|cff999999"+"사용 중에 움직일 수 있습니다."+"|r"
endmethod
//! endtextmacro
//! textmacro abilityTooltip3010
method relativeTooltip takes Unit caster returns string
	return "지정 범위에 감속영역을 전개합니다. 범위 내의 적들은 "+"|cffffffff"+"0.5초"+"|r"+"마다 "+"|cff9999ff"+R2SW(0.1*caster.getCarculatedStatValue(CONFIG_STAT_MAGICPOWER)*(1+0.08*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAGICPOWER)+"의 피해를 입고 "+"|cffffffff"+"4.5초"+"|r"+" 동안 "+"|cffffff99"+"이동속도"+"가 "+"15"+"|r"+", "+"|cff99ccff"+"회피치"+"가 "+R2SW(0.02*caster.getCarculatedStatValue(CONFIG_STAT_MAGICPOWER)*(1+0.08*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAGICPOWER)+" 감소합니다."+"\n"+"\n"+" - 감속영역 최대 공격횟수 : "+"|cffffffff"+"10"+"회"+"|r"+"\n"+"\n"+"|cff999999"+"해당 약화효과는 중첩됩니다."+"|r"
endmethod
//! endtextmacro
//! textmacro abilityTooltip3020
method relativeTooltip takes Unit caster returns string
	return "정신집중하여 "+"|cffffffff"+"0.25초"+"|r"+" 마다 대상에게 "+"|cff9999ff"+R2SW(0.2*caster.getCarculatedStatValue(CONFIG_STAT_MAGICPOWER)*(1+0.08*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAGICPOWER)+"의 피해를 입히고 "+"|cff00ff00"+"원본 피해량의 "+"40%"+"에 해당하는 "+"체력"+"|r"+"을 회복하며 "+"|cffffffff"+"충전을 1 획득합니다.(최대 "+"10"+"까지 획득)"+"|r"+" 충전이 1 이상일 때 "+"|cff9999ff"+"스킬"+"공격"+"|r"+"으로 피해를 입히면 충전을 모두 소모해 소모한 충전 1당 "+"|cff00dd00"+"피해량을 "+R2SW(0.75*caster.getCarculatedStatValue(CONFIG_STAT_HPREGEN)*(1+0.08*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_HPREGEN)+" 증가시킵니다.(최대 피해량 : "+"|cff00dd00"+R2SW(7.5*caster.getCarculatedStatValue(CONFIG_STAT_HPREGEN)*(1+0.08*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_HPREGEN)+")"+"\n"+"\n"+" - "+"|cffffffff"+"충전"+"|r"+"이 최대치일 때 이 스킬의 회복량이 "+"|cffffffff"+"50%"+"|r"+"로 감소합니다."+"\n"+" - 정신집중 후 매 "+"|cffffffff"+"3"+"번째"+"|r"+" 공격만 적중 시 발생효과를 발생시킵니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip3030
method relativeTooltip takes Unit caster returns string
	return "대상에게 "+"|cff9999ff"+R2SW(1.3*caster.getCarculatedStatValue(CONFIG_STAT_MAGICPOWER)*(1+0.08*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAGICPOWER)+"의 피해를 입히는 전격 구체를 발사하고 짧은 시간동안 "+"|cffffff99이동속도|r"+"가 증가하며 공격자의 자리에 "+"|cffffffff"+"2.0초"+"|r"+" 동안 지속되는 예비 전격 구체를 남깁니다. 이미 예비 전격 구체가 있을 경우 구체와의 거리에 비례해 "+"|cffffffff"+"20%"+"~"+"100%"+"|r"+"의 피해를 입히는 전격 구체를 추가로 발사합니다."+"\n"+"\n"+" - 예비 구체와의 거리가 "+"|cffffffff"+"400.0"+"|r"+" 이상일 때 최대 피해량이 적용됩니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip3040
method relativeTooltip takes Unit caster returns string
	return "대상에게 "+"|cffff9900"+R2SW(1.57*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.08*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입히는 바람 칼날을 사출하며 대상과의 거리가 "+"|cffffffff"+"600.0"+"|r"+" 이상이면 대상과의 거리가 "+"|cffffffff"+"575.0"+"|r"+"(으)로 좁혀질 때 까지 돌진합니다."+"\n"+"\n"+" - 돌진 가능 거리일 때 돌진 발동에 실패하면 바람칼날이 사출되지 않습니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip3050
method relativeTooltip takes Unit caster returns string
	return "스킬 습득 시 "+"|cffffffff"+"레벨 "+I2S(1*.level)+"|r"+" "+"군마"+"가 소환됩니다. "+"군마"+"를 우클릭하여 "+"|cff00ffff탑승|r"+"할 수 있으며 해당 방식으로 탑승 시 "+"군마"+"의 "+"|cffffff99"+"이동속도"+"가 "+"110"+"|r"+" 증가합니다."+"\n"+"\n"+"|cff00ffff"+"사용 시 : "+"|r"+"군마"+"를 해당 위치로 이동시킵니다. "+"군마"+"를 대상으로 사용 시 "+"군마"+"와 시전자가 서로의 위치로 이동하며 탑승을 시도하고 자신을 대상으로 사용 시 "+"군마"+"를 자신의 위치에 소환합니다."+"\n"+"\n"+"|cff00ffff"+"Shift+스킬단축키 : "+"|r"+"군마"+"가 지정한 위치에 "+"|cffffffff"+"레벨 "+I2S(1*.level)+"|r"+" "+"돌진 v2"+"을 사용합니다."+"\n"+"\n"+"|cff00ffff"+"군마"+" 사용 무기 : "+"|r"+"|cffffffff"+"레벨 "+I2S(1*.level)+" "+"짓밟기"+"|r"
endmethod
//! endtextmacro
//! textmacro abilityTooltip3060
method relativeTooltip takes Unit caster returns string
	return "갈고리를 던져 처음 맞는 적에게 "+"|cffff9900"+R2SW(2.85*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.08*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입히고 시전자 앞으로 끌어옵니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip3070
method relativeTooltip takes Unit caster returns string
	return "전방의 적들을 휩쓸어 "+"|cff9999ff"+R2SW((0.65*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)+0.55*caster.getCarculatedStatValue(CONFIG_STAT_MAGICPOWER))*(1+0.08*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+CustomString.shiftStatTooltip(CONFIG_STAT_MAGICPOWER)+"의 피해를 입힙니다. "+"|cffffffff"+"매 "+"3"+"번째"+"|r"+" 공격은 직선상의 적들에게 "+"|cffffffff"+"150%"+"|r"+"의 피해를 입힙니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip3080
method relativeTooltip takes Unit caster returns string
	return "지정한 위치로 순간이동한 뒤 경로상의 적들에게 "+"|cffff9900"+R2SW((1.75*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)+0.75*caster.getCarculatedStatValue(CONFIG_STAT_ACCURACY))*(1+0.08*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+CustomString.shiftStatTooltip(CONFIG_STAT_ACCURACY)+"의 피해를 입힙니다. 한 기 이상의 적에게 적중하면 "+"|cff0099ff"+"마나"+"를 "+R2SW(26.0,1,1)+"|r"+" 회복합니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip4000
method relativeTooltip takes Unit caster returns string
	return "미사일 컨테이너를 소환합니다. 미사일 컨테이너는 매 "+"|cffffffff"+"0.125초"+"|r"+"마다 주변의 무작위 대상 하나에게 "+"|cffff9900"+R2SW(1.25*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.09*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입히는 미사일을 발사합니다. "+"|cffffffff"+"20"+"개"+"|r"+"의 미사일을 발사하거나 "+"|cffffffff"+"3.0초"+"|r"+"가 경과하면 미사일 컨테이너는 소멸합니다."+"\n"+"\n"+" - 이미 미사일에 공격받은 대상은 "+"|cffffffff"+"30%"+"|r"+"의 피해를 입습니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip4010
method relativeTooltip takes Unit caster returns string
	return "지정 경로 내의 적들에게 "+"|cff9999ff"+R2SW(3.75*caster.getCarculatedStatValue(CONFIG_STAT_MAGICPOWER)*(1+0.09*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAGICPOWER)+"의 피해를 입힙니다."
endmethod
//! endtextmacro
//! textmacro abilityTooltip5000
method relativeTooltip takes Unit caster returns string
	return "화룡의 불길로 매 "+"|cffffffff"+"0.2초"+"|r"+"마다 지정 범위 내의 적들에게 "+"|cff9999ff"+R2SW(0.67*caster.getCarculatedStatValue(CONFIG_STAT_MAGICPOWER)*(1+0.1*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAGICPOWER)+"의 피해를 입힙니다. 해당 공격은 "+"|cff00ff99"+"대상의 "+"저항력"+"을 "+"50%"+"|r"+" 무시합니다."+"\n"+"\n"+" - 공격횟수 : "+"|cffffffff"+"15"+"회"+"|r"+"(최대 피해량 : "+"|cff9999ff"+R2SW(10.05*caster.getCarculatedStatValue(CONFIG_STAT_MAGICPOWER)*(1+0.1*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_MAGICPOWER)+")"+"\n"+"\n"+"|cff999999"+"다른 행동 중에 사용할 수 있습니다."+"|r"
endmethod
//! endtextmacro
//! textmacro abilityTooltip5010
method relativeTooltip takes Unit caster returns string
	return "지정한 방향으로 무차별 난사하여 "+"|cffffffff"+"0.125초"+"|r"+"마다 범위 내의 적들에게 "+"|cffff9900"+R2SW(0.55*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.1*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+"의 피해를 입힙니다."+"\n"+"\n"+" - 공격횟수 : "+"|cffffffff"+"20"+"회"+"|r"+"(최대 피해량 : "+"|cffff9900"+R2SW(11.0*caster.getCarculatedStatValue(CONFIG_STAT_ATTACK)*(1+0.1*.level),2,2)+"|r"+CustomString.shiftStatTooltip(CONFIG_STAT_ATTACK)+")"
endmethod
//! endtextmacro