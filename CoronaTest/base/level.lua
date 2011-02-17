module(..., package.seeall)

local Avatar = require("base/avatar")
local Util = require("util")
local Tiles = require("base/tile")

-- constants
TILE_WALL = "1"
TILE_FLOOR = "0"
TILE_BRICK = "2"
TILE_START = "S"
TILE_EXIT = "E"

tile_lookup = {};

tile_lookup[TILE_WALL] = "wall";
tile_lookup[TILE_FLOOR] = "floor";
tile_lookup[TILE_BRICK] = "brick";
tile_lookup[TILE_START] = "start";
tile_lookup[TILE_EXIT]  = "exit";





tilesize = 50;

--- build level

function buildLevel(raw_map_string)
	print("building level..")
	level = display.newGroup()
	
	function level:getHero()
		return hero;
	end
	
	-- destroy level method
	function level:destroy(raw_map_string)
		print("destroy level.");
		self:removeSelf();
	end	
	
	
	
	rdata = Util.splitString(raw_map_string,";")
	i=0;
	for rowNum=0, #rdata do
	
		-- split the chars from the row string
		cdata = Util.splitString(rdata[rowNum],",");
		
		for colNum=0, #cdata do
			
			tileConfig = Tiles.tileConfig(colNum*tilesize,rowNum*tilesize,tilesize,tile_lookup[cdata[colNum]])
			new_tile = Tiles.newTile(tileConfig) --createTile(colNum,rowNum,cdata[colNum])
			level:insert(new_tile)
			
			--- check for start
			if cdata[colNum] == TILE_START then
				level.startX = colNum*tilesize;
				level.startY = rowNum*tilesize;
				
			end
			
			--- check for exit
			if cdata[colNum] == TILE_EXIT then
				level.endX = colNum*tilesize;
				level.endY = rowNum*tilesize;
			end
			
			i=i+1;
		end
	end
	
	
	
	hero = Avatar.newHero()
	level:insert(hero)
	
	hero.x = level.startX;
	hero.y = level.startY;
	
	
	return level;
end

