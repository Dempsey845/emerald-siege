extends Node3D

func _ready() -> void:
	%GPUParticles3D.emitting = true

func _on_gpu_particles_3d_finished() -> void:
	call_deferred("queue_free")
