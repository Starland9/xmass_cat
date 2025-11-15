extends TileMapLayer
class_name Floor

const collectible_scene = preload("res://objects/collectible/collectible.tscn")
const enemy_scene = preload("res://characters/chicken/chiken.tscn")

var end_pos : Vector2
var _start_pos : Vector2


func generate(start_pos: Vector2, size: Vector2):
	var atlas = AtlasManager.Floors.simple   
	end_pos = start_pos + size
	_start_pos = start_pos
	var atlas_coord : Vector2
	for x in range(start_pos.x, end_pos.x):
		for y in range(start_pos.y, end_pos.y):
			if x == start_pos.x:
				if y == start_pos.y:
					atlas_coord = atlas.top_left
				elif y == end_pos.y - 1:
					atlas_coord = atlas.bottom_left()
				else:
					atlas_coord = atlas.middle_left()
			elif x == end_pos.x - 1:
				if y == start_pos.y:
					atlas_coord = atlas.top_right()
				elif y == end_pos.y - 1:
					atlas_coord = atlas.bottom_right()
				else:
					atlas_coord = atlas.middle_right()
			else:
				if y == start_pos.y:
					atlas_coord = atlas.top_center()
				elif y == end_pos.y - 1:
					atlas_coord = atlas.bottom_center()
				else:
					atlas_coord = atlas.middle_center()
				
			
			set_cell(Vector2(x, y), 0, atlas_coord)
	
	_add_collectibles()
	_add_enemies()
			

func _add_collectibles():
	for i in range(randi() % 5):
		var c : Collectible = collectible_scene.instantiate()
		add_child(c)
		c.position.x = randf_range(global_start_pos().x, global_end_pos().x)
		c.position.y = global_start_pos().y - 12
		c.scale *= .6
		
func _add_enemies():
	for i in range(randi() % 5):
		var c : Chicken = enemy_scene.instantiate()
		add_child(c)
		c.position.x = randf_range(global_start_pos().x, global_end_pos().x)
		c.position.y = global_start_pos().y - 12

func global_end_pos(): return end_pos * Vector2(tile_set.tile_size)

func global_start_pos(): return _start_pos * Vector2(tile_set.tile_size)
