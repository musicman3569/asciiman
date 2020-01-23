DEFINT A-Z

TYPE Coord
    row AS INTEGER
    col AS INTEGER
END TYPE

TYPE Rectangle
    min AS Coord
    max AS Coord
END TYPE

'--- Useful when array searching to indicate no index was found.
DIM SHARED NULL_INDEX: NULL_INDEX = -1

'--------------------------------------------------------------------------
' The GameState TYPE stores global game state information and settings.
'--------------------------------------------------------------------------
TYPE GameState
    soundEnabled AS INTEGER '--- 1 = Enable sound effects, 0 = Disable all sound
    loadedLevel AS INTEGER '--- Currently loaded game level. 0 = none loaded.
    nextLevel AS INTEGER '--- Game level to load. Increments as levels are completed.
    levelTitle AS STRING '--- Title of the currently loaded level.
    gravity AS INTEGER '--- Global gravity direction to combine with Sprite gravity settings.
    frameRate AS INTEGER '--- Framerate the game loop runs at in frames-per-second.
END TYPE

'--- Initialize global game state
DIM SHARED GAME_STATE AS GameState
GAME_STATE.soundEnabled = 1
GAME_STATE.loadedLevel = 0
GAME_STATE.nextLevel = 1
GAME_STATE.gravity = 1
GAME_STATE.frameRate = 18

'--------------------------------------------------------------------------
' Debugging variables for tracking information, changing values has no functional impact.
'--------------------------------------------------------------------------
DIM SHARED DEBUG_ON: DEBUG_ON = 1 '--- 1 = Display messages from as Debug...() SUBs, 0 = Hide messages
DIM SHARED DEBUG_SPRITE_INDEX: DEBUG_SPRITE_INDEX = NULL_INDEX '--- For tracking sprite index values
DIM SHARED DEBUG_CALLER AS STRING: DEBUG_CALLER = "NONE" '--- For tracking calling SUBs (stack tracing)

'--------------------------------------------------------------------------
' Used to store all chars from the keyboard input buffer each frame
'--------------------------------------------------------------------------
DIM SHARED KEY_INPUT(10) AS STRING
DIM SHARED KEY_INPUT_MAX: KEY_INPUT_MAX = 0

'--------------------------------------------------------------------------
' Dimensions of the screen
'--------------------------------------------------------------------------
DIM SHARED SCREEN_AREA AS Rectangle
SCREEN_AREA.min.row = 1
SCREEN_AREA.min.col = 1
SCREEN_AREA.max.row = 30
SCREEN_AREA.max.col = 80

'--------------------------------------------------------------------------
' Dimensions of the game play area, leaves 2 rows for stats
'--------------------------------------------------------------------------
DIM SHARED GAME_AREA AS Rectangle
GAME_AREA.min.row = 1
GAME_AREA.min.col = 1
GAME_AREA.max.row = 28
GAME_AREA.max.col = 80

'--------------------------------------------------------------------------
' Color Palette Aliases
'--------------------------------------------------------------------------
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

'--------------------------------------------------------------------------
' The Player TYPE stores information about each player during game play.
'--------------------------------------------------------------------------
TYPE Player
    enabled AS INTEGER '--- 1 = Player is enabled, 2 = Player is disabled
    spriteIndex AS INTEGER '--- Stores the index values of the player sprites in the SPRITES() array.
    spriteColor AS INTEGER '--- Color the player's default sprite should be.
    startRow AS INTEGER '--- Stores the spawn row position of the player
    startCol AS INTEGER '--- Stores the spawn col position of the player
    score AS INTEGER '--- Total score the player has earned.
    keyLeft AS STRING '--- Key binding to move left
    keyRight AS STRING '--- Key binding to move right
    keyJump AS STRING '--- Key binding to jump
    keySpikeball AS STRING '--- Key binding to perform Spikeball attack
END TYPE

DIM SHARED PLAYER(5) AS Player '--- Stores the index values of the player sprites in the SPRITES() array.
DIM SHARED PLAYER_MAX: PLAYER_MAX = 0 '--- Number of active players in the game

PLAYER(1).enabled = 1
PLAYER(1).spriteColor = CLR_YELLOW
PLAYER(1).keyLeft = CHR$(0) + "K" '--- Left arrow key
PLAYER(1).keyRight = CHR$(0) + "M" '--- Right arrow key
PLAYER(1).keyJump = CHR$(0) + "H" '--- Up arrow key
PLAYER(1).keySpikeball = CHR$(0) + "P" '--- Down arrow key

PLAYER(2).enabled = 0
PLAYER(2).spriteColor = CLR_LT_BLUE
PLAYER(2).keyLeft = "A"
PLAYER(2).keyRight = "D"
PLAYER(2).keyJump = "W"
PLAYER(2).keySpikeball = "S"

'--------------------------------------------------------------------------
' Sprite Type Constants: Used to identify select Sprite structs.
'--------------------------------------------------------------------------
DIM SHARED SPRITE_TYPE_NONE: SPRITE_TYPE_NONE = 0
DIM SHARED SPRITE_TYPE_PLAYER: SPRITE_TYPE_PLAYER = 1
DIM SHARED SPRITE_TYPE_PLAYER_SPIKEBALL: SPRITE_TYPE_PLAYER_SPIKEBALL = 2
DIM SHARED SPRITE_TYPE_PLAYER_DRAINED: SPRITE_TYPE_PLAYER_DRAINED = 3
DIM SHARED SPRITE_TYPE_ENEMY1: SPRITE_TYPE_ENEMY1 = 4
DIM SHARED SPRITE_TYPE_FIRE: SPRITE_TYPE_FIRE = 5
DIM SHARED SPRITE_TYPE_EXTRA_LIFE: SPRITE_TYPE_EXTRA_LIFE = 6
DIM SHARED SPRITE_TYPE_SPIKE: SPRITE_TYPE_SPIKE = 7
DIM SHARED SPRITE_TYPE_SLIDE_L: SPRITE_TYPE_SLIDE_L = 8
DIM SHARED SPRITE_TYPE_SLIDE_R: SPRITE_TYPE_SLIDE_R = 9
DIM SHARED SPRITE_TYPE_NEXT_LEVEL: SPRITE_TYPE_NEXT_LEVEL = 10
'--- Highest index of the SPRINT_TYPE constants above.
DIM SHARED SPRITE_TYPES_MAX: SPRITE_TYPES_MAX = 10

'--------------------------------------------------------------------------
' Sprite Movement Type Constants: Used to determine how sprites are moved.
'--------------------------------------------------------------------------
DIM SHARED SPRITE_MOVE_NONE: SPRITE_MOVE_NONE = 0
DIM SHARED SPRITE_MOVE_PLAYER_CONTROLLED: SPRITE_MOVE_PLAYER_CONTROLLED = 1
DIM SHARED SPRITE_MOVE_LR_RANDOM_GROUND: SPRITE_MOVE_LR_RANDOM_GROUND = 2

'--------------------------------------------------------------------------
' Character Collision Behavior Constants: Used to determine player collision behavior
'--------------------------------------------------------------------------
DIM SHARED CHAR_COLLISION_NONE: CHAR_COLLISION_NONE = 0
DIM SHARED CHAR_COLLISION_SOLID: CHAR_COLLISION_SOLID = 1
DIM SHARED CHAR_COLLISION_DEATH: CHAR_COLLISION_DEATH = 2
DIM SHARED CHAR_COLLISION_ENEMY_DEATH: CHAR_COLLISION_ENEMY_DEATH = 3
DIM SHARED CHAR_COLLISION_EXTRA_LIFE: CHAR_COLLISION_EXTRA_LIFE = 4
DIM SHARED CHAR_COLLISION_NEXT_LEVEL: CHAR_COLLISION_NEXT_LEVEL = 5
DIM SHARED CHAR_COLLISION_PUSH_LEFT: CHAR_COLLISION_PUSH_LEFT = 6
DIM SHARED CHAR_COLLISION_PUSH_RIGHT: CHAR_COLLISION_PUSH_RIGHT = 7
DIM SHARED CHAR_COLLISION_VERTICAL_DEATH: CHAR_COLLISION_VERTICAL_DEATH = 8
DIM SHARED CHAR_COLLISION_VERTICAL_ENEMY_DEATH: CHAR_COLLISION_VERTICAL_ENEMY_DEATH = 9
'--- Highest index of the CHAR_COLLISION constants above
DIM SHARED CHAR_COLLISION_MAX: CHAR_COLLISION_MAX = 9

