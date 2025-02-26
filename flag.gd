extends StaticBody2D

@export var level_exit: Node2D

@onready var grab_area = $collider_grab
@onready var boundary = $CollisionShape2D
@onready var score_zones = $score_zones

var player: Player

var scores = [5000, 2000, 1000, 400, 200]

func _physics_process(delta: float) -> void:
  if player != null:
    player.velocity = Vector2.ZERO

func grab_bar():
  Game.stop_time()
  player.can_move = false

  player.position.x = position.x - 16
  if player.direction == player.DIRECTION.LEFT:
    player.direction = player.DIRECTION.RIGHT
    player.flip_sprites()
  
  var score = determine_score()
  Game.add_score(score)

  slide_down()

func determine_score() -> int:
  print("determine score")
  var zones: Array = score_zones.get_children()
  for zone: Area2D in zones:
    var bodies = zone.get_overlapping_bodies()
    for b: Node2D in bodies:
      if b.is_in_group("Player"):
        return zone.name.to_int()
  return 0

func slide_down():
  slide_player()
  slide_flag()

func slide_player():
  var tween = get_tree().create_tween()
  tween.tween_property(player, "position:y", position.y, 1.0)
  tween.tween_callback(exit_level)

func slide_flag():
  $AnimationPlayer.play("slide")

func exit_level():
  await get_tree().create_timer(0.5).timeout
  player.change_state("walk")
  var tween = get_tree().create_tween()
  tween.tween_property(player, "position:x", player.position.x+20, 0.2)
  tween.tween_property(player, "position:y", player.position.y+16, 0.2)
  tween.tween_property(player, "position", level_exit.position, 1.0)
  Game.game_over()

func _on_collider_grab_body_entered(body: Node2D) -> void:
  if !body.is_in_group("Player"):
    return

  player = body
  grab_bar()
