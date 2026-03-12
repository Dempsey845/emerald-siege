extends Node3D

const BARBARIAN_ENEMY = preload("res://Scenes/Enemy/Characters/barbarian_enemy.tscn")

@export var enemy_container: Node3D
@onready var path_progress: PathFollow3D = %PathProgress

func get_random_spawn_position():
	path_progress.progress_ratio = randf()
	return path_progress.global_position


func _on_spawn_timer_timeout() -> void:
	var enemy = BARBARIAN_ENEMY.instantiate()
	enemy_container.add_child(enemy)
	enemy.global_position = get_random_spawn_position()
