extends ColorRect

@export var fade_speed := 3.0
var current_intensity := 0.0

func _process(delta):
	if current_intensity > 0:
		current_intensity = max(current_intensity - fade_speed * delta, 0)
		material.set_shader_parameter("intensity", current_intensity)

func show_hit(intensity := 0.7):
	current_intensity = intensity
