extends Node

@onready var music: AudioStreamPlayer = $music

func restart_music():
  music.play()

#items
@onready var coin: AudioStreamPlayer = $sounds/coin
@onready var extralife: AudioStreamPlayer = $sounds/extralife

func play_coin():
  coin.play()
  return coin

func play_extralife():
  extralife.play()
  return extralife

#player
@onready var jump: AudioStreamPlayer = $sounds/jump
@onready var grow: AudioStreamPlayer = $sounds/grow
@onready var hit: AudioStreamPlayer = $sounds/hit

func play_jump():
  jump.play()
  return jump

func play_grow():
  grow.play()
  return grow

func play_hit():
  hit.play()
  return hit

#blocks
@onready var item: AudioStreamPlayer = $sounds/item
@onready var bricksplosion: AudioStreamPlayer = $sounds/bricksplosion
@onready var thud: AudioStreamPlayer = $sounds/thud

func play_bricksplosion():
  bricksplosion.play()
  return bricksplosion
func play_item():
  item.play()
  return item
func play_thud():
  thud.play()
  return thud

#enemies
@onready var stomp: AudioStreamPlayer = $sounds/stomp
@onready var hamster: AudioStreamPlayer = $sounds/hamster

func play_stomp(): 
  stomp.play()
  return stomp

func play_hamster(): 
  hamster.play()
  return hamster
