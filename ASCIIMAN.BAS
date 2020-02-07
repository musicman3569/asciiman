DEFINT A-Z

TYPE Coord
    row AS INTEGER
    col AS INTEGER
END TYPE

TYPE Rectangle
    min AS Coord
    max AS Coord
END TYPE

'--------------------------------------------------------------------------
' The KeyMap TYPE stores keyboard/controller button mappings for each player.
'--------------------------------------------------------------------------
TYPE KeyMap
    playerIndex AS INTEGER '--- Index of the PLAYER() the KeyMap is bound to.
    deviceIndex AS INTEGER '--- Device number the KeyMap is bound to.
    inputType AS INTEGER '--- One of the INPUT_TYPE_{...} values.  Defines the input type on the input device (e.g. button/axis)
    inputAction AS STRING '--- One of the INPUT_ACTION_{...} values. Determines the action the input triggers.
    inputIndex AS SINGLE '--- Button/axis index on the device
    axisMin AS SINGLE '--- Minimum value the axis must return to trigger action.
    axisMax AS SINGLE '--- Maximum value the axis must return to trigger action.
    value AS SINGLE '--- Current raw value of the input. Used to determine if the inputAction should be triggered.
    inputName AS STRING '--- On-screen display name of the input.
    needsRelease AS INTEGER '--- 1 = Require a release event before the action can be triggered again, 0 = action may be triggered
END TYPE

'--- Initialize global key map array that will store all button mappings
DIM SHARED KEY_MAP(1 TO 64) AS KeyMap
DIM SHARED KEY_MAPS: KEY_MAPS = 0 '--- Increments as key mappings are added to track the max KEY_MAP index to use

'--------------------------------------------------------------------------
' Input Types are used to identify the what type of input a KeyMap is for.
' This allows different methods to be called for checking/handling the values
' since different inputs have different ranges.
'--------------------------------------------------------------------------
DIM SHARED INPUT_TYPE_UNASSIGNED: INPUT_TYPE_UNASSIGNED = 0
DIM SHARED INPUT_TYPE_BUTTON: INPUT_TYPE_BUTTON = 1
DIM SHARED INPUT_TYPE_AXIS: INPUT_TYPE_AXIS = 2
DIM SHARED INPUT_TYPE_WHEEL: INPUT_TYPE_WHEEL = 3

'--------------------------------------------------------------------------
' Input Actions are used to indicate what action a KeyMap should perform
' on the Player's sprite when it is triggering an event.
'--------------------------------------------------------------------------
DIM SHARED INPUT_ACTION_NONE AS STRING: INPUT_ACTION_NONE = ""
DIM SHARED INPUT_ACTION_LEFT AS STRING: INPUT_ACTION_LEFT = "Move Left"
DIM SHARED INPUT_ACTION_RIGHT AS STRING: INPUT_ACTION_RIGHT = "Move Right"
DIM SHARED INPUT_ACTION_JUMP AS STRING: INPUT_ACTION_JUMP = "Jump"
DIM SHARED INPUT_ACTION_SPIKEBALL AS STRING: INPUT_ACTION_SPIKEBALL = "Spikeball Attack"

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
    playerCount AS INTEGER '--- Number of active players to load into the level
END TYPE

'--- Initialize global game state
DIM SHARED GAME_STATE AS GameState
GAME_STATE.soundEnabled = 1
GAME_STATE.loadedLevel = 0
GAME_STATE.nextLevel = 1
GAME_STATE.gravity = 1
GAME_STATE.frameRate = 18
GAME_STATE.playerCount = 0

'--------------------------------------------------------------------------
' Debugging variables for tracking information, changing values has no functional impact.
'--------------------------------------------------------------------------
DIM SHARED DEBUG_ON: DEBUG_ON = 0 '--- 1 = Display messages from as Debug...() SUBs, 0 = Hide messages
DIM SHARED DEBUG_SPRITE_INDEX: DEBUG_SPRITE_INDEX = NULL_INDEX '--- For tracking sprite index values
DIM SHARED DEBUG_CALLER AS STRING: DEBUG_CALLER = "NONE" '--- For tracking calling SUBs (stack tracing)

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
    maxJumpDistance AS INTEGER '--- Max number of cols a player can jump
    jumpDistance AS INTEGER '--- Stores the remaining number of jump cols during jumps
    deviceIndex AS INTEGER '--- Input device index number for the player's controller (or other input device)
END TYPE

DIM SHARED PLAYER(1 TO 4) AS Player '--- Stores the index values of the player sprites in the SPRITES() array.
DIM SHARED PLAYER_MAX: PLAYER_MAX = 0 '--- Number of active players in the game

PLAYER(1).spriteColor = CLR_YELLOW
PLAYER(1).maxJumpDistance = 9

PLAYER(2).spriteColor = CLR_LT_BLUE
PLAYER(2).maxJumpDistance = 9

PLAYER(3).spriteColor = CLR_LT_CYAN
PLAYER(3).maxJumpDistance = 9

