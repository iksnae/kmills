package com.iksnae.skinny.items
{
	import org.flixel.FlxSprite;
	
	public class Spawn extends FlxSprite
	{
		[Embed(source="data/blackhole_64.png")] static public var blackhole:Class;
		
		public function Spawn(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super(X, Y,blackhole);
//			loadGraphic(blackhole,true,false,64,64);
//			addAnimation('normal',[0,1,2,3,4,5,6],3)
//			play('normal');	
//			createGraphic(32,32,0xff000000,true,);
		}
		
	}
}