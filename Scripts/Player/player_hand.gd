class_name PlayerHand extends BoneAttachment3D

const PROJECTILE = preload("res://Scenes/Player/player_projectile.tscn")
const BLASTER_PISTOL = preload("res://Scenes/Player/Blasters/blaster_pistol.tscn")
const BLASTER_SMG = preload("res://Scenes/Player/Blasters/blaster_smg.tscn")

@onready var current_blaster: Blaster = $BlasterPistol

@onready var emerald_energy: EmeraldEnergy = get_tree().current_scene.get_node("%EmeraldEnergy")

@export var arms: Arms

var can_shoot = true

var energy_consumption_per_bullet := 2.0

enum BlasterType
{
	Pistol,
	SMG
}

func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	change_blaster(BlasterType.SMG)

func change_blaster(type: BlasterType):
	var blaster_scene: Resource
	
	match type:
		BlasterType.Pistol:
			blaster_scene = BLASTER_PISTOL
		BlasterType.SMG:
			blaster_scene = BLASTER_SMG
			
	current_blaster.queue_free()
	current_blaster = blaster_scene.instantiate()
	add_child(current_blaster)

func _process(_delta: float) -> void:
	if can_shoot and Input.is_action_pressed("shoot") and emerald_energy.energy > energy_consumption_per_bullet:
		shoot_projectile()
		emerald_energy.take_energy(energy_consumption_per_bullet)
		arms.fire(current_blaster.recoil_magnitude, current_blaster.bullets_per_second)
		can_shoot = false
		await arms.animation_player.animation_finished
		can_shoot = true

func shoot_projectile():
	var projectile = PROJECTILE.instantiate()
	add_child(projectile)
	
	projectile.global_position = current_blaster.fire_point.global_position
	projectile.global_basis = current_blaster.fire_point.global_basis
