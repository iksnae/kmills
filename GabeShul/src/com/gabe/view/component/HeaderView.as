package com.gabe.view.component
{
	import com.gabe.model.IResizable;
	import com.gabe.model.IStylable;
	import com.gabe.model.data.Theme;
	import com.gabe.util.AlignUtil;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class HeaderView extends Sprite implements IStylable, IResizable
	{
		
		private const TITLE_STRING:String = "GABRIEL SHULINDER"
		private var _logo			:Header1;
		
		

		
		public function HeaderView()
		{
			super();
			_logo = new Header1();
			_logo.y = 30;
			_logo.graphics.beginFill(0xff0000,0);
			_logo.graphics.drawRect(0,0,_logo.width,_logo.height);
			_logo.graphics.endFill();

			addChild(_logo);
		}
		public function changeStyle(id:int):void
		{
			Debug.log('header style change: '+id);
			switch(id)
			{
				
				case 1:
					Debug.log('turn logo white');
					_logo.alpha=0;
					TweenMax.to(_logo, 1, {alpha:1,colorTransform:{tint:Theme.WHITE},delay:1});
					break;
				
				case 0:
					Debug.log('turn logo black');
					_logo.alpha=0;
					TweenMax.to(_logo, 1, {alpha:1,colorTransform:{tint:Theme.BLACK},delay:1}); 
					break;
			}
		}
		public function resize():void
		{

			/**
			 * i guess when u updated the logo, the X position got messed up. 
			 * so, i added this alternate centering so it can be offset/tweaked.
			**/
			_logo.x = AlignUtil.STAGEX*.5-250;
			
			//			AlignUtil.alignCenterX(_logo); -- old logo centering
		}

		public function get logo():Header1
		{
			return _logo;
		}

		
	}
}