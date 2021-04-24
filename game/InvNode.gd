extends Node2D

var dimensions
var arrow_button = load("res://Arrow_Button.tscn")

var tile_scaling = 3
var tile_basesize = 64
var padding_tiles = 50
var padding_screen = 70
var cols = 3

func add_tile(tile):
    var arrow: Node2D = arrow_button.instance()
    var button: TextureButton = arrow.get_child(0)
    
    button.texture_normal = tile.get_child(0).texture
    arrow.scale = Vector2(tile_scaling, tile_scaling)
    arrow.rotate(tile.rotation)
    if len(get_children()) == 0:
        arrow.position = Vector2(dimensions.x - cols*((tile_basesize*tile_scaling)+padding_tiles)+padding_screen, padding_screen + tile_basesize)
        #$".".add_child(arrow)
    else:
        var prev : Node2D =  get_child(get_child_count()-1)
        if prev.position.x + padding_tiles + (tile_basesize * tile_scaling) + padding_screen > dimensions.x:
            arrow.position = Vector2(dimensions.x - cols*((tile_basesize*tile_scaling)+padding_tiles)+padding_screen,prev.position.y + padding_tiles + (tile_basesize * tile_scaling))
        else:
            arrow.position = Vector2(prev.position.x + padding_tiles + (tile_basesize * tile_scaling),prev.position.y)
    $".".add_child(arrow)
    
func gen_inv():
    for i in range(13):
        add_tile(get_node("../Gamefield").getRandomTile())

func _ready():
    dimensions = get_viewport().get_viewport().size
    gen_inv()
    
    
    
    #var arrow: Node2D = arrow_button.instance()
    #var button: TextureButton = arrow.get_child(0)
    
    #button.texture_normal = load("res://Sprites/Tile_Corner_Piece.png")
    
    #dimensions = get_viewport().get_viewport().size
    
    #arrow.scale = Vector2(tile_scaling, tile_scaling)
    #arrow.rotate(1.5)
    #arrow.position = Vector2(dimensions.y - (tile_basesize*tile_scaling)+tile_basesize,(tile_basesize*tile_scaling)+tile_basesize)
    #$".".add_child(arrow)
