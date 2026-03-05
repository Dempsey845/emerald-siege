extends Area3D

const SPEED := 25.0

func _process(delta: float) -> void:
	global_position += -basis.z * SPEED * delta
