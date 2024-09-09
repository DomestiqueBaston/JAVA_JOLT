extends OpenableObject

func _ready():
	set_collider(
		Globals.Prop.KITCHEN_TOOLS_DRAWER_OPEN,
		$Stuff_Colliders/Kitchen_Tools_Drawer_Open_Collider)
