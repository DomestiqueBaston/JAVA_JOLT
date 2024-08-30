extends CanvasLayer

## Dialogue typing speed, in characters per seconds.
@export var characters_per_second := 15

## Scale applied to pitch of sound when Rowena types.
@export var rowena_typing_pitch: float = 6

## Scale applied to pitch of sound when the doctor types.
@export var doctor_typing_pitch: float = 1

## Color of dialogue text when Rowena speaks.
@export var rowena_text_color := Color(0xed/255.0, 0x6f/255.0, 0x68/255.0)

## Color of dialogue text when the doctor speaks.
@export var doctor_text_color := Color(0x5b/255.0, 0x90/255.0, 0xc2/255.0)

## Color of dialogue text option under the mouse cursor.
@export var highlighted_text_color := Color.WHITE

## Seconds before comments disappear.
@export var comment_timeout: float = 4

## Which dialogue to start with (for testing), 0 for none.
@export_range(0, 3) var dialogue_number: int = 0

## Signal emitted when user clicks somewhere to move or do something.
signal click_on_background(pos: Vector2)

## Signal emitted when user tries to "use" one inventory item on another.
signal use_object_on_other(object1: int, object2: int)

## Signal emitted when user removes an inventory item (from [enum Globals.Prop]).
signal inventory_item_removed(which: int)

## Signal emitted when the comment box is closed, automatically or by the user.
signal comment_closed

enum { ROWENA, DOCTOR }

# Color of unhighlighted text options in current dialogue.
var _choice_text_color: Color

# Which cursor actions are currently available.
var _available_cursors: Array[int] = []

# Cursor actions available while the inventory is open.
const _inventory_cursors: Array[int] = [
	Globals.Cursor.HAND,
	Globals.Cursor.TRASH
]

# Current cursor action (index into _available_cursors or _inventory_cursors).
var _current_cursor: int = -1

# true if the tutorial has been seen
var _is_tutorial_seen: bool = false

# true if the inventory box is open.
var _is_inventory_open: bool = false

# Inventory contents: maps item numbers (Globals.Prop enum) to label strings.
var _inventory_contents := {}

# Index (not item ID!) of the highlighted inventory item.
var _current_inventory_index: int = -1

# Number (Global.Prop enum) of the inventory item being used (arrow cursor).
var _inventory_item_being_used: int = -1

# How many items the inventory can hold.
const _max_inventory_size = 4

# Emitted when the typing of a line of dialogue finishes.
signal _typing_finished

# Emitted when the user clicks on "..." to pass to the next line of dialogue.
signal _next_click

# Emitted when the user clicks on one possible response in the dialogue box.
signal _click_on_choice(which: int)

const dialogue1 = preload("res://dialogue1.json").data
const dialogue2 = preload("res://dialogue2.json").data
const dialogue3 = preload("res://dialogue3.json").data

func _ready():
	clear_inventory()
	match dialogue_number:
		1:
			_tell_story_node(dialogue1, dialogue1["start"])
		2:
			_tell_story_node(dialogue2, dialogue2["start"])
		3:
			_tell_story_node(dialogue3, dialogue3["start"])

#
# If the user has chosen an inventory item to use and then moves the mouse
# outside the inventory box, close the inventory box automatically. It would
# seem cleaner to do this using mouse_entered() and mouse_exited() GUI events,
# but those events are already handled by the Labels inside the inventory box.
# And without a big margin around them, events for their container are not
# triggered reliably.
#
func _input(event: InputEvent):
	if (_is_inventory_open and _inventory_item_being_used >= 0 and
		event is InputEventMouseMotion):
		var invbox = $Boxes/Inventory_Box
		var rect = Rect2(invbox.position, invbox.size)
		if rect.has_point(event.position):
			$Close_Inventory_Timer.stop()
		else:
			$Close_Inventory_Timer.start()

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("left_mouse_click"):
		if _is_inventory_open:
			_click_on_inventory_item()
			get_viewport().set_input_as_handled()
		elif is_tutorial_open():
			$Boxes/Tutorial.hide()
			get_viewport().set_input_as_handled()
		elif not is_dialogue_visible():
			if event is InputEventMouse:
				click_on_background.emit(event.position)
			else:
				click_on_background.emit($Mouse.position)
			get_viewport().set_input_as_handled()
	elif event.is_action_pressed("next_mouse_action"):
		_next_cursor()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("prev_mouse_action"):
		_prev_cursor()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("inventory_action"):
		if not is_dialogue_visible():
			if _is_inventory_open:
				_close_inventory()
			else:
				_open_inventory()
			get_viewport().set_input_as_handled()

