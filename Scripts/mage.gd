class_name MageCharacter extends EnemyCharacter

@onready var enemy_attack_agent: AttackAgent = %EnemyAttackAgent

func _ready():
	super._ready()
	enemy_attack_agent.melee_attack.connect(run_to_attack)
	enemy_attack_agent.melee_ended.connect(attack_to_run)
	enemy_attack_agent.ranged_attack.connect(run_to_attack)
	enemy_attack_agent.ranged_ended.connect(attack_to_run)
