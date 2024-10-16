extends Area2D

@export var damage = 1
@export var knockback_amount = 0

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableHitboxTimer

signal hit()

func tempdisable():
	collision.call_deferred("set", "disabled", true)
	disableTimer.start()


func _on_disable_hitbox_timer_timeout() -> void:
	collision.call_deferred("set", "disabled", false)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurt"):
		hit.emit()
