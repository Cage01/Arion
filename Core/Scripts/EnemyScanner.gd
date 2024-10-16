extends Area2D

var enemies = [Node2D]
	

func get_random_target():
	if enemies != null && enemies.size() > 0:
		return enemies.pick_random().global_position
	
	return Vector2.RIGHT

func get_nearest_target():
	var closest = null
	if enemies != null && enemies.size() > 0:
		for i: Node2D in enemies:
			if closest == null:
				closest = i.global_position
			elif abs(global_position - i.global_position) < abs(global_position - closest):
				closest = i.global_position
	
	if closest == null:
		closest = Vector2.RIGHT
		
	return closest

func _on_body_entered(body: Node2D) -> void:
	if not enemies.has(body):
		enemies.append(body)
	
	
func _on_body_exited(body: Node2D) -> void:
	enemies.erase(body)
