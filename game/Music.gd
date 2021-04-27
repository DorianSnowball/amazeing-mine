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
                if file_name.ends_with(".mp3.import"):
                    
                    var dir_path = dir.get_current_dir()
                    var fqn = (dir_path if dir_path.ends_with("/") else dir_path + "/")+file_name
                    
                    var config = ConfigFile.new()
                    var err = config.load(fqn)
                    if err == OK:
                        var mp3_path = config.get_value("remap", "path", "null")
                        print(mp3_path)
                    
                        print("Loaded " + mp3_path)
                        var stream = load(mp3_path) as AudioStreamMP3
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
    

var music_level = 0
func next_level(level):
    if (level % 2 == 0):
        music_level += 1
        var fqn = "res://Audio/Background/LD48_("+str(music_level)+").mp3.import"
        
        if fqn in tracks:
            #print("queued next level ", level+1)
            queued = fqn
        else:
            print("no track for next level ", music_level)

func _on_track_finished():
    #print("old track finished")
    start_play(queued)
