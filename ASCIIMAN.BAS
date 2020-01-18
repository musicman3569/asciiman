DEFINT A-Z

'--- Global Constants
DIM SHARED MAX_ROWS: MAX_ROWS = 28 '--- Game play area height, leaves 2 rows for stats
DIM SHARED MAX_COLS: MAX_COLS = 80 '--- Game play area width

'--- Color Palette Aliases
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

'--- Sprite Type Constants: Used to identify select Sprite structs.
DIM SHARED SPRITE_TYPE_NONE: SPRITE_TYPE_NONE = 0
DIM SHARED SPRITE_TYPE_PLAYER: SPRITE_TYPE_PLAYER = 1
DIM SHARED SPRITE_TYPE_ENEMY1: SPRITE_TYPE_ENEMY1 = 2
DIM SHARED SPRITE_TYPE_FIRE: SPRITE_TYPE_FIRE = 3
DIM SHARED SPRITE_TYPE_EXTRA_LIFE: SPRITE_TYPE_EXTRA_LIFE = 4

'--- Sprite Movement Type Constants: Used to determine how sprites are moved.
DIM SHARED SPRITE_MOVE_NONE: SPRITE_MOVE_NONE = 0
DIM SHARED SPRITE_MOVE_PLAYER_CONTROLLED: SPRITE_MOVE_PLAYER_CONTROLLED = 1
DIM SHARED SPRITE_MOVE_LR_RANDOM_GROUND: SPRITE_MOVE_LR_RANDOM_GROUND = 2

'--- Character Collision Behavior Constants: Used to determine player collision behavior
DIM SHARED CHAR_COLLISION_NONE: CHAR_COLLISION_NONE = 0
DIM SHARED CHAR_COLLISION_SOLID: CHAR_COLLISION_SOLID = 1
DIM SHARED CHAR_COLLISION_DEATH: CHAR_COLLISION_DEATH = 2
DIM SHARED CHAR_COLLISION_ENEMY_DEATH: CHAR_COLLISION_ENEMY_DEATH = 3
DIM SHARED CHAR_COLLISION_EXTRA_LIFE: CHAR_COLLISION_EXTRA_LIFE = 4
DIM SHARED CHAR_COLLISION_NEXT_LEVEL: CHAR_COLLISION_NEXT_LEVEL = 5
DIM SHARED CHAR_COLLISION_PUSH_LEFT: CHAR_COLLISION_PUSH_LEFT = 6
DIM SHARED CHAR_COLLISION_PUSH_RIGHT: CHAR_COLLISION_PUSH_RIGHT = 7

'--- Main data type for configuring all game sprites
TYPE Sprite
    spriteType AS INTEGER '--- Use SPRITE_TYPE_{...} constant. Defines the type of sprite.
    moveType AS INTEGER '--- Use SPRITE_MOVE_{...} constant. Defines sprite movement behavior.
    frames AS STRING '--- String containing 1 or more characters used to render the sprite, in animation order.
    frame AS INTEGER '--- Current animation frame. Stores index of the char to display from the frames property. Range 1 to maxFrame.
    maxFrame AS INTEGER '--- Length of the frames property
    frameRate AS INTEGER '--- Number of game frames between Sprite animation frames.
    frameRateTimer AS INTEGER '--- Tracks frames between Sprite animations. Decrements from frameRate to 0.
    charCollision AS INTEGER '--- Use CHAR_COLLISION_{...} constant. Defines sprite collision behavior.
    charColor AS INTEGER '--- Use CLR_{...} constant.  Defines sprite color.
    gravity AS INTEGER '--- 1 = sprite affected by gravity, 0 = sprite not affected by gravity, -1 = sprite floats up
    gravityTimer AS INTEGER '--- Number of game frames to suspend gravity effects.
    row AS INTEGER '--- Row on the SCREEN to render sprite. Range 1 to MAX_ROWS, or 0 to disable sprite.
    col AS INTEGER '--- Column on the SCREEN to render sprite. Range 1 to MAX_COLS, or 0 to disable sprite.
END TYPE

'--------------------------------------------------------------------------
' Array to store all active game sprites
'--------------------------------------------------------------------------
DIM SHARED SPRITES(200) AS Sprite
DIM SHARED SPRITE_COUNT: SPRITE_COUNT = 0 '--- Number of active sprites.  Increment as they are added.

