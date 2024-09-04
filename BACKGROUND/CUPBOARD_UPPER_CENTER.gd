extends Node2D

signal area_entered_object(which: int, area: Area2D)
signal area_exited_object(which: int, area: Area2D)

@onready var _colliders: Array[Area2D] = [
	$Stuff_Colliders/Large_Cookie_Box_Collider,
	$Stuff_Colliders/Small_Cookie_Box_Collider,
	$Stuff_Colliders/Tea_Box_1_Collider,
	$Stuff_Colliders/Tea_Box_2_Collider,
	$Stuff_Colliders/Tea_Box_3_Collider,
	$Stuff_Colliders/Tea_Box_4_Collider,
	$Stuff_Colliders/Tea_Box_5_Collider,
	$Door_Collider,
]

func _ready():
	assert(_colliders.size() ==
		Globals.Prop.CUPBOARD_UPPER_CENTER_END -
		Globals.Prop.CUPBOARD_UPPER_CENTER_BEGIN + 1)
	for index in _colliders.size():
		var collider: Area2D = _colliders[index]
		collider.area_entered.connect(
			func(area):
				area_entered_object.emit(
					Globals.Prop.CUPBOARD_UPPER_CENTER_BEGIN + index, area)
				)
		collider.area_exited.connect(
			func(area):
				area_exited_object.emit(
					Globals.Prop.CUPBOARD_UPPER_CENTER_BEGIN + index, area))

func get_collider(which: int) -> Area2D:
	return _colliders[which - Globals.Prop.CUPBOARD_UPPER_CENTER_BEGIN]

func get_object_from_collider(area: Area2D) -> int:
	var index = _colliders.find(area)
	if index >= 0:
		index += Globals.Prop.CUPBOARD_UPPER_CENTER_BEGIN
	return index

func set_object_visible(which: int, vis: bool):
	match which:
		Globals.Prop.SMALL_COOKIE_BOX:
			$Removed_Objects/Small_Cookie_Box_Out.visible = not vis
			$Stuff_Colliders/Small_Cookie_Box_Collider.monitoring = vis
		Globals.Prop.TEA_BOX_5:
			$Removed_Objects/Tea_Box_5_Out.visible = not vis
			$Stuff_Colliders/Tea_Box_5_Collider.monitoring = vis
