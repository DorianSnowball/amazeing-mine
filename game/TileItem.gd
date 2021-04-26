extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

var score


func _on_Area2D_body_entered(body):
    if body.name == "Dwarf":
        if score:
            $"/root/Control/Score".increaseScore(score)
        else:
            $"/root/Control/ItemList".add_tile($"/root/Control/Gamefield".getRandomTile(Vector2(0,0),false))
        call_deferred("delete", self)

func delete(node):
    get_parent().remove_child(node)
    
