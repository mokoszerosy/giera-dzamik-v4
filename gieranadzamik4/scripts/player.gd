extends CharacterBody2D

@export var horizontal_speed := 250.0
@export var jump_velocity := -400.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var last_collided_with: Dictionary[Object, Object] = {}
var last_floor_height: float = 0.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	apply_movement_inputs()
	var old_velocity: Vector2 = velocity
	move_and_slide()
	do_bounces(old_velocity)
	
	
func apply_movement_inputs():
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * horizontal_speed
	else:
		velocity.x = move_toward(velocity.x, 0, horizontal_speed)

func do_bounces(old_velocity: Vector2):
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
		var direction = old_velocity.normalized().bounce(normal)
		velocity = direction *  sqrt(bounce * 2 * gravity)
		move_and_slide()
	
		
		
