extends Node
class_name State

signal Transitioned

var owning_state_machine: StateMachine
var spawned_unit: SpawnedUnit

func enter():
	pass
	
func exit():
	pass
	
func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass
