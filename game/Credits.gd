extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func back():
    visible = false
# Called when the node enters the scene tree for the first time.
func _ready():
    $"Back".connect("pressed",self,"back")
    pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
