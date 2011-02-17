package com.gabe.view.component
{
	import com.gabe.model.vo.ContactItem;
	import com.gabe.util.AlignUtil;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class ContactView extends Sprite
	{
		private var _data:Vector.<ContactItem>;
		private var _entries:Vector.<ContactEntryView>;
		private var _spacing:Number = 60;
		private var _listHolder:Sprite = new Sprite();
		
		public function ContactView()
		{
			super();
			graphics.beginFill(0xff0000,0);
			graphics.drawRect(0,130,400,600);
			graphics.endFill();
			_listHolder.y = 180
			_listHolder.x = 30;
			addChild(_listHolder);
		}
		public function populate(contacts:Vector.<ContactItem>):void
		{
			_data = contacts;
			_entries = new Vector.<ContactEntryView>();
			for each( var c:ContactItem in _data)
			{
				var cv:ContactEntryView = new ContactEntryView(c);
				trace('contact: '+c.label);
				_entries.push(cv);
				_listHolder.addChild(cv);
			}
			redraw();
		}
		public function show():void
		{
			trace('show contact')
			alpha=0;
			visible=true;
			TweenMax.to(this,.5,{alpha:1,delay:3})
		}
		public function hide():void
		{
			trace('hide contact')
			TweenMax.to(this,0,{alpha:0,onComplete:onHideComplete,onCompleteParams:[this]})
		}
		
		private function onHideComplete(view:DisplayObject):void
		{
			view.visible=false;
		}
		private function redraw():void
		{
			var i:int=0;
			for each(var v:ContactEntryView in _entries)
			{
				v.y = _spacing*i;
				i++;
			}
			AlignUtil.alignCenterX(this);
		}
	}
}