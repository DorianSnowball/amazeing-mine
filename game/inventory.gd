extends ItemList



# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var inv = []

var gd = load("res://icon.png")

#Rotated end tiles
var te_90 = load("res://Tile_End_Piece_90.png")
var te_180 = load("res://Tile_End_Piece_180.png")
var te_270 = load("res://Tile_End_Piece_270.png")

#Rotated corner tiles
var tc_90 = load("res://Tile_Corner_Piece_90.png")
var tc_180 = load("res://Tile_Corner_Piece_180.png")
var tc_270 = load("res://Tile_Corner_Piece_270.png")

#rotated t pieces
var tt_90 = load("res://Tile_T_Piece_90.png")
var tt_180 = load("res://Tile_T_Piece_180.png")
var tt_270 = load("res://Tile_T_Piece_270.png")

#rotated tube
var tu_vr = load("res://Tile_Tube_vert.png")


func add_tile_inv(tile):
    inv.append(tile)
    var tex = tile.get_child(0).texture
    tex = tt_90
    print(tile.rotation_degrees)
    if tile.name == "Tile_End_Piece":
        if tile.rotation_degrees == 90:
            tex = te_90
        if tile.rotation_degrees == 180:
            tex = te_180
        if tile.rotation_degrees == 270:
            tex = te_270

    if tile.name == "Tile_Corner":
        if tile.rotation_degrees == 90:
            tex = tc_90
        if tile.rotation_degrees == 180:
            tex = tc_180
        if tile.rotation_degrees == 270:
            tex = tc_270 
    
    if tile.name == "Tile_T_Piece":
        if tile.rotation_degrees == 90:
            tex = tt_90
        if tile.rotation_degrees == 180:
            tex = tt_180
        if tile.rotation_degrees == 270:
            tex = tt_270
    
    if tile.name == "Tile_Tube":
        if tile.rotation_degrees == 90 || tile.rotation_degrees == 270:
            tex = tu_vr

    add_item(tile.name,tex,true)
    

func gen_inv():
    
    for i in range(20):
        add_tile_inv(get_node("../Gamefield").getRandomTile())

# Called when the node enters the scene tree for the first time.
func _ready():
    gen_inv()
    select(0,true)

func get_selected_tile():
    var indx = get_selected_items()[0]
    var tile = inv[indx]
    inv.remove(indx)
    remove_item(indx)
    return tile
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
