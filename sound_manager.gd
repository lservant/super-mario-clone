extends Node

@onready var coin: AudioStreamPlayer = $coin

func play_coin():
  coin.play()
  return coin