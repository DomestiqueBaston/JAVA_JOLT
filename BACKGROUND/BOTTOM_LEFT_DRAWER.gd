extends OpenableObject

func _ready():
	set_collider(
		Globals.Prop.DRAWER_LEFT_3_OPEN,
		$Stuff_Colliders/Bottom_Left_Drawer_Collider)
