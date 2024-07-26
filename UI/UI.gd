extends CanvasLayer

enum { ROWENA, DOCTOR }

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

# Color of unhighlighted text options in current dialogue.
var _choice_text_color: Color

## Which dialogue to start with (for testing), 0 for none.
@export_range(0, 3) var dialogue_number: int = 0

var _available_cursors: Array[int] = []
var _current_cursor: int = -1

## Signal emitted when user clicks somewhere to make Rowena move.
signal click_on_background(pos: Vector2)

signal _typing_finished
signal _next_click
signal _click_on_choice(which: int)

const dialogue1 = preload("res://dialogue1.json").data
const dialogue2 = preload("res://dialogue2.json").data
const dialogue3 = preload("res://dialogue3.json").data

func _ready():
	match dialogue_number:
		1:
			_tell_story_node(dialogue1, dialogue1["start"])
		2:
			_tell_story_node(dialogue2, dialogue2["start"])
		3:
			_tell_story_node(dialogue3, dialogue3["start"])

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("left_mouse_click"):
		if not is_dialogue_visible():
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
	$Boxes/CenterContainer/Comment_Box.show()

func clear_comment_text():
	$Boxes/CenterContainer/Comment_Box.hide()

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

func clear_available_cursors():
	_available_cursors.clear()
	_current_cursor = -1
	_set_mouse_cursor(Globals.Cursor.CROSS_PASSIVE)

func set_available_cursors(cursors: Array[int]):
	if cursors.is_empty():
		clear_available_cursors()
	else:
		_available_cursors = cursors
		_current_cursor = 0
		_set_mouse_cursor(cursors[0])

func get_current_cursor() -> int:
	if _current_cursor < 0:
		return Globals.Cursor.CROSS_PASSIVE
	else:
		return _available_cursors[_current_cursor]

func _next_cursor():
	if _available_cursors.size() > 1:
		_current_cursor = (_current_cursor + 1) % _available_cursors.size()
		_set_mouse_cursor(_available_cursors[_current_cursor])

func _prev_cursor():
	if _available_cursors.size() > 1:
		_current_cursor = posmod(_current_cursor - 1, _available_cursors.size())
		_set_mouse_cursor(_available_cursors[_current_cursor])
