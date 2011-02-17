package com.gabe.view.component
{
	import com.gabe.model.vo.CollectionItem;
	import com.greensock.TweenMax;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	public class CollectionLargeTile extends Sprite
	{
		private var _image:Loader;
		private var _data:CollectionItem;
		public function CollectionLargeTile(data:CollectionItem)
		{
			super();
			_data=data;
			_image = new Loader();
			buttonMode=true
			graphics.beginFill(0xff0000,0);
			graphics.drawRect(0,0,300,320);
			graphics.endFill();
			addEventListener(MouseEvent.CLICK,clickHandler);
			addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			addEventListener(MouseEvent.ROLL_OUT,outHandler);
			_image.load(new URLRequest(_data.fullImage));
			addChild(_image);
		}
		
		private function overHandler(e:MouseEvent):void
		{
			TweenMax.to(this,1,{alpha:.6});
		}
		private function outHandler(e:MouseEvent):void
		{
			TweenMax.to(this,1,{alpha:1});
		}
		private function clickHandler(e:MouseEvent):void
		{
			
		}

		public function get data():CollectionItem
		{
			return _data;
		}

	}
}