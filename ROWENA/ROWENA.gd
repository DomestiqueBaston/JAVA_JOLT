extends CharacterBody2D

const SPEED = 40.0

var target_x: float

func _ready():
	target_x = position.x

func _physics_process(_delta: float):
	if absf(target_x - position.x) > 1:
		if target_x > position.x:
			$Rowena_Sprites.scale = Vector2(0.5, 0.5)
			velocity.x = SPEED
		else:
			$Rowena_Sprites.scale = Vector2(-0.5, 0.5)
			velocity.x = -SPEED
		$ROWENA_AnimationPlayer.play("Walk")
	else:
		velocity.x = 0
		$ROWENA_AnimationPlayer.play("Wait_Base")
	move_and_slide()

func walk_to(x: float):
	target_x = x
