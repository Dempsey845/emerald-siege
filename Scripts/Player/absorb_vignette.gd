extends ColorRect

@export var fade_speed := 3.0
var current_intensity := 0.0

var show_vignette := false

func _process(delta):
	if current_intensity > 0:
		if not show_vignette:
			current_intensity = max(current_intensity - fade_speed * delta, 0)
		material.set_shader_parameter("intensity", current_intensity)

func start_asorb(intensity := 0.7):
	if show_vignette:
		return
	
	current_intensity = intensity
	show_vignette = true

func stop_absorb():
	show_vignette = false
