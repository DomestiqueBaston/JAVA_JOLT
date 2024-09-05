extends "OpenableObject.gd"

@onready var _my_colliders: Array[Area2D] = [
	$Stuff_Colliders/Drain_Cleaner_Collider,
	$Stuff_Colliders/Mop_Collider,
	$Stuff_Colliders/Detergent_Collider,
	$Stuff_Colliders/Large_Bucket_Collider,
	$Stuff_Colliders/Small_Bucket_Collider,
	$Stuff_Colliders/Dust_Pan_Brush_Collider,
	$Door_Collider,
]

func _ready():
	assert(_my_colliders.size() ==
		Globals.Prop.CLEANING_CLOSET_END -
		Globals.Prop.CLEANING_CLOSET_BEGIN + 1)
	set_colliders(Globals.Prop.CLEANING_CLOSET_BEGIN, _my_colliders)
