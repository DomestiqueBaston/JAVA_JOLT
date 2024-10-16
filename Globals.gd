##
## Defines enums and methods available to all scenes in the project.
##
extends Node

## Characters in the game.
enum { ROWENA, DOCTOR, BOSS }

## Mouse cursors defined in the UI scene.
enum Cursor {
	CROSS_PASSIVE,
	CROSS_ACTIVE,
	CROSS_ACTIVE_NEVER_SEEN,
	ARROW_PASSIVE,
	ARROW_ACTIVE,
	SOUND_UP,
	SOUND_DOWN,
	NO_SOUND,
	EYE,
	HAND,
	OPEN,
	CLOSE,
	LOAD,
	SAVE,
	QUIT,
	TRASH,
	CURSOR_COUNT # must be last
}

## Objects defined in the BACKGROUND scene.
enum Prop {
	
	# props that are not inside something else, so they are always visible
	# (unless they are temporarily hidden behind an open door, for example)
	
	KITCHEN_CABINET,
	RECYCLING_CLOSET,
	UNDER_SINK_CABINET,
	CLEANING_CLOSET,
	DRAWER_LEFT_1,
	DRAWER_LEFT_2,
	DRAWER_LEFT_3,
	PRIVATE_DRAWER,
	KITCHEN_TOOLS_DRAWER,
	CUTLERY_DRAWER,
	OVEN,
	OVEN_BOTTOM,
	DISHWASHER,
	STOOL,
	CHAIR,
	TOWEL_LARGE,
	TOWEL_SMALL,
	TOP_LEFT_UNUSED_CUPBOARD,
	LEFT_GLASS_CUPBOARD,
	TOP_CENTER_UNUSED_CUPBOARD,
	RIGHT_GLASS_CUPBOARD,
	CUPBOARD_UPPER_CENTER_LEFT,
	CUPBOARD_UPPER_CENTER,
	COFFEE_CUPBOARD,
	UPPER_RIGHT_CUPBOARD,
	MICROWAVE,
	WINDOW_RIGHT,
	WINDOW_LEFT,
	SPOILED_MILK,
	COFFEE_MAKER,
	RADIO,
	REFRIGERATOR_RIGHT,
	REFRIGERATOR_LEFT,
	REFRIGERATOR_LEFT_WATER_ICE,
	PAINTING,
	LIGHT_SWITCH_LEFT,
	LIGHT_SWITCH_RIGHT,
	YUCCA,
	OLIVE_OIL_BOTTLE,
	SALT,
	TOASTER,
	NOTCHED_COFFEE_CUP_RIGHT,
	PEPPER,
	RICE_POT,
	COOKIE_POT,
	TAP,
	PLASTIC_BOXES,
	MANDOLIN,
	FOOD_PROCESSOR,
	RED_COFFEE_CUP_LEFT,
	BROWN_COFFEE_CUP,
	KNIFE_BLOCK,
	FRUIT_BASKET,
	CUTTING_BOARD,
	PRESSURE_COOKER,
	KETTLE,
	SAUCE_PAN,
	COFFEE_BEANS_1,
	COFFEE_BEANS_2,
	NEWSPAPER,
	MAIN_PROP_COUNT, # must follow the last of the main props
	
	# props visible when the refrigerator door is open
	
	REFRIGERATOR_RIGHT_BEGIN=MAIN_PROP_COUNT,
	SMOOTHIE_BOTTLES=REFRIGERATOR_RIGHT_BEGIN,
	FRUIT_JUICE_BOTTLES,
	MILK_BOTTLES,
	BUTTER_KNIFE,
	CREAM_POTS,
	YOGHURTS,
	SAUCE_PAN_IN_FRIDGE,
	EGGS,
	GREEN_PEPPER,
	TOMATOES,
	CAULIFLOWER,
	YELLOW_PEPPER,
	FRUIT,
	REFRIGERATOR_RIGHT_OPEN_DOOR,
	REFRIGERATOR_RIGHT_END=REFRIGERATOR_RIGHT_OPEN_DOOR,
	
	# props visible when the freezer door is open
	
