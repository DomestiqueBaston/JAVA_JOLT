extends Control

var _current_cursor: int = -1

@onready var _cursors: Array[TextureRect] = [
	$Cross_Passive,
	$Cross_Active,
	$Cursor,
	$Sound_Up,
	$Sound_Down,
	$No_Sound,
	$Eye,
	$Hand,
	$Load,
	$Save,
	$Quit,
	$Trash,
]

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	assert(_cursors.size() == Globals.Cursor.CURSOR_COUNT)
	set_cursor(Globals.Cursor.CROSS_PASSIVE)

func _input(event):
	if event is InputEventMouseMotion:
		global_position = event.position

func set_cursor(cursor: int):
	if _current_cursor != cursor:
		if _current_cursor >= 0:
			_cursors[_current_cursor].hide()
		_current_cursor = cursor
		_cursors[_current_cursor].show()
