extends Item

@export var direction = DIRECTION.RIGHT
@export var speed = 5

@onready var collider = $CollisionShape2D
@onready var wallray_collider = $wall_ray

func _ready() -> void:
  if direction == DIRECTION.LEFT:
    speed = -speed

func _physics_process(delta: float) -> void:
  if collider.disabled:
    return
  # Add the gravity.
  if not is_on_floor():
    velocity += get_gravity() * delta
  
  if wallray_collider.is_colliding():
    direction = (direction + 1) % 2
    wallray_collider.target_position.x = -wallray_collider.target_position.x
    speed *= -1
  
  velocity.x = speed * 500 * delta
  move_and_slide()

func toggle_physics(enabled: bool):
  collider.disabled = !enabled

func _on_pickup_zone_body_entered(body: Node2D) -> void:
  if body.name != "player":
    return
  
  var player: Player = body
  Game.gain_life()
  queue_free()
