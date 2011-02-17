package com.gabe.view.mediator
{
	
	import com.gabe.control.event.GabeShuEvent;
	import com.gabe.view.component.HeaderView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class HeaderMediator extends Mediator
	{
		static public const NAME:String = "HeaderMediator"
		
		private var _app:GabeShul;	
		
		public function HeaderMediator(viewComponent:HeaderView)
		{
			super(NAME, viewComponent);
			_app = GabeShuFacade.getInstance().app;
			
//			_app.addElement(viewComponent);
		}
		//////////////////////////////////////////////////////////////////////////
		//	PUBLIC FUNCTIONS													//
		//////////////////////////////////////////////////////////////////////////
		public function get view():HeaderView
		{
			return viewComponent as HeaderView;
		}
		//////////////////////////////////////////////////////////////////////////
		//	PRIVATE FUNCTIONS													//
		//////////////////////////////////////////////////////////////////////////
		private function init():void
		{
			
		}
		//////////////////////////////////////////////////////////////////////////
		//	IMPLEMENTATIONS														//
		//////////////////////////////////////////////////////////////////////////
		override public function listNotificationInterests():Array
		{
			return [
				GabeShuEvent.THEME_CHANGE,
				GabeShuEvent.STAGE_RESIZE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case GabeShuEvent.THEME_CHANGE:
					view.changeStyle(notification.getBody() as int);
					break;
				case GabeShuEvent.STAGE_RESIZE:
					view.resize();
					break;
			}
		}
	}
}