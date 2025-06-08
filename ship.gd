extends CharacterBody3D

@export var thrust_force: float = 10.0
@export var max_speed: float = 100.0
@export var rotation_speed: float = 0.6
@export var drag: float = 0.02

var current_throttle: float = 0.0

@onready var player = get_tree().get_root().get_node("World/Player")
@onready var camera = get_tree().get_root().get_node("World/CameraRig/Camera3D")

func set_active(is_active: bool):
	set_physics_process(is_active)
	camera.current = is_active

func _physics_process(delta):
	if Global.control_mode != Global.ControlMode.SHIP:
		return

	_handle_input(delta)
	_apply_physics(delta)
	move_and_slide()



	# Exit ship

	if Global.control_mode == Global.ControlMode.SHIP:
		if Input.is_action_just_pressed("interact"):
			player.global_transform.origin = global_transform.origin + Vector3(0, 2, 0)
			Global.switch_to_player(player, self)

func _handle_input(delta):
	if Input.is_action_pressed("throttle_up"):
		current_throttle = clamp(current_throttle + delta, 0.0, 1.0)
	elif Input.is_action_pressed("throttle_down"):
		current_throttle = clamp(current_throttle - delta, 0.0, 1.0)

	var pitch := Input.get_action_strength("pitch_down") - Input.get_action_strength("pitch_up")
	var yaw := Input.get_action_strength("yaw_left") - Input.get_action_strength("yaw_right")
	var roll := Input.get_action_strength("roll_left") - Input.get_action_strength("roll_right")

	rotate_object_local(Vector3.RIGHT, pitch * rotation_speed * delta)
	rotate_object_local(Vector3.UP, yaw * rotation_speed * delta)
	rotate_object_local(Vector3.BACK, roll * rotation_speed * delta)

func _apply_physics(delta):
	var forward = -transform.basis.z
	var target_velocity = forward * thrust_force * current_throttle
	velocity = velocity.lerp(target_velocity, 0.1)

	velocity -= velocity * drag * delta

	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
