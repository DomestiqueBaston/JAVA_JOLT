extends Node

var the_game = preload("res://JAVA_JOLT.tscn")

func _on_intro_radio_on():
	$RadioPlayer.play()

func _on_intro_intro_done():
	$INTRO.queue_free()
	#var game_instance = the_game.instantiate()
	#game_instance.skip_dialogues = false
	var game_instance = $JAVA_JOLT.create_instance()
	add_child(game_instance)
