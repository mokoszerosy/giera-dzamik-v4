@tool
extends StaticBody2D

const TILE_FRAMES: SpriteFrames = preload("uid://cvwo3empw38o1")
const TILE_FRAMES_ONE_WAY: SpriteFrames = preload("uid://bh3dp3jw3hwq")
const TILE_FRAMES_DISAPPEARING: SpriteFrames = preload("uid://c42tws43snnj4")
const ANIMATED_TILE_SPRITE = preload("uid://t03gfxvodhe1")

const BLOCKER_MARGIN: float = 2.0

@onready var collision: CollisionShape2D = $Collision
@onready var detector_collision: CollisionShape2D = $PlayerDetector/DetectorCollision
@onready var blocker_collision: CollisionShape2D = $SpawnBlocker/BlockerCollision
@onready var safety_timer: Timer = $SafetyTimer
@onready var destroy_timer: Timer = $DestroyTimer
@onready var restore_timer: Timer = $RestoreTimer

var has_player: bool = false
var player_nearby: bool = false
var tiles: Array[Node2D] = []

@export_range(1, 10, 1) var width: int = 1:
	set(value):
		width = value
		_rebuild()

@export var one_way: bool = false:
	set(value):
		one_way = value
		_rebuild()
		
@export var disappearing: bool = false:
	set(value):
		disappearing = value
		_rebuild()

func _ready() -> void:
	_rebuild()
	
func _process(_delta: float) -> void:
	pass

func _rebuild() -> void:
	if not is_node_ready():
		return
		
	for old_tile in tiles:
		old_tile.queue_free()
		
	tiles.clear()
		
	# Texure
	var frames = TILE_FRAMES_DISAPPEARING if disappearing else \
		TILE_FRAMES_ONE_WAY if one_way else \
		TILE_FRAMES
		
	# Old one way
	collision.one_way_collision = one_way
	
	# Old width
	collision.position.x = width * 8
	collision.scale.x = width
	detector_collision.position.x = width * 8
	detector_collision.scale.x = width - 2.0/16.0
	blocker_collision.position.x = width * 8
	blocker_collision.scale = Vector2(width + BLOCKER_MARGIN * 2.0 / Globals.TILE_PIXEL_SIZE, 1.0)
	
	for i in width:
		var spriteInstance: Node2D = ANIMATED_TILE_SPRITE.instantiate()
		tiles.append(spriteInstance)
		add_child(spriteInstance)
		var sprite: AnimatedSprite2D = spriteInstance.get_node("SpriteCut/Sprite")
		var offsetIndex = 0
		if i == 0:
			offsetIndex = 0
			sprite.animation_finished.connect(_on_sprite_animation_finished)
		elif i == width - 1:
			offsetIndex = 3
		elif i <= width / 2:
			offsetIndex = 1
		else:
			offsetIndex = 2
			
		sprite.position.x = 24 - offsetIndex * Globals.TILE_PIXEL_SIZE
		sprite.sprite_frames = frames
		
		spriteInstance.position = Vector2(i * Globals.TILE_PIXEL_SIZE, 0.0)

func _on_player_detector_body_entered(body: Node2D) -> void:
	if not body is Player or not disappearing:
		return
	if not restore_timer.is_stopped():
		return
	has_player = true
	_play_anim_on_all("playerstanding")
	safety_timer.start()
	
	if destroy_timer.is_stopped():
		Sound.play_falling_rocks_ambient()
		destroy_timer.start()

func _on_player_detector_body_exited(body: Node2D) -> void:
	if not body is Player or not disappearing:
		return
	has_player = false
	if safety_timer.is_stopped():
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
	_play_anim_on_all("breaking")
	collision.set_deferred("disabled", true)
	detector_collision.set_deferred("disabled", true)
	restore_timer.start()
	Sound.play_falling_rocks()

func _enable_self():
	if player_nearby:
		return
	_play_anim_on_all("idle")
	collision.set_deferred("disabled", false)
	detector_collision.set_deferred("disabled", false)

func _on_sprite_animation_finished() -> void:
	if not disappearing:
		return
		
	var first_sprite: AnimatedSprite2D = tiles[0].get_node("SpriteCut/Sprite")
	var previous_anim = first_sprite.animation
	match previous_anim:
		"breaking":
			_play_anim_on_all("cooldown")
			
		
		
			
func _play_anim_on_all(anim: String) -> void:
	for tile in tiles:
		var sprite: AnimatedSprite2D = tile.get_node("SpriteCut/Sprite")
		sprite.play(anim)
			
