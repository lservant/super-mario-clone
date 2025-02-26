extends Node

var score: int = 0
var coins: int = 0
var lives: int = 1
var time: int = 0

var spawn: Vector2 = Vector2.ZERO

var _stop_time: bool = false
func stop_time():
  _stop_time = true
func start_time():
  _stop_time = false
func countdown_time():
  if _stop_time:
    return

  time -= 1
  if time == 100:
    SoundManager.speed_music()
  if time <= 0:
    lose_life()
  
func add_coin():
  SoundManager.play_coin()
  coins += 1
  add_score(200)
  if coins % 100 == 0:
    gain_life()
    coins = 0

func add_score(points: int):
  score += points

func gain_life():
  SoundManager.play_extralife()
  lives += 1
  print("Lives: ", lives)

func lose_life():
  pause_game()
  SoundManager.stop_music()
  SoundManager.reset_music()
  SoundManager.play_hit()
  await get_tree().create_timer(0.5).timeout
  lives -= 1
  time = 0
  if lives <= 0:
    game_over()
  else:
    restart_level()

func restart_level():
  get_tree().change_scene_to_file("res://level_start.tscn")

func restart_game():
  lives = 3
  score = 0
  unset_spawn()
  restart_level()

func game_over():
  get_tree().change_scene_to_file("res://game_over.tscn")

func pause_game():
  get_tree().paused = true
  
func resume_game():
  get_tree().paused = false

func set_spawn(spawn: Node2D):
  print("Set spawn ", spawn.position)
  self.spawn = spawn.position
  self.spawn.x -= 8

func unset_spawn():
  self.spawn = Vector2.ZERO