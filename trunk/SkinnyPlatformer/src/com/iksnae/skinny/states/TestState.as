package com.iksnae.skinny.states
{
	import com.iksnae.skinny.levels.TestLevel;
	import com.iksnae.skinny.players.TestPlayer;
	
	import org.flixel.*;

	
	public class TestState extends FlxState
	{
		
		///  player character
		public var player:FlxSprite;
		public var level:FlxTilemap;
		public var coins:FlxGroup;
		public var levelData:Array;
		public var status:FlxText;
		public var score:FlxText;
		
		
		public function TestState()
		{
			super();
		}
		override public function create():void
		{
			bgColor = 0xff000000;
			
			level = new FlxTilemap();
			level.auto = FlxTilemap.AUTO;
			level.loadMap(FlxTilemap.arrayToCSV(TestLevel.data, TestLevel.width),FlxTilemap.ImgAuto);
			add(level);
			
			coins = new FlxGroup();
			//Top left coins
			coins.add(createCoin(18,4));
			coins.add(createCoin(12,4));
			coins.add(createCoin(9,4));
			coins.add(createCoin(8,11));
			coins.add(createCoin(1,7));
			coins.add(createCoin(3,4));
			coins.add(createCoin(5,2));
			coins.add(createCoin(15,11));
			coins.add(createCoin(16,11));
			
			//Bottom left coins
			coins.add(createCoin(3,16));
			coins.add(createCoin(4,16));
			coins.add(createCoin(1,23));
			coins.add(createCoin(2,23));
			coins.add(createCoin(3,23));
			coins.add(createCoin(4,23));
			coins.add(createCoin(5,23));
			coins.add(createCoin(12,26));
			coins.add(createCoin(13,26));
			coins.add(createCoin(17,20));
			coins.add(createCoin(18,20));
			
			//Top right coins
			coins.add(createCoin(21,4));
			coins.add(createCoin(26,2));
			coins.add(createCoin(29,2));
			coins.add(createCoin(31,5));
			coins.add(createCoin(34,5));
			coins.add(createCoin(36,8));
			coins.add(createCoin(33,11));
			coins.add(createCoin(31,11));
			coins.add(createCoin(29,11));
			coins.add(createCoin(27,11));
			coins.add(createCoin(25,11));
			coins.add(createCoin(36,14));
			
			//Bottom right coins
			coins.add(createCoin(38,17));
			coins.add(createCoin(33,17));
			coins.add(createCoin(28,19));
			coins.add(createCoin(25,20));
			coins.add(createCoin(18,26));
			coins.add(createCoin(22,26));
			coins.add(createCoin(26,26));
			coins.add(createCoin(30,26));
			
			add(coins);
			
			
			
			player = new TestPlayer((FlxG.width*.5)-5);
			add(player);

			
			score = new FlxText(2,2,80);
			score.shadow = 0xff000000;
			score.scrollFactor.x = score.scrollFactor.y = 0;
			score.text = "SCORE: "+(coins.countDead()*100);
			add(score);
			
			status = new FlxText(FlxG.width-160-2,2,160);
			status.shadow = 0xff000000;
			status.alignment = "right";
			
			FlxG.follow(player,10);
//			FlxG.followBounds(0,0,2000,level.height); //the hard way
			
			
		}
		//creates a new coin located on the specified tile
		public function createCoin(X:uint,Y:uint):FlxSprite
		{
			return new FlxSprite(X*8+3,Y*8+2).createGraphic(2,4,0xffffff00);
		}
		public function getCoin(Coin:FlxSprite,Player:FlxSprite):void
		{
			Coin.kill();
			score.text = "SCORE: "+(coins.countDead()*100);
//			bgColor = (Math.random()*0xffffffff)+0xffffffff;
			if(coins.countLiving() == 0)
			{
				status.text = "Find the exit.";
//				exit.exists = true;
			}
		}
		override public function update():void
		{
			player.acceleration.x = 0;
			player.acceleration.x = 0;
			if(FlxG.keys.LEFT)
				player.acceleration.x = -player.maxVelocity.x*4;
			if(FlxG.keys.RIGHT)
				player.acceleration.x = player.maxVelocity.x*4;
			if(FlxG.keys.SPACE && player.onFloor)
				player.velocity.y = -player.maxVelocity.y/2;
			
			super.update();
			
			//Check for player lose conditions
			if(player.y > FlxG.height)
			{
				FlxG.score = 1; //sets status.text to "Aww, you died!"
				FlxG.state = new TestState();
				return;
			}
			FlxU.overlap(coins,player,getCoin);
			FlxU.collide(level,player);
		}
	}
}