extends OpenableObject

@onready var _my_colliders: Array[Area2D] = [
	$Stuff_Colliders/Pizza_Collider,
	$Door_Collider,
]

func _ready():
	assert(_my_colliders.size() ==
		Globals.Prop.MICROWAVE_END -
		Globals.Prop.MICROWAVE_BEGIN + 1)
	set_colliders(Globals.Prop.MICROWAVE_BEGIN, _my_colliders)
