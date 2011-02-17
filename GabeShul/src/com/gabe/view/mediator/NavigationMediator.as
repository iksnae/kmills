package com.gabe.view.mediator
{
	import com.gabe.control.event.GabeShuEvent;
	import com.gabe.model.data.Theme;
	import com.gabe.view.component.NavigationButtonView;
	import com.gabe.view.component.NavigationView;
	import com.greensock.TweenMax;
	
	import flash.events.MouseEvent;
	
	import org.casalib.transitions.Tween;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class NavigationMediator extends Mediator
	{
		//////////////////////////////////////////////////////////////////////////
		//	IMPLEMENTATIONS														//
		//////////////////////////////////////////////////////////////////////////
		static public const NAME:String = "NavigationMediator";
		
		//////////////////////////////////////////////////////////////////////////
		//	PRIVATE PROPERTIES													//
		//////////////////////////////////////////////////////////////////////////
		private var _app:GabeShul;
		
		
		public function NavigationMediator( viewComponent:NavigationView)
		{
			super(NAME, viewComponent);
			_app = GabeShuFacade.getInstance().app;
			init()
		}
		//////////////////////////////////////////////////////////////////////////
		//	PUBLIC FUNCTIONS													//
		//////////////////////////////////////////////////////////////////////////
		public function get view():NavigationView
		{
			return viewComponent as NavigationView;
		}
		//////////////////////////////////////////////////////////////////////////
		//	PRIVATE FUNCTIONS													//
		//////////////////////////////////////////////////////////////////////////
		private function init():void
		{
			view.about_btn.addEventListener(MouseEvent.CLICK,clickHandler);
			view.collections_btn.addEventListener(MouseEvent.CLICK,clickHandler);
			view.lookbook_btn.addEventListener(MouseEvent.CLICK,clickHandler);
			view.press_btn.addEventListener(MouseEvent.CLICK,clickHandler);
			view.stockists_btn.addEventListener(MouseEvent.CLICK,clickHandler);
			view.links_btn.addEventListener(MouseEvent.CLICK,clickHandler);
			view.blog_btn.addEventListener(MouseEvent.CLICK,clickHandler);
			view.art_btn.addEventListener(MouseEvent.CLICK,clickHandler);
			view.contact_btn.addEventListener(MouseEvent.CLICK,clickHandler);
			view.cartButton.addEventListener(MouseEvent.CLICK,clickHandler);
			
			
		}
		private function clickHandler(e:MouseEvent):void
		{
			
			switch(e.currentTarget)
			{
				case view.contact_btn:
					sendNotification(GabeShuEvent.CHANGE_SECTION,'contact');
					break;
				case view.collections_btn:
					sendNotification(GabeShuEvent.CHANGE_SECTION,'collections');
					break;
				case view.cartButton:
					sendNotification(GabeShuEvent.CHANGE_SECTION,'cart');
					break;
				/*
				case view.about_btn:
					sendNotification(GabeShuEvent.CHANGE_SECTION,'about');
					break;
				case view.lookbook_btn:
					sendNotification(GabeShuEvent.CHANGE_SECTION,'lookbook');
					break;
				case view.press_btn:
					sendNotification(GabeShuEvent.CHANGE_SECTION,'press');
					break;
				case view.stockists_btn:
					sendNotification(GabeShuEvent.CHANGE_SECTION,'stocklists');
					break;
				case view.links_btn:
					sendNotification(GabeShuEvent.CHANGE_SECTION,'links');
					break;
				case view.blog_btn:
					sendNotification(GabeShuEvent.CHANGE_SECTION,'blog');
					break;
				case view.art_btn:
					sendNotification(GabeShuEvent.CHANGE_SECTION,'art');
					break;
				
				
				*/
				
			}
		}
		private function handleSectionChange(str:String):void
		{
			TweenMax.to(view,0,{alpha:0});
			TweenMax.to(view,1,{alpha:1,delay:2});
			
			for each(var btn:NavigationButtonView in view.buttons)
			{
				if(btn.label.toLowerCase()==str)
				{
					view.selectButton(btn);
				}
				else
				{
					view.deselectButton(btn);
				}
			}
		}
		
		//////////////////////////////////////////////////////////////////////////
		//	IMPLEMENTATIONS														//
		//////////////////////////////////////////////////////////////////////////
		override public function listNotificationInterests():Array
		{
			return [GabeShuEvent.THEME_CHANGE,GabeShuEvent.SECTION_CHANGE,GabeShuEvent.CART_UPDATED];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case GabeShuEvent.THEME_CHANGE:
					view.changeStyle(notification.getBody() as int);
					break;
				case GabeShuEvent.SECTION_CHANGE:
					
					handleSectionChange(notification.getBody() as String)
					break;
				case GabeShuEvent.CART_UPDATED:
					var items:Array = notification.getBody() as Array;
					if(items.length>0)
						view.cartButton.label = 'cart('+items.length+')';
					else
						view.cartButton.label = 'cart';
						
					break;
			}
		}
	}
}