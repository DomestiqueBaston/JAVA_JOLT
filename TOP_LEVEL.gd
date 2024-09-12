extends Node

var intro = preload("res://INTRO_OUTRO/INTRO.tscn").instantiate()
var game = preload("res://JAVA_JOLT.tscn").instantiate()

func _ready():
	add_child(intro)
	intro.radio_on.connect(_on_intro_radio_on)
	intro.intro_done.connect(_on_intro_intro_done)
	game.skip_dialogues = false

func _on_intro_radio_on():
	$RadioPlayer.play()

func _on_intro_intro_done():
	intro.queue_free()
	add_child(game)
