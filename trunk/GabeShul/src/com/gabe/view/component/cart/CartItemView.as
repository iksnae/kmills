package com.gabe.view.component.cart
{
	import com.gabe.control.event.GabeShuEvent;
	import com.gabe.model.data.Theme;
	import com.gabe.model.vo.CollectionItem;
	import com.gabe.view.component.NavigationButtonView;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class CartItemView extends Sprite
	{
		private var _data:CollectionItem;
		
		public var removeButton		:NavigationButtonView;
		public var thumbLoader		:Loader;
		public var titleText		:TextField;
		public var descriptionText	:TextField;
		public var priceText		:TextField;
		
		private var _font:NavFont = new NavFont();
		private var _style1:TextFormat;
		
		
		public function CartItemView(data:CollectionItem)
		{
			super();
			_data = data;
			titleText 		= new TextField();
			descriptionText = new TextField();
			priceText 		= new TextField();
			removeButton 	= new NavigationButtonView('remove');
			
			_style1 = Theme.CartItemViewLabelStyle;//new TextFormat('Arial',12);
			
			titleText.defaultTextFormat 		= _style1;
			descriptionText.defaultTextFormat 	= _style1;
			priceText.defaultTextFormat 		= _style1;
			
			
			titleText.width = 200;
			titleText.height = 25;
			titleText.mouseEnabled = titleText.selectable = false;
			
			priceText.mouseEnabled = priceText.selectable = false;
			
			removeButton.addEventListener(MouseEvent.CLICK,onRemove);
			removeButton.borderSize = 5;
			removeButton.bgAlpha = 1;
//			removeButton.overBgColor = Theme.WHITE;
//			removeButton.outBgColor = Theme.BLACK;
			removeButton.drawBackground();
			removeButton.enabled = true;
//			removeButton.outStyle = Theme.FooterStyleWhite;
//			removeButton.overStyle = Theme.FooterStyleBlack;
			
			descriptionText.y = 20;
			removeButton.x = 325;
			priceText.x = 280;
			removeButton.x = 350;
			
			titleText.text = _data.title;
			descriptionText.text = _data.style;
			priceText.text = '$'+_data.price;
			
			addChild(titleText);
			addChild(descriptionText);
			addChild(priceText);
			addChild(removeButton);
			
		}
		private function onRemove(e:MouseEvent):void
		{
			GabeShuFacade.getInstance().sendNotification(GabeShuEvent.CART_REMOVE_ITEM,_data);
		}
	
		
	}
}