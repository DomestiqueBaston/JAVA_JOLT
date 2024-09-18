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
@export var comment_timeout_base: float = 2

## Additional comment time for each letter in the comment.
@export var comment_timeout_per_letter: float = 0.05

## Seconds before inventory closes if the user "uses" an object and then moves
## the cursor outside the box.
@export var inventory_timeout: float = 0.3

## Seconds before drawer closes if the user moves the cursor outside the box.
@export var drawer_timeout: float = 1

## If true, only our big cursor is visible.
@export var hide_system_mouse: bool = false

## Signal emitted during a dialogue, when a line of dialogue finishes typing.
## [param speaker] is Globals.ROWENA or Globals.DOCTOR.
signal typing_finished(speaker: int)

## Signal emitted when user clicks somewhere to move or do something.
signal click_on_background(pos: Vector2)

## Signal emitted when user tries to "use" one inventory item on another.
signal use_object_on_other(object1: int, object2: int)

## Signal emitted when user clicks on the trash cursor to remove an item from
## the inventory ([param which] is a constant from [enum Globals.Prop]).
signal trash_inventory_item(which: int)

## Signal emitted when user clicks on an item in the open drawer (a constant
## from [enum Globals.Prop]).
signal drawer_item_picked(which: int)

## Signal emitted when the open drawer is closed.
signal drawer_closed

## Signal emitted when the comment box is closed, automatically or by the user.
signal comment_closed

## Signal emitted when the quit process is interrupted by a mouse click.
signal quit_aborted

enum InventoryMode {
	OFF,
	INVENTORY,
	DRAWER
}

# Color of unhighlighted text options in current dialogue.
var _choice_text_color: Color

# Current speaker during a dialogue.
var _current_speaker: int

# Which cursor actions are currently available.
var _available_cursors: Array[int] = []

# Cursor actions available while the inventory (or a drawer) is open.
var _inventory_cursors: Array[int] = []

# Current cursor action (index into _available_cursors or _inventory_cursors).
var _current_cursor: int = -1

# INVENTORY or DRAWER if the inventory box is open.
var _inventory_mode: int = InventoryMode.OFF

# Inventory contents: maps item numbers (Globals.Prop enum) to label strings.
var _inventory_contents: Dictionary = {}

# Contents of the drawer, when inventory box is opened in DRAWER mode: maps
# item numbers (Globals.Prop enum) to label strings.
var _drawer_contents: Dictionary = {}

# Index (not item ID!) of the highlighted inventory or drawer item.
var _current_inventory_index: int = -1

# Number (Global.Prop enum) of the inventory item being used (arrow cursor).
var _inventory_item_being_used: int = -1

# How many items the inventory can hold.
const _max_inventory_size = 4

# true if the tutorial has been seen
var _is_tutorial_seen: bool = false

# true if a dialogue is in progress
var _is_dialogue_in_progress: bool = false

# Set by start_quit(), reset by _abort_quit().
var _is_quitting: bool = false

# Emitted when the user clicks on "..." to pass to the next line of dialogue.
signal _next_click

# Emitted when the user clicks on one possible response in the dialogue box.
signal _click_on_choice(which: int)

const dialogue1 = preload("res://dialogue1.json").data
const dialogue2 = preload("res://dialogue2.json").data
const dialogue3 = preload("res://dialogue3.json").data

func _ready():
	clear_inventory()
	if hide_system_mouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

