extends CharacterBody2D


class_name SpawnedUnit

@export var movement_speed = 40.0
@export var health = 20
@export var knockback_recovery = 3.5

var is_attacking = false
var is_taking_damage = false
var is_dying = false

var knockback = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	velocity = knockback

func _on_hurtbox_hurt(damage, angle, knockback_amount) -> void:
	knockback = angle * knockback_amount
	health -= damage
	
func play_anim(player: AnimationPlayer, sprite: Sprite2D, anim_name: String, stop_prev: bool = false):
	show_sprite(sprite)
	#Will call the reset frames of the anim
	if stop_prev:
		player.stop(true)
		player.play(&"RESET")
		player.call_deferred("advance", 0)
	#Play desired animation
	player.play(anim_name)	
	
#Will hide all sprites except the desired one
func show_sprite(sprite):
	for i in $".".get_children():
		for j in i.get_children():
			if j is Sprite2D or j is AnimatedSprite2D:
				j.visible = false
	
	sprite.visible = true
	
#Will flip all sprites in a node tree
func flip_sprites(is_flipped: bool):
	for i in $".".get_children():
		if i is Sprite2D or i is AnimatedSprite2D:
			i.flip_h = is_flipped
		
		if i.name == "Hitbox":
			if is_flipped:
				i.scale.x = -1
			else:
				i.scale.x = 1
		else:
			for j in i.get_children():
				if j is Sprite2D or j is AnimatedSprite2D:
					j.flip_h = is_flipped

func frame_freeze(duration: float, time_scale: float = 0):
	Engine.time_scale = time_scale
	await(get_tree().create_timer(duration, true, false, true).timeout)
	Engine.time_scale = 1.0	
