class_name EnemyCharacter extends Node3D

# Animation blending
var attack_blend := 0.0
var target_attack_blend := 0.0
var move_blend := 0.0
var target_move_blend := 0.0
var blend_speed := 5.0

# Animation states
var is_attacking := false
var attack_while_idle := false
var attack_while_moving := false

# Weapon
var current_weapon := "Gun"

@export_category("Hit Effect")
@export var meshes: Array[MeshInstance3D]
@export var hit_duration: float = 1.0
var hit_timer: float = 0.0

@onready var animation_tree: AnimationTree = %AnimationTree

func _ready() -> void:
	get_parent().damage_taken.connect(trigger_hit)
	
	switch_weapon(current_weapon)
	
func switch_weapon(weapon: String):
	current_weapon = weapon
	
	match current_weapon:
		"Gun":
			attack_while_idle = false
			attack_while_moving = true
		"Axe":
			attack_while_idle = true
			attack_while_moving = true

func _process(delta: float) -> void:
	# Update hit shader effect
	if hit_timer < hit_duration:
		hit_timer += delta
		for mesh in meshes:
			mesh.set_instance_shader_parameter("time_passed", hit_timer)
	
	_blend_animations(delta)

func trigger_hit():
	hit_timer = 0.0
	for mesh in meshes:
		mesh.set_instance_shader_parameter("time_passed", 0.0)

func run_to_attack():
	if is_attacking:
		return

	is_attacking = true
	target_attack_blend = 1.0 

func attack_to_run():
	is_attacking = false
	target_attack_blend = 0.0 

func _blend_animations(delta: float):
	attack_blend = lerp(attack_blend, target_attack_blend, delta * blend_speed)
	
	if attack_while_idle:
		_set_idle_attack_blend(attack_blend)
	else:
		_set_idle_attack_blend(0.0)
		
	if attack_while_moving:
		_set_move_attack_blend(attack_blend)
	else:
		_set_move_attack_blend(0.0)
	
	move_blend = lerp(move_blend, 0.0 if get_parent().velocity == Vector3.ZERO else 1.0, delta * blend_speed)
	animation_tree.set("parameters/IdleRun"+current_weapon+"AttackBlend/blend_amount", move_blend)

func _set_idle_attack_blend(blend: float):
	animation_tree.set("parameters/Idle"+current_weapon+"AttackBlendTree/Blend/blend_amount", blend)
	
func _set_move_attack_blend(blend: float):
	animation_tree.set("parameters/Run"+current_weapon+"AttackBlendTree/Blend/blend_amount", blend)
