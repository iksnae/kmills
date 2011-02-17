package com.gabe.view.component.cart
{

	import com.gabe.view.component.NavigationButtonView;
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class CartView extends Sprite
	{
		
		public var checkoutButton:NavigationButtonView;
		public var closeButton:NavigationButtonView
		public var totalText:TextField;
		public var list:CartList;
		
		private var _background:Sprite;
		
		public function CartView()
		{
			super();
			init();
		}
		private function init():void
		{
			checkoutButton = new NavigationButtonView('check out');
			checkoutButton.x = 510;
			checkoutButton.y = 90;
			checkoutButton.borderSize = 10;
			checkoutButton.drawBackground()
			
			closeButton = new NavigationButtonView('x');
			closeButton.x = 475;
			closeButton.y = 15;
			closeButton.borderSize = 3;
			closeButton.drawBackground();
			
			
			totalText = new TextField();
			list = new CartList();
			list.y = 75;
			list.x = 50;
			
			
			_background = new Sprite();
			_background.graphics.beginFill(0x999999);
			_background.graphics.drawRect(0,0,540,385);
			_background.graphics.endFill();
			
	
			
//			addChild(_background);
			addChild(list);
//			addChild(closeButton);
			addChild(checkoutButton);
			
			
		}
		public function show():void
		{
			trace('show contact')
			alpha=0;
			visible=true;
			TweenMax.to(this,.5,{alpha:1,delay:3})
		}
		public function hide():void
		{
			trace('hide contact')
			TweenMax.to(this,0,{alpha:0,onComplete:onHideComplete,onCompleteParams:[this]})
		}
		private function onHideComplete(view:CartView):void
		{
			view.visible=false;
		}
	}
}