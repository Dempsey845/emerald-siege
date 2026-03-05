class_name Enemy extends CharacterBody3D

const MOVE_SPEED := 5.0
const ROTATION_SPEED := 6.0

@export var target_node: Node3D
@export var attack_agent: AttackAgent
@onready var navigation_agent: NavigationAgent3D = %NavigationAgent3D

func _physics_process(delta: float) -> void:
	if not target_node:
		return

	if navigation_agent.is_navigation_finished():
		navigation_agent.set_velocity(Vector3.ZERO)
		velocity = Vector3.ZERO

		_look_at_target_node(delta)
		
		if attack_agent:
			attack_agent.attack_melee()
		
		return

	var next_pos = navigation_agent.get_next_path_position()
	var direction = global_position.direction_to(next_pos)

	_look_at_move_direction(direction, delta)

	var desired_velocity = direction * MOVE_SPEED
	navigation_agent.set_velocity(desired_velocity)
	
	if attack_agent:
		attack_agent.attack_ranged()

func get_distance_to_target_node_sq() -> float:
	if not target_node:
		push_warning("Attempting to get distance to null target node.")
		return INF
	
	return global_position.distance_squared_to(target_node.global_position)


func _look_at_target_node(delta: float):
	var look_dir = global_position.direction_to(target_node.global_position)
	if look_dir.length() > 0.01:
		var target_angle = atan2(look_dir.x, look_dir.z)
		rotation.y = lerp_angle(rotation.y, target_angle, delta * ROTATION_SPEED)

func _look_at_move_direction(direction: Vector3, delta: float):
	if direction.length() > 0.01:
		var target_angle = atan2(direction.x, direction.z)
		rotation.y = lerp_angle(rotation.y, target_angle, delta * ROTATION_SPEED)

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	move_and_slide()

func _on_update_nav_timer_timeout() -> void:
	if not target_node:
		return

	navigation_agent.target_position = target_node.global_position
