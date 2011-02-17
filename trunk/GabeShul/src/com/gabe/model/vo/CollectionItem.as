package com.gabe.model.vo
{
	public class CollectionItem
	{
		public var id:int;
		public var availability:int;
		public var productID:String;
		public var collection:String;
		public var title:String;
		public var style:String;
		public var size:String;
		public var material:String;
		public var price:Number;
		public var thumbImage:String;
		public var fullImage:String;
		
		public function CollectionItem()
		{
		}
		
		public function toString():String
		{
			return "[CollectionItem: title='"+title+"', price='"+price+"', material='"+material+"', collection='"+collection+"']";
		}
	}
}