#
# If the user has chosen an inventory item to use and then moves the mouse
# outside the inventory box, close the inventory box automatically. It would
# seem cleaner to do this using mouse_entered() and mouse_exited() GUI events,
# but those events are already handled by the Labels inside the inventory box.
# And without a big margin around them, events for their container are not
# triggered reliably.
#
func _input(event: InputEvent):
	if is_inventory_open() and event is InputEventMouseMotion:
		var invbox = $Boxes/Inventory_Box
		var rect = Rect2(invbox.position, invbox.size)
		if rect.has_point(event.position):
			$Close_Inventory_Timer.stop()
		elif _inventory_mode == InventoryMode.DRAWER:
			$Close_Inventory_Timer.start(drawer_timeout)
		elif _inventory_item_being_used >= 0:
			$Close_Inventory_Timer.start(inventory_timeout)

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("left_mouse_click"):
		_abort_quit()
		if is_inventory_open():
			_click_on_inventory_item()
			get_viewport().set_input_as_handled()
		elif is_tutorial_open():
			$Boxes/Tutorial.hide()
			get_viewport().set_input_as_handled()
		elif not is_dialogue_open():
			if event is InputEventMouse:
				click_on_background.emit(event.position)
			else:
				click_on_background.emit($Mouse.position)
			get_viewport().set_input_as_handled()
	elif event.is_action_pressed("next_mouse_action"):
		next_cursor()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("prev_mouse_action"):
		prev_cursor()
		get_viewport().set_input_as_handled()

##
## Plays dialogue number 1, 2 or 3. This is a couroutine; use await to block
## until the dialogue finishes.
##
func tell_story(which: int):
	_is_dialogue_in_progress = true
	_set_mouse_cursor(Globals.Cursor.CROSS_PASSIVE)
	match which:
		1:
			await _tell_story_node(dialogue1, dialogue1["start"])
		2:
			await _tell_story_node(dialogue2, dialogue2["start"])
		3:
			await _tell_story_node(dialogue3, dialogue3["start"])
	_is_dialogue_in_progress = false

func _tell_story_node(graph, node):
	var speaker = _get_node_speaker(node)
	_type_dialogue_text(node.text, speaker)
	await typing_finished
	await _next_click
	var next = node.get("next")
	if typeof(next) == TYPE_ARRAY:
		var texts: Array[String] = []
		for node_name in next:
			texts.append(graph[node_name].text)
		speaker = _get_node_speaker(graph[next[0]])
		var choice = await _choose_response(texts, speaker)
		next = graph[next[choice]].get("next")
	if next:
		await _tell_story_node(graph, graph[next])
	else:
		_clear_dialogue()

func _get_node_speaker(node) -> int:
	return Globals.ROWENA if node.speaker == "rowena" else Globals.DOCTOR

func _set_current_speaker(speaker: int):
	_current_speaker = speaker
	if speaker == Globals.ROWENA:
		$Boxes/Dialogue_Box/BG/Dialogue.self_modulate = rowena_text_color
		$Typing.pitch_scale = 6
	else:
		$Boxes/Dialogue_Box/BG/Dialogue.self_modulate = doctor_text_color
		$Typing.pitch_scale = 1

func is_dialogue_open() -> bool:
	return _is_dialogue_in_progress

func _clear_dialogue():
	$Dialogue_AnimationPlayer.play("Close_Dialogue_1")
	$Boxes/Dialogue_Box/BG/Next.hide()

func _set_dialogue_text(text: String, speaker: int):
	_set_current_speaker(speaker)
	$Boxes/Dialogue_Box/BG/Dialogue.text = text
	$Dialogue_AnimationPlayer.play("Open_Dialogue_1")
	$Boxes/Dialogue_Box/BG/Next.show()

func _type_dialogue_text(text: String, speaker: int):
	_set_current_speaker(speaker)
	$Boxes/Dialogue_Box/BG/Dialogue.text = text
	$Boxes/Dialogue_Box/BG/Dialogue.visible_characters = 0
	$Boxes/Dialogue_Box/BG/Next.hide()
	$Typing_Timer.start(1.0 / characters_per_second)
	$Dialogue_AnimationPlayer.play("Open_Dialogue_1")

func _choose_response(choices: Array[String], speaker: int) -> int:
	_choice_text_color = \
		rowena_text_color if speaker == Globals.ROWENA else doctor_text_color
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
		typing_finished.emit(_current_speaker)
		$Boxes/Dialogue_Box/BG/Next.show()

