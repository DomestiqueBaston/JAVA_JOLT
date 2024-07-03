extends Node2D


func _on_animation_outro_animation_finished(_anim_name):
	get_tree().quit()
