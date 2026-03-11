class_name PlayerInteractArea extends Area3D

@export var emerald_energy: EmeraldEnergy

var areas: Array[Area3D]

var current_emerald_repo_area: Area3D
var current_emerald_repo: EmeraldRepository

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and areas.size() > 0:
		for area in areas:
			area.interact()
	
	if Input.is_action_pressed("charge") and current_emerald_repo_area:
		emerald_energy.add_energy(delta * 5.0)
 
func _on_timer_timeout() -> void:
	areas = get_overlapping_areas()


func _on_area_entered(area: Area3D) -> void:
	current_emerald_repo_area = area
	
func _on_area_exited(area: Area3D) -> void:
	if area == current_emerald_repo_area:
		current_emerald_repo_area = null
