extends Area3D

var projectile_energy := 15.0

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("PlayerProjectile"):
		print("Hit")
		get_parent().add_energy(projectile_energy)
	elif area.is_in_group("EnemyProjectile"):
		get_parent().take_energy(projectile_energy)
