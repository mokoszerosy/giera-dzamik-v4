@tool
extends StaticBody2D

const TILE_TEXTURE = preload("uid://c42tws43snnj4")
const TILE_TEXTURE_ONE_WAY = preload("uid://dbrjra42fpg7o")

@onready var sprite: NinePatchRect = $Sprite
@onready var collision: CollisionShape2D = $Collision

@export_range(1, 10, 1) var width: int = 1:
	set(value):
		width = value
		_set_width()

@export var one_way: bool = false:
	set(value):
		one_way = value
		_set_one_way()

func _ready() -> void:
	_set_width()
	_set_one_way()

func _set_width() -> void:
	if not is_node_ready():
		return
	sprite.size.x = width * 16
	collision.position.x = width * 8
	collision.scale.x = width

func _set_one_way() -> void:
	if not is_node_ready():
		return
	sprite.texture = TILE_TEXTURE_ONE_WAY if one_way else TILE_TEXTURE
	collision.one_way_collision = one_way
