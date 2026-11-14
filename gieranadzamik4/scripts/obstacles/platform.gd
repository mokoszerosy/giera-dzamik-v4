@tool
extends StaticBody2D

@onready var sprite: NinePatchRect = $Sprite
@onready var collision: CollisionShape2D = $Collision

@export_range(1, 10, 1) var width: int = 1:
	set(value):
		width = value
		_construct()

func _ready() -> void:
	_construct()

func _construct() -> void:
	sprite.size.x = width * 16
	#sprite.position.x = -width * 8
	collision.position.x = width * 8
	collision.scale.x = width
