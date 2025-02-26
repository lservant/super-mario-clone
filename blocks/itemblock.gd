extends StaticBody2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var block: Sprite2D = $block
@onready var topside: Area2D = $topside

@export_file() var item_path: String
@export var coins: int = 1
@export var is_hidden: bool = false
@export var is_secret: bool = false

var has_item
var item_scene: PackedScene

const EMPTY_FRAME = 8
const BRICK_FRAME = 1

func _ready() -> void:
  block.visible = !is_hidden
  has_item = !item_path.is_empty()
  item_scene = load(item_path)

  if is_secret:
    block.frame = BRICK_FRAME
  else:
    anim.play("idle")

func bump_topside():
  var things_above = topside.get_overlapping_bodies()
  for thing: CharacterBody2D in things_above:
    if not thing.is_class("CharacterBody2D"):
      continue

    thing.velocity.y = -150
    if thing.is_in_group("Enemies"):
      thing.die()

func _on_underside_body_entered(body: Node2D) -> void:
  if body.name != "player":
    return
  
  var player: Player = body
  player.change_state("fall")
  SoundManager.play_thud()
  bump_topside()
  if not is_empty():
    bounce()

  if has_item:
    give_item()
  elif coins > 0:
    give_coin()
  
  if is_empty():
    block.frame = EMPTY_FRAME
    
func give_item():
  has_item = false
  SoundManager.play_item()
  var item: Item = item_scene.instantiate()
  var item_tween = item.create_tween()
  item.position = position
  
  add_sibling(item)
  item.toggle_physics(false)
  await item_tween.tween_property(item, "position:y", item.position.y-20, 0.5).finished
  item.toggle_physics(true)
  
func give_coin():
  anim.play("give_coin")
  coins -= 1
  Game.add_coin()

func bounce():
  anim.play("bounce")

func is_empty():
  return not has_item and coins == 0