func _tell_story_node(graph, node):
	var speaker = _get_node_speaker(node)
	type_dialogue_text(node.text, speaker)
	await _typing_finished
	await _next_click
	var next = node.get("next")
	if typeof(next) == TYPE_ARRAY:
		var texts: Array[String] = []
		for node_name in next:
			texts.append(graph[node_name].text)
		speaker = _get_node_speaker(graph[next[0]])
		var choice = await choose_response(texts, speaker)
		next = graph[next[choice]].get("next")
	if next:
		_tell_story_node(graph, graph[next])
	else:
		clear_dialogue()

func _get_node_speaker(node) -> int:
	return ROWENA if node.speaker == "rowena" else DOCTOR

func _set_dialogue_style(speaker: int):
	if speaker == ROWENA:
		$Boxes/Dialogue_Box/BG/Dialogue.self_modulate = rowena_text_color
		$Typing.pitch_scale = 6
	else:
		$Boxes/Dialogue_Box/BG/Dialogue.self_modulate = doctor_text_color
		$Typing.pitch_scale = 1

func is_dialogue_visible() -> bool:
	return $Boxes/Dialogue_Box/BG/Dialogue.visible

func clear_dialogue():
	$Dialogue_AnimationPlayer.play("Close_Dialogue_1")
	$Boxes/Dialogue_Box/BG/Next.hide()

func set_dialogue_text(text: String, speaker: int):
	_set_dialogue_style(speaker)
	$Boxes/Dialogue_Box/BG/Dialogue.text = text
	$Dialogue_AnimationPlayer.play("Open_Dialogue_1")
	$Boxes/Dialogue_Box/BG/Next.show()

func type_dialogue_text(text: String, speaker: int):
	_set_dialogue_style(speaker)
	$Boxes/Dialogue_Box/BG/Dialogue.text = text
	$Boxes/Dialogue_Box/BG/Dialogue.visible_characters = 0
	$Boxes/Dialogue_Box/BG/Next.hide()
	$Typing_Timer.start(1.0 / characters_per_second)
	$Dialogue_AnimationPlayer.play("Open_Dialogue_1")

func choose_response(choices: Array[String], speaker: int) -> int:
	_choice_text_color = rowena_text_color if speaker == ROWENA else doctor_text_color
	$Boxes/Dialogue_Box/BG/Next.hide()
	$Boxes/Dialogue_Box/BG/Dialogue.text = choices[0]
	$Boxes/Dialogue_Box/BG/Dialogue.self_modulate = _choice_text_color
	if choices.size() > 1:
		$Boxes/Dialogue_Box/BG2/Dialogue2.text = choices[1]
		$Boxes/Dialogue_Box/BG2/Dialogue2.self_modulate = _choice_text_color
		if choices.size() > 2:
			$Boxes/Dialogue_Box/BG3/Dialogue3.text = choices[2]
			$Boxes/Dialogue_Box/BG3/Dialogue3.self_modulate = _choice_text_color
			if choices.size() > 3:
				$Boxes/Dialogue_Box/BG4/Dialogue4.text = choices[3]
				$Boxes/Dialogue_Box/BG4/Dialogue4.self_modulate = _choice_text_color
	$Dialogue_AnimationPlayer.play("Open_Dialogue_%d" % choices.size())
	var choice = await _click_on_choice
	$Dialogue_AnimationPlayer.play("Close_Dialogue_%d" % choices.size())
	await $Dialogue_AnimationPlayer.animation_finished
	return choice

func _type_one_character():
	var n = $Boxes/Dialogue_Box/BG/Dialogue.text.length()
	var i = $Boxes/Dialogue_Box/BG/Dialogue.visible_characters
	if i >= 0 and i < n:
		if $Boxes/Dialogue_Box/BG/Dialogue.text[i] != ' ':
			$Typing.play()
		i += 1
		$Boxes/Dialogue_Box/BG/Dialogue.visible_characters = i
	if i < 0 or i == n:
		$Typing_Timer.stop()
		emit_signal("_typing_finished")
		$Boxes/Dialogue_Box/BG/Next.show()

