package com.gabe.view.component.cart
{
	import com.gabe.model.vo.CollectionItem;
	
	import flash.display.Sprite;
	
	public class CartList extends Sprite
	{
		private var _background:Sprite;
		private var _holder:Sprite;
		
		public function CartList()
		{
			super();
			_background = new Sprite();
			_background.graphics.beginFill(0xffffff);
			_background.graphics.drawRect(0,0,440,285);
			_background.graphics.endFill();
			addChild(_background);
			
			_holder = new Sprite();
			_holder.x = _holder.y = 10;
			addChild(_holder);
			
		}
		public function clear():void
		{
			while(_holder.numChildren>0)
			{
				_holder.removeChildAt(0);
			}
		}
		public function populate(arr:Array):void
		{
			var i:int=0;
			for each( var item:CollectionItem in arr)
			{
				var v:CartItemView = new CartItemView(item);
				v.y = i*35;
				_holder.addChild(v);
				i++;
			}
		}
	}
}