'--------------------------------------------------------------------------
' The Sprite TYPE stores the state of each Sprite instance during game play.
'--------------------------------------------------------------------------
TYPE Sprite
    spriteType AS INTEGER '--- Use SPRITE_TYPE_{...} constant. Defines the type of sprite.
    moveType AS INTEGER '--- Use SPRITE_MOVE_{...} constant. Defines sprite movement behavior.
    frames AS STRING '--- String containing 1 or more characters used to render the sprite, in animation order.
    frame AS INTEGER '--- Current animation frame. Stores index of the char to display from the frames property. Range 1 to maxFrame.
    maxFrame AS INTEGER '--- Length of the frames property
    frameRate AS INTEGER '--- Number of game frames between Sprite animation frames.
    frameRateTimer AS INTEGER '--- Tracks frames between Sprite animations. Decrements from frameRate to 0.
    charColor AS INTEGER '--- Use CLR_{...} constant.  Defines sprite color.
    gravity AS INTEGER '--- 1 = sprite affected by gravity, 0 = sprite not affected by gravity, -1 = sprite floats up
    gravityTimer AS INTEGER '--- Number of game frames to suspend gravity effects.
    nextSpriteType AS INTEGER '--- Use SPRITE_TYPE_{...} constant. Changes the current sprite to this SPRITE_TYPES template. SPRITE_TYPE_NONE = no change.
    nextSpriteTypeTimer AS INTEGER '--- Number of frames to wait before changing the sprite to the value in nextSpriteType.
    lives AS INTEGER '--- Stores the health of number of lives remaining for a sprite.
    position AS Coord '--- Row/col position in the GAME_AREA Rectangle bounds to render sprite. Set row or col to 0 to disable sprite.
    velocity AS Coord '--- Number of chars to move the row/col of the sprite during the next frame.
    moveTo AS Coord '--- Used internally as the sprite is being moved and velocity is being applied. Do not modify directly.
    moveTimer AS INTEGER '--- Number of game frames to disallow automatic or player controlled movement.
    friction AS INTEGER '--- Amount of velocity reduction to apply each frame when on a solid. Defaults to 1.
    playerIndex AS INTEGER '--- Index of the PLAYER() that controls the sprite. 0 = not player controlled (default).
END TYPE

DIM SHARED SPRITES(200) AS Sprite '--- Array to store all active game sprites
DIM SHARED SPRITE_COUNT: SPRITE_COUNT = 0 '--- Number of active sprites.  Increment as they are added.

'--------------------------------------------------------------------------
' Array with 1 of each SPRITE_TYPE_{...} as the index.
' Used as templates for making new sprites, and for getting the attributes
' of each SPRITE_TYPE_{...}
'--------------------------------------------------------------------------
DIM SHARED SPRITE_TYPES(SPRITE_TYPES_MAX + 1) AS Sprite

'--- Apply default settings to all SPRITE_TYPES, can be overridden below.
FOR spriteType = 0 TO SPRITE_TYPES_MAX
    SPRITE_TYPES(spriteType).friction = 1
    SPRITE_TYPES(spriteType).frame = 1
NEXT spriteType

'--- Null Sprite template
SPRITE_TYPES(SPRITE_TYPE_NONE).spriteType = SPRITE_TYPE_NONE
'--- Player Sprite template
SPRITE_TYPES(SPRITE_TYPE_PLAYER).spriteType = SPRITE_TYPE_PLAYER
SPRITE_TYPES(SPRITE_TYPE_PLAYER).moveType = SPRITE_MOVE_PLAYER_CONTROLLED
SPRITE_TYPES(SPRITE_TYPE_PLAYER).frames = ""
SPRITE_TYPES(SPRITE_TYPE_PLAYER).maxFrame = 1
SPRITE_TYPES(SPRITE_TYPE_PLAYER).frameRate = 0
SPRITE_TYPES(SPRITE_TYPE_PLAYER).charColor = CLR_YELLOW
SPRITE_TYPES(SPRITE_TYPE_PLAYER).gravity = 1
SPRITE_TYPES(SPRITE_TYPE_PLAYER).gravityTimer = 0
SPRITE_TYPES(SPRITE_TYPE_PLAYER).lives = 9
'--- Player Spikeball Sprite template
SPRITE_TYPES(SPRITE_TYPE_PLAYER_SPIKEBALL).spriteType = SPRITE_TYPE_PLAYER_SPIKEBALL
SPRITE_TYPES(SPRITE_TYPE_PLAYER_SPIKEBALL).moveType = SPRITE_MOVE_NONE
SPRITE_TYPES(SPRITE_TYPE_PLAYER_SPIKEBALL).frames = ""
SPRITE_TYPES(SPRITE_TYPE_PLAYER_SPIKEBALL).maxFrame = 1
SPRITE_TYPES(SPRITE_TYPE_PLAYER_SPIKEBALL).frameRate = 0
SPRITE_TYPES(SPRITE_TYPE_PLAYER_SPIKEBALL).charColor = CLR_LT_WHITE
SPRITE_TYPES(SPRITE_TYPE_PLAYER_SPIKEBALL).gravity = 1
SPRITE_TYPES(SPRITE_TYPE_PLAYER_SPIKEBALL).gravityTimer = 0
SPRITE_TYPES(SPRITE_TYPE_PLAYER_SPIKEBALL).nextSpriteType = SPRITE_TYPE_PLAYER_DRAINED
SPRITE_TYPES(SPRITE_TYPE_PLAYER_SPIKEBALL).nextSpriteTypeTimer = 5
'--- Player Drained Sprite template (can't use attacks)
SPRITE_TYPES(SPRITE_TYPE_PLAYER_DRAINED).spriteType = SPRITE_TYPE_PLAYER_DRAINED
SPRITE_TYPES(SPRITE_TYPE_PLAYER_DRAINED).moveType = SPRITE_MOVE_PLAYER_CONTROLLED
SPRITE_TYPES(SPRITE_TYPE_PLAYER_DRAINED).frames = ""
SPRITE_TYPES(SPRITE_TYPE_PLAYER_DRAINED).maxFrame = 1
SPRITE_TYPES(SPRITE_TYPE_PLAYER_DRAINED).frameRate = 0
SPRITE_TYPES(SPRITE_TYPE_PLAYER_DRAINED).charColor = CLR_LT_RED
SPRITE_TYPES(SPRITE_TYPE_PLAYER_DRAINED).gravity = 1
SPRITE_TYPES(SPRITE_TYPE_PLAYER_DRAINED).gravityTimer = 0
SPRITE_TYPES(SPRITE_TYPE_PLAYER_DRAINED).nextSpriteType = SPRITE_TYPE_PLAYER
SPRITE_TYPES(SPRITE_TYPE_PLAYER_DRAINED).nextSpriteTypeTimer = 16
'---  Enemy1 Sprite template
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).spriteType = SPRITE_TYPE_ENEMY1
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).moveType = SPRITE_MOVE_LR_RANDOM_GROUND
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).frames = "•¢"
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).maxFrame = 2
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).frameRate = 5
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).charColor = CLR_GREEN
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).gravity = 1
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).gravityTimer = 0
'--- Fire Sprite template
SPRITE_TYPES(SPRITE_TYPE_FIRE).spriteType = SPRITE_TYPE_FIRE
SPRITE_TYPES(SPRITE_TYPE_FIRE).moveType = SPRITE_MOVE_NONE
SPRITE_TYPES(SPRITE_TYPE_FIRE).frames = ".;'.;`"
SPRITE_TYPES(SPRITE_TYPE_FIRE).maxFrame = 6
SPRITE_TYPES(SPRITE_TYPE_FIRE).frameRate = 1
SPRITE_TYPES(SPRITE_TYPE_FIRE).charColor = CLR_LT_RED
SPRITE_TYPES(SPRITE_TYPE_FIRE).gravity = 1
SPRITE_TYPES(SPRITE_TYPE_FIRE).gravityTimer = 0
'--- Extra Life Sprite Template
SPRITE_TYPES(SPRITE_TYPE_EXTRA_LIFE).spriteType = SPRITE_TYPE_EXTRA_LIFE
SPRITE_TYPES(SPRITE_TYPE_EXTRA_LIFE).moveType = SPRITE_MOVE_NONE
SPRITE_TYPES(SPRITE_TYPE_EXTRA_LIFE).frames = ""
SPRITE_TYPES(SPRITE_TYPE_EXTRA_LIFE).maxFrame = 1
SPRITE_TYPES(SPRITE_TYPE_EXTRA_LIFE).frameRate = 0
SPRITE_TYPES(SPRITE_TYPE_EXTRA_LIFE).charColor = CLR_LT_CYAN
SPRITE_TYPES(SPRITE_TYPE_EXTRA_LIFE).gravity = 1
SPRITE_TYPES(SPRITE_TYPE_EXTRA_LIFE).gravityTimer = 0
'--- Spike Sprite template
SPRITE_TYPES(SPRITE_TYPE_SPIKE).spriteType = SPRITE_TYPE_SPIKE
SPRITE_TYPES(SPRITE_TYPE_SPIKE).moveType = SPRITE_MOVE_NONE
SPRITE_TYPES(SPRITE_TYPE_SPIKE).frames = "³"
SPRITE_TYPES(SPRITE_TYPE_SPIKE).maxFrame = 1
SPRITE_TYPES(SPRITE_TYPE_SPIKE).frameRate = 0
SPRITE_TYPES(SPRITE_TYPE_SPIKE).charColor = CLR_LT_CYAN
SPRITE_TYPES(SPRITE_TYPE_SPIKE).gravity = 0
SPRITE_TYPES(SPRITE_TYPE_SPIKE).gravityTimer = 0
'--- Slide Right Sprite template
SPRITE_TYPES(SPRITE_TYPE_SLIDE_R).spriteType = SPRITE_TYPE_SLIDE_R
SPRITE_TYPES(SPRITE_TYPE_SLIDE_R).moveType = SPRITE_MOVE_NONE
SPRITE_TYPES(SPRITE_TYPE_SLIDE_R).frames = "\"
SPRITE_TYPES(SPRITE_TYPE_SLIDE_R).maxFrame = 1
SPRITE_TYPES(SPRITE_TYPE_SLIDE_R).frameRate = 0
SPRITE_TYPES(SPRITE_TYPE_SLIDE_R).charColor = CLR_BROWN
SPRITE_TYPES(SPRITE_TYPE_SLIDE_R).gravity = 0
SPRITE_TYPES(SPRITE_TYPE_SLIDE_R).gravityTimer = 0
'--- Slide Left Sprite template
SPRITE_TYPES(SPRITE_TYPE_SLIDE_L).spriteType = SPRITE_TYPE_SLIDE_L
SPRITE_TYPES(SPRITE_TYPE_SLIDE_L).moveType = SPRITE_MOVE_NONE
SPRITE_TYPES(SPRITE_TYPE_SLIDE_L).frames = "/"
SPRITE_TYPES(SPRITE_TYPE_SLIDE_L).maxFrame = 1
SPRITE_TYPES(SPRITE_TYPE_SLIDE_L).frameRate = 0
SPRITE_TYPES(SPRITE_TYPE_SLIDE_L).charColor = CLR_BROWN
SPRITE_TYPES(SPRITE_TYPE_SLIDE_L).gravity = 0
SPRITE_TYPES(SPRITE_TYPE_SLIDE_L).gravityTimer = 0
'--- Next Level Sprite template
SPRITE_TYPES(SPRITE_TYPE_NEXT_LEVEL).spriteType = SPRITE_TYPE_NEXT_LEVEL
SPRITE_TYPES(SPRITE_TYPE_NEXT_LEVEL).moveType = SPRITE_MOVE_NONE
SPRITE_TYPES(SPRITE_TYPE_NEXT_LEVEL).frames = "°"
SPRITE_TYPES(SPRITE_TYPE_NEXT_LEVEL).maxFrame = 1
SPRITE_TYPES(SPRITE_TYPE_NEXT_LEVEL).frameRate = 0
SPRITE_TYPES(SPRITE_TYPE_NEXT_LEVEL).charColor = CLR_LT_MAGENTA
SPRITE_TYPES(SPRITE_TYPE_NEXT_LEVEL).gravity = 0
SPRITE_TYPES(SPRITE_TYPE_NEXT_LEVEL).gravityTimer = 0

