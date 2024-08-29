extends CharacterBody2D

## Walking speed in pixels/second.
const SPEED = 40.0

## Signal emitted by [method get_something] when Rowena's hand reaches the
## target.
signal get_something_reached

## Signal emitted by [method get_something] when the animation has finished.
signal get_something_done

## Signal emitted when Rowena has reached the target set by [method
## walk_to_area].
signal target_area_reached

# X coordinate that Rowena is walking toward.
var _target_x: float

# Area2D collider that Rowena is walking toward.
var _target_area: Area2D

# true if Rowena is walking toward the origin of _target_area.
var _walk_to_area_origin: bool

# Counts Wait_Base animation cycles to time other wait animations occasionally.
var _wait_cycle_count = 0

func _ready():
	_target_x = position.x

func _physics_process(_delta: float):
	var dir = 0

	if _target_area:
		var done
		if _walk_to_area_origin:
			done = (absf(_target_area.global_position.x - position.x) < 1)
		else:
			done = _target_area.overlaps_body(self)
		if done:
			_target_area = null
			_target_x = position.x
			target_area_reached.emit()
			return
		dir = 1 if _target_area.global_position.x > position.x else -1
	elif absf(_target_x - position.x) >= 1:
		dir = 1 if _target_x > position.x else -1

	if dir == 0:
		_wait_cycle()
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

##
## Walks toward the given X coordinate. Ignored if Rowena is walking toward an
## Area2D collider, that is, if [method walk_to_area] has been called and
## [signal target_area_reached] has not yet been emitted.
##
func walk_to_x(x: float):
	_target_x = x

##
## Walks toward the given Area2D collider and stops when it intersects with
## Rowena's collider. When that happens, [signal target_area_reached] is
## emitted.
##
## If Rowena's collider already intersects [param area]'s, false is returned,
## and [signal target_area_reached] is NOT emitted.
##
func walk_to_area(area: Area2D) -> bool:
	if area.overlaps_body(self):
		look_at_x(area.global_position.x)
		return false
	else:
		_target_area = area
		_walk_to_area_origin = false
		return true

##
## Similar to [method walk_to_area], but Rowena walks all the way to the origin
## of the given collider, rather than stopping when she gets close enough. When
## she arrives at the origin of the collider, [signal target_area_reached] is
## emitted.
##
## If Rowena is already at the origin of the collider, false is returned, and
## [signal target_area_reached] is NOT emitted.
##
func walk_to_area_origin(area: Area2D) -> bool:
	if absf(area.global_position.x - position.x) < 1:
		return false
	else:
		_target_area = area
		_walk_to_area_origin = true
		return true

func get_global_bbox() -> Rect2:
	var rect_shape: RectangleShape2D = $ROWENA_Collider.shape
	var size: Vector2 = rect_shape.size
	var pos: Vector2 = $ROWENA_Collider.global_position
	return Rect2(pos - size/2, size)

##
## Plays the animations used when Rowena gets an object, or opens/closes
## something. [param height] is a value between 0 and 5 (inclusive) indicating
## the height of the relevant object: 0 is the lowest, 4 and 5 are the highest.
## If [param with_sound] is true, a sound is played when her hand reaches the
## object.
##
## Two signals are emitted: [signal get_something_reached] when Rowena's hand
## reaches the point where she can touch the object, and [signal
## get_something_done] when all the animations have finished.
##
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
	get_something_reached.emit()
	if with_sound:
		$Open_Close.play()
	await $ROWENA_AnimationPlayer.animation_finished
	get_something_done.emit()
	set_physics_process(true)

##
## Plays the required animations when Rowena turns away to do something, then
## turns back. Inbetween, the Do_Stuff animation is played. If [param
## with_sound] is true, a sound effect is played as well.
##
func do_stuff(with_sound: bool):
	set_physics_process(false)
	$ROWENA_AnimationPlayer.play("Turn_Back")
	await $ROWENA_AnimationPlayer.animation_finished
	$ROWENA_AnimationPlayer.play("Do_Stuff")
	if with_sound:
		$Do_Stuff.play()
	await $ROWENA_AnimationPlayer.animation_finished
	$ROWENA_AnimationPlayer.play("Turn_Front")
	await $ROWENA_AnimationPlayer.animation_finished
	set_physics_process(true)

##
## Plays the required animations when Rowena turns away to do something
## disgusting, then turns back. Inbetween, the Do_Erk_Stuff animation is
## played.
##
func do_erk_stuff():
	set_physics_process(false)
	$ROWENA_AnimationPlayer.play("Turn_Back")
	await $ROWENA_AnimationPlayer.animation_finished
	$ROWENA_AnimationPlayer.play("Do_Erk_Stuff")
	await $ROWENA_AnimationPlayer.animation_finished
	$ROWENA_AnimationPlayer.play("Turn_Front")
	await $ROWENA_AnimationPlayer.animation_finished
	set_physics_process(true)

#
# Starts Rowena's wait animation cycle. Does nothing if she is already waiting.
#
func _wait_cycle():
	if not $ROWENA_AnimationPlayer.current_animation.begins_with("Wait"):
		_wait_cycle_count = 0
		$ROWENA_AnimationPlayer.play("Wait_Base")

#
# Callback invoked whenever an animation begins. If Rowena is waiting, then
# occasionally, after 5-10 Wait_Base animation cycles, the Wait_Nails or
# Wait_Towel animation is played.
#
func _on_animation_started(anim_name: String):
	if anim_name.begins_with("Wait"):
		var next_anim = "Wait_Base"
		if anim_name == "Wait_Base" and _wait_cycle_count >= 4:
			var f = randf()
			if f < 0.2:
				next_anim = "Wait_Nails" if f < 0.1 else "Wait_Towel"
				_wait_cycle_count = 0
		$ROWENA_AnimationPlayer.queue(next_anim)
		_wait_cycle_count += 1
