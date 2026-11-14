extends CharacterBody2D

@export var horizontal_speed := 250.0
@export var jump_velocity := -600.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity") 
var last_collided_with: Dictionary[Object, Object] = {}

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	apply_movement_inputs()
	var old_velocity: Vector2 = velocity
	move_and_slide()
	do_bounces(old_velocity)
	
	
func apply_movement_inputs():
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y += jump_velocity

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
		var firstTimeMultiplier = 1.0 if first_time else -1.0
		velocity = old_velocity.bounce(normal) + normal * Globals.BOUNCE_BONUS * firstTimeMultiplier
		move_and_slide()
	
		
		
