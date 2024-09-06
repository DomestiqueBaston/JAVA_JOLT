extends OpenableObject

@onready var _my_colliders: Array[Area2D] = [
	$Stuff_Colliders/Bowls_Collider,
	$Stuff_Colliders/Large_Bowls_Collider,
	$Stuff_Colliders/Right_Plates_Collider,
	$Door_Collider,
]

func _ready():
	assert(_my_colliders.size() ==
		Globals.Prop.RIGHT_GLASS_CUPBOARD_END -
		Globals.Prop.RIGHT_GLASS_CUPBOARD_BEGIN + 1)
	set_colliders(Globals.Prop.RIGHT_GLASS_CUPBOARD_BEGIN, _my_colliders)

func set_object_visible(index: int, vis: bool):
	match index:
		Globals.Prop.BOWLS:
			$Removed_Objects/Right_Bowls_Out.visible = not vis
			$Stuff_Colliders/Bowls_Collider/Bowls.set_deferred("disabled", not vis)
			$Stuff_Colliders/Bowls_Collider/Bowls_Out.set_deferred("disabled", vis)
		Globals.Prop.LARGE_BOWLS:
			$Removed_Objects/Right_Large_Bowls_Out.visible = not vis
			$Stuff_Colliders/Large_Bowls_Collider/Large_Bowls.set_deferred("disabled", not vis)
			$Stuff_Colliders/Large_Bowls_Collider/Large_Bowls_Out.set_deferred("disabled", vis)
		Globals.Prop.PLATES_2:
			$Removed_Objects/Right_Plates_Out.visible = not vis
			$Stuff_Colliders/Right_Plates_Collider/Right_Plates.set_deferred("disabled", not vis)
			$Stuff_Colliders/Right_Plates_Collider/Right_Plates_Out.set_deferred("disabled", vis)
