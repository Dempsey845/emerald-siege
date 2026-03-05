class_name Arms extends Node3D

@onready var animation_player: AnimationPlayer = %AnimationPlayer

const FIRE = "Pistol_Fire_Big_Recoil"
const IDLE = "Pistol_Idle"

func fire():
	animation_player.play(FIRE)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == FIRE:
		animation_player.play(IDLE)
