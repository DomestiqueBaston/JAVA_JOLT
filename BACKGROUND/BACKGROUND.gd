extends Node2D

signal area_entered_object(which: int, area: Area2D)
signal area_exited_object(which: int, area: Area2D)

var _open_object = -1

@onready var _colliders: Array[Area2D] = [
	$Stuff_Colliders/Low/Kitchen_Cabinet_Collider,				# KITCHEN_CABINET
	$Stuff_Colliders/Low/Recycling_Closet_Collider,				# RECYCLING_CLOSET
	$Stuff_Colliders/Low/Undersink_Cabinet_Collider,			# UNDERSINK_CABINET
	$Stuff_Colliders/Low/Cleaning_Closet_Collider,				# CLEANING_CLOSET
	$Stuff_Colliders/Low/Drawer_Left_1_Collider,				# DRAWER_LEFT_1
	$Stuff_Colliders/Low/Drawer_Left_2_Collider,				# DRAWER_LEFT_2
	$Stuff_Colliders/Low/Drawer_Left_3_Collider,				# DRAWER_LEFT_3
	$Stuff_Colliders/Low/Private_Drawer_Collider,				# PRIVATE_DRAWER
	$Stuff_Colliders/Low/Kitchen_Tools_Drawer_Collider,			# KITCHEN_TOOLS_DRAWER
	$Stuff_Colliders/Low/Cutlery_Drawer_Collider,				# CUTLERY_DRAWER
	$Stuff_Colliders/Low/Oven_Collider,							# OVEN
	$Stuff_Colliders/Low/Oven_Bottom_Collider,					# OVEN_BOTTOM
	$Stuff_Colliders/Low/DishWasher_Collider,					# DISHWASHER
	$Stuff_Colliders/Low/Stool_Collider,						# STOOL
	$Stuff_Colliders/Low/Chair_Collider,						# CHAIR
	$Stuff_Colliders/Low/Towel_Large_Collider,					# TOWEL_LARGE
	$Stuff_Colliders/Low/Towel_Small_Collider,					# TOWEL_SMALL
	$Stuff_Colliders/Up/Top_Left_Unused_Cupboard_Collider,		# TOP_LEFT_UNUSED_CUPBOARD
	$Stuff_Colliders/Up/Left_Glass_Cupboard_Collider,			# LEFT_GLASS_CUPBOARD
	$Stuff_Colliders/Up/Top_Center_Unused_Cupboard_Collider,	# TOP_CENTER_UNUSED_CUPBOARD
	$Stuff_Colliders/Up/Right_Glass_Cupboard_Collider,			# RIGHT_GLASS_CUPBOARD
	$Stuff_Colliders/Up/Cupboard_Upper_Center_Left_Collider,	# CUPBOARD_UPPER_CENTER_LEFT
	$Stuff_Colliders/Up/Cupboard_Upper_Center_Collider,			# CUPBOARD_UPPER_CENTER
	$Stuff_Colliders/Up/Coffee_Cupboard_Collider,				# COFFEE_CUPBOARD
	$Stuff_Colliders/Up/Upper_Right_Cupboard_Collider,			# UPPER_RIGHT_CUPBOARD
	$Stuff_Colliders/Up/Microwave_Oven_Collider,				# MICROWAVE_OVEN
	$Stuff_Colliders/Up/Window_Right_Collider,					# WINDOW_RIGHT
	$Stuff_Colliders/Up/Window_Left_Collider,					# WINDOW_LEFT
	$Stuff_Colliders/Mid/Spoiled_Milk_Collider,					# SPOILED_MILK
	$Stuff_Colliders/Mid/Coffee_Maker_Collider,					# COFFEE_MAKER
	$Stuff_Colliders/Mid/Radio_Collider,						# RADIO
	$Stuff_Colliders/Mid/Refrigerator_Right_Collider,			# REFRIGERATOR_RIGHT
	$Stuff_Colliders/Mid/Refrigerator_Left_Collider,			# REFRIGERATOR_LEFT
	$Stuff_Colliders/Mid/Refrigerator_Left_Water_Ice_Collider,	# REFRIGERATOR_LEFT_WATER_ICE
	$Stuff_Colliders/Mid/Painting_Collider,						# PAINTING
	$Stuff_Colliders/Mid/Light_Switch_Left_Collider,			# LIGHT_SWITCH_LEFT
	$Stuff_Colliders/Mid/Light_Switch_Right_Collider,			# LIGHT_SWITCH_RIGHT
	$Stuff_Colliders/Mid/Yucca_Collider,						# YUCCA
	$Stuff_Colliders/Mid/Olive_Oil_Bottle_Collider,				# OLIVE_OIL_BOTTLE
	$Stuff_Colliders/Mid/Salt_Collider,							# SALT
	$Stuff_Colliders/Mid/Toaster_Collider,						# TOASTER
	$Stuff_Colliders/Mid/Notched_Coffee_Cup_Right_Collider,		# NOTCHED_COFFEE_CUP_RIGHT
	$Stuff_Colliders/Mid/Pepper_Collider,						# PEPPER
	$Stuff_Colliders/Mid/Rice_Pot_Collider,						# RICE_POT
	$Stuff_Colliders/Mid/Cookie_Pot_Collider,					# COOKIE_POT
	$Stuff_Colliders/Mid/Tap_Collider,							# TAP
	$Stuff_Colliders/Mid/Plastic_Boxes_Collider,				# PLASTIC_BOXES
	$Stuff_Colliders/Mid/Mandolin_Collider,						# MANDOLIN
	$Stuff_Colliders/Mid/Food_Processor_Collider,				# FOOD_PROCESSOR
	$Stuff_Colliders/Mid/Red_Coffee_Cup_Left_Collider,			# RED_COFFEE_CUP_LEFT
	$Stuff_Colliders/Mid/Brown_Coffee_Cup_Collider,				# BROWN_COFFEE_CUP
	$Stuff_Colliders/Mid/Knife_Block_Collider,					# KNIFE_BLOCK
	$Stuff_Colliders/Mid/Fruit_Basket_Collider,					# FRUIT_BASKET
	$Stuff_Colliders/Mid/Cutting_Board_Collider,				# CUTTING_BOARD
	$Stuff_Colliders/Mid/Pressure_Cooker_Collider,				# PRESSURE_COOKER
	$Stuff_Colliders/Mid/Kettle_Collider,						# KETTLE
	$Stuff_Colliders/Mid/Sauce_Pan_Collider,					# SAUCE_PAN
	$Stuff_Colliders/Mid/Coffee_Beans_1_Collider,				# COFFEE_BEANS_1
	$Stuff_Colliders/Mid/Coffee_Beans_2_Collider,				# COFFEE_BEANS_2
]