'--------------------------------------------------------------------------
' Array with 1 of each SPRITE_TYPE_{...} as the index.
' Used as templates for making new sprites, and for getting the attributes
' of each SPRITE_TYPE_{...}
'--------------------------------------------------------------------------
DIM SHARED SPRITE_TYPES(5) AS Sprite
DIM SHARED SPRITE_TYPES_MAX: SPRITE_TYPES_MAX = 4 '--- Highest index of the SPRINT_TYPES array below.
'--- Null Sprite template
SPRITE_TYPES(SPRITE_TYPE_NONE).spriteType = SPRITE_TYPE_NONE
'--- Player Sprite template
SPRITE_TYPES(SPRITE_TYPE_PLAYER).spriteType = SPRITE_TYPE_PLAYER
SPRITE_TYPES(SPRITE_TYPE_PLAYER).moveType = SPRITE_MOVE_PLAYER_CONTROLLED
SPRITE_TYPES(SPRITE_TYPE_PLAYER).frames = ""
SPRITE_TYPES(SPRITE_TYPE_PLAYER).maxFrame = 1
SPRITE_TYPES(SPRITE_TYPE_PLAYER).frameRate = 0
SPRITE_TYPES(SPRITE_TYPE_PLAYER).charCollision = CHAR_COLLISION_SOLID
SPRITE_TYPES(SPRITE_TYPE_PLAYER).charColor = CLR_YELLOW
SPRITE_TYPES(SPRITE_TYPE_PLAYER).gravity = 1
SPRITE_TYPES(SPRITE_TYPE_PLAYER).gravityTimer = 0
'---  Enemy1 Sprite template
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).spriteType = SPRITE_TYPE_ENEMY1
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).moveType = SPRITE_MOVE_LR_RANDOM_GROUND
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).frames = "•¢"
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).maxFrame = 2
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).frameRate = 5
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).charCollision = CHAR_COLLISION_DEATH
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).charColor = CLR_GREEN
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).gravity = 1
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).gravityTimer = 0
'--- Fire Sprite template
SPRITE_TYPES(SPRITE_TYPE_FIRE).spriteType = SPRITE_TYPE_FIRE
SPRITE_TYPES(SPRITE_TYPE_FIRE).moveType = SPRITE_MOVE_NONE
SPRITE_TYPES(SPRITE_TYPE_FIRE).frames = ".;'.;`"
SPRITE_TYPES(SPRITE_TYPE_FIRE).maxFrame = 6
SPRITE_TYPES(SPRITE_TYPE_FIRE).frameRate = 1
SPRITE_TYPES(SPRITE_TYPE_FIRE).charCollision = CHAR_COLLISION_SOLID
SPRITE_TYPES(SPRITE_TYPE_FIRE).charColor = CLR_LT_RED
SPRITE_TYPES(SPRITE_TYPE_FIRE).gravity = 0
SPRITE_TYPES(SPRITE_TYPE_FIRE).gravityTimer = 0
'--- Extra Life Sprite Template
SPRITE_TYPES(SPRITE_TYPE_EXTRA_LIFE).spriteType = SPRITE_TYPE_EXTRA_LIFE
SPRITE_TYPES(SPRITE_TYPE_EXTRA_LIFE).moveType = SPRITE_MOVE_NONE
SPRITE_TYPES(SPRITE_TYPE_EXTRA_LIFE).frames = ""
SPRITE_TYPES(SPRITE_TYPE_EXTRA_LIFE).maxFrame = 1
SPRITE_TYPES(SPRITE_TYPE_EXTRA_LIFE).frameRate = 0
SPRITE_TYPES(SPRITE_TYPE_EXTRA_LIFE).charCollision = CHAR_COLLISION_EXTRA_LIFE
SPRITE_TYPES(SPRITE_TYPE_EXTRA_LIFE).charColor = CLR_LT_CYAN
SPRITE_TYPES(SPRITE_TYPE_EXTRA_LIFE).gravity = 0
SPRITE_TYPES(SPRITE_TYPE_EXTRA_LIFE).gravityTimer = 0

