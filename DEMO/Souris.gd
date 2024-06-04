extends Control


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)	# Hide system mouse cursor
	$"..".show()
	$".".show()
	$Souris_curseur.show()
	$Souris_oeil.hide()
	$Souris_hand.hide()
	

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

func _on_radio_collider_mouse_entered():
	$Souris_curseur.hide()
	$Souris_oeil.show()

func _on_radio_collider_mouse_exited():
	$Souris_curseur.show()
	$Souris_oeil.hide()

func _on_oven_colliders_input_event(_viewport, event, _shape_idx):
	if Input.is_action_just_pressed("left_mouse_click"):
		if (event is InputEventMouseButton && event.pressed):
			if $"../../Clickable/Oven".visible == false:
				$"../../Clickable/Oven".visible = true
				$"../../Clickable/Milk".hide()
				$"../../Clickable/Coffee_Maker".hide()
				$"../../Clickable/Radio".hide()
			else:
				$"../../Clickable/Oven".visible = false

func _on_milk_collider_input_event(_viewport, event, _shape_idx):
	if Input.is_action_just_pressed("left_mouse_click"):
		if (event is InputEventMouseButton && event.pressed):
			if $"../../Clickable/Milk".visible == false:
				$"../../Clickable/Milk".visible = true
				$"../../Clickable/Oven".hide()
				$"../../Clickable/Coffee_Maker".hide()
				$"../../Clickable/Radio".hide()
			else:
				$"../../Clickable/Milk".visible = false

func _on_coffee_maker_collider_input_event(_viewport, event, _shape_idx):
	if Input.is_action_just_pressed("left_mouse_click"):
		if (event is InputEventMouseButton && event.pressed):
			if $"../../Clickable/Coffee_Maker".visible == false:
				$"../../Clickable/Coffee_Maker".visible = true
				$"../../Clickable/Oven".hide()
				$"../../Clickable/Milk".hide()
				$"../../Clickable/Radio".hide()
			else:
				$"../../Clickable/Coffee_Maker".visible = false

func _on_radio_collider_input_event(_viewport, event, _shape_idx):
	if Input.is_action_just_pressed("left_mouse_click"):
		if (event is InputEventMouseButton && event.pressed):
			if $"../../Clickable/Radio".visible == false:
				$"../../Clickable/Radio".visible = true
				$"../../Clickable/Oven".hide()
				$"../../Clickable/Milk".hide()
				$"../../Clickable/Coffee_Maker".hide()
			else:
				$"../../Clickable/Radio".visible = false
