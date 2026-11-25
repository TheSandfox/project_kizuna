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
const SHEET_NAME = 'UnitParams';
const OUTPUT_FILE = path.join(__dirname, 'GeneratedUnitParams.j');

const SETTER_SUFFIX_MAP = {
    string: 'String',
    integer: 'Integer',
    real: 'Real',
    fourcc: 'Integer',
    iconpath: 'String',
};

const DEFAULT_VALUE_MAP = {
    string: '""',
    integer: '0',
    real: '0.0',
    fourcc: '0',
    iconpath: '""',
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

function formatFourccLiteral(val) {
    const raw = toCleanString(val);
    if (!raw) return '0';
    if (raw.startsWith("'") && raw.endsWith("'") && raw.length >= 2) {
        return raw;
    }
    return `'${raw}'`;
}

function formatIconPathLiteral(val) {
    const raw = toCleanString(val);
    if (!raw) return '""';
    const body = raw
        .replace(/^replaceabletextures[\\/]+commandbuttons[\\/]+/i, '')
        .replace(/\.blp$/i, '');
    return `"ReplaceableTextures\\\\CommandButtons\\\\${escapeJassString(body)}.blp"`;
}

function formatRealLiteral(val) {
    const num = typeof val === 'number' ? val : Number(toCleanString(val));
    if (Number.isNaN(num)) {
        const raw = toCleanString(val);
        return raw.includes('.') ? raw : `${raw}.0`;
    }
    const str = String(num);
    return str.includes('.') ? str : `${str}.0`;
}

function formatIntegerLiteral(val) {
    const num = typeof val === 'number' ? Math.trunc(val) : parseInt(toCleanString(val), 10);
    return Number.isNaN(num) ? '0' : String(num);
}

function formatValueByType(rawType, cellVal) {
    if (isEmpty(cellVal)) {
        return DEFAULT_VALUE_MAP[rawType] ?? '0';
    }

    switch (rawType) {
        case 'fourcc':
            return formatFourccLiteral(cellVal);
        case 'iconpath':
            return formatIconPathLiteral(cellVal);
        case 'string':
            return `"${escapeJassString(toCleanString(cellVal))}"`;
        case 'integer':
            return formatIntegerLiteral(cellVal);
        case 'real':
            return formatRealLiteral(cellVal);
        default:
            return toCleanString(cellVal);
    }
}

function formatUnitIdArg(idRaw, idHeaderType) {
    const cleanId = toCleanString(idRaw);
    if (idHeaderType === 'fourcc') {
        return formatFourccLiteral(cleanId);
    }
    return cleanId;
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
    const idHeaderType = toCleanString(row2Types[0]).toLowerCase();

    const outputLines = [];

    // 1. 상단 globals 블록 (1행 헤더 기준 0-based 컬럼 인덱스)
    outputLines.push('globals');
    for (let c = 0; c < colCount; c++) {
        const headerName = toCleanString(row1Headers[c]);
        if (!headerName) continue;
        outputLines.push(`    constant integer ENUM_UNIT_PARAM_${headerName} = ${c}`);
    }
    outputLines.push('endglobals');

    // 2. 3행(index 2)부터 데이터 행 처리 (1열 ID가 비면 종료)
    for (let r = 2; r < rows.length; r++) {
        const row = rows[r];
        const idRaw = row[0];

        if (isEmpty(idRaw)) {
            break;
        }

        const unitScopeId = toCleanString(idRaw);
        const unitIdArg = formatUnitIdArg(idRaw, idHeaderType);

        outputLines.push('');
        outputLines.push(`scope Unit${unitScopeId} initializer init`);
        outputLines.push('\tprivate function init takes nothing returns nothing');

        for (let c = 0; c < colCount; c++) {
            const headerName = toCleanString(row1Headers[c]);
            const rawType = toCleanString(row2Types[c]).toLowerCase();

            if (!headerName || !rawType || rawType === 'ignore') {
                continue;
            }

            const suffix = SETTER_SUFFIX_MAP[rawType];
            if (!suffix) {
                continue;
            }

            const cellVal = c < row.length ? row[c] : null;
            const formattedVal = formatValueByType(rawType, cellVal);
            outputLines.push(`\t\tcall UnitData.set${suffix}(${unitIdArg},ENUM_UNIT_PARAM_${headerName},${formattedVal})`);
        }

        outputLines.push('\tendfunction');
        outputLines.push('endscope');
    }

    const finalContent = outputLines.join('\n') + '\n';
    fs.writeFileSync(OUTPUT_FILE, finalContent, 'utf8');
    console.log(`완료: '${OUTPUT_FILE}' 파일이 생성되었습니다.`);
}

main();