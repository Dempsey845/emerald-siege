class_name EnemyCharacter extends Node3D

signal attack
signal hit_check

var move_blend := 0.0
var target_move_blend := 0.0
var blend_speed := 5.0

@export_category("Attack Animation")
@export var attack_animation_name: StringName = "Custom/"

@export_category("Hit Effect")
@export var meshes: Array[MeshInstance3D]
@export var hit_duration: float = 1.0
var hit_timer: float = 0.0

@onready var animation_tree: AnimationTree = %AnimationTree

func _ready() -> void:
	get_parent().damage_taken.connect(trigger_hit)
	animation_tree.tree_root.get_node("AttackAnimation").animation = attack_animation_name
	

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


func _blend_animations(delta: float):
	move_blend = lerp(move_blend, 0.0 if get_parent().velocity == Vector3.ZERO else 1.0, delta * blend_speed)
	animation_tree.set("parameters/IdleToRun/blend_amount", move_blend)

func play_attack():
	animation_tree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	attack.emit()

func emit_attack():
	attack.emit()

func emit_hit_check():
	hit_check.emit()
