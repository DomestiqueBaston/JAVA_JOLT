extends Node2D

# MANIPULATING OBJECTS
#
# If the user can take an object, add the HAND cursor action when the object is
# made current in _update_current_prop(). Then, in _perform_hand_action(), add
# the object to the inventory if it is the current prop. If the object is to be
# hidden from sight when it has been taken (the small towel, for example), or
# if its visual aspect changes (e.g. to hide one milk bottle or the coffee
# maker's filter holder), the object must be handled by set_object_visible() in
# the BACKGROUND scene (or a subscene, if the object is inside something). That
# method will show/hide the object as appropriate, and perhaps enable/disable
# its collider so it cannot be taken if it is hidden.

## For debugging: don't display any dialogues.
@export var skip_dialogues: bool = false

## For debugging: if set to 1, 2, 3 or 4, the game starts with that chapter and
## its associated dialogue. If set to 0, you will want to call either [method
## start] or [method load_game] to get the game started.
@export_range(0,4) var auto_start_chapter: int = 1

## Radio volume presets in dB. These must be in ascending order.
@export var volume_presets: Array[float] = [-80, -30, -20, -15, -10, -5, 0]

## Time in seconds when Rowena is ready to dig the old coffee out of the trash.
@export var scavenging_time: float = 900

## How long the phone rings before Rowena answers it.
@export var phone_ring_time: float = 2.5

## Signal emitted when the player quits the game. If this node is parented
## directly to the root of the scene tree, no signal is emitted: the node quits
## immediately.
signal quit

## Signal emitted when Rowena leaves the kitchen. The game is over.
signal game_over

# Current chapter of the story.
var current_chapter: int = 1

# Has the dialogue for the current chapter been seen?
var is_dialogue_seen: bool = false

# When end_game() is called, the game may not be terminated immediately...
enum { GAME_IN_PROGRESS, END_GAME_REQUESTED, GAME_ENDING }
var game_over_status: int = GAME_IN_PROGRESS

# true if we are doing something that cannot be interrupted by end game.
var im_busy: int = 0

# The prop currently under the mouse cursor (see Globals.Prop), or -1.
var current_prop: int = -1

# Which props the user has looked at.
var props_seen: Array = []

# Dictionary containing all the background object colliders that are currently
# in contact with the mouse cursor. Keys are prop numbers (see Globals.prop);
# values are Area2D instances.
var overlapping_colliders: Dictionary = {}

const prop_info: Array[String] = [
	# KITCHEN_CABINET
	"That's a cabinet...",
	# RECYCLING_CLOSET
	"That's the recycling.",
	# UNDER_SINK_CABINET
	"Oh my god! What's in there?",
	# CLEANING_CLOSET
	"That's where I put my cleaning stuff.",
	# DRAWER_LEFT_1
	"My useful junk drawer!",
	# DRAWER_LEFT_2
	"That drawer is empty.",
	# DRAWER_LEFT_3
	"That drawer is empty.",
	# PRIVATE_DRAWER
	"That's my private drawer...",
	# KITCHEN_TOOLS_DRAWER
	"That's where I put useless stuff, like my garlic press.",
	# CUTLERY_DRAWER
	"Nice cutlery drawer, isn't it?",
	# OVEN
	"That's my oven...",
	# OVEN_BOTTOM
	"That's full of burnt pizza remains.",
	# DISHWASHER
	"That's my dishwasher...",
	# STOOL
	"That's a stool.",
	# CHAIR
	"That's a chair.",
	# TOWEL_LARGE
	"That's a big dirty towel.",
	# TOWEL_SMALL
	"That's a little towel.",
	# TOP_LEFT_UNUSED_CUPBOARD
	"There's nothing interesting in there.",
	# LEFT_GLASS_CUPBOARD
	"It's magic! I can see through the door!",
	# TOP_CENTER_UNUSED_CUPBOARD
	"There's nothing interesting in there.",
	# RIGHT_GLASS_CUPBOARD
	"It's magic! I can see what's in there!",
	# CUPBOARD_UPPER_CENTER_LEFT
	"That's a cupboard...",
	# CUPBOARD_UPPER_CENTER
	"I wonder what's in there...",
	# COFFEE_CUPBOARD
	"That's my coffee cupboard. :'(",
	# UPPER_RIGHT_CUPBOARD
	"There's big stuff in there.",
	# MICROWAVE
	"The microwave works. If I turn it on...",
	# WINDOW_RIGHT
	"That's a big window.",
	# WINDOW_LEFT
	"I know what that is: it's a window!",
	# SPOILED_MILK
	"That's a bottle of sour milk.",
	# COFFEE_MAKER
	"That's my coffee maker, FWIW.",
	# RADIO
	"That's the radio. How clever, I can turn it up or down...",
	# REFRIGERATOR_RIGHT
	"That's my refrigerator...",
	# REFRIGERATOR_LEFT
	"That's my freezer.",
	# REFRIGERATOR_LEFT_WATER_ICE
	"That dispenses cold water and ice. How cool is that?",
	# PAINTING
	"That's a painting.",
	# LIGHT_SWITCH_LEFT
	"That's a light switch.",
	# LIGHT_SWITCH_RIGHT
	"That's a light switch.",
	# YUCCA
	"That's a yucca plant.",
	# OLIVE_OIL_BOTTLE
	"That's a bottle of olive oil.",
	# SALT
	"That's salt.",
	# TOASTER
	"That's my toaster.",
	# NOTCHED_COFFEE_CUP_RIGHT
	"That coffee cup is chipped.",
	# PEPPER
	"That's pepper.",
	# RICE_POT
	"There is raw rice in there.",
	# COOKIE_POT
	"There are cookies in there.",
	# TAP
	"That's the faucet.",
	# PLASTIC_BOXES
	"That's tupperware.",
	# MANDOLIN
	"That's my miracle vegetable slicer, as seen on TV.",
	# FOOD_PROCESSOR
	"That's my food processor.",
	# RED_COFFEE_CUP_LEFT
	"That's an empty, red coffee cup.",
	# BROWN_COFFEE_CUP
	"That's a dirty coffee cup.",
	# KNIFE_BLOCK
	"Those are kitchen knives.",
	# FRUIT_BASKET
	"That's a fruit basket.",
	# CUTTING_BOARD
	"That's a cutting board.",
	# PRESSURE_COOKER
	"That's a pressure cooker.",
	# KETTLE
	"That's a tea kettle.",
	# SAUCE_PAN
	"That's a sauce pan.",
	# COFFEE_BEANS_1
	"Coffee beans!",
	# COFFEE_BEANS_2
	"Coffee beans!",
	# NEWSPAPER
	"Newspaper from last week. An eternity...",
	# SMOOTHIE_BOTTLES
	"Those are smoothie bottles.",
	# FRUIT_JUICE_BOTTLES
	"Those are bottles of fruit juice.",
	# MILK_BOTTLES
	"Those are bottles of milk.",
	# BUTTER_KNIFE
	"That's butter... with a butter knife in it.",
	# CREAM_POTS
	"Those are jars of cream.",
	# YOGHURTS
	"That's yogurt.",
	# SAUCE_PAN_IN_FRIDGE
	"That's a sauce pan.",
	# EGGS
	"Those are eggs.",
	# GREEN_PEPPER
	"That's a green pepper.",
	# TOMATOES
	"Those are tomatoes.",
	# CAULIFLOWER
	"That's a cauliflower.",
	# YELLOW_PEPPER
	"That's a yellow pepper.",
	# FRUIT
	"That's some fruit.",
	# REFRIGERATOR_RIGHT_OPEN_DOOR
	"Do you want to close the refrigerator?",
	# PIZZA_DRAWER
	"I keep frozen pizzas there.",
	# VEGETABLE_DRAWER
	"I keep frozen vegetables there.",
	# LASAGNA_DRAWER
	"I keep frozen lasagna there.",
	# ICE_CREAM_DRAWER
	"I keep ice cream in there.",
	# MEAT_DRAWER
	"I keep frozen meat in there.",
	# REFRIGERATOR_LEFT_OPEN_DOOR
	"Do you want to close the freezer?",
	# EMPTY_COFFEE_SPACE
	"That's where my coffee should be but isn't.",
	# CANNED_GREEN_BEANS_1
	"That's a can of green beans.",
	# CANNED_GREEN_BEANS_2
	"That's a can of green beans.",
	# CANNED_BEANS_1
	"That's a can of beans.",
	# CANNED_BEANS_2
	"That's a can of beans.",
	# COFFEE_CUPBOARD_OPEN_DOOR
	"Do you want to close the coffee cupboard?",
	# DISHWASHER_TOP
	"That's the top rack of the dishwasher.",
	# DISHWASHER_MIDDLE
	"That's the middle rack of the dishwasher.",
	# DISHWASHER_BOTTOM
	"That's the main compartment of the dishwasher.",
	# DISHWASHER_OPEN_DOOR
	"Do you want to close the dishwasher?",
	# EXTINGUISHER
	"That's a fire extinguisher.",
	# PLASTIC_BASKETS
	"Those are plastic tubs.",
	# PLUNGER
	"That's a plunger.",
	# TRASH
	"That's my trash.",
	# UNDER_SINK_OPEN_DOOR
	"Do you want to close the cabinet?",
	# COOKING_POT
	"That's a big crock pot.",
	# HUGE_PRESSURE_COOKER
	"That's a big pressure cooker.",
	# SAUCE_PAN_SET
	"That's a set of sauce pans.",
	# SALAD_BOWLS
	"Those are my salad bowls.",
	# UPPER_RIGHT_CUPBOARD_OPEN_DOOR
	"Do you want to close the cupboard?",
	# DRAIN_CLEANER
	"That's drain cleaner.",
	# MOP
	"That's a mop.",
	# DETERGENT
	"That's detergent.",
	# LARGE_BUCKET
	"That's a big bucket.",
	# SMALL_BUCKET
	"That's a little bucket.",
	# DUST_PAN_BRUSH
	"That's a dust pan and broom.",
	# CLEANING_CLOSET_OPEN_DOOR
	"Do you want to close the cabinet?",
	# LARGE_COOKIE_BOX
	"That's a big box of tea biscuits.",
	# SMALL_COOKIE_BOX
	"That's a little box of tea biscuits.",
	# TEA_BOX_1
	"That's a box of tea.",
	# TEA_BOX_2
	"That's a box of tea.",
	# TEA_BOX_3
	"That's a box of tea.",
	# TEA_BOX_4
	"That's a box of tea.",
	# TEA_BOX_5
	"That's a box of tea.",
	# CUPBOARD_UPPER_CENTER_OPEN_DOOR
	"Do you want to close the cupboard?",
	# OVEN_EMPTY_SPACE_1
	"There's nothing in there.",
	# OVEN_EMPTY_SPACE_2
	"There's nothing in there.",
	# OVEN_EMPTY_SPACE_3
	"There's nothing in there.",
	# OVEN_OPEN_DOOR
	"Do you want to close the oven?",
	# MICROWAVE_PIZZA
	"That's an old pizza.",
	# MICROWAVE_OPEN_DOOR
	"Do you want to close the microwave?",
	# SMALL_WINE_GLASSES
	"Those are wine glasses.",
	# LARGE_GLASSES
	"Those are water glasses.",
	# SOUP_PLATES
	"Those are soup dishes.",
	# CUPBOARD_UPPER_CENTER_LEFT_OPEN_DOOR
	"Do you want to close the cupboard?",
	# RICE_COOKER
	"That's a rice cooker.",
	# PRESSURE_COOKER_2
	"That's a pressure cooker.",
	# KITCHEN_CABINET_OPEN_DOOR
	"Do you want to close the cabinet?",
	# WINE_GLASSES
	"Those are wine glasses.",
	# GLASSES
	"Those are glasses.",
	# PLATES
	"Those are plates.",
	# LEFT_GLASS_CUPBOARD_OPEN_DOOR
	"Do you want to close the cupboard?",
	# RECYCLING
	"That's my recycling.",
	# RECYCLING_OPEN_DOOR	
	"Do you want to close it?",
	# BOWLS
	"Those are bowls.",
	# LARGE_BOWLS
	"Those are large bowls.",
	# PLATES_2
	"Those are plates.",
	# RIGHT_GLASS_CUPBOARD_OPEN_DOOR
	"Do you want to close the cupboard?",
	# DRAWER_LEFT_1_OPEN
	"Do you want to close the drawer?",
	# DRAWER_LEFT_2_OPEN
	"Do you want to close the drawer?",
	# DRAWER_LEFT_3_OPEN
	"Do you want to close the drawer?",
	# PRIVATE_DRAWER_OPEN
	"Would you close that, please?",
	# KITCHEN_TOOLS_DRAWER_OPEN
	"Do you want to close the drawer?",
	# CUTLERY_DRAWER_OPEN
	"Do you want to close the drawer?",
	# OVEN_BOTTOM_OPEN
	"Do you want to close that?",
]

