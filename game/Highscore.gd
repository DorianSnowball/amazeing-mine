extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func back():
    print("highscore back")
    visible = false
    
# Called when the node enters the scene tree for the first time.
export var highscore_url = "https://doriansnowball.de/gethighscores.php"
func _ready():
    $"HTTPRequest".connect("request_completed", self, "_on_request_completed")
    $"Back".connect("pressed",self,"back")
    $"HTTPRequest".request(highscore_url)
    #print(error)
    pass # Replace with function body.

func _on_request_completed(result, response_code, headers, body):
    print(body.get_string_from_utf8())
    print("res"+str(result))
    print(response_code)
    var json = JSON.parse(body.get_string_from_utf8())
    var highscores = json.result
    $"RichTextLabel".bbcode_text = "[center]"
    var count = 1
    for s in highscores:
        var time = int(s['time'] )
        var minutes = time / 60
        var seconds = time % 60
        $"RichTextLabel".bbcode_text += str(count) + ". " + s['name'] + "  " + s['score'] + "m " + str(minutes) + ":" + str(seconds) + "\n"
        count += 1
        
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
