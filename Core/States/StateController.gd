extends Node

class_name StateController

var state_machine: StateMachine
var spawned_unit: SpawnedUnit

func _ready() -> void:
	assert(get_parent() is SpawnedUnit, "ERROR: This node should only be placed in a scene where the root node is a SpawnedUnit type")
	spawned_unit = get_parent()
	
	for node in get_parent().get_children():
		if node is StateMachine:
			state_machine  = node
	
	assert(state_machine != null, "ERROR: Could not find a State Machine")
	
func get_state():
	return state_machine.current_state
	
func is_state_active(state_name: String):
	if !state_machine.current_state:
		return false
		
	return state_machine.current_state.name.to_lower() == state_name.to_lower()
	
#Probably dont want to use this is most cases, but added the functionality just in case
func change_state(state_name: String, data: Array = []):
	state_machine.current_state.Transitioned.emit(state_machine.current_state, state_name)
	
	if (data.size() > 0):
		send_state_data(data)
	
func send_state_data(data: Array):
	data.push_front("StateData")
	state_machine.callv("emit_signal", data)
