extends TileMap

const x_view = 40
const y_view = 24
onready var player = get_node("../Player")

func _process(delta):
	render_tiles()

func render_tiles():
	clear()
	var nearest_cell = world_to_map(player.global_position) - Vector2(x_view / 2, y_view / 2)
	for i in range(x_view):
		var nextc = ((i * Vector2.RIGHT) + nearest_cell)
		for j in range(y_view):
			nextc = Vector2.DOWN + nextc
			set_cellv(nextc, 0)	