func set_comment_text(text: String, x: float, left_justify: bool):
	$Boxes/CenterContainer/Comment_Box/Comments.text = text
	if not left_justify:
		x -= $Boxes/CenterContainer/Comment_Box.size.x
	$Boxes/CenterContainer.position.x = x
	$Boxes/CenterContainer.show()
	$Comment_Timer.start(comment_timeout)

func clear_comment_text():
	$Comment_Timer.stop()
	_hide_comment_box()

func _on_comment_timer_timeout():
	_hide_comment_box()

func _hide_comment_box():
	$Boxes/CenterContainer.hide()
	comment_closed.emit()

func _on_three_points_gui_input(event: InputEvent):
	if event.is_action_pressed("left_mouse_click"):
		$Boxes/Dialogue_Box/BG/Next/Three_Points.accept_event()
		emit_signal("_next_click")

func _on_dialogue_1_gui_input(event: InputEvent):
	if event.is_action_pressed("left_mouse_click"):
		$Boxes/Dialogue_Box/BG/Dialogue.accept_event()
		# if Dialogue2 is visible, we are waiting for the user to choose
		if $Boxes/Dialogue_Box/BG2/Dialogue2.visible:
			_click_on_choice.emit(0)
		# if not, we may be typing
		else:
			$Boxes/Dialogue_Box/BG/Dialogue.visible_characters = -1

func _on_dialogue_2_gui_input(event: InputEvent):
	if event.is_action_pressed("left_mouse_click"):
		$Boxes/Dialogue_Box/BG2/Dialogue2.accept_event()
		_click_on_choice.emit(1)

func _on_dialogue_3_gui_input(event: InputEvent):
	if event.is_action_pressed("left_mouse_click"):
		$Boxes/Dialogue_Box/BG3/Dialogue3.accept_event()
		_click_on_choice.emit(2)

func _on_dialogue_4_gui_input(event: InputEvent):
	if event.is_action_pressed("left_mouse_click"):
		$Boxes/Dialogue_Box/BG4/Dialogue4.accept_event()
		_click_on_choice.emit(3)

func _on_dialogue_1_mouse_entered():
	if $Boxes/Dialogue_Box/BG2/Dialogue2.visible:
		$Boxes/Dialogue_Box/BG/Dialogue.self_modulate = highlighted_text_color
		$Boxes/Dialogue_Box/BG2/Dialogue2.self_modulate = _choice_text_color
		$Boxes/Dialogue_Box/BG3/Dialogue3.self_modulate = _choice_text_color
		$Boxes/Dialogue_Box/BG4/Dialogue4.self_modulate = _choice_text_color

func _on_dialogue_2_mouse_entered():
	$Boxes/Dialogue_Box/BG/Dialogue.self_modulate = _choice_text_color
	$Boxes/Dialogue_Box/BG2/Dialogue2.self_modulate = highlighted_text_color
	$Boxes/Dialogue_Box/BG3/Dialogue3.self_modulate = _choice_text_color
	$Boxes/Dialogue_Box/BG4/Dialogue4.self_modulate = _choice_text_color

func _on_dialogue_3_mouse_entered():
	$Boxes/Dialogue_Box/BG/Dialogue.self_modulate = _choice_text_color
	$Boxes/Dialogue_Box/BG2/Dialogue2.self_modulate = _choice_text_color
	$Boxes/Dialogue_Box/BG3/Dialogue3.self_modulate = highlighted_text_color
	$Boxes/Dialogue_Box/BG4/Dialogue4.self_modulate = _choice_text_color

func _on_dialogue_4_mouse_entered():
	$Boxes/Dialogue_Box/BG/Dialogue.self_modulate = _choice_text_color
	$Boxes/Dialogue_Box/BG2/Dialogue2.self_modulate = _choice_text_color
	$Boxes/Dialogue_Box/BG3/Dialogue3.self_modulate = _choice_text_color
	$Boxes/Dialogue_Box/BG4/Dialogue4.self_modulate = highlighted_text_color

func _set_mouse_cursor(cursor: int):
	$Mouse.set_cursor(cursor)

##
## Specifies that no action cursors are available in the current context. The
## current cursor is set to CROSS_PASSIVE (unless a "use inventory item"
## operation is in progress).
##
func clear_available_cursors():
	_available_cursors.clear()
	if _inventory_item_being_used < 0:
		_current_cursor = -1
		_set_mouse_cursor(Globals.Cursor.CROSS_PASSIVE)
	else:
		_set_mouse_cursor(Globals.Cursor.ARROW_PASSIVE)

