extends SpawnedUnit


@onready var player = get_tree().get_first_node_in_group("player")
@onready var s_walk = $Sprites/S_Walk
@onready var s_hurt = $Sprites/S_Hurt
@onready var s_death: Sprite2D = $Sprites/S_Death
@onready var collision: CollisionShape2D = $Collision
@onready var hitbox_collision: CollisionShape2D = $Hitbox/CollisionShape2D

@onready var anim_player = $AnimationPlayer


@onready var hurtbox_collision: CollisionShape2D = $Hurtbox/CollisionShape2D



func _ready():
	play_anim(anim_player, s_walk, "walk")

func _physics_process(_delta: float) -> void:
	super(_delta)

	if not is_dying:
		var direction = global_position.direction_to(player.global_position)
		velocity += direction * movement_speed
		
		move_and_slide()
			
		if (direction.x > 0.1):
			flip_sprites(false)
			#_utils.update_anim(run_sprite, run_timer)
		elif (direction.x < -0.1):
			flip_sprites(true)
			#_utils.update_anim(run_sprite, run_timer)
		


func _on_hurtbox_hurt(_damage, _angle, _knockback) -> void:
	super(_damage, _angle, _knockback)
	
	is_taking_damage = true
	
	if (health <= 0):
		is_dying = true
		play_anim(anim_player, s_death, "Death")
		hurtbox_collision.call_deferred("set","disabled",true)
		hitbox_collision.call_deferred("set", "disabled", true)
		collision.call_deferred("set", "disabled", true)
	else:
		play_anim(anim_player, s_hurt, "Hurt", true)
	
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Hurt" and is_taking_damage:
		play_anim(anim_player, s_walk, "walk")
		is_taking_damage = false
	elif anim_name == "Death":
		queue_free()
