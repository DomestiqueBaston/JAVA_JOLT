extends Node

## Skip the intro and go straight to the game.
@export var skip_intro := false

## Don't display any dialogues.
@export var skip_dialogues := false

## File where game state is saved.
const save_file = "user://save.json"

## Time (in seconds from start of radio program) when the game starts.
const time_at_start = 13.2

var intro = preload("res://INTRO_OUTRO/INTRO.tscn").instantiate()
var game = preload("res://JAVA_JOLT.tscn").instantiate()
var outro = preload("res://INTRO_OUTRO/OUTRO.tscn").instantiate()

func _ready():
	game.skip_dialogues = skip_dialogues
	game.auto_start_chapter = 0
	game.quit.connect(_on_quit)
	get_tree().root.close_requested.connect(_on_close_requested)
	if skip_intro or FileAccess.file_exists(save_file):
		Globals.play_radio_at(time_at_start)
		_start_game()
	else:
		intro.radio_on.connect(_on_intro_radio_on)
		intro.intro_done.connect(_on_intro_intro_done)
		add_child(intro)

#
# Called when the intro emits its radio_on signal: turns on the radio.
#
func _on_intro_radio_on():
	Globals.play_radio_at(0)

#
# Called when the intro finishes: closes the intro and starts the game.
#
func _on_intro_intro_done():
	intro.queue_free()
	_start_game()

#
# Called when the user clicks on the window's close button: saves the game
# first.
#
func _on_close_requested():
	_save_game()

#
# Called when the game scene emits its quit signal, meaning Rowena has jumped
# out the window: saves the game, then quits.
#
func _on_quit():
	_save_game()
	get_tree().quit()

#
# Called when Rowena has left the kitchen: plays the outro scene and turns off
# the radio.
#
func _on_game_over():
	game.queue_free()
	outro.music_off.connect(Globals.stop_radio)
	add_child(outro)

#
# Starts the game...
#
func _start_game():
	game.game_over.connect(_on_game_over)
	add_child(game)
	if not _load_game():
		game.start()

#
# Saves the current state of the game.
#
func _save_game():
	if is_instance_valid(game) and game.is_inside_tree():
		var dict = game.save_game()
		var file = FileAccess.open(save_file, FileAccess.WRITE)
		file.store_line(JSON.stringify(dict, "\t"))

#
# Reloads the state of the game, if a save file is found.
#
func _load_game():
	var json_str = FileAccess.get_file_as_string(save_file)
	if json_str:
		var json = JSON.new()
		if json.parse(json_str) == OK:
			var dict = json.get_data()
			if dict is Dictionary:
				game.load_game(dict)
				return true
	return false