	REFRIGERATOR_LEFT_BEGIN,
	PIZZA_DRAWER=REFRIGERATOR_LEFT_BEGIN,
	VEGETABLE_DRAWER,
	LASAGNA_DRAWER,
	ICE_CREAM_DRAWER,
	MEAT_DRAWER,
	REFRIGERATOR_LEFT_OPEN_DOOR,
	REFRIGERATOR_LEFT_END=REFRIGERATOR_LEFT_OPEN_DOOR,
	
	# props visible when the coffee cupboard is open
	
	COFFEE_CUPBOARD_BEGIN,
	EMPTY_COFFEE_SPACE=COFFEE_CUPBOARD_BEGIN,
	CANNED_GREEN_BEANS_1,
	CANNED_GREEN_BEANS_2,
	CANNED_BEANS_1,
	CANNED_BEANS_2,
	COFFEE_CUPBOARD_OPEN_DOOR,
	COFFEE_CUPBOARD_END=COFFEE_CUPBOARD_OPEN_DOOR,
	
	# props visible when the dishwasher is open
	
	DISHWASHER_BEGIN,
	DISHWASHER_TOP=DISHWASHER_BEGIN,
	DISHWASHER_MIDDLE,
	DISHWASHER_BOTTOM,
	DISHWASHER_OPEN_DOOR,
	DISHWASHER_END=DISHWASHER_OPEN_DOOR,
	
	# props visible when the cabinet under the sink is open
	
	UNDER_SINK_BEGIN,
	EXTINGUISHER=UNDER_SINK_BEGIN,
	PLASTIC_BASKETS,
	PLUNGER,
	TRASH,
	UNDER_SINK_OPEN_DOOR,
	UNDER_SINK_END=UNDER_SINK_OPEN_DOOR,
	
	# props visible when the upper right cupboard is open
	
	UPPER_RIGHT_CUPBOARD_BEGIN,
	COOKING_POT=UPPER_RIGHT_CUPBOARD_BEGIN,
	HUGE_PRESSURE_COOKER,
	SAUCE_PAN_SET,
	SALAD_BOWLS,
	UPPER_RIGHT_CUPBOARD_OPEN_DOOR,
	UPPER_RIGHT_CUPBOARD_END=UPPER_RIGHT_CUPBOARD_OPEN_DOOR,
	
	# props visible when the cleaning closet is open
	
	CLEANING_CLOSET_BEGIN,
	DRAIN_CLEANER=CLEANING_CLOSET_BEGIN,
	MOP,
	DETERGENT,
	LARGE_BUCKET,
	SMALL_BUCKET,
	DUST_PAN_BRUSH,
	CLEANING_CLOSET_OPEN_DOOR,
	CLEANING_CLOSET_END=CLEANING_CLOSET_OPEN_DOOR,
	
	# props visible when the upper center cupboard is open
	
	CUPBOARD_UPPER_CENTER_BEGIN,
	LARGE_COOKIE_BOX=CUPBOARD_UPPER_CENTER_BEGIN,
	SMALL_COOKIE_BOX,
	TEA_BOX_1,
	TEA_BOX_2,
	TEA_BOX_3,
	TEA_BOX_4,
	TEA_BOX_5,
	CUPBOARD_UPPER_CENTER_OPEN_DOOR,
	CUPBOARD_UPPER_CENTER_END=CUPBOARD_UPPER_CENTER_OPEN_DOOR,
	
	# props visible when the oven is open
	
	OVEN_BEGIN,
	OVEN_EMPTY_SPACE_1=OVEN_BEGIN,
	OVEN_EMPTY_SPACE_2,
	OVEN_EMPTY_SPACE_3,
	OVEN_OPEN_DOOR,
	OVEN_END=OVEN_OPEN_DOOR,
	
	# props visible when the microwave is open
	
	MICROWAVE_BEGIN,
	MICROWAVE_PIZZA=MICROWAVE_BEGIN,
	MICROWAVE_OPEN_DOOR,
	MICROWAVE_END=MICROWAVE_OPEN_DOOR,
	
	# props visible when the upper center left cupboard is open
	
