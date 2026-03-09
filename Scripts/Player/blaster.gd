class_name Blaster extends Node3D

enum RecoilMagnitude
{
	Small,
	Big
}

@export var bullets_per_second: float = 2.0
@export var recoil_magnitude: RecoilMagnitude
@onready var fire_point: Marker3D = $FirePoint
