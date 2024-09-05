extends OpenableObject

@onready var _my_colliders: Array[Area2D] = [
	$Stuff_Colliders/Small_Wine_Glasses_Collider,
	$Stuff_Colliders/Large_Glasses_Collider,
	$Stuff_Colliders/Soup_Plates_Collider,
	$Door_Collider,
]

func _ready():
	assert(_my_colliders.size() ==
		Globals.Prop.CUPBOARD_UPPER_CENTER_LEFT_END -
		Globals.Prop.CUPBOARD_UPPER_CENTER_LEFT_BEGIN + 1)
	set_colliders(Globals.Prop.CUPBOARD_UPPER_CENTER_LEFT_BEGIN, _my_colliders)

func set_object_visible(which: int, vis: bool):
	match which:
		Globals.Prop.SMALL_WINE_GLASSES:
			$Removed_Objects/Small_Wine_Glasses_Out.visible = not vis
			$Stuff_Colliders/Small_Wine_Glasses_Collider/Small_Wine_Glasses.set_deferred("disabled", not vis)
			$Stuff_Colliders/Small_Wine_Glasses_Collider/Small_Wine_Glasses_Out.set_deferred("disabled", vis)
		Globals.Prop.LARGE_GLASSES:
			$Removed_Objects/Large_Glasses_Out.visible = not vis
			$Stuff_Colliders/Large_Glasses_Collider/Large_Glasses.set_deferred("disabled", not vis)
			$Stuff_Colliders/Large_Glasses_Collider/Large_Glasses_Out.set_deferred("disabled", vis)
		Globals.Prop.SOUP_PLATES:
			$Removed_Objects/Soup_Plates_Out.visible = not vis
			$Stuff_Colliders/Soup_Plates_Collider/Soup_Plates.set_deferred("disabled", not vis)
			$Stuff_Colliders/Soup_Plates_Collider/Soup_Plates_Out.set_deferred("disabled", vis)
