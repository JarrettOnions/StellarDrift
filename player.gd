extends CharacterBody3D

const SPEED = 5.0

@onready var ship = get_tree().get_root().get_node("World/Ship")
@onready var camera = get_tree().get_root().get_node("World/CameraRig/Camera3D")

func set_active(is_active: bool):
	set_physics_process(is_active)
	camera.current = is_active
	visible = is_active

func _physics_process(delta):
	if Global.control_mode != Global.ControlMode.PLAYER:
		return

	var dir = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		dir -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		dir += transform.basis.z
	if Input.is_action_pressed("move_left"):
		dir -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		dir += transform.basis.x

	if dir != Vector3.ZERO:
		dir = dir.normalized() * SPEED

	velocity.x = dir.x
	velocity.z = dir.z
	move_and_slide()

	# Re-enter the ship
	if Global.control_mode == Global.ControlMode.PLAYER:
		if Input.is_action_just_pressed("interact"):
			if global_transform.origin.distance_to(ship.global_transform.origin) < 10.0:
				Global.switch_to_ship(self, ship)
