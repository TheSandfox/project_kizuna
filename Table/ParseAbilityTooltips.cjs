const path = require('path');
const childProcess = require('child_process');

// 전역 설치된 모듈 경로 추적
try {
  const globalRoot = childProcess.execSync('npm root -g', { encoding: 'utf8' }).trim();
  module.paths.push(globalRoot);
} catch (e) {
  // ignore
}

const XLSX = require('xlsx');
const fs = require('fs');
const htmlparser2 = require('htmlparser2');

// Excel 시트 파싱 메모리 DB
let AbilityTable = {};
let BuffTable = {};
let UnitTable = {};
let EnumLookupTable = {};

let currentAbilityId = '';

// ---------------------------------------------------------------------------
// 1. EnumLookup 시트 파싱 로더
// ---------------------------------------------------------------------------
function loadEnumLookupParams(workbook) {
  const sheet = workbook.Sheets['EnumLookup'];
  if (!sheet) return;

  const rows = XLSX.utils.sheet_to_json(sheet, { header: 1, defval: null });
  if (!rows || rows.length < 2) return;

  const subfixCols = [];
  const headerRow = rows[0];

  for (let c = 2; c < headerRow.length; c++) {
    if (headerRow[c] === 'subfix' || (rows[1] && ['NAME', 'COLOR', 'ICON'].includes(rows[1][c]))) {
      subfixCols.push(c);
    }
  }

  for (let r = 1; r < rows.length; r++) {
    const row = rows[r];
    const rawIndex = row[0];
    const rawArrName = row[1];

    if (!rawIndex || !rawArrName) continue;

    const baseArrName = String(rawArrName).replace(/^CONSTANT_/, '');
    const enumIndex = String(rawIndex);

    for (const subfixColIdx of subfixCols) {
      const subfix = row[subfixColIdx];
      const val = row[subfixColIdx + 2];

      if (subfix && val !== undefined && val !== null) {
        const key = `${baseArrName}_${subfix}`;
        if (!EnumLookupTable[key]) EnumLookupTable[key] = {};

        EnumLookupTable[key][enumIndex] = String(val);
        const shortIndex = enumIndex.replace(/^ENUM_/, '');
        EnumLookupTable[key][shortIndex] = String(val);
      }
    }
  }
}

// ---------------------------------------------------------------------------
// 2. Ability / Buff / Unit 시트 로더
// ---------------------------------------------------------------------------
function loadAbilityParams(workbook) {
  const sheet = workbook.Sheets['AbilityParams'];
  if (!sheet) return;

  const rows = XLSX.utils.sheet_to_json(sheet, { header: 1, defval: null });
  if (!rows || rows.length === 0) return;

  const idRow = rows[0];
  const colCount = idRow.length;

  for (let c = 3; c < colCount; c++) {
    const abId = idRow[c];
    if (abId !== null && abId !== undefined) AbilityTable[String(abId)] = {};
  }

  for (let r = 1; r < rows.length; r++) {
    const propName = rows[r][0];
    if (!propName) continue;

    for (let c = 3; c < colCount; c++) {
      const abId = idRow[c];
      if (abId !== null && abId !== undefined) {
        const val = rows[r][c];
        AbilityTable[String(abId)][String(propName)] = val !== null ? val : '';
      }
    }
  }
}

function loadBuffParams(workbook) {
  const sheet = workbook.Sheets['BuffParams'];
  if (!sheet) return;

  const rows = XLSX.utils.sheet_to_json(sheet, { header: 1, defval: null });
  if (!rows || rows.length === 0) return;

  const idRow = rows[0];
  const colCount = idRow.length;

  for (let c = 3; c < colCount; c++) {
    const buffId = idRow[c];
    if (buffId !== null && buffId !== undefined) BuffTable[String(buffId)] = {};
  }

  for (let r = 1; r < rows.length; r++) {
    const propName = rows[r][0];
    if (!propName) continue;

    for (let c = 3; c < colCount; c++) {
      const buffId = idRow[c];
      if (buffId !== null && buffId !== undefined) {
        const val = rows[r][c];
        BuffTable[String(buffId)][String(propName)] = val !== null ? val : '';
      }
    }
  }
}

