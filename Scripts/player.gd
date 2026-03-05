extends CharacterBody3D

var move_speed := 8.0
var mouse_sensitivity := 0.1
var gravity := -9.8
var jump_speed := 5.0

var rotation_x = 0

# Movement sway
var sway_amount := 0.05
var sway_speed := 6.0

# Mouse sway
var mouse_sway_amount := 0.0008
var mouse_delta := Vector2.ZERO

# Idle breathing
var idle_breath_amount := 0.015
var idle_breath_speed := 1.5
var idle_time := 0.0

# Bobbing
var bob_time := 0.0

# Jump / landing
var jump_offset := 0.0
var landing_force := 0.15
var was_on_floor := true

var arms_default_position := Vector3.ZERO

# Health
var health = 3

@onready var camera: Camera3D = %Camera3D
@onready var arms: Node3D = %Arms


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	arms_default_position = arms.position


func _unhandled_input(event):
	handle_mouse_look(event)


func _physics_process(delta):
	var direction = get_movement_input()

	apply_gravity_and_jump(delta)
	apply_movement(direction)

	move_and_slide()

	handle_landing()
	update_arm_sway(delta)


func handle_mouse_look(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
		
		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, -90, 90)
		
		camera.rotation_degrees.x = rotation_x
		rotation_degrees.y -= event.relative.x * mouse_sensitivity


func get_movement_input() -> Vector3:
	var direction = Vector3()

	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_back"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x

	return direction.normalized()

func apply_gravity_and_jump(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if not was_on_floor:
			jump_offset = -landing_force
		
		velocity.y = 0
		
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_speed
			jump_offset = 0.08


func apply_movement(direction: Vector3):
	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed


func handle_landing():
	was_on_floor = is_on_floor()


func update_arm_sway(delta):

	var horizontal_speed = Vector2(velocity.x, velocity.z).length()

	var bob_offset = get_movement_bob(delta, horizontal_speed)
	var idle_offset = get_idle_breath(delta, horizontal_speed)
	var mouse_sway = get_mouse_sway()

	jump_offset = lerp(jump_offset, 0.0, delta * 6.0)
	var jump_vector = Vector3(0, jump_offset, 0)

	var target_position = arms_default_position + bob_offset + idle_offset + mouse_sway + jump_vector

	arms.position = arms.position.lerp(target_position, delta * 8.0)

	apply_rotation_sway(delta)

	mouse_delta = mouse_delta.lerp(Vector2.ZERO, delta * 10.0)


func get_movement_bob(delta, speed) -> Vector3:

	if speed > 0.1 and is_on_floor():
		bob_time += delta * sway_speed
	else:
		bob_time = 0

	return Vector3(
		cos(bob_time) * sway_amount,
		abs(sin(bob_time * 2.0)) * sway_amount,
		0
	)


func get_idle_breath(delta, speed) -> Vector3:

	if speed < 0.1 and is_on_floor():
		idle_time += delta * idle_breath_speed
	else:
		idle_time = 0

	return Vector3(
		0,
		sin(idle_time) * idle_breath_amount,
		0
	)


func get_mouse_sway() -> Vector3:
	return Vector3(
		-mouse_delta.x * mouse_sway_amount,
		mouse_delta.y * mouse_sway_amount,
		0
	)


func apply_rotation_sway(delta):

	var target_rotation = Vector3(
		mouse_delta.y * 0.002,
		-mouse_delta.x * 0.002,
		-mouse_delta.x * 0.001
	)

	arms.rotation = arms.rotation.lerp(target_rotation, delta * 8.0)

func take_damage(damage: int = 1):
	health -= damage
	%HitVignette.show_hit(1)
