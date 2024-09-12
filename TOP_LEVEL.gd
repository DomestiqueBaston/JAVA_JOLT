extends Node

var game_scene = preload("res://JAVA_JOLT.tscn")

func _on_intro_radio_on():
	$RadioPlayer.play()

func _on_intro_intro_done():
	$INTRO.queue_free()
	var game = game_scene.instantiate()
	game.skip_dialogues = false
	add_child(game)
