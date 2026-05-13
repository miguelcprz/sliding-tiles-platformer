class_name MainMenuButton extends TextureButton

@export var right_ray : RayCast2D
@export var top_ray : RayCast2D
@export var left_ray : RayCast2D
@export var bottom_ray : RayCast2D
@export var grab_initial_focus : bool = false
@export var focus_anim : AnimatedSprite2D
var neighbor_rays : Array[RayCast2D]

func _ready() -> void:
	action_mode = BaseButton.ACTION_MODE_BUTTON_RELEASE
	neighbor_rays = [
		right_ray,top_ray,bottom_ray,left_ray
	]
	ready.connect(func(): for ray in neighbor_rays: ray.force_raycast_update(); update_neighbors())
	focus_entered.connect(set_frame_visibility)
	focus_exited.connect(set_frame_visibility)
	if grab_initial_focus:
		grab_focus()
		
func update_neighbors() -> void:
	var right_nei_set : bool = false
	var left_nei_set : bool = false
	var top_nei_set : bool = false
	var bottom_nei_set : bool = false
	
	for ray in neighbor_rays:
		ray.force_raycast_update()
		if ray.is_colliding():
			if ray.target_position.x > 0:
				focus_neighbor_right = ray.get_collider().get_parent().get_path()
				right_nei_set = true
				
			if ray.target_position.x < 0:
				focus_neighbor_left = ray.get_collider().get_parent().get_path()
				left_nei_set = true
				
			if ray.target_position.y > 0:
				focus_neighbor_bottom = ray.get_collider().get_parent().get_path()
				bottom_nei_set = true
				
			if ray.target_position.y < 0:
				focus_neighbor_top = ray.get_collider().get_parent().get_path()
				top_nei_set = true
	
	if right_nei_set == false:
		focus_neighbor_right = self.get_path()
		
	if left_nei_set == false:
		focus_neighbor_left = self.get_path()
		
	if top_nei_set == false:
		focus_neighbor_top = self.get_path()
		
	if bottom_nei_set == false:
		focus_neighbor_bottom = self.get_path()

func set_frame_visibility() -> void:
	if has_focus():
		focus_anim.show()
	else:
		focus_anim.hide()
