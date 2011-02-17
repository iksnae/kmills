package com.gabe.view.mediator
{
	
	import com.gabe.control.event.GabeShuEvent;
	import com.gabe.model.proxy.AppDataProxy;
	import com.gabe.view.component.CollectionView;
	import com.greensock.TweenMax;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class CollectionViewMediator extends Mediator
	{
		
		static public const NAME:String = "CollectionViewMediator";
		
		private var _app:GabeShul;
		
		public function CollectionViewMediator( viewComponent:CollectionView)
		{
			super(NAME, viewComponent);
			_app = GabeShuFacade.getInstance().app;
			view.alpha = 0;
			
		}
		
		public function get view():CollectionView
		{
			return viewComponent as CollectionView
		}
		
		
		
		//////////////////////////////////////////////////////////////////////////
		//	IMPLEMENTATIONS														//
		//////////////////////////////////////////////////////////////////////////
		override public function listNotificationInterests():Array
		{
			return [
				GabeShuEvent.SECTION_CHANGE,
				GabeShuEvent.STAGE_RESIZE,
				GabeShuEvent.COLLECTION_LOADED
			];
		}
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case GabeShuEvent.SECTION_CHANGE:
					if(notification.getBody()=='collections')
					{
						view.show();
					}
					else
					{
						view.hide();
					}
					break;
				case GabeShuEvent.STAGE_RESIZE:
					view.resize();
					break;
				case GabeShuEvent.COLLECTION_LOADED:
					view.populate(AppDataProxy(facade.retrieveProxy(AppDataProxy.NAME)).collection);
					break;
			}
		}
	}
	
}