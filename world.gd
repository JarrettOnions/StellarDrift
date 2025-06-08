extends Node3D

func _ready():
	# Assign CameraRig to Global
	Global.camera_rig = $CameraRig

	# Start in ship mode
	Global.switch_to_ship($Player, $Ship)
