package com.gabe.view.component
{
	import com.gabe.model.IResizable;
	import com.gabe.model.IStylable;
	import com.gabe.model.data.Theme;
	import com.gabe.util.AlignUtil;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class FooterView extends Sprite implements IStylable, IResizable
	{
		private const LEGAL_STRING:String = "ALL IMAGES & TEXT © 2010 GABRIEL J. SHULDINER"
		private var _legal:TextField;
		
		public function FooterView()
		{
			super();
			_legal = new TextField();
			_legal.defaultTextFormat = Theme.FooterStyleBlack;
			_legal.text = LEGAL_STRING;
			_legal.height = 20;
			_legal.width = 300;
			_legal.selectable = _legal.mouseEnabled = false;
			addChild(_legal);

		}
		public function changeStyle(id:int):void
		{
			_legal.text = '';
			if(id==0)
			{
				_legal.defaultTextFormat = Theme.FooterStyleBlack;
			}
			else if(id==1)
			{
				_legal.defaultTextFormat = Theme.FooterStyleWhite;
			}
			_legal.embedFonts = true;
			_legal.text = LEGAL_STRING;
		}
		public function resize():void
		{
			AlignUtil.alignCenterX(_legal);
			AlignUtil.alignBottom(this);
		}
		
	}
}