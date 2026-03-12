class_name GameManager extends Node3D

@export var camera_shake: CameraShake
@export var player: Player

func add_camera_shake(intensity: float, duration: float = 0.5, direction: Vector3 = Vector3.ZERO):
	camera_shake.add_shake(intensity, duration, direction)