const open_close_door: Dictionary = {
	Globals.Prop.KITCHEN_CABINET: Globals.Prop.KITCHEN_CABINET_OPEN_DOOR,
	Globals.Prop.RECYCLING_CLOSET: Globals.Prop.RECYCLING_CLOSET_OPEN_DOOR,
	Globals.Prop.UNDER_SINK_CABINET: Globals.Prop.UNDER_SINK_OPEN_DOOR,
	Globals.Prop.CLEANING_CLOSET: Globals.Prop.CLEANING_CLOSET_OPEN_DOOR,
	Globals.Prop.DRAWER_LEFT_1: Globals.Prop.DRAWER_LEFT_1_OPEN,
	Globals.Prop.DRAWER_LEFT_2: Globals.Prop.DRAWER_LEFT_2_OPEN,
	Globals.Prop.DRAWER_LEFT_3: Globals.Prop.DRAWER_LEFT_3_OPEN,
	Globals.Prop.PRIVATE_DRAWER: Globals.Prop.PRIVATE_DRAWER_OPEN,
	Globals.Prop.KITCHEN_TOOLS_DRAWER: Globals.Prop.KITCHEN_TOOLS_DRAWER_OPEN,
	Globals.Prop.CUTLERY_DRAWER: Globals.Prop.CUTLERY_DRAWER_OPEN,
	Globals.Prop.OVEN: Globals.Prop.OVEN_OPEN_DOOR,
	Globals.Prop.OVEN_BOTTOM: Globals.Prop.OVEN_BOTTOM_OPEN,
	Globals.Prop.DISHWASHER: Globals.Prop.DISHWASHER_OPEN_DOOR,
	Globals.Prop.LEFT_GLASS_CUPBOARD: Globals.Prop.LEFT_GLASS_CUPBOARD_OPEN_DOOR,
	Globals.Prop.RIGHT_GLASS_CUPBOARD: Globals.Prop.RIGHT_GLASS_CUPBOARD_OPEN_DOOR,
	Globals.Prop.CUPBOARD_UPPER_CENTER_LEFT: Globals.Prop.CUPBOARD_UPPER_CENTER_LEFT_OPEN_DOOR,
	Globals.Prop.CUPBOARD_UPPER_CENTER: Globals.Prop.CUPBOARD_UPPER_CENTER_OPEN_DOOR,
	Globals.Prop.COFFEE_CUPBOARD: Globals.Prop.COFFEE_CUPBOARD_OPEN_DOOR,
	Globals.Prop.UPPER_RIGHT_CUPBOARD: Globals.Prop.UPPER_RIGHT_CUPBOARD_OPEN_DOOR,
	Globals.Prop.MICROWAVE: Globals.Prop.MICROWAVE_OPEN_DOOR,
	Globals.Prop.REFRIGERATOR_RIGHT: Globals.Prop.REFRIGERATOR_RIGHT_OPEN_DOOR,
	Globals.Prop.REFRIGERATOR_LEFT: Globals.Prop.REFRIGERATOR_LEFT_OPEN_DOOR,
}

const inventory_full_msg = "Hey, I don't have 4 arms, I'm not Shiva!"

const cant_use_msgs: Array[String] = [
	"That doesn't ring a bell for me.",
	"Maybe some other time.",
	"Yeah, or I could just lick the floor...",
	"No way, Jose!",
]

enum CoffeeState {
	BEANS,
	IN_TOWEL,
	ON_BOARD,
	GROUND,
}

enum FilterState {
	ORIGINAL,
	ON_BOARD,
	HALVED,
	FULL,
	SEALED,
}

var butter_knife_seen := false
var coffee_maker_seen := false
var is_towel_wet := false
var is_object_taken_from_drawer := false
var coffee_state: int = CoffeeState.BEANS
var filter_state: int = FilterState.ORIGINAL
var is_glass_full := false
var is_water_in_coffee_maker := false
var is_coffee_in_coffee_maker := false
var is_coffee_maker_on := false
var is_quitting := false

# 0: no coffee beans
# 1: COFFEE_BEANS_1
# 2: COFFEE_BEANS_2
# 3: COFFEE_BEANS_1 and COFFEE_BEANS_2
var coffee_beans_held: int = 0

func _ready():
	assert(prop_info.size() == Globals.Prop.VISIBLE_PROP_COUNT)
	if auto_start_chapter > 0:
		start(auto_start_chapter)

#
# Call this before doing anything that involves await statements (actions that
# cannot be interrupted), then call _clear_busy() when finished. This is to
# ensure that the game is not terminated (Rowena getting a phone call, walking
# to the counter to answer, etc.) while she is doing something, or while the
# comment box is open.
#
func _set_busy():
	im_busy += 1

#
# Call this after a call to _set_busy(). When the busy count drops to zero, if
# the end game has been requested, the game is ended here.
#
func _clear_busy():
	im_busy -= 1
	if im_busy == 0 and game_over_status == END_GAME_REQUESTED:
		_on_end_game()

##
## Call this to start the game from the beginning, as if this is the first time
## it has been played. You can optionally specify a [param chapter] other than
## the first to start with.
##
func start(chapter: int = 1):
	current_chapter = chapter
	if not skip_dialogues:
		is_dialogue_seen = false
		_set_busy()
		await $UI.tell_story(current_chapter)
		_clear_busy()
	is_dialogue_seen = true
	$UI.pin_help_button()

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("inventory_action", false, true):
		if $UI.is_inventory_open():
			$UI.close_inventory()
		elif not ($UI.is_tutorial_open() or $UI.is_dialogue_open()):
			if is_quitting or not $ROWENA.is_busy():
				$UI.open_inventory()
		get_viewport().set_input_as_handled()

#
# Sets the comment text, positioning it to the left or to the right of Rowena,
# depending on where she is standing.
#
func _set_comment(text: String):
	var viewport_size: Vector2 = get_viewport_rect().size
	var rowena_bbox: Rect2 = $ROWENA.get_global_bbox()
	var x: float
	var left_justify: bool
	if rowena_bbox.get_center().x < viewport_size.x/2:
		left_justify = true
		x = rowena_bbox.position.x + rowena_bbox.size.x
	else:
		left_justify = false
		x = rowena_bbox.position.x
	_set_busy()
	$UI.set_comment_text(text, x, left_justify)

func _on_ui_comment_closed():
	_clear_busy()

