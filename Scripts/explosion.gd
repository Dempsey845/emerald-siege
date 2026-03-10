extends Node3D

@onready var effects := [%Sparks, %Flash]

func _ready() -> void:
	for effect in effects:
		effect.emitting = true
