extends OpenableObject

@onready var _my_colliders: Array[Area2D] = [
	$Stuff_Colliders/Large_Cookie_Box_Collider,
	$Stuff_Colliders/Small_Cookie_Box_Collider,
	$Stuff_Colliders/Tea_Box_1_Collider,
	$Stuff_Colliders/Tea_Box_2_Collider,
	$Stuff_Colliders/Tea_Box_3_Collider,
	$Stuff_Colliders/Tea_Box_4_Collider,
	$Stuff_Colliders/Tea_Box_5_Collider,
	$Door_Collider,
]

func _ready():
	assert(_my_colliders.size() ==
		Globals.Prop.CUPBOARD_UPPER_CENTER_END -
		Globals.Prop.CUPBOARD_UPPER_CENTER_BEGIN + 1)
	set_colliders(Globals.Prop.CUPBOARD_UPPER_CENTER_BEGIN, _my_colliders)

func set_object_visible(which: int, vis: bool):
	match which:
		Globals.Prop.SMALL_COOKIE_BOX:
			$Removed_Objects/Small_Cookie_Box_Out.visible = not vis
			$Stuff_Colliders/Small_Cookie_Box_Collider.monitoring = vis
		Globals.Prop.TEA_BOX_5:
			$Removed_Objects/Tea_Box_5_Out.visible = not vis
			$Stuff_Colliders/Tea_Box_5_Collider.monitoring = vis