func _on_ui_click_on_background(pos: Vector2):
	if $ROWENA.is_busy():
		return
	var cursor = $UI.get_current_cursor()
	match cursor:
		Globals.Cursor.CROSS_PASSIVE, \
		Globals.Cursor.CROSS_ACTIVE, \
		Globals.Cursor.CROSS_ACTIVE_NEVER_SEEN:
			$UI.clear_comment_text()
			$ROWENA.walk_to_x(pos.x)
		Globals.Cursor.ARROW_PASSIVE:
			$UI.stop_using_inventory_item()
		Globals.Cursor.ARROW_ACTIVE:
			_use_object_on_other($UI.get_inventory_item_being_used(), current_prop)
			$UI.stop_using_inventory_item()
		Globals.Cursor.SOUND_UP, \
		Globals.Cursor.SOUND_DOWN, \
		Globals.Cursor.NO_SOUND:
			_adjust_radio_volume(cursor)
		Globals.Cursor.EYE:
			_perform_eye_action(pos)
		Globals.Cursor.HAND:
			await _perform_hand_action()
		Globals.Cursor.OPEN:
			await _perform_open_action()
		Globals.Cursor.CLOSE:
			await _perform_close_action()
		Globals.Cursor.QUIT:
			$UI.clear_comment_text()
			# Start walking toward the window, but don't actually quit until
			# Rowena reaches it (a target_area_reached signal is received from
			# $ROWENA). Until then, a quit_aborted signal may be received from
			# $UI.
			is_quitting = true
			_walk_to_prop(current_prop, false, false)
			$UI.start_quit()

func _perform_eye_action(pos: Vector2):
	$ROWENA.look_at_x(pos.x)
	if current_prop < 0:
		return
	_set_prop_seen(current_prop)
	var comment = ""
	match current_prop:
		Globals.Prop.BUTTER_KNIFE:
			butter_knife_seen = true
			if $UI.find_in_inventory(current_prop) >= 0:
				comment = "That's butter. I've got the knife, though."
		Globals.Prop.COFFEE_MAKER:
			coffee_maker_seen = true
			if $UI.find_in_inventory(current_prop) >= 0:
				comment = "That's my coffee maker. I've got the filter holder."
	_set_comment(comment if comment else prop_info[current_prop])

func _perform_hand_action():
	$UI.clear_comment_text()
	$UI.clear_available_cursors()

	if current_prop < 0:
		return
	_set_prop_seen(current_prop)

	var take_label = ""
	var take_msg = ""
	var need_room_in_inventory = true

	match current_prop:
		Globals.Prop.STOOL:
			_set_comment("As soon as I figure out what it's for.")
		Globals.Prop.CHAIR:
			_set_comment("I'm fine, I've had enough rest, thank you.")
		Globals.Prop.TOWEL_LARGE:
			_set_comment("I shouldn't use it, except for... No, I shouldn't!")
		Globals.Prop.TOWEL_SMALL:
			if is_towel_wet:
				take_label = "Small towel moistened with milk"
			else:
				take_label = "Small towel"
			take_msg = "It's clean, it'll be perfect!"
		Globals.Prop.COFFEE_MAKER:
			await _turn_on_coffee_maker()
		Globals.Prop.SPOILED_MILK:
			_set_comment("I don't want that.")
		Globals.Prop.REFRIGERATOR_LEFT_WATER_ICE:
			_set_comment("Where in the world have you been until now?")
		Globals.Prop.PAINTING:
			_set_comment("The painting's called \"Monsieur le Marquis et Madame\".")
		Globals.Prop.LIGHT_SWITCH_LEFT, \
		Globals.Prop.LIGHT_SWITCH_RIGHT:
			_set_comment("I’m no Hubert Bonisseur de la Bath...")
		Globals.Prop.YUCCA:
			take_label = "Yucca plant"
			take_msg = "I'll be watering it later, but OK."
		Globals.Prop.OLIVE_OIL_BOTTLE:
			take_label = "Olive oil"
			take_msg = "OK, but it's just to please you."
		Globals.Prop.SALT:
			take_label = "Salt"
			take_msg = "I'll never use it with my coffee, but OK."
		Globals.Prop.TOASTER:
			_set_comment("It works and I can use it any time.")
		Globals.Prop.NOTCHED_COFFEE_CUP_RIGHT:
			_set_comment("No, I chipped it yesterday.")
		Globals.Prop.PEPPER:
			take_label = "Pepper"
			take_msg = "You always need some pepper!"
		Globals.Prop.RICE_POT:
			_set_comment("No, it's raw.")
		Globals.Prop.COOKIE_POT:
			take_label = "Cookie"
			take_msg = "Only one. But I need my coffee first."
		Globals.Prop.TAP:
			_set_comment("Yes. And?")
		Globals.Prop.PLASTIC_BOXES:
			take_label = "Tupperware"
			take_msg = "I know how to make them fart! I'll take one."
		Globals.Prop.MANDOLIN:
			take_label = "Vegetable slicer"
			take_msg = "As long as I don't slice my fingers off."
		Globals.Prop.FOOD_PROCESSOR:
			_set_comment("It's not a Rank Xerox, no way.")
		Globals.Prop.RED_COFFEE_CUP_LEFT:
			take_label = "Coffee cup"
			take_msg = "Yeah, it's new and clean."
		Globals.Prop.BROWN_COFFEE_CUP:
			_set_comment("That's not my cup of tea.")
		Globals.Prop.KNIFE_BLOCK:
			_set_comment("Nah! My boss isn't worth the trouble.")
		Globals.Prop.FRUIT_BASKET:
			take_label = "Red apple"
			take_msg = "Just a red apple, nothing more."
		Globals.Prop.CUTTING_BOARD:
			take_label = "Cutting board"
			take_msg = "Clever! Probably..."
		Globals.Prop.PRESSURE_COOKER:
			_set_comment("There's no way I'm dragging that around.")
		Globals.Prop.KETTLE:
			take_label = "Tea kettle"
			take_msg = "OK, if you say so."
		Globals.Prop.SAUCE_PAN:
			_set_comment("No, there's still sauce in it.")
		Globals.Prop.COFFEE_BEANS_1, \
		Globals.Prop.COFFEE_BEANS_2:
			if coffee_beans_held > 0:
				take_label = "Coffee beans (enough)"
				need_room_in_inventory = false
			else:
				take_label = "Coffee beans (not enough)"
			take_msg = "Coffee beans!"
		Globals.Prop.NEWSPAPER:
			_set_comment("That'll get me depressed.")
		Globals.Prop.SMOOTHIE_BOTTLES:
			take_label = "Smoothie"
			take_msg = "I drink it before working out. But OK, one."
		Globals.Prop.FRUIT_JUICE_BOTTLES:
			take_label = "Fruit juice"
			take_msg = "I drink it before working out. But one is OK."
		Globals.Prop.MILK_BOTTLES:
			take_label = "Bottle of milk"
			take_msg = "OK, one bottle of milk."
		Globals.Prop.BUTTER_KNIFE:
			if butter_knife_seen:
				take_label = "Butter knife"
				take_msg = "OK, I'll just take that knife."
			else:
				_set_comment("Remember? Coffee...")
		Globals.Prop.CREAM_POTS:
			_set_comment("Not now.")
		Globals.Prop.YOGHURTS:
			take_label = "Yoghurt"
			take_msg = "OK, OK..."
		Globals.Prop.SAUCE_PAN_IN_FRIDGE:
			_set_comment("Yeah, I'll leave that there.")
		Globals.Prop.EGGS:
			take_label = "Egg"
			take_msg = "OK but I need to be extra careful."
		Globals.Prop.GREEN_PEPPER:
			_set_comment("It's way too early for that!")
		Globals.Prop.TOMATOES:
			_set_comment("Hmm... Nope!")
		Globals.Prop.CAULIFLOWER:
			_set_comment("Not now.")
		Globals.Prop.YELLOW_PEPPER:
			_set_comment("OK. No, just kidding.")
		Globals.Prop.FRUIT:
			_set_comment("Don't you remember? I need coffee!")
		Globals.Prop.PIZZA_DRAWER, \
		Globals.Prop.VEGETABLE_DRAWER, \
		Globals.Prop.LASAGNA_DRAWER, \
		Globals.Prop.ICE_CREAM_DRAWER, \
		Globals.Prop.MEAT_DRAWER:
			_set_comment("Way too cold at this hour!")
		Globals.Prop.EMPTY_COFFEE_SPACE:
			_set_comment("I'd better take 10 more looks at it, just in case...")
		Globals.Prop.CANNED_GREEN_BEANS_1, \
		Globals.Prop.CANNED_GREEN_BEANS_2:
			_set_comment("Not what I had in mind...")
		Globals.Prop.CANNED_BEANS_1, \
		Globals.Prop.CANNED_BEANS_2:
			_set_comment("They make me fart, so maybe not.")
		Globals.Prop.DISHWASHER_TOP, \
		Globals.Prop.DISHWASHER_MIDDLE, \
		Globals.Prop.DISHWASHER_BOTTOM:
			_set_comment("It's empty.")
		Globals.Prop.EXTINGUISHER:
			take_label = "Fire extinguisher"
			take_msg = "That's clever? Or is it...?"
		Globals.Prop.PLASTIC_BASKETS:
			_set_comment("No. Even though it's lightweight.")
		Globals.Prop.PLUNGER:
			take_label = "Plunger"
			take_msg = "I've always loved a plunger."
		Globals.Prop.TRASH:
			if (current_chapter == 3
				and Globals.get_elapsed_time() > scavenging_time):
				take_label = "Yesterday's coffee filter"
				take_msg = "Not much choice... Where is that old coffee filter?"
			else:
				_set_comment("I used to play in the dump. When I was a kid...")
		Globals.Prop.COOKING_POT, \
		Globals.Prop.HUGE_PRESSURE_COOKER, \
		Globals.Prop.SAUCE_PAN_SET, \
		Globals.Prop.SALAD_BOWLS:
			_set_comment("No way I'm dragging that around.")
		Globals.Prop.DRAIN_CLEANER:
			_set_comment("To make coffee??")
		Globals.Prop.MOP:
			_set_comment("It's filthy!")
		Globals.Prop.DETERGENT:
			_set_comment("I'll use it this weekend.")
		Globals.Prop.LARGE_BUCKET:
			_set_comment("Hmm... Nope.")
		Globals.Prop.SMALL_BUCKET:
			_set_comment("What could I possibly do with it?")
		Globals.Prop.DUST_PAN_BRUSH:
			_set_comment("What was I looking for again?")
		Globals.Prop.LARGE_COOKIE_BOX:
			_set_comment("That's way too much right now.")
		Globals.Prop.SMALL_COOKIE_BOX:
			take_label = "Tea biscuits"
			take_msg = "I shouldn't, but OK..."
		Globals.Prop.TEA_BOX_1, \
		Globals.Prop.TEA_BOX_2, \
		Globals.Prop.TEA_BOX_3, \
		Globals.Prop.TEA_BOX_4:
			_set_comment("They'll all fall down on me if I take that one!")
		Globals.Prop.TEA_BOX_5:
			take_label = "Box of tea"
			take_msg = "I want coffee, not tea, but OK."
		Globals.Prop.OVEN_EMPTY_SPACE_1, \
		Globals.Prop.OVEN_EMPTY_SPACE_2, \
		Globals.Prop.OVEN_EMPTY_SPACE_3:
			_set_comment("I'd have to clean it, it's so gross.")
		Globals.Prop.MICROWAVE_PIZZA:
			_set_comment("It's rock hard now!")
		Globals.Prop.SMALL_WINE_GLASSES:
			take_label = "Small wine glass"
			take_msg = "OK, why not?"
		Globals.Prop.LARGE_GLASSES:
			take_label = "Water glass"
			take_msg = "OK."
		Globals.Prop.SOUP_PLATES:
			take_label = "Soup dish"
			take_msg = "Yes, just what I need!"
		Globals.Prop.RICE_COOKER:
			_set_comment("Please...")
		Globals.Prop.PRESSURE_COOKER_2:
			_set_comment("No way I'm dragging that around.")
		Globals.Prop.WINE_GLASSES:
			take_label = "Wine glass"
			take_msg = "Just one is fine with me."
		Globals.Prop.GLASSES:
			take_label = "Glass"
			take_msg = "As long as I only take one."
		Globals.Prop.PLATES:
			take_label = "Plate"
			take_msg = "Good."
		Globals.Prop.RECYCLING:
			_set_comment("It's half full of plastic and paper.")
		Globals.Prop.BOWLS:
			take_label = "Bowl"
			take_msg = "I have bigger ones, but OK."
		Globals.Prop.LARGE_BOWLS:
			take_label = "Large bowl"
			take_msg = "I have smaller ones, but OK."
		Globals.Prop.PLATES_2:
			take_label = "Plate"
			take_msg = "Nice and clean."
		Globals.Prop.DRAWER_LEFT_1, \
		Globals.Prop.DRAWER_LEFT_1_OPEN:
			_show_junk_drawer()
		Globals.Prop.DRAWER_LEFT_2, \
		Globals.Prop.DRAWER_LEFT_2_OPEN:
			_show_empty_drawer()
		Globals.Prop.PRIVATE_DRAWER, \
		Globals.Prop.PRIVATE_DRAWER_OPEN:
			_show_private_drawer()
		Globals.Prop.KITCHEN_TOOLS_DRAWER, \
		Globals.Prop.KITCHEN_TOOLS_DRAWER_OPEN:
			_show_kitchen_tools_drawer()
		Globals.Prop.CUTLERY_DRAWER, \
		Globals.Prop.CUTLERY_DRAWER_OPEN:
			_show_cutlery_drawer()
		Globals.Prop.OVEN_BOTTOM, \
		Globals.Prop.OVEN_BOTTOM_OPEN:
			_show_oven_bottom()

	if take_label:
		if need_room_in_inventory and $UI.is_inventory_full():
			_set_comment(inventory_full_msg)
		else:
			_set_busy()

			# because walking will change the current prop...
			var take_prop = current_prop
			await _walk_to_prop()
			_set_comment(take_msg)
			var collider: Area2D = $BACKGROUND.get_collider(take_prop)
			$ROWENA.get_something_at(collider.position.y)
			await $ROWENA.get_something_reached

			# special case for coffee beans: there are two colliders, but in
			# the inventory they only count for one item

			if take_prop == Globals.Prop.COFFEE_BEANS_1:
				coffee_beans_held += 1
				$UI.add_to_inventory(Globals.Prop.COFFEE_BEANS_1, take_label)
			elif take_prop == Globals.Prop.COFFEE_BEANS_2:
				coffee_beans_held += 2
				$UI.add_to_inventory(Globals.Prop.COFFEE_BEANS_1, take_label)
			else:
				$UI.add_to_inventory(take_prop, take_label)

			$BACKGROUND.set_object_visible(take_prop, false)
			await $ROWENA.get_something_done

			_clear_busy()

