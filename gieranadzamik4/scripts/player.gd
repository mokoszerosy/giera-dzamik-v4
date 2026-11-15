class_name Player
extends CharacterBody2D

@onready var anim_sprite: AnimatedSprite2D = $AnimSprite
@export var horizontal_speed := 350.0
@export var grounded_horizontal_speed := 500.0
@export var deceleration_speed := 75
@export var jump_velocity := -400.0
@export var movement_ease_in_speed: float = 0.8
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var last_collided_with: Dictionary[Object, Object] = {}
var last_floor_height: float = 0.0
var is_airborne: bool = false

var movement_ease_in: float = 0.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		is_airborne = true
		velocity.y += gravity * delta

	apply_movement_inputs()
	move_and_slide()
	do_bounces()
	
	
func apply_movement_inputs():
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		Sound.play_jump()
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		movement_ease_in = move_toward(movement_ease_in, 1.0, movement_ease_in_speed)
		if is_on_floor():
			velocity.x = direction * Tween.interpolate_value(
			0, grounded_horizontal_speed,
			movement_ease_in, 1.0,
		 	Tween.TRANS_QUINT,
			Tween.EASE_IN
			)
		else:
			velocity.x = direction * Tween.interpolate_value(
			0, horizontal_speed,
			movement_ease_in, 1.0,
		 	Tween.TRANS_QUINT,
			Tween.EASE_IN
			)
			
		if direction > 0:
			if is_airborne:
				if velocity.y > 0:
					anim_sprite.play("fall_right")
				else:
					anim_sprite.play("fly_right")
			else:
				anim_sprite.play("run_right")
			anim_sprite.flip_h = true
			
		else:
			if is_airborne:
				if velocity.y > 0:
					anim_sprite.play("fall_left")
				else:
					anim_sprite.play("fly_left")
			else:
				anim_sprite.play("run_left")
			anim_sprite.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration_speed)
		if not is_airborne:
			anim_sprite.play("idle")

func do_bounces():
	var normal = Vector2()
	
	var collisions: Array[Object] = []
	
	var first_time: bool = false
	
	for i in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		var collider = collision.get_collider()
		if not collider.is_in_group("bouncers"):
			if is_on_floor():
				last_collided_with.clear()
				last_floor_height = collision.get_position().y
				if is_airborne:
					Sound.play_land()
					is_airborne = false
			continue
		first_time = first_time or not collider in last_collided_with
		last_collided_with[collider] = null
		collisions.append(collision)
		
	
	for collision in collisions:
		if (normal.is_zero_approx()):
			normal = collision.get_normal()
		else:
			normal = ((normal + collision.get_normal()) / 2.0).normalized()
			

	if (!normal.is_zero_approx()):
		var bounce_distance: float = abs(last_floor_height - global_position.y)
		var bounce: float = bounce_distance + Globals.TILE_SIZE + Globals.LEVEL_STEP * int(first_time)
		velocity = normal *  sqrt(bounce * 2 * gravity)
		Sound.play_bounce(max(bounce_distance/500, 0.5))
		move_and_slide()
	
		
		
