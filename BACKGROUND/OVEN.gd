extends Node2D

signal area_entered_object(which: int, area: Area2D)
signal area_exited_object(which: int, area: Area2D)

@onready var _colliders: Array[Area2D] = [
	$Stuff_Colliders/Empty_Space_1_Collider,
	$Stuff_Colliders/Empty_Space_2_Collider,
	$Stuff_Colliders/Empty_Space_3_Collider,
	$Door_Collider,
]

func _ready():
	assert(_colliders.size() ==
		Globals.Prop.OVEN_END -
		Globals.Prop.OVEN_BEGIN + 1)
	for index in _colliders.size():
		var collider: Area2D = _colliders[index]
		collider.area_entered.connect(
			func(area):
				area_entered_object.emit(
					Globals.Prop.OVEN_BEGIN + index, area)
				)
		collider.area_exited.connect(
			func(area):
				area_exited_object.emit(
					Globals.Prop.OVEN_BEGIN + index, area))

func get_collider(which: int) -> Area2D:
	return _colliders[which - Globals.Prop.OVEN_BEGIN]

func get_object_from_collider(area: Area2D) -> int:
	var index = _colliders.find(area)
	if index >= 0:
		index += Globals.Prop.OVEN_BEGIN
	return index

func set_object_visible(_which: int, _vis: bool):
	pass