func _perform_open_action():
	$UI.clear_comment_text()
	$UI.clear_available_cursors()

	if current_prop < 0:
		return
	_set_prop_seen(current_prop)
	_set_prop_seen(open_close_door[current_prop])

	var object_to_open = current_prop
	var collider: Area2D = $BACKGROUND.get_collider(object_to_open)

	_set_busy()
	await _close_open_object()
	await _walk_to_prop(object_to_open)
	$ROWENA.get_something_at(collider.position.y)
	await $ROWENA.get_something_reached
	$BACKGROUND.open_something(object_to_open)
	await $ROWENA.get_something_done
	_clear_busy()

	match object_to_open:
		Globals.Prop.DRAWER_LEFT_1:
			_show_junk_drawer()
		Globals.Prop.DRAWER_LEFT_2, \
		Globals.Prop.DRAWER_LEFT_3:
			_show_empty_drawer()
		Globals.Prop.PRIVATE_DRAWER:
			_show_private_drawer()
		Globals.Prop.KITCHEN_TOOLS_DRAWER:
			_show_kitchen_tools_drawer()
		Globals.Prop.CUTLERY_DRAWER:
			_show_cutlery_drawer()
		Globals.Prop.OVEN_BOTTOM:
			_show_oven_bottom()
		Globals.Prop.COFFEE_CUPBOARD:
			_set_comment("I like rubbing salt in the wound.")

func _perform_close_action():
	$UI.clear_comment_text()
	$UI.clear_available_cursors()

	var collider: Area2D = $BACKGROUND.get_collider(current_prop)

	_set_busy()
	await _walk_to_prop()
	$ROWENA.get_something_at(collider.position.y)
	await $ROWENA.get_something_reached
	$BACKGROUND.close_something()
	await $ROWENA.get_something_done
	_clear_busy()

	_recompute_overlapping_colliders()

func _close_open_object():
	var which = $BACKGROUND.get_open_object()
	if which < 0:
		return

	var door = open_close_door[which]

	_set_busy()
	await _walk_to_prop(door)
	var collider: Area2D = $BACKGROUND.get_collider(door)
	$ROWENA.get_something_at(collider.position.y)
	await $ROWENA.get_something_reached
	$BACKGROUND.close_something()
	await $ROWENA.get_something_done
	_clear_busy()

	_recompute_overlapping_colliders()

#
# Returns the distance in X between Rowena and the given object from the
# BACKGROUND scene (a constant from Globals.Prop).
#
# NB. Background objects are represented by Area2D instances, and Area2D does
# not provide access to its bounding box, so all we can do is look at the
# Area2D's origin. This method will give unexpected results if an object's
# collider is not positioned at the center of its shape(s). 
#
func _get_distance_from_prop(which: int) -> float:
		var prop: Area2D = $BACKGROUND.get_collider(which)
		return absf($ROWENA.position.x - prop.position.x)

#
# Tells Rowena to walk toward the given object from the BACKGROUND scene (a
# constant from Globals.Prop). If which is -1, she walks toward the current
# prop (i.e. the object the mouse is over). This is a couroutine which blocks
# until she has reached the object; if she is already standing near the object,
# she just turns to face it, and the method returns immediately.
#
# If walk_to_origin is true, she walks all the way to the origin of the object's
# collider; otherwise, she walks until her collider intersects with it.
#
# If blocking is true, the method blocks until Rowena arrives; otherwise, it
# returns immediately.
#
# NB. This will only work properly if the given object's collider (an Area2D) is
# positioned correctly (its origin is at the center of its shape), and if its
# collision mask includes Rowena's movements (layer 3).
#
func _walk_to_prop(
	which: int = -1, walk_to_origin: bool = false, blocking: bool = true):
	if which < 0:
		which = current_prop
	var area = $BACKGROUND.get_collider(which)
	$ROWENA.look_at_x(area.global_position.x)
	$ROWENA.walk_to_area(area, walk_to_origin, false)
	if blocking:
		_set_busy()
		await $ROWENA.target_area_reached
		_clear_busy()

#
# Callback invoked when the mouse collider (_area) enters the Area2D of a
# background object (the prop identified by which: see Globals.Prop). The
# current prop, and available cursor actions, are updated as appropriate.
#
func _on_background_area_entered_object(which: int, _area: Area2D):

	# coffee beans are not visible until chapter 2, and some are only visible
	# if you take the salt first

	if which in [Globals.Prop.COFFEE_BEANS_1, Globals.Prop.COFFEE_BEANS_2]:
		if current_chapter < 2:
			return
		if (which == Globals.Prop.COFFEE_BEANS_1
			and $UI.find_in_inventory(Globals.Prop.SALT) < 0):
			return

	# add the collider to the set of current colliders and make the topmost
	# collider the current prop

	var collider: Area2D = $BACKGROUND.get_collider(which)
	if not overlapping_colliders.has(which):
		overlapping_colliders[which] = collider
		_update_current_prop()

#
# Callback invoked when the mouse collider (_area) leaves the Area2D of a
# background object (the prop identified by which: see Globals.Prop). The
# current prop, and available cursor actions, are updated as appropriate.
#
func _on_background_area_exited_object(which: int, _area: Area2D):
	if overlapping_colliders.erase(which):
		_update_current_prop()

#
# Recomputes from scratch the list of objects overlapping the mouse collider,
# then calls _update_current_prop() to find the topmost object, make it the
# current prop and set the available action cursors appropriately.
#
# This is useful in particular when an object has disappeared (e.g. an object
# in the refrigerator we just closed), because if the mouse was over it before
# it disappeared, we will never receive an exit signal to remove it.
#
func _recompute_overlapping_colliders():
	overlapping_colliders.clear()
	for area in $UI.get_areas_overlapping_mouse():
		var index = $BACKGROUND.get_object_from_collider(area)
		if index >= 0:
			overlapping_colliders[index] = area
	_update_current_prop()

