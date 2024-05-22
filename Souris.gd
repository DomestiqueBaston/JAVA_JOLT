extends Node2D


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)# Hide system mouse cursor
	$".".show()
	$Souris_curseur.show()
	$Souris_oeil.hide()

	
func _process(_delta):
	$".".global_position = $".".get_global_mouse_position()
	






func _on_oven_colliders_mouse_entered():
	$Souris_curseur.hide()
	$Souris_oeil.show()


func _on_oven_colliders_mouse_exited():
	$Souris_curseur.show()
	$Souris_oeil.hide()


func _on_milk_collider_mouse_entered():
	$Souris_curseur.hide()
	$Souris_oeil.show()


func _on_milk_collider_mouse_exited():
	$Souris_curseur.show()
	$Souris_oeil.hide()

func _on_coffee_maker_collider_mouse_entered():
	$Souris_curseur.hide()
	$Souris_oeil.show()


func _on_coffee_maker_collider_mouse_exited():
	$Souris_curseur.show()
	$Souris_oeil.hide()


func _on_radio_alarm_collider_mouse_entered():
	$Souris_curseur.hide()
	$Souris_oeil.show()


func _on_radio_alarm_collider_mouse_exited():
	$Souris_curseur.show()
	$Souris_oeil.hide()


func _on_oven_colliders_input_event(_viewport, event, _shape_idx):
	if Input.is_action_just_pressed("mouse_click"):
		if (event is InputEventMouseButton && event.pressed):
			if $"../Oven".visible == false:
				$"../Oven".visible = true
				$"../Milk".hide()
				$"../Coffee_Maker".hide()
				$"../Radio_Alarm".hide()
			else:
				$"../Oven".visible = false
		


func _on_milk_collider_input_event(_viewport, event, _shape_idx):
	if Input.is_action_just_pressed("mouse_click"):
		if (event is InputEventMouseButton && event.pressed):
			if $"../Milk".visible == false:
				$"../Milk".visible = true
				$"../Oven".hide()
				$"../Coffee_Maker".hide()
				$"../Radio_Alarm".hide()
			else:
				$"../Milk".visible = false


func _on_coffee_maker_collider_input_event(_viewport, event, _shape_idx):
	if Input.is_action_just_pressed("mouse_click"):
		if (event is InputEventMouseButton && event.pressed):
			if $"../Coffee_Maker".visible == false:
				$"../Coffee_Maker".visible = true
				$"../Oven".hide()
				$"../Milk".hide()
				$"../Radio_Alarm".hide()
			else:
				$"../Coffee_Maker".visible = false


func _on_radio_alarm_collider_input_event(_viewport, event, _shape_idx):
	if Input.is_action_just_pressed("mouse_click"):
		if (event is InputEventMouseButton && event.pressed):
			if $"../Radio_Alarm".visible == false:
				$"../Radio_Alarm".visible = true
				$"../Oven".hide()
				$"../Milk".hide()
				$"../Coffee_Maker".hide()
			else:
				$"../Radio_Alarm".visible = false
