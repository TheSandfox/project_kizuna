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
const xlsxFile = './Master.xlsx'
const sheetName = 'Enum';

function parseEnumExcel(excelFilePath) {
    const workbook = XLSX.readFile(excelFilePath);
    const sheet = workbook.Sheets[sheetName];

    // 2차원 배열 형태로 엑셀 로드
    const rows = XLSX.utils.sheet_to_json(sheet, { header: 1 });

    const resultLines = ["globals"];

    // 1행 헤더를 제외한 2행(인덱스 1)부터 데이터 순회
    for (let r = 1; r < rows.length; r++) {
        const row = rows[r];
        if (!row || row.length === 0) continue;

        // A열: type, B열: name, C열: value
        const type = row[0];
        const name = row[1];
        let value = row[2];

        // type과 name이 없으면, 또는 type가 annotation이면 스킵
        if (!type || !name || type==="annotation") continue;

        if (value === undefined || value === null) {
            value = "";
        }

        // JASS 선언 구문 생성: type name = value
        // 예: integer ENUM_UNIT_CLASS_UNDEAD = 0
        const line = `\tconstant ${type} ${name} = ${value}`;
        resultLines.push(line);
    }

    resultLines.push("endglobals");

    // 결과물 저장 (Enum.j)
    const outputPath = path.join(process.cwd(), 'Enum.j');
    fs.writeFileSync(outputPath, resultLines.join('\n'), 'utf8');

    console.log(`파싱 완료! 파일이 생성되었습니다: ${outputPath}`);
}

// 스크립트 실행 (엑셀 파일 경로 지정)
parseEnumExcel(xlsxFile);