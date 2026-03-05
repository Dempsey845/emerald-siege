class_name AttackAgent extends Node3D

signal melee_attack
signal ranged_attack

enum ATTACK_TYPE
{
	Melee,
	Ranged,
	MeleeAndRanged
}

@export var attack_type: ATTACK_TYPE
@onready var enemy: Enemy = get_parent()

@export_category("Ranged")
@export var ranged_attack_distance: float = 15.0
@onready var ranged_attack_distance_sq := ranged_attack_distance * ranged_attack_distance
@onready var ranged_cooldown_timer: Timer = %RangedCooldownTimer

@export_category("RangedAndMelee")
@export var min_time_between_attack_types: float = 1.0 # The minimum amount of delay between a ranged and melee attack

var time_since_last_melee_attack := 0.0
var time_since_last_ranged_attack := 0.0

@export_category("Melee")
@onready var melee_cooldown_timer: Timer = %MeleeCooldownTimer

func _process(delta: float) -> void:
	time_since_last_melee_attack += delta
	time_since_last_ranged_attack += delta

func attack_melee():
	if attack_type != ATTACK_TYPE.Melee and attack_type != ATTACK_TYPE.MeleeAndRanged or not melee_cooldown_timer.is_stopped():
		return
	
	if attack_type == ATTACK_TYPE.MeleeAndRanged and time_since_last_ranged_attack < min_time_between_attack_types:
		return

	melee_attack.emit()
	time_since_last_melee_attack = 0.0
	melee_cooldown_timer.start()
	
func attack_ranged():
	if attack_type != ATTACK_TYPE.Ranged and attack_type != ATTACK_TYPE.MeleeAndRanged:
		return
		
	if not ranged_cooldown_timer.is_stopped() or enemy.get_distance_to_target_node_sq() > ranged_attack_distance_sq:
		return
		
	if attack_type == ATTACK_TYPE.MeleeAndRanged and time_since_last_melee_attack < min_time_between_attack_types:
		return
	
	ranged_attack.emit()
	time_since_last_ranged_attack = 0.0
	ranged_cooldown_timer.start()
