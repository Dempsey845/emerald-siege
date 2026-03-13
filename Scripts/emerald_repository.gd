class_name EmeraldRepository extends StaticBody3D

signal energy_changed(energy_value: float)

@onready var regen_delay_timer: Timer = %RegenDelayTimer

var energy := 0.0
var max_energy := 100.0

var can_regen := true

var regen_speed := 10.0

var can_absorb := false
var absorb_amount := 35.0

func _ready() -> void:
	set_energy(randi_range(0, 100))

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

func set_energy(value: float):
	energy = value
	energy_changed.emit(value)

func _on_regen_delay_timer_timeout() -> void:
	can_regen = true


func _on_discover_area_body_entered(body: Node3D) -> void:
	if not body.is_in_group("Enemy"):
		return
	
	var grab_attention = randi_range(0, 2) == 0
	
	if grab_attention:
		var enemy_target_agent: EnemyTargetAgent = body.get_node("EnemyTargetAgent")
		enemy_target_agent.change_target(EnemyTargetAgent.TargetType.EmeraldRepository, self)