func _get_prop_name(prop: int) -> String:
	return Globals.Prop.find_key(prop).capitalize()

#
# Called when the list of background objects in contact with the mouse collider
# has changed. The current prop object is updated, if necessary, and the list of
# available cursor actions is updated accordingly.
#
# If the mouse is is contact with more than one object, all but the topmost
# object are ignored. Object depth is determined by each collider's "bg_level"
# metadata value. The default value is 0; higher values are considered to be on
# top of lower values.
#
func _update_current_prop():
	var top_prop = -1

	# fetch the topmost object in contact with the mouse collider

	if not overlapping_colliders.is_empty():
		var bg_level = -1
		for key in overlapping_colliders.keys():
			var collider: Area2D = overlapping_colliders[key]
			var level = collider.get_meta(&"bg_level", 0)
			if bg_level < level:
				bg_level = level
				top_prop = key

	# already the current prop: do nothing

	if current_prop == top_prop:
		return

	current_prop = top_prop

	# update the list of available cursor actions

	if current_prop < 0:
		$UI.clear_available_cursors()
		return

	#print(_get_prop_name(top_prop))
	var actions: Array[int] = [Globals.Cursor.CROSS_ACTIVE, Globals.Cursor.EYE]
	if not _is_prop_seen(current_prop):
		actions[0] = Globals.Cursor.CROSS_ACTIVE_NEVER_SEEN

	match current_prop:
		Globals.Prop.KITCHEN_CABINET, \
		Globals.Prop.RECYCLING_CLOSET, \
		Globals.Prop.UNDER_SINK_CABINET, \
		Globals.Prop.CLEANING_CLOSET, \
		Globals.Prop.OVEN, \
		Globals.Prop.DISHWASHER, \
		Globals.Prop.LEFT_GLASS_CUPBOARD, \
		Globals.Prop.RIGHT_GLASS_CUPBOARD, \
		Globals.Prop.CUPBOARD_UPPER_CENTER_LEFT, \
		Globals.Prop.CUPBOARD_UPPER_CENTER, \
		Globals.Prop.COFFEE_CUPBOARD, \
		Globals.Prop.UPPER_RIGHT_CUPBOARD, \
		Globals.Prop.MICROWAVE, \
		Globals.Prop.REFRIGERATOR_RIGHT, \
		Globals.Prop.REFRIGERATOR_LEFT:
			if $BACKGROUND.get_open_object() != current_prop:
				actions.append(Globals.Cursor.OPEN)

		Globals.Prop.KITCHEN_CABINET_OPEN_DOOR, \
		Globals.Prop.RECYCLING_CLOSET_OPEN_DOOR, \
		Globals.Prop.UNDER_SINK_OPEN_DOOR, \
		Globals.Prop.CLEANING_CLOSET_OPEN_DOOR, \
		Globals.Prop.OVEN_OPEN_DOOR, \
		Globals.Prop.DISHWASHER_OPEN_DOOR, \
		Globals.Prop.LEFT_GLASS_CUPBOARD_OPEN_DOOR, \
		Globals.Prop.RIGHT_GLASS_CUPBOARD_OPEN_DOOR, \
		Globals.Prop.CUPBOARD_UPPER_CENTER_LEFT_OPEN_DOOR, \
		Globals.Prop.CUPBOARD_UPPER_CENTER_OPEN_DOOR, \
		Globals.Prop.COFFEE_CUPBOARD_OPEN_DOOR, \
		Globals.Prop.UPPER_RIGHT_CUPBOARD_OPEN_DOOR, \
		Globals.Prop.MICROWAVE_OPEN_DOOR, \
		Globals.Prop.REFRIGERATOR_RIGHT_OPEN_DOOR, \
		Globals.Prop.REFRIGERATOR_LEFT_OPEN_DOOR:
			actions.append(Globals.Cursor.CLOSE)

		Globals.Prop.SPOILED_MILK, \
		Globals.Prop.REFRIGERATOR_LEFT_WATER_ICE, \
		Globals.Prop.PAINTING, \
		Globals.Prop.LIGHT_SWITCH_LEFT, \
		Globals.Prop.LIGHT_SWITCH_RIGHT, \
		Globals.Prop.YUCCA, \
		Globals.Prop.OLIVE_OIL_BOTTLE, \
		Globals.Prop.SALT, \
		Globals.Prop.TOASTER, \
		Globals.Prop.NOTCHED_COFFEE_CUP_RIGHT, \
		Globals.Prop.PEPPER, \
		Globals.Prop.RICE_POT, \
		Globals.Prop.COOKIE_POT, \
		Globals.Prop.TAP, \
		Globals.Prop.PLASTIC_BOXES, \
		Globals.Prop.MANDOLIN, \
		Globals.Prop.FOOD_PROCESSOR, \
		Globals.Prop.RED_COFFEE_CUP_LEFT, \
		Globals.Prop.BROWN_COFFEE_CUP, \
		Globals.Prop.KNIFE_BLOCK, \
		Globals.Prop.FRUIT_BASKET, \
		Globals.Prop.CUTTING_BOARD, \
		Globals.Prop.PRESSURE_COOKER, \
		Globals.Prop.KETTLE, \
		Globals.Prop.SAUCE_PAN, \
		Globals.Prop.NEWSPAPER, \
		Globals.Prop.STOOL, \
		Globals.Prop.CHAIR, \
		Globals.Prop.TOWEL_LARGE, \
		Globals.Prop.TOWEL_SMALL, \
		Globals.Prop.SMOOTHIE_BOTTLES, \
		Globals.Prop.FRUIT_JUICE_BOTTLES, \
		Globals.Prop.MILK_BOTTLES, \
		Globals.Prop.BUTTER_KNIFE, \
		Globals.Prop.CREAM_POTS, \
		Globals.Prop.YOGHURTS, \
		Globals.Prop.SAUCE_PAN_IN_FRIDGE, \
		Globals.Prop.EGGS, \
		Globals.Prop.GREEN_PEPPER, \
		Globals.Prop.TOMATOES, \
		Globals.Prop.CAULIFLOWER, \
		Globals.Prop.YELLOW_PEPPER, \
		Globals.Prop.FRUIT, \
		Globals.Prop.PIZZA_DRAWER, \
		Globals.Prop.VEGETABLE_DRAWER, \
		Globals.Prop.LASAGNA_DRAWER, \
		Globals.Prop.ICE_CREAM_DRAWER, \
		Globals.Prop.MEAT_DRAWER, \
		Globals.Prop.EMPTY_COFFEE_SPACE, \
		Globals.Prop.CANNED_GREEN_BEANS_1, \
		Globals.Prop.CANNED_GREEN_BEANS_2, \
		Globals.Prop.CANNED_BEANS_1, \
		Globals.Prop.CANNED_BEANS_2, \
		Globals.Prop.DISHWASHER_TOP, \
		Globals.Prop.DISHWASHER_MIDDLE, \
		Globals.Prop.DISHWASHER_BOTTOM, \
		Globals.Prop.EXTINGUISHER, \
		Globals.Prop.PLASTIC_BASKETS, \
		Globals.Prop.PLUNGER, \
		Globals.Prop.TRASH, \
		Globals.Prop.COOKING_POT, \
		Globals.Prop.HUGE_PRESSURE_COOKER, \
		Globals.Prop.SAUCE_PAN_SET, \
		Globals.Prop.SALAD_BOWLS, \
		Globals.Prop.DRAIN_CLEANER, \
		Globals.Prop.MOP, \
		Globals.Prop.DETERGENT, \
		Globals.Prop.LARGE_BUCKET, \
		Globals.Prop.SMALL_BUCKET, \
		Globals.Prop.DUST_PAN_BRUSH, \
		Globals.Prop.LARGE_COOKIE_BOX, \
		Globals.Prop.SMALL_COOKIE_BOX, \
		Globals.Prop.TEA_BOX_1, \
		Globals.Prop.TEA_BOX_2, \
		Globals.Prop.TEA_BOX_3, \
		Globals.Prop.TEA_BOX_4, \
		Globals.Prop.TEA_BOX_5, \
		Globals.Prop.OVEN_EMPTY_SPACE_1, \
		Globals.Prop.OVEN_EMPTY_SPACE_2, \
		Globals.Prop.OVEN_EMPTY_SPACE_3, \
		Globals.Prop.MICROWAVE_PIZZA, \
		Globals.Prop.SMALL_WINE_GLASSES, \
		Globals.Prop.LARGE_GLASSES, \
		Globals.Prop.SOUP_PLATES, \
		Globals.Prop.RICE_COOKER, \
		Globals.Prop.PRESSURE_COOKER_2, \
		Globals.Prop.WINE_GLASSES, \
		Globals.Prop.GLASSES, \
		Globals.Prop.PLATES, \
		Globals.Prop.RECYCLING, \
		Globals.Prop.BOWLS, \
		Globals.Prop.LARGE_BOWLS, \
		Globals.Prop.PLATES_2:
			if $UI.find_in_inventory(current_prop) < 0:
				actions.append(Globals.Cursor.HAND)

		Globals.Prop.COFFEE_MAKER:
			if (is_water_in_coffee_maker
				and is_coffee_in_coffee_maker
				and not is_coffee_maker_on):
				actions.append(Globals.Cursor.HAND)

		Globals.Prop.COFFEE_BEANS_1:
			if not (coffee_beans_held & 1):
				actions.append(Globals.Cursor.HAND)
		Globals.Prop.COFFEE_BEANS_2:
			if not (coffee_beans_held & 2):
				actions.append(Globals.Cursor.HAND)

		Globals.Prop.DRAWER_LEFT_1, \
		Globals.Prop.DRAWER_LEFT_2, \
		Globals.Prop.DRAWER_LEFT_3, \
		Globals.Prop.PRIVATE_DRAWER, \
		Globals.Prop.KITCHEN_TOOLS_DRAWER, \
		Globals.Prop.CUTLERY_DRAWER, \
		Globals.Prop.OVEN_BOTTOM:
			if $BACKGROUND.get_open_object() == current_prop:
				actions.append(Globals.Cursor.HAND)
			else:
				actions.append(Globals.Cursor.OPEN)

		Globals.Prop.DRAWER_LEFT_1_OPEN, \
		Globals.Prop.DRAWER_LEFT_2_OPEN, \
		Globals.Prop.DRAWER_LEFT_3_OPEN, \
		Globals.Prop.PRIVATE_DRAWER_OPEN, \
		Globals.Prop.KITCHEN_TOOLS_DRAWER_OPEN, \
		Globals.Prop.CUTLERY_DRAWER_OPEN, \
		Globals.Prop.OVEN_BOTTOM_OPEN:
			actions.append(Globals.Cursor.HAND)
			actions.append(Globals.Cursor.CLOSE)

		Globals.Prop.RADIO:
			actions.append(Globals.Cursor.SOUND_UP)
			actions.append(Globals.Cursor.SOUND_DOWN)
			actions.append(Globals.Cursor.NO_SOUND)

		Globals.Prop.WINDOW_RIGHT:
			actions.append(Globals.Cursor.QUIT)

	$UI.set_available_cursors(actions)

