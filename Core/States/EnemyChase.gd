extends State
class_name EnemyChase

var player: SpawnedUnit

func enter():
	super()
	
	player = get_tree().get_first_node_in_group("player")

func physics_update(delta: float):
	super(delta)
	
	if spawned_unit:
		var direction = spawned_unit.global_position.direction_to(player.global_position)
		spawned_unit.velocity = direction * spawned_unit.movement_speed
