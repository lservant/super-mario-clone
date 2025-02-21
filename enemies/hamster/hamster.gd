extends Item
class_name Hamster

@export var direction = DIRECTION.RIGHT
@export var move_speed = 5
@export var kick_speed = 20
var dir_scalar = 1

@onready var anim = $AnimationPlayer
@onready var collider = $CollisionShape2D
@onready var wallray_collider = $ray_wallcheck
@onready var sprite = $Sprite2D

@onready var sm = $States

var player: Player
var counter = 0

func _ready() -> void:
  if direction == DIRECTION.LEFT:
    change_direction()

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

func die():
  SoundManager.play_stomp()
  Game.add_score(100)
  change_state("hide")

func hit() -> void:
  print("hit player")
  is_hitting_player = false
  player.hit(self)

func get_stomped():
  reset_can_kick()
  tprint("stomp")
  reset_can_hit_player()
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
  var angle_to_player = get_angle_to(player.position) / PI
  var desired_direction = direction
  if angle_to_player >= 0.5 and angle_to_player <= 1.5:
    desired_direction = DIRECTION.RIGHT
  elif angle_to_player < 0.5 or angle_to_player > 1.5:
    desired_direction = DIRECTION.LEFT
  if desired_direction != direction:
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
  if body.name != "player":
    return
  
  player = body

  if sm.current_state == "hide" and can_kick():
    is_being_kicked = true
    return

  if can_hit_player():
    is_hitting_player = true

func _on_collider_hit_body_exited(body: Node2D) -> void:
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