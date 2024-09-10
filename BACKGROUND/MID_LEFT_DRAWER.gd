extends OpenableObject

func _ready():
	set_collider(
		Globals.Prop.DRAWER_LEFT_2_OPEN,
		$Stuff_Colliders/Mid_Left_Drawer_Collider)
