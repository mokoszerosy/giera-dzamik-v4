extends Area2D

@export var collision: CollisionShape2D
@export var animation_sprite: AnimatedSprite2D
var player_nearby: bool = false
var disabled: bool = false

func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	player_nearby = true
	if disabled:
		return
	Sound.play_slime()
	if body.velocity.y > 0:
		body.last_floor_height = body.get_position().y
		body.velocity.y = 1.5 * body.jump_velocity
	else:
		body.velocity.y += -sqrt(Globals.TILE_SIZE * 2 * ProjectSettings.get_setting("physics/2d/default_gravity"))
	_disable_self()

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_nearby = false
		if disabled and animation_sprite.animation == "boom_loop":
			_enable_self()

func _disable_self():
	disabled = true
	animation_sprite.play("boom_in")

func _enable_self():
	if player_nearby:
		return
	disabled = false
	animation_sprite.play("boom_out")

func _on_sprite_2d_animation_finished() -> void:
	match animation_sprite.animation:
		"boom_in":
			animation_sprite.play("boom_loop")
		"boom_loop":
			if not player_nearby:
				_enable_self()
			else:
				animation_sprite.play("boom_loop")
		"boom_out":
			animation_sprite.play("idle")
	
