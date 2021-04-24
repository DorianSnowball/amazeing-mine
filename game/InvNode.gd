extends Node2D

var dimensions
var arrow_button = load("res://Arrow_Button.tscn")

var clicked = 0

var tile_scaling = 3
var tile_basesize = 64
var padding_tiles = 50
var padding_screen = 70
var cols = 3
var start_tiles = 50

var button_count = 9

var inv = []

func add_button(indx):
    var arrow: Node2D = arrow_button.instance()
    var button: TextureButton = arrow.get_child(0)
    
    button.texture_normal = null
    arrow.scale = Vector2(tile_scaling, tile_scaling)
    
    #scale fuckery
    if len(get_children()) == 0:
        arrow.position = Vector2(dimensions.x - cols*((tile_basesize*tile_scaling)+padding_tiles)+padding_screen, padding_screen + tile_basesize)
    else:
        var prev : Node2D =  get_child(get_child_count()-1)
        if prev.position.x + padding_tiles + (tile_basesize * tile_scaling) + padding_screen > dimensions.x:
            arrow.position = Vector2(dimensions.x - cols*((tile_basesize*tile_scaling)+padding_tiles)+padding_screen,prev.position.y + padding_tiles + (tile_basesize * tile_scaling))
        else:
            arrow.position = Vector2(prev.position.x + padding_tiles + (tile_basesize * tile_scaling),prev.position.y)
    $".".add_child(arrow)
    
    #button fuckery
    button.connect("pressed",self,"inv_button",[indx])

func inv_to_buttons():
    for i in range(button_count):
        var button : Node2D = get_child(i)
        if i + 1 > len(inv):
            button.visible = false
        else:
            button.visible = true
            var tile : KinematicBody2D = inv[i]
            button.rotation = 0
            button.get_child(0).texture_normal = tile.get_child(0).texture
            #fookin flipped shit mate
            button.scale = tile.scale
            button.rotation = tile.rotation
        
    
func add_tile(tile):
    inv.append(tile)
    if len(inv) <= button_count:
        inv_to_buttons()
    
    
func inv_button(indx):
    var tile : KinematicBody2D = inv[indx]
    clicked = indx
    
func gen_buttons():
    for i in range(button_count):
        add_button(i)
        
func get_selected_tile():
    if len(inv) == 0:
        return null
    var tile = inv[clicked]
    tile.position = get_child(clicked).position
    inv.remove(clicked)
    inv_to_buttons()
    clicked = 0
    return tile
    
func gen_inv():
    for i in range(start_tiles):
        add_tile($"../Gamefield".getRandomTile(Vector2(0,0)))

func _ready():
    dimensions = get_viewport().get_viewport().size
    if dimensions.y < 1000:
        tile_scaling = 2
    gen_buttons()
    gen_inv()
    
    
    
    #var arrow: Node2D = arrow_button.instance()
    #var button: TextureButton = arrow.get_child(0)
    
    #button.texture_normal = load("res://Sprites/Tile_Corner_Piece.png")
    
    #dimensions = get_viewport().get_viewport().size
    
    #arrow.scale = Vector2(tile_scaling, tile_scaling)
    #arrow.rotate(1.5)
    #arrow.position = Vector2(dimensions.y - (tile_basesize*tile_scaling)+tile_basesize,(tile_basesize*tile_scaling)+tile_basesize)
    #$".".add_child(arrow)
