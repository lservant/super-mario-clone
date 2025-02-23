extends StateBase
class_name PlayerState

@onready var player: Player = actor

func reset():
  player.anim_movement.play(state)

func handle_horizontal(delta: float):
  var target_speed = 0.0
  
  player.is_running = Input.is_action_pressed("run")
  var max_speed = player.max_walk
  if player.is_running:
    max_speed = player.max_run
    
  if Input.is_action_pressed("move_right"):
    target_speed = min(player.velocity.x + player.accel, max_speed)
  if Input.is_action_pressed("move_left"):
    target_speed = max(player.velocity.x - player.accel, -max_speed)
  if target_speed != 0.0 and player.can_move:
    player.velocity.x = lerp(player.velocity.x, target_speed, player.weight)
  return target_speed

func handle_jump(delta: float):
  if Input.is_action_just_pressed("jump") and player.can_move:
    SoundManager.play_jump()
    player.velocity.y = -player.jump_height * 500 * delta
    player.change_state("jump")

func handle_crouch():
  if Input.is_action_pressed("crouch"):
    player.change_state("crouch")