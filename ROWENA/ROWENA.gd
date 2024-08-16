extends CharacterBody2D

const SPEED = 40.0

signal got_something
signal target_area_reached

var _target_x: float
var _target_area: Area2D

func _ready():
	_target_x = position.x

func _physics_process(_delta: float):
	var dir = 0

	if _target_area:
		if _target_area.overlaps_body(self):
			_target_area = null
			_target_x = position.x
			target_area_reached.emit()
			return
		dir = 1 if _target_area.global_position.x > position.x else -1
	elif absf(_target_x - position.x) > 1:
		dir = 1 if _target_x > position.x else -1

	if dir == 0:
		$ROWENA_AnimationPlayer.play("Wait_Base")
	else:
		$Rowena_Sprites.scale = Vector2(0.5 * dir, 0.5)
		velocity.x = SPEED * dir
		$ROWENA_AnimationPlayer.play("Walk")
		move_and_slide()

#
# Turns to look in the direction of the given X coordinate.
#
func look_at_x(x: float):
	var dx = position.x - x
	if dx < 0:
		$Rowena_Sprites.scale = Vector2(0.5, 0.5)
	elif dx > 0:
		$Rowena_Sprites.scale = Vector2(-0.5, 0.5)

#
# Walks toward the given X coordinate. Ignored if Rowena is walking toward an
# Area2D collider, that is, if walk_to_area() has been called and the
# target_area_reached() signal has not yet been emitted.
#
func walk_to_x(x: float):
	_target_x = x

#
# Walks toward the given Area2D collider and stops when it intersects with
# Rowena's collider. When that happens, a target_area_reached() signal is
# emitted.
#
# If Rowena's collider already intersects area's, false is returned, and no
# target_area_reached() is emitted.
#
func walk_to_area(area: Area2D) -> bool:
	if area.overlaps_body(self):
		look_at_x(area.global_position.x)
		return false
	else:
		_target_area = area
		return true

func get_global_bbox() -> Rect2:
	var rect_shape: RectangleShape2D = $ROWENA_Collider.shape
	var size: Vector2 = rect_shape.size
	var pos: Vector2 = $ROWENA_Collider.global_position
	return Rect2(pos - size/2, size)

func get_something(height: int, with_sound: bool):
	const animations = [
		"Get_Something_Lowest",
		"Get_Something_Low",
		"Get_Something_Low_Mid",
		"Get_Something_Mid",
		"Get_Something_High_1",
		"Get_Something_High_2",
	]
	set_physics_process(false)
	var anim = clampi(height, 0, animations.size() - 1)
	$ROWENA_AnimationPlayer.play(animations[anim])
	var delay = 0.7 if anim == 1 else 0.8
	await get_tree().create_timer(delay).timeout
	got_something.emit()
	if with_sound:
		$Open_Close.play()
	await $ROWENA_AnimationPlayer.animation_finished
	set_physics_process(true)
