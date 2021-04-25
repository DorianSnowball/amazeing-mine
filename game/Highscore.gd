extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func back():
    print("highscore back")
    visible = false
    
# Called when the node enters the scene tree for the first time.
func _ready():
    $"HTTPRequest".connect("request_completed", self, "_on_request_completed")
    $"Back".connect("pressed",self,"back")
    #$"HTTPRequest".request("https://doriansnowball.de")
    var error = $"HTTPRequest".request("https://cybermuell.rocks")
    print(error)
    pass # Replace with function body.

func _on_request_completed(result, response_code, headers, body):
    print(body.get_string_from_utf8())
    print("res"+str(result))
    print(response_code)
    var json = JSON.parse(body.get_string_from_utf8())
    print(json.result)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
