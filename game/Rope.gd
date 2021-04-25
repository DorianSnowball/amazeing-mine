extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rope_segment = load("res://RopeSegment.tscn")
var start_pos_y
var segments = []

# Called when the node enters the scene tree for the first time.
func _ready():
    start_pos_y = position.y
    
    var rope = rope_segment.instance()
    rope.position = Vector2(0,0)
    #rope.position.y += segments.size() * segment_size
    segments.append(rope)
    add_child(rope)
    
    var joint: Joint2D = $"JointR-1"
    joint.node_b = rope.get_path()
    joint.position = Vector2(0,0)
   

# Called every frame. 'delta' is the elapsed time since the previous frame.

var segment_size = 32
func _process(delta):
    pass
#    if abs(position.y - start_pos_y) > segment_size:
#        var joint = PinJoint2D.new()
#        var rope = rope_segment.instance()
#        joint.position = position 
#        joint.position.y += segments.size() * segment_size
#        rope.position = position 
#        rope.position.y += segments.size() * segment_size
#        segments.append(rope)
#
#        joint.node_a = segments.back().get_path()
#        joint.node_b = rope.get_path()

var attached = false
func _on_RigidBody2D_body_entered(body):
    if not attached:
        if body is StaticBody2D or body is KinematicBody2D:
                        
            var pos = global_position
            
            get_parent().remove_child(self)
            body.add_child(self)
            global_position = pos
            global_rotation_degrees = 0
           
            var joint = PinJoint2D.new()
            joint.node_a = body.get_path()
            joint.node_b = get_path()
            joint.position = position
            
            body.add_child(joint)
            
            var jointR1: Joint2D = $"JointR-1"
            jointR1.node_b = segments[0].get_path()
            
            segments[0].linear_velocity = Vector2()
            linear_velocity = Vector2()
            attached = true
            
            var space_state = get_world_2d().direct_space_state
            var exclusion_list = [self,$"Anchor", $"/root/Control/Gamefield/Dwarf"]
            exclusion_list.append_array(segments)

            var result = space_state.intersect_ray(global_position, Vector2(global_position.x,800), exclusion_list)
            
            if result:
                var distance = global_position.distance_to(result.position)
                
                for i in range((distance/segment_size)-1):
                    var segment_joint = PinJoint2D.new()
                    var rope = rope_segment.instance()
                    var last = segments.back()
                    
                    add_child(segment_joint)
                    add_child(rope)
                    segment_joint.global_position = last.global_position
                    segment_joint.global_position.y += 32
                    
                    rope.global_position = last.global_position
                    rope.global_position.y += 32
                    
                    segment_joint.global_rotation_degrees = 0
                    rope.global_rotation_degrees = 0
                    segment_joint.node_a = last.get_path()
                    segment_joint.node_b = rope.get_path()
                    
                    segments.append(rope) 
                    yield(get_tree().create_timer(0.25), "timeout")
                    
