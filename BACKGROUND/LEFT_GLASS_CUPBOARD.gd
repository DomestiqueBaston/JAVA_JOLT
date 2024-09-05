extends OpenableObject

@onready var _my_colliders: Array[Area2D] = [
	$Stuff_Colliders/Wine_Glasses_Collider,
	$Stuff_Colliders/Glasses_Collider,
	$Stuff_Colliders/Left_Plates_Collider,
	$Door_Collider,
]

func _ready():
	assert(_my_colliders.size() ==
		Globals.Prop.LEFT_GLASS_CUPBOARD_END -
		Globals.Prop.LEFT_GLASS_CUPBOARD_BEGIN + 1)
	set_colliders(Globals.Prop.LEFT_GLASS_CUPBOARD_BEGIN, _my_colliders)

func set_object_visible(index: int, vis: bool):
	match index:
		Globals.Prop.WINE_GLASSES:
			$Stuff_Colliders/Wine_Glasses_Collider.visible = not vis
			$Stuff_Colliders/Wine_Glasses_Collider/Wine_Glasses.set_deferred("disabled", not vis)
			$Stuff_Colliders/Wine_Glasses_Collider/Wine_Glasses_Out.set_deferred("disabled", vis)
		Globals.Prop.GLASSES:
			$Stuff_Colliders/Glasses_Collider.visible = not vis
			$Stuff_Colliders/Glasses_Collider/Glasses.set_deferred("disabled", not vis)
			$Stuff_Colliders/Glasses_Collider/Glasses_Out.set_deferred("disabled", vis)
		Globals.Prop.PLATES:
			$Stuff_Colliders/Left_Plates_Collider.visible = not vis
			$Stuff_Colliders/Left_Plates_Collider/Left_Plates.set_deferred("disabled", not vis)
			$Stuff_Colliders/Left_Plates_Collider/Left_Plates_Out.set_deferred("disabled", vis)
