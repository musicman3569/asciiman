DEFINT A-Z

' Global Constants
DIM SHARED MAX_ROWS: MAX_ROWS = 28
DIM SHARED MAX_COLS: MAX_COLS = 80

' Color Palette Aliases
DIM SHARED CLR_BLACK: CLR_BLACK = 0
DIM SHARED CLR_BLUE: CLR_BLUE = 1
DIM SHARED CLR_GREEN: CLR_GREEN = 2
DIM SHARED CLR_CYAN: CLR_CYAN = 3
DIM SHARED CLR_RED: CLR_RED = 4
DIM SHARED CLR_MAGENTA: CLR_MAGENTA = 5
DIM SHARED CLR_BROWN: CLR_BROWN = 6
DIM SHARED CLR_WHITE: CLR_WHITE = 7
DIM SHARED CLR_GRAY: CLR_GRAY = 8
DIM SHARED CLR_LT_BLUE: CLR_LT_BLUE = 9
DIM SHARED CLR_LT_GREEN: CLR_LT_GREEN = 10
DIM SHARED CLR_LT_CYAN: CLR_LT_CYAN = 11
DIM SHARED CLR_LT_RED: CLR_LT_RED = 12
DIM SHARED CLR_LT_MAGENTA: CLR_LT_MAGENTA = 13
DIM SHARED CLR_YELLOW: CLR_YELLOW = 14
DIM SHARED CLR_LT_WHITE: CLR_LT_WHITE = 15

' Sprite Type Constants
DIM SHARED SPRITE_TYPE_NONE: SPRITE_TYPE_NONE = 0
DIM SHARED SPRITE_TYPE_PLAYER: SPRITE_TYPE_PLAYER = 1
DIM SHARED SPRITE_TYPE_ENEMY1: SPRITE_TYPE_ENEMY1 = 2
DIM SHARED SPRITE_TYPE_FIRE: SPRITE_TYPE_FIRE = 3
DIM SHARED SPRITE_TYPE_EXTRA_LIFE: SPRITE_TYPE_EXTRA_LIFE = 4

' Sprite Movement Type Constants
DIM SHARED SPRITE_MOVE_NONE: SPRITE_MOVE_NONE = 0
DIM SHARED SPRITE_MOVE_PLAYER_CONTROLLED: SPRITE_MOVE_PLAYER_CONTROLLED = 1
DIM SHARED SPRITE_MOVE_LR_RANDOM_GROUND: SPRITE_MOVE_LR_RANDOM_GROUND = 2

' Character Collision Behavior Constants
DIM SHARED CHAR_COLLISION_NONE: CHAR_COLLISION_NONE = 0
DIM SHARED CHAR_COLLISION_SOLID: CHAR_COLLISION_SOLID = 1
DIM SHARED CHAR_COLLISION_DEATH: CHAR_COLLISION_DEATH = 2
DIM SHARED CHAR_COLLISION_ENEMY_DEATH: CHAR_COLLISION_ENEMY_DEATH = 3
DIM SHARED CHAR_COLLISION_EXTRA_LIFE: CHAR_COLLISION_EXTRA_LIFE = 4
DIM SHARED CHAR_COLLISION_NEXT_LEVEL: CHAR_COLLISION_NEXT_LEVEL = 5
DIM SHARED CHAR_COLLISION_PUSH_LEFT: CHAR_COLLISION_PUSH_LEFT = 6
DIM SHARED CHAR_COLLISION_PUSH_RIGHT: CHAR_COLLISION_PUSH_RIGHT = 7

TYPE Sprite
    spriteType AS INTEGER
    moveType AS INTEGER
    frames AS STRING
    frame AS INTEGER
    maxFrame AS INTEGER
    frameRate AS INTEGER
    frameRateTimer AS INTEGER
    charCollision AS INTEGER
    charColor AS INTEGER
    row AS INTEGER
    col AS INTEGER
END TYPE

