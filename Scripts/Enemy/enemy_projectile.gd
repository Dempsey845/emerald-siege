extends Area3D

const SPEED := 25.0

func _process(delta: float) -> void:
	global_position += -basis.z * SPEED * delta


func _on_life_timer_timeout() -> void:
	call_deferred("queue_free")


func _on_body_entered(body: Node3D) -> void:
	call_deferred("queue_free")
