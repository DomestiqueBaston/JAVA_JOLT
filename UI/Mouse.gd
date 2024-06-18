extends Control


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)	# Hide system mouse cursor
	$".".show()
	$Cross_Passive.show()
	

func _process(_delta):
	$".".global_position = $".".get_global_mouse_position()
	
