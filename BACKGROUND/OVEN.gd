extends "OpenableObject.gd"

@onready var _my_colliders: Array[Area2D] = [
	$Stuff_Colliders/Empty_Space_1_Collider,
	$Stuff_Colliders/Empty_Space_2_Collider,
	$Stuff_Colliders/Empty_Space_3_Collider,
	$Door_Collider,
]

func _ready():
	assert(_my_colliders.size() ==
		Globals.Prop.OVEN_END - Globals.Prop.OVEN_BEGIN + 1)
	set_colliders(Globals.Prop.OVEN_BEGIN, _my_colliders)
