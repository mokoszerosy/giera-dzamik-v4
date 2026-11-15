@tool
class_name FinishDoor
extends Node2D

@export var transfer: PackedScene
@export var label_text: String = "":
	set(value):
		label_text = value
		_set_text()
@export var enabled: bool = false:
	set(value):
		enabled = value
		if has_player:
			_run_action()

@onready var label: Label = $Label

var has_player: bool = false

func _ready() -> void:
	_set_text()
	
func _set_text() -> void:
	if not is_node_ready():
		return
	label.text = label_text

func _run_action():
	var current_scene := get_tree().current_scene
	if current_scene and current_scene.scene_file_path != "":
		Globals.finish_level(current_scene.scene_file_path)
	if transfer != null:
		get_tree().change_scene_to_packed(transfer)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		has_player = true
		if enabled:
			_run_action.call_deferred()
			
func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		has_player = false
