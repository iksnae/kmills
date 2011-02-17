package com.gabe.control.command.init
{

	
	import com.gabe.model.proxy.AppDataProxy;
	import com.gabe.view.mediator.DeepLinkMediator;
	import com.gabe.view.mediator.ThemeMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class PrepModelCommand extends SimpleCommand
	{
		public function PrepModelCommand()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			Debug.log('EXECUTE: PrepModelCommand');
			facade.registerProxy(new AppDataProxy());
			facade.registerMediator(new DeepLinkMediator());
			facade.registerMediator(new ThemeMediator());
//			facade.registerProxy(new ApplicationDataProxy());
//			facade.registerProxy(new WPServiceProxy());
//			facade.registerProxy(new ShoppingCartProxy());
		}
	}
}