PLAYER(4).spriteColor = CLR_LT_MAGENTA
PLAYER(4).maxJumpDistance = 9

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
    playerPoints AS INTEGER '--- Number of points to award a player if on death of this sprite
    collisionBelow AS INTEGER '--- Stores the CHAR_COLLISION_{...} type between the sprite and the char gravitationally below it. Needed for several checks, so this improves performance by caching it.
    spriteBelowIndex AS INTEGER '--- Index of the sprite gravitationally below this sprite, or NULL_INDEX for none.
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
SPRITE_TYPES(SPRITE_TYPE_PLAYER).frames = ""
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
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).frames = "•ў"
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).maxFrame = 2
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).frameRate = 5
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).charColor = CLR_GREEN
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).gravity = 1
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).gravityTimer = 0
SPRITE_TYPES(SPRITE_TYPE_ENEMY1).playerPoints = 50
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
SPRITE_TYPES(SPRITE_TYPE_EXTRA_LIFE).playerPoints = 200
'--- Spike Sprite template
SPRITE_TYPES(SPRITE_TYPE_SPIKE).spriteType = SPRITE_TYPE_SPIKE
SPRITE_TYPES(SPRITE_TYPE_SPIKE).moveType = SPRITE_MOVE_NONE
SPRITE_TYPES(SPRITE_TYPE_SPIKE).frames = "і"
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
SPRITE_TYPES(SPRITE_TYPE_NEXT_LEVEL).playerPoints = 100

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

KEY 15, CHR$(0) + CHR$(1)
ON KEY(15) ExitGame
KEY(15) ON



'--------------------------------------------------------------------------
' Start Program Execution
'--------------------------------------------------------------------------
SetDisplayMode
IntroVid
WaitForPlayersToJoin

WHILE GAME_STATE.nextLevel > 0 AND GAME_STATE.nextLevel < 10
    LoadLevelData
    RunMainGameLoop

    IF GAME_STATE.nextLevel = 0 THEN
        DeadVid
        GAME_STATE.nextLevel = 1
    END IF
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
' Displays a waiting screen where players press a button on their input
' device to join the game. As players join, the input device and key
' mappings for the player's controls are displayed.
'
' After all players have joined, a continuation key is pressed to continue.
'--------------------------------------------------------------------------
SUB WaitForPlayersToJoin
    CLS
    PrintAt 2, 1, 10, "Waiting for players...Press any button to join."
    PrintAt 3, 1, 10, "Press Esc to quit."
    COLOR

    _KEYCLEAR
    ClearInkey

    '--- Wait for player input until Esc is pressed and there is at least 1 player
    DO
        FOR deviceIndex = 1 TO _DEVICES
            '--- Check if the device has any input events
            IF _DEVICEINPUT(deviceIndex) THEN
                deviceName$ = _DEVICE$(deviceIndex)

                '--- Detect Button presses on any devices with buttons
                IF INSTR(deviceName$, "[BUTTON]") > 0 AND INSTR(deviceName$, "[MOUSE]") = 0 THEN
                    FOR btnIndex = 1 TO _LASTBUTTON(deviceIndex)
                        '--- Detect any button other than SpaceBar (btnIndex 2) as a player joining
                        IF _BUTTONCHANGE(btnIndex) = -1 AND btnIndex <> 58 THEN
                            IF GAME_STATE.playerCount = 0 THEN PrintAt 3, 1, 10, "Press Space to start, or Esc to quit.": PRINT: PRINT
                            SetPlayerInputs deviceIndex
                        END IF
                    NEXT btnIndex
                END IF
            END IF
        NEXT deviceIndex
    LOOP UNTIL INKEY$ = " " AND GAME_STATE.playerCount > 0
END SUB

'--------------------------------------------------------------------------
' Add a new KeyMap to the KEY_MAP array and increment the KEY_MAPS counter.
'
' @param playerIndex Index of the PLAYER() the KeyMap is bound to.
' @param deviceIndex Device number the KeyMap is bound to.
' @param inputAction$ One of the INPUT_ACTION_{...} values. Determines the action the input triggers.
' @param inputType One of the INPUT_TYPE_{...} values.  Defines the input type on the input device (e.g. button/axis)
' @param inputIndex Button/axis index on the device
' @param axisMin! Minimum value the axis must return to trigger action.
' @param axisMax! Maximum value the axis must return to trigger action.
' @param inputName$ On-screen display name of the input.
'--------------------------------------------------------------------------
SUB AddKeyMap (playerIndex, deviceIndex, inputAction$, inputType, inputIndex, axisMin!, axisMax!, inputName$)
    KEY_MAPS = KEY_MAPS + 1
    KEY_MAP(KEY_MAPS).playerIndex = playerIndex
    KEY_MAP(KEY_MAPS).deviceIndex = deviceIndex
    KEY_MAP(KEY_MAPS).inputAction = inputAction$
    KEY_MAP(KEY_MAPS).inputType = inputType
    KEY_MAP(KEY_MAPS).inputIndex = inputIndex
    KEY_MAP(KEY_MAPS).axisMax = axisMax!
    KEY_MAP(KEY_MAPS).axisMin = axisMin!
    KEY_MAP(KEY_MAPS).inputName = inputName$
END SUB

