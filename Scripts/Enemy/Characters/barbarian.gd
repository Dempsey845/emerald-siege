class_name BarbarianCharacter extends EnemyCharacter

@onready var enemy_attack_agent: AttackAgent = %EnemyAttackAgent
@export var enemy_parent: Enemy

func _ready():
	super._ready()
	enemy_attack_agent.melee_attack.connect(play_attack)
	enemy_parent.damage_taken.connect(play_hit)
