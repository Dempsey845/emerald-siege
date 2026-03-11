class_name EmeraldEnergy extends Node3D

signal energy_changed(energy_value: float)

@export var max_energy: float = 100.0
@export var min_energy: float = 0.0

var energy := 50.0

func add_energy(amount: float):
	energy += amount
	
	if energy > max_energy:
		energy = max_energy
	
	energy_changed.emit(energy)
	
func take_energy(amount: float):
	energy -= amount
	
	if energy < min_energy:
		energy = min_energy
	
	energy_changed.emit(energy)
	
func set_energy(value: float):
	energy = value
	
	if energy < min_energy:
		energy = min_energy
	elif energy > max_energy:
		energy = max_energy
	
	energy_changed.emit(energy)
