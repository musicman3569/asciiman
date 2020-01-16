DECLARE FUNCTION CharIsGround% (char$)
DEFINT A-Z
DECLARE SUB Pause ()
DECLARE SUB IntroVid ()
DECLARE SUB DeadVid ()
levels = 9
start.place = 1
DIM l$(130)
DIM enemy.col$(10)
DIM enemy.row$(10)
DIM fire.col$(10)
DIM fire.row$(10)
DIM enemy.move(30)
DIM move.num(30)

'Colors----
hero.color = 14
enemy.color = 2
ground.color = 8
ground2.color = 8
ground3.color = 9
ground4.color = 3
warp.color = 13
slide.color = 6
spike.color = 11
fire1.color = 12
fire2.color = 4
fire3.color = 12
prpn.color = 15
statline.color = 14
torch.color = 14
pole.color = 14
'---

hero$ = ""
hero.spikeball$ = ""
lives = 10
sound.stat = 1
spikeball.timer = 0
spikeball.cooldown.timer = 0
ON KEY(10) GOSUB Finished
KEY(10) ON
IntroVid

FOR level = start.place TO levels
    '‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
    level$ = LTRIM$(STR$(level))
    file$ = ".\DATA\LEV_" + level$ + ".DAT"
    enemy.count = 0
    fire.count = 0
    enemy.animate.timer = 0
    enemy.char$ = "ï"

    '--- Read level data from file to the l$ array
    OPEN file$ FOR INPUT AS #1
    INPUT #1, level.title$
    FOR curr.line = 1 TO 30
        INPUT #1, l$(curr.line)
    NEXT curr.line
    CLOSE #1

    CLS: SCREEN 12
    WHILE INKEY$ <> "": WEND
    COLOR 15
    LOCATE 10, 10: PRINT level.title$;
    SLEEP 3
    WHILE INKEY$ <> "": WEND

    '--- Print level data to the screen
    FOR curr.line = 1 TO 28
        LOCATE curr.line, 1
        PRINT l$(curr.line);
    NEXT curr.line
    LOCATE 1, 69: PRINT "Reading...";

    FOR curr.row = 1 TO 28
        FOR curr.col = 1 TO 80
            'SOUND 0, .1
            curr.char$ = CHR$(SCREEN(curr.row, curr.col))
            SELECT CASE curr.char$
                CASE IS = "€"
                    COLOR ground.color
                    char.att = INT(RND * 3) + 1
                    IF char.att = 1 THEN curr.char$ = "€"
                    IF char.att = 2 THEN curr.char$ = "±"
                    IF char.att = 3 THEN curr.char$ = "≤"
                CASE IS = "±"
                    COLOR ground4.color
                CASE IS = "≤"
                    COLOR ground3.color
                CASE IS = "ﬂ"
                    COLOR ground2.color
                CASE IS = "T"
                    COLOR torch.color
                    curr.char$ = ""
                CASE IS = "P"
                    COLOR pole.color
                    curr.char$ = "≥"
                CASE IS = "S"
                    COLOR ground2.color
                    curr.char$ = "€"
                CASE IS = "\"
                    COLOR slide.color
                CASE IS = "/"
                    COLOR slide.color
                CASE IS = ""
                    COLOR hero.color
                CASE IS = "∞"
                    COLOR warp.color
                CASE IS = "≥"
                    COLOR spike.color
                CASE ELSE
                    COLOR ground.color
            END SELECT
            LOCATE curr.row, curr.col: PRINT curr.char$;
        NEXT curr.col
    NEXT curr.row

    el.stat = 0
    FOR curr.line = 1 TO 28
        FOR curr.col = 1 TO 80
            curr.char$ = CHR$(SCREEN(curr.line, curr.col))
            IF curr.char$ = "O" THEN
                IF enemy.count >= 10 THEN LOCATE curr.line, curr.col: PRINT " ";
                IF enemy.count < 10 THEN
                    enemy.count = enemy.count + 1
                    enemy.col(enemy.count) = curr.col: enemy.row(enemy.count) = curr.line
                END IF
            END IF
            IF curr.char$ = "F" THEN
                IF fire.count >= 10 THEN LOCATE f.line, f.col: PRINT " ";
                IF fire.count < 10 THEN
                    fire.count = fire.count + 1
                    fire.col(fire.count) = curr.col: fire.row(fire.count) = curr.line
                END IF
            END IF
            IF curr.char$ = "" THEN
                my.row = curr.line: my.col = curr.col
                start.row = curr.line: start.col = curr.col
            END IF
            IF curr.char$ = "" THEN
                el.stat = 1
                el.row = curr.line: el.col = curr.col
            END IF
        NEXT curr.col
    NEXT curr.line
    lev.stat$ = ""
    FOR o = 1 TO enemy.count
        enemy.move(o) = 0
        move.num(o) = 5
    NEXT o
    WHILE INKEY$ <> "": WEND

    '-------------------------------------BEGIN MAIN GAME LOOP
    DO

        '--- Render fire
        fire.pos = fire.pos + 1
        IF fire.pos > 3 THEN fire.pos = 1
        FOR f = 1 TO fire.count
            LOCATE fire.row(f), fire.col(f)
            f.color = INT(RND * 3) + 1
            IF f.color = 1 THEN f.color = fire1.color
            IF f.color = 2 THEN f.color = fire2.color
            IF f.color = 3 THEN f.color = fire3.color
            COLOR f.color
            IF fire.pos = 1 THEN PRINT ".";
            IF fire.pos = 2 THEN PRINT "˘";
            IF fire.pos = 3 THEN
                p = INT(RND * 2) + 1
                IF p = 1 THEN PRINT "'";
                IF p = 2 THEN PRINT "`";
            END IF
        NEXT f

        '--- Render enemies
        enemy.animate.timer = enemy.animate.timer + 1
        IF enemy.animate.timer = 3 THEN
            enemy.animate.timer = 0
            IF enemy.char$ = "ï" THEN enemy.char$ = "¢" ELSE enemy.char$ = "ï"
        END IF
        FOR o = 1 TO enemy.count
            IF enemy.row(o) <> 0 AND enemy.col(o) <> 0 THEN
                COLOR enemy.color
                LOCATE enemy.row(o), enemy.col(o)
                PRINT enemy.char$;
            END IF
        NEXT o

        '--- Render HUD
        LOCATE 1, 69: PRINT "          ";
        COLOR statline.color
        LOCATE 30, 1: PRINT "Lives ="; lives, "Level ="; level, "Score ="; score, "Spikeball ="; spikeball.cooldown.timer;
        'SOUND 0, 1
        _LIMIT 18

        '--- Render extra life pickup item
        IF el.stat = 1 THEN
            LOCATE el.row, el.col: COLOR (INT(RND * 15) + 1): PRINT "";
        END IF

        '--- Update timers and apply gravity
        IF spikeball.timer > 0 THEN spikeball.timer = spikeball.timer - 1
        IF spikeball.cooldown.timer > 0 THEN spikeball.cooldown.timer = spikeball.cooldown.timer - 1
        new.col = my.col
        new.row = my.row
        my.char.below$ = CHR$(SCREEN(my.row + 1, my.col))
        IF my.jump.timer > 0 THEN
            my.jump.timer = my.jump.timer - 1
        ELSE
            IF CharIsGround(my.char.below$) = 0 THEN new.row = my.row + 1
            IF new.row > 29 THEN GOSUB die
        END IF

        '--- Handle player keyboard input
        SELECT CASE UCASE$(INKEY$)
            CASE IS = CHR$(0) + "M" 'right
                IF spikeball.cooldown.timer = 0 AND my.char.below$ <> "/" AND my.char.below$ <> "\" THEN new.col = my.col + 1
            CASE IS = CHR$(0) + "K" 'left
                IF spikeball.cooldown.timer = 0 AND my.char.below$ <> "/" AND my.char.below$ <> "\" THEN new.col = my.col - 1
            CASE IS = " "
                IF my.jump.timer = 0 THEN
                    my.jump.timer = 16
                    IF my.row > 1 THEN new.row = my.row - 1
                END IF
            CASE IS = "S"
                IF sound.stat = 0 THEN sound.stat = 1 ELSE sound.stat = 0
            CASE IS = "B"
                IF spikeball.cooldown.timer = 0 THEN
                    spikeball.cooldown.timer = 16
                    spikeball.timer = 4
                    SOUND 0, 2
                END IF
        END SELECT

        '--- Clear any extra keyboard input
        WHILE INKEY$ <> "": WEND

        '--- Handle enemy collisions with player
        FOR o = 1 TO enemy.count
            IF spikeball.timer > 0 THEN
                IF my.row = enemy.row(o) AND ABS(my.col - enemy.col(o)) < 2 THEN
                    COLOR 4
                    LOCATE enemy.row(o), enemy.col(o): PRINT "_";
                    enemy.row(o) = 0: enemy.col(o) = 0
                    IF sound.stat = 1 THEN SOUND 80, 2
                    score = score + 50
                END IF
            ELSE
                IF my.row = enemy.row(o) AND my.col = enemy.col(o) THEN GOSUB die
            END IF
        NEXT o

        '--- Move enemies
        FOR o = 1 TO enemy.count
            enemy.move(o) = enemy.move(o) + 1
            IF enemy.move(o) = move.num(o) THEN
                enemy.move(o) = 0
                move.num(o) = INT(RND * 20) + 1

                IF enemy.row(o) <> 0 AND enemy.col(o) <> 0 THEN
                    new.enemy.col = enemy.col(o) + INT(RND * 3) - 1
                    new.enemy.char$ = CHR$(SCREEN(enemy.row(o), new.enemy.col))
                    new.enemy.charbelow$ = CHR$(SCREEN(enemy.row(o) + 1, new.enemy.col))
                    IF new.enemy.char$ = " " AND CharIsGround(new.enemy.charbelow$) THEN
                        LOCATE enemy.row(o), enemy.col(o): PRINT " ";
                        enemy.col(o) = new.enemy.col
                    END IF
                END IF
            END IF
        NEXT o

        '--- Handle fire collisions with player
        FOR f = 1 TO fire.count
            IF my.row = fire.row(f) AND my.col = fire.col(f) THEN GOSUB die
            IF new.row = fire.row(f) AND new.col = fire.col(f) THEN GOSUB die
        NEXT f

        '--- Handle all other player collisions
        IF new.row <> my.row OR new.col <> my.col THEN
            new.position.changed = 1
            LOCATE my.row, my.col: PRINT " "
        ELSE
            new.position.changed = 0
        END IF

        '--- Keep checking the new position for collisions until the collisions stop moving it
        WHILE new.position.changed
            new.position.changed = 0
            SELECT CASE CHR$(SCREEN(new.row, new.col))
                CASE " "
                CASE "_"
                CASE "≥"
                    GOSUB die
                CASE "/"
                    new.col = new.col - 1: my.jump.timer = 0: new.position.changed = 1
                CASE "\"
                    new.col = new.col + 1: my.jump.timer = 0: new.position.changed = 1
                CASE "∞"
                    lev.stat$ = "DONE"
                CASE ""
                    LOCATE my.row, my.col: PRINT " ";
                    LOCATE el.row, el.col: COLOR hero.color: PRINT hero$;
                    IF sound.stat = 1 THEN PLAY "MF T200 O1 L64 CDEFGAB>CDEFGAB>C"
                    lives = lives + 1
                    el.stat = 0
                CASE ELSE
                    ' Any other characters will be considered solid
                    new.row = my.row: new.col = my.col
            END SELECT
        WEND
        my.row = new.row: my.col = new.col

        '--- Render player
        LOCATE my.row, my.col
        IF spikeball.timer > 0 THEN
            COLOR prpn.color
            PRINT hero.spikeball$
        ELSE
            IF spikeball.cooldown.timer > 0 THEN COLOR 12 ELSE COLOR hero.color
            PRINT hero$
        END IF

        IF lives < 0 THEN EXIT DO
    LOOP UNTIL lev.stat$ = "DONE"
    '-------------------------------------END MAIN GAME LOOP

    IF lives < 0 THEN EXIT FOR
    'ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
