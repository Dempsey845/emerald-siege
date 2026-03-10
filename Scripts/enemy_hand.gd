extends BoneAttachment3D

@export var current_melee_weapon: MeleeWeapon
@export var enemy_character: EnemyCharacter

var enemy_parent: Enemy

func _ready() -> void:
	enemy_parent = enemy_character.enemy_parent
	enemy_parent.death.connect(on_death)

func on_death():
	current_melee_weapon.dissolve()
