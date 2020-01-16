DEFINT A-Z
REM - LEVEL EDITOR PROGRAM
        
crsr$ = "Û"

CLS : SCREEN 12
CHDIR "D:\ASCIIMAN"
LOCATE 10, 10: INPUT "File Name: ", file$
LOCATE 11, 10: INPUT "Level Title: ", title$
CLS
ON ERROR GOTO NoFile

DIM row$(30)
OPEN file$ FOR INPUT AS #1
   IF title$ = "" THEN INPUT #1, title$ ELSE INPUT #1, dummy$
   FOR row = 1 TO 28
      INPUT #1, row$(row)
   NEXT row
CLOSE #1

FOR row = 1 TO 28
   LOCATE row, 1: PRINT row$(row);
NEXT row

10 row = 14: col = 40
LOCATE 30, 1
PRINT "1 Û  2 ß  3   4 Ü  5   6 ³  7 °  8 ±  9 ²";
LOCATE 30, 50: PRINT LEFT$(title$, 20);
IF LEN(title$) > 20 THEN PRINT "...";
under.char$ = CHR$(SCREEN(row, col))
lock.stat = 0

DO
COLOR 10
LOCATE row, col: PRINT crsr$
COLOR 15

k$ = ""
DO
k$ = INKEY$
LOOP UNTIL k$ <> ""

old.row = row: old.col = col

k$ = UCASE$(k$)
SELECT CASE k$
    CASE IS = CHR$(0) + "H" 'Up
        row = row - 1: IF row < 1 THEN row = 1
    CASE IS = CHR$(0) + "P" 'Down
        row = row + 1: IF row > 28 THEN row = 28
    CASE IS = CHR$(0) + "K" 'Left
        col = col - 1: IF col < 1 THEN col = 1
    CASE IS = CHR$(0) + "M" 'Right
        col = col + 1: IF col > 80 THEN col = 80
    CASE IS = CHR$(13)
        IF lock.stat = 0 THEN lock.stat = 1 ELSE lock.stat = 0
        IF lock.stat = 1 THEN lock.char$ = under.char$: LOCATE 30, 75: PRINT "Lock";
        IF lock.stat = 0 THEN LOCATE 30, 75: PRINT "    ";
    CASE IS = "1"
        LOCATE row, col, 1: PRINT "Û"; : LOCATE row, col, 1: under.char$ = "Û"
    CASE IS = "2"
        LOCATE row, col, 1: PRINT "ß"; : LOCATE row, col, 1: under.char$ = "ß"
    CASE IS = "3"
        LOCATE row, col, 1: PRINT ""; : LOCATE row, col, 1: under.char$ = ""
    CASE IS = "4"
        LOCATE row, col, 1: PRINT "Ü"; : LOCATE row, col, 1: under.char$ = "Ü"
    CASE IS = "5"
        LOCATE row, col, 1: PRINT ""; : LOCATE row, col, 1: under.char$ = ""
    CASE IS = "6"
        LOCATE row, col, 1: PRINT "³"; : LOCATE row, col, 1: under.char$ = "³"
    CASE IS = "7"
        LOCATE row, col, 1: PRINT "°"; : LOCATE row, col, 1: under.char$ = "°"
    CASE IS = "8"
        LOCATE row, col, 1: PRINT "±"; : LOCATE row, col, 1: under.char$ = "±"
    CASE IS = "9"
        LOCATE row, col, 1: PRINT "²"; : LOCATE row, col, 1: under.char$ = "²"
    CASE IS = " "
        LOCATE row, col, 1: PRINT " "; : LOCATE row, col, 1: under.char$ = " "
    CASE IS = "F"
        LOCATE row, col, 1: PRINT "F"; : LOCATE row, col, 1: under.char$ = "F"
    CASE IS = "O"
        LOCATE row, col, 1: PRINT "O"; : LOCATE row, col, 1: under.char$ = "O"
    CASE IS = "E"
        LOCATE row, col, 1: PRINT "E"; : LOCATE row, col, 1: under.char$ = "E"
    CASE IS = "C"
        LOCATE row, col, 1: PRINT "C"; : LOCATE row, col, 1: under.char$ = "C"
    CASE ELSE
        IF ASC(k$) >= 43 AND ASC(k$) <= 126 THEN
           LOCATE row, col, 1: PRINT k$; : LOCATE row, col, 1: under.char$ = k$
        END IF
END SELECT
IF lock.stat = 1 THEN under.char$ = lock.char$
LOCATE old.row, old.col: PRINT under.char$;
under.char$ = CHR$(SCREEN(row, col))

LOOP UNTIL k$ = CHR$(27) OR k$ = "X"
IF k$ = "X" THEN GOTO 100

LOCATE 30, 1: PRINT STRING$(80, " ");
LOCATE 30, 1: PRINT "S a v i n g . . .";

DIM ln$(30)
FOR r = 1 TO 28
   FOR c = 1 TO 80
      ln$(r) = ln$(r) + CHR$(SCREEN(r, c))
   NEXT c
NEXT r

OPEN file$ FOR OUTPUT AS #1
PRINT #1, CHR$(34) + title$ + CHR$(34)
FOR r = 1 TO 28
   PRINT #1, CHR$(34) + ln$(r) + CHR$(34)
NEXT r
PRINT #1, CHR$(34) + CHR$(34)
PRINT #1, CHR$(34) + CHR$(34)
CLOSE #1

100 SYSTEM

NoFile:
RESUME 10

