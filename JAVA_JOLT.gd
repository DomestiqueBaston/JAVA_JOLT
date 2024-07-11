extends Node2D

func _on_ui_click_on_background(pos):
	$ROWENA.walk_to(pos.x)
