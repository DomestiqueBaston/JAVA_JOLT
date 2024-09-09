extends OpenableObject

func _ready():
	set_collider(
		Globals.Prop.PRIVATE_DRAWER_OPEN,
		$Stuff_Colliders/Private_Drawer_Open_Collider)
