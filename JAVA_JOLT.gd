extends Node2D

# MANIPULATING OBJECTS
#
# If the user can take an object, add the HAND cursor action when the object is
# made current in _update_current_prop(). Then, in _perform_hand_action(), add
# the object to the inventory if it is the current prop. If the object is to be
# hidden from sight when it has been taken (the small towel, for example), add
# it to the list of singleton objects in _on_background_area_entered_object(),
# and show/hide it in the BACKGROUND scene: add the appropriate image to the
# Removed_Objects node there and handle it in $BACKGROUND.set_object_visible().
# That function must also be modified if the object is not a singleton but its
# visual aspect changes (e.g. to hide one milk bottle or the coffee maker's
# filter holder).

## At this distance from an open object (e.g. the refrigerator), we close it
## automatically rather than make Rowena walk back to it.
@export var auto_close_distance = 60

## Which dialogue to start with (for testing), 0 for none.
@export_range(0, 3) var dialogue_number: int = 0

# The prop currently under the mouse cursor (see Globals.Prop), or -1.
var current_prop: int = -1

# Dictionary containing all the background object colliders that are currently
# in contact with the mouse cursor. Keys are prop numbers (see Globals.prop);
# values are Area2D instances.
var overlapping_colliders = {}

const prop_info: Array[String] = [
	# KITCHEN_CABINET
	"That's a cabinet...",
	# RECYCLING_CLOSET
	"That's the recycling.",
	# UNDERSINK_CABINET
	"Oh my god! What's in there?",
	# CLEANING_CLOSET
	"That's where I put my cleaning stuff.",
	# DRAWER_LEFT_1
	"That's my junk drawer.",
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
	"That's a big towel.",
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
	# MICROWAVE_OVEN
	"The microwave works. If I turn it on...",
	# WINDOW_RIGHT
	"That's a big window.",
	# WINDOW_LEFT
	"I know what that is: it's a window!",
	# SPOILED_MILK
	"That's just some sour milk.",
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
	"That's a painting called \"Monsieur le Marquis et Madame\".",
	# LIGHT_SWITCH_LEFT
	"I’m no Hubert Bonisseur de la Bath...",
	# LIGHT_SWITCH_RIGHT
	"I’m no Hubert Bonisseur de la Bath...",
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
	"Tupperware. I know how to make them fart!",
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
]

const open_close_height: Dictionary = {
	Globals.Prop.DISHWASHER: 1,
	Globals.Prop.DISHWASHER_OPEN_DOOR: 1,
	Globals.Prop.COFFEE_CUPBOARD: 4,
	Globals.Prop.COFFEE_CUPBOARD_OPEN_DOOR: 4,
	Globals.Prop.REFRIGERATOR_RIGHT: 3,
	Globals.Prop.REFRIGERATOR_RIGHT_OPEN_DOOR: 3,
	Globals.Prop.REFRIGERATOR_LEFT: 3,
	Globals.Prop.REFRIGERATOR_LEFT_OPEN_DOOR: 3,
}

const open_close_door: Dictionary = {
	Globals.Prop.DISHWASHER: Globals.Prop.DISHWASHER_OPEN_DOOR,
	Globals.Prop.COFFEE_CUPBOARD: Globals.Prop.COFFEE_CUPBOARD_OPEN_DOOR,
	Globals.Prop.REFRIGERATOR_RIGHT: Globals.Prop.REFRIGERATOR_RIGHT_OPEN_DOOR,
	Globals.Prop.REFRIGERATOR_LEFT: Globals.Prop.REFRIGERATOR_LEFT_OPEN_DOOR,
}

const inventory_full_msg = "Hey, I don't have 4 arms, I'm not Shiva!"

const cant_use_msgs = [
	"That doesn't ring a bell for me.",
	"Maybe some other time.",
	"Yeah, or I could just lick the floor...",
	"No way, Jose!",
]

var butter_knife_seen = false
var coffee_maker_seen = false
var is_towel_wet = false

func _ready():
	assert(prop_info.size() == Globals.Prop.TOTAL_PROP_COUNT)
	if dialogue_number > 0:
		await $UI.tell_story(dialogue_number)
	$UI.pin_help_button()

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
	$UI.set_comment_text(text, x, left_justify)

