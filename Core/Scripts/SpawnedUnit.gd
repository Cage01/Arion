extends CharacterBody2D


class_name SpawnedUnit

@export var movement_speed = 40.0
@export var health = 20

func _physics_process(_delta: float) -> void:
	pass

func _on_hurtbox_hurt(damage: Variant) -> void:
	health -= damage
	