'--------------------------------------------------------------------------
' Adds a new player and their input device and automatically configures
' the control mappings based on the type of device detected.  Renders
' the final mappings on-screen. Also prevents the deviceIndex from being
' mapped to more than one player at a time by performing no action if the
' deviceIndex is already in use.
'
' @param deviceIndex Device number (see _DEVICEINPUT) to map to the
'--------------------------------------------------------------------------
SUB SetPlayerInputs (deviceIndex)
    '--- Don't assign controller if it is already assigned to another player
    FOR p = 1 TO GAME_STATE.playerCount
        IF PLAYER(p).deviceIndex = deviceIndex THEN EXIT SUB
    NEXT p

    '--- The controller is available, add a new player
    GAME_STATE.playerCount = GAME_STATE.playerCount + 1
    playerIndex = GAME_STATE.playerCount
    PLAYER(playerIndex).deviceIndex = deviceIndex

    '--- Keep track of the starting KeyMap index so all new KeyMaps
    '--- can be displayed after all the buttons/axis are mapped.
    startingKeyMap = KEY_MAPS + 1
    deviceName$ = GetDeviceName$(deviceIndex)

    '--- Auto-configure the input device button mappings by the detected device name
    SELECT CASE deviceName$
        CASE "Controller (XBOX 360 For Windows)", "Controller (Xbox One For Windows)"
            AddKeyMap playerIndex, deviceIndex, INPUT_ACTION_LEFT, INPUT_TYPE_AXIS, 1, -1, -0.7, "Joystick Left"
            AddKeyMap playerIndex, deviceIndex, INPUT_ACTION_RIGHT, INPUT_TYPE_AXIS, 1, 0.7, 1, "Joystick Right"
            AddKeyMap playerIndex, deviceIndex, INPUT_ACTION_JUMP, INPUT_TYPE_BUTTON, 1, -1, -1, "A Button"
            AddKeyMap playerIndex, deviceIndex, INPUT_ACTION_SPIKEBALL, INPUT_TYPE_BUTTON, 3, -1, -1, "X Button"
        CASE "USB Gamepad "
            AddKeyMap playerIndex, deviceIndex, INPUT_ACTION_LEFT, INPUT_TYPE_AXIS, 1, -1, -0.7, "D-Pad Left"
            AddKeyMap playerIndex, deviceIndex, INPUT_ACTION_RIGHT, INPUT_TYPE_AXIS, 1, 0.7, 1, "D-Pad Right"
            AddKeyMap playerIndex, deviceIndex, INPUT_ACTION_JUMP, INPUT_TYPE_BUTTON, 3, -1, -1, "B Button"
            AddKeyMap playerIndex, deviceIndex, INPUT_ACTION_SPIKEBALL, INPUT_TYPE_BUTTON, 1, -1, -1, "Y Button"
        CASE "KEYBOARD"
            AddKeyMap playerIndex, deviceIndex, INPUT_ACTION_LEFT, INPUT_TYPE_BUTTON, 332, -1, -1, "Left Arrow Key"
            AddKeyMap playerIndex, deviceIndex, INPUT_ACTION_RIGHT, INPUT_TYPE_BUTTON, 334, -1, -1, "Right Arrow Key"
            AddKeyMap playerIndex, deviceIndex, INPUT_ACTION_JUMP, INPUT_TYPE_BUTTON, 329, -1, -1, "Up Arrow Key"
            AddKeyMap playerIndex, deviceIndex, INPUT_ACTION_SPIKEBALL, INPUT_TYPE_BUTTON, 337, -1, -1, "Down Arrow Key"
    END SELECT

    '--- Display the newly added player and key mappings
    COLOR PLAYER(playerIndex).spriteColor
    PRINT " PLAYER"; STR$(playerIndex); ": "; deviceName$; " #"; LTRIM$(STR$(deviceIndex))
    FOR k = startingKeyMap TO KEY_MAPS
        PRINT KEY_MAP(k).inputAction; ": "; KEY_MAP(k).inputName
    NEXT k
    PRINT
END SUB

'--------------------------------------------------------------------------
' Extracts the user-friendly display name of an input device. See _DEVICE$()
' for details on the source string from which this extracts the name.
'
' @param deviceIndex Device number from _DEVICEINPUT to return the name for.
'--------------------------------------------------------------------------
FUNCTION GetDeviceName$ (deviceIndex)
    GetDeviceName$ = _DEVICE$(deviceIndex)
    GetDeviceName$ = Replace$(GetDeviceName$, "[CONTROLLER]", "")
    GetDeviceName$ = Replace$(GetDeviceName$, "[NAME]", "")
    GetDeviceName$ = Replace$(GetDeviceName$, "[BUTTON]", "")
    GetDeviceName$ = Replace$(GetDeviceName$, "[AXIS]", "")
    GetDeviceName$ = Replace$(GetDeviceName$, "[", "")
    GetDeviceName$ = Replace$(GetDeviceName$, "]", "")
END FUNCTION

'--------------------------------------------------------------------------
' Run the main game loop for the currently loaded level. LoadLevelData
' must be called before this.
'
' @param gameLevel% Number of the game level to start.
'--------------------------------------------------------------------------
SUB RunMainGameLoop
    ClearInkey

    ' Keep running the game loop until the GAME_STATE.nextLevel changes from
    ' its original value. 0 indicates game over/quit
    WHILE GAME_STATE.nextLevel = GAME_STATE.loadedLevel
        ChangeSpritesToNextSpriteType
        RenderSprites
        RenderStatusLine
        _LIMIT GAME_STATE.frameRate
        CheckSpecialCollisions
        GetKeyInput
        MoveSprites
    WEND
END SUB

