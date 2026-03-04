extends CharacterBody3D


var speed := 8.0
var mouse_sensitivity := 0.1
var gravity := -9.8
var jump_speed := 5.0

@export var camera: Camera3D
var rotation_x = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, -90, 90)
		camera.rotation_degrees.x = rotation_x
		rotation_degrees.y -= event.relative.x * mouse_sensitivity

func _physics_process(delta):
	var direction = Vector3()
	
	# WASD movement
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_back"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	direction = direction.normalized()
	
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_speed

	# Movement
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	move_and_slide()
