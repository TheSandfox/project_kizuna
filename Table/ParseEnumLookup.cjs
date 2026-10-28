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
const sheetName = 'EnumLookup';

function parseExcelToJass(excelFilePath) {
    const workbook = XLSX.readFile(excelFilePath);
    const sheet = workbook.Sheets[sheetName];

    const rows = XLSX.utils.sheet_to_json(sheet, { header: 1 });

    const assignmentLines = ["function InitEnumLookup takes nothing returns nothing"];
    // 중복 방지를 위한 Map (key: fullArrName, value: type)
    const arrayDeclarations = new Map();

    // 2행(인덱스 1)부터 데이터 순회
    for (let r = 1; r < rows.length; r++) {
        const row = rows[r];
        if (!row || row.length === 0) continue;

        const indexVal = row[0];
        const arrName = row[1];

        if (!indexVal || !arrName) continue;

        // C열(인덱스 2)부터 3개씩 한 쌍으로 읽기
        for (let c = 2; c < row.length; c += 3) {
            const subfix = row[c];
            const type = row[c + 1];
            let value = row[c + 2];

            if (!subfix || !type) break;

            if (value === undefined || value === null) {
                value = "";
            }

            const fullArrName = `${arrName}_${subfix}`;
            const normalizedType = String(type).trim();

            // 1. 변수 선언 정보 수집 (중복 자동 제거)
            if (!arrayDeclarations.has(fullArrName)) {
                arrayDeclarations.set(fullArrName, normalizedType);
            }

            // 2. 값 포맷팅 (type이 string일 때만 큰따옴표)
            let formattedValue = value;
            if (normalizedType.toLowerCase() === 'string') {
                formattedValue = `"${value}"`;
            }

            // 3. 할당 구문 생성
            const line = `\tset ${fullArrName}[${indexVal}] = ${formattedValue}`;
            assignmentLines.push(line);
        }
    }
    assignmentLines.push("endfunction")

    // 4. 전역 배열 선언 구문 생성
    const declarationLines = ["globals"];
    for (const [arrName, type] of arrayDeclarations.entries()) {
        declarationLines.push(`\t${type} array ${arrName}`);
    }
    declarationLines.push("endglobals")

    // 5. 선언 구문과 할당 구문 결합 (중간에 한 줄 공백 추가)
    const finalContent = [
        ...declarationLines,
        "", // 선언과 할당 사이 구분선
        ...assignmentLines
    ].join('\n');

    // 6. EnumLookup.j 파일로 출력
    const outputPath = path.join(process.cwd(), 'EnumLookup.j');
    fs.writeFileSync(outputPath, finalContent, 'utf8');

    console.log(`파싱 완료! 파일이 생성되었습니다: ${outputPath}`);
}

// 스크립트 실행 (엑셀 파일명 경로 지정)
parseExcelToJass(xlsxFile);