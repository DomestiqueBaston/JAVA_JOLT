extends Node2D


var next_scene = load("res://JAVA_JOLT.tscn")

func _on_animation_screens_animation_finished(_anim_name):
	get_tree().change_scene_to_packed(next_scene)
