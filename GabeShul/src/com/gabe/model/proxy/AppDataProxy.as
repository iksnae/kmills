package com.gabe.model.proxy
{
	import com.gabe.control.event.GabeShuEvent;
	import com.gabe.model.data.AppData;
	import com.gabe.model.vo.CollectionItem;
	import com.gabe.model.vo.ContactItem;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class AppDataProxy extends Proxy
	{
		static public const NAME:String = "AppDataProxy";
		
		private var _appData:AppData;
		
		public function AppDataProxy()
		{
			super(NAME);
			_appData = new AppData();
			_appData.addEventListener(GabeShuEvent.COLLECTION_LOADING,onDataLoaded);
			_appData.addEventListener(GabeShuEvent.CONTACTS_LOADING,onDataLoaded);
			_appData.addEventListener(GabeShuEvent.COLLECTION_LOADED,onDataLoaded);
			_appData.addEventListener(GabeShuEvent.CONTACTS_LOADED,onDataLoaded);
			
		}
		public function get collection():Vector.<CollectionItem>
		{
			return _appData.collection;
		}
		public function get contact():Vector.<ContactItem>
		{
			return _appData.contacts;
		}
		private function onDataLoaded(e:GabeShuEvent):void
		{
			trace('=====>  '+e.type)
			sendNotification(e.type);
		}
	}
}