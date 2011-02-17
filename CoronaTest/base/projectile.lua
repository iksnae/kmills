module(..., package.seeall)

local bulletRadius = 5;

function newBullet()
	b = display.newGroup();
	b.health = 1;
	b.damage = 1;
	b.speed = 300;
	b.art = display.newCircle(0,0,bulletRadius);
	function b:destroy()
		self.art:removeSelf();
		self:removeSelf();
	end
end