func set_comment_text(text: String, x: float, left_justify: bool):
	$Boxes/CenterContainer/Comment_Box/Comments.text = text
	if not left_justify:
		x -= $Boxes/CenterContainer/Comment_Box.size.x
	$Boxes/CenterContainer.position.x = x
	$Boxes/CenterContainer.show()
	$Comment_Timer.start(
		comment_timeout_base + comment_timeout_per_letter * text.length())

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
	if not (is_inventory_open() or is_tutorial_open() or is_dialogue_open()):
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
		if not (is_inventory_open() or is_tutorial_open() or is_dialogue_open()):
			if _inventory_item_being_used < 0:
				_current_cursor = 0
				_set_mouse_cursor(cursors[0])
			else:
				_set_mouse_cursor(Globals.Cursor.ARROW_ACTIVE)

func get_current_cursor() -> int:
	if is_dialogue_open():
		return Globals.Cursor.ARROW_PASSIVE
	elif _inventory_item_being_used >= 0:
		if is_inventory_open():
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
	elif is_inventory_open():
		return _inventory_cursors[_current_cursor]
	else:
		return _available_cursors[_current_cursor]

##
## Changes the cursor to the next available one, depending on the context.
##
func next_cursor():
	if _inventory_item_being_used >= 0:
		return
	elif is_inventory_open():
		_current_cursor = (_current_cursor + 1) % _inventory_cursors.size()
		_set_mouse_cursor(_inventory_cursors[_current_cursor])
	elif _available_cursors.size() > 1:
		_current_cursor = (_current_cursor + 1) % _available_cursors.size()
		_set_mouse_cursor(_available_cursors[_current_cursor])

##
## Changes the cursor to the previous available one, depending on the context.
##
func prev_cursor():
	if _inventory_item_being_used >= 0:
		return
	elif is_inventory_open():
		_current_cursor = posmod(_current_cursor - 1, _inventory_cursors.size())
		_set_mouse_cursor(_inventory_cursors[_current_cursor])
	elif _available_cursors.size() > 1:
		_current_cursor = posmod(_current_cursor - 1, _available_cursors.size())
		_set_mouse_cursor(_available_cursors[_current_cursor])

##
## Returns true if the inventory box is open, regardless of whether it is being
## used to display the inventory or the contents of a drawer.
##
func is_inventory_open() -> bool:
	return _inventory_mode != InventoryMode.OFF

func is_tutorial_open() -> bool:
	return $Boxes/Tutorial.visible

func _on_help_button_entered(_area: Area2D):
	if not (is_dialogue_open() or is_tutorial_open() or $Help.visible):
		$Help_AnimationPlayer.play("Help_On")

func _on_help_button_exited(_area: Area2D):
	if not is_dialogue_open() and _is_tutorial_seen and $Help.visible:
		$Help_AnimationPlayer.play("Help_Off")

##
## Makes the help button visible until the user clicks on it to see the
## tuturial.
##
func pin_help_button():
	_is_tutorial_seen = false
	if not $Help.visible:
		$Help_AnimationPlayer.play("Help_On")

##
## Does the opposite of [method pin_help_button]: hides the help button until
## the mouse passes over it.
##
func unpin_help_button():
	_is_tutorial_seen = true
	if $Help.visible:
		$Help_AnimationPlayer.play("Help_Off")

##
## Returns true if the user has seen the tutorial at least once, or if [method
## unpin_help_button] has been called.
##
func is_tutorial_seen() -> bool:
	return _is_tutorial_seen

func _on_help_gui_input(event: InputEvent):
	if event.is_action_pressed("left_mouse_click"):
		_abort_quit()
		if not (is_dialogue_open() or is_inventory_open()):
			$Boxes/Tutorial.show()
			$Help_AnimationPlayer.play("Help_Off")
			_is_tutorial_seen = true

##
## Displays the contents of a drawer, where [param contents] maps item numbers
## (constants from [enum Globals.Prop]) to label strings. The contents remain
## on display until [method close_drawer] is called, or until all the contents
## are removed by [method remove_from_drawer].
##
## Note that drawer contents are displayed using the same GUI controls as the
## inventory, so only one or the other can be shown at a time.
##
func open_drawer(contents: Dictionary):
	if _inventory_mode == InventoryMode.OFF:
		_drawer_contents = contents
		_open_inventory(InventoryMode.DRAWER)

