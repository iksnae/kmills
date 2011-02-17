package com.gabe.view.mediator
{
	import com.gabe.view.component.cart.CartView;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class CartMediator extends Mediator
	{
		static public const NAME:String = "CartMediator";
		
		public function CartMediator( viewComponent:CartView)
		{
			super(NAME, viewComponent);
		}
		
		private function get view():CartView
		{
			return viewComponent as CartView
		}
		
	}
}