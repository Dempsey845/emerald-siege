extends Area3D

const SPEED := 50.0

const SPARK_HIT = preload("res://Scenes/spark_hit.tscn")

func _process(delta: float) -> void:
	global_position += -basis.z * SPEED * delta
	
	get_tree().create_timer(2.0).timeout.connect(func(): call_deferred("queue_free"))

func _on_body_entered(_body: Node3D) -> void:
	var hit = SPARK_HIT.instantiate()
	get_parent().add_child(hit)
	hit.global_position = global_position
	call_deferred("queue_free")
