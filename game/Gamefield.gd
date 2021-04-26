extends Node2D

var tile_tube = load("res://Tile_Tube.tscn")
var tile_corner = load("res://Tile_Corner.tscn")
var tile_end_piece = load("res://Tile_End_Piece.tscn")
var tile_T_piece = load("res://Tile_T_Piece.tscn")
var tile_intersection = load("res://Tile_Intersection.tscn")

var arrow_button = load("res://Arrow_Button.tscn")

var tile_list = [tile_tube, tile_corner, tile_T_piece, tile_intersection]

var start_time = 0

# Declare member variables here. Examples:
export var fieldsize_width : int = 5
export var fieldsize_height : int = 5

export var tile_scaling = 2
export var tile_basesize = 64

export var intro_animation = true

var field : = []




# Called when the node enters the scene tree for the first time.
func _ready():
    # init 2d array
    start_time = OS.get_unix_time()
    Globals.start_time = start_time
    for x in range(fieldsize_height):
        field.append([])
        field[x]=[]        
        for y in range(fieldsize_width):
            field[x].append([])
            field[x][y]=0
            
    # draw field and test insert functions
    generateRandomField()
    drawArrows()
    drawField()
    yield(get_tree().create_timer(0.75), "timeout")
    spawnDwarf()
    if intro_animation:
        spawnAnimation()
    else:
        dwarf.in_spawn_animation = false

func insertRow(left, rowIdx, tile):
    var row = field[rowIdx]
    if left:
        row.push_front(tile)
        var node = row.pop_back()
        $".".remove_child(node)
    else:
        row.push_back(tile)
        $".".remove_child(row.pop_front())

    drawField()
        
func insertCol(top, colIdx, tile):
    var col = []
    for i in field:
        col.push_back(i[colIdx])
        
    if top:
        col.push_front(tile)
    else:
        col.push_back(tile)
    
    if top:
        $".".remove_child(col.pop_back())
    else:
        $".".remove_child(col.pop_front())
    
    var j = 0
    for i in field:
        i[colIdx] = col[j]
        j+=1
    drawField()
    
func generateRandomField():
    randomize()
    tile_list.shuffle()
    var i = 0
    var j = 0
    for row in field:
        for node in row:            

            field[i][j] = getRandomTile(Vector2(0,fieldsize_height*tile_scaling*tile_basesize+100), true)
            j+=1
        generateTileItem(row)
        i+=1
        j=0
    
    # hardcoding the starting tile
    $".".remove_child(field[0][0])
    var starting_tile = tile_corner.instance()
    tilePermutation(starting_tile, 0, 0, 2)
    #starting_tile.rotate(2* -1.5707963268)
    starting_tile.scale = Vector2(tile_scaling, tile_scaling)
    starting_tile.position = Vector2(0,0)
    field[0][0] = starting_tile
    $".".add_child(starting_tile)
    

func getRandomTile(pos, spawn):
    var tile : KinematicBody2D = tile_list[randi() % tile_list.size()].instance()
    tile.scale = Vector2(tile_scaling, tile_scaling)
    tile.position = pos
    
    var canvas_item: CanvasItem = tile.get_node("Sprite")
    canvas_item.modulate = tile_color
    
    tilePermutation(tile, randi() % 2, randi() % 2, randi() % 4)
    if spawn:
        $".".add_child(tile)
    return tile
    
func tilePermutation(tile, y_mirror, x_mirror, rotation):
    if y_mirror == 1:                                                           # 50% chance an der x achse spiegeln
        tile.scale.y *= -1
        var temp = tile.hitbox["top"]                                           # transform the hitbox dict with the thing itself
        tile.hitbox["top"] = tile.hitbox["bottom"]
        tile.hitbox["bottom"] = temp
    
    if x_mirror == 1:                                                           # 50% chance an der y achse spiegeln
        tile.scale.x *= -1
        var temp = tile.hitbox["left"]
        tile.hitbox["left"] = tile.hitbox["right"]
        tile.hitbox["right"] = temp
        
                                                                                # rotate the box by 90-360°
    tile.rotate(rotation * 1.5707963268)
    for i in range(rotation):                                                   # rotate the hitbox too
        var top = tile.hitbox["top"]
        var right = tile.hitbox["right"]
        var bottom = tile.hitbox["bottom"]
        var left = tile.hitbox["left"]
        tile.hitbox["top"] = left
        tile.hitbox["right"] = top
        tile.hitbox["bottom"] = right
        tile.hitbox["left"] = bottom
    