DIM SHARED SPRITE_PLAYER AS Sprite
SPRITE_PLAYER.spriteType = SPRITE_TYPE_PLAYER
SPRITE_PLAYER.moveType = SPRITE_MOVE_PLAYER_CONTROLLED
SPRITE_PLAYER.frames = ""
SPRITE_PLAYER.maxFrame = 0
SPRITE_PLAYER.frameRate = 0
SPRITE_PLAYER.charCollision = CHAR_COLLISION_SOLID
SPRITE_PLAYER.charColor = CLR_YELLOW

DIM SHARED SPRITE_ENEMY1 AS Sprite
SPRITE_ENEMY1.spriteType = SPRITE_TYPE_ENEMY1
SPRITE_ENEMY1.moveType = SPRITE_MOVE_LR_RANDOM_GROUND
SPRITE_ENEMY1.frames = "•¢"
SPRITE_ENEMY1.maxFrame = 1
SPRITE_ENEMY1.frameRate = 3
SPRITE_ENEMY1.charCollision = CHAR_COLLISION_SOLID
SPRITE_ENEMY1.charColor = CLR_GREEN

DIM SHARED SPRITE_FIRE AS Sprite
SPRITE_FIRE.spriteType = SPRITE_TYPE_FIRE
SPRITE_FIRE.moveType = SPRITE_MOVE_NONE
SPRITE_FIRE.frames = ",`'"
SPRITE_FIRE.maxFrame = 2
SPRITE_FIRE.frameRate = 1
SPRITE_FIRE.charCollision = CHAR_COLLISION_SOLID
SPRITE_FIRE.charColor = CLR_LT_RED

DIM SHARED SPRITE_EXTRA_LIFE AS Sprite
SPRITE_EXTRA_LIFE.spriteType = SPRITE_TYPE_EXTRA_LIFE
SPRITE_EXTRA_LIFE.moveType = SPRITE_MOVE_NONE
SPRITE_EXTRA_LIFE.frames = ""
SPRITE_EXTRA_LIFE.maxFrame = 0
SPRITE_EXTRA_LIFE.frameRate = 0
SPRITE_EXTRA_LIFE.charCollision = CHAR_COLLISION_EXTRA_LIFE
SPRITE_EXTRA_LIFE.charColor = CLR_LT_CYAN

' Start Execution
SetDisplayMode
StartGameLevel 1
SYSTEM

'--------------------------------------------------------------------------
' Start playing a specified level.
'
' @param gameLevel% Number of the game level to start.
'--------------------------------------------------------------------------
SUB StartGameLevel (gameLevel)
    LoadLevelData gameLevel
    ParseLevelData
    Pause
END SUB


'--------------------------------------------------------------------------
' Reads level data from a file in the .\DATA subfolder.
'
' @param level% Number of the level to load
'--------------------------------------------------------------------------
SUB LoadLevelData (level)
    ' Open level data file
    file$ = ".\DATA\LEV_" + LTRIM$(STR$(level)) + ".DAT"
    OPEN file$ FOR INPUT AS #1

    ' First line has the title of the level to be returned
    INPUT #1, levelTitle$
    DisplayLevelTitle levelTitle$

    ' Read/render file data to the screen
    FOR row = 1 TO MAX_ROWS
        INPUT #1, levelData$
        PrintAt row, 1, 7, levelData$
    NEXT row

    ' Close the file handle
    CLOSE #1
END SUB

'--------------------------------------------------------------------------
' Displays a level title screen for a few seconds
'
' @param title$ Level title text to display on screen
'--------------------------------------------------------------------------
SUB DisplayLevelTitle (title$)
    CLS
    ClearInkey
    PrintAt 10, 10, 15, title$
    SLEEP 3
    ClearInkey
END SUB

