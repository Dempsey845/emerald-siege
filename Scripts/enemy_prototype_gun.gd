extends Node3D

@export var enemy_attack_agent: AttackAgent

@onready var fire_point: Marker3D = %FirePoint

const PROJETILE = preload("res://Scenes/enemy_projectile.tscn")

func _ready() -> void:
	enemy_attack_agent.ranged_attack.connect(shoot)

func shoot():
	var projectile = PROJETILE.instantiate()
	add_child(projectile)
	projectile.global_position = fire_point.global_position
	projectile.global_basis = fire_point.global_basis