'--------------------------------------------------------------------------
' Start Program Execution
'--------------------------------------------------------------------------
SetDisplayMode
StartGameLevel 4
SYSTEM

'--------------------------------------------------------------------------
' Start playing a specified level.
'
' @param gameLevel% Number of the game level to start.
'--------------------------------------------------------------------------
SUB StartGameLevel (gameLevel)
    LoadLevelData gameLevel
    ParseLevelData

    '--- TODO: Replace this with an actual game loop
    FOR i = 1 TO 100
        RenderSprites
        PrintAt 29, 1, 15, "SPRITE_COUNT:" + STR$(SPRITE_COUNT)
        _LIMIT 18
    NEXT i

    PrintAt 29, 1, 15, "Press any key to exit..."
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
    CLS
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

    FOR row = 1 TO MAX_ROWS
        FOR col = 1 TO MAX_COLS
            char$ = CharAt$(row, col)
            SELECT CASE char$
                CASE "Û" '--- Solid ground (random texture)
                    COLOR CLR_GRAY
                    char$ = groundTexture$(INT(RND * 3))
                CASE "±"
                    COLOR CLR_CYAN
                CASE "²"
                    COLOR CLR_LT_BLUE
                CASE "ß"
                    COLOR CLR_GRAY
                CASE "", "T" '--- Torch
                    COLOR CLR_YELLOW
                    char$ = ""
                CASE "P" '--- Pole   [P]
                    COLOR CLR_YELLOW
                    char$ = "³"
                CASE "S" '--- Solid color ground (untextured)
                    COLOR CLR_GRAY
                    char$ = "Û"
                CASE "\" '--- Slide (right)
                    COLOR CLR_BROWN
                CASE "/" '--- Slide (left)
                    COLOR CLR_BROWN
                CASE "" '--- Player
                    COLOR CLR_YELLOW
                CASE "°" '--- Level Exit
                    COLOR CLR_LT_MAGENTA
                CASE "³" '--- Spike Hazard
                    COLOR CLR_LT_CYAN
                CASE "O" '--- Enemy1 SPRITE
                    char$ = "•"
                CASE "F" '--- Fire SPRITE
                    char$ = "'"
                CASE ELSE
                    COLOR CLR_GRAY
            END SELECT

            LOCATE row, col: PRINT char$

            spriteType = GetSpriteType(char$)
            IF spriteType THEN AddSprite spriteType, row, col
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
            spriteType = GetSpriteType(char$)
            IF spriteType THEN
                GetCharCollision = SPRITE_TYPES(spriteType).charCollision
            ELSE
                GetCharCollision = CHAR_COLLISION_SOLID
            END IF
    END SELECT
END FUNCTION

'--------------------------------------------------------------------------
' Renders all active sprites to the screen and updates their animation frames.
'--------------------------------------------------------------------------
SUB RenderSprites
    DIM currSprite AS Sprite

    FOR index = 0 TO SPRITE_COUNT - 1
        currSprite = SPRITES(index)
        currFrame = currSprite.frame

        '--- Only render on-screen sprites.
        IF currSprite.row > 0 AND currSprite.col > 0 THEN
            SPRITES(index).charColor = AnimateSpriteColor(currSprite)
            PrintAt currSprite.row, currSprite.col, currSprite.charColor, MID$(currSprite.frames, currSprite.frame, 1)

            '--- Only animate sprite if framerate is above 0
            IF SPRITES(index).frameRate THEN
                SPRITES(index).frameRateTimer = (SPRITES(index).frameRateTimer + 1) MOD SPRITES(index).frameRate

                '--- Animate next frame when frameRateTimer cycles to 0
                IF SPRITES(index).frameRateTimer = 0 THEN
                    SPRITES(index).frame = SPRITES(index).frame + 1
                    IF SPRITES(index).frame > SPRITES(index).maxFrame THEN SPRITES(index).frame = 1
                END IF
            END IF
        END IF
    NEXT index
END SUB

