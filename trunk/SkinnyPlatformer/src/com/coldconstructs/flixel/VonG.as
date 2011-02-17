package com.coldconstructs.flixel
{
	import flash.display.*;
	import flash.geom.*;
	
	public class VonG {
		static public var zp:Point = new Point();
		static private var p1:Point = new Point(0, 0);
		static private var p2:Point = new Point(0, 0);
		static private var pos0:Point = new Point(0, 0);
		static private var pos1:Point = new Point(0, 0);
		static private var vel0:Point = new Point(0, 0);
		static private var vel1:Point = new Point(0, 0);
		
		/**
		 * Pixel-perfect collision/overlap detection between two FlxSprites.
		 * @param	target1		An FlxSprite you want to check collision of.
		 * @param	target2		The other FlxSprite you want to collide with the first one.
		 * @return	The area of the collision between the two FlxSprites.
		 */
		static public function getCollisionRect(target1:VonSprite, target2:VonSprite):Rectangle {
			if (target1.ikID == target2.ikID) return null; // ignore sprites attached to each other
			var rect1:Rectangle = target1.buffer.rect.clone();
			rect1.x = rect1.y = 0; // uneeded
			var rect2:Rectangle = target2.buffer.rect.clone();
			rect2.x = target2.x - target1.x;
			rect2.y = target2.y - target1.y;
			var intersectionRect:Rectangle = rect1.intersection(rect2);
			intersectionRect.width = int(intersectionRect.width); // dimensions need to be floored else an "invalid bitmapdata" error is thrown if w or h < 1.0
			intersectionRect.height = int(intersectionRect.height);
			if (intersectionRect.width > 0 && intersectionRect.height > 0) {
				var alpha1:BitmapData = new BitmapData(intersectionRect.width, intersectionRect.height, false, 0);
				alpha1.copyChannel(target1.buffer, intersectionRect, zp, BitmapDataChannel.ALPHA, BitmapDataChannel.RED);
				intersectionRect.x += target1.x - target2.x;
				intersectionRect.y += target1.y - target2.y;
				var alpha2:BitmapData = new BitmapData(intersectionRect.width, intersectionRect.height, false, 0);
				alpha2.copyChannel(target2.buffer, intersectionRect, zp, BitmapDataChannel.ALPHA, BitmapDataChannel.GREEN);
				alpha1.draw(alpha2, null, null, BlendMode.LIGHTEN);
				var collisionRect:Rectangle = alpha1.getColorBoundsRect(0x010100, 0x010100);
				alpha1.dispose();
				alpha2.dispose();
				collisionRect.width = int(collisionRect.width); // i could just check for width >1 but i need clean dimensions anyway
				collisionRect.height = int(collisionRect.height);
				if (collisionRect.size.length > 0) {
					collisionRect.x += intersectionRect.x + target2.x; // put the rectangle back in sprites' coord space
					collisionRect.y += intersectionRect.y + target2.y;
					return collisionRect;
				} else return null;
			} else return null;
		}
		
		/**
		 * Provides circle-based collision detection and simple billiard-ball physics reaction (with mass). COPY THIS TO YOUR MAIN LOOP
		 * @param	objList		A Vector of the VonSprites you want to collide with each other. Don't forget to set the radius (and mass, optionally) of each object.
		 */
		static public function collideByRadius(objList:Vector.<VonSprite>):void {
			var objNum:int = objList.length;
			var i:int = 0;
			var j:int = 0;
			for (i = 0; i < objNum - 1; ++i) {
				var o0:VonSprite = objList[i];
				if (!o0.active) continue;
				for (j = i + 1; j < objNum; ++j) {
					var o1:VonSprite = objList[j];
					if (!o1.active) continue;
					var dx:Number = (o1.x+(o1.width>>1)) - (o0.x+(o0.width>>1));
					var dy:Number = (o1.y+(o1.height>>1)) - (o0.y+(o0.height>>1));
					var dist:Number = Math.sqrt(dx*dx + dy*dy);
					if (dist < o0.radius + o1.radius) {
						var angle:Number = Math.atan2(dy, dx);
						var sin:Number = Math.sin(angle);
						var cos:Number = Math.cos(angle);
						pos0.x = pos0.y = 0;
						pos1 = rotate(dx, dy, sin, cos, true);
						vel0 = rotate(o0.velocity.x, o0.velocity.y, sin,cos,true);
						vel1 = rotate(o1.velocity.x, o1.velocity.y, sin,cos,true);
						var vxTotal:Number = vel0.x - vel1.x;
						vel0.x = ((o0.mass - o1.mass) * vel0.x + 2 * o1.mass * vel1.x) / (o0.mass + o1.mass);
						vel1.x = vxTotal + vel0.x;
						var absV:Number = ((vel0.x ^ (vel0.x >> 31)) - (vel0.x >> 31)) + ((vel1.x ^ (vel1.x >> 31)) - (vel1.x >> 31));
						var overlap:Number = o0.radius + o1.radius - Math.abs(pos0.x - pos1.x);
						pos0.x += vel0.x / absV * overlap;
						pos1.x = vel1.x / absV * overlap;
						var pos0F:Point = rotate(pos0.x, pos0.y, sin, cos, false);
						var pos1F:Point = rotate(pos1.x, pos1.y, sin, cos, false);
						o1.x += pos1F.x;
						o1.y += pos1F.y;
						o0.x += pos0F.x;
						o0.y += pos0F.y;
						var vel0F:Point = rotate(vel0.x, vel0.y, sin, cos, false);
						var vel1F:Point = rotate(vel1.x, vel1.y, sin, cos, false);
						o0.velocity.x = vel0F.x;
						o0.velocity.y = vel0F.y;
						o1.velocity.x = vel1F.x;
						o1.velocity.y = vel1F.y;
						o0.bump(o1);
						o1.bump(o0);
					}
				}
			}
		}
		
		static private function rotate(x:Number, y:Number, sin:Number, cos:Number, reverse:Boolean):Point {
			var result:Point = new Point();
			if(reverse) {
				result.x = x * cos + y * sin;
				result.y = y * cos - x * sin;
			} else {
				result.x = x * cos - y * sin;
				result.y = y * cos + x * sin;
			}
			return result;
		}
		
		/**
		 * Rotates a point in 2D space around another point by the given angle.
		 * @param	X		The X coordinate of the point you want to rotate.
		 * @param	Y		The Y coordinate of the point you want to rotate.
		 * @param	PivotX	The X coordinate of the point you want to rotate around.
		 * @param	PivotY	The Y coordinate of the point you want to rotate around.
		 * @param	Angle	Rotate the point by this many degrees.
		 * @return	A <code>Point</code> containing the coordinates of the rotated point.
		 */
		static public function orbitPoint(X:Number, Y:Number, PivotX:Number, PivotY:Number, Angle:Number):Point {
			var P:Point = new Point();
			var rad:Number = Angle * 0.01745;
			var sin:Number = Math.sin(rad);
			var cos:Number = Math.cos(rad);
			var dx:Number = X - PivotX;
			var dy:Number = Y - PivotY;
			P.x = dx * cos + dy * sin;
			P.y = dy * cos - dx * sin;
			P.x += PivotX;
			P.y += PivotY;
			return P;
		}
	}
}
