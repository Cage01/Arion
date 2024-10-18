extends State
class_name PlayerDefault

func enter():
	super()
	
func exit():
	super()
	
func update(_delta: float):
	super(_delta)

func physics_update(_delta: float):
	super(_delta)
	
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	
	spawned_unit.velocity = mov.normalized() * spawned_unit.movement_speed
	
	if (owning_state_machine.current_state == self):
		var light_attack = Input.get_action_strength("light_attack")
		if (light_attack > 0):
			#print("testing")
			Transitioned.emit(self, "playerattack")
