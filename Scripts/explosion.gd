extends Node3D

@onready var effects := [%Sparks, %Flash]
@onready var damage_area: DamageArea = %DamageArea

@onready var check_hit_delay_timer: Timer = %CheckHitDelayTimer

func _ready() -> void:
	for effect in effects:
		effect.emitting = true
		
	var game_manager: GameManager = get_tree().current_scene
	game_manager.add_camera_shake(0.5, 1.0)
	
func _on_check_hit_delay_timer_timeout() -> void:
	damage_area.check_hit()
