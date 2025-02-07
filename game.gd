extends Node

var score: int = 0
var coins: int = 0
var lives: int = 3
var time: int = 400

func add_coin():
  coins += 1
  add_score(200)
  if coins % 100 == 0:
    gain_life()
    coins = 0

func add_score(points: int):
  score += points

func gain_life():
  lives += 1

func lose_life():
    lives -= 1
    if lives <= 0:
        game_over()

func countdown_time():
    time -= 1
    if time <= 0:
        game_over()

func game_over():
    print("Game Over")

func pause_game():
    get_tree().paused = true
  
func resume_game():
    get_tree().paused = false