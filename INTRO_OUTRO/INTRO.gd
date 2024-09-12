extends Node2D

signal radio_on
signal intro_done

func turn_on_radio():
	radio_on.emit()

func _on_animation_intro_animation_finished(_anim_name):
	intro_done.emit()