'--------------------------------------------------------------------------
' Sprite collision mappings.
' The 1st index is the Sprite that is moving.
' The 2nd index is the Sprite at the movement destination.
' Value is the collision behavior FROM THE PERSPECTIVE OF THE 1st Sprite.
'
' This means CHAR_COLLISION_DEATH causes the 1st sprite to die,
' and CHAR_COLLISION_ENEMY_DEATH causes the 2nd sprite to die.
'--------------------------------------------------------------------------
DIM SHARED COLLISIONS(SPRITE_TYPES_MAX, SPRITE_TYPES_MAX) AS INTEGER
'--- Player movement collisions
COLLISIONS(SPRITE_TYPE_PLAYER, SPRITE_TYPE_PLAYER) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_PLAYER, SPRITE_TYPE_PLAYER_SPIKEBALL) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_PLAYER, SPRITE_TYPE_PLAYER_DRAINED) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_PLAYER, SPRITE_TYPE_ENEMY1) = CHAR_COLLISION_DEATH
COLLISIONS(SPRITE_TYPE_PLAYER, SPRITE_TYPE_FIRE) = CHAR_COLLISION_DEATH
COLLISIONS(SPRITE_TYPE_PLAYER, SPRITE_TYPE_EXTRA_LIFE) = CHAR_COLLISION_EXTRA_LIFE
COLLISIONS(SPRITE_TYPE_PLAYER, SPRITE_TYPE_SPIKE) = CHAR_COLLISION_VERTICAL_DEATH
COLLISIONS(SPRITE_TYPE_PLAYER, SPRITE_TYPE_SLIDE_L) = CHAR_COLLISION_PUSH_LEFT
COLLISIONS(SPRITE_TYPE_PLAYER, SPRITE_TYPE_SLIDE_R) = CHAR_COLLISION_PUSH_RIGHT
COLLISIONS(SPRITE_TYPE_PLAYER, SPRITE_TYPE_NEXT_LEVEL) = CHAR_COLLISION_NEXT_LEVEL
'--- Player Spikeball movement collisions
COLLISIONS(SPRITE_TYPE_PLAYER_SPIKEBALL, SPRITE_TYPE_PLAYER) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_PLAYER_SPIKEBALL, SPRITE_TYPE_PLAYER_SPIKEBALL) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_PLAYER_SPIKEBALL, SPRITE_TYPE_PLAYER_DRAINED) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_PLAYER_SPIKEBALL, SPRITE_TYPE_ENEMY1) = CHAR_COLLISION_ENEMY_DEATH
COLLISIONS(SPRITE_TYPE_PLAYER_SPIKEBALL, SPRITE_TYPE_FIRE) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_PLAYER_SPIKEBALL, SPRITE_TYPE_EXTRA_LIFE) = CHAR_COLLISION_EXTRA_LIFE
COLLISIONS(SPRITE_TYPE_PLAYER_SPIKEBALL, SPRITE_TYPE_SPIKE) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_PLAYER_SPIKEBALL, SPRITE_TYPE_SLIDE_L) = CHAR_COLLISION_PUSH_LEFT
COLLISIONS(SPRITE_TYPE_PLAYER_SPIKEBALL, SPRITE_TYPE_SLIDE_R) = CHAR_COLLISION_PUSH_RIGHT
COLLISIONS(SPRITE_TYPE_PLAYER_SPIKEBALL, SPRITE_TYPE_NEXT_LEVEL) = CHAR_COLLISION_NEXT_LEVEL
'--- Player Drained movement collisions
COLLISIONS(SPRITE_TYPE_PLAYER_DRAINED, SPRITE_TYPE_PLAYER) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_PLAYER_DRAINED, SPRITE_TYPE_PLAYER_SPIKEBALL) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_PLAYER_DRAINED, SPRITE_TYPE_PLAYER_DRAINED) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_PLAYER_DRAINED, SPRITE_TYPE_ENEMY1) = CHAR_COLLISION_DEATH
COLLISIONS(SPRITE_TYPE_PLAYER_DRAINED, SPRITE_TYPE_FIRE) = CHAR_COLLISION_DEATH
COLLISIONS(SPRITE_TYPE_PLAYER_DRAINED, SPRITE_TYPE_EXTRA_LIFE) = CHAR_COLLISION_EXTRA_LIFE
COLLISIONS(SPRITE_TYPE_PLAYER_DRAINED, SPRITE_TYPE_SPIKE) = CHAR_COLLISION_VERTICAL_DEATH
COLLISIONS(SPRITE_TYPE_PLAYER_DRAINED, SPRITE_TYPE_SLIDE_L) = CHAR_COLLISION_PUSH_LEFT
COLLISIONS(SPRITE_TYPE_PLAYER_DRAINED, SPRITE_TYPE_SLIDE_R) = CHAR_COLLISION_PUSH_RIGHT
COLLISIONS(SPRITE_TYPE_PLAYER_DRAINED, SPRITE_TYPE_NEXT_LEVEL) = CHAR_COLLISION_NEXT_LEVEL
'--- Enemy1 movement collisions
COLLISIONS(SPRITE_TYPE_ENEMY1, SPRITE_TYPE_PLAYER) = CHAR_COLLISION_ENEMY_DEATH
COLLISIONS(SPRITE_TYPE_ENEMY1, SPRITE_TYPE_PLAYER_SPIKEBALL) = CHAR_COLLISION_DEATH
COLLISIONS(SPRITE_TYPE_ENEMY1, SPRITE_TYPE_PLAYER_DRAINED) = CHAR_COLLISION_ENEMY_DEATH
COLLISIONS(SPRITE_TYPE_ENEMY1, SPRITE_TYPE_ENEMY1) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_ENEMY1, SPRITE_TYPE_FIRE) = CHAR_COLLISION_VERTICAL_DEATH
COLLISIONS(SPRITE_TYPE_ENEMY1, SPRITE_TYPE_EXTRA_LIFE) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_ENEMY1, SPRITE_TYPE_SPIKE) = CHAR_COLLISION_VERTICAL_DEATH
COLLISIONS(SPRITE_TYPE_ENEMY1, SPRITE_TYPE_SLIDE_L) = CHAR_COLLISION_PUSH_LEFT
COLLISIONS(SPRITE_TYPE_ENEMY1, SPRITE_TYPE_SLIDE_R) = CHAR_COLLISION_PUSH_RIGHT
COLLISIONS(SPRITE_TYPE_ENEMY1, SPRITE_TYPE_NEXT_LEVEL) = CHAR_COLLISION_SOLID
'--- Fire movement collisions
COLLISIONS(SPRITE_TYPE_FIRE, SPRITE_TYPE_PLAYER) = CHAR_COLLISION_ENEMY_DEATH
COLLISIONS(SPRITE_TYPE_FIRE, SPRITE_TYPE_PLAYER_SPIKEBALL) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_FIRE, SPRITE_TYPE_PLAYER_DRAINED) = CHAR_COLLISION_ENEMY_DEATH
COLLISIONS(SPRITE_TYPE_FIRE, SPRITE_TYPE_ENEMY1) = CHAR_COLLISION_VERTICAL_ENEMY_DEATH
COLLISIONS(SPRITE_TYPE_FIRE, SPRITE_TYPE_FIRE) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_FIRE, SPRITE_TYPE_EXTRA_LIFE) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_FIRE, SPRITE_TYPE_SPIKE) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_FIRE, SPRITE_TYPE_SLIDE_L) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_FIRE, SPRITE_TYPE_SLIDE_R) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_FIRE, SPRITE_TYPE_NEXT_LEVEL) = CHAR_COLLISION_SOLID
'--- Extra Life movement collisions
COLLISIONS(SPRITE_TYPE_EXTRA_LIFE, SPRITE_TYPE_PLAYER) = CHAR_COLLISION_EXTRA_LIFE
COLLISIONS(SPRITE_TYPE_EXTRA_LIFE, SPRITE_TYPE_PLAYER_SPIKEBALL) = CHAR_COLLISION_EXTRA_LIFE
COLLISIONS(SPRITE_TYPE_EXTRA_LIFE, SPRITE_TYPE_PLAYER_DRAINED) = CHAR_COLLISION_EXTRA_LIFE
COLLISIONS(SPRITE_TYPE_EXTRA_LIFE, SPRITE_TYPE_ENEMY1) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_EXTRA_LIFE, SPRITE_TYPE_FIRE) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_EXTRA_LIFE, SPRITE_TYPE_EXTRA_LIFE) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_EXTRA_LIFE, SPRITE_TYPE_SPIKE) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_EXTRA_LIFE, SPRITE_TYPE_SLIDE_L) = CHAR_COLLISION_PUSH_LEFT
COLLISIONS(SPRITE_TYPE_EXTRA_LIFE, SPRITE_TYPE_SLIDE_R) = CHAR_COLLISION_PUSH_RIGHT
COLLISIONS(SPRITE_TYPE_EXTRA_LIFE, SPRITE_TYPE_NEXT_LEVEL) = CHAR_COLLISION_SOLID
'--- Spike movement collisions
COLLISIONS(SPRITE_TYPE_SPIKE, SPRITE_TYPE_PLAYER) = CHAR_COLLISION_VERTICAL_ENEMY_DEATH
COLLISIONS(SPRITE_TYPE_SPIKE, SPRITE_TYPE_PLAYER_SPIKEBALL) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_SPIKE, SPRITE_TYPE_PLAYER_DRAINED) = CHAR_COLLISION_VERTICAL_ENEMY_DEATH
COLLISIONS(SPRITE_TYPE_SPIKE, SPRITE_TYPE_ENEMY1) = CHAR_COLLISION_ENEMY_DEATH
COLLISIONS(SPRITE_TYPE_SPIKE, SPRITE_TYPE_FIRE) = CHAR_COLLISION_ENEMY_DEATH
COLLISIONS(SPRITE_TYPE_SPIKE, SPRITE_TYPE_EXTRA_LIFE) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_SPIKE, SPRITE_TYPE_SPIKE) = CHAR_COLLISION_SOLID
COLLISIONS(SPRITE_TYPE_SPIKE, SPRITE_TYPE_SLIDE_L) = CHAR_COLLISION_PUSH_LEFT
COLLISIONS(SPRITE_TYPE_SPIKE, SPRITE_TYPE_SLIDE_R) = CHAR_COLLISION_PUSH_RIGHT
COLLISIONS(SPRITE_TYPE_SPIKE, SPRITE_TYPE_NEXT_LEVEL) = CHAR_COLLISION_DEATH