function loadUnitParams(workbook) {
  const sheet = workbook.Sheets['UnitParams'];
  if (!sheet) return;

  const rows = XLSX.utils.sheet_to_json(sheet, { header: 1, defval: null });
  if (!rows || rows.length === 0) return;

  const idRow = rows[0];
  const colCount = idRow.length;

  for (let c = 2; c < colCount; c++) {
    const unitId = idRow[c];
    if (unitId !== null && unitId !== undefined) UnitTable[String(unitId)] = {};
  }

  for (let r = 1; r < rows.length; r++) {
    const propName = rows[r][0];
    if (!propName) continue;

    for (let c = 2; c < colCount; c++) {
      const unitId = idRow[c];
      if (unitId !== null && unitId !== undefined) {
        const val = rows[r][c];
        UnitTable[String(unitId)][String(propName)] = val !== null ? val : '';
      }
    }
  }
}

// ---------------------------------------------------------------------------
// 3. 속성 값 및 EnumLookup 평가 함수
// ---------------------------------------------------------------------------
function getProperty(par) {
  if (!par) return '';

  if (par.startsWith('(') && par.includes(')')) {
    const inner = par.substring(2, par.lastIndexOf(')'));
    const context = par.substring(par.lastIndexOf(')') + 1);
    return getProperty(inner) + context;
  }

  const prefix = par[0];
  const rest = par.substring(1);

  let rawVal = '';

  switch (prefix) {
    case '#':
      rawVal = rest;
      break;
    case '$':
      rawVal = getProperty(rest);
      break;
    case '%': {
      let targetBuffId = '';
      let propName = '';

      if (rest.startsWith('(') && rest.includes(')')) {
        const closeIdx = rest.indexOf(')');
        targetBuffId = rest.substring(1, closeIdx);
        propName = rest.substring(closeIdx + 1);
      } else {
        targetBuffId = currentAbilityId;
        propName = rest;
      }

      if (AbilityTable[currentAbilityId]?.[targetBuffId] !== undefined) {
        targetBuffId = AbilityTable[currentAbilityId][targetBuffId];
      }

      rawVal = BuffTable[targetBuffId]?.[propName] ?? '';
      break;
    }
    case '^': {
      const targetAbilityId = rest.substring(0, 4);
      const propName = rest.substring(4);
      rawVal = AbilityTable[targetAbilityId]?.[propName] ?? '';
      break;
    }
    case '&': {
      let targetUnitId = '';
      let propName = '';

      if (rest.startsWith('(') && rest.includes(')')) {
        const closeIdx = rest.indexOf(')');
        targetUnitId = rest.substring(1, closeIdx);
        propName = rest.substring(closeIdx + 1);
      } else {
        targetUnitId = rest.substring(0, 4);
        propName = rest.substring(4);
      }

      // AbilityParams의 유닛 참조 프로퍼티(UNIT_ID1 등)인 경우 실제 유닛 ID로 변환
      if (AbilityTable[currentAbilityId]?.[targetUnitId] !== undefined) {
        targetUnitId = AbilityTable[currentAbilityId][targetUnitId];
      }

      rawVal = UnitTable[targetUnitId]?.[propName] ?? '';
      break;
    }
    default: {
      rawVal = AbilityTable[currentAbilityId]?.[par] ?? par;
      break;
    }
  }

  // 퍼센트 문자열('15%', '1%' 등)이 수식에 들어갈 때 실수(0.15, 0.01)로 자동 변환
  if (typeof rawVal === 'string' && rawVal.endsWith('%')) {
    const num = parseFloat(rawVal.slice(0, -1));
    if (!isNaN(num)) {
      return String(num / 100);
    }
  }

  return rawVal;
}

function getEnumLookupValue(attr) {
  if (!attr || !attr.includes(',')) return '';

  const commaIdx = attr.indexOf(',');
  const targetKey = attr.substring(0, commaIdx).trim();
  const rawIndexExpr = attr.substring(commaIdx + 1).trim();

  const evaluatedIndex = String(getProperty(rawIndexExpr));

  if (!EnumLookupTable[targetKey]) {
    return '';
  }

  return EnumLookupTable[targetKey][evaluatedIndex] ?? '';
}