func _check_objects(have1: int, have2: int, want1: int, want2: int) -> bool:
	return ((have1 == want1 and have2 == want2) or
			(have1 == want2 and have2 == want1))

#
# Called when the user "uses" an object in the inventory on another object,
# which may or may not be in the inventory. The two parameters are object
# constants from Globals.Prop.
#
func _use_object_on_other(object1: int, object2: int):
	_set_busy()
	var ok = false
	match current_chapter:
		1:
			ok = await _use_object_chapter1(object1, object2)
		2:
			ok = await _use_object_chapter2(object1, object2)
		3:
			ok = await _use_object_chapter3(object1, object2)
	_clear_busy()

	if not ok:
		#print("use ", _get_prop_name(object1), " on ", _get_prop_name(object2))
		var msg_index = randi() % cant_use_msgs.size()
		_set_comment(cant_use_msgs[msg_index])

func _use_object_chapter1(object1: int, object2: int) -> bool:

	# butter knife + coffee maker: add the filter holder to the inventory

	if _check_objects(
		object1, object2, Globals.Prop.BUTTER_KNIFE, Globals.Prop.COFFEE_MAKER):
		if not coffee_maker_seen:
			_set_comment("That's not my sparring partner.")
		elif $UI.is_inventory_full():
			_set_comment("Hey, I'm not going around with Santa's bag!")
		else:
			await _walk_to_prop(Globals.Prop.COFFEE_MAKER, true)
			await $ROWENA.do_stuff($Do_Stuff)
			_set_comment("I got the filter holder out intact!")
			$UI.add_to_inventory(Globals.Prop.COFFEE_MAKER, "Coffee filter holder")
			$BACKGROUND.set_object_visible(Globals.Prop.COFFEE_MAKER, false)
		return true

	# milk bottle + small towel: moisten the towel and update the inventory
	# (both objects must be in the inventory)

	if _check_objects(
		object1, object2, Globals.Prop.MILK_BOTTLES, Globals.Prop.TOWEL_SMALL):
		if ($UI.find_in_inventory(object1) < 0 or
			$UI.find_in_inventory(object2) < 0):
			return false
		elif is_towel_wet:
			_set_comment("The towel is already moist.")
		else:
			await $ROWENA.walk_to_area($BACKGROUND/Counter_Collider)
			await $ROWENA.do_stuff()
			_set_comment("Now the towel is moist.")
			is_towel_wet = true
			$UI.add_to_inventory(
				Globals.Prop.TOWEL_SMALL, "Small towel moistened with milk")
		return true

	# small towel + filter holder: if the towel has been moistened, use it on
	# the filter holder and taste it (both objects must be in the inventory)

	if _check_objects(
		object1, object2, Globals.Prop.TOWEL_SMALL, Globals.Prop.COFFEE_MAKER):
		if ($UI.find_in_inventory(object1) < 0 or
			$UI.find_in_inventory(object2) < 0):
			return false
		elif is_towel_wet:
			await $ROWENA.walk_to_area($BACKGROUND/Counter_Collider)
			await $ROWENA.do_stuff()
			_set_comment("That should be more absorbent now. Let's taste it!")
			await $UI.comment_closed
			await $ROWENA.do_erk_stuff()
			_set_comment("That's disgusting! And there's not enough...")
			current_chapter += 1
			$UI.unpin_help_button()
			if not skip_dialogues:
				is_dialogue_seen = false
				await $UI.comment_closed
				await $UI.tell_story(current_chapter)
			is_dialogue_seen = true
		else:
			await $ROWENA.walk_to_area($BACKGROUND/Counter_Collider)
			await $ROWENA.do_stuff()
			_set_comment("That works, but I can't get enough coffee out of it.")
		return true

	return false

func _use_object_chapter2(object1: int, object2: int) -> bool:

	# towel + coffee beans: wrap the beans in the towel (the small towel and
	# ALL the coffee beans must be in the inventory)

	if _check_objects(
		object1, object2, Globals.Prop.TOWEL_SMALL, Globals.Prop.COFFEE_BEANS_1):
		if ($UI.find_in_inventory(object1) < 0 or
			$UI.find_in_inventory(object2) < 0 or
			coffee_state != CoffeeState.BEANS):
			return false
		elif coffee_beans_held != 3:
			_set_comment("I don't have enough coffee beans.")
		else:
			await $ROWENA.walk_to_area($BACKGROUND/Counter_Collider)
			await $ROWENA.do_stuff()
			_set_comment("OK. Well that's something.")
			coffee_state = CoffeeState.IN_TOWEL
			$UI.remove_from_inventory(Globals.Prop.TOWEL_SMALL)
			$UI.add_to_inventory(
				Globals.Prop.COFFEE_BEANS_1, "Coffee beans wrapped in towel")
		return true

	# cutting board + coffee beans wrapped in towel: put the wrapped beans on
	# the cutting board (both must be in the inventory)

	if _check_objects(
		object1, object2, Globals.Prop.CUTTING_BOARD, Globals.Prop.COFFEE_BEANS_1):
		if ($UI.find_in_inventory(object1) < 0 or
			$UI.find_in_inventory(object2) < 0 or
			coffee_state != CoffeeState.IN_TOWEL):
			return false
		else:
			await $ROWENA.walk_to_area($BACKGROUND/Counter_Collider)
			await $ROWENA.do_stuff()
			_set_comment("Looks like a plan to me!")
			coffee_state = CoffeeState.ON_BOARD
			$UI.remove_from_inventory(Globals.Prop.CUTTING_BOARD)
			$UI.add_to_inventory(
				Globals.Prop.COFFEE_BEANS_1, "Wrapped coffee beans on cutting board")
		return true

	# wooden spoon + wrapped coffee beans on cutting board: ground the beans
	# (both must be in the inventory)

	if _check_objects(
		object1, object2, Globals.Prop.WOODEN_SPOON, Globals.Prop.COFFEE_BEANS_1):
		if ($UI.find_in_inventory(object1) < 0 or
			$UI.find_in_inventory(object2) < 0 or
			coffee_state != CoffeeState.ON_BOARD):
			return false
		elif $UI.get_inventory_room() < 2:
			_set_comment(inventory_full_msg)
		else:
			await $ROWENA.walk_to_area($BACKGROUND/Counter_Collider)
			await $ROWENA.do_stuff()
			_set_comment("One small step for man, one giant leap...")
			coffee_state = CoffeeState.GROUND
			$UI.add_to_inventory(Globals.Prop.COFFEE_BEANS_1, "Ground coffee")
			$UI.add_to_inventory(Globals.Prop.CUTTING_BOARD, "Cutting board")
			$UI.add_to_inventory(Globals.Prop.WOODEN_SPOON, "Wooden spoon")
		return true

	# coffee filter + cutting board (both must be in the inventory)

	if _check_objects(
		object1, object2, Globals.Prop.CUTTING_BOARD, Globals.Prop.COFFEE_FILTER):
		if ($UI.find_in_inventory(object1) < 0 or
			$UI.find_in_inventory(object2) < 0 or
			filter_state != FilterState.ORIGINAL):
			return false
		else:
			await $ROWENA.walk_to_area($BACKGROUND/Counter_Collider)
			await $ROWENA.do_stuff()
			_set_comment("All right!")
			filter_state = FilterState.ON_BOARD
			$UI.remove_from_inventory(Globals.Prop.CUTTING_BOARD)
			$UI.add_to_inventory(
				Globals.Prop.COFFEE_FILTER, "Coffee filter on cutting board")
		return true

	# knife + coffee filter on cutting board (they are both in drawers, so if
	# we get this far they must be in the inventory)

	if _check_objects(
		object1, object2, Globals.Prop.CUTLERY_KNIVES, Globals.Prop.COFFEE_FILTER):
		if filter_state != FilterState.ON_BOARD:
			return false
		elif $UI.is_inventory_full():
			_set_comment(inventory_full_msg)
		else:
			await $ROWENA.walk_to_area($BACKGROUND/Counter_Collider)
			await $ROWENA.do_stuff()
			_set_comment("OK, but just this once.")
			filter_state = FilterState.HALVED
			$UI.add_to_inventory(Globals.Prop.CUTTING_BOARD, "Cutting board")
			$UI.add_to_inventory(
				Globals.Prop.COFFEE_FILTER, "Coffee filter cut in half")
		return true

	# knife + scotch tape, or scotch tape on itself: cut a piece of tape (both
	# come from drawers so must be in the inventory)

	if (_check_objects(
			object1, object2, Globals.Prop.CUTLERY_KNIVES, Globals.Prop.SCOTCH_TAPE)
		or (object1 == Globals.Prop.SCOTCH_TAPE and object2 == object1)):
		if $UI.find_in_inventory(Globals.Prop.PIECE_OF_TAPE) >= 0:
			return false
		elif $UI.is_inventory_full():
			_set_comment(inventory_full_msg)
		else:
			await $ROWENA.walk_to_area($BACKGROUND/Counter_Collider)
			await $ROWENA.do_stuff()
			_set_comment("Clever me!")
			$UI.add_to_inventory(Globals.Prop.PIECE_OF_TAPE, "Piece of tape")
		return true

	# ground coffee + half coffee filter: put the coffee in the filter

	if _check_objects(
		object1, object2, Globals.Prop.COFFEE_BEANS_1, Globals.Prop.COFFEE_FILTER):
		if filter_state != FilterState.HALVED:
			return false
		else:
			await $ROWENA.walk_to_area($BACKGROUND/Counter_Collider)
			await $ROWENA.do_stuff()
			_set_comment("Clever me!")
			filter_state = FilterState.FULL
			$UI.add_to_inventory(
				Globals.Prop.COFFEE_FILTER, "Ground coffee in half a filter")
			$UI.remove_from_inventory(Globals.Prop.COFFEE_BEANS_1)
		return true

	# coffee in filter + piece of tape: coffee patch!
	# coffee patch + piece of tape: try the patch (doesn't work, too dry)

	if _check_objects(
		object1, object2, Globals.Prop.PIECE_OF_TAPE, Globals.Prop.COFFEE_FILTER):
		if filter_state == FilterState.FULL:
			await $ROWENA.walk_to_area($BACKGROUND/Counter_Collider)
			await $ROWENA.do_stuff()
			_set_comment("OK, now it's sealed.")
			filter_state = FilterState.SEALED
			$UI.add_to_inventory(Globals.Prop.COFFEE_FILTER, "Coffee patch")
			$UI.remove_from_inventory(Globals.Prop.PIECE_OF_TAPE)
		elif filter_state == FilterState.SEALED:
			await $ROWENA.walk_to_area($BACKGROUND/Counter_Collider)
			await $ROWENA.do_patch_stuff()
			await get_tree().create_timer(5).timeout
			_set_comment("Darn! This doesn't do anything.")
			await $UI.comment_closed
			await $ROWENA.do_patch_stuff()
			$UI.remove_from_inventory(Globals.Prop.PIECE_OF_TAPE)
		else:
			return false
		return true

	# sealed coffee patch + tap: end of chapter

	if _check_objects(
		object1, object2, Globals.Prop.COFFEE_FILTER, Globals.Prop.TAP):
		if filter_state != FilterState.SEALED:
			return false
		else:
			await $ROWENA.walk_to_area($BACKGROUND.get_collider(Globals.Prop.TAP), true)
			await $ROWENA.do_stuff($Running_Water)
			_set_comment("Yeah, that should make it more porous...")
			await $UI.comment_closed
			await $ROWENA.do_patch_stuff()
			await get_tree().create_timer(5).timeout
			_set_comment("Damn it, it doesn't work at all!")
			current_chapter += 1
			if not skip_dialogues:
				is_dialogue_seen = false
				await $UI.comment_closed
				await $UI.tell_story(current_chapter)
			is_dialogue_seen = true
		return true

	return false