DIM SHARED DEAD_SPLAT$: DEAD_SPLAT$ = "_"

'--------------------------------------------------------------------------
' Keyboard input mappings
'--------------------------------------------------------------------------
IF DEBUG_ON THEN
    KEY(1) ON
    ON KEY(1) ToggleGravity
END IF

KEY(2) ON
ON KEY(2) ToggleSound


KEY(10) ON
ON KEY(10) ExitGame

'--------------------------------------------------------------------------
' Start Program Execution
'--------------------------------------------------------------------------
SetDisplayMode

WHILE GAME_STATE.nextLevel > 0 AND GAME_STATE.nextLevel < 10
    LoadLevelData
    RunMainGameLoop
WEND

SYSTEM

'--------------------------------------------------------------------------
' Keyboard input handlers
'--------------------------------------------------------------------------
SUB ToggleGravity
    GAME_STATE.gravity = GAME_STATE.gravity * -1
END SUB

SUB ExitGame
    SYSTEM
END SUB

SUB ToggleSound
    IF GAME_STATE.soundEnabled = 0 THEN GAME_STATE.soundEnabled = 1 ELSE GAME_STATE.soundEnabled = 0
END SUB

'--------------------------------------------------------------------------
' Run the main game loop for the currently loaded level. LoadLevelData
' must be called before this.
'
' @param gameLevel% Number of the game level to start.
'--------------------------------------------------------------------------
SUB RunMainGameLoop
    ' Keep running the game loop until the GAME_STATE.nextLevel changes from
    ' its original value. 0 indicates game over/quit
    WHILE GAME_STATE.nextLevel = GAME_STATE.loadedLevel
        ChangeSpritesToNextSpriteType
        RenderSprites
        RenderStatusLine
        _LIMIT GAME_STATE.frameRate
        CheckSpecialCollisions
        MoveSprites
    WEND
END SUB

SUB RenderStatusLine
    PrintAt SCREEN_AREA.max.row, 1, 15, GAME_STATE.levelTitle

    FOR p = 1 TO PLAYER_MAX
        COLOR PLAYER(p).spriteColor
        PRINT ": Lives =" + STR$(SPRITES(PLAYER(p).spriteIndex).lives) + "  Score =" + STR$(PLAYER(p).score);
    NEXT p

END SUB


'--------------------------------------------------------------------------
' Reads level data from a file in the .\DATA subfolder. Loads the level
' stored in the GAME_STATE.nextLevel and then updates the
' GAME_STATE.loadedLevel upon success.
'--------------------------------------------------------------------------
SUB LoadLevelData
    ' Open level data file
    file$ = ".\DATA\LEV_" + LTRIM$(STR$(GAME_STATE.nextLevel)) + ".DAT"
    OPEN file$ FOR INPUT AS #1

    ' First line has the title of the level to be returned
    INPUT #1, GAME_STATE.levelTitle
    DisplayLevelTitle GAME_STATE.levelTitle

    ' Read/render file data to the screen
    FOR row = GAME_AREA.min.row TO GAME_AREA.max.row
        INPUT #1, levelData$
        PrintAt row, 1, 7, levelData$
    NEXT row

    ' Close the file handle
    CLOSE #1

    '--- Update/reset variables storing level-specific data
    GAME_STATE.loadedLevel = GAME_STATE.nextLevel
    SPRITE_COUNT = 0
    PLAYER_MAX = 0
    ParseLevelData
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

    FOR row = 1 TO GAME_AREA.max.row
        FOR col = 1 TO GAME_AREA.max.col
            char$ = CharAt$(row, col)

            '--- Process chars that need to be changed
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
                CASE "", "T" '--- Torch [T]
                    COLOR CLR_YELLOW
                    char$ = ""
                CASE "S" '--- Solid color ground (untextured)
                    COLOR CLR_GRAY
                    char$ = "Û"
                CASE "O" '--- Enemy1 SPRITE
                    char$ = "•"
                CASE "F" '--- Fire SPRITE
                    char$ = "'"
                CASE ELSE
                    COLOR CLR_GRAY
            END SELECT

            spriteType = GetSpriteType(char$)
            IF spriteType THEN
                '--- Process Sprite chars
                AddSprite spriteType, row, col
            ELSE
                '--- Process chars that need to change
                '--- into chars that would conflict with Sprites
                '--- if processed before the sprite detection.
                SELECT CASE char$
                    CASE "P" '--- Pole [P]
                        COLOR CLR_YELLOW
                        char$ = "³" '--- Conflicts with Spike sprite
                END SELECT
            END IF

            LOCATE row, col: PRINT char$
        NEXT col
    NEXT row
