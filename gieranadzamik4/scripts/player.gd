extends CharacterBody2D

@export var horizontal_speed := 500.0
@export var jump_velocity := -600.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity") 

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	
	if Input.is_action_pressed("jump") and is_on_floor():
		print(delta)
		velocity.y += jump_velocity

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * horizontal_speed
	else:
		velocity.x = move_toward(velocity.x, 0, horizontal_speed)

	move_and_slide()
