class_name EnemyCharacter extends Node3D

signal attack
signal hit_check

var move_blend := 0.0
var target_move_blend := 0.0
var blend_speed := 5.0

var dissolving := false
var dissolve_amount := 0.0
var dissolve_speed := 0.5

@export_category("Attack Animation")
@export var attack_animation_name: StringName = "Custom/"

@export_category("Hit Effect")
@export var meshes: Array[MeshInstance3D]
@export var hit_duration: float = 1.0
var hit_timer: float = 0.0

@onready var animation_tree: AnimationTree = %AnimationTree

const ENEMY_DISSOLVE = preload("res://Shaders/enemy_dissolve.tres")

func _ready() -> void:
	get_parent().damage_taken.connect(trigger_hit)
	animation_tree.tree_root.get_node("AttackAnimation").animation = attack_animation_name
	animation_tree.set("parameters/SpawnOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func _process(delta: float) -> void:
	# Update hit shader effect
	if hit_timer < hit_duration:
		hit_timer += delta
		for mesh in meshes:
			mesh.set_instance_shader_parameter("time_passed", hit_timer)
	
	if dissolving and dissolve_amount < 1.0:
		dissolve_amount += delta * dissolve_speed
		for mesh in meshes:
			mesh.set_instance_shader_parameter("dissolve_amount", dissolve_amount)
			mesh.transparency = dissolve_amount
			
	if animation_tree:
		_blend_animations(delta)

func trigger_hit():
	hit_timer = 0.0
	for mesh in meshes:
		mesh.set_instance_shader_parameter("time_passed", 0.0)

func start_dissolve():
	for mesh in meshes:
		mesh.material_overlay = ENEMY_DISSOLVE
		mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	dissolving = true

func _blend_animations(delta: float):
	move_blend = lerp(move_blend, 0.0 if get_parent().velocity == Vector3.ZERO else 1.0, delta * blend_speed)
	animation_tree.set("parameters/IdleToRun/blend_amount", move_blend)

func play_attack():
	animation_tree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	attack.emit()
	
func play_hit():
	animation_tree.set("parameters/HitOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func play_death():
	animation_tree.set("parameters/DeathOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	await animation_tree.animation_finished
	animation_tree.set("parameters/DeathPoseBlend/blend_amount", 1.0)
	start_dissolve()

func emit_attack():
	attack.emit()

func emit_hit_check():
	hit_check.emit()
