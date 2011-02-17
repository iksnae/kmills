package com.gabe.model.data
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * 
	 * @author iksnae
	 * 
	 * This class is for storing theme and styling information
	 * in static properties and methods. This makes consistent styling
	 * available across the application and allows easier global updates.
	 * 
	 * Themes are identified by an interger value, there are currently 2: 
	 * 
	 * theme 0:
	 * black on white
	 * 
	 * theme 1:
	 * white on black
	 * 
	 * The styling is applied based on the current section in the DeepLinkMediator.
	 * @see com.gabe.view.mediator.DeepLinkMediator @ handleSectionChange()
	 */
	public class Theme
	{
		
		// this property can be checked to see current style
		static public var CURRENT_THEME:int = 0;
		
		// FONTS
		// - embed fonts here.. 
		static public const navFont:NavFont = new NavFont();
		
		
		
		
		// COLORS
		// store colors here
		static public const BLACK:uint = 0x000000;
		static public const WHITE:uint = 0xffffff;
		static public const GREY:uint  = 0x999999;
		
		
		// TEXTFORMAT OBJECTS
		// - this area is for storing text field styles
//		static public const NavFont_White_Style:TextFormat = new TextFormat(navFont.fontName,null,0xffffff);
//		static public const SackersGothic_Black_Style:TextFormat = new TextFormat('SackersGothic',9,0x000000);
		static public const FooterStyleBlack:TextFormat = new TextFormat('SackersGothicStd',9,0x000000);
		static public const FooterStyleWhite:TextFormat = new TextFormat('SackersGothicStd',9,0xffffff);
		
		static public const SackersGothic_White_Style:TextFormat = new TextFormat('SackersGothicStd',null,0xffffff);
		static public const CartItemViewLabelStyle:TextFormat = new TextFormat('SackersGothicStd',12,0x000000);
		static public const CartButtonBuyNowStyle:TextFormat = new TextFormat('Arial',12,GREY);
		static public const CartButtonSoldOutStyle:TextFormat = new TextFormat('Arial',12,0xffffff);
		
		
		static public const ContactItemStyle1:TextFormat = new TextFormat('SackersGothicStd',12,0xffffff,true,null,null,null,null,TextFormatAlign.CENTER);
		static public const ContactItemStyle2:TextFormat = new TextFormat('SackersGothicStd',12,0xffffff,true,null,null,null,null,TextFormatAlign.CENTER);
		
//		static public const BookAntiqua_Black12_Style:TextFormat = new TextFormat('BookAntiqua',12,0x000000);
//		static public const BookAntiqua_White12_Style:TextFormat = new TextFormat('BookAntiqua',12,0xffffff);
		static public const CollectionDetailsLabelStyle:TextFormat = new TextFormat('SackersGothicStd',12,0x000000,true,null,null,null,null,TextFormatAlign.CENTER);
		static public const CollectionDetailsFieldStyle:TextFormat = new TextFormat('BookAntiqua',12,0x000000,null,null,null,null,null,TextFormatAlign.CENTER);
		static public const CollectionDetailsCollectionStyle:TextFormat = new TextFormat('ChopinScript',24,0x000000,null,null,null,null,null,TextFormatAlign.CENTER);
		
		static public const NavigationOverStyle1:TextFormat	= new TextFormat('SackersGothicStd',null,0xffffff);
		static public const NavigationOutStyle1:TextFormat	= new TextFormat('SackersGothicStd',null,0x000000);
		
		/// constructor
		public function Theme()
		{
		}
	}
}