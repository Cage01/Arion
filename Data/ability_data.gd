extends Resource

class_name AbilityData

@export var name: String
@export var scene: Resource
@export var level: int = 1
@export var damage: float = 5
@export var attack_speed: float = 1
@export var attack_size: float = 1.0
@export var knockback_amount: int = 100
@export var cooldown: float = 0.5 # in seconds

var target = Vector2.ZERO
var angle = Vector2.ZERO
