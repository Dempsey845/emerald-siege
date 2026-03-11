class_name DamageArea extends Area3D

@export var damage: int = 1
@export var emerald_energy: float = 0.0

func check_hit():
	var bodies = get_overlapping_bodies()
	if bodies.size() > 0:
		for body in bodies:
			if body.has_method("take_damage"):
				body.take_damage(damage)
			if emerald_energy > 0.0 and body.has_method("add_energy"):
				body.add_energy(emerald_energy)
