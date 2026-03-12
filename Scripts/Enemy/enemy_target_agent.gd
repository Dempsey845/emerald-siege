class_name EnemyTargetAgent extends Node3D

enum TargetType
{
	None,
	Player,
	EmeraldRepository,
}

@export var enemy_parent: Enemy
@export var current_target_type: TargetType

var current_emerald_repo: EmeraldRepository

var none_time := 0.0
var target_time := 0.0

func _process(delta: float) -> void:
	if current_target_type == TargetType.None:
		none_time += delta
		target_time = 0.0
		return
	
	target_time += delta

func change_target(new_target_type: TargetType, emerald_repo: EmeraldRepository = null):
	target_time = 0.0
	none_time = 0.0
	
	match new_target_type:
		TargetType.Player:
			var player = _get_player_node()
			enemy_parent.target_node = player
			current_target_type = TargetType.Player if player else TargetType.None 
		TargetType.EmeraldRepository:
			enemy_parent.target_node = emerald_repo
			current_target_type = TargetType.EmeraldRepository if emerald_repo else TargetType.None 
			current_emerald_repo = emerald_repo
			
			
func _get_player_node() -> Player:
	return get_tree().current_scene.player


func _on_update_timer_timeout() -> void:
	match current_target_type:
		TargetType.None:
			if none_time > 3.0:
				change_target(TargetType.Player)
		TargetType.EmeraldRepository:
			if current_emerald_repo.energy == 0.0:
				change_target(TargetType.Player)
