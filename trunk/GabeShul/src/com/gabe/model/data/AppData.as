package com.gabe.model.data
{
	import com.gabe.control.event.GabeShuEvent;
	import com.gabe.model.vo.CollectionItem;
	import com.gabe.model.vo.ContactItem;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.Responder;
	import flash.system.JPEGLoaderContext;
	
	import org.swxformat.SWX;
	import org.swxformat.events.SWXResultEvent;
	
	public class AppData extends EventDispatcher
	{
		
		private var _gatewayUrl:String = 'http://iksnae.com/remoting/php/swx.php';
		private var _swx:SWX;
		
		private var _collection:Vector.<CollectionItem>;
		private var _collectionReady:Boolean;
		
		
		private var _contacts:Vector.<ContactItem>;
		private var _contactsReady:Boolean;
		
		
		
		
		public function AppData()
		{
			
			_collection = new Vector.<CollectionItem>();
			_contacts = new Vector.<ContactItem>();
			
			_swx = new SWX();
			_swx.gateway = _gatewayUrl;
			_swx.encoding = "POST";
			_swx.timeout = 10;	
			_swx.debug = false;
			
			_swx.progressHandler = progressHandler;
			_swx.timeoutHandler = timeoutHandler;
			_swx.faultHandler = faultHandler;
			
			getAllProducts();
			
		}
		
		private function getAllProducts():void
		{
			dispatchEvent( new GabeShuEvent(GabeShuEvent.COLLECTION_LOADING));
			_swx.resultHandler = getProductsResultHandler;
			_swx.GSCollectionManager.getAllProducts();
		}
		private function getAllContacts():void
		{
			dispatchEvent( new GabeShuEvent(GabeShuEvent.CONTACTS_LOADING));
			_swx.resultHandler = getContactsResultHandler;
			_swx.GSCollectionManager.getAllContacts();
		}
		private function getContactsResultHandler( result:SWXResultEvent ) : void
		{
			trace('getContactsResultHandler invoked');
			var contactData:Array = result.result as Array;
			for each(var obj:Object in contactData)
			{
				var contactVo:ContactItem = new ContactItem();
				contactVo.id = obj.iid;
				contactVo.address = obj.address;
				contactVo.href = obj.href;
				contactVo.label = obj.label;
				_contacts.push(contactVo);
			}
			_contactsReady=true;
			dispatchEvent( new GabeShuEvent(GabeShuEvent.CONTACTS_LOADED));
		}
		private function getProductsResultHandler( result:Object ) : void
		{
			trace('getProductsResultHandler invoked');
			
			var contactData:Array = result.result as Array;
			for each (var obj:Object in contactData)
			{
				var vo:CollectionItem = new CollectionItem();
				vo.id 			= obj.id;
				vo.productID 	= obj.productID;
				vo.title 		= obj.title;
				vo.style 		= obj.style;
				vo.size 		= obj.size;
				vo.collection 	= obj.collection;
				vo.material 	= obj.material;
				vo.price 		= parseFloat(obj.price);
				vo.fullImage 	= obj.fullimage;
				vo.availability = obj.availability;
				vo.thumbImage	= obj.thumb;
				
				_collection.push(vo);
				trace(vo);
			}
			_collectionReady=true;
			dispatchEvent( new GabeShuEvent(GabeShuEvent.COLLECTION_LOADED));
			getAllContacts();
			
		}
		private function getProductsAsXmlResultHandler( result:Object ) : void
		{
			trace('getProductsAsXmlResultHandler invoked');
			var xml:XML = XML(result.result);
			
			var items:XMLList = xml..item;
			for each (var itemXml:XML in items)
			{
				var vo:CollectionItem = new CollectionItem();
				vo.title = itemXml.title.text();
				vo.style = itemXml.style.text();
				vo.size = itemXml.size.text();
				vo.collection = itemXml.collection.text();
				vo.material = itemXml.material.text();
				vo.price = parseFloat(itemXml.price.text());
				vo.fullImage = itemXml.fullimage.text();
				vo.thumbImage = itemXml.thumb.text();
				
				_collection.push(vo);
				trace(vo);
			}
			_collectionReady=true;
			dispatchEvent( new GabeShuEvent(GabeShuEvent.COLLECTION_LOADED));
			getAllContacts();
			
		}
		private function progressHandler( result:Object ) : void
		{
			trace('progressHandler invoked');
//			trace(result);
		}
		private function timeoutHandler( result:Object ) : void
		{
			trace('timeoutHandler invoked');
//			trace(result);
		}
		private function faultHandler( result:Object ) : void
		{
			trace('faultHandler invoked');
//			trace(result);
		}

		public function get collection():Vector.<CollectionItem>
		{
			return _collection;
		}

		public function get collectionReady():Boolean
		{
			return _collectionReady;
		}

		public function get contacts():Vector.<ContactItem>
		{
			return _contacts;
		}
		
		
	}
}