func _on_ui_click_on_background(pos: Vector2):
	match $UI.get_current_cursor():
		Globals.Cursor.CROSS_PASSIVE, Globals.Cursor.CROSS_ACTIVE:
			$UI.clear_comment_text()
			$ROWENA.walk_to_x(pos.x)
		Globals.Cursor.ARROW_PASSIVE:
			$UI.stop_using_inventory_item()
		Globals.Cursor.ARROW_ACTIVE:
			_use_object_on_other($UI.get_inventory_item_being_used(), current_prop)
			$UI.stop_using_inventory_item()
		Globals.Cursor.EYE:
			_perform_eye_action(pos)
		Globals.Cursor.HAND:
			_perform_hand_action()
		Globals.Cursor.OPEN:
			_perform_open_action()
		Globals.Cursor.CLOSE:
			_perform_close_action()
		Globals.Cursor.QUIT:
			$UI.clear_comment_text()
			await _close_open_object(false)
			await _walk_to_prop()
			get_tree().quit()

func _perform_eye_action(pos: Vector2):
	$ROWENA.look_at_x(pos.x)
	if current_prop < 0:
		return
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

	var take_label = ""
	var take_msg = ""
	var take_height = 0
	var take_sound = false

	match current_prop:
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
			take_height = 1
		Globals.Prop.REFRIGERATOR_LEFT_WATER_ICE:
			_set_comment("Where in the world have you been until now?")
		Globals.Prop.OLIVE_OIL_BOTTLE:
			take_label = "Olive oil"
			take_msg = "OK, but it's just to please you."
			take_height = 3
		Globals.Prop.SALT:
			take_label = "Salt"
			take_msg = "I'll never use it with my coffee, but OK."
			take_height = 3
		Globals.Prop.TOASTER:
			_set_comment("It works and I can use it any time.")
		Globals.Prop.NOTCHED_COFFEE_CUP_RIGHT:
			_set_comment("No, I chipped it yesterday.")
		Globals.Prop.PEPPER:
			take_label = "Pepper"
			take_msg = "You always need some pepper!"
			take_height = 3
		Globals.Prop.RICE_POT:
			_set_comment("No, it's raw.")
		Globals.Prop.COOKIE_POT:
			take_label = "Cookie"
			take_msg = "Only one. But I need my coffee first."
			take_height = 3
		Globals.Prop.TAP:
			_set_comment("Yes. And?")
		Globals.Prop.MANDOLIN:
			take_label = "Vegetable slicer"
			take_msg = "As long as I don't slice my fingers off."
			take_height = 3
		Globals.Prop.FOOD_PROCESSOR:
			_set_comment("It's not a Rank Xerox, no way.")
		Globals.Prop.RED_COFFEE_CUP_LEFT:
			take_label = "Coffee cup"
			take_msg = "Yeah, it's new and clean."
			take_height = 3
		Globals.Prop.BROWN_COFFEE_CUP:
			_set_comment("That's not my cup of tea.")
		Globals.Prop.FRUIT_BASKET:
			take_label = "Red apple"
			take_msg = "Just a red apple, nothing more."
			take_height = 3
		Globals.Prop.PRESSURE_COOKER:
			_set_comment("There's no way I'm dragging that around.")
		Globals.Prop.KETTLE:
			take_label = "Tea kettle"
			take_msg = "OK, if you say so."
			take_height = 3
		Globals.Prop.SAUCE_PAN:
			_set_comment("No, there's still sauce in it.")
		Globals.Prop.SMOOTHIE_BOTTLES:
			take_label = "Smoothie"
			take_msg = "I drink it before working out. But OK, one."
			take_height = 3
		Globals.Prop.FRUIT_JUICE_BOTTLES:
			take_label = "Fruit juice"
			take_msg = "I drink it before working out. But one is OK."
			take_height = 2
		Globals.Prop.MILK_BOTTLES:
			take_label = "Bottle of milk"
			take_msg = "OK, one bottle of milk."
			take_height = 1
		Globals.Prop.BUTTER_KNIFE:
			if butter_knife_seen:
				take_label = "Butter knife"
				take_msg = "OK, I'll just take that knife."
			else:
				_set_comment("Remember? Coffee...")
			take_height = 4
		Globals.Prop.CREAM_POTS:
			_set_comment("Not now.")
		Globals.Prop.YOGHURTS:
			take_label = "Yoghurt"
			take_msg = "OK, OK..."
			take_height = 3
		Globals.Prop.SAUCE_PAN_IN_FRIDGE:
			_set_comment("Yeah, I'll leave that there.")
		Globals.Prop.EGGS:
			take_label = "Egg"
			take_msg = "OK but I need to be extra careful."
			take_height = 2
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

	if take_label:
		if $UI.is_inventory_full():
			_set_comment(inventory_full_msg)
		else:
			# because walking will change the current prop...
			var take_prop = current_prop
			await _walk_to_prop()
			_set_comment(take_msg)
			$ROWENA.get_something(take_height, take_sound)
			await $ROWENA.get_something_reached
			$UI.add_to_inventory(take_prop, take_label)
			$BACKGROUND.set_object_visible(take_prop, false)
			await $ROWENA.get_something_done

