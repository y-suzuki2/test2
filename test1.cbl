IDENTIFICATION DIVISION.
PROGRAM-ID. SUM_SAMPLE02.
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
SELECT IN01-FILE
ASSIGN TO "in01.txt"
ORGANIZATION IS LINE SEQUENTIAL
FILE STATUS IS IN-FILE-STATUS.
SELECT OUT01-FILE
ASSIGN TO "out01.txt"
ORGANIZATION IS LINE SEQUENTIAL.
DATA DIVISION.
FILE SECTION.
FD IN01-FILE.
01 IN01.
03 IN01-YEAR PIC X(04).
03 IN01-MONTH PIC X(02).
03 IN01-SUJI PIC 99.
FD OUT01-FILE.
01 OUT01.
03 OUT01-YEAR PIC X(04).
03 OUT01-MONTH PIC X(02).
03 OUT01-SUJI PIC 999.
03 OUT01-SUJI-ALL PIC 999.
WORKING-STORAGE SECTION.
01 IN-FILE-STATUS PIC XX.
01 WK-KEY-AREA.
03 WK-KEY-OLD.
05 WK-KEY-OLD-YEAR PIC X(04).
05 WK-KEY-OLD-MONTH PIC X(02).
03 WK-KEY-NEW.
05 WK-KEY-NEW-YEAR PIC X(04).
05 WK-KEY-NEW-MONTH PIC X(02).
01 WK-SUM-AREA.
03 WK-SUM-SUJI PIC 999.
03 WK-SUM-SUJI-ALL PIC 999.
PROCEDURE DIVISION.
*> 1.初期処理（ファイルオープン）
OPEN INPUT IN01-FILE.
OPEN OUTPUT OUT01-FILE.
READ IN01-FILE
AT END
DISPLAY "READ END"
NOT AT END
MOVE IN01-YEAR TO WK-KEY-NEW-YEAR
WK-KEY-OLD-YEAR
MOVE IN01-MONTH TO WK-KEY-NEW-MONTH
WK-KEY-OLD-MONTH
MOVE IN01-SUJI TO WK-SUM-SUJI
MOVE IN01-SUJI TO WK-SUM-SUJI-ALL
END-READ
*> 2.主処理（キーブレイク処理、データ集計処理）
PERFORM UNTIL IN-FILE-STATUS NOT = "00"
READ IN01-FILE
AT END
DISPLAY "READ END"
MOVE WK-KEY-OLD-YEAR TO OUT01-YEAR
MOVE WK-KEY-OLD-MONTH TO OUT01-MONTH
MOVE WK-SUM-SUJI TO OUT01-SUJI
MOVE WK-SUM-SUJI-ALL TO OUT01-SUJI-ALL
WRITE OUT01
NOT AT END
MOVE IN01-YEAR TO WK-KEY-NEW-YEAR
MOVE IN01-MONTH TO WK-KEY-NEW-MONTH
*>　キーブレイク１
IF WK-KEY-NEW-YEAR = WK-KEY-OLD-YEAR
*>　データ集計
THEN
*>　キーブレイク２
IF WK-KEY-NEW = WK-KEY-OLD
THEN
COMPUTE WK-SUM-SUJI = WK-SUM-SUJI + IN01-SUJI
COMPUTE WK-SUM-SUJI-ALL = WK-SUM-SUJI-ALL + IN01-SUJI
ELSE
*>　ファイル出力
MOVE WK-KEY-OLD-YEAR TO OUT01-YEAR
MOVE WK-KEY-OLD-MONTH TO OUT01-MONTH
MOVE WK-SUM-SUJI TO OUT01-SUJI
MOVE WK-SUM-SUJI-ALL TO OUT01-SUJI-ALL
WRITE OUT01
*>　次のキーをセット
MOVE WK-KEY-NEW TO WK-KEY-OLD
MOVE IN01-SUJI TO WK-SUM-SUJI
COMPUTE WK-SUM-SUJI-ALL = WK-SUM-SUJI-ALL + IN01-SUJI
END-IF
ELSE
*>　ファイル出力
MOVE WK-KEY-OLD-YEAR TO OUT01-YEAR
MOVE WK-KEY-OLD-MONTH TO OUT01-MONTH
MOVE WK-SUM-SUJI TO OUT01-SUJI
MOVE WK-SUM-SUJI-ALL TO OUT01-SUJI-ALL
WRITE OUT01
*>　次のキーをセット
MOVE WK-KEY-NEW TO WK-KEY-OLD
MOVE IN01-SUJI TO WK-SUM-SUJI
MOVE IN01-SUJI TO WK-SUM-SUJI-ALL
END-IF
END-READ
END-PERFORM.
*> 3.終了処理（ファイルクローズ）
CLOSE IN01-FILE.
CLOSE OUT01-FILE.
STOP RUN.
END PROGRAM SUM_SAMPLE02.