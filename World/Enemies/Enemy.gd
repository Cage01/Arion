extends SpawnedUnit


@onready var player = get_tree().get_first_node_in_group("player")
@onready var walk_sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer

func _ready():
	anim_player.play("walk")

func _physics_process(_delta: float) -> void:
	super(_delta)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * movement_speed
	
	move_and_slide()
	
	if (direction.x > 0.1):
		walk_sprite.flip_h = false
		#_utils.update_anim(run_sprite, run_timer)
	elif (direction.x < -0.1):
		walk_sprite.flip_h = true;
		#_utils.update_anim(run_sprite, run_timer)


func _on_hurtbox_hurt(damage: Variant) -> void:
	super(damage)
	
	if (health <= 0):
		queue_free()
	#print(health)
