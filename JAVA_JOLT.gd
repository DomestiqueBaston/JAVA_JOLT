extends Node2D

var current_object = -1

func _on_ui_click_on_background(pos):
	if current_object == $BACKGROUND.WINDOW_RIGHT:
		get_tree().quit()
	else:
		$ROWENA.walk_to(pos.x)

func _on_background_mouse_entered_object(which):
	print($BACKGROUND.get_collider(which).name)
	current_object = which
	if which == $BACKGROUND.WINDOW_RIGHT:
		$UI.set_mouse_cursor("Quit")
	else:
		$UI.set_mouse_cursor("Cross_Passive")

func _on_background_mouse_exited_object(_which):
	current_object = -1
	$UI.set_mouse_cursor("Cross_Passive")