'--------------------------------------------------------------------------
' Initializes the game state by parsing the raw level data on the screen.
' Creates sprites, and converts the characters to the proper color and
' in-game characters to be displayed while playing.
'--------------------------------------------------------------------------
SUB ParseLevelData
    char$ = ""

    DIM groundTexture$(3)
    groundTexture$(0) = "Û"
    groundTexture$(1) = "±"
    groundTexture$(2) = "²"


    '--- TODO: This needs to be finished to handle creating sprites, etc.
    FOR row = 1 TO MAX_ROWS
        FOR col = 1 TO MAX_COLS
            char$ = CharAt$(row, col)
            SELECT CASE char$
                CASE IS = "Û" ' Solid ground with random texture
                    COLOR CLR_GRAY
                    char$ = groundTexture$(INT(RND * 3))
                CASE IS = "±"
                    COLOR CLR_CYAN
                CASE IS = "²"
                    COLOR CLR_LT_BLUE
                CASE IS = "ß"
                    COLOR CLR_GRAY
                CASE IS = "T"
                    COLOR torch.color
                    curr.char$ = ""
                CASE IS = "P"
                    COLOR pole.color
                    curr.char$ = "³"
                CASE IS = "S"
                    COLOR ground2.color
                    curr.char$ = "Û"
                CASE IS = "\"
                    COLOR slide.color
                CASE IS = "/"
                    COLOR slide.color
                CASE IS = ""
                    COLOR hero.color
                CASE IS = "°"
                    COLOR warp.color
                CASE IS = "³"
                    COLOR spike.color
                CASE ELSE
                    COLOR ground.color
            END SELECT
        NEXT col
    NEXT row
END SUB

'--------------------------------------------------------------------------
' Returns the CHAR_COLLISION_{collision_type} constant that specifies
' the collision behavior for a character.
'
' @param char$ Character to get the collision behavior for
' @return Returns one of the CHAR_COLLISION global constants.
'--------------------------------------------------------------------------
FUNCTION GetCharCollision (char$)
    SELECT CASE char$
        CASE " "
            GetCharCollision = CHAR_COLLISION_NONE
        CASE ""
            GetCharCollision = CHAR_COLLISION_EXTRA_LIFE
        CASE "°"
            GetCharCollision = CHAR_COLLISION_NEXT_LEVEL
        CASE "\"
            GetCharCollision = CHAR_COLLISION_PUSH_RIGHT
        CASE "/"
            GetCharCollision = CHAR_COLLISION_PUSH_LEFT
        CASE "³"
            GetCharCollision = CHAR_COLLISION_DEATH
        CASE ELSE
            '--- TODO: Check sprite collision here
            GetCharCollision = CHAR_COLLISION_SOLID
    END SELECT
END FUNCTION

'--------------------------------------------------------------------------
' Returns the SPRITE_TYPE_{sprite_type} constant that specifies
' the which type of sprite a character is.
'
' @param char$ Character to determing the sprite type for.
' @return Returns one of the SPRITE_TYPE global constants.
'--------------------------------------------------------------------------
FUNCTION GetSpriteType (char$)
    '--- TODO: Use the Sprite templates to check char by searching for char$ in the Sprite.frames
END FUNCTION

'==========================================================================
'                     GENERIC UTILITY FUNCTIONS
'==========================================================================

'--------------------------------------------------------------------------
' Clear the keyboard input buffer.
'--------------------------------------------------------------------------
SUB ClearInkey
    WHILE INKEY$ <> "": WEND
END SUB

'--------------------------------------------------------------------------
' Pause execution until any key is pressed.
'--------------------------------------------------------------------------
SUB Pause
    SLEEP
    ClearInkey
END SUB

'--------------------------------------------------------------------------
' Initialize the screen to the proper mode and display settings.  Only
' needs to be run once when the program starts.
'--------------------------------------------------------------------------
SUB SetDisplayMode
    CLS: SCREEN 12
    _FULLSCREEN _SQUAREPIXELS
END SUB

'--------------------------------------------------------------------------
' Print text using a specified position and color.
'
' @param row% Screen row to start printing the text
' @param col% Screen col to start printing the text
' @param text$ Text to render
'--------------------------------------------------------------------------
SUB PrintAt (row, col, textColor, text$)
    COLOR textColor
    LOCATE row, col
    PRINT text$;
END SUB

'--------------------------------------------------------------------------
' Reads a character from the screen at the specified position.
'
' @param row% Screen row to read.
' @param col% Screen col to read.
'--------------------------------------------------------------------------
FUNCTION CharAt$ (row, col)
    ChartAt$ = CHR$(SCREEN(row, col))
END FUNCTION
