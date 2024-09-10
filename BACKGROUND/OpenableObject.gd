##
## Class implementing some functionality common to all closets, cupboards,
## drawers, etc. Nodes must call either [method set_colliders] or [method
## set_collider] from [method _ready].
##
class_name OpenableObject extends Node2D

## Signal emitted when another collider (which should be either the mouse or
## Rowena) enters the shape of one of this object's colliders. [param index] is
## the (unique) index of this object's collider; [param area] is the other
## collider.
signal area_entered_object(index: int, area: Area2D)

## Signal emitted when another collider (which should be either the mouse or
## Rowena) exits the shape of one of this object's colliders. [param index] is
## the (unique) index of this object's collider; [param area] is the other
## collider.
signal area_exited_object(index: int, area: Area2D)

var _start_index: int
var _colliders: Array[Area2D]

##
## Alternative to [method set_colliders] that can be called when the object
## has only one collider.
##
func set_collider(index: int, collider: Area2D):
	var colliders: Array[Area2D] = [collider]
	set_colliders(index, colliders)

##
## Specifies the [param colliders] exposed when this object is opened. Each one
## is identified by a unique number: [param start_index] for the first in the
## array, [param start_index]+1 for the second, and so on.
##
## At the very least, a collider should be provided for the open door or drawer
## that will allow the user to close it again.
##
## This method should be called only once, e.g. from the node's [method _ready]
## method.
##
func set_colliders(start_index: int, colliders: Array[Area2D]):
	_start_index = start_index
	_colliders = colliders

	for i in colliders.size():
		var collider: Area2D = colliders[i]
		collider.area_entered.connect(
			func(area): area_entered_object.emit(start_index + i, area))
		collider.area_exited.connect(
			func(area): area_exited_object.emit(start_index + i, area))

##
## Returns the collider associated with the given unique [param index]. The
## index must satisfy the constraint i <= index < i+n, where i is the start
## index that was given to [method set_colliders], and n is the number of
## colliders it was given.
##
func get_collider(index: int) -> Area2D:
	return _colliders[index - _start_index]

##
## Returns the unique index associated with the given collider, if it is one
## of the colliders that was passed to [method set_colliders]. If not, -1 is
## returned.
##
func get_object_from_collider(area: Area2D) -> int:
	var index = _colliders.find(area)
	if index >= 0:
		index += _start_index
	return index

##
## Specifies that the collider with the given [param _index] is no longer
## visible ([param _vis] false) or is again visible ([param _vis] true). The
## default implementation does nothing, but a node can override this method to
## alter the scene accordingly and perhaps enable/disable the collider itself. 
##
func set_object_visible(_index: int, _vis: bool):
	pass
