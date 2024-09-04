extends Node

## Mouse cursors defined in the UI scene.
enum Cursor {
	CROSS_PASSIVE,
	CROSS_ACTIVE,
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
	MICROWAVE_OVEN,
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
	
	TOTAL_PROP_COUNT # must be last
}
