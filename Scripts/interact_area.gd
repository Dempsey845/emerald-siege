class_name InteractArea extends Area3D

signal interacted

func interact():
	interacted.emit()


func _on_hit_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("PlayerProjectile"):
		get_parent().add_energy(get_parent().absorb_amount)
	elif area.is_in_group("EnemyProjectile"):
		get_parent().take_energy(get_parent().absorb_amount)
