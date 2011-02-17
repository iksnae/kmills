module(..., package.seeall)

local projectile = require("base/projectile");

function newHero()
	print("creating new hero avatar")
	hero = display.newGroup();
	art = display.newCircle(0,0,25)
	hero:insert(art)
	
	function hero:shoot()
		bullet = projectile.newBullet()
	end
	
	return hero;
end

function newEnemy()

end