'--------------------------------------------------------------------------
' Prints the status line at the bottom of the screen. Displays the
' level title, and each player's remaining lives and scores.
'--------------------------------------------------------------------------
SUB RenderStatusLine
    PrintAt SCREEN_AREA.max.row, 73, 7, "Esc=Quit"
    PrintAt SCREEN_AREA.max.row, 1, 15, GAME_STATE.levelTitle

    FOR p = 1 TO PLAYER_MAX
        COLOR PLAYER(p).spriteColor
        PRINT "  ="; LTRIM$(STR$(SPRITES(PLAYER(p).spriteIndex).lives)) + " $"; LTRIM$(STR$(PLAYER(p).score));
    NEXT p

END SUB


'--------------------------------------------------------------------------
' Reads level data from a file in the .\DATA subfolder. Loads the level
' stored in the GAME_STATE.nextLevel and then updates the
' GAME_STATE.loadedLevel upon success.
'--------------------------------------------------------------------------
SUB LoadLevelData
    '--- Open level data file
    file$ = ".\DATA\LEV_" + LTRIM$(STR$(GAME_STATE.nextLevel)) + ".DAT"
    OPEN file$ FOR INPUT AS #1

    '--- First line has the title of the level to be returned
    INPUT #1, GAME_STATE.levelTitle
    DisplayLevelTitle GAME_STATE.levelTitle

    '--- Read/render file data to the screen
    FOR row = GAME_AREA.min.row TO GAME_AREA.max.row
        INPUT #1, levelData$
        PrintAt row, 1, 7, levelData$
    NEXT row

    '--- Close the file handle
    CLOSE #1

    '--- Update/reset variables storing level-specific data
    GAME_STATE.loadedLevel = GAME_STATE.nextLevel
    SPRITE_COUNT = 0
    PLAYER_MAX = 0

    '--- Clear all player key inputs from requiring key releases
    FOR k = 1 TO KEY_MAPS
        KEY_MAP(k).needsRelease = 0
    NEXT k

    '--- Clear any previous player movement values
    FOR p = 1 TO GAME_STATE.playerCount
        spriteIndex = PLAYER(p).spriteIndex
        SPRITES(spriteIndex).velocity.row = 0
        SPRITES(spriteIndex).velocity.col = 0
    NEXT p

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
    _DELAY 3
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
    groundTexture$(0) = "Ы"
    groundTexture$(1) = "±"
    groundTexture$(2) = "І"

    FOR row = 1 TO GAME_AREA.max.row
        FOR col = 1 TO GAME_AREA.max.col
            char$ = CharAt$(row, col)

            '--- Process chars that need to be changed
            SELECT CASE char$
                CASE "Ы" '--- Solid ground (random texture)
                    COLOR CLR_GRAY
                    char$ = groundTexture$(INT(RND * 3))
                CASE "±"
                    COLOR CLR_CYAN
                CASE "І"
                    COLOR CLR_LT_BLUE
                CASE "Я"
                    COLOR CLR_GRAY
                CASE "", "T" '--- Torch [T]
                    COLOR CLR_YELLOW
                    char$ = ""
                CASE "S" '--- Solid color ground (untextured)
                    COLOR CLR_GRAY
                    char$ = "Ы"
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
                        char$ = "і" '--- Conflicts with Spike sprite
                END SELECT
            END IF

            LOCATE row, col: PRINT char$
        NEXT col
    NEXT row
END SUB

'--------------------------------------------------------------------------
' Returns the index of the SPRITES() array element at a specified
' row and column, or NULL_INDEX for none.
'
' @param row Game area row to check for sprites.
' @param col Game area col to check for sprites.
' @return Returns an index for referencing the SPRITES() array, of the sprite at the specified row/col.
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
    FOR index = 0 TO SPRITE_COUNT - 1
        '--- Only move sprite if it is alive and in a valid game area position
        IF SpriteIsActive(SPRITES(index)) THEN
            SpriteUpdateCollisionBelow index
            SpriteApplyGravity index

            '--- Apply automatic or player-controlled SPRITE_MOVE_{...} types
            SELECT CASE SPRITES(index).moveType
                CASE SPRITE_MOVE_LR_RANDOM_GROUND
                    SpriteMoveLRRandomGround index
                CASE SPRITE_MOVE_PLAYER_CONTROLLED
                    SpriteMovePlayerControlled index
            END SELECT

            '--- Move the Sprite using the new velocity values
            SpriteChangeMoveTarget index, SPRITES(index).position.row + SPRITES(index).velocity.row, SPRITES(index).position.col + SPRITES(index).velocity.col
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
    rowBelow = SPRITES(index).position.row + SGN(GAME_STATE.gravity)
    spriteBelowIndex = SPRITES(index).spriteBelowIndex
    collisionBelow = SPRITES(index).collisionBelow

    '---Player landing on solid ground/slides ends jump
    IF SPRITES(index).playerIndex AND SPRITES(index).gravityTimer > 0 THEN
        IF collisionBelow = CHAR_COLLISION_SOLID OR collisionBelow = CHAR_COLLISION_PUSH_LEFT OR collisionBelow = CHAR_COLLISION_PUSH_RIGHT THEN
            '--- End jump if NOT jumping over another player
            IF spriteBelowIndex = NULL_INDEX THEN
                SPRITES(index).gravityTimer = 0
            ELSEIF SPRITES(spriteBelowIndex).playerIndex < 1 THEN
                SPRITES(index).gravityTimer = 0
            END IF
        END IF
    END IF

    '--- Apply gravity based on sprite settings
    IF SPRITES(index).gravityTimer = 0 THEN
        IF SPRITES(index).gravity THEN

            '--- Apply friction from ground when there is gravity
            IF rowBelow >= GAME_AREA.min.row AND rowBelow <= GAME_AREA.max.col THEN
                '--- Only check friction if it is a non-zero value
                IF SPRITES(index).friction THEN
                    '--- Apply friction if it is not a "frictionless" push collision
                    IF collisionBelow <> CHAR_COLLISION_PUSH_LEFT AND collisionBelow <> CHAR_COLLISION_PUSH_RIGHT THEN
                        SPRITES(index).velocity.col = SPRITES(index).velocity.col - SPRITES(index).friction * SGN(SPRITES(index).velocity.col)
                    END IF
                END IF
            END IF

            '--- Only apply gravity when not on a solid surface/object
            IF collisionBelow <> CHAR_COLLISION_SOLID THEN
                totalGravity = SPRITES(index).gravity * GAME_STATE.gravity

                IF GAME_STATE.gravity > 0 THEN
                    SPRITES(index).velocity.row = GetMin(SPRITES(index).velocity.row + totalGravity, totalGravity)
                ELSEIF GAME_STATE.gravity < 0 THEN
                    SPRITES(index).velocity.row = GetMax(SPRITES(index).velocity.row + totalGravity, totalGravity)
                END IF
            END IF
        END IF
    ELSE
        SPRITES(index).gravityTimer = SPRITES(index).gravityTimer - 1
    END IF
