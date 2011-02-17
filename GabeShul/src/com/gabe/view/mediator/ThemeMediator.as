package com.gabe.view.mediator
{
	import com.gabe.control.event.GabeShuEvent;
	import com.gabe.model.data.Theme;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ThemeMediator extends Mediator
	{
		static public const NAME:String = 'ThemeMediator'
		public function ThemeMediator()
		{
			super(NAME);
		}
		//////////////////////////////////////////////////////////////////////////
		//	IMPLEMENTATIONS														//
		//////////////////////////////////////////////////////////////////////////
		override public function listNotificationInterests():Array
		{
			return [
				GabeShuEvent.THEME_CHANGE
			];
		}
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case GabeShuEvent.THEME_CHANGE:
					Theme.CURRENT_THEME = notification.getBody() as int;
					break;
				
			}
		}
	}
}