func _perform_open_action():
	$UI.clear_comment_text()
	$UI.clear_available_cursors()

	var object_to_open = current_prop
	var height = _get_open_close_height(object_to_open)

	await _close_open_object(true)
	await _walk_to_prop(object_to_open)
	$ROWENA.get_something(height, false)
	await $ROWENA.get_something_reached
	$BACKGROUND.open_something(object_to_open)
	await $ROWENA.get_something_done
	
	if object_to_open == Globals.Prop.COFFEE_CUPBOARD:
		_set_comment("I like rubbing salt in the wound.")

func _perform_close_action():
	$UI.clear_comment_text()
	$UI.clear_available_cursors()

	var height = _get_open_close_height(current_prop)

	await _walk_to_prop()
	$ROWENA.get_something(height, false)
	await $ROWENA.get_something_reached
	$BACKGROUND.close_something()
	await $ROWENA.get_something_done

	_recompute_overlapping_colliders()

func _close_open_object(always_make_the_trip: bool):
	var which = $BACKGROUND.get_open_object()
	if which < 0:
		return

	var door = open_close_door[which]
	var height = _get_open_close_height(which)

	if (always_make_the_trip or
		_get_distance_from_prop(door) < auto_close_distance):
		await _walk_to_prop(door)
		$ROWENA.get_something(height, false)
		await $ROWENA.get_something_reached
		$BACKGROUND.close_something()
		await $ROWENA.get_something_done
	else:
		$BACKGROUND.close_something()

	_recompute_overlapping_colliders()

func _get_open_close_height(which: int) -> int:
	var height = open_close_height[which]
	if height >= 4:
		height = randi_range(4, 5)
	return height

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
# NB. This will only work properly if the given object's collider (an Area2D) is
# positioned correctly (its origin is at the center of its shape), and if its
# collision mask includes Rowena's movements (layer 3).
#
func _walk_to_prop(which: int = -1, walk_to_origin: bool = false):
	if which < 0:
		which = current_prop
	var area = $BACKGROUND.get_collider(which)
	$ROWENA.look_at_x(area.global_position.x)
	await $ROWENA.walk_to_area(area, walk_to_origin)

#
# Callback invoked when the mouse collider (_area) enters the Area2D of a
# background object (the prop identified by which: see Globals.Prop). The
# current prop, and available cursor actions, are updated as appropriate.
#
func _on_background_area_entered_object(which: int, _area: Area2D):

	# some objects are hidden if the user has taken them, so ignore them

	const singleton_objects = [
		Globals.Prop.TOWEL_SMALL,
		Globals.Prop.OLIVE_OIL_BOTTLE,
		Globals.Prop.SALT,
		Globals.Prop.PEPPER,
		Globals.Prop.MANDOLIN,
		Globals.Prop.RED_COFFEE_CUP_LEFT,
		Globals.Prop.KETTLE,
	]
	if which in singleton_objects and $UI.find_in_inventory(which) >= 0:
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

