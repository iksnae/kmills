package com.iksnae.skinny.items
{
	import net.pixelpracht.tmx.TmxObject;
	
	import org.flixel.FlxSprite;

	public class Door extends FlxSprite
	{
		[Embed(source="data/door.png")] static public var doorGraphic:Class;
		public var destination:String;
		public var spawn:String;
		public function Door(X:Number,Y:Number,graphic:Class=null)
		{
			super(X,Y,doorGraphic);
			offset.y=28;
			height = 32;
//			createGraphic(16,16,0xffff0000);
		}
	}
}
