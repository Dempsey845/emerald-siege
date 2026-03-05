extends MeshInstance3D

@export var hit_duration: float = 0.5
var hit_timer: float = 0.0

func _ready():
	# Connect damage signal
	get_parent().damage_taken.connect(trigger_hit)

func trigger_hit():
	print("Hit!")
	hit_timer = 0.0
	# Reset per-instance shader parameter
	set_instance_shader_parameter("time_passed", 0.0)

func _process(delta):
	if hit_timer < hit_duration:
		hit_timer += delta
		# Update shader for this instance only
		set_instance_shader_parameter("time_passed", hit_timer)
