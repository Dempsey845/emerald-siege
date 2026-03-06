class_name MageCharacter extends EnemyCharacter

@onready var enemy_attack_agent: AttackAgent = %EnemyAttackAgent


func _ready():
	super._ready()
	enemy_attack_agent.ranged_attack.connect(play_attack)
	
	
