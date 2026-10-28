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

// 상대 경로를 절대 경로로 안전하게 생성
const xlsxFile = path.resolve(__dirname, './Master.xlsx');

function wwrite(workbook, sheetName, mode) {
    const sheet = workbook.Sheets[sheetName];
    if (!sheet) {
        console.warn(`시트를 찾을 수 없습니다: ${sheetName}`);
        return;
    }

    // 2차원 배열 형태로 시트 데이터 로드 (header: 1)
    const rows = XLSX.utils.sheet_to_json(sheet, { header: 1, defval: null });
    if (!rows || rows.length === 0) return;

    let outJass = '';
    let prefix = '';
    if (mode === 'ability') {
        outJass = path.resolve(__dirname, './GeneratedAbilityParams.j');
        prefix = 'private';
    } else if (mode === 'buff') {
        outJass = path.resolve(__dirname, './GeneratedBuffParams.j');
        prefix = 'public';
    }

    const datafromX = 3;
    const dataType = 2;
    const allowNull = 1;
    let i = 0;
    let j = datafromX;

    // 출력 파일 초기화
    fs.writeFileSync(outJass, '', 'utf-8');

    while (true) {
        // 끝까지 가면 루프 탈출
        if (j === rows[0].length || rows[0][j] == null) {
            break;
        }

        // 텍매열기 J
        fs.appendFileSync(outJass, '//! textmacro ' + mode + 'Param' + rows[0][j] + "\nglobals\n", 'utf-8');

        // 셀 데이터 기록
        i = 0;
        while (true) {
            if (i === rows.length) {
                break;
            }

            // 빈 값이 아닐 때만 (또는 allowNull이 "true"일 때)
            if ((rows[i][j] != null || String(rows[i][allowNull]) === "true") && rows[i][dataType] !== "ignore") {
                const cellVal = rows[i][j];
                const typeVal = rows[i][dataType];
                const varName = rows[i][0];

                switch (typeVal) {
                    case 'iconpath':
                        fs.appendFileSync(outJass, '\t' + prefix + ' constant string ' + varName + ' = "ReplaceableTextures\\\\CommandButtons\\\\' + cellVal + '.blp"\n', 'utf-8');
                        break;
                    case 'fourcc':
                        fs.appendFileSync(outJass, '\t' + prefix + ' constant integer ' + varName + " = '" + cellVal + "'\n", 'utf-8');
                        break;
                    case 'string':
                        fs.appendFileSync(outJass, '\t' + prefix + ' constant string ' + varName + ' = "' + cellVal + '"\n', 'utf-8');
                        break;
                    case 'abilitytag':
                        if (cellVal != null) {
                            fs.appendFileSync(outJass, '\t' + prefix + ' constant integer ' + varName + " = ENUM_ABILITY_TAG_" + cellVal + "\n", 'utf-8');
                        } else {
                            fs.appendFileSync(outJass, '\t' + prefix + ' constant integer ' + varName + " = -1\n", 'utf-8');
                        }
                        break;
                    case 'casttype':
                        if (cellVal != null) {
                            fs.appendFileSync(outJass, '\t' + prefix + ' constant integer ' + varName + " = ENUM_CAST_TYPE_" + cellVal + "\n", 'utf-8');
                        } else {
                            fs.appendFileSync(outJass, '\t' + prefix + ' constant integer ' + varName + " = -1\n", 'utf-8');
                        }
                        break;
                    case 'enum':
                        if (cellVal != null) {
                            fs.appendFileSync(outJass, '\t' + prefix + ' constant integer ' + varName + " = ENUM_" + cellVal + "\n", 'utf-8');
                        } else {
                            fs.appendFileSync(outJass, '\t' + prefix + ' constant integer ' + varName + " = -1\n", 'utf-8');
                        }
                        break;
                    case 'real':
                        if (typeof cellVal === 'string' && cellVal[cellVal.length - 1] === '%') {
                            let pure = Number(cellVal.substring(0, cellVal.length - 1)) / 100.0;
                            // 퍼센트임
                            fs.appendFileSync(outJass, '\t' + prefix + ' constant real ' + varName + " = " + String(pure) + "\n", 'utf-8');
                        } else {
                            // 아님
                            fs.appendFileSync(outJass, '\t' + prefix + ' constant real ' + varName + " = " + cellVal + "\n", 'utf-8');
                        }
                        break;
                    case 'ignore':
                        /* 기록 안 함 */
                        break;
                    default:
                        fs.appendFileSync(outJass, '\t' + prefix + ' constant ' + typeVal + " " + varName + " = " + cellVal + "\n", 'utf-8');
                        break;
                }
            }

            i++;
        }

        // 괄호 닫기 J
        fs.appendFileSync(outJass, "endglobals\n//! endtextmacro\n", 'utf-8');
        j++;
    }
}

function main() {
    const workbook = XLSX.readFile(xlsxFile);

    wwrite(workbook, 'AbilityParams', 'ability');
    wwrite(workbook, 'BuffParams', 'buff');

    console.log('파싱 완료!');
}

module.exports = main;

main();