##
## Hides the drawer contents shown previously by [method open_drawer].
##
func close_drawer():
	if _inventory_mode == InventoryMode.DRAWER:
		_drawer_contents.clear()
		await _close_inventory()

##
## Displays the current contents of the inventory. The inventory remains open
## until [method close_inventory] is called, or until the user triggers an
## "inventory_action" in the inventory box, or empties the inventory.
##
## Note that the inventory is displayed using the same GUI controls as drawer
## contents, so only one or the other can be shown at a time.
##
func open_inventory():
	_abort_quit()
	if _inventory_mode == InventoryMode.OFF:
		_open_inventory()

##
## Closes the inventory box after a call to open_inventory().
##
func close_inventory():
	if _inventory_mode == InventoryMode.INVENTORY:
		await _close_inventory()

func _open_inventory(mode: int = InventoryMode.INVENTORY):
	$Inventory_AnimationPlayer.play("Open_Inventory")
	clear_comment_text()

	_inventory_mode = mode
	_current_cursor = 0

	if mode == InventoryMode.INVENTORY:
		_inventory_cursors = [ Globals.Cursor.HAND, Globals.Cursor.TRASH ]
		_update_inventory_labels()
		_set_current_inventory_item(-1)
	else:
		_inventory_cursors = [ Globals.Cursor.HAND ]
		_update_drawer_labels()
		_set_current_drawer_item(-1)

func _close_inventory():
	$Close_Inventory_Timer.stop()
	$Inventory_AnimationPlayer.play("Close_Inventory")

	var mode = _inventory_mode
	_inventory_mode = InventoryMode.OFF
	_inventory_cursors.clear()

	if _inventory_item_being_used < 0:
		if _available_cursors.is_empty():
			_current_cursor = -1
			_set_mouse_cursor(Globals.Cursor.CROSS_PASSIVE)
		else:
			_current_cursor = 0
			_set_mouse_cursor(_available_cursors[0])

	if mode == InventoryMode.DRAWER:
		await $Inventory_AnimationPlayer.animation_finished
		drawer_closed.emit()

func _update_inventory_labels():
	_update_labels(_inventory_contents)

func _update_drawer_labels():
	_update_labels(_drawer_contents)

func _update_labels(contents: Dictionary):
	var keys = contents.keys()
	for i in _max_inventory_size:
		var label: Label = get_node(
			"Boxes/Inventory_Box/BG%d/Inventory%d" % [i+1, i+1])
		if i < contents.size():
			label.text = contents[keys[i]]
		else:
			label.text = ""

##
## Removes all items from the inventory.
##
func clear_inventory():
	_inventory_contents.clear()
	if _inventory_mode == InventoryMode.INVENTORY:
		_update_inventory_labels()

##
## Searches for an item in the inventory and returns its index, if it is found,
## or -1 if not. The [param item] parameter is a constant from [enum
## Globals.Prop].
##
func find_in_inventory(item: int) -> int:
	return _inventory_contents.keys().find(item)

##
## Returns the current contents of the inventory: a Dictionary mapping object
## numbers (from [enum Globals.Prop]) to their labels.
##
func get_inventory() -> Dictionary:
	return _inventory_contents

##
## This can be used either to add an item to the inventory or to update the
## label of an item that is already there. It is assumed that the inventory has
## room for the new item, if it is not already there.
##
func add_to_inventory(item: int, label: String):
	_inventory_contents[item] = label
	if _inventory_mode == InventoryMode.INVENTORY:
		_update_inventory_labels()

##
## Removes an item from the inventory, where [param item] is a constant from
## [enum Globals.Prop].
##
func remove_from_inventory(item: int):
	if (_inventory_contents.erase(item)
		and _inventory_mode == InventoryMode.INVENTORY):
		_set_current_inventory_item(_current_inventory_index)
		_update_inventory_labels()

