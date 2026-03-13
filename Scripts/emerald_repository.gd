class_name EmeraldRepository extends StaticBody3D

signal energy_changed(energy_value: float)

const EXPLOSION = preload("res://Scenes/explosion.tscn")

@onready var absorb_cooldown_timer: Timer = %AbsorbCooldownTimer

var energy := 0.0
var max_energy := 100.0
var overload_energy := 200.0

var regen_speed := 2.0
var regen_delay := 1.0
var regen_delay_timer := 0.0

var absorb_amount := 0.0
var min_absorb_amount := 8.0
var max_absorb_amount := 20.0

func _ready() -> void:
	set_energy(randi_range(0, 100))

func _process(delta: float) -> void:
	if regen_delay_timer == 0.0 and energy < max_energy:
		add_energy(delta * regen_speed)

	_handle_regen_delay(delta)

func add_energy(amount: float):
	var new_energy = energy + amount
	
	if energy > overload_energy:
		explode()
		new_energy = 0.0
	elif energy > max_energy:
		absorb_cooldown_timer.stop()
		
	set_energy(new_energy)
		
	energy_changed.emit(energy)
	
func take_energy(amount: float):
	var new_energy = energy - amount
	
	# Restarting the delay
	regen_delay_timer = 0.01
	
	if new_energy < 0.0:
		new_energy = 0.0
		
	set_energy(new_energy)
	
	energy_changed.emit(energy)

func set_energy(value: float):
	energy = value
	absorb_amount = min(max(value, min_absorb_amount), max_absorb_amount) if value > 0.5 else 0.0
	if energy < min_absorb_amount and absorb_cooldown_timer.is_stopped():
		absorb_cooldown_timer.start()
	energy_changed.emit(value)

func explode():
	var explosion = EXPLOSION.instantiate()
	add_child(explosion)
	explosion.global_position = global_position
	
func _handle_regen_delay(delta: float):
	if regen_delay_timer == 0.0:
		return
	
	regen_delay_timer += delta
	
	if regen_delay_timer > regen_delay:
		regen_delay_timer = 0.0


func can_absorb():
	return energy > min_absorb_amount and absorb_cooldown_timer.is_stopped() 
