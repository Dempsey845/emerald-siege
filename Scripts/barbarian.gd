class_name EnemyCharacter
extends Node3D

@onready var meshses = [
	%Barbarian_Body, %Barbarian_Head, %Barbarian_BearHat,
	%Barbarian_LegLeft, %Barbarian_LegRight,
	%Barbarian_ArmRight, %Barbarian_ArmLeft
]

@export var hit_duration: float = 1.0
var hit_timer: float = 0.0

var run_attack_blend := 0.0
var target_blend := 0.0
var blend_speed := 5.0

var is_attacking := false

@onready var enemy_attack_agent: AttackAgent = %EnemyAttackAgent


func _ready():
	get_parent().damage_taken.connect(trigger_hit)
	enemy_attack_agent.melee_attack.connect(run_to_attack)
	enemy_attack_agent.melee_ended.connect(attack_to_run)


func _process(delta):
	# Update hit shader effect
	if hit_timer < hit_duration:
		hit_timer += delta
		for mesh in meshses:
			mesh.set_instance_shader_parameter("time_passed", hit_timer)

	# Smoothly blend run and attack
	run_attack_blend = lerp(run_attack_blend, target_blend, delta * blend_speed)
	%AnimationTree.set("parameters/RunAttackBlendTree/RunAttackBlend/blend_amount", run_attack_blend)


func run_to_attack():
	if is_attacking:
		return

	is_attacking = true
	target_blend = 1.0 


func attack_to_run():
	is_attacking = false
	target_blend = 0.0 


func trigger_hit():
	hit_timer = 0.0
	for mesh in meshses:
		mesh.set_instance_shader_parameter("time_passed", 0.0)
