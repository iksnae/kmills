package com.iksnae.skinny.items
{
	import net.pixelpracht.tmx.TmxObject;
	
	import org.flixel.FlxSprite;

	public class Pickup extends FlxSprite
	{
		[Embed(source="data/coin_8.png")] 
		static public var coin:Class;
		
		public var prize:Object
		public var type:String;
		public function Pickup(X:Number,Y:Number,type:String)
		{
			super(X,Y)
			this.type = type;
			switch(type)
			{
				case 'coin':
					loadGraphic(coin);
					break;
				default:
					createGraphic(16,16,0xffffcc00);
					height = 32;
					width = 32;
					break;
				
			}
		}

			
	}
}