##
## Specifies the set of action cursors available in the current context. The
## current cursor is set to the first in the list; prev_cursor and next_cursor
## UI events cycle through the list (unless a "use inventory item" operation is
## in progress).
##
func set_available_cursors(cursors: Array[int]):
	if cursors.is_empty():
		clear_available_cursors()
	else:
		_available_cursors = cursors
		if _inventory_item_being_used < 0:
			_current_cursor = 0
			_set_mouse_cursor(cursors[0])
		else:
			_set_mouse_cursor(Globals.Cursor.ARROW_ACTIVE)

func get_current_cursor() -> int:
	if _inventory_item_being_used >= 0:
		if _is_inventory_open:
			if _current_inventory_index >= 0:
				return Globals.Cursor.ARROW_ACTIVE
			else:
				return Globals.Cursor.ARROW_PASSIVE
		else:
			if _available_cursors.is_empty():
				return Globals.Cursor.ARROW_PASSIVE
			else:
				return Globals.Cursor.ARROW_ACTIVE
	elif _current_cursor < 0:
		return Globals.Cursor.CROSS_PASSIVE
	elif _is_inventory_open:
		return _inventory_cursors[_current_cursor]
	else:
		return _available_cursors[_current_cursor]

func _next_cursor():
	if _inventory_item_being_used >= 0:
		return
	elif _is_inventory_open:
		_current_cursor = (_current_cursor + 1) % _inventory_cursors.size()
		_set_mouse_cursor(_inventory_cursors[_current_cursor])
	elif _available_cursors.size() > 1:
		_current_cursor = (_current_cursor + 1) % _available_cursors.size()
		_set_mouse_cursor(_available_cursors[_current_cursor])

func _prev_cursor():
	if _inventory_item_being_used >= 0:
		return
	elif _is_inventory_open:
		_current_cursor = posmod(_current_cursor - 1, _inventory_cursors.size())
		_set_mouse_cursor(_inventory_cursors[_current_cursor])
	elif _available_cursors.size() > 1:
		_current_cursor = posmod(_current_cursor - 1, _available_cursors.size())
		_set_mouse_cursor(_available_cursors[_current_cursor])

func is_inventory_open() -> bool:
	return _is_inventory_open

func is_tutorial_open() -> bool:
	return $Boxes/Tutorial.visible

func _on_help_button_entered(_area: Area2D):
	if not (is_dialogue_visible() or is_tutorial_open() or $Help.visible):
		$Help_AnimationPlayer.play("Help_On")

func _on_help_button_exited(_area: Area2D):
	if not is_dialogue_visible() and _is_tutorial_seen:
		$Help_AnimationPlayer.play("Help_Off")

func _on_help_gui_input(event: InputEvent):
	if event.is_action_pressed("left_mouse_click"):
		$Boxes/Tutorial.show()
		_is_tutorial_seen = true

func _open_inventory():
	$Inventory_AnimationPlayer.play("Open_Inventory")
	clear_comment_text()
	_current_cursor = 0
	if _inventory_item_being_used >= 0:
		_set_mouse_cursor(Globals.Cursor.ARROW_PASSIVE)
	else:
		_set_mouse_cursor(_inventory_cursors[0])
	_set_current_inventory_item(-1)
	_is_inventory_open = true

func _close_inventory():
	$Close_Inventory_Timer.stop()
	$Inventory_AnimationPlayer.play("Close_Inventory")
	_is_inventory_open = false
	if _inventory_item_being_used < 0:
		if _available_cursors.is_empty():
			_current_cursor = -1
			_set_mouse_cursor(Globals.Cursor.CROSS_PASSIVE)
		else:
			_current_cursor = 0
			_set_mouse_cursor(_available_cursors[0])

func _update_inventory_labels():
	var items = _inventory_contents.keys()
	for i in _max_inventory_size:
		var label: Label = get_node(
			"Boxes/Inventory_Box/BG%d/Inventory%d" % [i+1, i+1])
		if i < _inventory_contents.size():
			label.text = _inventory_contents[items[i]]
		else:
			label.text = ""

##
## Removes all items from the inventory.
##
func clear_inventory():
	_inventory_contents.clear()
	_update_inventory_labels()

