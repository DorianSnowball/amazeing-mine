extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func ll():
    get_tree().change_scene("res://GameOver.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
    connect("pressed",self,"ll")
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
