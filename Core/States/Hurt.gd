extends State

class_name Hurt

var player: SpawnedUnit
var knockback
var timeout_counter = 0
var hurt_triggered = false

@export_enum("Enemy", "Player") var owner_type: String

func enter():
	super()
	
	if (owner_type == "Enemy"):
		player = get_tree().get_first_node_in_group("player")
	
	if (!owning_state_machine.StateData.is_connected(on_hurt)):
		owning_state_machine.StateData.connect(on_hurt)

	
func exit():
	timeout_counter = 0
	hurt_triggered = false
	pass
	
func update(_delta: float):
	pass

func physics_update(_delta: float):
	super(_delta)
	if (hurt_triggered == true && (knockback == Vector2.ZERO || timeout_counter >= 100)):
		if(owner_type == "Enemy"):
			Transitioned.emit(self, "enemychase")
		return
		
	var direction = Vector2.ZERO
	if (owner_type == "Enemy"):
		direction = spawned_unit.global_position.direction_to(player.global_position)
	
	knockback = knockback.move_toward(Vector2.ZERO, spawned_unit.knockback_recovery)
	spawned_unit.velocity = knockback
	spawned_unit.velocity += direction * spawned_unit.movement_speed
	
	timeout_counter += 1
	
func on_hurt(damage, angle, knockback_amount):	
	knockback = angle * knockback_amount
	spawned_unit.health -= damage

	hurt_triggered = true
	
	if (spawned_unit.health <= 0):
		Transitioned.emit(self, "death")
