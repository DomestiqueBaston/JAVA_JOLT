extends "OpenableObject.gd"

@onready var _my_colliders: Array[Area2D] = [
	$Stuff_Colliders/Extinguisher_Collider,
	$Stuff_Colliders/Plastic_Baskets_Collider,
	$Stuff_Colliders/Plunger_Collider,
	$Stuff_Colliders/Trash_Collider,
	$Door_Collider,
]

func _ready():
	assert(_my_colliders.size() ==
		Globals.Prop.UNDER_SINK_END -
		Globals.Prop.UNDER_SINK_BEGIN + 1)
	set_colliders(Globals.Prop.UNDER_SINK_BEGIN, _my_colliders)

func set_object_visible(which: int, vis: bool):
	match which:
		Globals.Prop.EXTINGUISHER:
			$Removed_Objects/Extinguisher_Out.visible = not vis
			$Stuff_Colliders/Extinguisher_Collider.monitoring = vis
		Globals.Prop.PLUNGER:
			$Removed_Objects/Plunger_Out.visible = not vis
			$Stuff_Colliders/Plunger_Collider.monitoring = vis