func _get_prop_name(prop) -> String:
	var prop_name
	if typeof(prop) == TYPE_INT:
		prop_name = $BACKGROUND.get_collider(prop).name
	else:
		prop_name = prop.name
	return prop_name.to_lower().replace("_collider", "").replace("_", " ")

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
	var top_collider: Area2D

	# fetch the topmost object in contact with the mouse collider

	if not overlapping_colliders.is_empty():
		var bg_level = -1
		for key in overlapping_colliders.keys():
			var collider: Area2D = overlapping_colliders[key]
			var level = collider.get_meta(&"bg_level", 0)
			if bg_level < level:
				bg_level = level
				top_prop = key
				top_collider = collider

	# already the current prop: do nothing

	if current_prop == top_prop:
		return

	# if the refrigerator door is open (for example), the closed door remains
	# in the scene; ignore it

	if top_prop >= 0 and top_prop == $BACKGROUND.get_open_object():
		current_prop = -1
	else:
		current_prop = top_prop

	# update the list of available cursor actions

	if current_prop < 0:
		$UI.clear_available_cursors()
		return

	print(_get_prop_name(top_collider))
	var actions: Array[int] = [Globals.Cursor.CROSS_ACTIVE, Globals.Cursor.EYE]

	match current_prop:
		Globals.Prop.DISHWASHER, \
		Globals.Prop.COFFEE_CUPBOARD, \
		Globals.Prop.REFRIGERATOR_RIGHT, \
		Globals.Prop.REFRIGERATOR_LEFT:
			actions.append(Globals.Cursor.OPEN)

		Globals.Prop.DISHWASHER_OPEN_DOOR, \
		Globals.Prop.COFFEE_CUPBOARD_OPEN_DOOR, \
		Globals.Prop.REFRIGERATOR_RIGHT_OPEN_DOOR, \
		Globals.Prop.REFRIGERATOR_LEFT_OPEN_DOOR:
			actions.append(Globals.Cursor.CLOSE)

		Globals.Prop.REFRIGERATOR_LEFT_WATER_ICE, \
		Globals.Prop.OLIVE_OIL_BOTTLE, \
		Globals.Prop.SALT, \
		Globals.Prop.TOASTER, \
		Globals.Prop.NOTCHED_COFFEE_CUP_RIGHT, \
		Globals.Prop.PEPPER, \
		Globals.Prop.RICE_POT, \
		Globals.Prop.COOKIE_POT, \
		Globals.Prop.TAP, \
		Globals.Prop.MANDOLIN, \
		Globals.Prop.FOOD_PROCESSOR, \
		Globals.Prop.RED_COFFEE_CUP_LEFT, \
		Globals.Prop.BROWN_COFFEE_CUP, \
		Globals.Prop.FRUIT_BASKET, \
		Globals.Prop.PRESSURE_COOKER, \
		Globals.Prop.KETTLE, \
		Globals.Prop.SAUCE_PAN, \
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
		Globals.Prop.DISHWASHER_BOTTOM:
			if $UI.find_in_inventory(current_prop) < 0:
				actions.append(Globals.Cursor.HAND)

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

	# butter knife + coffee maker: add the filter holder to the inventory

	if _check_objects(
		object1, object2, Globals.Prop.BUTTER_KNIFE, Globals.Prop.COFFEE_MAKER):
		if not coffee_maker_seen:
			_set_comment("That's not my sparring partner.")
		elif $UI.is_inventory_full():
			_set_comment("Hey, I'm not going around with Santa's bag!")
		else:
			await _walk_to_prop(Globals.Prop.COFFEE_MAKER, true)
			await $ROWENA.do_stuff(true)
			_set_comment("I got the filter holder out intact!")
			$UI.add_to_inventory(Globals.Prop.COFFEE_MAKER, "Coffee filter holder")
			$BACKGROUND.set_object_visible(Globals.Prop.COFFEE_MAKER, false)

	# milk bottle + small towel: moisten the towel and update the inventory
	# (both objects must be in the inventory)

	elif _check_objects(
		object1, object2, Globals.Prop.MILK_BOTTLES, Globals.Prop.TOWEL_SMALL):
			if ($UI.find_in_inventory(object1) < 0 or
				$UI.find_in_inventory(object2) < 0):
				pass
			elif is_towel_wet:
				_set_comment("The towel is already moist.")
			else:
				await $ROWENA.walk_to_area($BACKGROUND/Counter_Collider)
				await $ROWENA.do_stuff(false)
				_set_comment("Now the towel is moist.")
				is_towel_wet = true
				$UI.add_to_inventory(
					Globals.Prop.TOWEL_SMALL, "Small towel moistened with milk")

	# small towel + filter holder: if the towel has been moistened, use it on
	# the filter holder and taste it (both objects must be in the inventory)

	elif _check_objects(
		object1, object2, Globals.Prop.TOWEL_SMALL, Globals.Prop.COFFEE_MAKER):
			if ($UI.find_in_inventory(object1) < 0 or
				$UI.find_in_inventory(object2) < 0):
				pass
			elif is_towel_wet:
				await $ROWENA.walk_to_area($BACKGROUND/Counter_Collider)
				await $ROWENA.do_stuff(false)
				_set_comment("That should be more absorbent now. Let's taste it!")
				await $UI.comment_closed
				await $ROWENA.do_erk_stuff()
				_set_comment("That's disgusting! And there's not enough...")
			else:
				await $ROWENA.walk_to_area($BACKGROUND/Counter_Collider)
				await $ROWENA.do_stuff(false)
				_set_comment("That works, but I can't get enough coffee out of it.")

	# huh?

	else:
		#print("use ", _get_prop_name(object1), " on ", _get_prop_name(object2))
		var msg_index = randi() % cant_use_msgs.size()
		_set_comment(cant_use_msgs[msg_index])

#
# Callback invoked when the user has removed an item from the inventory (that
# is, put it down). The corresponding object in the scene is made visible
# again.
#
func _on_inventory_item_removed(which: int):
	$BACKGROUND.set_object_visible(which, true)
