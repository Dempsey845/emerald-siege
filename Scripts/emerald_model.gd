extends Node3D

@export var emerald_repository: EmeraldRepository

@onready var shader_material: ShaderMaterial = %Crystal.material_override

var initial_rim_color: Color
var darkened_rim_color := Color.BLACK

var initial_albedo: Color
var darkened_albedo := Color(0.0, 0.843, 0.478)

var min_specular = 0.05
var max_specular = 1.0

@onready var lights = [{"light_node": %Light, "initial_energy": 1.0}, {"light_node": %Light2, "initial_energy": 1.0}]

var max_energy: float

@onready var sparks_large_vol: GPUParticles3D = %SparksLargeVol
@onready var sparks_mid_vol: GPUParticles3D = %SparksMidVol
@onready var sparks_small_vol: GPUParticles3D = %SparksSmallVol
@onready var sparks_very_small_vol: GPUParticles3D = %SparksVerySmallVol

func _ready() -> void:
	initial_rim_color = shader_material.get_shader_parameter("rim_color")
	initial_albedo = shader_material.get_shader_parameter("albedo")
		
	max_energy = emerald_repository.max_energy
	emerald_repository.energy_changed.connect(_on_energy_changed)
	
func _on_energy_changed(energy_value: float) -> void:
	energy_value = clamp(energy_value, 0.0, max_energy)
	
	var fraction: float = energy_value / max_energy
	
	var new_rim: Color = darkened_rim_color.lerp(initial_rim_color, fraction)
	shader_material.set_shader_parameter("rim_color", new_rim)
	
	var new_albedo: Color = darkened_albedo.lerp(initial_albedo, fraction)
	shader_material.set_shader_parameter("albedo", new_albedo)

	var new_specular = lerp(min_specular, max_specular, fraction)
	shader_material.set_shader_parameter("specular_strength", new_specular)
	
	for light_dict in lights:
		var light_node: Light3D = light_dict["light_node"]
		var initial_energy: float = light_dict["initial_energy"]
		light_node.light_energy = initial_energy * fraction
	
	sparks_large_vol.emitting = fraction > 0.75
	sparks_mid_vol.emitting = fraction > 0.5 and fraction <= 0.75
	sparks_small_vol.emitting = fraction > 0.25 and fraction <= 0.5
	sparks_very_small_vol.emitting = fraction > 0.15 and fraction <= 0.25
