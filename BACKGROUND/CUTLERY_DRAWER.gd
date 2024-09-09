extends OpenableObject

func _ready():
	set_collider(
		Globals.Prop.CUTLERY_DRAWER_OPEN,
		$Stuff_Colliders/Cutlery_Drawer_Open_Collider)
