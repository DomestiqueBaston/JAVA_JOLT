extends OpenableObject

@onready var _my_colliders: Array[Area2D] = [
	$Stuff_Colliders/Dishwasher_Empty_Top_Collider,
	$Stuff_Colliders/Dishwasher_Empty_Mid_Collider,
	$Stuff_Colliders/Dishwasher_Empty_Low_Collider,
	$Door_Collider,
]

func _ready():
	assert(_my_colliders.size() ==
		Globals.Prop.DISHWASHER_END -
		Globals.Prop.DISHWASHER_BEGIN + 1)
	set_colliders(Globals.Prop.DISHWASHER_BEGIN, _my_colliders)