##
## Removes an item from the open drawer, where [param item] is a constant from
## [enum Globals.Prop].
##
func remove_from_drawer(item: int):
	_drawer_contents.erase(item)
	if _inventory_mode == InventoryMode.DRAWER:
		if _drawer_contents.is_empty():
			await _close_inventory()
		else:
			_update_drawer_labels()

func is_inventory_full() -> bool:
	return _inventory_contents.size() >= _max_inventory_size

func is_inventory_empty() -> bool:
	return _inventory_contents.is_empty()

func get_inventory_room() -> int:
	return _max_inventory_size - _inventory_contents.size()

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
	else:
		_current_cursor = 0
		_set_mouse_cursor(_inventory_cursors[0])

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

func _set_current_drawer_item(index: int):
	if index >= _drawer_contents.size():
		index = -1

	_set_mouse_cursor(_inventory_cursors[0])

	for i in _drawer_contents.size():
		var label: Label = get_node(
			"Boxes/Inventory_Box/BG%d/Inventory%d" % [i+1, i+1])
		if i == index:
			label.self_modulate = rowena_text_color
		else:
			label.self_modulate = doctor_text_color

	_current_inventory_index = index

func _on_inventory_1_mouse_entered():
	match _inventory_mode:
		InventoryMode.INVENTORY:
			_set_current_inventory_item(0)
		InventoryMode.DRAWER:
			_set_current_drawer_item(0)

func _on_inventory_2_mouse_entered():
	match _inventory_mode:
		InventoryMode.INVENTORY:
			_set_current_inventory_item(1)
		InventoryMode.DRAWER:
			_set_current_drawer_item(1)

func _on_inventory_3_mouse_entered():
	match _inventory_mode:
		InventoryMode.INVENTORY:
			_set_current_inventory_item(2)
		InventoryMode.DRAWER:
			_set_current_drawer_item(2)

func _on_inventory_4_mouse_entered():
	match _inventory_mode:
		InventoryMode.INVENTORY:
			_set_current_inventory_item(3)
		InventoryMode.DRAWER:
			_set_current_drawer_item(3)

func _on_inventory_gui_input(event: InputEvent):
	if event.is_action_pressed("left_mouse_click"):
		_click_on_inventory_item()
	elif event.is_action_pressed("inventory_action"):
		await _close_inventory()

func _click_on_inventory_item():
	if _inventory_item_being_used >= 0:
		var object1 = _inventory_item_being_used
		_inventory_item_being_used = -1
		if _current_inventory_index >= 0:
			var object2 = _inventory_contents.keys()[_current_inventory_index]
			await _close_inventory()
			use_object_on_other.emit(object1, object2)
		else:
			_current_cursor = 0
			_set_mouse_cursor(_inventory_cursors[0])

	elif _current_inventory_index >= 0:
		match _inventory_cursors[_current_cursor]:
			Globals.Cursor.HAND:
				if _inventory_mode == InventoryMode.INVENTORY:
					_inventory_item_being_used = \
						_inventory_contents.keys()[_current_inventory_index]
					_set_mouse_cursor(Globals.Cursor.ARROW_ACTIVE)
				else: # InventoryMode.DRAWER
					drawer_item_picked.emit(
						_drawer_contents.keys()[_current_inventory_index])
			Globals.Cursor.TRASH:
				trash_inventory_item.emit(
					_inventory_contents.keys()[_current_inventory_index])

func _on_close_inventory_timer_timeout():
	if is_inventory_open():
		_close_inventory()

func _on_comment_box_gui_input(event):
	if event.is_action_pressed("left_mouse_click"):
		clear_comment_text()

func get_areas_overlapping_mouse() -> Array[Area2D]:
	return $Mouse/Mouse_Collider.get_overlapping_areas()

##
## Sets a flag saying that the user is about to quit. If any mouse click is
## received afterward, a [signal quit_aborted] signal is emitted and the flag
## is reset.
##
func start_quit():
	_is_quitting = true

func _abort_quit():
	if _is_quitting:
		_is_quitting = false
		quit_aborted.emit()
