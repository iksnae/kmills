module(..., package.seeall)


-- tile colors
tile_color_wall = {255,0,0}
tile_color_floor = {0,0,0}
tile_color_brick = {255,255,0}
tile_color_start = {0,255,0}
tile_color_exit = {255,0,0}

function tileConfig(xpos,ypos,size,type)
	config = {};
	config["x"] = xpos;
	config["y"] = ypos;
	config["size"] = size;
	config["type"] = type;
	return config;
end



function newTile(config)
	--print("new tile:"..config["type"].." @ x:"..config["x"]..", y:"..config["y"])
	-- create the ne tile view
	new_tile = display.newGroup();
	-- add tile artwork
	tile_art = display.newRect(0,0,config["size"],config["size"]);
	new_tile:insert(tile_art)
	
	-- set type-specific properties	
	if(config["type"]=="wall") then
		tile_art:setFillColor(tile_color_wall[0],tile_color_wall[1],tile_color_wall[2]);
	elseif(config["type"]=="floor") then
		tile_art:setFillColor(tile_color_floor[0],tile_color_floor[1],tile_color_floor[2],0);
	elseif(config["type"]=="barrier") then
		tile_art:setFillColor(tile_color_brick[0],tile_color_brick[1],tile_color_brick[2]);
	elseif(config["type"]=="exit") then
		tile_art:setFillColor(tile_color_exit[0],tile_color_exit[1],tile_color_exit[2]);
	elseif(config["type"]=="start") then
		tile_art:setFillColor(tile_color_start[0],tile_color_start[1],tile_color_start[2]);
	end
	
	

	-- position the tile
	new_tile.x = config["x"];
	new_tile.y = config["y"];
	
	-- return the new tile
	return new_tile;
end

