extends Control

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	show()
	$Cross_Passive.show()

func _input(event):
	if event is InputEventMouseMotion:
		global_position = event.position