func _ready():
	assert(_colliders.size() == Globals.Prop.MAIN_PROP_COUNT)

	for index in _colliders.size():
		var collider: Area2D = _colliders[index]
		collider.area_entered.connect(
			func(area): area_entered_object.emit(index, area))
		collider.area_exited.connect(
			func(area): area_exited_object.emit(index, area))

	$Open_Objects/Refrigerator_Right.area_entered_object.connect(
		func(which, area):
			if _open_object == Globals.Prop.REFRIGERATOR_RIGHT:
				area_entered_object.emit(which, area))
	$Open_Objects/Refrigerator_Right.area_exited_object.connect(
		func(which, area):
			if _open_object == Globals.Prop.REFRIGERATOR_RIGHT:
				area_exited_object.emit(which, area))

func get_collider(which: int) -> Area2D:
	if which < Globals.Prop.MAIN_PROP_COUNT:
		return _colliders[which]
	match _open_object:
		Globals.Prop.REFRIGERATOR_RIGHT:
			return $Open_Objects/Refrigerator_Right.get_collider(which)
		_:
			return null

func get_open_object() -> int:
	return _open_object

func open_refrigerator_right():
	$Open_Objects/Refrigerator_Right.show()
	$Sounds/Fridge_Open_Close.play()
	_open_object = Globals.Prop.REFRIGERATOR_RIGHT

func close_refrigerator_right():
	$Open_Objects/Refrigerator_Right.hide()
	$Sounds/Fridge_Open_Close.play()
	_open_object = -1

func close_everything():
	match _open_object:
		Globals.Prop.REFRIGERATOR_RIGHT:
			close_refrigerator_right()

#
# Makes the given object visible or invisible in the scene. An object is made
# invisible by making visible an image that hides it.
#
func set_object_visible(which: int, vis: bool):
	if which < Globals.Prop.MAIN_PROP_COUNT:
		match which:
			Globals.Prop.TOWEL_SMALL:
				$Removed_Objects/Tea_Towel_Out.visible = not vis
			Globals.Prop.COFFEE_MAKER:
				$Removed_Objects/Coffee_Filter_Holder_Out.visible = not vis
			Globals.Prop.OLIVE_OIL_BOTTLE:
				$Removed_Objects/Olive_Oil_Bottle_Out.visible = not vis
			Globals.Prop.MANDOLIN:
				$Removed_Objects/Mandolin_Out.visible = not vis
			Globals.Prop.KETTLE:
				$Removed_Objects/Kettle_Out.visible = not vis
	else:
		match _open_object:
			Globals.Prop.REFRIGERATOR_RIGHT:
				$Open_Objects/Refrigerator_Right.set_object_visible(which, vis)
