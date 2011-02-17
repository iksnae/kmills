package com.gabe.control.command.init
{

	import com.gabe.control.event.GabeShuEvent;
	import com.gabe.model.data.AppData;
	import com.gabe.view.component.CollectionView;
	import com.gabe.view.component.HeaderView;
	import com.gabe.view.component.NavigationButtonView;
	import com.gabe.view.component.NavigationView;
	import com.gabe.view.mediator.AppMediator;
	import com.gabe.view.mediator.CartViewMediator;
	import com.gabe.view.mediator.CollectionViewMediator;
	import com.gabe.view.mediator.ContactViewMediator;
	import com.gabe.view.mediator.DeepLinkMediator;
	import com.gabe.view.mediator.HeaderMediator;
	import com.gabe.view.mediator.NavigationMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PrepViewCommand extends SimpleCommand
	{
		public function PrepViewCommand()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			Debug.log('EXECUTE: PrepViewCommand');
			var app:GabeShul = GabeShuFacade.getInstance().app;
//			facade.registerMediator(new DeepLinkMediator());
			facade.registerMediator(new AppMediator(app));
			facade.registerMediator(new HeaderMediator(app.header));
			facade.registerMediator(new NavigationMediator(app.navigation));
			facade.registerMediator(new CollectionViewMediator(app.collection));
			facade.registerMediator(new ContactViewMediator(app.contact));
			facade.registerMediator(new CartViewMediator(app.cart));
			
			
//			var app:GabrielShuldiner = AppFacade.instance.app;
//			facade.registerMediator(new InventoryViewMediator(app.inventoryView));
//			facade.registerMediator(new CartViewMediator(app.cart));
			
		}
	}
}