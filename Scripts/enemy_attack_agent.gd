class_name AttackAgent extends Node3D

signal melee_attack
signal ranged_attack

enum AttackType {
	MELEE,
	RANGED
}

@export var attack_type: AttackType
@onready var enemy: Enemy = get_parent()

@export_category("Ranged")
@export var ranged_attack_distance: float = 15.0
@onready var ranged_attack_distance_sq := ranged_attack_distance * ranged_attack_distance
@onready var ranged_cooldown_timer: Timer = %RangedCooldownTimer

@export_category("Melee")
@export var melee_distance: float = 5.0
@onready var melee_distance_sq := melee_distance * melee_distance
@onready var melee_cooldown_timer: Timer = %MeleeCooldownTimer

func attack_melee() -> void:
	if attack_type != AttackType.MELEE:
		return

	if enemy.get_distance_to_target_node_sq() > melee_distance_sq:
		return

	if not melee_cooldown_timer.is_stopped():
		return

	melee_attack.emit()
	
	melee_cooldown_timer.start()


func attack_ranged() -> void:
	if attack_type != AttackType.RANGED or not ranged_cooldown_timer.is_stopped() or enemy.get_distance_to_target_node_sq() > ranged_attack_distance_sq:
		return

	ranged_attack.emit()

	ranged_cooldown_timer.start()
