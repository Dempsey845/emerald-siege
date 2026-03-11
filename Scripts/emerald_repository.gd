class_name EmeraldRepository extends StaticBody3D

signal energy_changed(energy_value: float)

@onready var regen_delay_timer: Timer = %RegenDelayTimer

var energy := 50.0
var max_energy := 100.0

var can_regen := true

var regen_speed := 15.0

var can_absorb := true
var absorb_amount := 35.0

func _on_interact_area_interacted() -> void:
	print("Interacting with repo!")

func _process(delta: float) -> void:
	if not can_regen:
		return
	
	add_energy(delta * regen_speed)

func add_energy(amount: float):
	energy += amount
	
	if energy > max_energy:
		energy = max_energy
		can_absorb = true
		
	energy_changed.emit(energy)
	
func take_energy(amount: float):
	can_regen = false
	
	energy -= amount
	
	if energy < 5.0:
		energy = 0.0
		
		if regen_delay_timer.is_stopped():
			regen_delay_timer.start()
			can_absorb = false
		
	energy_changed.emit(energy)


func _on_regen_delay_timer_timeout() -> void:
	can_regen = true
