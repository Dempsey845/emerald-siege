class_name PlayerInteractArea extends Area3D

signal absorb_started
signal absorb_ended

@export var player_energy: EmeraldEnergy

var areas: Array[Area3D]

var current_emerald_area: Area3D
var current_emerald_repo: EmeraldRepository

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and areas.size() > 0:
		for area in areas:
			area.interact()
	
	if Input.is_action_pressed("charge") and current_emerald_area:
		_handle_charge(delta)
	elif Input.is_action_just_released("charge") and current_emerald_repo:
		absorb_ended.emit()
 
func _handle_charge(delta: float):
	if current_emerald_repo.can_absorb and player_energy.energy < player_energy.max_energy:
		player_energy.add_energy(delta * current_emerald_repo.absorb_amount)
		current_emerald_repo.take_energy(delta * current_emerald_repo.absorb_amount)
		absorb_started.emit()
	else:
		absorb_ended.emit()

func _on_timer_timeout() -> void:
	areas = get_overlapping_areas()

func _on_area_entered(area: Area3D) -> void:
	current_emerald_area = area
	current_emerald_repo = current_emerald_area.get_parent()
	
func _on_area_exited(area: Area3D) -> void:
	if area == current_emerald_area:
		current_emerald_area = null
		current_emerald_repo = null
		absorb_ended.emit()
