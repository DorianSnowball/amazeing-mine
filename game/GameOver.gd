extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var end_time = 0

export var highscore_post_url = "https://doriansnowball.de/posthighscore.php"
func name_entered(name):
    if $"namebox".editable == false:
        return
    var time = end_time - Globals.start_time
    var query = JSON.print([["name",name],["score",Globals.score],["time",time]])
    var headers = ["Content-Type: application/json"]
    var error = $"HTTPRequest".request(highscore_post_url, headers, true, HTTPClient.METHOD_POST, query)
    print(error)
    $"namebox".editable = false
        
func name_focus():
    $"namebox".text = ""

func quit():
    get_tree().quit()
    
func menu():
    get_tree().change_scene("res://menu.tscn")

func submit():
    name_entered($"namebox".text)

# Called when the node enters the scene tree for the first time.
func _ready():
    end_time = OS.get_unix_time()
    $"submit".connect("pressed",self,"submit")
    $"menu".connect("pressed",self,"menu")
    $"quit".connect("pressed",self,"quit")
    $"namebox".connect("text_entered",self,"name_entered")
    $"HTTPRequest".connect("request_completed", self, "_on_request_completed")


func _on_request_completed(result, response_code, headers, body):
    print(body.get_string_from_utf8())
    print("res"+str(result))
    print(response_code)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
