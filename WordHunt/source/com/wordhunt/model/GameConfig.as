package com.wordhunt.model
{
	import flash.utils.Dictionary;
	/**
	 * this is the configuration object for WordHunt game.
	 * - descibes the game's settings
	 * @author k
	 * 
	 */	
	public class GameConfig
	{
		public function GameConfig()
		{
		}
		public var tileSize:Number;
		public var gridWidth:int;
		public var gridHeight:int;
		public var words:Array; 
		public var rawWords:String; 
		public var difficulty:int;
		public var hilightColor:uint;
		public var lineStrokeColor:uint = 0x000000;
		public var lineFillColor:uint = 0x000000;
		public var lineFillAlpha:Number = 0;
		public var lineStrokeAlpha:Number = 1;
		public var gameBackgroundColor:uint = 0xffffff;
		public var gameCharacterColor:uint  = 0x000000;
	
		
		
		

	}
}