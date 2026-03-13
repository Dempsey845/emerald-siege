extends Area3D

var emerald_repository: EmeraldRepository

func _ready() -> void:
	emerald_repository = get_parent()

func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("Enemy"):
		return
	
	var grab_attention = randi_range(0, 2) == 0
	
	if grab_attention:
		var enemy_target_agent: EnemyTargetAgent = body.get_node("EnemyTargetAgent")
		enemy_target_agent.change_target(EnemyTargetAgent.TargetType.EmeraldRepository, emerald_repository)
