class_name RadialAgent extends Node3D

enum AI_Radial_State
{
	FindingPoint,
	GoingToPoint,
	Attacking,
}

@export_category("Radial") 
@export var attack_agent: AttackAgent
@export var max_distance_from_target: float = 20.0
@export var attack_distance_from_target: float = 10.0
@onready var max_distance_from_target_sq := max_distance_from_target * max_distance_from_target

var radial_state := AI_Radial_State.FindingPoint
var radial_point := Vector3.ZERO
var min_attack_time := 2.0 # Minimum amount of time an enemy has to attack for at a radial point before moving on
var attack_time = 0.0
var map_ready := false

var distance_from_target_sq: float = INF
var target_node: Node3D

@onready var navigation_agent: NavigationAgent3D = %NavigationAgent3D

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	map_ready = true

func is_nav_ready():
	var map = get_world_3d().navigation_map
	return NavigationServer3D.map_get_iteration_id(map) > 0

func get_random_point_near_target(radius: float) -> Vector3:
	if not target_node or not is_nav_ready():
		return Vector3.ZERO
		
	# Random direction
	var dir = Vector3(
		randf_range(-1.0, 1.0),
		0,
		randf_range(-1.0, 1.0)
	).normalized()

	# Random distance within radius
	var distance = randf_range(0.0, radius)

	var random_point = target_node.global_position + dir * distance

	# Snap to nearest navigation mesh point
	return NavigationServer3D.map_get_closest_point(
		navigation_agent.get_navigation_map(),
		random_point
	)

func process_radial(delta: float):
	if not map_ready or not target_node:
		return
	
	match radial_state:
		AI_Radial_State.FindingPoint:
			_find_point()
		AI_Radial_State.GoingToPoint:
			_go_to_point()
		AI_Radial_State.Attacking:
			_attack(delta)

func _find_point():
	if distance_from_target_sq < attack_distance_from_target:
		radial_point = global_position
	else:
		radial_point = get_random_point_near_target(attack_distance_from_target)
		
	print(radial_point)
	navigation_agent.target_position = radial_point
	radial_state = AI_Radial_State.GoingToPoint
	
func _go_to_point():
	if navigation_agent.is_navigation_finished():
				radial_state = AI_Radial_State.Attacking
				navigation_agent.target_position = global_position

func _attack(delta: float):
	attack_time += delta
	if attack_time > min_attack_time:
		if distance_from_target_sq > max_distance_from_target_sq:
			radial_state = AI_Radial_State.FindingPoint
			attack_time = 0.0
			return
			
	if attack_agent:
		get_parent().velocity = Vector3.ZERO
		get_parent().look_at_direction(global_position.direction_to(target_node.global_position), delta)
		attack_agent.attack_ranged()
