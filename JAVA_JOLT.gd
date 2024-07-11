extends Node2D

func _on_ui_click_on_background(pos):
	$ROWENA.walk_to(pos.x)

func _on_background_mouse_entered_object(which):
	print($BACKGROUND.get_collider(which).name)

func _on_background_mouse_exited_object(_which):
	pass
