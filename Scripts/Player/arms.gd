class_name Arms extends Node3D

@export var camera_shake: CameraShake
@onready var animation_player: AnimationPlayer = %AnimationPlayer

const FIRE = "Pistol_Fire_Big_Recoil"
const SMALL_FIRE = "Pistol_Fire_small_recoil"
const IDLE = "Pistol_Idle"

const BIG_RECOIL_ANIM_LENGTH := 0.45
const SMALL_RECOIL_ANIM_LENGTH := 0.45

func fire(magnitude: Blaster.RecoilMagnitude, bullets_per_second: float = 2.0):
	if magnitude == Blaster.RecoilMagnitude.Small:
		var animation_speed = SMALL_RECOIL_ANIM_LENGTH/(1/bullets_per_second)
		animation_player.play(SMALL_FIRE, 0.0, animation_speed)
		camera_shake.add_shake(0.15, 0.15)
	else:
		var animation_speed = BIG_RECOIL_ANIM_LENGTH/(1/bullets_per_second)
		animation_player.play(FIRE, 0.0, animation_speed)
		camera_shake.add_shake(0.25, 0.2)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == FIRE:
		animation_player.play(IDLE)
