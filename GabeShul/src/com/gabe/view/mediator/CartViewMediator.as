package com.gabe.view.mediator
{

	
	import com.gabe.control.event.GabeShuEvent;
	import com.gabe.model.proxy.AppDataProxy;
	import com.gabe.model.vo.CollectionItem;
	import com.gabe.util.AlignUtil;
	import com.gabe.view.component.cart.CartView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	import org.casalib.util.ArrayUtil;
	import org.casalib.util.NumberUtil;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class CartViewMediator extends Mediator
	{
		public const PAYPAL_URL:String ="https://www.paypal.com/webscr";
		public const CHECKOUT:String = "https://checkout.google.com/api/checkout/v2/checkoutForm/Merchant/276581971523332";
		private var _cartData:Vector.<CollectionItem>;
		private var _items:Array = new Array();
//		private var _selectedProduct:ProductVO;
//		private var _selectedIndex:int;
		private var _loader:URLLoader;
		private var _request:URLRequest;
		private var _header:URLRequestHeader;
		private var _variables:URLVariables
		private var _urlVarString:String = '';
		
		public var totalCartItems:int=0;
	
		
		
		static public const NAME:String = "CartViewMediator"
		public function CartViewMediator(viewComponent:CartView)
		{
			super(NAME, viewComponent);
			
			
			view.checkoutButton.addEventListener(MouseEvent.CLICK,clickHandler);
			view.closeButton.addEventListener(MouseEvent.CLICK,clickHandler);
		
			view.visible = false;
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE,onComplete);
			
			_request = new URLRequest(PAYPAL_URL);
//			_request.method = URLRequestMethod.POST;
			_variables = new URLVariables();
//			update();
		}
		public function addItemToCart(vo:CollectionItem):void
		{
			if(!ArrayUtil.contains(_items,vo))
			{
				// new cart item...
				trace('add new cart item: '+vo.title);
				_items.push(vo);
			}
			else
			{
				// add to cart item..
				trace('already in cart: '+vo.title);
			
			}
			update();
		}
		
		private function update():void
		{
			var cost:Number = 0.0;
			var ship:Number = 0.0;
			var total:Number;
			totalCartItems = 0;
			for each (var vo:CollectionItem in _items)
			{
				cost += vo.price;
				
			}
			totalCartItems = _items.length;
			total = cost+ship;
//			view.subtotal_txt.text 	= "$"+NumberUtil.roundDecimalToPlace(cost,2);
//			view.shipping_txt.text 	= "$"+NumberUtil.roundDecimalToPlace(ship,2);
			view.totalText.text 	= "$"+NumberUtil.roundDecimalToPlace(total,2);
//			view.taxes_txt.text 	= "$"+NumberUtil.roundDecimalToPlace(total*.0865,2);
			
//			view.cart_list.dataProvider = _cartData;
//			view.cart_list.selectedIndex = _selectedIndex;
			
			view.closeButton.addEventListener(MouseEvent.CLICK,clickHandler);
			view.list.clear();
			view.list.populate(_items);
			sendNotification(GabeShuEvent.CART_UPDATED,_items);
		}
		private function clickHandler(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case view.checkoutButton:
					checkout();
					break;
				case view.closeButton:
					Debug.log('close cart');
					view.visible=false;
					break;

			}
		}
		public function checkout():void
		{
			var cartString:String;
			var items:int = 1;
			_variables = new URLVariables();
			_variables['cmd'] = '_cart';
			_variables['upload'] = '1';
			
			_variables['business'] = 'shop@gabrieljshuldiner.com';
//			_variables['bn']='ShoppingCart';
				
//			_variables['tax'];
			_urlVarString = PAYPAL_URL+'?cmd=_cart&upload=1&business=shop%40gabrieljshuldiner%2ecom&bn=ShoppingCart'
			for(var i:uint=0; i<_items.length;i++)
			{
				
				var product:CollectionItem = _items[i];
				var itemNum:String = items.toString();
				_urlVarString += "&item_name_"+itemNum+'='+product.title;
				_urlVarString += "&item_number_"+itemNum+'='+product.productID;
				_urlVarString += "&amount_"+itemNum+'='+product.price;
				_urlVarString += "&quantity_"+itemNum+'=1';
				
				_variables["item_name_"+itemNum] 	= product.title;
				_variables["item_number_"+itemNum] 	= product.productID;
				_variables["amount_"+itemNum ] 		= product.price;
				_variables["quantity_"+itemNum ] 	= "1";
				
//				_variables["shipping_"+itemNum ]  = product.productShipping;
//				_variables["tax_"+itemNum]		= product.productTax;
				items++
				
			}
			_urlVarString += '&display=1';
			_urlVarString += '&paymentaction=sale';
			_urlVarString += '&AMT=10.00';
			
			trace(_urlVarString)
			_request.data = _variables;
//			_loader.load(_request);
			navigateToURL(_request);
//			navigateToURL(new URLRequest(_urlVarString))
			
		}
		private function onComplete(e:Event):void
		{
			trace(_loader.data)
		}
		private function removeItemFromCart(vo:CollectionItem):void
		{
			Debug.log('remove: '+vo.title);
			ArrayUtil.removeItem(_items, vo);
			update();
		}
		private function clearSelectedItem():void
		{
//			view.name_txt.text='';
//			view.quantity_txt.text='';
//			view.thumbnail_loader.unload();
//			view.checkoutButton.enabled=false;
//			view.remove_btn.enabled=false;
		}
		private function get view():CartView
		{
			return viewComponent as CartView
		}
		private function get appDataProxy():AppDataProxy
		{
			return facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
		}
		private function handleSectionChange(str:String):void
		{
			
		}
		override public function listNotificationInterests():Array
		{
			return [GabeShuEvent.SECTION_CHANGE,GabeShuEvent.CART_REMOVE_ITEM,GabeShuEvent.CART_ADD_ITEM,GabeShuEvent.SHOW_CART,GabeShuEvent.STAGE_RESIZE];
		}
		override public function handleNotification(notification:INotification):void
		{
			
			switch(notification.getName())
			{
				
				case GabeShuEvent.CART_ADD_ITEM:
					addItemToCart(notification.getBody() as CollectionItem);
					break;
				case GabeShuEvent.CART_REMOVE_ITEM:
					removeItemFromCart(notification.getBody() as CollectionItem);
					break;
				case GabeShuEvent.SHOW_CART:
					view.visible = true;
					break;
				case GabeShuEvent.STAGE_RESIZE:
					AlignUtil.alignCenterX(view);
					break;
				case GabeShuEvent.SECTION_CHANGE:
					if(notification.getBody() == "cart")
					{
						view.show();
						
					}
					else if(view.visible)
					{
						view.hide();
					}
					break;
				
			}
		}
	}
}