FUNCTION AnimateSpriteColor (sprite AS Sprite)
    SELECT CASE sprite.spriteType
        CASE SPRITE_TYPE_FIRE
            colorRandomizer = INT(RND * 2)
            IF colorRandomizer = 0 THEN AnimateSpriteColor = CLR_RED
            IF colorRandomizer = 1 THEN AnimateSpriteColor = CLR_LT_RED
        CASE SPRITE_TYPE_EXTRA_LIFE
            AnimateSpriteColor = (sprite.charColor + 1) MOD 15
            IF AnimateSpriteColor = 0 THEN AnimateSpiteColor = 1
        CASE ELSE
            AnimateSpriteColor = sprite.charColor
    END SELECT
END FUNCTION

'--------------------------------------------------------------------------
' Initializes a new sprit into the global SPRITES array and increments
' the SPRITE_COUNT so all initialized Sprites can be tracked.
'
' @param spriteType% One of the SPRITE_TYPE_{...} constants to specify the type.
' @param row% Row of the sprite's starting position.
' @param col% Col of the sprite's starting position.
'--------------------------------------------------------------------------
SUB AddSprite (spriteType%, row%, col%)
    '--- Clone sprite from the SPRITE_TYPE template
    DIM template AS Sprite
    template = SPRITE_TYPES(spriteType%)
    SPRITES(SPRITE_COUNT) = template

    '--- Randomize frame positions and frameTimer so everything isn't in unison.
    SPRITES(SPRITE_COUNT).frame = INT(RND * template.maxFrame) + 1
    SPRITES(SPRITE_COUNT).frameRateTimer = INT(RND * template.frameRate)

    '--- Set the sprite position
    SPRITES(SPRITE_COUNT).row = row%
    SPRITES(SPRITE_COUNT).col = col%

    '--- Update sprite count so we know how many there are
    SPRITE_COUNT = SPRITE_COUNT + 1
END SUB

'--------------------------------------------------------------------------
' Returns the SPRITE_TYPE_{sprite_type} constant that specifies
' the which type of sprite a character is.
'
' @param char$ Character to determing the sprite type for.
' @return Returns one of the SPRITE_TYPE global constants.
'--------------------------------------------------------------------------
FUNCTION GetSpriteType (char$)
    GetSpriteType = SPRITE_TYPE_NONE

    '--- Search all characters in all the SpriteTypes animation frames
    IF char$ <> " " THEN
        FOR currSpriteType = 1 TO SPRITE_TYPES_MAX
            IF INSTR(SPRITE_TYPES(currSpriteType).frames, char$) THEN
                GetSpriteType = currSpriteType
                EXIT FOR
            END IF
        NEXT currSpriteType
    END IF
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
    CharAt$ = CHR$(SCREEN(row, col))
END FUNCTION

'--------------------------------------------------------------------------
' Clears the screen, displays a message, and terminates the program.
' Use when outputting debugging information when troubleshooting.
'
' @param msg$ Debugging output to display on-screen
'--------------------------------------------------------------------------
SUB Debug (msg$)
    CLS
    PrintAt 1, 1, 15, msg$
    Pause
    SYSTEM
END SUB

'--------------------------------------------------------------------------
' Displays all the properties of a Sprite on-screen and pauses.
' Useful when debugging Sprite values.
'
' @param mySprite Sprite data to display.
' @param terminate% Set to 1 to end execution after debugging.
'--------------------------------------------------------------------------
SUB DebugSprite (mySprite AS Sprite, terminate%)
    'CLS
    LOCATE 1, 1
    COLOR 7, 0
    PRINT "spriteType: " + STR$(mySprite.spriteType)
    PRINT "moveType: " + STR$(mySprite.moveType)
    PRINT "frames: " + mySprite.frames
    PRINT "frame: " + STR$(mySprite.frame)
    PRINT "maxFrame: " + STR$(mySprite.maxFrame)
    PRINT "frameRate: " + STR$(mySprite.frameRate)
    PRINT "frameRateTimer: " + STR$(mySprite.frameRateTimer)
    PRINT "charCollision: " + STR$(mySprite.charCollision)
    PRINT "charColor: " + STR$(mySprite.charColor)
    PRINT "gravity: " + STR$(mySprite.gravity)
    PRINT "gravityTimer: " + STR$(mySprite.gravityTimer)
    PRINT "row: " + STR$(mySprite.row)
    PRINT "col: " + STR$(mySprite.col)
    Pause
    IF terminate% THEN SYSTEM
END SUB
