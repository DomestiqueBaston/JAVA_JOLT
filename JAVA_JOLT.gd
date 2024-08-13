extends Node2D

## At this distance from an open object (e.g. the refrigerator), we close it
## automatically rather than make Rowena walk back to it.
@export var auto_close_distance = 60

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
	"That's the coffee maker. It's empty. I could cry if I had the time.",
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
	# MANDOLINE
	"That's my miracle vegetable slicer, as seen on TV.",
	# FOOD_PROCESSOR
	"That's my food processor.",
	# RED_COFFEE_CUP_LEFT
	"That's an empty coffee cup.",
	# BROWN_COFFEE_CUP
	"That's my cup of tea.",
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
]

var butter_knife_seen = false

func _ready():
	assert(prop_info.size() == Globals.Prop.TOTAL_PROP_COUNT)

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

func _on_ui_click_on_background(pos):
	match $UI.get_current_cursor():
		Globals.Cursor.CROSS_PASSIVE, Globals.Cursor.CROSS_ACTIVE:
			$UI.clear_comment_text()
			$ROWENA.walk_to_x(pos.x)
		Globals.Cursor.EYE:
			$ROWENA.look_at_x(pos.x)
			if current_prop >= 0:
				if (current_prop == Globals.Prop.BUTTER_KNIFE and
					$UI.find_in_inventory("Butter knife") >= 0):
					_set_comment("That's butter. I've got the knife, though.")
				else:
					_set_comment(prop_info[current_prop])
				if current_prop == Globals.Prop.BUTTER_KNIFE:
					butter_knife_seen = true
		Globals.Cursor.HAND:
			$UI.clear_comment_text()
			match current_prop:
				Globals.Prop.REFRIGERATOR_RIGHT:
					$UI.clear_available_cursors()
					await _walk_to_prop()
					$ROWENA.get_something(3, false)
					await $ROWENA.got_something
					$BACKGROUND.open_refrigerator_right()
				Globals.Prop.REFRIGERATOR_RIGHT_OPEN_DOOR:
					$UI.clear_available_cursors()
					await _walk_to_prop()
					$ROWENA.get_something(3, false)
					await $ROWENA.got_something
					$BACKGROUND.close_refrigerator_right()
				Globals.Prop.BUTTER_KNIFE:
					$UI.clear_available_cursors()
					if butter_knife_seen:
						$UI.add_to_inventory("Butter knife")
						_set_comment("OK, I'll just take that knife.")
					else:
						_set_comment("Remember? Coffee...")
				_:
					$ROWENA.look_at(pos.x)
		Globals.Cursor.QUIT:
			$UI.clear_comment_text()
			await _close_open_object()
			await _walk_to_prop()
			get_tree().quit()

func _close_open_object():
	if $BACKGROUND.get_open_object() == Globals.Prop.REFRIGERATOR_RIGHT:
		var door = Globals.Prop.REFRIGERATOR_RIGHT_OPEN_DOOR
		if _get_distance_from_prop(door) < auto_close_distance:
			await _walk_to_prop(door)
			$ROWENA.get_something(3, false)
			await $ROWENA.got_something
		$BACKGROUND.close_refrigerator_right()

func _get_distance_from_prop(which: int) -> float:
		var prop: Area2D = $BACKGROUND.get_collider(which)
		return absf($ROWENA.position.x - prop.position.x)

func _walk_to_prop(which: int = -1):
	if which < 0:
		which = current_prop
	$ROWENA.walk_to_area($BACKGROUND.get_collider(which))
	await $ROWENA.target_area_reached

#
# Callback invoked when the mouse collider (_area) enters the Area2D of a
# background object (the prop identified by which: see Globals.Prop). The
# current prop, and available cursor actions, are updated as appropriate.
#
func _on_background_area_entered_object(which: int, _area: Area2D):
	if $UI.is_dialogue_visible() or $UI.is_inventory_open():
		return
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
	else:
		print(top_collider.name)
		var actions: Array[int] = [ Globals.Cursor.CROSS_ACTIVE, Globals.Cursor.EYE ]
		match current_prop:
			Globals.Prop.REFRIGERATOR_RIGHT:
				actions.append(Globals.Cursor.HAND)
			Globals.Prop.BUTTER_KNIFE:
				if $UI.find_in_inventory("Butter knife") < 0:
					actions.append(Globals.Cursor.HAND)
			Globals.Prop.WINDOW_RIGHT:
				actions.append(Globals.Cursor.QUIT)
			Globals.Prop.REFRIGERATOR_RIGHT_OPEN_DOOR:
				actions.append(Globals.Cursor.HAND)
		$UI.set_available_cursors(actions)
