package com.iksnae.skinny.states
{
	
	import com.iksnae.skinny.levels.TestLevel;
	import com.iksnae.skinny.players.TestPlayer;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import net.pixelpracht.tmx.TmxMap;
	import net.pixelpracht.tmx.TmxObject;
	import net.pixelpracht.tmx.TmxObjectGroup;
	
	import org.flixel.*;
	
	public class MultiRoomState extends FlxState
	{
		[Embed(source="data/sky.png")] static public var SkyImage:Class;
		[Embed(source="data/hollywood.png")] static public var HollywoodImage:Class;
		
		[Embed(source="data/coin.png")] static public var CoinImage:Class;
		[Embed(source="data/coins.png")] static public var ImgCoins:Class;
		[Embed(source="data/gold.png")] static public var ImgGold:Class;
		[Embed(source="data/mario/Coin.mp3")] static public var pickupSnd:Class;
		[Embed(source="data/mario/jump.mp3")] static public var jumpSnd:Class;
		[Embed(source="data/mario/win.mp3")] static public var winSnd:Class;
//		[Embed(source="data/mario/smb-underground.mp3")] static public var loopSnd:Class;
		[Embed(source="data/mario/pipe.mp3")] static public var transferSnd:Class;
		
		
		
		
		public static const ROOM1:String = 'data/room1.tmx';
		public static const ROOM2:String = 'data/room2.tmx';
		public static const ROOM3:String = 'data/room3.tmx';
		
		
		public var room1:FlxTilemap;
		public var room2:FlxTilemap;
		
		
		
		public var player:FlxSprite;
		public var level:FlxTilemap;
		public var coinMap:FlxTilemap;
		
		public var coins1:FlxGroup;
		public var coins2:FlxGroup;
		public var coins3:FlxGroup;
		public var levelData:Array;
		
		
		
		private var _currentLevel:int=0;
		private var _spawPoints:Array;
		private var _exitsPoints:Array;
		private var _exits:FlxGroup;
		private var _coins:Array;
		
		
		
		private var _totalCoins:int
		
		public function MultiRoomState()
		{
			super();
			
		}
		override public function create():void
		{
			
			getMap(ROOM1);
			
		}
		private function loadTmxFile():void
		{
			trace('loading tmx file...')
			var loader:URLLoader = new URLLoader(); 
			loader.addEventListener(Event.COMPLETE, onTmxLoaded); 
			loader.load(new URLRequest('data/map4.tmx')); 
			
			
		}
		private function getMap(url:String):void
		{
			trace('getting tmx map...')
			var loader:URLLoader = new URLLoader(); 
			loader.addEventListener(Event.COMPLETE, onTmxLoaded); 
			loader.load(new URLRequest(url)); 
		}
		private function onTmxLoaded(e:Event):void
		{
			trace('tmx file loaded...')
			var xml:XML = new XML(e.target.data);
			var tmx:TmxMap = new TmxMap(xml);
			loadStateFromTmx(tmx);
		}
		
		private function loadStateFromTmx(tmx:TmxMap):void
		{			
			trace('converting tmx file to map...');
			//Background
			FlxState.bgColor = 0xFF0072FF;
			
			
			//Basic level structure
			level = new FlxTilemap();
			//generate a CSV from the layer 'map' with all the tiles from the TileSet 'tiles'
			var r1:String = tmx.getLayer('room1').toCsv(tmx.getTileSet('autotiles'));
			var r2:String = tmx.getLayer('room2').toCsv(tmx.getTileSet('autotiles'));
			room1 = new FlxTilemap();
			room2 = new FlxTilemap();
			
			room1.loadMap(r1,FlxTilemap.ImgAuto);
			room2.loadMap(r2,FlxTilemap.ImgAuto);
			add(room1);
			
			
			trace('parsed tmx file:'+level)
			
			
			player = new TestPlayer(FlxG.width*.5,0);
			add(player);
			
			trace('game started.');
			FlxG.play(transferSnd);
			FlxG.follow(player,3);
			FlxG.followBounds(0,0,level.width,level.height);
			
		}
		
		//creates a new coin located on the specified tile
		public function createCoin(X:uint,Y:uint):FlxSprite
		{
			return new FlxSprite(X*8+3,Y*8+2,CoinImage)//.createGraphic(16,16,0xffffff00);
		}
		
		
		public function getCoin(Coin:FlxSprite,Player:FlxSprite):void
		{
			Coin.kill();
			FlxG.play(pickupSnd)
//			score.text = "SCORE: "+(_coins[_currentLevel].countDead()*100);
//			status.text =  'collected '+_coins[_currentLevel].countDead()+'/'+_totalCoins;
			//			bgColor = (Math.random()*0xffffffff)+0xffffffff;
//			if(_coins[_currentLevel].countLiving() == 0)
//			{
//				status.text = "Find the exit.";
//				_exits[_currentLevel].exists = true;
//			}
		}
		
		override public function update():void
		{

			if(player)
			{
				player.acceleration.x = 0;

				if(FlxG.keys.LEFT)
				{
					player.acceleration.x = -player.maxVelocity.x*4;
				}
				if(FlxG.keys.RIGHT)
				{
					player.acceleration.x = player.maxVelocity.x*4;
				}
				if(FlxG.keys.SPACE && player.onFloor)
				{
					FlxG.play(jumpSnd)
					player.velocity.y = -player.maxVelocity.y/2;
				}
				super.update();
				
				//Check for player lose conditions
				if(player.y > level.height)
				{
					
					FlxG.score = 1; //sets status.text to "Aww, you died!"
					FlxG.state = new MultiRoomState();
					trace('player died.');
					return;
				}
				FlxU.overlap(_exits,player,win);
				FlxU.collide(room1,player);
//				_farImage.x = FlxG.scroll.x * -0.8; 
//				_nearImage.x = FlxG.scroll.x * -0.4; 
//			
//				
//				_farImage.y = FlxG.scroll.y * -0.8; 
//				_nearImage.y = FlxG.scroll.y * -0.4; 
			}
		}
		public function win(Exit:FlxSprite,Player:FlxSprite):void
		{
			
			_currentLevel++;
			player.x = _spawPoints[_currentLevel].x;
			player.y = _spawPoints[_currentLevel].y;
			
			
		}
		
	}
}