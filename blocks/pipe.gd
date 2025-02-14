extends Node2D
class_name Pipe

@export var teleport_to: Node2D

@export var height = 2
const minHeight = 2
const spriteHeight = 16.0

const ENTER_LEFT = -90.0
const ENTER_RIGHT = 90.0
const ENTER_TOP = 0.0
const ENTER_BOTTOM = 180.0
enum ENTER_DIR {
  LEFT = 0,
  RIGHT = 1,
  TOP = 2,
  BOTTOM = 3,
}
var enter_dir: ENTER_DIR = ENTER_DIR.TOP

@onready var top: Sprite2D = $top
@onready var bottom: Sprite2D = $bottom
@onready var collider: StaticBody2D = $body

func _ready() -> void:
  var rounded_rotation = roundf(rotation_degrees)
  if rounded_rotation == ENTER_LEFT or rounded_rotation == ENTER_BOTTOM:
    top.flip_h = true
    bottom.flip_h = true

  if rounded_rotation == ENTER_TOP:
    enter_dir = ENTER_DIR.TOP
  elif rounded_rotation == ENTER_BOTTOM:
    enter_dir = ENTER_DIR.BOTTOM
  elif rounded_rotation == ENTER_LEFT:
    enter_dir = ENTER_DIR.LEFT
  elif rounded_rotation == ENTER_RIGHT:
    enter_dir = ENTER_DIR.RIGHT

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

func teleport_player(player: Player, dir: ENTER_DIR) -> bool:
  if dir != enter_dir:
    return false
  player.position = teleport_to.position
  player.is_on_pipe = false
  player.mounted_pipe = null
  return true

func _on_teleporter_body_exited(body: Node2D) -> void:
  if body.name != "player":
    return

  var player: Player = body
  player.dismount_pipe(self)