// ---------------------------------------------------------------------------
// 4. 단일 태그 (Self-Closing Tag) 처리
// ---------------------------------------------------------------------------
function processMonoTag(tagName, attr) {
  switch (tagName) {
    case 'cstring': {
      const val = getEnumLookupValue(attr);
      return { type: 'string', value: val || '' };
    }
    case 'br':
      return { type: 'string', value: '\\n' };
    case 'prop':
      return { type: 'code', value: String(getProperty(attr)) };
    case 'propString':
      return { type: 'string', value: String(getProperty(attr)) };
    case 'second': {
      const did = getProperty(attr);
      return { type: 'string', value: `${did}초` };
    }
    case 'percent':
      return { type: 'string', value: `${Number(getProperty(attr)*100)}%` };
    case 'shift': {
      const did = getProperty(attr);
      return { type: 'code', value: `CustomString.shiftStatTooltip(ENUM_${did})` };
    }
    case 'xSkillLevel':
      return { type: 'code', value: '(1.+(.level-1)*DAMAGE_PER_LEVEL)' };
    case 'skillLevel':
      return { type: 'code', value: '.level' };
    case 'heroLevel':
      return { type: 'code', value: 'caster.level' };
    case 'statValue': {
      const did = getProperty(attr);
      return { type: 'code', value: `caster.getCarculatedStatValue(ENUM_${did})` };
    }
    case 'lucky': {
      const [p1Raw, p2Raw] = attr.split(',');
      const p1 = getProperty(p1Raw);
      const p2 = getProperty(p2Raw);
      const color = getEnumLookupValue('STAT_COLOR,STAT_LUCK');
      return {
        type: 'code',
        value: `"|cff${color}"+R2SW(caster.getLuckyPercent(${p1 / 100},${p2})*100.,1,1)+"%|r"+CustomString.shiftStatTooltip(ENUM_STAT_LUCK)`
      };
    }
    case 'multiply': {
      const [p1Raw, p2Raw] = attr.split(',');
      const p1 = Number(getProperty(p1Raw));
      const p2 = Number(getProperty(p2Raw));
      const res = p1 * p2;
      const strVal = Number.isInteger(res) ? String(res.toFixed(1)) : String(res);
      return { type: 'code', value: strVal };
    }
    case 'unitInfo': {
      const did = getProperty(attr);
      return { type: 'string', value: UnitTable[did]?.NAME || '' };
    }
    case 'abilityInfo': {
      const did = getProperty(attr);
      return { type: 'string', value: AbilityTable[did]?.NAME || '' };
    }
    default:
      return null;
  }
}

// ---------------------------------------------------------------------------
// 5. AST 순회 및 JASS 파싱
// ---------------------------------------------------------------------------
function traverseAst(node, tokens, inMathContext = false) {
  if (node.type === 'text') {
    if (node.data) {
      if (inMathContext) {
        tokens.push({ type: 'math_expr', value: node.data });
      } else {
        tokens.push({ type: 'string', value: node.data });
      }
    }
    return;
  }

  if (node.type === 'tag') {
    const tagName = node.name;
    const attr = node.attribs?.args || '';

    if (!node.children || node.children.length === 0) {
      const monoRes = processMonoTag(tagName, attr);
      if (monoRes) {
        if (inMathContext) {
          tokens.push({ type: 'math_expr', value: monoRes.value });
        } else {
          tokens.push(monoRes);
        }
      }
      return;
    }

    switch (tagName) {
      case 'real': {
        const mathTokens = [];
        node.children.forEach(child => traverseAst(child, mathTokens, true));
        const mathExpr = mathTokens.map(t => t.value).join('');
        const [w, d] = attr ? attr.split(',') : ['2', '2'];
        tokens.push({ type: 'code', value: `R2SW(${mathExpr},${w},${d})` });
        break;
      }
      case 'int': {
        const mathTokens = [];
        node.children.forEach(child => traverseAst(child, mathTokens, true));
        const mathExpr = mathTokens.map(t => t.value).join('');
        tokens.push({ type: 'code', value: `I2S(${mathExpr})` });
        break;
      }
      case 'percent': {
        const mathTokens = [];
        node.children.forEach(child => traverseAst(child, mathTokens, true));
        const mathExpr = mathTokens.map(t => t.value).join('');
        const [w, d] = attr ? attr.split(',') : ['1', '1'];
        tokens.push({ type: 'string', value: '(' });
        tokens.push({ type: 'code', value: `R2SW((${mathExpr})*100,${w},${d})+"%"` });
        tokens.push({ type: 'string', value: ')' });
        break;
      }
      default:
        node.children.forEach(child => traverseAst(child, tokens, inMathContext));
        break;
    }
  }
}

