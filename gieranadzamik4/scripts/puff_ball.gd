extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Sound.play_slime()
		if body.velocity.y > 0:
			body.last_floor_height = body.get_position().y
			body.velocity.y = 1.5 * body.jump_velocity
		else:
			body.velocity.y += -sqrt(Globals.TILE_SIZE * 2 * ProjectSettings.get_setting("physics/2d/default_gravity"))
