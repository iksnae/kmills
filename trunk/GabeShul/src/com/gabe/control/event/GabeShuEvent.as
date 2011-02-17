package com.gabe.control.event
{
	import flash.events.Event;
	
	public class GabeShuEvent extends Event
	{
		
		static public const STARTUP					:String = "GabeShuEvent.Startup";
		static public const READY					:String = "GabeShuEvent.Ready";
		static public const STAGE_RESIZE			:String = "GabeShuEvent.StageResize";
		
		static public const SECTION_CHANGE			:String = "GabeShuEvent.SectionChange";
		static public const CHANGE_SECTION			:String = "GabeShuEvent.ChangeSection";
		static public const THEME_CHANGE			:String = "GabeShuEvent.ThemeChange";
		
		static public const COLLECTION_LOADED		:String = "GabeShuEvent.CollectionLoaded";
		static public const COLLECTION_LOAD_FAIL	:String = "GabeShuEvent.CollectionFailed";
		static public const COLLECTION_LOADING		:String = "GabeShuEvent.CollectionLoading";
		
		static public const CONTACTS_LOADED			:String = "GabeShuEvent.ContactsLoaded";
		static public const CONTACTS_LOAD_FAIL		:String = "GabeShuEvent.ContactsFailed";
		static public const CONTACTS_LOADING		:String = "GabeShuEvent.ContactsLoading";
		
		
		static public const CART_ADD_ITEM			:String = "GabeShuEvent.CartAddItem";
		static public const CART_UPDATED			:String = "GabeShuEvent.CartUpdated";
		static public const CART_REMOVE_ITEM		:String = "GabeShuEvent.CartRemoveItem";
		static public const SHOW_CART				:String = "GabeShuEvent.ShowCart";
		
		
		
		public function GabeShuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}