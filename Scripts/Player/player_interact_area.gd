class_name PlayerInteractArea extends Area3D

@export var emerald_energy: EmeraldEnergy

var areas: Array[Area3D]

var current_emerald_repo_area: Area3D
var current_emerald_repo: EmeraldRepository

var energy_consumption_per_bullet := 2.0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and areas.size() > 0:
		for area in areas:
			area.interact()
	
	if Input.is_action_pressed("charge") and current_emerald_repo_area:
		if current_emerald_repo.can_absorb and current_emerald_repo.energy > energy_consumption_per_bullet:
			emerald_energy.add_energy(delta * current_emerald_repo.absorb_amount)
			current_emerald_repo.take_energy(delta * 25.0)
 
func _on_timer_timeout() -> void:
	areas = get_overlapping_areas()


func _on_area_entered(area: Area3D) -> void:
	current_emerald_repo_area = area
	current_emerald_repo = current_emerald_repo_area.get_parent()
	
func _on_area_exited(area: Area3D) -> void:
	if area == current_emerald_repo_area:
		current_emerald_repo_area = null
		current_emerald_repo = null