	CUPBOARD_UPPER_CENTER_LEFT_BEGIN,
	SMALL_WINE_GLASSES=CUPBOARD_UPPER_CENTER_LEFT_BEGIN,
	LARGE_GLASSES,
	SOUP_PLATES,
	CUPBOARD_UPPER_CENTER_LEFT_OPEN_DOOR,
	CUPBOARD_UPPER_CENTER_LEFT_END=CUPBOARD_UPPER_CENTER_LEFT_OPEN_DOOR,
	
	# props visible when the kitchen cabinet is open
	
	KITCHEN_CABINET_BEGIN,
	RICE_COOKER=KITCHEN_CABINET_BEGIN,
	PRESSURE_COOKER_2,
	KITCHEN_CABINET_OPEN_DOOR,
	KITCHEN_CABINET_END=KITCHEN_CABINET_OPEN_DOOR,
	
	# props visible when the left glass cupboard is open
	
	LEFT_GLASS_CUPBOARD_BEGIN,
	WINE_GLASSES=LEFT_GLASS_CUPBOARD_BEGIN,
	GLASSES,
	PLATES,
	LEFT_GLASS_CUPBOARD_OPEN_DOOR,
	LEFT_GLASS_CUPBOARD_END=LEFT_GLASS_CUPBOARD_OPEN_DOOR,
	
	# props visible when the recycling closet is open
	
	RECYCLING_CLOSET_BEGIN,
	RECYCLING=RECYCLING_CLOSET_BEGIN,
	RECYCLING_CLOSET_OPEN_DOOR,
	RECYCLING_CLOSET_END=RECYCLING_CLOSET_OPEN_DOOR,
	
	# props visible when the right glass cupboard is open
	
	RIGHT_GLASS_CUPBOARD_BEGIN,
	BOWLS=RIGHT_GLASS_CUPBOARD_BEGIN,
	LARGE_BOWLS,
	PLATES_2,
	RIGHT_GLASS_CUPBOARD_OPEN_DOOR,
	RIGHT_GLASS_CUPBOARD_END=RIGHT_GLASS_CUPBOARD_OPEN_DOOR,
	
	# open drawers
	
	DRAWER_LEFT_1_OPEN,
	DRAWER_LEFT_2_OPEN,
	DRAWER_LEFT_3_OPEN,
	PRIVATE_DRAWER_OPEN,
	KITCHEN_TOOLS_DRAWER_OPEN,
	CUTLERY_DRAWER_OPEN,
	OVEN_BOTTOM_OPEN,
	
	# props below VISIBLE_PROP_COUNT are not actually visible in the scene, so
	# they have no colliders (e.g. the contents of drawers)
	
	VISIBLE_PROP_COUNT,
	
	COFFEE_FILTER,
	SCOTCH_TAPE,
	GARLIC_PRESS,
	CORKSCREW,
	WOODEN_SPOON,
	CUTLERY_FORKS,
	CUTLERY_KNIVES,
	CUTLERY_SPOONS,
	BURNT_PIZZA,
	PIECE_OF_TAPE,
}

## If true, only our big cursor is visible.
@export var hide_system_mouse := false

## How long before the end of the radio program [signal radio_done] is emitted.
@export var radio_done_margin := 1.0

## Signal emitted just before the radio program ends.
signal radio_done

# Time corresponding to the start of the radio program, in milliseconds
# relative to the time the engine started: see Time.get_ticks_msec().
var _start_time: int

func _ready():
	if hide_system_mouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("full_screen", false, true):
		get_viewport().set_input_as_handled()
		var win = get_window()
		if win.mode == Window.MODE_WINDOWED:
			win.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
		else:
			win.mode = Window.MODE_WINDOWED

##
## Plays the radio starting at time [param t]. If the radio is already playing,
## it skips to [param t].
##
func play_radio_at(t: float = 0):
	_start_time = Time.get_ticks_msec() - roundi(t * 1000.0)
	$RadioPlayer.play(t)
	var end_time = $RadioPlayer.stream.get_length() - radio_done_margin
	if t < end_time:
		$RadioTimer.start(end_time - t)

func _on_radio_timer_timeout():
	radio_done.emit()

##
## Turns the radio off, if it is playing.
##
func stop_radio():
	$RadioPlayer.stop()

##
## Returns the time elapsed since the beginning of the radio program, in
## seconds.
##
func get_elapsed_time() -> float:
	return (Time.get_ticks_msec() - _start_time) / 1000.0
