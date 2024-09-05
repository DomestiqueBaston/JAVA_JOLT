class_name OpenableObject extends Node2D

signal area_entered_object(index: int, area: Area2D)
signal area_exited_object(index: int, area: Area2D)

var _start_index: int
var _colliders: Array[Area2D]

func set_colliders(start_index: int, colliders: Array[Area2D]):
	_start_index = start_index
	_colliders = colliders

	for i in colliders.size():
		var collider: Area2D = colliders[i]
		collider.area_entered.connect(
			func(area): area_entered_object.emit(start_index + i, area))
		collider.area_exited.connect(
			func(area): area_exited_object.emit(start_index + i, area))

func get_collider(index: int) -> Area2D:
	return _colliders[index - _start_index]

func get_object_from_collider(area: Area2D) -> int:
	var index = _colliders.find(area)
	if index >= 0:
		index += _start_index
	return index

func set_object_visible(_index: int, _vis: bool):
	pass