END SUB

'--------------------------------------------------------------------------
' Updates the collisionBelow property of a Sprite.  Several movement and
' collision checks need to check what type of collision is gravitationally
' under a Sprite, so this caches the result so it doesn't have to be
' recomputed each time.  Currently gets called by SpriteApplyGravity and
' SpriteAllowMove.
'
' @param index SPRITES() array index of the sprite to update.
'--------------------------------------------------------------------------
SUB SpriteUpdateCollisionBelow (index)
    rowBelow = SPRITES(index).position.row + SGN(GAME_STATE.gravity)
    SPRITES(index).spriteBelowIndex = GetSpriteIndexAt(rowBelow, SPRITES(index).position.col)
    SPRITES(index).collisionBelow = GetCollisionType(index, SPRITES(index).spriteBelowIndex, CharAt$(rowBelow, SPRITES(index).position.col))
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

        '--- If it's not solid ground or an attack on the player, cancel moving there
        collisionBelow = GetCollisionType(index, GetSpriteIndexAt(rowBelow, colBelow), CharAt$(rowBelow, colBelow))
        IF collisionBelow <> CHAR_COLLISION_SOLID AND collisionBelow <> CHAR_COLLISION_ENEMY_DEATH THEN
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
    DIM keyMap AS KeyMap
    DIM player AS Player

    SPRITES(spriteIndex).velocity.col = 0

    FOR k = 1 TO KEY_MAPS
        keyMap = KEY_MAP(k)
        playerIndex = keyMap.playerIndex
        player = PLAYER(playerIndex)

        IF spriteIndex = player.spriteIndex THEN
            IF CheckKeyInput(keyMap) THEN
                SELECT CASE keyMap.inputAction
                    CASE INPUT_ACTION_LEFT
                        IF SPRITES(spriteIndex).moveTimer = 0 THEN
                            SPRITES(spriteIndex).moveTimer = 2
                            SPRITES(spriteIndex).velocity.col = -1
                        END IF
                    CASE INPUT_ACTION_RIGHT
                        IF SPRITES(spriteIndex).moveTimer = 0 THEN
                            SPRITES(spriteIndex).moveTimer = 2
                            SPRITES(spriteIndex).velocity.col = 1
                        END IF
                    CASE INPUT_ACTION_JUMP
                        '--- Check what is gravitationally below the player
                        collisionBelow = SPRITES(spriteIndex).collisionBelow

                        '--- Only jump when on solid ground or slides
                        IF collisionBelow = CHAR_COLLISION_SOLID OR collisionBelow = CHAR_COLLISION_PUSH_LEFT OR collisionBelow = CHAR_COLLISION_PUSH_RIGHT THEN
                            '--- Require jump key to be released before jumping again
                            KeyMapSetNeedsRelease 1, playerIndex, INPUT_ACTION_JUMP
                            PLAYER(playerIndex).jumpDistance = player.maxJumpDistance

                            jumpDirection = SGN(GAME_STATE.gravity) * -1
                            SpriteChangeMoveTarget spriteIndex, SPRITES(spriteIndex).position.row + jumpDirection, SPRITES(spriteIndex).position.col
                            SPRITES(spriteIndex).gravityTimer = 16
                        END IF
                    CASE INPUT_ACTION_SPIKEBALL
                        IF SPRITES(spriteIndex).spriteType <> SPRITE_TYPE_PLAYER_DRAINED THEN
                            KeyMapSetNeedsRelease 1, playerIndex, INPUT_ACTION_SPIKEBALL '--- Must release key before attacking again

                            SPRITES(spriteIndex).nextSpriteType = SPRITE_TYPE_PLAYER_SPIKEBALL
                            SPRITES(spriteIndex).nextSpriteTypeTimer = 0
                            SPRITES(spriteIndex).velocity.col = 0
                        END IF
                END SELECT
            END IF
        END IF
    NEXT k

    IF SPRITES(spriteIndex).moveTimer > 0 THEN
        SPRITES(spriteIndex).moveTimer = SPRITES(spriteIndex).moveTimer - 1
    END IF
END SUB

