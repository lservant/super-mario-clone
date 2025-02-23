extends HamsterState

func _ready() -> void:
  state = "hide"

func reset() -> void:
  super()
  hamster.wallray_collider.set_collision_mask_value(4, true)
  hamster.player.change_state("bounce")
  hamster.anim.play("hide")

func _physics_process(delta: float) -> void:
  if sm.current_state != state:
    return
  
  if hamster.is_stomped:
    hamster.get_stomped()
    return
  if hamster.is_being_kicked:
    hamster.get_kicked()
    return
  
  hamster.velocity.x = lerp(hamster.velocity.x, 0.0, 0.1)
