class_name MageCharacter extends EnemyCharacter

@onready var enemy_attack_agent: AttackAgent = %EnemyAttackAgent
@export var enemy_parent: Enemy

func _ready():
	super._ready()
	enemy_attack_agent.ranged_attack.connect(play_attack)
	enemy_parent.damage_taken.connect(play_hit)
	enemy_parent.death.connect(play_death)
