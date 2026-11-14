@tool
extends StaticBody2D

const TILE_TEXTURE = preload("uid://c42tws43snnj4")
const TILE_TEXTURE_ONE_WAY = preload("uid://dbrjra42fpg7o")
const TILE_TEXTURE_DISAPPEARING = preload("uid://cvwo3empw38o1")

const BLOCKER_MARGIN: float = 2.0

@onready var sprite: NinePatchRect = $Sprite
@onready var collision: CollisionShape2D = $Collision
@onready var detector_collision: CollisionShape2D = $PlayerDetector/DetectorCollision
@onready var blocker_collision: CollisionShape2D = $SpawnBlocker/BlockerCollision
@onready var destroy_timer: Timer = $DestroyTimer
@onready var restore_timer: Timer = $RestoreTimer
var shake_magnitude = 1.4

var has_player: bool = false
var player_nearby: bool = false

@export_range(1, 10, 1) var width: int = 1:
	set(value):
		width = value
		_set_width()

@export var one_way: bool = false:
	set(value):
		one_way = value
		_set_one_way()
		
@export var disappearing: bool = false:
	set(value):
		disappearing = value
		_set_texture()

func _ready() -> void:
	_set_width()
	_set_one_way()
	
func _process(_delta: float) -> void:
	if (has_player):
		var offset = Vector2(
			randf_range(-shake_magnitude, shake_magnitude),
			randf_range(-shake_magnitude, shake_magnitude),
		)
		sprite.position = offset
	else:
		sprite.position = Vector2(0, 0)

func _set_width() -> void:
	if not is_node_ready():
		return
	sprite.size.x = width * 16
	collision.position.x = width * 8
	collision.scale.x = width
	detector_collision.position.x = width * 8
	detector_collision.scale.x = width - 2.0/16.0
	blocker_collision.position.x = width * 8
	blocker_collision.scale = Vector2(width + BLOCKER_MARGIN * 2.0 / Globals.TILE_PIXEL_SIZE, 1.0)

func _set_one_way() -> void:
	if not is_node_ready():
		return
	_set_texture()
	collision.one_way_collision = one_way
	

func _set_texture() -> void:
	if not is_node_ready():
		return
	sprite.texture = TILE_TEXTURE_DISAPPEARING if disappearing else \
		TILE_TEXTURE_ONE_WAY if one_way else \
		TILE_TEXTURE

func _on_player_detector_body_entered(body: Node2D) -> void:
	if not body is Player or not disappearing:
		return
	if not restore_timer.is_stopped():
		return
	has_player = true
	if destroy_timer.is_stopped():
		destroy_timer.start()

func _on_player_detector_body_exited(body: Node2D) -> void:
	if not body is Player or not disappearing:
		return
	has_player = false
	destroy_timer.stop()
	_disable_self()
		
func _on_spawn_blocker_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	player_nearby = true

func _on_spawn_blocker_body_exited(body: Node2D) -> void:
	if not body is Player:
		return
	player_nearby = false
	if restore_timer.is_stopped():
		_enable_self()

func _disable_self():
	visible = false
	collision.set_deferred("disabled", true)
	detector_collision.set_deferred("disabled", true)
	restore_timer.start()

func _enable_self():
	if player_nearby:
		return
	visible = true
	collision.set_deferred("disabled", false)
	detector_collision.set_deferred("disabled", false)
	
