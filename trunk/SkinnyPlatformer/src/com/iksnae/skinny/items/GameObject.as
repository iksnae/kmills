package com.iksnae.skinny.items
{
	import net.pixelpracht.tmx.TmxObject;
	
	import org.flixel.FlxSprite;

	public class GameObject
	{
		
		static public const DOOR:String 	= "DOOR";
		static public const PICKUP:String 	= "PICKUP";
		
		
		public var name:String;
		public var type:String;
		public var x:Number;
		public var y:Number;
		public var sprite:FlxSprite;
		public var properties:Array;

		public function GameObject(obj:TmxObject)
		{
			name 	= obj.name;
			type 	= obj.type;
			x 		= obj.x;
			y 		= obj.y;
			
			
		}
	
	}
}