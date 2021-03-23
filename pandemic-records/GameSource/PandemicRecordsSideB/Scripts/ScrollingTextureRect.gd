class_name ScrollingTextureRect
extends TextureRect

# Scroll velocity:
# Velocity at which the texture scrolls. In pixels/second.
export var scroll_velocity: Vector2 = Vector2.ZERO
# Scrolling:
# Weather or not the texture scrolls.
export var scrolling: bool = true

# Local variable to keep track of the offset of the texture.
var progress: Vector2 = Vector2.ZERO
onready var init_pos = rect_position
onready var scroll_dist = 0.75 * rect_size.y

func _process(delta):
	if texture == null or !scrolling: return
	
	# add movement
	rect_position += scroll_velocity * delta
	progress += scroll_velocity * delta
	
	# check if we moved over the entire map
	while abs(progress.y) >= scroll_dist:
		progress.y -= scroll_dist * sign(scroll_velocity.y)
		rect_position.y -= scroll_dist * sign(scroll_velocity.y)

func _on_PlayButton_pressed():
	progress.y = 0
	rect_position = init_pos
	scroll_velocity.y = 150

func _on_PlayerSpawner_you_died():
	scroll_velocity.y = 0
