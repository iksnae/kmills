package com.gabe.view.mediator
{
	import com.gabe.control.event.GabeShuEvent;
	import com.gabe.model.proxy.AppDataProxy;
	import com.gabe.view.component.ContactView;
	import com.greensock.TweenMax;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ContactViewMediator extends Mediator
	{
		
		static public const NAME:String = "ContactViewMediator";
		
		private var _appDataProxy:AppDataProxy;
		
		public function ContactViewMediator(viewComponent:ContactView)
		{
			super(NAME, viewComponent);
		}
		private function get view():ContactView
		{
			return viewComponent as ContactView
		}
		//////////////////////////////////////////////////////////////////////////
		//	IMPLEMENTATIONS														//
		//////////////////////////////////////////////////////////////////////////
		override public function listNotificationInterests():Array
		{
			return [
				GabeShuEvent.SECTION_CHANGE,
				GabeShuEvent.CONTACTS_LOADED
				
			];
		}
		override public function handleNotification(notification:INotification):void
		{
			
			switch(notification.getName())
			{
				case GabeShuEvent.SECTION_CHANGE:
					if(notification.getBody() == "contact")
					{
						view.show();
						
					}
					else if(view.visible)
					{
						view.hide();
					}
					break;
				case GabeShuEvent.CONTACTS_LOADED:
					_appDataProxy = facade.retrieveProxy(AppDataProxy.NAME) as AppDataProxy;
					view.populate(_appDataProxy.contact);
					
					
					break;
			
			}
		}
	}
}