extends RigidBody3D

const EXPLOSION = preload("res://Scenes/explosion.tscn")

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	var explosion = EXPLOSION.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	call_deferred("queue_free")
