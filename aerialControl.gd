extends CharacterBody3D

@export var thrust_force: float = 10.0
@export var max_speed: float = 100.0
@export var rotation_speed: float = 0.6
@export var lift_factor: float = 0.6
@export var drag: float = 0.02

var current_throttle: float = 0.0

func _physics_process(delta: float) -> void:
	_handle_input(delta)
	_apply_physics(delta)
	move_and_slide()

func _handle_input(delta: float) -> void:
	# Throttle control
	if Input.is_action_pressed("throttle_up"):
		current_throttle = clamp(current_throttle + delta, 0.0, 1.0)
	elif Input.is_action_pressed("throttle_down"):
		current_throttle = clamp(current_throttle - delta, 0.0, 1.0)

	# Rotation input
	var pitch_input := Input.get_action_strength("pitch_down") - Input.get_action_strength("pitch_up")
	var yaw_input := Input.get_action_strength("yaw_right") - Input.get_action_strength("yaw_left")
	var roll_input := Input.get_action_strength("roll_right") - Input.get_action_strength("roll_left")

	var rotation_delta := Vector3(-pitch_input, - yaw_input, -roll_input) * rotation_speed * delta
	rotate_object_local(Vector3.RIGHT, rotation_delta.x)
	rotate_y(rotation_delta.y)
	rotate_object_local(Vector3.BACK, rotation_delta.z)

func _apply_physics(delta: float) -> void:
	var forward := -transform.basis.z
	var target_velocity := forward * thrust_force * current_throttle
	velocity = velocity.lerp(target_velocity, 0.1)

	# Simple lift
	var up := transform.basis.y
	velocity += up * (velocity.length() * lift_factor * delta)

	# Drag
	velocity -= velocity * drag * delta

	# Cap speed
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
