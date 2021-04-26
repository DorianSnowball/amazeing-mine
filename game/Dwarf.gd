extends KinematicBody2D

# score
var depth : int = 0

# environment variables
#var speed : int = 200
export var top_speed : int = 200
export var frame_counter : int = 0
export var climb_speed : int = 200
export var jumpforce : int = 250
export var gravity : int = 800
export var coyote_time : int = 6

var frames_in_air : int = 0

#no stuck
var stuck_count = 0
var last_y = 0

var velocity : Vector2 = Vector2()

var on_rope : bool = false

var in_spawn_animation : bool = true


#onready var sprite : Sprite = get_node("Sprite")
onready var gamefield = $"/root/Control/Gamefield"
var rope_object = load("res://Rope.tscn")
onready var _animated_sprite = $AnimatedSprite
onready var _magic_sprite = $"magic sprite"
onready var _magic_sound = $poof
onready var _speech_sprite = $"speech bubble"

func get_input(delta):
    if -3 <= velocity.x and velocity.x <= 3:                              # Dead Zone Detection
        velocity.x = 0
        frame_counter = 0
        
    # movement input here
    if Input.is_action_pressed("move_left"):
        frame_counter += 1
        velocity.x = -6*(frame_counter*frame_counter)+1                                                     # Make go fast
        
    elif Input.is_action_pressed("move_right"):
        frame_counter += 1
        velocity.x = 6*(frame_counter*frame_counter)+1                                                     # Make go fast
        
    
    if Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right"):
        frame_counter = 0
    
    if not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right") and velocity.x != 0:
        frame_counter += 1
        velocity.x = 2.45* pow((frame_counter-3), 4)

        
    if Input.is_action_just_pressed("move_left"):
        _animated_sprite.flip_h = true                                          # spin guy in right direction
        if is_on_floor():
            _animated_sprite.play("walk")                                           # sprite animation
    elif Input.is_action_just_pressed("move_right"):
        _animated_sprite.flip_h = false                                         # spin guy in right direction
        if is_on_floor():
            _animated_sprite.play("walk")                                           # sprite animation
    
    if not is_on_floor():
        frames_in_air += 1
    else:
        frames_in_air = 0
    
    # jump input
    if Input.is_action_just_pressed("jump") and (frames_in_air <= coyote_time or on_rope):
        velocity.y -= jumpforce

        if velocity.x < 0:                                                      # backflip city
            for _x in range(30): #16
                _animated_sprite.rotation_degrees += 360/30  #22.5
                yield(get_tree().create_timer(0.4/30),"timeout")
        elif velocity.x >= 0:
            for _x in range(30): #16
                _animated_sprite.rotation_degrees -= 360/30  #22.5
                yield(get_tree().create_timer(0.4/30),"timeout")
    if Input.is_action_just_pressed("rope"):
        spawn_rope()
    
    if Input.is_action_pressed("climb_up") and on_rope:
        velocity.y = climb_speed * -1
    elif Input.is_action_pressed("climb_down") and on_rope:
        velocity.y = climb_speed
        
    if not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right") and not Input.is_action_pressed("climb_up") and not Input.is_action_pressed("climb_down") and is_on_floor():
        _animated_sprite.play("idle")
        
    if Input.is_action_just_pressed("climb_up") and on_rope:
        _animated_sprite.play("climb")                                           # sprite animation
    elif Input.is_action_just_pressed("climb_down") and on_rope:
        _animated_sprite.play("climb")  
    
    if Input.is_action_just_released("climb_up") or Input.is_action_just_released("climb_down"):
        velocity.y = 0
        
        

func _physics_process(delta):
    if not in_spawn_animation:
        #velocity.x = 0
        get_input(delta)        
        
    if velocity.x > top_speed:                                                  # restrict to top speed
        velocity.x = top_speed
    elif velocity.x < -1 * top_speed:
        velocity.x = -1* top_speed
    # applying the velocity
    velocity = move_and_slide(velocity, Vector2.UP)
    
    # gravity
    if not on_rope:
        velocity.y += gravity * delta
    
    #$"/root/Control/Score".text = "Velocity" + str(velocity)
    #$"/root/Control/Score".text = "Animation: " + _animated_sprite.animation
    if not in_spawn_animation:
        checkScroll()
        teleport()
        check_stuck()
    

# Called every frame. 'delta' is the elapsed time since the previous frame.   
func _process(delta):
    pass
    #$"/root/Control/Score".text = str(getTileHB($"/root/Control/Gamefield".field[getCurrentTile().y][getCurrentTile().x]))
    
    
export var max_stuck_count = 5
export var top_reset_trigger = 80
export var delta_y : float = 5.0

func check_stuck(): # not is_on_ceiling()
    var stuck_1 = is_on_wall() and not is_on_floor() and abs(last_y - position.y) <  delta_y
    var stuck_2 = position.y < top_reset_trigger and abs(last_y - position.y) <  delta_y
    if stuck_1 or stuck_2:
        stuck_count += 1
    else:
        stuck_count = 0
    #$"/root/Control/InvCounter".text = "stuck count: " + str(stuck_count) + "\nlast y: " + str(last_y) + "\nmy y:" + str(position.y) + "\nmy tile " + str(get_parent().getCord(position.x,position.y))
    last_y = position.y
    
    if stuck_count >= max_stuck_count:
        position = get_parent().get_tile_center(position)
        
func spawn_rope():
    var rope: RigidBody2D = rope_object.instance()
    rope.apply_impulse(Vector2(),Vector2(0,-1000))
    rope.position = position
    rope.position.y -= 40
    get_parent().add_child(rope)
    
    
func checkScroll():
    if get_parent().getRow(position.y) > 1 and is_on_floor() and not get_parent().scrolling:
        get_parent().scroll()


func getCurrentTile():
    return gamefield.getCord(position.x, position.y)
    
func getTileHB(tile):
    return tile.hitbox
    
func teleport():
    var modifier = 0.17
    var left_define = (gamefield.tile_basesize * gamefield.tile_scaling)/2 * (1.0 + modifier)
    var right_define = (gamefield.tile_basesize * gamefield.tile_scaling)/2 * (1.0 - modifier) + (gamefield.tile_basesize * gamefield.tile_scaling * gamefield.fieldsize_width)
    
    if position.x <= left_define and checkForRoom():
        position.x = right_define - modifier*2
        teleportEffect()
        
    elif position.x >= right_define and checkForRoom():
        position.x = left_define + modifier*2
        teleportEffect()


func teleportEffect():
    _magic_sound.play()
    if not _magic_sprite.playing:
        _magic_sprite.play("poof")

        yield(get_tree().create_timer(.1),"timeout")
        while _magic_sprite.frame != 0:
            yield(get_tree().create_timer(.01),"timeout")
        _magic_sprite.stop()
        _magic_sound.stop()

func checkForRoom():
    var curTile = getCurrentTile()
    return (curTile.x == 0 and not getTileHB(gamefield.field[curTile.y][curTile.x])["left"] and not getTileHB(gamefield.field[curTile.y][gamefield.fieldsize_width-1])["right"]) or \
    (curTile.x == gamefield.fieldsize_width-1 and not getTileHB(gamefield.field[curTile.y][curTile.x])["right"] and not getTileHB(gamefield.field[curTile.y][0])["left"])
         
        
