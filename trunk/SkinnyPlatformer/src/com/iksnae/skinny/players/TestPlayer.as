package com.iksnae.skinny.players
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class TestPlayer extends FlxSprite
	{
//		[Embed(source="data/Player.png")]
//		static public var skin:Class;
	
		private var _move_speed:int = 100;
		private var _jump_power:int = 400;   
		private var _max_health:int = 10;
		private var _hurt_counter:Number = 0;
		private var _size:Number = 16;
		
		public function TestPlayer(X:Number=0, Y:Number=0)
		{
			super(X, Y);
			createGraphic(_size,_size,0xffff0000);
			
//			loadGraphic(skin,true,true,_size,_size);
			
			
			maxVelocity.x = 200;
			maxVelocity.y = 320;
			acceleration.y = 200;
			drag.x = maxVelocity.x *3;

			//Set the player health
			health = 10;
			//Gravity
			acceleration.y = 210;            
			//Friction
			//bounding box tweaks
			width =_size;
			height = _size;
//			offset.x = _size*.25;
//			offset.y = _size*.5;
//			addAnimation("normal", [0, 1, 2, 3], 10);
//			addAnimation("jump", [2]);
//			addAnimation("attack", [4,5,6],10);
//			addAnimation("stopped", [0]);
//			addAnimation("hurt", [2,7],10);
//			addAnimation("dead", [7, 7, 7], 5);
		}
		override public function update():void
		{
			
			if(dead)
			{
				if(finished) exists = false;
				else
					super.update();
				return;
			}
			if (_hurt_counter > 0)
			{
				_hurt_counter -= FlxG.elapsed*3;
			}
			
			if(FlxG.keys.LEFT)
			{
				facing = FlxSprite.LEFT;
//				velocity.x -= _move_speed * FlxG.elapsed;
			}
			else if (FlxG.keys.RIGHT)
			{
				facing = FlxSprite.RIGHT;
//				velocity.x += _move_speed * FlxG.elapsed;                
			}
			if(FlxG.keys.A && velocity.y == 0)
			{
//				velocity.y = -_jump_power;
			}
			if (_hurt_counter > 0)
			{
				play("hurt");
			}
			else            
			{
				if (velocity.y != 0)
				{
					play("jump");
				}
				else
				{
					if (velocity.x == 0)
					{
						play("stopped");
					}
					else
					{
						play("normal");
					}
				}
			}
			
			super.update();
		}

	}
}