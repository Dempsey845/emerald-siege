class_name BarbarianCharacter extends EnemyCharacter

@onready var enemy_attack_agent: AttackAgent = %EnemyAttackAgent

func _ready():
	super._ready()
	enemy_attack_agent.melee_attack.connect(play_attack)
