package com.iksnae.skinny.players
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class RTJHero extends FlxSprite
	{
		
		static public const JUMP		:String = "jump";
		static public const WALK		:String = "walk";
		static public const STOP		:String = "stop";
		static public const ATTACK		:String = "attack";
		static public const HURT		:String = "hurt";
		static public const DEAD		:String = "dead";
		static public const DODGE		:String = "dodge";
		
		
		[Embed(source="data/Player2.png")]
		static public var skin:Class;
		
		
		private var _move_speed:int = 400;
		private var _jump_power:int = 800;   
		private var _max_health:int=10;
		private var _hurt_counter:Number = 0;
		private var _size:Number = 128;
		
		public var status:String = "";
		
		public function RTJHero(X:Number=0, Y:Number=0)
		{
			super(X, Y);
//			createGraphic(32,32,0xffff0000);
			
			loadGraphic(skin,true,true,_size,_size);
			
			
			maxVelocity.x = 600;
			maxVelocity.y = 1200;
			acceleration.y = 1200;
			
			drag.x = maxVelocity.x *3;

			//Set the player health
			health = 10;
			//Gravity
			acceleration.y = 1200;            
			//Friction
			
			//bounding box tweaks
			width 		= _size*.5;
			height 		= _size*.9;
			offset.x 	= _size*.25;
			offset.y 	= _size*.1;
			
			addAnimation(WALK, [0, 1, 2, 3], 10);
			addAnimation(JUMP, [2]);
			addAnimation(ATTACK, [11,12,13],10);
			addAnimation(STOP, [0]);
			addAnimation(HURT, [2,7],10);
			addAnimation(DEAD, [7, 7, 7], 5);
			addAnimation(DODGE, [7, 7, 7], 5);
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
			
			
			
			
			
			
			if(FlxG.keys.LEFT)
			{
				facing = FlxSprite.LEFT;
			}
			else if (FlxG.keys.RIGHT)
			{
				facing = FlxSprite.RIGHT;        
			}
			if(FlxG.keys.A && velocity.y == 0)
			{
//				velocity.y = -_jump_power;
			}
			
			if (_hurt_counter > 0)
			{
				status = HURT;
				play(HURT);
				_hurt_counter -= FlxG.elapsed*3;
			}
			else            
			{
				if (velocity.y != 0)
				{
					status =JUMP;
					play(JUMP);
				}
				else
				{
					if (velocity.x == 0)
					{
						status = STOP;
						play(STOP);
					}
					else
					{
						status = 'walking';
						play(WALK);
					}
				}
			}
			if(FlxG.keys.SPACE)
			{
				trace('attack')
				status = 'attack'
				play('attack');
			}
			
			
			if(FlxG.keys.DOWN)
			{
				trace('dodge')
				status = 'dodge'
				play('dodge');
			}
			super.update();
		}

	}
}