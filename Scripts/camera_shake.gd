class_name CameraShake extends Node3D

@export var decay_rate: float = 3.0
@export var trauma_power: float = 2.0
@export var max_position_offset: Vector3 = Vector3(0.5, 0.5, 0.5)
@export var max_rotation_offset: Vector3 = Vector3(5, 5, 5)

@export var fade_distance: float = 50.0  # distance at which shake is halved

var shakes := []
var noise := FastNoiseLite.new()
var noise_counter: float = 0.0

func _ready():
	randomize()
	noise.seed = randi()
	noise.frequency = 8.0

func _process(delta: float) -> void:
	noise_counter += delta * 10

	var total_trauma: float = 0.0
	for i in range(shakes.size() - 1, -1, -1):
		var s = shakes[i]
		s.time -= delta
		if s.time <= 0:
			shakes.remove_at(i)
		else:
			var distance = global_position.distance_to(s.position)
			var distance_factor = clamp(1.0 - (distance / fade_distance), 0.0, 1.0)
			total_trauma += s.intensity * distance_factor

	if total_trauma > 0:
		_apply_shake(total_trauma)
	else:
		position = Vector3.ZERO
		rotation = Vector3.ZERO

# Add a shake impulse
# intensity: 0.0 to 1.0
# duration: seconds the shake lasts
# pos: Vector3 where the shake originates
# direction: Vector3 to bias shake
func add_shake(intensity: float, duration: float = 0.5, pos: Vector3 = Vector3.ZERO, direction: Vector3 = Vector3.ZERO) -> void:
	shakes.append({
		"intensity": clamp(intensity, 0.0, 1.0),
		"time": duration,
		"direction": direction,
		"position": pos
	})

func _apply_shake(total_intensity: float) -> void:
	var trauma = pow(clamp(total_intensity, 0.0, 1.0), trauma_power)

	# Positional shake
	var offset = Vector3(
		max_position_offset.x * trauma * noise.get_noise_2d(0, noise_counter),
		max_position_offset.y * trauma * noise.get_noise_2d(1, noise_counter),
		max_position_offset.z * trauma * noise.get_noise_2d(2, noise_counter)
	)

	# Rotational shake
	var rot_offset = Vector3(
		deg_to_rad(max_rotation_offset.x) * trauma * noise.get_noise_2d(3, noise_counter),
		deg_to_rad(max_rotation_offset.y) * trauma * noise.get_noise_2d(4, noise_counter),
		deg_to_rad(max_rotation_offset.z) * trauma * noise.get_noise_2d(5, noise_counter)
	)

	# Directional bias
	var dir_bias = Vector3.ZERO
	for s in shakes:
		var distance = global_position.distance_to(s.position)
		var distance_factor = clamp(1.0 - (distance / fade_distance), 0.0, 1.0)
		dir_bias += s.direction * s.intensity * 0.5 * distance_factor

	position = offset + dir_bias
	rotation = rot_offset
