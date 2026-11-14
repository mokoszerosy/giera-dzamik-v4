extends Node

const PLAYER = preload("uid://s31bky5a7fdn")

@onready var finish_group: Control = $FinishGroup

@export var spawn_point: Marker2D

func _ready() -> void:
	var player: CharacterBody2D = PLAYER.instantiate()
	player.global_position = spawn_point.global_position
	add_child(player)
	


func _on_finish_activation_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	create_tween().tween_property(finish_group, "modulate", Color.WHITE, 5.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