NEXT level

IF lives < 0 THEN DeadVid
IF lives < 0 THEN RUN

IF level = 9 THEN RUN "W1_BOSS.DAT"


Finished:
SYSTEM
RETURN

die:
IF sound.stat = 1 THEN SOUND 57, 10
new.row = start.row
new.col = start.col
lives = lives - 1
RETURN

SUB DeadVid
    WHILE INKEY$ <> "": WEND
    CLS: SCREEN 12
    m$ = "Game Over"
    FOR col = 1 TO LEN(m$)
        char$ = RIGHT$(LEFT$(m$, col), 1)
        FOR row = 1 TO 14
            IF row > 1 THEN LOCATE row - 1, col + 30: PRINT " ";
            LOCATE row, col + 30: PRINT char$;
            _LIMIT 36
        NEXT row
    NEXT col
    WHILE INKEY$ <> "": WEND
    Pause
END SUB

SUB IntroVid
    CLS: SCREEN 12
    _FULLSCREEN _SQUAREPIXELS
    m$ = "ASCII-MAN  "
    WHILE INKEY$ <> "": WEND
    FOR col = 1 TO LEN(m$)
        char$ = RIGHT$(LEFT$(m$, col), 1)
        FOR row = 1 TO 14
            IF char$ <> "" THEN COLOR 10 ELSE COLOR 14
            IF row > 1 THEN LOCATE row - 1, col + 30: PRINT " ";
            LOCATE row, col + 30: PRINT char$;
            _LIMIT 36
            IF INKEY$ <> "" THEN EXIT SUB
        NEXT row
    NEXT col

    COLOR 9
    FOR col = 1 TO 80
        LOCATE 20, col: PRINT "ƒ";
        _LIMIT 180
        IF INKEY$ <> "" THEN EXIT SUB
    NEXT col
    FOR col = 1 TO 80
        LOCATE 10, col: PRINT "ƒ";
        _LIMIT 180
        IF INKEY$ <> "" THEN EXIT SUB
    NEXT col

    COLOR 14
    FOR col = 42 TO 80
        LOCATE 14, col - 1: PRINT " ";
        LOCATE 14, col: PRINT "";
        _LIMIT 18
        IF INKEY$ <> "" THEN EXIT SUB
    NEXT col
    LOCATE 14, 80: PRINT " ";

    FOR i = 1 TO 270
        r = INT(RND * 6) + 1
        c = INT(RND * 9) + 35
        COLOR (INT(RND * 15) + 1)
        LOCATE r, c: PRINT CHR$(INT(RND * 200) + 50);
        _LIMIT 180
        IF INKEY$ <> "" THEN EXIT SUB
    NEXT i

    COLOR 14
    LOCATE 1, 35: PRINT "  ‹€€€‹  ";
    LOCATE 2, 35: PRINT "‹€€˛€˛€€‹";
    LOCATE 3, 35: PRINT "€€€€€€€€€";
    LOCATE 4, 35: PRINT "€€ ﬂﬂﬂ €€";
    LOCATE 5, 35: PRINT "ﬂ€€   €€ﬂ";
    LOCATE 6, 35: PRINT "  ﬂ€€€ﬂ  ";

    COLOR 15
    LOCATE 28, 30: PRINT "Press Any Key To Begin";
    Pause
END SUB

DEFSNG A-Z
SUB Pause
    SLEEP
    WHILE INKEY$ <> "": WEND
END SUB

DEFINT A-Z
FUNCTION CharIsGround% (char$)
    IF char$ = "€" OR char$ = "ﬂ" OR char$ = "±" OR char$ = "≤" OR char$ = "›" OR char$ = "ﬁ" THEN
        CharIsGround% = 1
    ELSE
        CharIsGround% = 0
    END IF
END FUNCTION
