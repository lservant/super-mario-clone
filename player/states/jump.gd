extends PlayerState

func _ready() -> void:
  state = "jump"
  
func reset():
  super.reset()
  SoundManager.play_jump()
  player.is_jumping = true
  await get_tree().create_timer(player.jump_time).timeout
  player.is_jumping = false

func _physics_process(delta: float) -> void:
  if sm.current_state != state:
    return
    
  handle_horizontal(delta)
  
  if Input.is_action_pressed("jump") and player.is_jumping:
    player.velocity.y -= player.jump_height * player.jump_spring * delta
  else:
    player.is_jumping = false
  
  if player.velocity.y > 0:
    player.change_state("fall")