##
## Searches for an item in the inventory and returns its index, if it is found,
## or -1 if not. The [param item] parameter is a constant from [enum
## Globals.Prop].
##
func find_in_inventory(item: int) -> int:
	return _inventory_contents.keys().find(item)

##
## This can be used either to add an item to the inventory or to update the
## label of an item that is already there. It is assumed that the inventory has
## room for the new item, if it is not already there.
##
func add_to_inventory(item: int, label: String):
	_inventory_contents[item] = label
	_update_inventory_labels()

##
## Removes an item from the inventory, where 0 <= [param index] < the number of
## items in the inventory.
##
func remove_from_inventory(index: int):
	var item = _inventory_contents.keys()[index]
	inventory_item_removed.emit(item)
	_inventory_contents.erase(item)
	_update_inventory_labels()

func is_inventory_full() -> bool:
	return _inventory_contents.size() >= _max_inventory_size

##
## Returns true if the user has requested to use an item in the inventory and we
## are waiting for him to choose the target object.
##
func is_inventory_item_being_used() -> bool:
	return _inventory_item_being_used >= 0

##
## Returns the number of the item in the inventory that the user has requested
## to use: either a constant from [enum Globals.Prop], or -1 if no item is being
## used.
##
func get_inventory_item_being_used() -> int:
	return _inventory_item_being_used

##
## Call this if the user has clicked somewhere after requesting that an item in
## the inventory be used. He may have clicked on the target object, or in empty
## space to abort, for example. In any case, the operation is terminated and the
## previous mouse cursor is restored.
##
func stop_using_inventory_item():
	_inventory_item_being_used = -1
	if _available_cursors.is_empty():
		_current_cursor = -1
		_set_mouse_cursor(Globals.Cursor.CROSS_PASSIVE)
	else:
		_current_cursor = 0
		_set_mouse_cursor(_available_cursors[0])

func _set_current_inventory_item(index: int):
	if index >= _inventory_contents.size():
		index = -1

	if _inventory_item_being_used >= 0:
		if index >= 0:
			_set_mouse_cursor(Globals.Cursor.ARROW_ACTIVE)
		else:
			_set_mouse_cursor(Globals.Cursor.ARROW_PASSIVE)

	for i in _inventory_contents.size():
		var label: Label = get_node(
			"Boxes/Inventory_Box/BG%d/Inventory%d" % [i+1, i+1])
		if (_inventory_item_being_used >= 0 and
			_inventory_contents.keys()[i] == _inventory_item_being_used):
			label.self_modulate = rowena_text_color
		elif i == index:
			if _inventory_item_being_used < 0:
				label.self_modulate = rowena_text_color
			else:
				label.self_modulate = doctor_text_color
		else:
			label.self_modulate = Color.WHITE

	_current_inventory_index = index

func _on_inventory_1_mouse_entered():
	_set_current_inventory_item(0)

func _on_inventory_2_mouse_entered():
	_set_current_inventory_item(1)

func _on_inventory_3_mouse_entered():
	_set_current_inventory_item(2)

func _on_inventory_4_mouse_entered():
	_set_current_inventory_item(3)

func _on_inventory_gui_input(event: InputEvent):
	if event.is_action_pressed("left_mouse_click"):
		_click_on_inventory_item()

func _click_on_inventory_item():
	if _inventory_item_being_used >= 0:
		var object1 = _inventory_item_being_used
		_inventory_item_being_used = -1
		if _current_inventory_index >= 0:
			var object2 = _inventory_contents.keys()[_current_inventory_index]
			_close_inventory()
			use_object_on_other.emit(object1, object2)
		else:
			_current_cursor = 0
			_set_mouse_cursor(_inventory_cursors[0])

	elif _current_inventory_index >= 0:
		match _inventory_cursors[_current_cursor]:
			Globals.Cursor.HAND:
				_inventory_item_being_used = _inventory_contents.keys()[_current_inventory_index]
				_set_mouse_cursor(Globals.Cursor.ARROW_ACTIVE)
			Globals.Cursor.TRASH:
				remove_from_inventory(_current_inventory_index)
				if _inventory_contents.is_empty():
					_close_inventory()
				else:
					_set_current_inventory_item(_current_inventory_index)

func _on_close_inventory_timer_timeout():
	if _is_inventory_open:
		_close_inventory()

func _on_comment_box_gui_input(event):
	if event.is_action_pressed("left_mouse_click"):
		clear_comment_text()
