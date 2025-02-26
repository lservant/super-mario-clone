extends Node2D

var left_boundary = 0.0

@onready var player = $player
@onready var camera = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  $Camera2D.make_current()
  if Game.spawn != Vector2.ZERO:
    player.global_position = Game.spawn

  Game.time = 400
  get_tree().paused = false
  SoundManager.restart_music()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  const start_moving = 50
  const start_speed = 1
  const offset_pad = 100
  var player_offset = player.position.x - left_boundary
  
  if player_offset > start_moving:
    left_boundary += start_speed
    
  camera.limit_left = left_boundary
    

func _on_bound_bottom_body_entered(body: Node2D) -> void:
  if body.name != "player":
    return
  Game.lose_life()


func _on_timer_timeout() -> void:
  Game.countdown_time()

func _on_pipe_to_a_teleporting_to(node:Node2D) -> void:
  $undergroundcam.make_current()

func _on_pipe_to_b_teleporting_to(node:Node2D) -> void:
  $Camera2D.make_current()
