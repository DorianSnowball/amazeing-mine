extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player: AudioStreamPlayer = $track

var queued 
# Called when the node enters the scene tree for the first time.
func _ready():
    
    var dir = Directory.new()
    
    if dir.open("res://Audio/Background/") == OK:
        dir.list_dir_begin()
        var file_name = dir.get_next()
        while file_name != "":
            if dir.current_is_dir():
                print("Found directory: " + file_name)
            else:
                if file_name.ends_with(".mp3"):
                    var fqn = dir.get_current_dir()+"/"+file_name
                    print("Loaded " + fqn)
                    var stream = load(fqn) as AudioStreamMP3
                    stream.loop = false
                    tracks[fqn] = stream
                
            file_name = dir.get_next()
    else:
        print("An error occurred when trying to access the path.")

    
    next_level(0)
    start_play(queued)
     # Replace with function body.

var tracks = {}
func start_play(audio):
    #print("Start playing")
    
    player.stream = tracks[audio]
    player.play()
    queued = audio
 #   player.loop = true
    
 
func next_level(level):
    var fqn = "res://Audio/Background/LD48_("+str(level+1)+").mp3"
    
    if fqn in tracks:
        #print("queued next level ", level+1)
        queued = fqn
    else:
        print("no track for next level ", level+1)

func _on_track_finished():
    #print("old track finished")
    start_play(queued)
