extends "OpenableObject.gd"

@onready var _my_colliders: Array[Area2D] = [
	$Stuff_Colliders/Empty_Coffee_Space_Collider,
	$Stuff_Colliders/Canned_Green_Beans_1_Collider,
	$Stuff_Colliders/Canned_Green_Beans_2_Collider,
	$Stuff_Colliders/Canned_Beans_1_Collider,
	$Stuff_Colliders/Canned_Beans_2_Collider,
	$Door_Collider,
]

func _ready():
	assert(_my_colliders.size() ==
		Globals.Prop.COFFEE_CUPBOARD_END -
		Globals.Prop.COFFEE_CUPBOARD_BEGIN + 1)
	set_colliders(Globals.Prop.COFFEE_CUPBOARD_BEGIN, _my_colliders)
