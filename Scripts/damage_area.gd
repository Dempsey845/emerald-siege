class_name DamageArea extends Area3D

@export var damage: int = 1

func check_hit():
	var bodies = get_overlapping_bodies()
	if bodies.size() > 0:
		for body in bodies:
			if body.has_method("take_damage"):
				body.take_damage(damage)
