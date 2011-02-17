package com.iksnae.skinny.ui
{
	import flash.display.Sprite;
	
	public class TouchControlView extends Sprite
	{
		public function TouchControlView()
		{
			super();
			graphics.beginFill(0xffffff,.5);
			graphics.drawRoundRect(0,0,320,30,10);
			graphics.endFill()
		}
	}
}