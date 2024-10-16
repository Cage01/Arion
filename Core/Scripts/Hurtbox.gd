extends Area2D

@export_enum("Cooldown", "HitOnce", "DisableHitbox") var HurtBoxType = 0

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

signal hurt(damage, angle, knockback)


func _on_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("attack"):
		if not area.get("damage") == null:
			match HurtBoxType:
				0: #Cooldown
					collision.call_deferred("set","disabled",true)
					disableTimer.start()
				1: #Hit Once
					pass
				2: #DisableHitbox
					if area.has_method("tempdisable"):
						area.tempdisable()
			var damage = area.damage
			var angle = Vector2.ZERO
			var knockback = 1
			if not area.get("angle") == null:
				angle = area.angle 
			else:
				angle = area.global_position.direction_to(global_position)
			
			if not area.get("knockback_amount") == null:
				knockback = area.knockback_amount
			
			hurt.emit(damage, angle, knockback)

func _on_disable_timer_timeout() -> void:
	collision.call_deferred("set","disabled",false)
