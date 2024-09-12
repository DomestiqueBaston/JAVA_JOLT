extends Node

func _on_intro_radio_on():
	$RadioPlayer.play()

func _on_intro_intro_done():
	$INTRO.queue_free()
	add_child($JAVA_JOLT.create_instance())
