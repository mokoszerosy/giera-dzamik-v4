extends Area2D

@export var collision: CollisionShape2D
@export var animation_sprite: AnimatedSprite2D
var player_nearby: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_nearby = true
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

func _disable_self():
	animation_sprite.play("bubbleboom")

func _enable_self():
	if player_nearby:
		return
	visible = true
	collision.set_deferred("disabled", false)
	animation_sprite.play("idle")

func _on_sprite_2d_animation_finished() -> void:
	collision.set_deferred("disabled", true)
	while player_nearby:
		pass
	_enable_self()
