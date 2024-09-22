extends CharacterBody2D

## Walking speed in pixels/second.
const SPEED = 40.0

## Signal emitted by [method get_something] when Rowena's hand reaches the
## target.
signal get_something_reached

## Signal emitted by [method get_something] when the animation has finished.
signal get_something_done

## Signal emitted when Rowena has reached the target set by walk_to_area(]).
signal target_area_reached

# Signal emitted by Phone_Call animation when Rowena answers the phone.
signal _phone_answered

# X coordinate that Rowena is walking toward.
var _target_x: float

# Area2D collider that Rowena is walking toward.
var _target_area: Area2D

enum AreaMode {
	WALK_TO_EDGE,
	WALK_TO_ORIGIN,
	LEAVE
}

# is Rowena is walking toward _target_area, toward its origin, or away from it?
var _walk_to_area_mode: int

# Counts Wait_Base animation cycles to time other wait animations occasionally.
var _wait_cycle_count = 0

func _ready():
	_target_x = position.x

func _physics_process(_delta: float):
	var dir = 0

	if _target_area:
		var done
		match _walk_to_area_mode:
			AreaMode.WALK_TO_EDGE:
				done = _target_area.overlaps_body(self)
			AreaMode.WALK_TO_ORIGIN:
				done = (absf(_target_area.global_position.x - position.x) < 1)
			AreaMode.LEAVE:
				done = not _target_area.overlaps_body(self)
		if done:
			_target_area = null
			_target_x = position.x
			target_area_reached.emit()
			return
		if _walk_to_area_mode == AreaMode.LEAVE:
			dir = 1
		else:
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
## Walks toward the given X coordinate. Ignored if [method is_busy()] returns
## true.
##
func walk_to_x(x: float):
	if not is_busy():
		_target_x = x

##
## Walks toward the given Area2D collider and stops when it intersects with
## Rowena's collider or, if [param to_origin] is true, when she reaches the
## collider's origin. This is a coroutine; use await to block until Rowena
## reaches her target.
##
## If [param blocking] is true, the method blocks until Rowena reaches her
## destination. If false, the method returns immediately, but you can still
## be notified by the [signal target_area_reached] signal.
##
## Does nothing if [method is_busy()] returns true.
##
func walk_to_area(area: Area2D, to_origin: bool = false, blocking: bool = true):
	if is_busy():
		return
	_target_area = area
	_walk_to_area_mode = \
		AreaMode.WALK_TO_ORIGIN if to_origin else AreaMode.WALK_TO_EDGE
	if blocking:
		await target_area_reached

##
## Similar to [method walk_to_area], but Rowena walks to the right until she
## exits the given collider.
##
func walk_out_of_area(area: Area2D):
	if is_busy():
		return
	_target_area = area
	_walk_to_area_mode = AreaMode.LEAVE
	await target_area_reached

##
## Aborts a previous call to [method walk_to_area]: Rowena stops walking.
##
func abort_walk_to_area():
	_target_area = null
	_target_x = position.x

##
## Returns true if Rowena is busy doing something: walking to a given area or
## doing an animation.
##
func is_busy() -> bool:
	return _target_area != null or not is_physics_processing()

func get_global_bbox() -> Rect2:
	var rect_shape: RectangleShape2D = $ROWENA_Collider.shape
	var size: Vector2 = rect_shape.size
	var pos: Vector2 = $ROWENA_Collider.global_position
	return Rect2(pos - size/2, size)

##
## Plays the animations used when Rowena gets an object, or opens/closes
## something. [param y] is the location in Y of the object, and determines
## which animation is used.
##
## Two signals are emitted: [signal get_something_reached] when Rowena's hand
## reaches the point where she can touch the object, and [signal
## get_something_done] when all the animations have finished. If you don't need
## to know when her hand reaches the object, just use await to block until this
## method finishes.
##
## Does nothing if is_busy() returns true.
##
func get_something_at(y: float):
	if is_busy():
		return

	var anim
	var delay = 0.8
	if y > 55:
		anim = "Get_Something_Lowest"
	elif y > 45:
		anim = "Get_Something_Low"
		delay = 0.7
	elif y > 39:
		anim = "Get_Something_Low_Mid"
	elif y > 27:
		anim = "Get_Something_Mid"
	elif randf() < 0.5:
		anim = "Get_Something_High_1"
	else:
		anim = "Get_Something_High_2"

	set_physics_process(false)
	$ROWENA_AnimationPlayer.play(anim)
	await get_tree().create_timer(delay).timeout
	get_something_reached.emit()
	await $ROWENA_AnimationPlayer.animation_finished
	set_physics_process(true)
	get_something_done.emit()

