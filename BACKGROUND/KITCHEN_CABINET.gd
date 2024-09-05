extends OpenableObject

@onready var _my_colliders: Array[Area2D] = [
	$Stuff_Colliders/Rice_Cooker_Collider,
	$Stuff_Colliders/Pressure_Cooker_Collider,
	$Door_Collider,
]

func _ready():
	assert(_my_colliders.size() ==
		Globals.Prop.KITCHEN_CABINET_END -
		Globals.Prop.KITCHEN_CABINET_BEGIN + 1)
	set_colliders(Globals.Prop.KITCHEN_CABINET_BEGIN, _my_colliders)