END SUB

'--------------------------------------------------------------------------
' Returns the CHAR_COLLISION_{collision_type} constant that specifies
' the collision behavior for a Sprite as it moves onto another char.
'
' @param char$ Character to get the collision behavior for
' @return Returns one of the CHAR_COLLISION global constants.
'--------------------------------------------------------------------------
FUNCTION GetSpriteIndexAt (row, col)
    GetSpriteIndexAt = NULL_INDEX

    FOR index = 0 TO SPRITE_COUNT - 1
        IF SPRITES(index).position.row = row AND SPRITES(index).position.col = col THEN
            GetSpriteIndexAt = index
        END IF
    NEXT index
END FUNCTION


'--------------------------------------------------------------------------
' Iterates all Sprites in the SPRITES() array, decrements their
' nextSpriteTimer until it reaches 0, and then calls to change them
' to their next sprite type.  Ignored if nextSpriteType is empty/0.
'--------------------------------------------------------------------------
SUB ChangeSpritesToNextSpriteType
    FOR index = 0 TO SPRITE_COUNT - 1
        '--- Count nextSpriteTimer down if it is set
        IF SPRITES(index).nextSpriteTypeTimer > 0 THEN
            SPRITES(index).nextSpriteTypeTimer = SPRITES(index).nextSpriteTypeTimer - 1
        END IF

        IF SPRITES(index).nextSpriteType AND SPRITES(index).nextSpriteTypeTimer < 1 THEN
            SpriteChangeType index
        END IF
    NEXT index
END SUB

'--------------------------------------------------------------------------
' Changes a Sprite to the SPRITE_TYPE_{...} value specified in its
' .nextSpriteType property, and copies over the properties
' that are necessary for the new Sprite.
'
' @param index Sprite index of the Sprite to be changed
'--------------------------------------------------------------------------
SUB SpriteChangeType (index)
    DIM oldSprite AS Sprite
    DIM newSprite AS Sprite

    oldSprite = SPRITES(index)
    newSprite = SPRITE_TYPES(oldSprite.nextSpriteType)

    '--- Sprite type-specific changes here
    SELECT CASE newSprite.spriteType
        CASE SPRITE_TYPE_PLAYER, SPRITE_TYPE_PLAYER_SPIKEBALL, SPRITE_TYPE_PLAYER_DRAINED
            newSprite.lives = oldSprite.lives
            newSprite.gravityTimer = oldSprite.gravityTimer
            newSprite.playerIndex = oldSprite.playerIndex
            IF newSprite.spriteType = SPRITE_TYPE_PLAYER THEN
                newSprite.charColor = PLAYER(oldSprite.playerIndex).spriteColor
            END IF
    END SELECT

    '--- Changes that carry over for all types.
    newSprite.position = oldSprite.position
    newSprite.velocity = oldSprite.velocity
    newSprite.moveTo = oldSprite.moveTo

    SPRITES(index) = newSprite
END SUB


'--------------------------------------------------------------------------
' Process movement for all active sprites.
' Gets called by game loop once per frame.
'--------------------------------------------------------------------------
SUB MoveSprites
    GetKeyInput

    FOR index = 0 TO SPRITE_COUNT - 1
        '--- Only move sprite if it is alive and in a valid game area position
        IF SpriteIsActive(SPRITES(index)) THEN
            SpriteApplyGravity index

            '--- Apply automatic or player-controlled SPRITE_MOVE_{...} types
            SELECT CASE SPRITES(index).moveType
                CASE SPRITE_MOVE_LR_RANDOM_GROUND
                    SpriteMoveLRRandomGround index
                CASE SPRITE_MOVE_PLAYER_CONTROLLED
                    SpriteMovePlayerControlled index
            END SELECT

            '--- Store original position so we can tell if the Sprite moved
            originalRow = SPRITES(index).position.row
            originalCol = SPRITES(index).position.col

            '--- Move the Sprite using the new velocity values
            SpriteChangeMoveTarget index, originalRow + SPRITES(index).velocity.row, originalCol + SPRITES(index).velocity.col

            '--- If the sprite moved and did not leave a "dead splat" clear the spot it was in
            IF originalRow <> SPRITES(index).position.row OR originalCol <> SPRITES(index).position.col THEN
                IF SpriteIsActive(SPRITES(index)) AND CharAt$(originalRow, originalCol) <> DEAD_SPLAT$ THEN PrintAt originalRow, originalCol, 0, " "
            END IF
        END IF
    NEXT index
END SUB

'--------------------------------------------------------------------------
' Applies gravity to a Sprite based on the game state gravity and the
' Sprite's gravity combined.
'
' @param index Sprite index to apply gravity to.
'--------------------------------------------------------------------------
SUB SpriteApplyGravity (index)

    '---Player landing on solid ground/slides ends jump
    IF SPRITES(index).gravityTimer > 0 THEN
        IF SPRITES(index).moveType = SPRITE_MOVE_PLAYER_CONTROLLED THEN
            rowBelow = SPRITES(index).position.row + SGN(GAME_STATE.gravity)
            collisionBelow = GetCollisionType(index, GetSpriteIndexAt(rowBelow, SPRITES(index).position.col), CharAt$(rowBelow, SPRITES(index).position.col))
            IF collisionBelow = CHAR_COLLISION_SOLID OR collisionBelow = CHAR_COLLISION_PUSH_LEFT OR collisionBelow = CHAR_COLLISION_PUSH_RIGHT THEN
                SPRITES(index).gravityTimer = 0
            END IF
        END IF
    END IF

    '--- Apply gravity based on sprite settings
    IF SPRITES(index).gravityTimer = 0 THEN
        IF SPRITES(index).gravity THEN
            SpriteApplyFriction (index)
            totalGravity = SPRITES(index).gravity * GAME_STATE.gravity

            IF GAME_STATE.gravity > 0 THEN
                SPRITES(index).velocity.row = GetMin(SPRITES(index).velocity.row + totalGravity, totalGravity)
            ELSEIF GAME_STATE.gravity < 0 THEN
                SPRITES(index).velocity.row = GetMax(SPRITES(index).velocity.row + totalGravity, totalGravity)
            END IF
        END IF
    ELSE
        SPRITES(index).velocity.row = 0
        SPRITES(index).gravityTimer = SPRITES(index).gravityTimer - 1
    END IF
END SUB

'--------------------------------------------------------------------------
' Applies friction to a Sprite based on the Sprite's friction, and only
' if it has gravity and is on a solid.
'
' @param index Sprite index to apply friction to.
'--------------------------------------------------------------------------
SUB SpriteApplyFriction (index)
    IF SPRITES(index).friction THEN
        rowBelow = SPRITES(index).position.row + SGN(GAME_STATE.gravity)

        IF rowBelow >= GAME_AREA.min.row AND rowBelow <= GAME_AREA.max.col THEN
            onSolid = GetCollisionType(index, NULL_INDEX, CharAt$(rowBelow, SPRITES(index).position.col))
            IF ABS(SPRITES(index).velocity.col) > 0 AND onSolid THEN
                SPRITES(index).velocity.col = SPRITES(index).velocity.col - SPRITES(index).friction * SGN(SPRITES(index).velocity.col)
            END IF
        END IF
    END IF
END SUB

