extends SpawnedUnit

@onready var light_attack_sprite = $Sprites/S_Attack01
@onready var walk_sprite = $Sprites/S_Walk
@onready var idle_sprite = $Sprites/S_Idle
@onready var hurt_sprite = $Sprites/S_Hurt

@onready var anim_player = $AnimationPlayer
@onready var audio_hit_enemy = $Audio_Hit_Enemy
@onready var hitbox_collision: CollisionShape2D = $Hitbox/CollisionShape2D


var abilities = [AbilityData]

func _physics_process(_delta: float) -> void:
	super(_delta)
	movement()
	handle_input()


func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	
	if not is_attacking and not is_taking_damage:
		#Vector2.ZERO checks for if there is any movement
		if (mov == Vector2.ZERO):
			play_anim(anim_player, idle_sprite, "Idle")
		else:
			play_anim(anim_player, walk_sprite, "Walk")
		
	if (mov.x < 0):
		flip_sprites(true)
	elif (mov.x > 0):
		flip_sprites(false)
		
	velocity = mov.normalized() * movement_speed
	move_and_slide()
	
func handle_input():
	var light_attack = Input.get_action_strength("light_attack");
	
	if not is_taking_damage:
		if not anim_player.get_current_animation().to_lower().contains("attack") or not anim_player.is_playing():
			is_attacking = false
			
		if (light_attack > 0):
			play_anim(anim_player, light_attack_sprite, "Attack01")
			is_attacking = true


func _on_hurtbox_hurt(_damage, _angle, _knockback) -> void:
	super(_damage, _angle, _knockback)
	#Ensure the hitbox gets fully disabled
	hitbox_collision.set_deferred("disabled", true)
	
	if not is_taking_damage:
		frame_freeze(0.1, 0.1)
		
	is_taking_damage = true
	play_anim(anim_player, hurt_sprite, "Hurt", true)
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Hurt" && is_taking_damage:
		is_taking_damage = false

func _on_hitbox_hit() -> void:
	frame_freeze(0.1, 0.4)
	audio_hit_enemy.play()
