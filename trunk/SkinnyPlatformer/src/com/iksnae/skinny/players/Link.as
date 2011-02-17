package com.iksnae.skinny.players
{
	import org.flixel.*;
	
	public class Link extends FlxSprite
	{
		static public const UP_NORMAL	:String = 'up_normal';
		static public const UP_WALK		:String = 'up_walk';
		
		static public const DOWN_NORMAL	:String = 'down_normal';
		static public const DOWN_WALK	:String = 'down_walk';
		
		static public const SIDE_NORMAL	:String = 'side_normal';
		static public const SIDE_WALK	:String = 'side_walk';
		
		
		private var _direction:String;
		
		[Embed(source="data/link25.png")] static public var img:Class;
		public function Link(X:Number=0, Y:Number=0)
		{
			super(X, Y);
			loadGraphic(img,true,false,25,25);
			addAnimation(UP_NORMAL,		[17],5);
			addAnimation(UP_WALK,		[13,14,15,16,17,18],10);
			addAnimation(DOWN_NORMAL,	[36,36,38,38,38,38,38,38,38,38,38,38,38,38],5);
			addAnimation(DOWN_WALK,		[26,27,28,29,30,31,32,33,34,35].reverse(),10);
			addAnimation(SIDE_NORMAL,	[10,11,12],5);
			addAnimation(SIDE_WALK,		[0,1,2,3,4,5,6,7,8,9].reverse(),10);
		}
		override public function update():void
		{
			
			if(velocity.x < 0)
			{
				play(SIDE_WALK);
				scale.x = -1;
			}
			else
			if(velocity.x > 0)
			{
				play(SIDE_WALK);
				scale.x = 1;
			}
			else
			if(velocity.x == 0)
			{
				play(SIDE_NORMAL);	
			}
			
			
			if(velocity.y < 0)
			{
				play(UP_WALK);
			}
			else
			if(velocity.y > 0)
			{
				play(DOWN_WALK);
			}
			
			
//			if( FlxG.keys.RIGHT || FlxG.keys.LEFT )
//			{
//				play(SIDE_WALK);
//				_direction = 'side';
//			}
//			if( FlxG.keys.UP)
//			{
//				play(UP_WALK);
//				_direction = 'up'
//			}
//			else
//			if( FlxG.keys.DOWN)
//			{
//				play(DOWN_WALK);
//				_direction = 'down'
//			}
//			
//			if(velocity.y==0 && _direction=='down')
//			{
//				play(DOWN_NORMAL);
//			}
//			if(velocity.y==0 && _direction=='up')
//			{
//				play(UP_NORMAL);
//			}
//			if(velocity.x==0 && _direction=='side')
//			{
//				play(SIDE_NORMAL);
//			}
//			
			
			
			
			super.update();
		}
	}
}