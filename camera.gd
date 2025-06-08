extends Node3D

@export var follow_speed := 3.0
@export var rotation_speed := 3.0

var target: Node3D

func _process(delta):
	if target:
		# Smooth position
		global_transform.origin = global_transform.origin.lerp(
			target.global_transform.origin, follow_speed * delta)

		# Smooth rotation
		var current_rotation = global_transform.basis.get_rotation_quaternion()
		var target_rotation = target.global_transform.basis.get_rotation_quaternion()
		var new_rotation = current_rotation.slerp(target_rotation, rotation_speed * delta)

		global_transform.basis = Basis(new_rotation)