'--------------------------------------------------------------------------
' Require or unrequire an input to be released (meaning it falls out of
' range for active input) before further input events will be treated as active.
' Used for inputs where you don't want the player to hold the button/axis and
' have the action happen continuously until they release the button/axis first.
'
' @param needRelease 1=Require input to be released, 0=Remove release requirement
' @param playerIndex PLAYER() array Player instance whose input is being modified
' @param inputAction$ INPUT_ACTION_{...} type for which the button release requirement will be applied.
'--------------------------------------------------------------------------
SUB KeyMapSetNeedsRelease (needsRelease, playerIndex, inputAction$)
    FOR k = 1 TO KEY_MAPS
        IF KEY_MAP(k).playerIndex = playerIndex AND KEY_MAP(k).inputAction = inputAction$ THEN
            KEY_MAP(k).needsRelease = needsRelease
        END IF
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
    '--- Store original position so we can tell if the Sprite moved
    originalRow = SPRITES(spriteIndex).position.row
    originalCol = SPRITES(spriteIndex).position.col

    '--- Limit the move target to be withing the game area bounds
    SPRITES(spriteIndex).moveTo.row = GetMax(GAME_AREA.min.row, GetMin(GAME_AREA.max.row, row))
    SPRITES(spriteIndex).moveTo.col = GetMax(GAME_AREA.min.col, GetMin(GAME_AREA.max.col, col))

    '--- Move toward the new target
    SpriteMoveTowardTarget spriteIndex

    '--- If the sprite moved and did not leave a "dead splat" clear the spot it was in
    IF originalRow <> SPRITES(spriteIndex).position.row OR originalCol <> SPRITES(spriteIndex).position.col THEN
        IF SpriteIsActive(SPRITES(spriteIndex)) AND CharAt$(originalRow, originalCol) <> DEAD_SPLAT$ THEN PrintAt originalRow, originalCol, 0, " "
    END IF
END SUB

'--------------------------------------------------------------------------
' Moves the sprite 1 unit toward its .moveTo property coordinates,
' and calls for collision handling. This ensures that all collisions
' along the movement path will be handled by moving in a straight line,
' one unit at a time.
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
            SpriteDeath spriteIndex, targetSpriteIndex
        CASE CHAR_COLLISION_ENEMY_DEATH
            SpriteDeath targetSpriteIndex, spriteIndex
            SpriteAllowMove spriteIndex, row, col
        CASE CHAR_COLLISION_EXTRA_LIFE
            IF targetSprite.spriteType = SPRITE_TYPE_EXTRA_LIFE THEN
                SpriteDeath targetSpriteIndex, spriteIndex
                SpriteExtraLife spriteIndex
            END IF
            IF sprite.spriteType = SPRITE_TYPE_EXTRA_LIFE THEN
                SpriteDeath spriteIndex, targetSpriteIndex
                SpriteExtraLife targetSpriteIndex
            ELSE
                SpriteAllowMove spriteIndex, row, col
            END IF
        CASE CHAR_COLLISION_NEXT_LEVEL
            GAME_STATE.nextLevel = GAME_STATE.nextLevel + 1
            SpriteDeath targetSpriteIndex, spriteIndex
            SpriteAllowMove spriteIndex, row, col
        CASE CHAR_COLLISION_PUSH_LEFT
            SPRITES(spriteIndex).velocity.col = -1
            SpriteChangeMoveTarget spriteIndex, row, col - 1
        CASE CHAR_COLLISION_PUSH_RIGHT
            SPRITES(spriteIndex).velocity.col = 1
            SpriteChangeMoveTarget spriteIndex, row, col + 1
        CASE CHAR_COLLISION_VERTICAL_DEATH
            IF sprite.position.row <> row THEN
                SpriteDeath spriteIndex, targetSpriteIndex
            ELSE
                SpriteBlockMove spriteIndex, row, col
            END IF
        CASE CHAR_COLLISION_VERTICAL_ENEMY_DEATH
            IF sprite.position.row <> row THEN
                SpriteDeath targetSpriteIndex, spriteIndex
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
                            SpriteDeath targetIndex, index
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

    SpriteUpdateCollisionBelow spriteIndex

    '--- Check if this is a player sprite
    IF SPRITES(spriteIndex).playerIndex THEN
        playerIndex = SPRITES(spriteIndex).playerIndex

        '--- Check if the player is currently jumping
        IF SPRITES(spriteIndex).gravityTimer > 0 THEN

            '--- Reduce the remaining jump distance allowed
            PLAYER(playerIndex).jumpDistance = PLAYER(playerIndex).jumpDistance - 1

            '--- End the jump if the jump distance runs out
            IF PLAYER(playerIndex).jumpDistance = 0 THEN SPRITES(spriteIndex).gravityTimer = 0
        END IF
    END IF

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
        IF GetCollisionType(spriteIndex, NULL_INDEX, CharAt$(sprite.position.row, col)) = CHAR_COLLISION_NONE THEN emptyHorizontal = 1 ELSE emptyHorizontal = 0
        IF GetCollisionType(spriteIndex, NULL_INDEX, CharAt$(row, sprite.position.col)) = CHAR_COLLISION_NONE THEN emptyVertical = 1 ELSE emptyVertical = 0

        '--- Since the angle is blocked, try the best horizontal or vertical move.
        IF emptyVertical AND emptyHorizontal = 0 THEN
            SPRITES(spriteIndex).velocity.col = 0
            SpriteChangeMoveTarget spriteIndex, row, sprite.position.col '--- Only vertical move is empty, go there
        ELSEIF emptyHorizontal AND emptyVertical = 0 THEN
            SPRITES(spriteIndex).velocity.row = 0
            SpriteChangeMoveTarget spriteIndex, sprite.position.row, col '--- Only horizontal move is empty, go there
        ELSEIF ABS(sprite.velocity.row) > ABS(sprite.velocity.col) THEN
            SPRITES(spriteIndex).velocity.col = 0
            SpriteChangeMoveTarget spriteIndex, row, sprite.position.col '--- Stronger vertical velocity, move vertical
        ELSEIF ABS(sprite.velocity.col) > ABS(sprite.velocity.row) THEN
            SPRITES(spriteIndex).velocity.row = 0
            SpriteChangeMoveTarget spriteIndex, sprite.position.row, col '--- Stronger horizontal velocity, move horizontal
        ELSE
            SPRITES(spriteIndex).velocity.col = 0 '--- Perfect 45-degree collision, favor vertical movement (gravity)
            SpriteChangeMoveTarget spriteIndex, sprite.position.row, sprite.position.col
        END IF
    ELSEIF sprite.position.row <> row THEN
        SPRITES(spriteIndex).velocity.row = 0 '--- Vertical block. Stop vertical velocity and further movement.
        SpriteChangeMoveTarget spriteIndex, sprite.position.row, sprite.position.col
    ELSEIF sprite.position.col <> col THEN
        SPRITES(spriteIndex).velocity.col = 0 '--- Horizontal block. Stop horizontal velocity and further movement.
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
SUB SpriteDeath (spriteIndex, causedByIndex)
    SPRITES(spriteIndex).lives = SPRITES(spriteIndex).lives - 1
    DIM sprite AS Sprite: sprite = SPRITES(spriteIndex)
    DIM causedBySprite AS Sprite: causedBySprite = SPRITES(causedByIndex)

    replacementChar$ = " " '--- Default replacement char (empty space)
    replacementColor = CLR_BLACK '--- Default replacement color

    '--- Award player points if they caused the death of this sprite
    IF causedBySprite.playerIndex THEN
        PLAYER(causedBySprite.playerIndex).score = PLAYER(causedBySprite.playerIndex).score + sprite.playerPoints
    END IF

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
        SPRITE_COUNT = SPRITE_COUNT + 1

        '--- Recursively add player sprites until all players are added
        IF (PLAYER_MAX < GAME_STATE.playerCount) THEN
            AddSprite SPRITE_TYPE_PLAYER, row%, col%
        END IF
    ELSE
        '--- Update sprite count so we know how many there are
        SPRITE_COUNT = SPRITE_COUNT + 1
    END IF
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

