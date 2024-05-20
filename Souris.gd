extends Node2D


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)# Hide system mouse cursor
	$".".show()
	$Souris_curseur.show()
	$Souris_oeil.hide()

	
func _process(_delta):
	$".".global_position = $".".get_global_mouse_position()
	
