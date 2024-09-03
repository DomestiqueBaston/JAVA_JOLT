extends Node2D

signal area_entered_object(which: int, area: Area2D)
signal area_exited_object(which: int, area: Area2D)

@onready var _colliders: Array[Area2D] = [
	$Stuff_Colliders/Extinguisher_Collider,
	$Stuff_Colliders/Plastic_Baskets_Collider,
	$Stuff_Colliders/Plunger_Collider,
	$Stuff_Colliders/Trash_Collider,
	$Door_Collider,
]

func _ready():
	assert(_colliders.size() ==
		Globals.Prop.UNDER_SINK_END -
		Globals.Prop.UNDER_SINK_BEGIN + 1)
	for index in _colliders.size():
		var collider: Area2D = _colliders[index]
		collider.area_entered.connect(
			func(area):
				area_entered_object.emit(
					Globals.Prop.UNDER_SINK_BEGIN + index, area)
				)
		collider.area_exited.connect(
			func(area):
				area_exited_object.emit(
					Globals.Prop.UNDER_SINK_BEGIN + index, area))

func get_collider(which: int) -> Area2D:
	return _colliders[which - Globals.Prop.UNDER_SINK_BEGIN]

func get_object_from_collider(area: Area2D) -> int:
	var index = _colliders.find(area)
	if index >= 0:
		index += Globals.Prop.UNDER_SINK_BEGIN
	return index

func set_object_visible(which: int, vis: bool):
	match which:
		Globals.Prop.EXTINGUISHER:
			$Removed_Objects/Extinguisher_Out.visible = not vis
			$Stuff_Colliders/Extinguisher_Collider.monitoring = vis
		Globals.Prop.PLUNGER:
			$Removed_Objects/Plunger_Out.visible = not vis
			$Stuff_Colliders/Plunger_Collider.monitoring = vis
