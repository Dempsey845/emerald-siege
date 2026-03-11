extends Control

@export var emerald_energy: EmeraldEnergy

@onready var energy_progress_bar: ProgressBar = %EnergyProgressBar

func _ready() -> void:
	emerald_energy.energy_changed.connect(_on_energy_changed)
	
	energy_progress_bar.min_value = emerald_energy.min_energy
	energy_progress_bar.max_value = emerald_energy.max_energy
	energy_progress_bar.value = emerald_energy.energy
	
func _on_energy_changed(energy_value: float):
	energy_progress_bar.value = energy_value
