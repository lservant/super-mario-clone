extends Node2D

@export var height = 2
const minHeight = 2
const spriteHeight = 16.0

@onready var top: Sprite2D = $top
@onready var bottom: Sprite2D = $bottom
@onready var body: StaticBody2D = $body

func _ready() -> void:
  if height < minHeight:
    height = minHeight

  var heightInPixels: float = height * spriteHeight

  var bottomSize = heightInPixels - spriteHeight
  bottom.scale.y = bottomSize / spriteHeight
  bottom.position.y = spriteHeight / 2 * (height - 1)

  var original_height = minHeight * spriteHeight
  body.scale.y = heightInPixels / original_height
  body.position.y = spriteHeight / 2 * (height - minHeight)