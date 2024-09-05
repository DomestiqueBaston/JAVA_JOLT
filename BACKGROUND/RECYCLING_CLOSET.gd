extends OpenableObject

@onready var _my_colliders: Array[Area2D] = [
	$Stuff_Colliders/Recycling_Bin_Collider,
	$Door_Collider,
]

func _ready():
	assert(_my_colliders.size() ==
		Globals.Prop.RECYCLING_CLOSET_END -
		Globals.Prop.RECYCLING_CLOSET_BEGIN + 1)
	set_colliders(Globals.Prop.RECYCLING_CLOSET_BEGIN, _my_colliders)
