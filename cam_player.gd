extends Camera2D

@export var target : Node2D

@onready var bound_left : StaticBody2D = $bound_left

var start_moving_offset = Vector2(45,0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  bound_left.global_position.x = limit_left
  position = target.position
