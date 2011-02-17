package com.gabe.util
{
	import flash.display.DisplayObject;

	public class AlignUtil
	{
		static public var STAGEX:Number;
		static public var STAGEY:Number;
		static public var NAV_WIDTH:Number;
		
		
		public function AlignUtil()
		{
		}
		
		static public function alignCenterX(view:DisplayObject):void
		{
			view.x = STAGEX*.5 - (view.width*.5)
		}
		
		static public function alignBottomRight(view:DisplayObject):void
		{
			view.y = STAGEY-view.height;
			view.x = STAGEX-view.width;
		}
		static public function alignBottom(view:DisplayObject):void
		{
			view.y = STAGEY-view.height;
		}
	}
}