'--------------------------------------------------------------------------
' Plays the dumb little intro video when the game starts.  Can be bypassed
' by pressing a key on the keyboard.
'--------------------------------------------------------------------------
SUB IntroVid
    CLS
    m$ = "ASCII-MAN  "
    ClearInkey

    '--- Animate the letters dropping 1 at a time into the title
    FOR col = 1 TO LEN(m$)
        char$ = RIGHT$(LEFT$(m$, col), 1)
        FOR row = 1 TO 14
            IF char$ <> "" THEN COLOR 10 ELSE COLOR 14
            IF row > 1 THEN LOCATE row - 1, col + 30: PRINT " ";
            LOCATE row, col + 30: PRINT char$;
            _LIMIT 50
            IF INKEY$ <> "" THEN EXIT SUB
        NEXT row
    NEXT col

    '--- Animate drawing the horizontal bars
    COLOR 9
    FOR col = 1 TO 80
        LOCATE 20, col: PRINT "Д";
        _LIMIT 180
        IF INKEY$ <> "" THEN EXIT SUB
    NEXT col
    FOR col = 1 TO 80
        LOCATE 10, col: PRINT "Д";
        _LIMIT 180
        IF INKEY$ <> "" THEN EXIT SUB
    NEXT col

    '--- Animate ASCIIMAN running to the right
    COLOR 14
    FOR col = 42 TO 80
        LOCATE 14, col - 1: PRINT " ";
        LOCATE 14, col: PRINT "";
        _LIMIT 30
        IF INKEY$ <> "" THEN EXIT SUB
    NEXT col
    LOCATE 14, 80: PRINT " ";

    '--- Animate the random char/color distortion blob at the top
    FOR i = 1 TO 270
        r = INT(RND * 6) + 1
        c = INT(RND * 9) + 35
        COLOR (INT(RND * 15) + 1)
        LOCATE r, c: PRINT CHR$(INT(RND * 200) + 50);
        _LIMIT 180
        IF INKEY$ <> "" THEN EXIT SUB
    NEXT i

    '--- Make a giant ASCIIMAN appear where the distortion blob was
    COLOR 14
    LOCATE 1, 35: PRINT "  ЬЫЫЫЬ  ";
    LOCATE 2, 35: PRINT "ЬЫЫюЫюЫЫЬ";
    LOCATE 3, 35: PRINT "ЫЫЫЫЫЫЫЫЫ";
    LOCATE 4, 35: PRINT "ЫЫ ЯЯЯ ЫЫ";
    LOCATE 5, 35: PRINT "ЯЫЫ   ЫЫЯ";
    LOCATE 6, 35: PRINT "  ЯЫЫЫЯ  ";

    COLOR 15
    LOCATE 28, 30: PRINT "Press Any Key To Begin";
    Pause
