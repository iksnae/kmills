package com.gabe.view.mediator
{
	import com.asual.swfaddress.SWFAddress;
	import com.gabe.control.event.GabeShuEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class DeepLinkMediator extends Mediator
	{
		static public const NAME:String = 'DeepLinkMediator';
		
		private var _swfAddress:SWFAddress;
		
		public function DeepLinkMediator()
		{
			
			super(NAME, null);
			init()
			
			
		}
		
		private function init():void
		{
			SWFAddress.onChange = onChange;
			SWFAddress.onInit 	= onInit;
		
		}
		private function onInit():void
		{
			Debug.log('SWFAddress:onInit');
		}
		private function onChange():void
		{
			Debug.log('SWFAddress:onChange');
			Debug.log(SWFAddress.getValue());
			handleSectionChange(removeSlash(SWFAddress.getValue()));
		}
	
		private function setValue(str:String):void
		{
			SWFAddress.setValue(str);
			
		}
		private function handleSectionChange(id:String):void
		{
			
			switch(id)
			{
				
				case 'cart':
					sendNotification(GabeShuEvent.THEME_CHANGE,0);
					sendNotification(GabeShuEvent.SECTION_CHANGE,id);
					break;
				default:
					sendNotification(GabeShuEvent.THEME_CHANGE,1);
					sendNotification(GabeShuEvent.SECTION_CHANGE,id);
					break;
			}
		}
		private function removeSlash(str:String):String
		{
			return str.replace('/','');
		}
		//////////////////////////////////////////////////////////////////////////
		//	IMPLEMENTATIONS														//
		//////////////////////////////////////////////////////////////////////////
		override public function listNotificationInterests():Array
		{
			return [
				GabeShuEvent.CHANGE_SECTION,
			];
		}
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case GabeShuEvent.CHANGE_SECTION:
					setValue(notification.getBody() as String);
					
					break;
				
			}
		}
	}
}