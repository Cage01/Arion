extends SpawnedUnit

@onready var light_attack_sprite = $Sprites/S_Attack01
@onready var walk_sprite = $Sprites/S_Walk
@onready var idle_sprite = $Sprites/S_Idle
@onready var hurt_sprite = $Sprites/S_Hurt

@onready var anim_player = $AnimationPlayer

var is_attacking = false
var is_taking_damage = false

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
			show_sprite(idle_sprite)
			anim_player.play("Idle")
			#show_sprite(anim_sprite)
			#anim_sprite.play("Idle")
		else:
			show_sprite(walk_sprite)
			anim_player.play("Walk")
		
	if (mov.x < 0):
		flip_sprites(true)
	elif (mov.x > 0):
		flip_sprites(false)
		
	velocity = mov.normalized() * movement_speed
	move_and_slide()
	
func handle_input():
	var light_attack = Input.get_action_strength("light_attack");
	
	if not is_taking_damage:
		if not anim_player.is_playing() && is_attacking:
			#show_sprite(anim_sprite)
			is_attacking = false
		
		if (light_attack > 0):
			show_sprite(light_attack_sprite)
			anim_player.play("Attack01")
			is_attacking = true
		

func show_sprite(sprite):
	for i in $".".get_children():
		for j in i.get_children():
			if j is Sprite2D or j is AnimatedSprite2D:
				j.visible = false
	
	sprite.visible = true
	
func flip_sprites(is_flipped: bool):
	for i in $".".get_children():
		if i.name == "Hitbox":
			if is_flipped:
				i.scale.x = -1
			else:
				i.scale.x = 1
		else:
			for j in i.get_children():
				if j is Sprite2D or j is AnimatedSprite2D:
					j.flip_h = is_flipped


func _on_hurtbox_hurt(damage: Variant) -> void:
	super(damage)
	print(health)
	is_taking_damage = true
	show_sprite(hurt_sprite)
	anim_player.play("Hurt")
	frame_freeze(0.1)
	


func _on_hitbox_hit() -> void:
	#print("HIT")
	#frame_freeze(0.1)
	
	#if is_attacking && anim_attacks.is_playing() && not is_in_hitstun:
		#anim_attacks.pause()
	pass

func frame_freeze(duration):
	Engine.time_scale = 0
	await(get_tree().create_timer(duration, true, false, true).timeout)
	Engine.time_scale = 1.0
	



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Hurt" && is_taking_damage:
		is_taking_damage = false
