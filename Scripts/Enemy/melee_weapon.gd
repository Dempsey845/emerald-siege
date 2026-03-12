class_name MeleeWeapon extends Node3D

@export var damage: int = 1
@export var energy_damage: float = 15.0
@export var enemy_character: EnemyCharacter
@export var weapon_mesh: MeshInstance3D

@export_range(0.0, 5.0, 0.05) var hit_check_start_time := 0.20 # A delay from the start of the attack animation
@export_range(0.0, 5.0, 0.05) var hit_check_end_time := 0.30 

@onready var hit_area: Area3D = %HitArea

var checking_for_hit := false
var hit_check_timer := 0.0
var has_hit_this_check := false

var dissolving := false
var dissolve_amount := 0.0
var dissolve_speed := 0.5

func _ready() -> void:
	if not enemy_character:
		push_error("Melee Weapon requires an EnemyCharacter!")
		
	enemy_character.attack.connect(_start_hit_check)
	
func _process(delta: float) -> void:
	if checking_for_hit:
		hit_check_timer += delta
		
		if hit_check_timer > hit_check_start_time:
			_check_hit()
		
		if hit_check_timer > hit_check_end_time:
			_end_hit_check()
			
	if dissolving:
		dissolve_amount += delta * dissolve_speed
		weapon_mesh.set_instance_shader_parameter("dissolve_amount", dissolve_amount)
		weapon_mesh.transparency = dissolve_amount
			
func _start_hit_check():
	hit_check_timer = 0.0
	checking_for_hit = true
	
func _end_hit_check():
	hit_check_timer = 0.0
	checking_for_hit = false
	has_hit_this_check = false
	
func _check_hit():
	if has_hit_this_check:
		return

	has_hit_this_check = check_hit()

func check_hit() -> bool:
	var overlapping_bodies = hit_area.get_overlapping_bodies()
	
	if overlapping_bodies.size() > 0:
		print("Overlapping " + overlapping_bodies[0].name)
		if overlapping_bodies[0].is_in_group("Player"):
			var player: Player = overlapping_bodies[0]
			player.take_damage(damage)
			return true
		elif overlapping_bodies[0].is_in_group("EmeraldRepository"):
			var repo: EmeraldRepository = overlapping_bodies[0]
			repo.take_energy(energy_damage)
			return true
		
	return false

func dissolve():
	dissolving = true
	weapon_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
