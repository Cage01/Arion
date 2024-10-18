extends SpawnedUnit

#Sprites
@onready var light_attack_sprite = $Sprites/S_Attack01
@onready var walk_sprite = $Sprites/S_Walk
@onready var idle_sprite = $Sprites/S_Idle
@onready var hurt_sprite = $Sprites/S_Hurt

#Collision
@onready var hitbox_collision: CollisionShape2D = $Hitbox/CollisionShape2D

# Stream players
@onready var anim_player = $AnimationPlayer
@onready var audio_hit_enemy = $Audio_Hit_Enemy

# State Machine
@onready var state_controller: StateController = $StateController


var abilities = [AbilityData]

func _physics_process(_delta: float) -> void:
	super(_delta)
	
	if (!state_controller.is_state_active("hurt")):
		if (velocity.x > 0.1):
			flip_sprites(false)
		elif (velocity.x < -0.1):
			flip_sprites(true)
		
	if (state_controller.is_state_active("playerdefault")):
		if (abs(velocity) > Vector2.ZERO):
			play_anim(anim_player, walk_sprite, "Walk")
		else:
			play_anim(anim_player, idle_sprite, "Idle")

	move_and_slide()


func _on_hurtbox_hurt_triggered(damage, angle, knockback) -> void:
	
	if (!state_controller.is_state_active("death")):
		state_controller.change_state("hurt", [damage, angle, knockback])


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Hurt":
		state_controller.change_state("playerdefault")
		
	# Attack animation is finished
	if anim_name.contains("Attack"):
		state_controller.change_state("playerdefault")

func _on_hitbox_hit() -> void:
	frame_freeze(0.1, 0.4)
	audio_hit_enemy.play()
	


func _on_state_machine_state_started(state_name: String) -> void:
	if (state_name == "playerattack"):
		play_anim(anim_player, light_attack_sprite, "Attack01")
	
	if (state_name == "hurt"):
		play_anim(anim_player, hurt_sprite, "Hurt", true)
		frame_freeze(0.1, 0.1)
		hitbox_collision.set_deferred("disabled", true)
	


func _on_state_machine_state_finished(state_name: String) -> void:
	pass # Replace with function body.
