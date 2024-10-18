extends Node
class_name StateMachine

@export var initial_state: State
@export var state_controller: StateController

var current_state: State
var states: Dictionary = {}

signal StateStarted(state_name: String)
signal StateFinished(state_name: String)
signal StateData

func _ready():
	#Adding an empty state
	states["none"] = State.new()
	
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			if state_controller.spawned_unit:
				child.spawned_unit = state_controller.spawned_unit
				child.owning_state_machine = self
				
			#Sets up signal for each state to this function
			child.Transitioned.connect(on_child_transition) 

	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func _physics_process(delta: float) -> void:
		if current_state:
			current_state.physics_update(delta)


#This function will be called when the signal is emitted
func on_child_transition(old_state, new_state_name):
	#print("entering " + new_state_name)
	if old_state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state.exit()
		StateFinished.emit(current_state.name.to_lower())
		
	
	new_state.enter()
	StateStarted.emit(new_state.name.to_lower())
	
	current_state = new_state
