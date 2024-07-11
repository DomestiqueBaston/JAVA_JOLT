extends Control

var current_cursor: TextureRect

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_cursor("Cross_Passive")

func _input(event):
	if event is InputEventMouseMotion:
		global_position = event.position

func set_cursor(cursor_name: String):
	var cursor = get_node(cursor_name)
	if cursor != null and cursor != current_cursor:
		if current_cursor:
			current_cursor.hide()
		current_cursor = cursor
		current_cursor.show()
