extends CharacterBody2D
class_name Player

@onready var anim_movement: AnimationPlayer = $anim_movement
@onready var anim_transform: AnimationPlayer = $anim_transform
@onready var anim_hit: AnimationPlayer = $anim_hit

const accel = 100.0
const max_walk = 100.0
const max_run = 200.0

const jump_height = 20.0
const jump_spring = 50
const jump_time = 0.3

const weight = 0.11
const friction = 0.22

enum DIRECTION {LEFT, RIGHT}
var direction: DIRECTION

@onready var sm: StateMachine = $States

var is_running: bool = false
var is_jumping: bool = false
var is_big: bool = false
var is_immune: bool = false
var is_flashy: bool = false
var can_move: bool = true
var is_teleporting: bool = false

var immune_time: float = 3.0
var flashy_time: float = 10.0

func _ready() -> void:
  change_state("idle")

func _physics_process(delta: float) -> void:
  if !can_move:
    return

  # Add the gravity.
  if not is_on_floor():
    velocity += get_gravity() * delta
  
  update_direction()
  move_and_slide()

func get_center():
  if is_big:
    return $big_sprite.global_position
  else:
    return $small_sprite.global_position
    
func update_direction():
  var dir := Input.get_axis("move_left", "move_right")
  if dir > 0:
    direction = DIRECTION.RIGHT
    flip_sprites()
  elif dir < 0:
    direction = DIRECTION.LEFT
    flip_sprites()

func flip_sprites():
  var flip = direction == DIRECTION.LEFT
  $small_sprite.flip_h = flip
  $big_sprite.flip_h = flip

func grow():
  SoundManager.play_grow()
  if !is_big:
    get_tree().paused = true
    anim_transform.play("grow")
    is_big = true

func hit(enemy: Node2D):
  if is_flashy:
    enemy.die()
    return
  if is_immune:
    return

  get_tree().paused = true
  SoundManager.play_hit()
  is_immune = true
  if is_big:
    anim_transform.play_backwards("grow")
    is_big = false
    await get_tree().create_timer(immune_time).timeout
    anim_hit.stop()
    is_immune = false
  else:
    Game.lose_life()

func be_flashy():
  is_flashy = true
  is_immune = true
  anim_hit.play("flashy")
  await get_tree().create_timer(flashy_time).timeout
  anim_hit.stop()
  is_immune = false
  is_flashy = false

func change_state(new_state: String):
  sm.change_state(new_state)

func _on_anim_transform_animation_finished(anim_name: StringName) -> void:
  if anim_name == "grow":
    if is_immune:
      anim_hit.play("hit")
    get_tree().paused = false

var is_on_pipe = false
var mounted_pipe: Pipe

func mount_pipe(pipe: Pipe):
  is_on_pipe = true
  mounted_pipe = pipe

func dismount_pipe(pipe: Pipe):
  is_on_pipe = false
  mounted_pipe = null

func try_teleport(dir: Pipe.ENTER_DIR):
  if !is_on_pipe:
    return
  if is_teleporting:
    return
  if not can_move:
    return

  is_teleporting = true
  return await mounted_pipe.teleport_player(self, dir)

func start_teleport():
  can_move = false
  scale = Vector2(0.9,0.9)

func finish_teleport():
  scale = Vector2(1, 1)
  is_on_pipe = false
  mounted_pipe = null
  can_move = true
  is_teleporting = false

func get_size():
  if is_big:
    return Vector2(16, 32)
  else:
    return Vector2(16, 16)