package com.gabe.view.component
{
	import com.gabe.model.data.Theme;
	import com.gabe.model.vo.ContactItem;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class ContactEntryView extends Sprite
	{
		
		private var _data:ContactItem;
		private var _label1:TextField;
		private var _label2:TextField;
		private var _label1Style:TextFormat;
		private var _label2Style:TextFormat;
		
		
		public function ContactEntryView(vo:ContactItem)
		{
			super();
			
			_label1Style = Theme.ContactItemStyle1;
			_label2Style = Theme.ContactItemStyle2;
			
			
			_data = vo;
			_label1 = new TextField();
			_label2 = new TextField();
			_label1.width=300;
			_label2.width=300;
			_label1.autoSize = TextFieldAutoSize.CENTER;
			_label2.autoSize = TextFieldAutoSize.CENTER;
			
			
			_label1.defaultTextFormat = _label1Style;
			_label2.defaultTextFormat = _label2Style;
			
			_label2.y = 20;
			_label1.text = _data.label;
			_label2.text = _data.address;
			
			addChild(_label1);
			addChild(_label2);
			
			mouseChildren = false;
			buttonMode = true;
			
			addEventListener(MouseEvent.CLICK,onClick)
		}
		
		private function onClick(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(_data.href),'_blank');
		}
	}
}