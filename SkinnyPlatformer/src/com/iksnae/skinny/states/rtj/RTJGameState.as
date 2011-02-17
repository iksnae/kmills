package com.iksnae.skinny.states.rtj
{
	
	import com.iksnae.skinny.items.Door;
	import com.iksnae.skinny.items.Spawn;
	import com.iksnae.skinny.levels.LevelGroup;
	import com.iksnae.skinny.levels.TestLevel;
	import com.iksnae.skinny.players.RTJHero;
	import com.iksnae.skinny.players.TestPlayer;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import net.pixelpracht.tmx.TmxLayer;
	import net.pixelpracht.tmx.TmxMap;
	import net.pixelpracht.tmx.TmxObject;
	import net.pixelpracht.tmx.TmxObjectGroup;
	
	import org.flixel.*;
	
	public class RTJGameState extends FlxState
	{
//		[Embed(source="data/sky.png")] static public var SkyImage:Class;
//		[Embed(source="data/hollywood.png")] static public var HollywoodImage:Class;
//		
//		[Embed(source="data/coin.png")] static public var CoinImage:Class;
//		[Embed(source="data/coins.png")] static public var ImgCoins:Class;
//		[Embed(source="data/gold.png")] static public var ImgGold:Class;
//		[Embed(source="data/mario/Coin.mp3")] static public var pickupSnd:Class;
//		[Embed(source="data/mario/jump.mp3")] static public var jumpSnd:Class;
//		[Embed(source="data/mario/win.mp3")] static public var winSnd:Class;
////		[Embed(source="data/mario/smb-underground.mp3")] static public var loopSnd:Class;
//		[Embed(source="data/mario/pipe.mp3")] static public var transferSnd:Class;
		
		
		
		
		public static const LEVEL_PATH:String = 'data/jail.tmx';
	
		
		public var player:RTJHero;
//		public var level:FlxTilemap;
		public var coinMap:FlxTilemap;
		
		public var levelData:Array;
		
		private var _levels:Dictionary;
		
		private var _currentLevel:int=0;
		private var _currentLevelGroup:LevelGroup;
		private var _spawPoints:Array;
		private var _exitsPoints:Array;
		private var _exits:FlxGroup;
		private var _coins:Array;
		
		private var _framerate:FlxText;
		private var _herostatus:FlxText;
		
		
		
		private var _totalCoins:int
		
		public function RTJGameState()
		{
			super();
			_levels = new Dictionary();
			
			loadTmxFile();
			
		}
		override public function create():void
		{
			
//			loadTmxFile();
			
		}
		private function loadTmxFile():void
		{
			trace('loading tmx file...')
			var loader:URLLoader = new URLLoader(); 
			loader.addEventListener(Event.COMPLETE, onTmxLoaded); 
			loader.load(new URLRequest(LEVEL_PATH)); 
			
			
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
			
			for each( var layer:TmxLayer in tmx.layers)
			{
			
				var level:LevelGroup = new LevelGroup(layer.name,tmx);
				
				level.exists = false;
				_levels[layer.name]=level;
				add(level);
			}
			
			changeLevels('main');
			
			_framerate = new FlxText(0,0,100);
			_framerate.scrollFactor.x = 
			_framerate.scrollFactor.y = 0;
			add(_framerate);
			
			_herostatus = new FlxText(0,10,200,"idle.");
			_herostatus.scrollFactor.x = 
			_herostatus.scrollFactor.y = 0;
			add(_herostatus);


			
			player = new RTJHero(50,0);
			add(player);
			
			trace('game started.');
			FlxG.follow(player,10);
			FlxG.followBounds(0,0,_currentLevelGroup.walls.width,_currentLevelGroup.walls.height);
			
		}
		private function changeLevels(name:String):void
		{
			if(_currentLevelGroup)
			{
				_currentLevelGroup.exists = false
				trace('exiting level to: '+_currentLevelGroup.name);
			}
			_currentLevelGroup = _levels[name];
			_currentLevelGroup.exists = true;
			trace('changed level to: '+_currentLevelGroup.name);
		}
		//creates a new coin located on the specified tile
		public function createCoin(X:uint,Y:uint):FlxSprite
		{
			//return new FlxSprite(X*8+3,Y*8+2,CoinImage);
			return new FlxSprite(X*8+3,Y*8+2).createGraphic(16,16,0xffffff00);
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
				if(FlxG.keys.UP && player.onFloor)
				{
					_herostatus
					player.velocity.y = -player.maxVelocity.y/2;
				}
				super.update();
				
				
				//Check for player lose conditions
				if(player.y > _currentLevelGroup.height)
				{
					
//					FlxG.score = 1; //sets status.text to "Aww, you died!"
//					FlxG.state = new MultiRoomState();
//					trace('player died.');
//					return;
				}
//				FlxU.overlap(_exits,player,win);
				
//				_currentLevelGroup.walls.collide(player);
				FlxU.collide(_currentLevelGroup.walls,player);
				FlxU.overlap(_currentLevelGroup.pickups,player,getPickup);
				FlxU.overlap(_currentLevelGroup.doors,player,checkDoor);
				
				
				_framerate.text = FlxG.framerate+' fps';

				_currentLevelGroup.bgFar.x = FlxG.scroll.x * -0.8; 
				_currentLevelGroup.bgNear.x = FlxG.scroll.x * -0.4; 
			
				
				_currentLevelGroup.bgFar..y = FlxG.scroll.y * -0.8; 
//				_currentLevelGroup.bgNear.y = FlxG.scroll.y * -0.4; 
				
				_herostatus.text = player.status;
				
			}
		}
		public function getPickup(Pickup:FlxSprite,Player:FlxSprite):void
		{
			Pickup.kill()
		}
		public function checkDoor(door:Door,Player:FlxSprite):void
		{
			changeLevels(door.destination);
			var dest:Spawn = _currentLevelGroup.getSpawn(door.spawn);
			
			player.x =dest.x;
			player.y =dest.y;
			
		}
		
	}
}