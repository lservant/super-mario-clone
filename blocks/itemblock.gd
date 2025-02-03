extends StaticBody2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var collider: CollisionShape2D = $CollisionShape2D

@export_file() var item_path: String
@export var coins: int = 1

var has_item
var item_scene: PackedScene

func _ready() -> void:
  has_item = !item_path.is_empty()
  item_scene = load(item_path)

func _on_underside_body_entered(body: Node2D) -> void:
  if body.name != "player":
    return
  
  var player: Player = body
  
  bounce()
  player.change_state("fall")

  if has_item:
    give_item()
  elif coins > 0:
    give_coin()
  
func give_item():
  var item: Item = item_scene.instantiate()
  var item_tween = item.create_tween()
  item.position = position
  
  add_sibling(item)
  item.toggle_physics(false)
  await item_tween.tween_property(item, "position:y", item.position.y-20, 0.5).finished
  item.toggle_physics(true)
  has_item = false
  
func give_coin():
  anim.play("give_coin")
  coins -= 1

func bounce():
  anim.play("bounce")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
  if anim_name == "bounce":
    anim.play("RESET")
