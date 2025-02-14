extends Node2D
class_name Pipe

@export var teleport_to: Node2D

@export var height = 2
const minHeight = 2
const spriteHeight = 16.0

@onready var top: Sprite2D = $top
@onready var bottom: Sprite2D = $bottom
@onready var collider: StaticBody2D = $body

func _ready() -> void:
  if height < minHeight:
    height = minHeight

  var heightInPixels: float = height * spriteHeight

  var bottomSize = heightInPixels - spriteHeight
  bottom.scale.y = bottomSize / spriteHeight
  bottom.position.y = spriteHeight / 2 * (height - 1)

  var original_height = minHeight * spriteHeight
  collider.scale.y = heightInPixels / original_height
  collider.position.y = spriteHeight / 2 * (height - minHeight)

  if teleport_to == null:
    $teleporter.queue_free()

func _on_teleporter_body_entered(body: Node2D) -> void:
  if body.name != "player":
    return
  
  var player: Player = body
  player.mount_pipe(self)

func teleport_player(player: Player) -> void:
  player.position = teleport_to.position
  player.is_on_pipe = false
  player.mounted_pipe = null

func _on_teleporter_body_exited(body: Node2D) -> void:
  if body.name != "player":
    return

  var player: Player = body
  player.dismount_pipe(self)
