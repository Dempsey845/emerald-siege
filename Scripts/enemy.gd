extends CharacterBody3D

const MOVE_SPEED := 5.0

@export var target_node: Node3D

@onready var navigation_agent: NavigationAgent3D = %NavigationAgent3D


func _physics_process(_delta: float) -> void:
	if not navigation_agent.is_target_reachable():
		return

	var next_pos = navigation_agent.get_next_path_position()
	var direction = global_position.direction_to(next_pos)

	var desired_velocity = direction * MOVE_SPEED

	navigation_agent.set_velocity(desired_velocity)


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	move_and_slide()


func _on_update_nav_timer_timeout() -> void:
	if not target_node:
		return

	navigation_agent.target_position = target_node.global_position
