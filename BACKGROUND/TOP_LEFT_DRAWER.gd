extends OpenableObject

func _ready():
	set_collider(
		Globals.Prop.DRAWER_LEFT_1_OPEN,
		$Stuff_Colliders/Top_Left_Drawer_Collider)