func _use_object_chapter3(object1: int, object2: int) -> bool:

	# glass (in inventory) + tap: fill the glass with water

	if _check_objects(
		object1, object2, Globals.Prop.GLASSES, Globals.Prop.TAP):
		if $UI.find_in_inventory(Globals.Prop.GLASSES) < 0:
			return false
		elif is_glass_full:
			_set_comment("The glass is already full.")
		else:
			await $ROWENA.walk_to_area($BACKGROUND.get_collider(Globals.Prop.TAP), true)
			await $ROWENA.do_stuff($Running_Water)
			_set_comment("OK, but I won't drink it.")
			is_glass_full = true
			$UI.add_to_inventory(Globals.Prop.GLASSES, "Glass full of water")
		return true

	# glass of water (in inventory) + coffee maker: pour the water in

	if _check_objects(
		object1, object2, Globals.Prop.GLASSES, Globals.Prop.COFFEE_MAKER):
		if $UI.find_in_inventory(Globals.Prop.GLASSES) < 0:
			return false
		elif is_water_in_coffee_maker:
			_set_comment("One glass of water is enough.")
		elif not is_glass_full:
			_set_comment("There is nothing in the glass.")
		else:
			await $ROWENA.walk_to_area(
				$BACKGROUND.get_collider(Globals.Prop.COFFEE_MAKER), true)
			await $ROWENA.do_stuff()
			_set_comment("I'm strapped for time, so one glass will do.")
			is_glass_full = false
			is_water_in_coffee_maker = true
			$UI.add_to_inventory(Globals.Prop.GLASSES, "Empty glass")
		return true

	# used coffee (AKA trash, in inventory) + coffee maker: put the filter in
	# the coffee maker

	if _check_objects(
		object1, object2, Globals.Prop.TRASH, Globals.Prop.COFFEE_MAKER):
		if is_coffee_in_coffee_maker:
			_set_comment("The old filter is already in the coffee maker.")
		else:
			await $ROWENA.walk_to_area(
				$BACKGROUND.get_collider(Globals.Prop.COFFEE_MAKER), true)
			await $ROWENA.do_stuff()
			_set_comment("Don't think, don't think...")
			is_coffee_in_coffee_maker = true
			$UI.remove_from_inventory(Globals.Prop.TRASH)
		return true

	# red coffee cup (in inventory) + running coffee maker: taste and spit out

	if _check_objects(
		object1, object2, Globals.Prop.RED_COFFEE_CUP_LEFT, Globals.Prop.COFFEE_MAKER):
		if not is_coffee_maker_on:
			return false
		else:
			await $ROWENA.walk_to_area(
				$BACKGROUND.get_collider(Globals.Prop.COFFEE_MAKER), true)
			await $ROWENA.do_erk_stuff(true)
			_set_comment("Ugh! This is absolutely rancid!")
			await $UI.comment_closed
			end_game()
		return true

	return false

##
## Ends the game: Rowena gets a phone call from her boss, then goes back to
## bed.
##
func end_game():
	# game already ending: do nothing
	if game_over_status != GAME_IN_PROGRESS:
		return

	# start the phone ringing
	_start_ringing()

	# end game when we finish doing whatever we're doing
	if im_busy > 0:
		game_over_status = END_GAME_REQUESTED
	else:
		_on_end_game()

#
# Plays the end game sequence (phone call), then emits a game_over signal.
#
func _on_end_game():
	game_over_status = GAME_ENDING
	await $UI.abort_inventory_or_drawer()
	await get_tree().create_timer(phone_ring_time).timeout
	await $ROWENA.walk_to_area($BACKGROUND/Counter_Collider)
	await $ROWENA.play_phone_call_1()
	if not skip_dialogues:
		await $UI.tell_story(4)
	await $ROWENA.play_phone_call_2()
	_set_comment("That's it then...")
	await $UI.comment_closed
	_set_comment("Well. Back to bed.")
	await $UI.comment_closed
	await $ROWENA.walk_out_of_area($BACKGROUND/Room_Collider)
	game_over.emit()

#
# Starts the phone ringing until a phone_answered signal is emitted by ROWENA.
#
func _start_ringing():
	$Phone_Ring.play()
	$ROWENA.phone_answered.connect(func(): $Phone_Ring.stop(), CONNECT_ONE_SHOT)

#
# Callback invoked when the user tries to remove an item from the inventory
# (that is, put it down). The corresponding object in the scene is made visible
# again.
#
func _on_ui_trash_inventory_item(which: int):

	# special cases where the user cannot remove the item

	if current_chapter == 2:
		match which:
			Globals.Prop.COFFEE_BEANS_1:
				if coffee_state > CoffeeState.BEANS:
					return
			Globals.Prop.COFFEE_FILTER:
				if filter_state > FilterState.ORIGINAL:
					return

	# remove the item from the inventory, and close the inventory if it was the
	# last

	$UI.remove_from_inventory(which)
	if $UI.is_inventory_empty():
		$UI.close_inventory()

	# make the object visible in the scene again, but with special cases for
	# coffee beans: there are two colliders, but in the inventory they only
	# count for one item, plus they may be wrapped in the towel and may be on
	# the cutting board...

	if which == Globals.Prop.COFFEE_BEANS_1:
		if (coffee_beans_held & 1) and coffee_state < CoffeeState.GROUND:
			$BACKGROUND.set_object_visible(Globals.Prop.COFFEE_BEANS_1, true)
		if (coffee_beans_held & 2) and coffee_state < CoffeeState.GROUND:
			$BACKGROUND.set_object_visible(Globals.Prop.COFFEE_BEANS_2, true)
		if coffee_state in [CoffeeState.IN_TOWEL, CoffeeState.ON_BOARD]:
			$BACKGROUND.set_object_visible(Globals.Prop.TOWEL_SMALL, true)
		if coffee_state == CoffeeState.ON_BOARD:
			$BACKGROUND.set_object_visible(Globals.Prop.CUTTING_BOARD, true)
		coffee_beans_held = 0
		if coffee_state < CoffeeState.GROUND:
			coffee_state = CoffeeState.BEANS
	else:
		$BACKGROUND.set_object_visible(which, true)

func _on_rowena_target_area_reached():
	if is_quitting:
		if get_parent() == get_tree().root:
			get_tree().quit()
		else:
			quit.emit()

func _on_ui_quit_aborted():
	is_quitting = false
	$ROWENA.abort_walk_to_area()

func _show_junk_drawer():
	var contents = {}
	if $UI.find_in_inventory(Globals.Prop.COFFEE_FILTER) < 0:
		contents[Globals.Prop.COFFEE_FILTER] = "Coffee filter"
	if $UI.find_in_inventory(Globals.Prop.SCOTCH_TAPE) < 0:
		contents[Globals.Prop.SCOTCH_TAPE] = "Scotch tape"
	is_object_taken_from_drawer = false
	$UI.open_drawer(contents)

