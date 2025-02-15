extends Node

var score: int = 0
var coins: int = 0
var lives: int = 3
var time: int = 400

var spawn: Vector2 = Vector2.ZERO

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
  SoundManager.play_hit()
  await get_tree().create_timer(0.5).timeout
  lives -= 1
  time = 400
  print("Lives: ", lives)
  if lives <= 0:
    game_over()
  else:
    get_tree().reload_current_scene()
    SoundManager.restart_music()

func countdown_time():
  time -= 1
  if time <= 0:
    lose_life()

func game_over():
  print("Game Over")

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