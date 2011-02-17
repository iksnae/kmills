package com.iksnae.skinny.levels
{
	import com.iksnae.skinny.items.Background;
	import com.iksnae.skinny.items.Door;
	import com.iksnae.skinny.items.Pickup;
	import com.iksnae.skinny.items.Spawn;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import net.pixelpracht.tmx.TmxLayer;
	import net.pixelpracht.tmx.TmxMap;
	import net.pixelpracht.tmx.TmxObject;
	import net.pixelpracht.tmx.TmxObjectGroup;
	
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;

	/**
	 * 
	 * @author iksnae
	 * 
	 */	
	public class LevelGroup extends FlxGroup
	{
		public var name			:String;
		
		public var start		:Point;
		
		
		public var walls		:FlxTilemap;
		public var pickups		:FlxGroup;
		public var doors		:FlxGroup;
		public var spawns		:FlxGroup;
		
		public var bgFar		:FlxSprite;
		public var bgNear		:FlxSprite;
		
		private const WALL		:String = 'wall';
		private const PICKUP	:String = 'pickup';
		private const DOOR		:String = 'door';
		private const SPAWN		:String = 'spawn';
		
		private var _wallsList	:Dictionary;
		private var _pickupsList:Dictionary;
		private var _doorsList	:Dictionary;
		private var _spawnsList	:Dictionary;
		
		
		public function LevelGroup(name:String,tmx:TmxMap)
		{
			super();
			this.name = name;
			var lvl:TmxLayer = tmx.layers[name];
			
			// create lists
			_wallsList 		= new Dictionary();
			_pickupsList 	= new Dictionary();
			_doorsList 		= new Dictionary();
			_spawnsList		= new Dictionary();
			
			
			
			// create groups
			walls 	= new FlxTilemap();
			pickups = new FlxGroup();
			doors 	= new FlxGroup();
			spawns 	= new FlxGroup();
			bgNear 	= new FlxSprite();
			bgFar 	= new FlxSprite();
			
			var bgF:Class =Background[lvl.properties['bgFar']];
			var bgN:Class =Background[lvl.properties['bgNear']];
			
			bgFar.loadGraphic(bgF);
			bgNear.loadGraphic(bgN);
			
			// add groups to display
			
			add(bgFar);
			add(bgNear);
			
			
			add(walls);
			add(doors);
			add(pickups);
			add(spawns);
			
			var wallsCsv:String = tmx.getLayer(name).toCsv(tmx.getTileSet('autotiles'));
			var pickupsCsv:TmxObjectGroup = tmx.getObjectGroup(name+'_pickups');
			var doorsCsv:TmxObjectGroup = tmx.getObjectGroup(name+'_doors');
			var spawnsCsv:TmxObjectGroup = tmx.getObjectGroup(name+'_spawns');
			addWalls(wallsCsv);
			addPickups(pickupsCsv);
			addDoors(doorsCsv);
			addSpawns(spawnsCsv);
			
		}
		
		public function addPickups(tmxGrp:TmxObjectGroup):void
		{
			trace(tmxGrp.objects.length+' pickups found in '+name+' map.')
			for each (var obj:TmxObject in tmxGrp.objects)
			{
//				trace('add pickup: '+obj.name+' @'+obj.x+','+obj.y)
				var pickup:Pickup = new Pickup(obj.x,obj.y,obj.type);
				_pickupsList[obj.name] =pickup;
				pickups.add(pickup);
			}
		}
		public function addDoors(tmxGrp:TmxObjectGroup):void
		{
			trace(tmxGrp.objects.length+' doors found in '+name+' map.')
			for each (var obj:TmxObject in tmxGrp.objects)
			{
//				trace('add door: '+obj.name+' @'+obj.x+','+obj.y)
				var door:Door = new Door(obj.x,obj.y);
				door.destination = obj.custom['destination'];
				door.spawn = obj.custom['spawn'];
				_pickupsList[obj.name] = door;
				doors.add(door);
			}
		}
		public function addWalls(csvStr:String):void
		{
			walls.loadMap(csvStr,Background.Jail);
		}
		public function addSpawns(tmxGrp:TmxObjectGroup):void
		{
			trace(tmxGrp.objects.length+' spawns found in '+name+' map.')
			for each (var obj:TmxObject in tmxGrp.objects)
			{
//				trace('add spawn: '+obj.name+' @'+obj.x+','+obj.y)
				var spawn:Spawn = new Spawn(obj.x,obj.y);
				_spawnsList[obj.name] = spawn;
				spawns.add(spawn);
			}
		}
		
		public function getDoor(name:String):Door
		{
			return _doorsList[name]
		}
		public function getPickup(name:String):Pickup
		{
			return _pickupsList[name]
		}
		public function getSpawn(name:String):Spawn
		{
			return _spawnsList[name]
		}
		
		private function parse(csv:String,group:*):void
		{
			switch(group)
			{
				case walls:
					// parse and place level walls
//					walls.loadMap(csv,FlxTilemap.ImgAuto);
					addWalls(csv);
					break;
				case pickups:
					// parse and place pickup items
					break;
				case doors:
					// parse and place level doors
					break;
				
			}
		}
	}
}