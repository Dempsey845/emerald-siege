extends GPUParticles3D

func _ready() -> void:
	emitting = true


func _on_finished() -> void:
	call_deferred("queue_free")
