extends Node2D

var current_object: int = -1

func _on_ui_click_on_background(pos):
	$UI.clear_comment_text()
	match $UI.get_current_action():
		Globals.Cursor.QUIT:
			get_tree().quit()
		Globals.Cursor.EYE:
			match current_object:
				Globals.Prop.REFRIGERATOR_RIGHT:
					$UI.set_comment_text("That's a refrigerator.")
		Globals.Cursor.HAND:
			$UI.clear_comment_text()
			match current_object:
				Globals.Prop.REFRIGERATOR_RIGHT:
					print("open the refrigerator!")
					$UI.clear_available_actions()
		_:
			$ROWENA.walk_to(pos.x)

func _on_background_mouse_entered_object(which):
	print($BACKGROUND.get_collider(which).name)
	current_object = which
	var actions: Array[int] = []
	if which == Globals.Prop.WINDOW_RIGHT:
		actions.append(Globals.Cursor.QUIT)
	else:
		actions.append(Globals.Cursor.EYE)
		actions.append(Globals.Cursor.HAND)
	$UI.set_available_actions(actions)
	$UI.clear_comment_text()

func _on_background_mouse_exited_object(_which):
	current_object = -1
	$UI.clear_available_actions()
	$UI.clear_comment_text()
