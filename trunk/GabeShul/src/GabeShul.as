package
{
	import com.gabe.control.event.GabeShuEvent;
	import com.gabe.model.IResizable;
	import com.gabe.model.IStylable;
	import com.gabe.model.data.Theme;
	import com.gabe.util.AlignUtil;
	import com.gabe.view.component.CollectionView;
	import com.gabe.view.component.ContactView;
	import com.gabe.view.component.FooterView;
	import com.gabe.view.component.HeaderView;
	import com.gabe.view.component.NavigationView;
	import com.gabe.view.component.cart.CartView;
	import com.greensock.TweenMax;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.casalib.transitions.Tween;
	import org.casalib.util.StageReference;
	
	public class GabeShul extends Sprite implements IStylable, IResizable
	{
		//////////////////////////////////////////////////////////////////////////
		//	PRIVATE PROPERTIES													//
		//////////////////////////////////////////////////////////////////////////
		
		private var _facade:GabeShuFacade;
		private var _background:Sprite;
		
		
		//////////////////////////////////////////////////////////////////////////
		//	PUBLIC PROPERTIES													//
		//////////////////////////////////////////////////////////////////////////
		
		public var header:HeaderView;
		public var navigation:NavigationView;
		public var collection:CollectionView;
		public var contact:ContactView;
		public var footer:FooterView;
		public var cart:CartView;
		public var landingPage:LandingPageView;
		
		public var backGroundFadeTime:Number = 0.5;
		
		//////////////////////////////////////////////////////////////////////////
		//	CONSTRUCTOR															//
		//////////////////////////////////////////////////////////////////////////
		
		public function GabeShul()
		{
			TweenPlugin.activate([ColorTransformPlugin]);
			init()
		}
		
		//////////////////////////////////////////////////////////////////////////
		//	PUBLIC FUNCTIONS													//
		//////////////////////////////////////////////////////////////////////////
		
		
		//////////////////////////////////////////////////////////////////////////
		//	PRIVATE FUNCTIONS													//
		//////////////////////////////////////////////////////////////////////////
		
		private function init():void
		{
			// init base ui 
			initShell();
			initHeader();
			initFooter();
			initNavigation();
			
			// init sections
			initCollection();
			initContact();
			initCart();
			
			landingPage=new LandingPageView();
			landingPage.big_logo.alpha=0;
			landingPage.title.alpha=0;
			landingPage.subhead.alpha=0;
			landingPage.big_logo.buttonMode=true;
			landingPage.big_logo.addEventListener(MouseEvent.CLICK,
				function(e:MouseEvent):void
				{
					hideLandingPage();
				}
			);
			revealLandingPage();
			header.logo.buttonMode=true;
			header.logo.addEventListener(MouseEvent.CLICK,
				function(e:MouseEvent):void
				{
					revealLandingPage();
					GabeShuFacade.getInstance().sendNotification(GabeShuEvent.CHANGE_SECTION,'');
				}
			);
			
			// add the views to the stage
			addChild(_background);
			addChild(header);
			addChild(footer);
			addChild(navigation);
			addChild(collection);
			addChild(contact);
			addChild(cart);
			addChild(landingPage);
			
			// startup the app
			_facade = GabeShuFacade.init(this);
			_facade.startup()
		}
		
		
		
		
		/**
		 * sets up base ui elements
		 * - background drawn
		 * - stage setup
		 * 
		 */		
		private function initShell():void
		{
			_background = new Sprite();
			_background.graphics.beginFill(0xffffff);
			_background.graphics.drawRect(-200,-200,2500,2000);
			_background.graphics.endFill();
			
			StageReference.setStage(stage);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE,onStageResize)
			
			AlignUtil.STAGEX = stage.stageWidth;
			AlignUtil.STAGEY = stage.stageHeight;
		}
		
		
		/**
		 * initializes the header view 
		 * 
		 */		
		private function initHeader():void
		{
			header = new HeaderView();
		}
		/**
		 * initializes the footer view 
		 * 
		 */	
		private function initFooter():void
		{
			footer = new FooterView();
		}
		/**
		 * initializes the navigation view 
		 * 
		 */	
		private function initNavigation():void
		{
			navigation = new NavigationView();
			navigation.y = 160;
		}
		/**
		 * initializes the collection view 
		 * 
		 */	
		private function initCollection():void
		{
			collection = new CollectionView();
			collection.y = 180;
			collection.visible=false;
		}
		/**
		 * initializes the cart view 
		 * 
		 */	
		private function initCart():void
		{
			cart = new CartView();
			cart.y = 120;
		}
		private function initContact():void
		{
			contact = new ContactView();
			contact.visible = false;
			contact.y = 50;
		}
		
		private function onStageResize(e:Event):void
		{
			AlignUtil.STAGEX = stage.stageWidth;
			AlignUtil.STAGEY = stage.stageHeight;
			
			GabeShuFacade.getInstance().sendNotification(GabeShuEvent.STAGE_RESIZE);
		}
		
		private function revealLandingPage():void
		{
			landingPage.visible=true;
			TweenMax.to(landingPage,1,{alpha:1});
			TweenMax.to(landingPage.title,1,{alpha:1,delay:1});
			TweenMax.to(landingPage.subhead,1,{alpha:1,delay:2});
			TweenMax.to(landingPage.big_logo,1,{alpha:1,delay:3});
			
		}
		private function hideLandingPage():void
		{
			TweenMax.to(landingPage.title,1,{alpha:0,delay:2});
			TweenMax.to(landingPage.subhead,1,{alpha:0,delay:1});
			TweenMax.to(landingPage.big_logo,1,{alpha:0});
			TweenMax.to(landingPage,1,{alpha:0,delay:3,onComplete:function():void{ landingPage.visible=false; }});
		}
		
		//////////////////////////////////////////////////////////////////////////
		//	IMPLEMENTATIONS														//
		//////////////////////////////////////////////////////////////////////////
		/**
		 * changes the style of the base ui elements 
		 * @param id
		 * 
		 */		
		public function changeStyle(id:int):void
		{
			footer.changeStyle(id);
			switch(id)
			{
				case 0:
					TweenMax.to(_background, backGroundFadeTime, {colorTransform:{tint:Theme.WHITE}}); 
					break;
				case 1:
					TweenMax.to(_background, backGroundFadeTime, {colorTransform:{tint:Theme.BLACK}}); 
					break;
			}
		}
		
		/**
		 * adjusts to new stage dimensions 
		 * 
		 */		
		public function resize():void
		{
			///AlignUtil.alignCenterX(header);
			AlignUtil.alignCenterX(navigation);
			AlignUtil.alignCenterX(contact);
			AlignUtil.alignCenterX(landingPage);
			footer.resize();
		}
		
	}
}