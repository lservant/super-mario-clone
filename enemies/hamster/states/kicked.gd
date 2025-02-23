extends HamsterState

func _ready() -> void:
  state = "kicked"

func reset() -> void:
  super()
  hamster.wallray_collider.set_collision_mask_value(4, false)
  hamster.anim.play("kicked")

func _physics_process(delta: float) -> void:
  if sm.current_state != state:
    return

  if hamster.is_stomped:
    hamster.get_stomped()
    return
  if hamster.is_hitting_player and hamster.can_hit_player():
    hamster.hit()
  
  hamster.velocity.x = hamster.kick_speed * 500 * delta * hamster.dir_scalar
