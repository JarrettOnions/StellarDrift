extends Node

enum ControlMode {
	SHIP,
	PLAYER
}

var control_mode = ControlMode.SHIP
var camera_rig: Node3D


func switch_to_player(player, ship):
	player.set_physics_process(true)
	player.visible = true

	ship.set_physics_process(false)
	#ship.visible = false  # optional, if you want to hide the ship when on foot

	control_mode = ControlMode.PLAYER

	camera_rig.target = player
	camera_rig.global_transform.origin = player.global_transform.origin


func switch_to_ship(player, ship):
	player.set_physics_process(false)
	player.visible = false

	ship.set_physics_process(true)
	ship.visible = true

	control_mode = ControlMode.SHIP

	camera_rig.target = ship
	camera_rig.global_transform.origin = ship.global_transform.origin
