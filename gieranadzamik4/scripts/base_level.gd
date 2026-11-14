extends Node

const PLAYER = preload("uid://s31bky5a7fdn")

@export var spawn_point: Marker2D

func _ready() -> void:
	var player: CharacterBody2D = PLAYER.instantiate()
	player.global_position = spawn_point.global_position
	add_child(player)
	