func drawArrows():
    # draw arrows
    for x in range(fieldsize_width + 2):
        for y in range(fieldsize_height + 2):
            var arrow: Node2D = arrow_button.instance()
            var button: TextureButton = arrow.get_child(0)
            button.connect("pressed", self, "arrow_pressed", [Vector2(x,y)])

            arrow.position = Vector2(x*(tile_basesize*tile_scaling), y*(tile_basesize*tile_scaling))
            if x==0 and y in range(1,fieldsize_height+1): # left col    
                arrow.rotation_degrees = -90
                arrow.position.x += tile_basesize / 2
                $".".add_child(arrow)
            if y == 0 and x in range(1,fieldsize_width+1): # top row
                arrow.position.y += tile_basesize / 2
                $".".add_child(arrow)
            if x == fieldsize_width+1 and y in range(1, fieldsize_height+1): # right col
                arrow.rotation_degrees = 90
                arrow.position.x -= tile_basesize / 2
                $".".add_child(arrow)
            if y == fieldsize_height+1 and x in range(1,fieldsize_width+1): # bot row
                arrow.rotation_degrees = 180
                arrow.position.y -= tile_basesize / 2
                $".".add_child(arrow)
                
func drawField():
    var i = 0
    var j = 0
       
    # draw tiles
    for row in field:
        for node in row:

            var TweenNode: Tween = node.get_node("Tween")
            var newPos = Vector2((j+0.5)*(tile_basesize*tile_scaling)+tile_basesize, (i+0.5)*(tile_basesize*tile_scaling)+tile_basesize)
            
            
#            if node.get_parent() == null:
#                var spawnPos = Vector2((j-1.0)*(tile_basesize*tile_scaling)+tile_basesize, (i-1.0)*(tile_basesize*tile_scaling)+tile_basesize)
#                node.position = spawnPos
#                $".".add_child(node)
            #else:
            TweenNode.interpolate_property(node,"position", node.position, newPos, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT) 
            TweenNode.start()
                
            j+=1
        i+=1
        j=0
    
var dwarf = null
func spawnDwarf():
    dwarf = load("res://Dwarf.tscn").instance()
    dwarf.position = Vector2(32+(tile_basesize*tile_scaling), 5)
    #dwarf.position = Vector2(800,800)                                          # position outside of the gamebox
    $".".add_child(dwarf)                                                       # use it to try out movement w/o gravity
    
func spawnAnimation():
    while not dwarf.is_on_floor():
        yield(get_tree().create_timer(.1),"timeout")
    
    dwarf._animated_sprite.play("landing2")
    yield(get_tree().create_timer(.3),"timeout")
    while dwarf._animated_sprite.frame != 0:
        yield(get_tree().create_timer(.01),"timeout")
    dwarf._animated_sprite.stop()
    
    dwarf.velocity.x = -20
    dwarf._animated_sprite.flip_h = true
    dwarf._animated_sprite.play("walk")
    yield(get_tree().create_timer(1.2),"timeout")
    
    dwarf.velocity.x = 0
    dwarf._animated_sprite.play("idle")
    yield(get_tree().create_timer(0.8),"timeout")
    
    dwarf.velocity.x = 20
    dwarf._animated_sprite.flip_h = false
    dwarf._animated_sprite.play("walk")
    yield(get_tree().create_timer(2.5),"timeout")
    
    dwarf.velocity.x = 0
    dwarf._animated_sprite.play("idle")
    
    dwarf._speech_sprite.frame = 1
    yield(get_tree().create_timer(1.5),"timeout")
    dwarf._speech_sprite.frame = 0
    dwarf.in_spawn_animation = false
    

func getRow(y):
    var row = int(y-tile_basesize) / (tile_basesize * tile_scaling)
    return clamp(row, 0, fieldsize_height)

func getCol(x):
    var col = int(x-tile_basesize) / (tile_basesize * tile_scaling)
    
    return clamp(col, 0, fieldsize_width)

func getCord(x,y):
    return Vector2(getCol(x), getRow(y))
    