##
## Plays the required animations when Rowena turns away to do something, then
## turns back. Inbetween, the Do_Stuff animation is played. If [param sound] is
## given, a sound effect is played as well. This is a coroutine; use await to
## block until it finishes.
##
## Does nothing if is_busy() returns true.
##
func do_stuff(sound: AudioStreamPlayer = null):
	if is_busy():
		return
	set_physics_process(false)
	$ROWENA_AnimationPlayer.play("Turn_Back")
	await $ROWENA_AnimationPlayer.animation_finished
	$ROWENA_AnimationPlayer.play("Do_Stuff")
	if sound:
		sound.play()
	await $ROWENA_AnimationPlayer.animation_finished
	$ROWENA_AnimationPlayer.play("Turn_Front")
	await $ROWENA_AnimationPlayer.animation_finished
	set_physics_process(true)

##
## Plays the required animations when Rowena turns away to do something
## disgusting, then turns back. Inbetween, the Do_Erk_Stuff animation is
## played. And then the Spitting_Out animation, if [param and_spit] is true.
## This is a coroutine; use await to block until it finishes.
##
## Does nothing if is_busy() returns true.
##
func do_erk_stuff(and_spit: bool = false):
	if is_busy():
		return
	set_physics_process(false)
	$ROWENA_AnimationPlayer.play("Turn_Back")
	await $ROWENA_AnimationPlayer.animation_finished
	$ROWENA_AnimationPlayer.play("Do_Erk_Stuff")
	await $ROWENA_AnimationPlayer.animation_finished
	if and_spit:
		$ROWENA_AnimationPlayer.play("Spitting_Out")
		await $ROWENA_AnimationPlayer.animation_finished
	$ROWENA_AnimationPlayer.play("Turn_Front")
	await $ROWENA_AnimationPlayer.animation_finished
	set_physics_process(true)

##
## Plays the required animations when Rowena puts the coffee patch on her arm
## or removes it. This is a coroutine; use await to block until it finishes.
##
## Does nothing if is_busy() returns true.
##
func do_patch_stuff():
	if is_busy():
		return
	set_physics_process(false)
	$ROWENA_AnimationPlayer.play("Turn_Back")
	await $ROWENA_AnimationPlayer.animation_finished
	$ROWENA_AnimationPlayer.play("Sticking_Patch")
	await $ROWENA_AnimationPlayer.animation_finished
	$ROWENA_AnimationPlayer.play("Turn_Front")
	await $ROWENA_AnimationPlayer.animation_finished
	set_physics_process(true)

##
## Plays the phone call animation up until the frame where Rowena answers, then
## pauses. You must call [method play_phone_call_2] afterwards!
##
func play_phone_call_1():
	if is_busy():
		return
	set_physics_process(false)
	$ROWENA_AnimationPlayer.play("Phone_Call")
	await _phone_answered

#
# Invoked by the Phone_Call animation when Rowena answers the phone.
#
func _answer_phone():
	$ROWENA_AnimationPlayer.pause()
	_phone_answered.emit()

##
## Plays the rest of the phone call animation, starting from where [method
## play_phone_call_1] left off.
##
func play_phone_call_2():
	$ROWENA_AnimationPlayer.play()
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

##
## Plays a reaction animation (Nonsense, Stop_That or WtF), or not, at random.
## Does nothing if [method is_busy] returns true.
##
func respond_to_doctor_maybe():
	if is_busy():
		return
	var f = randf()
	if f < 0.25:
		set_physics_process(false)
		if f < 0.0833:
			$ROWENA_AnimationPlayer.play("Nonsense")
		elif f < 0.1667:
			$ROWENA_AnimationPlayer.play("Stop_That")
		else:
			$ROWENA_AnimationPlayer.play("WtF")
		await $ROWENA_AnimationPlayer.animation_finished
		set_physics_process(true)