'--------------------------------------------------------------------------
' Apply automatic AI left/right velocity changes to a Sprite.  Avoids
' falling off ledges or moving into hazards, and otherwise moves in slow,
' random side-to-side increments. Used for Sprites having a moveType
' value of SPRITE_MOVE_LR_RANDOM_GROUND.
'
' @param index Sprite index to move.
'--------------------------------------------------------------------------
SUB SpriteMoveLRRandomGround (index)
    IF SPRITES(index).moveTimer < 1 THEN
        '--- Only move once every 1 to 20 game frames
        SPRITES(index).moveTimer = INT(RND * 20) + 1
        '--- Move randomly 1 left, 1 right, or stay put (1/3 chance of each)
        SPRITES(index).velocity.col = INT(RND * 3) - 1

        '--- Check for solid ground just below where the sprite should move.
        rowBelow = SPRITES(index).position.row + 1
        colBelow = SPRITES(index).position.col + SGN(SPRITES(index).velocity.col)

        '--- If it's not solid ground, cancel moving there
        collision = GetCollisionType(index, GetSpriteIndexAt(rowBelow, colBelow), CharAt$(rowBelow, colBelow))
        IF collision <> CHAR_COLLISION_SOLID AND collision <> CHAR_COLLISION_ENEMY_DEATH THEN
            SPRITES(index).velocity.col = 0
        END IF
    ELSE
        SPRITES(index).moveTimer = SPRITES(index).moveTimer - 1
    END IF
END SUB

'--------------------------------------------------------------------------
' Handle keyboard input from the player and apply actions to player
' controlled Sprites.
'
' @param spriteIndex SPRITES() array index of the player-controlled Sprite.
'--------------------------------------------------------------------------
SUB SpriteMovePlayerControlled (spriteIndex)
    DIM player AS Player
    player = PLAYER(SPRITES(spriteIndex).playerIndex)

    '--- Process all characters in the INKEY$ buffer by looping/reading each

    FOR k = 0 TO KEY_INPUT_MAX
        '--- Player-specific key presses
        SELECT CASE UCASE$(KEY_INPUT(k))
            CASE player.keyRight
                SPRITES(spriteIndex).velocity.col = 1
            CASE player.keyLeft
                SPRITES(spriteIndex).velocity.col = -1
            CASE player.keyJump
                rowBelow = SPRITES(spriteIndex).position.row + SGN(GAME_STATE.gravity)
                colBelow = SPRITES(spriteIndex).position.col
                collisionBelow = GetCollisionType(spriteIndex, GetSpriteIndexAt(rowBelow, colBelow), CharAt$(rowBelow, colBelow))

                IF collisionBelow = CHAR_COLLISION_SOLID OR collisionBelow = CHAR_COLLISION_PUSH_LEFT OR collisionBelow = CHAR_COLLISION_PUSH_RIGHT THEN
                    SPRITES(spriteIndex).velocity.row = SPRITES(index).gravity * GAME_STATE.gravity * -1
                    SPRITES(spriteIndex).gravityTimer = 16
                END IF
            CASE player.keySpikeball
                IF SPRITES(spriteIndex).spriteType <> SPRITE_TYPE_PLAYER_DRAINED THEN
                    SPRITES(spriteIndex).nextSpriteType = SPRITE_TYPE_PLAYER_SPIKEBALL
                    SPRITES(spriteIndex).nextSpriteTypeTimer = 0
                    SPRITES(spriteIndex).velocity.col = 0
                END IF
            CASE CHR$(27) '--- Escape
                GAME_STATE.nextLevel = 0
            CASE ELSE
                SPRITES(spriteIndex).velocity.col = 0
        END SELECT
    NEXT k
END SUB

'--------------------------------------------------------------------------
' Main function for moving a Sprite's position during a frame.
' Use this to initiate collision-safe moves to a Sprite:
'
' * Handles keeping the requested position within the GAME_AREA bounds.
' * Sets the .moveTo property to the bounded requested position.
' * Calls for handling all collisions along the way.
'
' @param spriteIndex Index of the Sprite to move.
' @param row Game area row to attempt to move the sprite to.
' @param col Game area col to attempt to move the sprite to.
'--------------------------------------------------------------------------
SUB SpriteChangeMoveTarget (spriteIndex, row, col)
    '--- Limit the move target to be withing the game area bounds
    SPRITES(spriteIndex).moveTo.row = GetMax(GAME_AREA.min.row, GetMin(GAME_AREA.max.row, row))
    SPRITES(spriteIndex).moveTo.col = GetMax(GAME_AREA.min.col, GetMin(GAME_AREA.max.col, col))

    '--- Move toward the new target
    SpriteMoveTowardTarget spriteIndex
END SUB

'--------------------------------------------------------------------------
' Moves the sprite 1 unit toward its .moveTo property coordinates,
' and calls for collision handling. This ensures that all collisions
' along the movement path will be handled by moving in a straight line,
' on unit at a time.
'
' @param spriteIndex Index of the Sprite to move.
'--------------------------------------------------------------------------
SUB SpriteMoveTowardTarget (spriteIndex)
    DIM sprite AS Sprite
    sprite = SPRITES(spriteIndex)

    '--- Get the distance (in character units) to the target row/col
    rowsRemaining = sprite.moveTo.row - sprite.position.row
    colsRemaining = sprite.moveTo.col - sprite.position.col
    stepsRemaining = GetMax(ABS(rowsRemaining), ABS(colsRemaining))

    '--- Only continue if the move target is not yet reached
    IF stepsRemaining > 0 THEN
        '--- Move one unit toward the target row/col in a straight line
        newRow = sprite.position.row + CINT(rowsRemaining / stepsRemaining)
        newCol = sprite.position.col + CINT(colsRemaining / stepsRemaining)

        CheckCollision spriteIndex, newRow, newCol
    END IF
END SUB

'--------------------------------------------------------------------------
' Gets the CHAR_COLLISION_{...} constant for a collision between a
' specified Sprite and an optional target Sprite and/or character.
'
' @param spriteIndex Index of the Sprite to compare as the source sprite.
' @param targetSpriteIndex Index of the Sprite to as the destination sprite.
'                          Can be set to NULL_INDEX to skip sprite collision checking
' @param targetChar$ Single character to compare as the collision destination.
' @return CHAR_COLLISION_{...} constant indicating the collision type.
'--------------------------------------------------------------------------
FUNCTION GetCollisionType (spriteIndex, targetSpriteIndex, targetChar$)
    '--- Get type of collision at the target row/col
    IF targetSpriteIndex <> NULL_INDEX THEN
        GetCollisionType = COLLISIONS(SPRITES(spriteIndex).spriteType, SPRITES(targetSpriteIndex).spriteType)
    ELSE
        SELECT CASE targetChar$
            CASE " ", DEAD_SPLAT$
                GetCollisionType = CHAR_COLLISION_NONE
            CASE ELSE
                GetCollisionType = CHAR_COLLISION_SOLID
        END SELECT
    END IF
END FUNCTION

'--------------------------------------------------------------------------
' Checks a Sprite for collisions at a specified position, and applies
' the appropriate collision result (e.g. blocking, death, next level, etc).
' Typically called by the SpriteMoveTowardTarget and not directly.
'
' IMPORTANT: THE row/col PARAMS MUST NOT BE MORE THAN 1 UNIT AWAY FROM
'            THE Sprite's .position property!
'
' @param spriteIndex Index of the Sprite to check for collisions.
' @param row Destination row to check for collisions.
' @param col Destination col to check for collisions.
'--------------------------------------------------------------------------
SUB CheckCollision (spriteIndex, row, col)
    DIM sprite AS Sprite
    sprite = SPRITES(spriteIndex)

    DIM targetSprite AS Sprite
    targetSpriteIndex = GetSpriteIndexAt(row, col)
    IF targetSpriteIndex <> NULL_INDEX THEN targetSprite = SPRITES(targetSpriteIndex)

    collisionType = GetCollisionType(spriteIndex, targetSpriteIndex, CharAt$(row, col))

    '--- Handling for all collision types
    SELECT CASE collisionType
        CASE CHAR_COLLISION_NONE
            SpriteAllowMove spriteIndex, row, col
        CASE CHAR_COLLISION_SOLID
            SpriteBlockMove spriteIndex, row, col
        CASE CHAR_COLLISION_DEATH
            SpriteDeath spriteIndex
        CASE CHAR_COLLISION_ENEMY_DEATH
            SpriteDeath targetSpriteIndex
            SpriteAllowMove spriteIndex, row, col
        CASE CHAR_COLLISION_EXTRA_LIFE
            IF targetSprite.spriteType = SPRITE_TYPE_EXTRA_LIFE THEN
                SpriteDeath targetSpriteIndex
                SpriteExtraLife spriteIndex
            END IF
            IF sprite.spriteType = SPRITE_TYPE_EXTRA_LIFE THEN
                SpriteDeath spriteIndex
                SpriteExtraLife targetSpriteIndex
            ELSE
                SpriteAllowMove spriteIndex, row, col
            END IF
        CASE CHAR_COLLISION_NEXT_LEVEL
            GAME_STATE.nextLevel = GAME_STATE.nextLevel + 1
            SpriteAllowMove spriteIndex, row, col
        CASE CHAR_COLLISION_PUSH_LEFT
            SpriteChangeMoveTarget spriteIndex, row, col - 1
        CASE CHAR_COLLISION_PUSH_RIGHT
            SpriteChangeMoveTarget spriteIndex, row, col + 1
        CASE CHAR_COLLISION_VERTICAL_DEATH
            IF sprite.position.row <> row THEN
                SpriteDeath spriteIndex
            ELSE
                SpriteBlockMove spriteIndex, row, col
            END IF
        CASE CHAR_COLLISION_VERTICAL_ENEMY_DEATH
            IF sprite.position.row <> row THEN
                SpriteDeath targetSpriteIndex
                SpriteAllowMove spriteIndex, row, col
            ELSE
                SpriteBlockMove spriteIndex, row, col
            END IF
        CASE ELSE
            SpriteBlockMove spriteIndex, row, col
    END SELECT
