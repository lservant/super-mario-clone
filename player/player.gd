extends CharacterBody2D
class_name Player

@onready var anim : AnimationPlayer = $AnimationPlayer

const accel = 100.0
const max_walk = 100.0
const max_run = 200.0

const jump_height = 20.0
const jump_spring = 50
const jump_time = 0.3

const weight = 0.11
const friction = 0.22

enum DIRECTION {LEFT, RIGHT}
var direction : DIRECTION

var current_state: String
var is_running: bool = false
var is_jumping: bool = false
var is_big: bool = false

func _ready() -> void:
  change_state("idle")

func _physics_process(delta: float) -> void:
  # Add the gravity.
  if not is_on_floor():
    velocity += get_gravity() * delta
  
  update_direction()
  move_and_slide()
  
func update_direction():
  var dir := Input.get_axis("move_left","move_right")
  if dir > 0:
    direction = DIRECTION.RIGHT
    $small_sprite.flip_h = false
    $big_sprite.flip_h = false
  elif dir < 0:
    direction = DIRECTION.LEFT
    $small_sprite.flip_h = true
    $big_sprite.flip_h = true

func grow():
  if !is_big:
    anim.play("grow")
    is_big = true

func hit():
  if is_big:
    anim.play_backwards("grow")
    is_big = false
  else:
    get_tree().reload_current_scene()

func change_state(new_state: String):
  print("Changing state ", current_state, ", ", new_state)
  current_state = new_state
  
  var states = $States
  for i in states.get_child_count():
    var state = states.get_child(i)
    if new_state == state.name:
      state.reset()
