extends OpenableObject

func _ready():
	set_collider(Globals.Prop.OVEN_BOTTOM_OPEN, $Door_Collider)
