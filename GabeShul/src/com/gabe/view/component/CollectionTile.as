package com.gabe.view.component
{
	import com.gabe.model.vo.CollectionItem;
	import com.greensock.TweenMax;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	public class CollectionTile extends Sprite
	{
		static public const DEFAULTSIZE:Number = 180;
		
		private var _thumbHolder:Loader;
		private var _data:CollectionItem;
		
		public function CollectionTile(vo:CollectionItem)
		{
			super();
			_data = vo;
			_thumbHolder = new Loader();
			graphics.beginFill(0x999999,0);
			graphics.drawRect(0,0,DEFAULTSIZE,DEFAULTSIZE);
			graphics.endFill();
			buttonMode = true;
			_thumbHolder.contentLoaderInfo.addEventListener(Event.COMPLETE,onThumbLoaded);
			_thumbHolder.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			
			if(_data.thumbImage)
			_thumbHolder.load(new URLRequest(_data.thumbImage));
			addChild(_thumbHolder);
			
			addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			
			
		}
		private function overHandler(e:MouseEvent):void
		{
			TweenMax.to(this,0.5,{alpha:.6});
		}
		private function outHandler(e:MouseEvent):void
		{
			TweenMax.to(this,1.0,{alpha:1});
		}
		
		private function onThumbLoaded(e:Event):void
		{
//			Debug.log('onThumbLoaded');
			_thumbHolder.x = 60-(_thumbHolder.width*.5);
			_thumbHolder.y = 60-(_thumbHolder.height*.5);
		}
		private function onIOError(e:IOErrorEvent):void
		{
			Debug.log('!Thumbnail Failed to Load: '+_data.thumbImage+'!!');
		}

		public function get data():CollectionItem
		{
			return _data;
		}

			
	}
}