class_name Projectile extends Area3D

const SPEED := 35.0

@export var projectile_hit_scene: Resource
const SAND_HIT = preload("res://Scenes/sand_hit.tscn")
const PROJECTILE_DECAL = preload("res://Scenes/projectile_decal.tscn")

var has_hit := false

enum SHOT_FROM
{
	Player,
	Enemy
}

@export var shot_from: SHOT_FROM

func _process(delta: float) -> void:
	if has_hit:
		return
		
	global_position += -basis.z * SPEED * delta
	
func _on_body_entered(body: Node3D) -> void:
	if has_hit:
		return
		
	has_hit = true
	
	if projectile_hit_scene:
		var projectile_hit = projectile_hit_scene.instantiate()
		get_parent().add_child(projectile_hit)
		projectile_hit.global_position = global_position
	
	if body.is_in_group("Terrain"):
		var sand_hit = SAND_HIT.instantiate()
		var projectile_decal = PROJECTILE_DECAL.instantiate()
		
		get_parent().add_child(sand_hit)
		get_parent().add_child(projectile_decal)
		
		sand_hit.global_position = global_position
		projectile_decal.global_position = global_position
	elif (body.is_in_group("Enemy") and shot_from == SHOT_FROM.Player) or (body.is_in_group("Player") and shot_from == SHOT_FROM.Enemy):
		body.take_damage(1)

	
	shrink_and_remove()

func shrink_and_remove():
	# Stop movement
	has_hit = true
	
	# Disable collisions immediately
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	
	# Create quick shrink tween
	var tween = create_tween()
	tween.tween_property(self, "scale", scale * 1.2, 0.05)
	tween.tween_property(self, "scale", Vector3.ONE * 0.001, 0.4)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_IN)
	tween.tween_callback(queue_free)
		
	tween.tween_callback(queue_free)


func _on_life_timer_timeout() -> void:
	shrink_and_remove()
	
