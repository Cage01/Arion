extends State
class_name Death

func enter():
	super()
	
	if spawned_unit.is_in_group("player"):
		print("do something?")

	
func exit():
	super()

	
func physics_update(delta: float):
	super(delta)
