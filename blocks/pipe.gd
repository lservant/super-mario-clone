extends Node2D
class_name Pipe

signal teleporting_to(node: Node2D)

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
  _set_enter_direction()
  _adjust_height()
  _setup_collider()
  if teleport_to == null:
    $teleporter.queue_free()

func _set_enter_direction() -> void:
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

func _adjust_height() -> void:
  if height < minHeight:
    height = minHeight

  var heightInPixels: float = height * spriteHeight

  var bottomSize = heightInPixels - spriteHeight
  bottom.scale.y = bottomSize / spriteHeight
  bottom.position.y = spriteHeight / 2 * (height - 1)

func _setup_collider() -> void:
  var original_height = minHeight * spriteHeight
  var heightInPixels: float = height * spriteHeight
  collider.scale.y = heightInPixels / original_height
  collider.position.y = spriteHeight / 2 * (height - minHeight)

func _on_teleporter_body_entered(body: Node2D) -> void:
  if body.name != "player":
    return
  
  var player: Player = body
  player.mount_pipe(self)

func teleport_player(player: Player, dir: ENTER_DIR) -> bool:
  if dir != enter_dir:
    return false
  
  player.start_teleport()
  var player_size = player.get_size()
  var move_by = -get_move_by(player_size)

  collider.hide()
  var tween = get_tree().create_tween()
  await tween.tween_property(player, "position", player.position + move_by, 0.5).finished
  collider.show()

  teleporting_to.emit(teleport_to)

  if teleport_to.is_in_group("Pipes"):
    await teleport_to.eject_player(player)
    return true

  player.position = teleport_to.position
  player.finish_teleport()
  return true

func get_move_by(player_size: Vector2) -> Vector2:
  var move_by = Vector2()
  match enter_dir:
    ENTER_DIR.LEFT:
      move_by.x = -player_size.x
    ENTER_DIR.RIGHT:
      move_by.x = player_size.x
    ENTER_DIR.TOP:
      move_by.y = -player_size.y
    ENTER_DIR.BOTTOM:
      move_by.y = player_size.y
  return move_by
  
func eject_player(player: Player) -> void:
  var player_size = player.get_size()
  var move_by = get_move_by(player_size)

  collider.hide()
  player.global_position = $playerspawn.global_position
  player.position.x -= player_size.x / 2

  var tween = get_tree().create_tween()
  await tween.tween_property(player, "position", player.position + move_by, 0.5).finished
  collider.show()

  player.finish_teleport()

func _on_teleporter_body_exited(body: Node2D) -> void:
  if body.name != "player":
    return

  var player: Player = body
  player.dismount_pipe(self)
