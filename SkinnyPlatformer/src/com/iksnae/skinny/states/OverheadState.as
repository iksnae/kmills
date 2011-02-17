package com.iksnae.skinny.states
{
	import com.iksnae.skinny.players.Link;
	
	import flash.events.*;
	import flash.net.*;
	
	import net.pixelpracht.tmx.*;
	
	import org.flixel.*;
	
	public class OverheadState extends FlxState
	{
		
		public var player:Link
		public var tileMap:FlxTilemap;
		public var doors:FlxGroup;
		public var pickups:FlxGroup;
		public var spawns:FlxGroup;
		
		
		
		public function OverheadState()
		{
			super();
			getTmxMap('data/room.tmx');
		}
		
		override public function update():void
		{
			if(player)
			{
				player.acceleration.x = 0;
				player.acceleration.y = 0;
				if(FlxG.keys.LEFT)
				{
					//					player.play('normal');
					player.acceleration.x = -player.maxVelocity.x*4;
					//player.facing = FlxSprite.LEFT;
					player.scale.x =  -1
				}
				if(FlxG.keys.RIGHT)
				{
					//					player.play('normal');
					player.acceleration.x = player.maxVelocity.x*4;
					//player.facing = FlxSprite.RIGHT;
					player.scale.x =  1
				}
				
				
				if(FlxG.keys.UP)
				{
					//					player.play('normal');
					player.acceleration.y = -player.maxVelocity.y*4;
				}
				if(FlxG.keys.DOWN)
				{
					//					player.play('normal');
					player.acceleration.y = player.maxVelocity.y*4;
				}
				
			}
			super.update();
//			FlxU.overlap(doors,player,onDoor);
//			FlxU.overlap(pickups,player,onPickup);
			FlxU.collide(tileMap,player);
			FlxG.followBounds(0,0,tileMap.width,tileMap.height);
		}
		private function onDoor():void
		{
			
		}
		private function onPickup():void
		{
			
		}
		private function getTmxMap(url:String):void
		{
			trace('loading tmx file...')
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
			FlxState.bgColor = 0xFF0072FF;
			
			tileMap = new FlxTilemap();
			var mapCsv	:String 		= tmx.getLayer('map').toCsv(tmx.getTileSet('autotiles'));
//			var pickups	:TmxObjectGroup = tmx.getObjectGroup('pickups');
//			var doors	:TmxObjectGroup = tmx.getObjectGroup('doors');
//			var spawns	:TmxObjectGroup = tmx.getObjectGroup('spawns');
			
			doors = parseObjects(tmx, 'doors');
			pickups = parseObjects(tmx, 'pickups');
			spawns = parseObjects(tmx, 'spawns');
			
			
			tileMap.loadMap(mapCsv,FlxTilemap.ImgAuto);			
			add(tileMap);
			add(doors);
			add(spawns);
			
			player = new Link(100,100);
//			player.createGraphic(16,16);
			
			player.maxVelocity.x = 100;
			player.maxVelocity.y = 100;
			player.drag.x = player.maxVelocity.x*4;
			player.drag.y = player.maxVelocity.y*4;
//			player.acceleration.y = 100;
//			player.acceleration.x = 100;
			add(player);
			
			FlxG.follow(player);
		}
		private function parseObjects(tmx:TmxMap, id:String ):FlxGroup
		{
			var tmxGroup:TmxObjectGroup = tmx.getObjectGroup(id); 
			var grp:FlxGroup = new FlxGroup();
			var objects:Array = tmxGroup.objects;
			for(var i:int=0;i<tmxGroup.objects.length; i++)
			{
				
				var tmxObject:TmxObject = tmxGroup.objects[i];
				var gameObject:FlxSprite = new FlxSprite(tmxObject.x,tmxObject.y);
				if(tmxObject.type == "door")
				{
					trace('adding door:'+tmxObject.name);
					gameObject.createGraphic(16,16,0xffffcc00,true);

				}
				if(tmxObject.type == "spawns")
				{
					trace('adding spawn point:'+tmxObject.name);
					gameObject.createGraphic(16,16,0xeeffcc00,true);
				}
				if(tmxObject.type == "pickups")
				{
					trace('adding pick item:'+tmxObject.name);
					gameObject.createGraphic(16,16,0xff667e00,true);
				}
				grp.add(gameObject);
//				
//				newExit.createGraphic(16,16,0xffff0000);
//				_exitList.push(newExit);
//				
//				_exits.add(newExit);
//				newExit.exists = false;
				
			}
			return grp;
		}
	}
}