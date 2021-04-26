extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player: AudioStreamPlayer = $track

var queued 
# Called when the node enters the scene tree for the first time.
func _ready():
    
    next_level(0)
    start_play(queued)
     # Replace with function body.

var tracks = {}
func start_play(audio):
    print("Start playing")
    
    player.stream = tracks[audio]
    player.play()
    queued = audio
 #   player.loop = true
    
 
func next_level(level):
    queued = "res://Audio/LD48_("+str(level+1)+").mp3"
    var stream
    if not queued in tracks:    
        stream = load(queued) as AudioStreamMP3
        stream.loop = false
        tracks[queued] = stream
    print("queued next level ", level)


func _on_track_finished():
    print("old track finished")
    start_play(queued)
