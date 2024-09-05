extends OpenableObject

@onready var _my_colliders: Array[Area2D] = [
	$Stuff_Colliders/Cooking_Pot_Up_Right_Collider,
	$Stuff_Colliders/Huge_Pressure_Cooker_Collider,
	$Stuff_Colliders/Sauce_Pan_Set_Collider,
	$Stuff_Colliders/Salad_Bowls_Collider,
	$Door_Collider,
]

func _ready():
	assert(_my_colliders.size() ==
		Globals.Prop.UPPER_RIGHT_CUPBOARD_END -
		Globals.Prop.UPPER_RIGHT_CUPBOARD_BEGIN + 1)
	set_colliders(Globals.Prop.UPPER_RIGHT_CUPBOARD_BEGIN, _my_colliders)