END SUB

'--------------------------------------------------------------------------
' Similar to CheckCollision but handles non-movement cases such as the
' Spikeball that attacks the spaces to its sides.  Add any special collision
' cases here where the Sprites are not technically touching but collision
' rules should be applied.
'--------------------------------------------------------------------------
SUB CheckSpecialCollisions
    FOR index = 0 TO SPRITE_COUNT - 1
        DIM sprite AS Sprite: sprite = SPRITES(index)

        SELECT CASE sprite.spriteType
            CASE SPRITE_TYPE_PLAYER_SPIKEBALL
                '--- Spikeball attacks directly to left/right, check for collisions on both
                FOR colOffset = -1 TO 1 STEP 2
                    targetIndex = GetSpriteIndexAt(sprite.position.row, sprite.position.col + colOffset)

                    '--- If a sprite is found and a spikeball collision kills it, then kill it
                    IF targetIndex <> NULL_INDEX THEN
                        IF COLLISIONS(sprite.spriteType, SPRITES(targetIndex).spriteType) = CHAR_COLLISION_ENEMY_DEATH THEN
                            SpriteDeath targetIndex
                        END IF
                    END IF
                NEXT colOffset
        END SELECT

    NEXT index
END SUB

'--------------------------------------------------------------------------
' Apply an allowable move to a Sprite's' .position property.
' Typically called by SUB CheckCollision after collision handling,
' and not directly.
'
' @param spriteIndex Index of the Sprite to move.
' @param row New row position to apply to the Sprite.
' @param col New col position to apply to the Sprite.
'--------------------------------------------------------------------------
SUB SpriteAllowMove (spriteIndex, row, col)
    SPRITES(spriteIndex).position.row = row
    SPRITES(spriteIndex).position.col = col
    SpriteMoveTowardTarget spriteIndex
END SUB

'--------------------------------------------------------------------------
' Block a move to a Sprite's position at a requested position.
' Typically called by SUB CheckCollision after collision handling.
'
' * Changes the requested move to an appropriate alternative position.
' * Alters the Sprite .velocity property based on the nature of the block.
' * Retries an alternative move based on the angle/velocity/surroundings.
'
' @param spriteIndex Index of the moving Sprite to block.
' @param row Blocked row the sprite is trying to move to.
' @param col Blocked col the sprite is trying to move to.
'--------------------------------------------------------------------------
SUB SpriteBlockMove (spriteIndex, row, col)
    DIM sprite AS Sprite: sprite = SPRITES(spriteIndex)

    IF sprite.position.row <> row AND sprite.position.col <> col THEN
        '--- Blocked on an angle. First try a quick check on either side for empty spaces.
        IF CharAt$(sprite.position.row, col) = " " THEN emptyHorizontal = 1 ELSE emptyHorizontal = 0
        IF CharAt$(row, sprite.position.col) = " " THEN emptyVertical = 1 ELSE emptyVertical = 0

        '--- Since the angle is blocked, try the best horizontal or vertical move.
        IF emptyVertical AND emptyHorizontal = 0 THEN
            SpriteChangeMoveTarget spriteIndex, row, sprite.position.col '--- Only vertical move is empty, go there
        ELSEIF emptyHorizontal AND emptyVertical = 0 THEN
            SpriteChangeMoveTarget spriteIndex, sprite.position.row, col '--- Only horizontal move is empty, go there
        ELSEIF ABS(sprite.velocity.row) > ABS(sprite.velocity.col) THEN
            SpriteChangeMoveTarget spriteIndex, row, sprite.position.col '--- Stronger vertical velocity, move vertical
        ELSEIF ABS(sprite.velocity.col) > ABS(sprite.velocity.row) THEN
            SpriteChangeMoveTarget spriteIndex, sprite.position.row, col '--- Stronger horizontal velocity, move horizontal
        ELSE
            '--- Perfect 45 degree angle and equal horizontal/vertical velocity
            '--- Try a vertical move first.
            SpriteChangeMoveTarget spriteIndex, row, sprite.position.col
            newRow = SPRITES(spriteIndex).position.row
            newCol = SPRITES(spriteIndex).position.col

            '--- If the vertical move didn't change anything, try a horizontal move.
            IF newRow = sprite.position.row AND newCol = sprite.position.col THEN
                SpriteChangeMoveTarget spriteIndex, sprite.position.row, col
            END IF
        END IF
    ELSEIF sprite.position.row <> row THEN
        sprite.velocity.row = 0 '--- Vertical block. Stop vertical velocity and further movement.
        SpriteChangeMoveTarget spriteIndex, sprite.position.row, sprite.position.col
    ELSEIF sprite.position.col <> col THEN
        sprite.velocity.col = 0 '--- Horizontal block. Stop horizontal velocity and further movement.
        SpriteChangeMoveTarget spriteIndex, sprite.position.row, sprite.position.col
    END IF
END SUB

'--------------------------------------------------------------------------
' Adds a life to a sprite and processes any other sprite-specific
' extra life behaviors.
'
' @param spriteIndex Index of the Sprite to move.
'--------------------------------------------------------------------------
SUB SpriteExtraLife (spriteIndex)
    SPRITES(spriteIndex).lives = SPRITES(spriteIndex).lives + 1

    SELECT CASE SPRITES(spriteIndex).spriteType
        CASE SPRITE_TYPE_PLAYER, SPRITE_TYPE_PLAYER_SPIKEBALL, SPRITE_TYPE_PLAYER_DRAINED
            IF GAME_STATE.soundEnabled = 1 THEN PLAY "MF T200 O1 L64 CDEFGAB>CDEFGAB>C"
    END SELECT
END SUB

'--------------------------------------------------------------------------
' Deducts 1 life from the sprite and disables it if dead. Defines
' replacement chars and colors for dead sprites. Called after death
' collision detections.
'
' @param spriteIndex Index of the Sprite that should lose a life.
'--------------------------------------------------------------------------
SUB SpriteDeath (spriteIndex)
    SPRITES(spriteIndex).lives = SPRITES(spriteIndex).lives - 1
    DIM sprite AS Sprite: sprite = SPRITES(spriteIndex)

    replacementChar$ = " " '--- Default replacement char (empty space)
    replacementColor = CLR_BLACK '--- Default replacement color

    SELECT CASE sprite.spriteType
        CASE SPRITE_TYPE_PLAYER, SPRITE_TYPE_PLAYER_SPIKEBALL, SPRITE_TYPE_PLAYER_DRAINED
            '--- Move the Sprite back to the player's original starting position
            playerIndex = sprite.playerIndex
            SPRITES(spriteIndex).position.row = PLAYER(playerIndex).startRow
            SPRITES(spriteIndex).position.col = PLAYER(playerIndex).startCol
            SPRITES(spriteIndex).moveTo.row = PLAYER(playerIndex).startRow
            SPRITES(spriteIndex).moveTo.col = PLAYER(playerIndex).startCol
            SPRITES(spriteIndex).velocity.row = 0
            SPRITES(spriteIndex).velocity.col = 0

            '--- Replace the template's .lives value with the deducted value
            IF GAME_STATE.soundEnabled THEN SOUND 57, 10
            IF SPRITES(spriteIndex).lives < 1 THEN GAME_STATE.nextLevel = 0

            '--- Leave a splat the same color as the player was
            PrintAt sprite.position.row, sprite.position.col, sprite.charColor, DEAD_SPLAT$
        CASE SPRITE_TYPE_ENEMY1
            '--- Show a red splat for dead Enemy1 sprites
            IF GAME_STATE.soundEnabled THEN SOUND 80, 2
            replacementColor = CLR_GREEN
            replacementChar$ = DEAD_SPLAT$
            PLAYER(PLAYER_MAX).score = PLAYER(PLAYER_MAX).score + 50
        CASE SPRITE_TYPE_EXTRA_LIFE
            PLAYER(PLAYER_MAX).score = PLAYER(PLAYER_MAX).score + 200
    END SELECT

    '--- Disable the Sprite if it is out of lives
    IF SPRITES(spriteIndex).lives < 1 THEN SpriteDisable spriteIndex, replacementChar$, replacementColor
