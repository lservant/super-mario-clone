extends Node2D

var left_boundary = 0.0

@onready var player = $player
@onready var camera = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  const start_moving = 50
  const start_speed = 1
  const offset_pad = 100
  var player_offset = player.position.x - left_boundary
  
  if player_offset > start_moving:
    left_boundary += start_speed
    
  camera.limit_left = left_boundary
    
