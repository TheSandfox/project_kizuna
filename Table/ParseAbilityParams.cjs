const path = require('path');
const childProcess = require('child_process');

// 전역 설치된 모듈 경로 추적
try {
    const globalRoot = childProcess.execSync('npm root -g', { encoding: 'utf8' }).trim();
    module.paths.push(globalRoot);
} catch (e) {
    // ignore
}

const fs = require('fs');
const XLSX = require('xlsx');

const INPUT_FILE = path.join(__dirname, 'Master.xlsx');
const SHEET_NAME = 'AbilityParams';
const OUTPUT_FILE = path.join(__dirname, 'GeneratedAbilityParams.j');

// 빈 셀일 때 2행 헤더 타입별 기본값
const DEFAULT_BY_HEADER_TYPE = {
    integer: '0',
    fourcc: '0',
    real: '0.0',
    boolean: 'false',
    string: '""',
    iconpath: '""',
    casttype: '0',
    abilitytag: '-1',
    enum: '0',
};

function isEmpty(val) {
    if (val === null || val === undefined) return true;
    if (typeof val === 'string' && val.trim() === '') return true;
    return false;
}

function toCleanString(val) {
    if (val === null || val === undefined) return '';
    return String(val).trim();
}

function escapeJassString(str) {
    return str.replace(/\\/g, '\\\\').replace(/"/g, '\\"');
}

function formatRealLiteral(val) {
    const num = typeof val === 'number' ? val : Number(String(val).trim());
    if (Number.isNaN(num)) {
        const raw = toCleanString(val);
        return raw.includes('.') ? raw : `${raw}.0`;
    }
    const str = String(num);
    return str.includes('.') ? str : `${str}.0`;
}

function formatBooleanLiteral(val) {
    if (typeof val === 'boolean') return val ? 'true' : 'false';
    const normalized = toCleanString(val).toLowerCase();
    return normalized === 'true' || normalized === '1' ? 'true' : 'false';
}

function formatFourccLiteral(val) {
    const raw = toCleanString(val);
    if (!raw) return '0';
    // 이미 'A1B2' 형태면 그대로 두고, 4글자 rawcode면 작은따옴표로 감쌈
    if (raw.startsWith("'") && raw.endsWith("'") && raw.length >= 2) {
        return raw;
    }
    return `'${raw}'`;
}

function formatIconPathLiteral(val) {
    const raw = toCleanString(val);
    if (!raw) return '""';
    // 이미 ReplaceableTextures\... 또는 .blp가 붙어있을 경우를 대비해 정리
    let body = raw
        .replace(/^replaceabletextures[\\/]+commandbuttons[\\/]+/i, '')
        .replace(/\.blp$/i, '');
    body = escapeJassString(body);
    return `"ReplaceableTextures\\\\CommandButtons\\\\${body}.blp"`;
}

function formatField(header1, header2Raw, cellVal) {
    const varName = toCleanString(header1);
    const rawType = toCleanString(header2Raw).toLowerCase();

    if (!varName || !rawType || rawType === 'ignore') {
        return null;
    }

    if (isEmpty(cellVal)&& (rawType!=='abilitytag')) {
        return null;
    }

    let jassType = rawType;
    let jassValue = '';

    switch (rawType) {
        case 'fourcc': {
            jassType = 'integer';
            jassValue = isEmpty(cellVal) ? DEFAULT_BY_HEADER_TYPE.fourcc : formatFourccLiteral(cellVal);
            break;
        }
        case 'iconpath': {
            jassType = 'string';
            jassValue = isEmpty(cellVal) ? DEFAULT_BY_HEADER_TYPE.iconpath : formatIconPathLiteral(cellVal);
            break;
        }
        case 'casttype': {
            jassType = 'integer';
            if (isEmpty(cellVal)) {
                jassValue = DEFAULT_BY_HEADER_TYPE.casttype;
            } else {
                const v = toCleanString(cellVal);
                jassValue = v.startsWith('ENUM_CAST_TYPE_') ? v : `ENUM_CAST_TYPE_${v}`;
            }
            break;
        }
        case 'abilitytag': {
            jassType = 'integer';
            if (isEmpty(cellVal)) {
                jassValue = '-1';
            } else {
                const v = toCleanString(cellVal);
                jassValue = v.startsWith('ENUM_ABILITY_TAG_') ? v : `ENUM_ABILITY_TAG_${v}`;
            }
            break;
        }
        case 'enum': {
            jassType = 'integer'; // 별도 타입 지정이 없으므로 2행 헤더 타입 유지
            if (isEmpty(cellVal)) {
                jassValue = DEFAULT_BY_HEADER_TYPE.enum;
            } else {
                const v = toCleanString(cellVal);
                jassValue = v.startsWith('ENUM_') ? v : `ENUM_${v}`;
            }
            break;
        }
        case 'real': {
            jassType = 'real';
            jassValue = isEmpty(cellVal) ? DEFAULT_BY_HEADER_TYPE.real : formatRealLiteral(cellVal);
            break;
        }
        case 'integer': {
            jassType = 'integer';
            jassValue = isEmpty(cellVal) ? DEFAULT_BY_HEADER_TYPE.integer : String(parseInt(toCleanString(cellVal), 10));
            break;
        }
        case 'boolean': {
            jassType = 'boolean';
            jassValue = isEmpty(cellVal) ? DEFAULT_BY_HEADER_TYPE.boolean : formatBooleanLiteral(cellVal);
            break;
        }
        case 'string': {
            jassType = 'string';
            jassValue = isEmpty(cellVal) ? DEFAULT_BY_HEADER_TYPE.string : `"${escapeJassString(toCleanString(cellVal))}"`;
            break;
        }
        default: {
            // 별도 언급이 없는 기타 2행 헤더는 타입 및 값 그대로 파싱
            jassType = toCleanString(header2Raw);
            jassValue = isEmpty(cellVal) ? '0' : toCleanString(cellVal);
            break;
        }
    }

    return `\tprivate constant ${jassType} ${varName} = ${jassValue}`;
}

function main() {
    if (!fs.existsSync(INPUT_FILE)) {
        console.error(`입력 파일을 찾을 수 없습니다: ${INPUT_FILE}`);
        process.exit(1);
    }

    const workbook = XLSX.readFile(INPUT_FILE);
    const worksheet = workbook.Sheets[SHEET_NAME];
    if (!worksheet) {
        console.error(`시트 '${SHEET_NAME}'을(를) 찾을 수 없습니다.`);
        process.exit(1);
    }

    // 2차원 배열로 변환 (빈 셀은 null로 채움)
    const rows = XLSX.utils.sheet_to_json(worksheet, {
        header: 1,
        defval: null,
        raw: true,
    });

    if (rows.length < 3) {
        console.error('헤더(1~2행) 또는 데이터(3행 이상)가 충분하지 않습니다.');
        process.exit(1);
    }

    const row1Headers = rows[0];
    const row2Types = rows[1];
    const colCount = Math.max(row1Headers.length, row2Types.length);

    const blocks = [];

    // 3행(index 2)부터 순회하며 1열(index 0) ID가 비면 종료
    for (let r = 2; r < rows.length; r++) {
        const row = rows[r];
        const idRaw = row[0];

        if (isEmpty(idRaw)) {
            break;
        }

        const idStr = toCleanString(idRaw);
        const lines = [];
        lines.push(`//! textmacro abilityParam${idStr}`);
        lines.push('globals');

        for (let c = 0; c < colCount; c++) {
            const h1 = row1Headers[c];
            const h2 = row2Types[c];
            const val = c < row.length ? row[c] : null;

            const formatted = formatField(h1, h2, val);
            if (formatted !== null) {
                lines.push(formatted);
            }
        }

        lines.push('endglobals');
        lines.push('//! endtextmacro');
        blocks.push(lines.join('\n'));
    }

    const outputContent = blocks.join('\n\n') + (blocks.length > 0 ? '\n' : '');
    fs.writeFileSync(OUTPUT_FILE, outputContent, 'utf8');
    console.log(`완료: 총 ${blocks.length}개의 abilityParam 텍스트매크로를 '${OUTPUT_FILE}'에 생성했습니다.`);
}

main();