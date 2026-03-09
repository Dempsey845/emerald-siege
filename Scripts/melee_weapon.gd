class_name MeleeWeapon extends Node3D

@export var damage: int = 1
@export var enemy_character: EnemyCharacter

@export_range(0.0, 5.0, 0.05) var hit_check_start_time := 0.20 # A delay from the start of the attack animation
@export_range(0.0, 5.0, 0.05) var hit_check_end_time := 0.30 

@onready var hit_area: Area3D = %HitArea

var checking_for_hit := false
var hit_check_timer := 0.0
var has_hit_this_check := false

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
	
	if overlapping_bodies.size() > 0 and overlapping_bodies[0].is_in_group("Player"):
		var player: Player = overlapping_bodies[0]
		player.take_damage(damage)
		return true
		
	return false
