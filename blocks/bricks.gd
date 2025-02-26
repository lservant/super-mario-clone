extends StaticBody2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var topside: Area2D = $topside

@export var dark = false

const BASE_FRAME = 1
const DESTROY_FRAME = 0
const BASE_FRAME_DARK = 6
const DESTROY_FRAME_DARK = 5

func _ready() -> void:
  if dark:
    sprite.frame = BASE_FRAME_DARK
  else:
    sprite.frame = BASE_FRAME

func _on_underside_body_entered(body: Node2D) -> void:
  if body.name != "player":
    return
  
  var player: Player = body
  bump_topside()
  if player.is_big:
    destroy()
  else:
    bounce()
    player.change_state("fall")

func bump_topside():
  var things_above = topside.get_overlapping_bodies()
  for thing: CharacterBody2D in things_above:
    if not thing.is_class("CharacterBody2D"):
      continue

    thing.velocity.y = -150
    if thing.is_in_group("Enemies"):
      thing.die()

func bounce():
  anim.play("bounce")
  SoundManager.play_thud()

func destroy():
  collider.disabled = true
  Game.add_score(50)
  if dark:
    sprite.frame = DESTROY_FRAME_DARK
  else:
    sprite.frame = DESTROY_FRAME
  SoundManager.play_bricksplosion()
  await get_tree().create_timer(0.4).timeout
  queue_free()
