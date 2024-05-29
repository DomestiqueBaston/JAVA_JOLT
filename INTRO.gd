extends Node2D


func _on_animation_screens_animation_finished(_anim_name):
	get_tree().change_scene_to_file("res://JAVA_JOLT.tscn")
