extends CharacterBody2D


var speed = 40
var click_position = Vector2()
var target_position = Vector2()
var moving = false


func _ready():
	click_position = position
	$".".show()
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("mouse_click"):
		if $"../Papa_Souris/Souris_curseur".visible == true:
			hide_labels()
			click_position = get_global_mouse_position()
			click_position.y = position.y
		
	if position.distance_to(click_position) > 1:
		target_position = (click_position - position).normalized()
		velocity = target_position * speed
		moving = true
	else:
		moving = false

	if moving == true:
		if moving == true && click_position.x - position.x > 0:
			$Rowena_Sprites.scale = Vector2(-0.5, 0.5)
			$"../Animation_Rowena".play("Walk")
		elif moving == true && click_position.x - position.x < 0:
			$Rowena_Sprites.scale = Vector2(0.5, 0.5)
			$"../Animation_Rowena".play("Walk")
		move_and_slide()
	else:
		click_position.x = position.x
		$"../Animation_Rowena".play("Waiting")
		
#func test_eye_open():
	#if $"../Papa_Souris/Souris_curseur".visible == true && $"../Papa_Souris/Souris_oeil".visible == false:
		#moving = false

func hide_labels():
	$"../Oven".hide()
	$"../Milk".hide()
	$"../Coffee_Maker".hide()
	$"../Radio_Alarm".hide()