END SUB

'--------------------------------------------------------------------------
' Disables a sprite to remove it from rendering, movement, and collision
' tests. Sets position, moveTo, and velocity to empty values and optionally
' prints a replacement character where the spite was located.
'
' @param spriteIndex Index of the Sprite to disable.
' @param replacementChar$ Char to print where the sprite was located
' @param replacementColor CLR_{...} constant of the color to use for the replacementChar$.
'--------------------------------------------------------------------------
SUB SpriteDisable (spriteIndex, replacementChar$, replacementColor)
    PrintAt SPRITES(spriteIndex).position.row, SPRITES(spriteIndex).position.col, replacementColor, replacementChar$
    SPRITES(spriteIndex).position.row = 0
    SPRITES(spriteIndex).position.col = 0
    SPRITES(spriteIndex).moveTo.row = 0
    SPRITES(spriteIndex).moveTo.col = 0
    SPRITES(spriteIndex).velocity.row = 0
    SPRITES(spriteIndex).velocity.col = 0
END SUB

'--------------------------------------------------------------------------
' Render all active sprites to the screen and update their animation frames.
'--------------------------------------------------------------------------
SUB RenderSprites
    DIM sprite AS Sprite

    FOR index = 0 TO SPRITE_COUNT - 1
        sprite = SPRITES(index)

        '--- Only render on-screen sprites.
        IF SpriteIsActive(sprite) THEN
            '--- Only animate sprite if framerate is above 0
            IF SPRITES(index).frameRate THEN
                SPRITES(index).frameRateTimer = (SPRITES(index).frameRateTimer + 1) MOD SPRITES(index).frameRate

                '--- Animate next frame when frameRateTimer cycles to 0
                IF SPRITES(index).frameRateTimer = 0 THEN
                    SPRITES(index).frame = SPRITES(index).frame + 1
                    IF SPRITES(index).frame > SPRITES(index).maxFrame THEN SPRITES(index).frame = 1
                END IF
            END IF

            SPRITES(index).charColor = AnimateSpriteColor(sprite)
            RenderSprite sprite
        END IF
    NEXT index
END SUB

'--------------------------------------------------------------------------
' Draws a Sprite on the screen at its stored position using the Sprite's
' current animation frame and color.
'
' @param sprite Sprite to be rendered on the screen.
'--------------------------------------------------------------------------
SUB RenderSprite (sprite AS Sprite)
    PrintAt sprite.position.row, sprite.position.col, sprite.charColor, MID$(sprite.frames, sprite.frame, 1)
END SUB

'--------------------------------------------------------------------------
' Tests if a sprite has lives remaining and is not off-screen. Use before
' calling any sprite rendering, moving, or collision testing.
'
' @param sprite Sprite to test. 1 = active, 0 = inactive/disabled
'--------------------------------------------------------------------------
FUNCTION SpriteIsActive (sprite AS Sprite)
    IF sprite.lives > 0 AND sprite.position.row > 0 AND sprite.position.col > 0 THEN
        SpriteIsActive = 1
    ELSE
        SpriteIsActive = 0
    END IF
END FUNCTION

'--------------------------------------------------------------------------
' Returns the next charColor property value for a Sprite to be rendered
' based on its spriteType property.
'
' @param sprite Sprite being animated.
' @return New value to be assigned to the sprite's charColor.
'--------------------------------------------------------------------------
FUNCTION AnimateSpriteColor (sprite AS Sprite)
    SELECT CASE sprite.spriteType
        CASE SPRITE_TYPE_PLAYER_SPIKEBALL
            IF sprite.charColor = CLR_LT_WHITE THEN
                AnimateSpriteColor = CLR_LT_RED
            ELSE
                AnimateSpriteColor = CLR_LT_WHITE
            END IF
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
' Initializes a new sprite into the global SPRITES array and increments
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
    SPRITES(SPRITE_COUNT).position.row = row%
    SPRITES(SPRITE_COUNT).position.col = col%

    '--- Default to 1 life if none specified
    IF template.lives = 0 THEN SPRITES(SPRITE_COUNT).lives = 1

    '--- Register the SPRITES() index value of player sprites so we know which ones they are.
    IF spriteType% = SPRITE_TYPE_PLAYER THEN
        PLAYER_MAX = PLAYER_MAX + 1
        PLAYER(PLAYER_MAX).spriteIndex = SPRITE_COUNT
        PLAYER(PLAYER_MAX).startRow = row%
        PLAYER(PLAYER_MAX).startCol = col%
        SPRITES(SPRITE_COUNT).playerIndex = PLAYER_MAX
        SPRITES(SPRITE_COUNT).charColor = PLAYER(PLAYER_MAX).spriteColor
    END IF

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
        FOR spriteType = 1 TO SPRITE_TYPES_MAX
            IF INSTR(SPRITE_TYPES(spriteType).frames, char$) THEN
                GetSpriteType = spriteType
                EXIT FOR
            END IF
        NEXT spriteType
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

FUNCTION GetMax (valueA, valueB)
    IF (valueA > valueB) THEN GetMax = valueA ELSE GetMax = valueB
END FUNCTION

FUNCTION GetMin (valueA, valueB)
    IF (valueA < valueB) THEN GetMin = valueA ELSE GetMin = valueB
END FUNCTION


'--------------------------------------------------------------------------
' Clears the screen, displays a message, and terminates the program.
' Use when outputting debugging information when troubleshooting.
'
' @param msg$ Debugging output to display on-screen
'--------------------------------------------------------------------------
SUB Debug (msg$)
    IF DEBUG_ON THEN
        PrintAt SCREEN_AREA.max.row - 1, 1, 10, msg$
    END IF
END SUB

'--------------------------------------------------------------------------
' Displays all the properties of a Sprite on-screen and pauses.
' Useful when debugging Sprite values.
'
' @param sprite Sprite data to display.
'--------------------------------------------------------------------------
SUB DebugSprite (sprite AS Sprite)
    IF DEBUG_ON THEN
        LOCATE 1, 1
        COLOR 7, 0
        PRINT "spriteType: " + STR$(sprite.spriteType)
        PRINT "moveType: " + STR$(sprite.moveType)
        PRINT "frames: " + sprite.frames
        PRINT "frame: " + STR$(sprite.frame)
        PRINT "maxFrame: " + STR$(sprite.maxFrame)
        PRINT "frameRate: " + STR$(sprite.frameRate)
        PRINT "frameRateTimer: " + STR$(sprite.frameRateTimer)
        PRINT "charColor: " + STR$(sprite.charColor)
        PRINT "gravity: " + STR$(sprite.gravity)
        PRINT "gravityTimer: " + STR$(sprite.gravityTimer)
        PRINT "position.row: " + STR$(sprite.position.row)
        PRINT "position.col: " + STR$(sprite.position.col)
        PRINT "velocity.row: " + STR$(sprite.velocity.row)
        PRINT "velocity.col: " + STR$(sprite.velocity.col)
        PRINT "moveTo.row: " + STR$(sprite.moveTo.row)
        PRINT "moveTo.col: " + STR$(sprite.moveTo.col)
        PRINT "moveTimer: " + STR$(sprite.moveTimer)
        PRINT "lives: " + STR$(sprite.lives)
        Pause
        SYSTEM
    END IF
END SUB

'--------------------------------------------------------------------------
' Displays all the coordinate properties of a Sprite on-screen.
' Useful when debugging Sprite values. This was needed because the
' VWatch debugger can't handle nested user-defined TYPEs like Coord.
'
' @param spriteIndex Index of the Sprite in the SPRITES() array to display.
'--------------------------------------------------------------------------
SUB DebugSpriteCoords (spriteIndex, msg$)
    IF DEBUG_ON THEN
        DIM sprite AS Sprite
        sprite = SPRITES(spriteIndex)

        LOCATE SCREEN_AREA.max.row - 1, 1
        PRINT msg$;
        PRINT " i:" + STR$(spriteIndex);
        PRINT " p.r:" + STR$(sprite.position.row);
        PRINT " p.c:" + STR$(sprite.position.col);
        PRINT " m.r:" + STR$(sprite.moveTo.row);
        PRINT " m.c:" + STR$(sprite.moveTo.col);
        PRINT " v.r:" + STR$(sprite.velocity.row);
        PRINT " v.c:" + STR$(sprite.velocity.col);
        PRINT " ";
    END IF
END SUB

SUB GetKeyInput
    KEY_INPUT_MAX = 0
    nextChar$ = INKEY$

    WHILE nextChar$ <> ""
        KEY_INPUT_MAX = KEY_INPUT_MAX + 1 '--- Note: KEY_INPUT(0) should stay empty, skip it when looping
        KEY_INPUT(KEY_INPUT_MAX) = nextChar$
        nextChar$ = INKEY$
    WEND
END SUB
