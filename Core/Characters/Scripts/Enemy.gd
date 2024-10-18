extends SpawnedUnit

@onready var s_walk = $Sprites/S_Walk
@onready var s_hurt = $Sprites/S_Hurt
@onready var s_death: Sprite2D = $Sprites/S_Death
@onready var anim_player = $AnimationPlayer

@onready var state_controller: StateController = $"State Controller"

func _ready():
	play_anim(anim_player, s_walk, "walk")


func _physics_process(_delta: float) -> void:
	if(!state_controller.is_state_active("death")):
		move_and_slide()
		
		if (!state_controller.is_state_active("hurt")):
			if (velocity.x > 0.1):
				flip_sprites(false)
			elif (velocity.x < -0.1):
				flip_sprites(true)
	else:
		disable_collision()


func _on_hurtbox_hurt_triggered(damage, angle, knockback) -> void:
	if (!state_controller.is_state_active("death")):
		state_controller.change_state("hurt", [damage, angle, knockback])


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Death":
		state_controller.change_state("none")


func _on_state_machine_state_started(state_name: String) -> void:
	if (state_name == "enemychase"):
		play_anim(anim_player, s_walk, "walk")
		
	elif (state_name == "hurt"):
		play_anim(anim_player, s_hurt, "Hurt", true)
		
	elif (state_name == "death"):
		play_anim(anim_player, s_death, "Death", true)


func _on_state_machine_state_finished(state_name: String) -> void:
	if (state_name == "death"):
		#TODO: Spawn experience pickup
		queue_free()
	pass
	
