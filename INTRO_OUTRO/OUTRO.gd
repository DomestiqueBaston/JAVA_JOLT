extends Node2D

## Signal emitted when it is time to turn off the radio, if it is still on. It
## is emitted by Animation_Outro.
@warning_ignore("unused_signal")
signal music_off

func _on_animation_outro_animation_finished(_anim_name):
	get_tree().quit()
