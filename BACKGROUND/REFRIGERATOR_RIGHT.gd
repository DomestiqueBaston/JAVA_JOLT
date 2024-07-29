extends Node2D

signal area_entered_object(which: int, area: Area2D)
signal area_exited_object(which: int, area: Area2D)

@onready var _colliders: Array[Area2D] = [
	$Stuff_Colliders/Smoothie_Bottles_Collider,
	$Stuff_Colliders/Fruit_Juice_Bottles_Collider,
	$Stuff_Colliders/Milk_Bottles_Collider,
	$Stuff_Colliders/Butter_Knife_Collider,
	$Stuff_Colliders/Cream_Pots_Collider,
	$Stuff_Colliders/Yoghurts_Collider,
	$Stuff_Colliders/Sauce_Pan_Collider,
	$Stuff_Colliders/Eggs_Collider,
	$Stuff_Colliders/Green_Pepper_Collider,
	$Stuff_Colliders/Tomatoes_Collider,
	$Stuff_Colliders/Cauliflower_Collider,
	$Stuff_Colliders/Yellow_Pepper_Collider,
	$Stuff_Colliders/Fruits_Collider,
]

func _ready():
	assert(_colliders.size() ==
		Globals.Prop.REFRIGERATOR_RIGHT_END -
		Globals.Prop.REFRIGERATOR_RIGHT_BEGIN + 1)
	for index in _colliders.size():
		var collider: Area2D = _colliders[index]
		collider.area_entered.connect(
			func(area):
				area_entered_object.emit(
					Globals.Prop.REFRIGERATOR_RIGHT_BEGIN + index, area)
				)
		collider.area_exited.connect(
			func(area):
				area_exited_object.emit(
					Globals.Prop.REFRIGERATOR_RIGHT_BEGIN + index, area))

func get_collider(which: int) -> Area2D:
	return _colliders[which - Globals.Prop.REFRIGERATOR_RIGHT_BEGIN]
