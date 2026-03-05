extends Node3D

const PROJECTILE = preload("res://Scenes/player_projectile.tscn")

@onready var fire_point: Marker3D = $FirePoint

@onready var arms: Arms = $"../../../.."

var can_shoot = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot_projectile()
		arms.fire()
		can_shoot = false
		await arms.animation_player.animation_finished
		can_shoot = true

func shoot_projectile():
	var projectile = PROJECTILE.instantiate()
	add_child(projectile)
	
	projectile.global_position = fire_point.global_position
	projectile.global_basis = fire_point.global_basis
	
	
