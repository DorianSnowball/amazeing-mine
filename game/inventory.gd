extends ItemList



# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var inv = []

var gd = load("res://icon.png")

func add_tile_inv(tile):
    inv.append(tile)
    var tex = tile.get_child(0).texture
    add_item(tile.name,tex,true)

func gen_inv():
    
    for i in range(20):
        add_tile_inv(get_node("../Gamefield").getRandomTile())

# Called when the node enters the scene tree for the first time.
func _ready():
    gen_inv()


    

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
