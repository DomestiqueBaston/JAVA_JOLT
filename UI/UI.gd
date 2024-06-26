extends CanvasLayer

enum { ROWENA, DOCTOR }

@export var rowena_text_color := Color(0xed/255.0, 0x6f/255.0, 0x68/255.0)
@export var doctor_text_color := Color(0x5b/255.0, 0x90/255.0, 0xc2/255.0)

signal _typing_finished
signal _next_click

func _ready():
	tell_story()

func tell_story():
	type_dialogue_text("No coffee? This can't be happening...", ROWENA)
	await _typing_finished
	await _next_click
	type_dialogue_text(
		"Ah! Rowena Pitifool! What keeps you going? Your cherished coffee, the \
		faithful companion in your... dry spells. Oh, the trials your... \
		profession must face!", DOCTOR)
	await _typing_finished
	await _next_click
	clear_dialogue()

func _set_dialogue_color(speaker: int):
	if speaker == ROWENA:
		$Boxes/Dialogue_Box/Dialogue.self_modulate = rowena_text_color
	else:
		$Boxes/Dialogue_Box/Dialogue.self_modulate = doctor_text_color

func clear_dialogue():
	$Dialogue_AnimationPlayer.play("Close_Dialogue")

func set_dialogue_text(text: String, speaker: int):
	_set_dialogue_color(speaker)
	$Boxes/Dialogue_Box/Dialogue.text = text
	$Dialogue_AnimationPlayer.play("Open_Dialogue")

func type_dialogue_text(text: String, speaker: int):
	_set_dialogue_color(speaker)
	$Boxes/Dialogue_Box/Dialogue.text = text
	$Boxes/Dialogue_Box/Dialogue.visible_characters = 0
	$Boxes/Dialogue_Box/Typing_Timer.start()
	$Dialogue_AnimationPlayer.play("Open_Dialogue")

func _type_one_character():
	var n = $Boxes/Dialogue_Box/Dialogue.text.length()
	var i = $Boxes/Dialogue_Box/Dialogue.visible_characters
	while i < n:
		i += 1
		if $Boxes/Dialogue_Box/Dialogue.text[i-1] != ' ':
			$Typing.play()
			break
	$Boxes/Dialogue_Box/Dialogue.visible_characters = i
	if i == n:
		$Boxes/Dialogue_Box/Typing_Timer.stop()
		emit_signal("_typing_finished")

func _on_three_points_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("_next_click")
