extends Node3D

const PROJECTILE = preload("res://Scenes/projectile.tscn")

@onready var fire_point: Marker3D = $FirePoint

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot_projectile()

func shoot_projectile():
	var projectile = PROJECTILE.instantiate()
	add_child(projectile)
	
	projectile.global_position = fire_point.global_position
	projectile.global_basis = fire_point.global_basis
	
	
