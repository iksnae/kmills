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
	
	public class TMXState extends FlxState
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
		
		
		public var player:FlxSprite;
		public var exit:FlxSprite;
		public var level:FlxTilemap;
		public var coinMap:FlxTilemap;
		
		public var coins:FlxGroup;
		public var levelData:Array;
		public var status:FlxText;
		public var score:FlxText;
		
		private var _farLayer:FlxGroup;
		private var _nearLayer:FlxGroup;
		private var _nearImage:FlxSprite;
		private var _farImage:FlxSprite;
		
		
		
		private var _totalCoins:int
		
		public function TMXState()
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
			trace('converting tmx file to map...')
			//Background
			FlxState.bgColor = 0xFF0072FF;
			
			
			//Basic level structure
			level = new FlxTilemap();
			//generate a CSV from the layer 'map' with all the tiles from the TileSet 'tiles'
			var mapCsv:String = tmx.getLayer('map').toCsv(tmx.getTileSet('autotiles'));
			
			coins = new FlxGroup();
			var cg:TmxObjectGroup = tmx.getObjectGroup('coins');
			_totalCoins = cg.objects.length;
			trace(cg.objects.length+' coins found in map.')
			for each (var obj:TmxObject in cg.objects)
			{
				trace('add coin: '+obj.x+','+obj.y)
				coins.add(createCoin(obj.x/8,obj.y/8));
			}
			
			level.loadMap(mapCsv,FlxTilemap.ImgAuto);
			add(level);
			
			var ex:TmxObjectGroup = tmx.getObjectGroup('exit');
			var exObj:TmxObject = ex.objects[0];
			exit = new FlxSprite(exObj.x,exObj.y);
			exit.createGraphic(16,16,0xffff0000);
			exit.exists = false;
			add(exit);
			
			trace('parsed tmx file:'+level)
			
			
			add(coins);
			
			
			
			player = new TestPlayer((FlxG.width*.5)-5,0);
			add(player);
			
			
			score = new FlxText(2,2,80);
			score.shadow = 0xff000000;
			score.scrollFactor.x = score.scrollFactor.y = 0;
			score.text = "SCORE: "+(coins.countDead()*100);
			add(score);
			
			status = new FlxText(FlxG.width-160-2,2,160,'collect the coins.');
			status.scrollFactor.x = status.scrollFactor.y = 0;
			status.shadow = 0xff000000;
			status.alignment = "right";
			add(status);
			
			
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
			score.text = "SCORE: "+(coins.countDead()*100);
			status.text =  'collected '+coins.countDead()+'/'+_totalCoins;
			//			bgColor = (Math.random()*0xffffffff)+0xffffffff;
			if(coins.countLiving() == 0)
			{
				status.text = "Find the exit.";
				exit.exists = true;
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
				if(player.y > level.height)
				{
					
					FlxG.score = 1; //sets status.text to "Aww, you died!"
					FlxG.state = new TMXState();
					return;
				}
				FlxU.overlap(coins,player,getCoin);
				FlxU.overlap(exit,player,win);
				FlxU.collide(level,player);
				_farImage.x = FlxG.scroll.x * -0.8; 
//				_nearImage.x = FlxG.scroll.x * -0.4; 
			
				
				_farImage.y = FlxG.scroll.y * -0.8; 
//				_nearImage.y = FlxG.scroll.y * -0.4; 
		
				//				trace('player:'+player.x+','+player.y)
			}
		}
		public function win(Exit:FlxSprite,Player:FlxSprite):void
		{
			
			FlxG.play(winSnd);
			status.text = "Yay, you won!";
			
			Player.kill();
		}
		
	}
}