package com.gabe.model.data
{
	import com.gabe.model.vo.CollectionItem;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class CartData extends EventDispatcher
	{
		
		private var _cartItems:Vector.<CollectionItem>;
		
		public function CartData(target:IEventDispatcher=null)
		{
			super(target);
			_cartItems = new Vector.<CollectionItem>();
		}
		
		public function addItem(item:CollectionItem):void
		{
			_cartItems.push(item);
		}
	}
}