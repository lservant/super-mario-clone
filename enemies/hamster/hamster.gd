extends Item
class_name Hamster

@export var direction = DIRECTION.RIGHT
@export var move_speed = 5
@export var kick_speed = 20
var dir_scalar = 1

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var wallray_collider: RayCast2D = $ray_wallcheck
@onready var sprite: Sprite2D = $Sprite2D

@onready var sm: StateMachine = $States

var player: Player
var counter = 0

func _ready() -> void:
  if direction == DIRECTION.LEFT:
    wallray_collider.target_position.x = -wallray_collider.target_position.x
    dir_scalar *= -1
    sprite.flip_h = !sprite.flip_h

func _physics_process(delta: float) -> void:
  counter += 1
  # Add the gravity.
  if not is_on_floor():
    velocity += get_gravity() * delta
  
  if wallray_collider.is_colliding():
    change_direction()
    
  move_and_slide()

func change_state(state: String) -> void:
  sm.change_state(state)

func start_moving():
  change_state("move")

func change_direction():
  if direction == DIRECTION.LEFT:
    direction = DIRECTION.RIGHT
  else:
    direction = DIRECTION.LEFT
    
  wallray_collider.target_position.x = -wallray_collider.target_position.x
  dir_scalar *= -1
  sprite.flip_h = !sprite.flip_h

func hit() -> void:
  print("hit player")
  is_hitting_player = false
  player.hit(self)

func get_stomped():
  reset_can_kick()
  tprint("stomp")
  reset_can_hit_player()
  SoundManager.play_hamster()
  player.change_state("bounce")
  if sm.current_state == "move" \
      or sm.current_state == "idle" \
      or sm.current_state == "kicked":
    change_state("hide")
  else:
    change_state("kicked")
  is_stomped = false

var is_being_kicked = false
@onready var can_kick_timer = $can_kick_timer
func can_kick():
  return !can_kick_timer.running
func reset_can_kick():
  can_kick_timer.reset(0.5)
func get_kicked():
  if !can_kick():
    return
  tprint("kick")
  SoundManager.play_hamster()
  var angle_to_player = get_angle_to(player.get_center()) / PI
  var desired_direction: DIRECTION = direction
  if angle_to_player >= 0.5 and angle_to_player <= 1.5:
    desired_direction = DIRECTION.RIGHT
  elif angle_to_player < 0.5 or angle_to_player > 1.5:
    desired_direction = DIRECTION.LEFT
  print(angle_to_player, "dir", desired_direction, direction)
  if desired_direction != direction:
    print("change dir")
    change_direction()
  change_state("kicked")
  is_being_kicked = false

var is_hitting_player = false
@onready var can_hit_timer = $can_hit_player_timer
func can_hit_player():
  return !can_hit_timer.running
func reset_can_hit_player():
  can_hit_timer.reset(0.5)

func _on_collider_hit_body_entered(body: Node2D) -> void:
  _start_hitting_player(body)
  _start_hitting_enemy(body)

func _start_hitting_player(body):
  if body.name != "player":
    return
  
  player = body

  if sm.current_state == "hide" and can_kick():
    is_being_kicked = true
    return

  if can_hit_player():
    is_hitting_player = true

func _start_hitting_enemy(body):
  if !body.is_in_group("Enemies"):
    return
  
  if sm.current_state == "kicked":
    body.die()

func _on_collider_hit_body_exited(body: Node2D) -> void:
  _done_hitting_player(body)

func _done_hitting_player(body: Node2D):
  if body.name != "player":
    return
  is_hitting_player = false

var is_stomped = false
func _on_collider_stomp_body_entered(body: Node2D) -> void:
  if body.name != "player":
    return
  player = body
  if player.sm.current_state == "fall" and not is_being_kicked:
    is_stomped = true

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
  start_moving()
  
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
  queue_free()

func tprint(msg):
  print(counter, ": ", msg)
  print("is_stomped: ", is_stomped)
  print("is_being_kicked: ", is_being_kicked)
  print("can_kick: ", can_kick())