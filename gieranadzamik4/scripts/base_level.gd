extends Node

const PLAYER = preload("uid://s31bky5a7fdn")

@onready var finish_group: Node2D = $FinishGroup
@onready var finish_door_left: FinishDoor = $FinishGroup/FinishDoorLeft
@onready var finish_door_right: FinishDoor = $FinishGroup/FinishDoorRight

@export var spawn_point: Marker2D

func _ready() -> void:
	var player: CharacterBody2D = PLAYER.instantiate()
	player.global_position = spawn_point.global_position
	add_child(player)
	# Hide ready group
	finish_group.modulate = Color(1, 1, 1, 0)
	


func _on_finish_activation_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	var tween = create_tween()
	var tween_duration = 3.5
	tween.tween_property(finish_group, "modulate", Color.WHITE, tween_duration) \
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(_tween_callback).set_delay(tween_duration / 4.0)

func _tween_callback():
	finish_door_left.enabled = true
	finish_door_right.enabled = true
	
