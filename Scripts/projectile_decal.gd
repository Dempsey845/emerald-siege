extends Decal

func _process(delta: float) -> void:
	albedo_mix -= 0.1 * delta
	if albedo_mix <= 0:
		call_deferred("queue_free")
		
