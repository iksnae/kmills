package com.iksnae.skinny.states
{
	
	import com.ashylarry.characters.PlayerCharacter;
	import com.iksnae.skinny.levels.TestLevel;
	import com.iksnae.skinny.players.TestPlayer;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import net.pixelpracht.tmx.TmxMap;
	import net.pixelpracht.tmx.TmxObject;
	import net.pixelpracht.tmx.TmxObjectGroup;
	
	import org.flixel.*;
	
	public class MultiLevelState extends FlxState
	{
		public static const HOURS:uint = 2;
		public static const MINUTES:uint = 1;
		public static const SECONDS:uint = 0;
		
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
		
		
		public var player:FlxSprite;
		public var level:FlxTilemap;
		public var coinMap:FlxTilemap;
		
		public var coins1:FlxGroup;
		public var coins2:FlxGroup;
		public var coins3:FlxGroup;
		public var levelData:Array;
		public var status:FlxText;
		public var score:FlxText;
		
		private var _farLayer:FlxGroup;
		private var _nearLayer:FlxGroup;
		private var _nearImage:FlxSprite;
		private var _farImage:FlxSprite;
		
		private var _currentLevel:int=0;
		private var _spawPoints:Array;
		private var _exitList:Array;
		private var _exitsPoints:Array;
		private var _exits:FlxGroup;
		private var _coins:Array;
		private var _timerDisplays:Array;
		private var _ticker:Number = 0;
		private var time1:FlxText;
		private var time2:FlxText;
		private var time3:FlxText;
		private var time4:FlxText;
		
		
		private var _gameTimer:Timer = new Timer(1000);
		
		
		
		private var _totalCoins:int
		
		public function MultiLevelState()
		{
			super();
			_farLayer = new FlxGroup();
			_nearLayer= new FlxGroup();
			_nearImage = new FlxSprite(0,0,HollywoodImage);
			_farImage = new FlxSprite(0,0,SkyImage)
			_farLayer.add(_farImage);
			_nearLayer.add(_nearImage);
			
//			add(_farLayer);
//			add(_nearLayer);
			
			
			_gameTimer.addEventListener(TimerEvent.TIMER,onTick);
		}
		override public function create():void
		{
			
			loadTmxFile()
			
		}
		private function loadTmxFile():void
		{
			trace('loading tmx file...')
			var loader:URLLoader = new URLLoader(); 
			loader.addEventListener(Event.COMPLETE, onTmxLoaded); 
			loader.load(new URLRequest('data/ashy4.tmx')); 
			
			
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
			var mapCsv:String = tmx.getLayer('map').toCsv(tmx.getTileSet('autotiles'));
			_coins = new Array();
			_exitList = new Array();
			_timerDisplays = new Array();
			coins1 = new FlxGroup();
			coins2 = new FlxGroup();
			coins3 = new FlxGroup();
			_coins.push(coins1);
			_coins.push(coins2);
			_coins.push(coins3);
			
			var c1:TmxObjectGroup = tmx.getObjectGroup('coins1');
			var c2:TmxObjectGroup = tmx.getObjectGroup('coins2');
			var c3:TmxObjectGroup = tmx.getObjectGroup('coins3');
			
//			_totalCoins = c1.objects.length;
			if(c1)
			{
				trace(c1.objects.length+' coins found in map.')
				for each (var coinObj1:TmxObject in c1.objects)
				{
					trace('add coin: '+coinObj1.x+','+coinObj1.y)
					coins1.add(createCoin(coinObj1.x/8,coinObj1.y/8));
				}
				add(coins1);
			}
			else
			{
				trace('no coins found @ 1')
			}
			
			if(c2)
			{
				for each (var coinObj2:TmxObject in c2.objects)
				{
					trace('add coin: '+coinObj1.x+','+coinObj2.y)
					coins2.add(createCoin(coinObj2.x/8,coinObj2.y/8));
				}
				add(coins2);
			}
			else
			{
				trace('no coins found @ 1')
			}
			if(c3)
			{
				for each (var coinObj3:TmxObject in c3.objects)
				{
					trace('add coin: '+coinObj3.x+','+coinObj3.y)
					coins3.add(createCoin(coinObj3.x/8,coinObj3.y/8));
		 		}
				add(coins3);
			}
			else
			{
				trace('no coins found @ 3')
			}
			level.loadMap(mapCsv,FlxTilemap.ImgAuto);
			add(level);
			
			var exitData:TmxObjectGroup = tmx.getObjectGroup('doors');
			if(exitData)
			{
			_exitsPoints= exitData.objects;
				_exits = new FlxGroup();
				for each ( var exitObj:TmxObject in _exitsPoints)
				{
					var newExit:FlxSprite = new FlxSprite(exitObj.x,exitObj.y,CoinImage);
					newExit.createGraphic(16,16,0xffff0000);
					_exitList.push(newExit);
						
					_exits.add(newExit);
					newExit.exists = false;
					
				}
				add(_exits);
			}
			else
			{
				trace('no exits found.')
			}
			
			trace('parsed tmx file:'+level)
			
			
	
			
			
			var spawnGroup:TmxObjectGroup = tmx.getObjectGroup('player');
			
			if(spawnGroup)
			{
				_spawPoints = spawnGroup.objects;
				player = new PlayerCharacter(_spawPoints[_currentLevel].x,_spawPoints[_currentLevel].y);
			}else{
				player = new PlayerCharacter(FlxG.width*.5,0);
			}
			
			
			add(player);
			
			
			score = new FlxText(2,2,80);
			score.shadow = 0xff000000;
			score.scrollFactor.x = score.scrollFactor.y = 0;
			score.text = "SCORE: "+(_coins[_currentLevel].countDead()*100);
			add(score);
			
			status = new FlxText(FlxG.width-160-2,2,160,'collect the coins.');
			status.scrollFactor.x = status.scrollFactor.y = 0;
			status.shadow = 0xff000000;
			status.alignment = "right";
			add(status);
			
			time1 = new FlxText(2,10,100,'-:--:--');
			time1.shadow = 0xff000000;
			time1.scrollFactor.x = time1.scrollFactor.y = 0;
			time1.shadow = 0xff000000;
			time2 = new FlxText(2,20,100,'-:--:--');
			time2.scrollFactor.x = time2.scrollFactor.y = 0;
			time2.shadow = 0xff000000;
			time3 = new FlxText(2,30,100,'-:--:--');
			time3.scrollFactor.x = time3.scrollFactor.y = 0;
			time3.shadow = 0xff000000;
			time4 = new FlxText(2,40,100,'-:--:--');
			time4.scrollFactor.x = time4.scrollFactor.y = 0;
			time4.shadow = 0xff000000;
			
			_timerDisplays.push(time1);
			_timerDisplays.push(time2);
			_timerDisplays.push(time3);
			_timerDisplays.push(time4);
			
			
			
			add(time1);
			add(time2);
			add(time3);
			add(time4);
			
			
			
			
			FlxG.play(transferSnd);
			FlxG.follow(player,10);
//			FlxG.followBounds(0,0,level.width,level.height);
			
			_gameTimer.start()
			
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
			score.text = "SCORE: "+(_coins[_currentLevel].countDead()*100);
			status.text =  'collected '+_coins[_currentLevel].countDead()+'/'+_totalCoins;
			//			bgColor = (Math.random()*0xffffffff)+0xffffffff;
			if(_coins[_currentLevel].countLiving() == 0)
			{
				status.text = "Find the exit.";
				_exitList[_currentLevel].exists = true;
			}
		}
		
		override public function update():void
		{
//			addAnimation("normal", [0, 1, 2, 3], 10);
//			addAnimation("jump", [2]);
//			addAnimation("attack", [4,5,6],10);
//			addAnimation("stopped", [0]);
//			addAnimation("hurt", [2,7],10);
//			addAnimation("dead", [7, 7, 7], 5);
			if(player)
			{
				player.acceleration.x = 0;
//				player.play('stopped');
				if(FlxG.keys.LEFT)
				{
//					player.play('normal');
						
					player.acceleration.x = -player.maxVelocity.x*4;
				}
				if(FlxG.keys.RIGHT)
				{
//					player.play('normal');
					player.acceleration.x = player.maxVelocity.x*4;
				}
				if(FlxG.keys.SPACE && player.onFloor)
				{
					FlxG.play(jumpSnd)
//					player.play('jump');
					player.velocity.y = -player.maxVelocity.y/2;
				}
				super.update();
				
				//Check for player lose conditions
				if(player.y > level.height*2)
				{
					
//					FlxG.score = 1; //sets status.text to "Aww, you died!"
//					FlxG.state = new MultiLevelState();
//					return;
				}
				FlxU.overlap(_coins[_currentLevel],player,getCoin);
				FlxU.overlap(_exits,player,win);
				FlxU.collide(level,player);
				_farImage.x = FlxG.scroll.x * -0.8; 
				_nearImage.x = FlxG.scroll.x * -0.4; 
			
				
				_farImage.y = FlxG.scroll.y * -0.8; 
				_nearImage.y = FlxG.scroll.y * -0.4; 
		
				//				trace('player:'+player.x+','+player.y)
			}
		}
		private function onTick(e:TimerEvent):void
		{
//			trace(_ticker)
			_ticker++;
			_timerDisplays[_currentLevel].text = formatTime(_ticker);
		}
		public static function formatTime(time:Number, detailLevel:uint = 2):String {
			var intTime:uint = Math.floor(time);
			var hours:uint = Math.floor(intTime/ 3600);
			var minutes:uint = (intTime - (hours*3600))/60;
			var seconds:uint = intTime -  (hours*3600) - (minutes * 60);
			var hourString:String = detailLevel == HOURS ? hours + ":":"";
			var minuteString:String = detailLevel >= MINUTES ? ((detailLevel == HOURS && minutes <10 ? "0":"") + minutes + ":"):"";
			var secondString:String = ((seconds < 10 && (detailLevel >= MINUTES)) ? "0":"") + seconds;
			return hourString + minuteString + secondString;
		}
		public function win(Exit:FlxSprite,Player:FlxSprite):void
		{
			
//			FlxG.play(winSnd);
			
			_ticker=0;
			_currentLevel++;
			if(_coins[_currentLevel])
			{
				status.text = "Yay, you made it!";
				FlxG.play(winSnd);
				_totalCoins = FlxGroup(_coins[_currentLevel]).members.length;
				FlxG.play(transferSnd);
				player.x = _spawPoints[_currentLevel].x;
				player.y = _spawPoints[_currentLevel].y;
			}
			else
			{
				status.text = "Yay, you won!";
				_gameTimer.stop();
				player.kill();
			}
			
			
			
//			Player.kill();
		}
		
	}
}