func get_tile_center(pos):
    var tilepos = getCord(pos.x,pos.y)
    return Vector2((tilepos.x+0.5)*(tile_basesize*tile_scaling)+tile_basesize, (tilepos.y+0.5)*(tile_basesize*tile_scaling)+tile_basesize)
    
    
func arrow_pressed(pos):
    var selected_tile = get_node("../ItemList").get_selected_tile()
    if selected_tile == null:
        return
    add_child(selected_tile)
    if pos.x == 0: # left row button pressed
        insertRow(true, pos.y-1, selected_tile)
    if pos.x == fieldsize_width+1: # right row button pressed
        insertRow(false, pos.y-1, selected_tile)
    if pos.y == 0: # top row button pressed
        insertCol(true, pos.x-1, selected_tile)
    if pos.y == fieldsize_height + 1: # bot row button pressed
        insertCol(false, pos.x-1, selected_tile)

    
var scrolling = false
var tile_color = Color.white
var item_color = Color.darkgreen

func scroll():
    randomize()
    # remove first row
    # add new last row
    scrolling = true
    var row = []
    for i in range(fieldsize_width):
        row.append(getRandomTile(Vector2(64+(i+0.5)*tile_scaling*tile_basesize,fieldsize_height*tile_scaling*tile_basesize+100),true))
        
    var old = field.pop_front()
    for tile in old:
        $".".remove_child(tile)
        
    #print("score",float(Globals.score))
    #print("needed",((level+1) * score_per_level))
    #print("calc",float(Globals.score) / ((level+1) * score_per_level))
    if (float(Globals.score) / ((level+1) * score_per_level)) > 1.0:
        level += 1
        tile_color = Color(randf(), randf(), randf())
        item_color = Color(randf(), randf(), randf())
        score_per_level = stepify(500 + 50 / getDifficulty(), 10)
        get_parent().get_node("Level").bbcode_text = "[center]Level:\n"+str(level)
        get_parent().get_node("Music").next_level(level)
        
    clean_up_ropes()
    generateTileItem(row)
    field.push_back(row)
    
    
    
    drawField()
    $"../Score".increaseScore(10)
    #dwarf.position.y -= tile_basesize*tile_scaling
    
    yield(get_tree().create_timer(0.5), "timeout")
    scrolling = false
    

export var itemProb = 0.1337
export var chestProb = 0.5
export var difficulty_increase = 0.05

var level = 0
var score_per_level: int = 500
func getDifficulty():
    return chestProb * pow(difficulty_increase,(level/55.0))

func generateTileItem(row):
    #print(level, score_per_level, getDifficulty())
    if randf() < getDifficulty():
        var tile = row[randi() % row.size()]
        var chest = load("res://TileItem.tscn").instance()
        match tile.rotation_degrees:
            90.0: chest.rotation_degrees = -90
            180.0: chest.rotation_degrees = 180
            270.0: chest.rotation_degrees = -270
            _: print(tile.rotation_degrees)
            
        chest.scale.x = 1
        if tile.scale.x < 0:
            chest.rotation_degrees *= -1
        if tile.scale.y < 0:
            chest.scale.y *= -1
            chest.rotation_degrees *= -1
        tile.add_child(chest)
        return

    if randf() < itemProb:
        var tile: KinematicBody2D = row[randi() % row.size()]
        var item = load("res://TileItem.tscn").instance()

        item.get_node("Sprite").play("gem")
        item.score = stepify(score_per_level / 5, 10)
        var canvas_item: CanvasItem = item.get_node("Sprite")
        canvas_item.modulate = item_color
        match tile.rotation_degrees:
            90.0: item.rotation_degrees = -90
            180.0: item.rotation_degrees = 180
            270.0: item.rotation_degrees = -270
            _: print(tile.rotation_degrees)
            
        item.scale.x = 1
        if tile.scale.x < 0:
            item.rotation_degrees *= -1
        if tile.scale.y < 0:
            item.scale.y *= -1
            item.rotation_degrees *= -1
        tile.add_child(item)
        
func clean_up_ropes():
    var children = get_node("StaticBody2D").get_children()
    for child in children:
        if child is RigidBody2D or child is PinJoint2D:
            get_node("StaticBody2D").remove_child(child)
        