END SUB

SUB DeadVid
    CLS
    COLOR CLR_LT_RED
    m$ = "Game Over"
    FOR col = 1 TO LEN(m$)
        char$ = RIGHT$(LEFT$(m$, col), 1)
        FOR row = 1 TO 14
            IF row > 1 THEN LOCATE row - 1, col + 30: PRINT " ";
            LOCATE row, col + 30: PRINT char$;
            _LIMIT 50
        NEXT row
    NEXT col

    Pause
END SUB


'==========================================================================
'                     GENERIC UTILITY FUNCTIONS
'==========================================================================

'--------------------------------------------------------------------------
' Clear the keyboard input buffer.
'--------------------------------------------------------------------------
SUB ClearInkey
    WHILE INKEY$ <> "": WEND
    WHILE _DEVICEINPUT: WEND
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
' Replaces all instances of the [Find] sub-string with the [Add] sub-string
' within the [Text] string.
'
' @param Text The input string; the text that's being manipulated.
' @param Find The specified sub-string; the string sought within the [Text] string.
' @param Add The sub-string that's being added to the [Text] string.
'--------------------------------------------------------------------------
FUNCTION Replace$ (Text AS STRING, Find AS STRING, Add AS STRING)
    DIM lngLocation AS LONG 'The address of the [Find] substring within the [Text] string.
    DIM strBefore AS STRING 'The characters before the string to be replaced.
    DIM strAfter AS STRING 'The characters after the string to be replaced.

    '--- INITIALIZE:
    lngLocation = INSTR(1, Text, Find)

    '--- PROCESSING:
    '--- While [Find] appears in [Text]...
    WHILE lngLocation
        'Extract all text before the [Find] substring:
        strBefore = LEFT$(Text, lngLocation - 1)
        'Extract all text after the [Find] substring:
        strAfter = RIGHT$(Text, ((LEN(Text) - (lngLocation + LEN(Find) - 1))))
        'Return the substring:
        Text = strBefore + Add + strAfter
        'Locate the next instance of [Find]:
        lngLocation = INSTR(1, Text, Find)
        'Next instance of [Find]...
    WEND

    '--- OUTPUT:
    Replace$ = Text
END FUNCTION

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
' Checks to see if a KeyMap's value indicates it is currently being pressed
' and hasn't been set to require release before receiving input again.
' To require a key to be released, call SUB KeyMapSetNeedsRelease
' anywhere in the game loop.
'
' @param keyMap KeyMap instance to check for input events.
'--------------------------------------------------------------------------
FUNCTION CheckKeyInput (keyMap AS KeyMap)
    CheckKeyInput = 0

    IF keyMap.needsRelease = 0 THEN
        IF keyMap.value >= keyMap.axisMin AND keyMap.value <= keyMap.axisMax THEN
            CheckKeyInput = 1
        END IF
    END IF
END FUNCTION

'--------------------------------------------------------------------------
' Reads input events from keyboards and game controllers and updates
' the values in the KEY_MAP array with the results.
'
' NOTE: Instead of checking KeyMap values directly for button/axis
' input events, use the FUNCTION CheckKeyInput(keyMap)
' which also verifies a key release is not required first.
'--------------------------------------------------------------------------
SUB GetKeyInput
    '--- Check for the first device with an input event
    deviceIndex = _DEVICEINPUT

    WHILE deviceIndex
        '--- Check all buttons on the device for events
        FOR b = 1 TO _LASTBUTTON(deviceIndex)
            buttonChange! = _BUTTONCHANGE(b)
            IF buttonChange! <> 0 THEN
                SetKeyInput deviceIndex, INPUT_TYPE_BUTTON, b, buttonChange!
            END IF
        NEXT

        '--- Update all axis on the device with the current readings
        FOR a = 1 TO _LASTAXIS(deviceIndex)
            SetKeyInput deviceIndex, INPUT_TYPE_AXIS, a, _AXIS(a)
        NEXT

        '--- Get the next device with an input event
        deviceIndex = _DEVICEINPUT
    WEND
END SUB

'--------------------------------------------------------------------------
' Updates the KEY_MAP array with a new value, and clears the needsRelease
' field if the new value indicates the input event has stopped. Should be
' called when new input events are detected.
'
' @param deviceIndex Device number read from _DEVICEINPUT that has the new value.
' @param inputType One of INPUT_TYPE_{...} constants that the new value is for.
' @param inputIndex Button or Axis index on the device that the new value is for.
' @param value! New KeyMap input value to store.
'--------------------------------------------------------------------------
SUB SetKeyInput (deviceIndex, inputType, inputIndex, value!)
    '--- Check each player's inputs for events
    FOR k = 1 TO KEY_MAPS
        IF KEY_MAP(k).deviceIndex = deviceIndex AND KEY_MAP(k).inputType = inputType AND KEY_MAP(k).inputIndex = inputIndex THEN
            KEY_MAP(k).value = value!

            '--- Clear the "need release" setting when the input value falls out of range
            IF KEY_MAP(k).needsRelease THEN
                IF KEY_MAP(k).value < KEY_MAP(k).axisMin OR KEY_MAP(k).value > KEY_MAP(k).axisMax THEN
                    KEY_MAP(k).needsRelease = 0
                END IF
            END IF
        END IF
    NEXT k
END SUB

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
