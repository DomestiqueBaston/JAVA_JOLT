extends OpenableObject

@onready var _my_colliders: Array[Area2D] = [
	$Stuff_Colliders/Pizza_Drawer_Collider,
	$Stuff_Colliders/Vegetable_Drawer_Collider,
	$Stuff_Colliders/Lasagna_Drawer_Collider,
	$Stuff_Colliders/Ice_Cream_Drawer_Collider,
	$Stuff_Colliders/Meat_Drawer_Collider,
	$Door_Collider,
]

func _ready():
	assert(_my_colliders.size() ==
		Globals.Prop.REFRIGERATOR_LEFT_END -
		Globals.Prop.REFRIGERATOR_LEFT_BEGIN + 1)
	set_colliders(Globals.Prop.REFRIGERATOR_LEFT_BEGIN, _my_colliders)
