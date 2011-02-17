package com.gabe.view.component
{
	import com.gabe.control.event.GabeShuEvent;
	import com.gabe.model.data.Theme;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	public class NavigationButtonView extends Sprite
	{
		private var _textOver		:TextField;
		private var _textOut		:TextField;
		private var _font			:NavFont = new NavFont();
		
		private var _styleOver		= Theme.NavigationOverStyle1;
		private var _styleOut		= Theme.NavigationOutStyle1;

		private var _label			:String;
		private var _hit			:Sprite;
		private var _overBG			:Sprite;
		private var _outBG			:Sprite;
		
		private var _overBgColor	:uint = Theme.BLACK;
		private var _outBgColor		:uint = Theme.WHITE;
		private var _enabled		:Boolean = false;
		
		private var _bgAlpha		:Number = 1.0;
		
		private var _borderSize:Number = 10;
		
		public function NavigationButtonView(label:String)
		{
			super();
			
			
			// store label value
			_label = label.toUpperCase();
			
	
			
			// init TF
			_textOver = new TextField();
			_textOver.defaultTextFormat = _styleOver;
			
			_textOver.text = _label;
			_textOver.width = _textOver.textWidth+15;
			_textOver.height = _textOver.textHeight+1;
			_textOver.selectable = _textOver.mouseEnabled = false;
			
			_textOut = new TextField();
			_textOut.defaultTextFormat = _styleOut;
			_textOut.text = _label;
			_textOut.width = _textOut.textWidth+15;
			_textOut.height = _textOut.textHeight+1;
			_textOut.selectable = _textOut.mouseEnabled = false;
			

			// init hit
			_hit = new Sprite();
			_hit.graphics.beginFill(0xff0000,0);
			_hit.graphics.drawRect(0,0,_textOver.width,_textOver.height);
			_hit.graphics.endFill();
			
			_overBG = new Sprite();
			_outBG = new Sprite();
			
			_textOver.alpha = 0;
			_overBG.alpha = 0;
			
			addChild(_outBG);
			addChild(_textOut);
			addChild(_overBG);
			addChild(_textOver);
			
			addChild(_hit);
			
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_OVER,over);
			addEventListener(MouseEvent.MOUSE_OUT,out);
			enabled = true
		}
		public function set label(value:String):void
		{
			_label = value.toLocaleUpperCase();
			
			_textOut.text 	= _label;
			_textOver.text 	= _label;
			
			

		}
		public function get label():String
		{
			return _label;
		}

		public function set overStyle(style:TextFormat):void
		{
			_styleOver = style;
			redraw();
		}
		public function set outStyle(style:TextFormat):void
		{
			_styleOut = style;
			redraw();
		}

		public function over(o:Object=null):void
		{
			if(_enabled)
			{
				TweenLite.to(_textOut,.5,{alpha:0});
				TweenLite.to(_outBG,.5,{alpha:0});
				
				TweenLite.to(_textOver,.5,{alpha:1});
				TweenLite.to(_overBG,.5,{alpha:1});
			}
		}
		public function out(o:Object=null):void
		{
			if(_enabled)
			{
				TweenLite.to(_textOut,.5,{alpha:1});
				TweenLite.to(_outBG,.5,{alpha:1});
	
				TweenLite.to(_textOver,.5,{alpha:0});
				TweenLite.to(_overBG,.5,{alpha:0});
			}
		}
		public function drawBackground():void
		{
			_textOut.width = _textOut.textWidth+5;
			_textOut.height = _textOut.textHeight+5;
			
			_textOver.width = _textOver.textWidth+5;
			_textOver.height = _textOver.textHeight+5;
			drawBg(_outBgColor,_outBG);
			drawBg(_overBgColor,_overBG);
		}
		private function drawBg(c:uint,targ:Sprite):void
		{
			targ.graphics.clear();
			targ.graphics.beginFill(c,_bgAlpha);
			targ.graphics.drawRect(  0-_borderSize,  0-_borderSize,  _textOut.width+(_borderSize*2),  _textOut.height+(_borderSize*2) );
			targ.graphics.endFill();
				
		}
		private function redraw():void
		{
			_textOver.text='';
			_textOver.defaultTextFormat = _styleOver;
			_textOver.text = _label;
			_textOver.embedFonts = true;
			_textOut.text='';
			_textOut.defaultTextFormat = _styleOut;
			_textOut.text = _label;
			_textOut.embedFonts = true;
			drawBackground();
			
		}

		public function get overBgColor():uint
		{
			return _overBgColor;
		}

		public function set overBgColor(value:uint):void
		{
			_overBgColor = value;
		}

		public function get outBgColor():uint
		{
			return _outBgColor;
		}

		public function set outBgColor(value:uint):void
		{
			_outBgColor = value;
		}

		

		public function get borderSize():Number
		{
			return _borderSize;
		}

		public function set borderSize(value:Number):void
		{
			_borderSize = value;
		}

		
		public function set enabled(value:Boolean):void
		{
			
			if(!value)
			{
				over();
			}
			else
			{
				out();
			}
			_enabled = value;
		}

		public function set bgAlpha(value:Number):void
		{
			_bgAlpha = value;
		}

		

		
	}
}