function normalizeXmlTags(inputStr) {
  return inputStr.replace(/<([a-zA-Z0-9_]+):([^>/]+)(\/?)>/g, (match, tag, args, slash) => {
    let cleanArgs = args.trim();
    if (cleanArgs.endsWith('/')) {
      cleanArgs = cleanArgs.slice(0, -1).trim();
      slash = '/';
    }
    return `<${tag} args="${cleanArgs}"${slash}>`;
  });
}

function parseTooltipToJass(inputStr) {
  if (!inputStr) return '""';

  const normalizedStr = normalizeXmlTags(inputStr);

  const dom = htmlparser2.parseDocument(`<root>${normalizedStr}</root>`, {
    xmlMode: true,
    lowerCaseTags: false,
    lowerCaseAttributeNames: false
  });
  const rootElement = dom.children.find(c => c.name === 'root');

  const tokens = [];
  if (rootElement && rootElement.children) {
    rootElement.children.forEach(child => traverseAst(child, tokens, false));
  }

  const combinedTokens = [];
  tokens.forEach(tok => {
    if (!tok || !tok.value) return;
    const prev = combinedTokens[combinedTokens.length - 1];

    if (prev && prev.type === 'string' && tok.type === 'string') {
      prev.value += tok.value;
    } else {
      combinedTokens.push({ type: tok.type, value: tok.value });
    }
  });

  const jassParts = combinedTokens.map(tok => {
    if (tok.type === 'string') {
      return `"${tok.value}"`;
    }
    return tok.value;
  });

  return jassParts.join('+');
}

// ---------------------------------------------------------------------------
// 6. 메인 실행 루틴 (출력 경로: ./GeneratedAbilityTooltips.j)
// ---------------------------------------------------------------------------
function main() {
  const excelFile = path.resolve(__dirname, './Master.xlsx');
  const outputJ = path.resolve(__dirname, './GeneratedAbilityTooltips.j');

  console.log('엑셀 시트 파싱 시작...');
  if (!fs.existsSync(excelFile)) {
    console.error(`엑셀 파일을 찾을 수 없습니다: ${excelFile}`);
    return;
  }

  const workbook = XLSX.readFile(excelFile);

  loadEnumLookupParams(workbook);
  loadAbilityParams(workbook);
  loadBuffParams(workbook);
  loadUnitParams(workbook);

  const sheet = workbook.Sheets['AbilityTooltips'];
  if (!sheet) {
    console.error('AbilityTooltips 시트를 찾을 수 없습니다.');
    return;
  }

  const rows = XLSX.utils.sheet_to_json(sheet, { header: 1, defval: null });
  if (!rows || rows.length === 0) {
    console.error('AbilityTooltips 시트에 데이터가 없습니다.');
    return;
  }

  const outputDir = path.dirname(outputJ);
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }

  fs.writeFileSync(outputJ, '', 'utf-8');

  let processedCount = 0;

  for (let i = 0; i < rows.length; i++) {
    const row = rows[i];
    if (!row || row[0] === null || row[0] === undefined) continue;

    currentAbilityId = String(row[0]).trim();
    if (!currentAbilityId) continue;

    try {
      let macroContent = `\n//! textmacro abilityTooltip${currentAbilityId}`;
      let hasMethod = false;

      // C열 (index 2): relativeTooltip
      if (row[2] !== null && row[2] !== undefined && String(row[2]).trim() !== '') {
        const jassExpr = parseTooltipToJass(String(row[2]));
        macroContent += `\nmethod relativeTooltip takes Unit caster returns string\n\treturn ${jassExpr}\nendmethod`;
        hasMethod = true;
      }

      // D열 (index 3): customCostTooltip
      if (row[3] !== null && row[3] !== undefined && String(row[3]).trim() !== '') {
        const jassExpr = parseTooltipToJass(String(row[3]));
        macroContent += `\nmethod customCostTooltip takes nothing returns string\n\treturn ${jassExpr}\nendmethod`;
        hasMethod = true;
      }

      macroContent += `\n//! endtextmacro`;

      if (hasMethod) {
        fs.appendFileSync(outputJ, macroContent, 'utf-8');
        processedCount++;
      }
    } catch (err) {
      console.error(`[Error] Ability ID: ${currentAbilityId}`, err);
    }
  }

  console.log(`파싱 완료! 총 ${processedCount}개의 스킬 툴팁 매크로가 생성되었습니다.`);
}

if (require.main === module) {
  main();
}

module.exports = main;