func _show_empty_drawer():
	_set_comment("It's empty.")

func _show_private_drawer():
	_set_comment("No one must know what's inside this drawer.")

func _show_kitchen_tools_drawer():
	var contents = {}
	if $UI.find_in_inventory(Globals.Prop.GARLIC_PRESS) < 0:
		contents[Globals.Prop.GARLIC_PRESS] = "Garlic press"
	if $UI.find_in_inventory(Globals.Prop.CORKSCREW) < 0:
		contents[Globals.Prop.CORKSCREW] = "Corkscrew"
	if $UI.find_in_inventory(Globals.Prop.WOODEN_SPOON) < 0:
		contents[Globals.Prop.WOODEN_SPOON] = "Wooden spoon"
	is_object_taken_from_drawer = false
	$UI.open_drawer(contents)

func _show_cutlery_drawer():
	var contents = {}
	if $UI.find_in_inventory(Globals.Prop.CUTLERY_FORKS) < 0:
		contents[Globals.Prop.CUTLERY_FORKS] = "Forks"
	if $UI.find_in_inventory(Globals.Prop.CUTLERY_KNIVES) < 0:
		contents[Globals.Prop.CUTLERY_KNIVES] = "Knives"
	if $UI.find_in_inventory(Globals.Prop.CUTLERY_SPOONS) < 0:
		contents[Globals.Prop.CUTLERY_SPOONS] = "Spoons"
	is_object_taken_from_drawer = false
	$UI.open_drawer(contents)

func _show_oven_bottom():
	var contents = {}
	if $UI.find_in_inventory(Globals.Prop.BURNT_PIZZA) < 0:
		contents[Globals.Prop.BURNT_PIZZA] = "Burnt pizza"
	is_object_taken_from_drawer = false
	$UI.open_drawer(contents)

func _on_ui_drawer_item_picked(which: int):
	if $UI.is_inventory_full():
		$UI.close_drawer()
		_set_comment(inventory_full_msg)
	else:
		var add_label = ""
		match which:
			Globals.Prop.COFFEE_FILTER:
				add_label = "Coffee filter"
			Globals.Prop.SCOTCH_TAPE:
				add_label = "Scotch tape"
			Globals.Prop.WOODEN_SPOON:
				add_label = "Wooden spoon"
			Globals.Prop.CUTLERY_FORKS:
				add_label = "Fork"
			Globals.Prop.CUTLERY_KNIVES:
				add_label = "Knife"
			Globals.Prop.CUTLERY_SPOONS:
				add_label = "Spoon"
		if add_label:
			is_object_taken_from_drawer = true
			$UI.add_to_inventory(which, add_label)
			$UI.remove_from_drawer(which)

func _on_ui_drawer_closed():
	match $BACKGROUND.get_open_object():
		Globals.Prop.DRAWER_LEFT_1:
			if is_object_taken_from_drawer:
				_set_comment("Could be useful. Some day...")
			else:
				_set_comment("Maybe next time...")
		Globals.Prop.KITCHEN_TOOLS_DRAWER:
			if is_object_taken_from_drawer:
				_set_comment("My childhood dream was to have a wooden spoon...")
			else:
				_set_comment("Never mind...")
		Globals.Prop.CUTLERY_DRAWER:
			if is_object_taken_from_drawer:
				const reactions = [
					"Great!",
					"Amazing!",
					"Wonderful!",
					"Yeah! Rock & roll!",
				]
				var which = randi_range(0, reactions.size() - 1)
				_set_comment(reactions[which])
			else:
				_set_comment("Well, anyway...")

##
## Returns a Dictionary containing data to save the game for later.
##
func save_game() -> Dictionary:
	var dict = {
		"chapter": current_chapter,
		"is-dialogue-seen": is_dialogue_seen,
		"butter-knife-seen": butter_knife_seen,
		"coffee-maker-seen": coffee_maker_seen,
		"is-towel-wet": is_towel_wet,
		"coffee-beans-held": coffee_beans_held,
		"coffee-state": coffee_state,
		"filter-state": filter_state,
		"is-glass-full": is_glass_full,
		"is-water-in-coffee-maker": is_water_in_coffee_maker,
		"is-coffee-in-coffee-maker": is_coffee_in_coffee_maker,
		"is-coffee-maker-on": is_coffee_maker_on,
		"props-seen": props_seen,
		"inventory": $UI.get_inventory(),
		"tutorial-seen": $UI.is_tutorial_seen(),
		"open-object": $BACKGROUND.get_open_object(),
		"radio-volume": _get_radio_volume(),
		"elapsed-time": Globals.get_elapsed_time(),
	}
	return dict

##
## Processes a Dictionary saved previously by [method save_game].
##
func load_game(dict: Dictionary):
	current_chapter = dict.get("chapter", 1)
	is_dialogue_seen = dict.get("is-dialogue-seen", false)
	butter_knife_seen = dict.get("butter-knife-seen", false)
	coffee_maker_seen = dict.get("coffee-maker-seen", false)
	is_towel_wet = dict.get("is-towel-wet", false)
	coffee_beans_held = dict.get("coffee-beans-held", 0)
	coffee_state = dict.get("coffee-state", CoffeeState.BEANS)
	filter_state = dict.get("filter-state", FilterState.ORIGINAL)
	is_glass_full = dict.get("is-glass-full", false)
	is_water_in_coffee_maker = dict.get("is-water-in-coffee-maker", false)
	is_coffee_in_coffee_maker = dict.get("is-coffee-in-coffee-maker", false)
	is_coffee_maker_on = dict.get("is-coffee-maker-on", false)
	props_seen = dict.get("props-seen", [])

	if (coffee_beans_held & 1) or coffee_state == CoffeeState.GROUND:
		$BACKGROUND.set_object_visible(Globals.Prop.COFFEE_BEANS_1, false)
	if (coffee_beans_held & 2) or coffee_state == CoffeeState.GROUND:
		$BACKGROUND.set_object_visible(Globals.Prop.COFFEE_BEANS_2, false)
	if coffee_state in [CoffeeState.IN_TOWEL, CoffeeState.ON_BOARD]:
		$BACKGROUND.set_object_visible(Globals.Prop.TOWEL_SMALL, false)
	if coffee_state == CoffeeState.ON_BOARD or filter_state == FilterState.ON_BOARD:
		$BACKGROUND.set_object_visible(Globals.Prop.CUTTING_BOARD, false)

	$UI.clear_inventory()
	var inventory = dict.get("inventory", {})
	for item in inventory:
		var index = item as int
		$UI.add_to_inventory(index, inventory[item])
		if index != Globals.Prop.COFFEE_BEANS_1:
			$BACKGROUND.set_object_visible(index, false)

	if dict.has("tutorial-seen"):
		if dict["tutorial-seen"]:
			$UI.unpin_help_button()
		else:
			$UI.pin_help_button()

	var open_object = dict.get("open-object", -1)
	if open_object >= 0:
		$BACKGROUND.open_something(open_object, false)
	
	_set_radio_volume(dict.get("radio-volume", -8))
	Globals.play_radio_at(dict.get("elapsed-time", 0))
	
	if not is_dialogue_seen:
		if not skip_dialogues:
			await $UI.tell_story(current_chapter)
		is_dialogue_seen = true

func _on_ui_typing_finished(speaker: int):
	if speaker == Globals.DOCTOR:
		$ROWENA.respond_to_doctor_maybe()

#
# Returns the current radio volume in dB.
#
func _get_radio_volume():
	var bus = AudioServer.get_bus_index(&"MUSIC")
	if bus < 0:
		return volume_presets[0]
	else:
		return AudioServer.get_bus_volume_db(bus)

#
# Sets the radio volume to the given value in dB. If the given volume is not
# found in volume_presets, a nearby value is used instead.
#
func _set_radio_volume(volume):
	_set_radio_volume_preset(volume_presets.bsearch(volume))

#
# Sets the radio volume to the given preset, which is an index into
# volume_presets. Returns the new volume.
#
func _set_radio_volume_preset(preset: int):
	var bus = AudioServer.get_bus_index(&"MUSIC")
	if bus < 0:
		return AudioServer.get_bus_volume_db(bus)
	preset = clampi(preset, 0, volume_presets.size() - 1)
	AudioServer.set_bus_volume_db(bus, volume_presets[preset])
	$BACKGROUND.set_radio_light_on(preset > 0)
	return volume_presets[preset]

#
# Turns the radio volume up, down or off.
#
func _adjust_radio_volume(cursor: int):
	var volume = _get_radio_volume()
	var old_preset = volume_presets.bsearch(volume)
	var new_preset

	match cursor:
		Globals.Cursor.SOUND_UP:
			new_preset = old_preset + 1
		Globals.Cursor.SOUND_DOWN:
			new_preset = old_preset - 1
		Globals.Cursor.NO_SOUND:
			new_preset = 0

	volume = _set_radio_volume_preset(new_preset)
	new_preset = volume_presets.bsearch(volume)

	if new_preset != old_preset:
		match cursor:
			Globals.Cursor.SOUND_UP:
				$Volume_Up.play()
			Globals.Cursor.SOUND_DOWN:
				$Volume_Down.play()
				# show NO_SOUND cursor when volume is turned all the way down
				if new_preset == 0:
					$UI.next_cursor()

func _turn_on_coffee_maker():
	_set_busy()
	await $ROWENA.walk_to_area(
		$BACKGROUND.get_collider(Globals.Prop.COFFEE_MAKER), true)
	await $ROWENA.do_stuff($Beep)
	_set_comment("I can't believe I'm doing this...")
	await $UI.comment_closed
	$Coffee_Ready.play()
	is_coffee_maker_on = true
	_clear_busy()

func _is_prop_seen(which: int) -> bool:
	var i = props_seen.bsearch(which)
	return i < props_seen.size() and props_seen[i] == which

func _set_prop_seen(which: int):
	var i = props_seen.bsearch(which)
	if i == props_seen.size() or props_seen[i] != which:
		props_seen.insert(i, which)
