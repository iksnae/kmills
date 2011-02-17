package com.gabe.view.component
{
	import com.gabe.model.vo.CollectionItem;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.casalib.util.NumberUtil;
	import org.osmf.events.TimeEvent;
	
	public class PanningCollectionView extends Sprite
	{
		static public const ITEMSELECTED:String="PanningCollectionView.ItemSelected"
		
		private var _collection:Vector.<CollectionItem>;
		private var _currentPosition:int = 0;
		private var _totalItems:int;
		private var _spacing:Number = 300;
		private var _tiles:Vector.<CollectionLargeTile>;
		private var _timer:Timer = new Timer(100);
		private var _bg:Sprite = new Sprite();
	
		
		
		public var selectedItem:CollectionLargeTile;
		
		public function PanningCollectionView()
		{
			super();
			_tiles = new Vector.<CollectionLargeTile>();
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
//			addChild(_bg);
//			_timer.start();
			x =100;
		}
		public function next():void
		{
			if(_currentPosition<_totalItems)
			{
				// move to next item
				_currentPosition++;
			}
			else
			{
				// move to first item
				_currentPosition = 0;
			}
		}
		public function previous():void
		{
			
		}
		public function populate(coll:Vector.<CollectionItem>):void
		{
			_collection = coll.reverse();
			_totalItems = _collection.length;
			initView();
		}
		
		private function initView():void
		{
			for each( var tile:CollectionItem in _collection)
			{
				var t:CollectionLargeTile = new CollectionLargeTile(tile);
				t.y = 10;
				t.addEventListener(MouseEvent.CLICK,clickHandler);
				addChild(t);
				_tiles.push(t);
			}
			redraw();
			
//			addEventListener(MouseEvent.MOUSE_OUT,stopTimer);
//			addEventListener(MouseEvent.MOUSE_MOVE,startTimer);
			
			
				
		}
		private function redraw():void
		{
			var i:int=0;
			for each(var tile:CollectionLargeTile in _tiles)
			{
				tile.x = (_spacing*i);
				trace('place '+tile+' at '+_spacing*i)
				i++;
			}
//			x=width-stage.stageWidth;
//			_bg.graphics.beginFill(0xff0000,0);
//			_bg.graphics.drawRect(0,0,-width,height);
//			_bg.graphics.endFill();
			trace('collection redrawn: '+_tiles.length)
		}
		
	
		
		private function clickHandler(e:Event):void
		{
			selectedItem = e.currentTarget as CollectionLargeTile;
		
			dispatchEvent(new Event(ITEMSELECTED));
		}
		
		private function onTimer(e:TimerEvent):void
		{
			if(visible && parent.visible)
			{
				trace('MOVE!!');
				var xspeed:Number = ((stage.mouseX-(stage.stageWidth*.5))/10)*-1;
				var min:Number = 0;
				var max:Number = width;
				
			
				
//				var inbounds:Boolean = NumberUtil.isBetween(x,min,max);
//				trace(x+":"+inbounds+'['+min+','+max+']')
//				if(x > min && x <= max)
//				{
//					trace('MOVE!!');
//					x += xspeed;
//					if(x > 0) x=0;
						
//				}	
			}
		}
	}
}