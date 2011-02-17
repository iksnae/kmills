package com.gabe.view.component
{
	import com.gabe.control.event.GabeShuEvent;
	import com.gabe.model.data.Theme;
	import com.gabe.model.vo.CollectionItem;
	import com.gabe.util.AlignUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import org.casalib.util.TextFieldUtil;
	
	public class CollectItemDetailedView extends Sprite
	{
		
		static public const COLLAPSE:String = "CollectItemDetailedView.Collapse";
		static public const UPDATED:String = "CollectItemDetailedView.Updated";
		
		
		private var _data:CollectionItem;
		
		private var _image:Loader;
		private var _imageZoom:ImageZoom;
		
		
		private var _labelStyle		:TextFormat;
		private var _fieldStyle		:TextFormat;
		private var _collectionStyle:TextFormat;
		
		private var _buyButton		:NavigationButtonView;
		private var _soldButton		:NavigationButtonView;
		
		
		private var _collectionText	:TextField;
		private var _titleText		:TextField;
		private var _styleText		:TextField;
		private var _materialText	:TextField;
		private var _sizeText		:TextField;
		private var _priceText		:TextField;
		
		
		private var _titleLabel		:TextField;
		private var _styleLabel		:TextField;
		private var _materialLabel	:TextField;
		private var _sizeLabel		:TextField;
		
		
		
		
		
		
		private var _collectionTextY	:Number = 0;
		
		private var _titleLabelY		:Number = 0;
		private var _titleLabelX		:Number = 110;
		private var _titleTextY			:Number = 15;
		
		private var _styleLabelY		:Number = 45;
		private var _styleLabelX		:Number = 110;
		private var _styleTextY			:Number = 60;
		
		private var _materialTextY		:Number = 145;
		private var _materialLabelY		:Number = 130;
		private var _materialLabelX		:Number = 110;
		
		private var _sizeTextY			:Number = 235;
		private var _sizeLabelY			:Number = 220;
		private var _sizeLabelX			:Number = 110;
		
		private var _priceTextY			:Number = 300;
		private var _priceTextX			:Number = 0;
		
		private var _font			:NavFont = new NavFont();
		
		private var buyOverSyle		:TextFormat = new TextFormat(_font.fontName,13,Theme.GREY);
		private var buyOutStyle		:TextFormat = new TextFormat(_font.fontName,13,Theme.WHITE);
		
		private var soldStyle		:TextFormat = new TextFormat(_font.fontName,13,Theme.WHITE);
		
		
		private var _available			:Boolean;
		
		private var _rightSide:Sprite;

		
		
		public var nextbtn:Sprite;
		public var prevbtn:Sprite;
		
		
		
		
		public function CollectItemDetailedView()
		{
			super();
			
			_labelStyle = Theme.CollectionDetailsLabelStyle; //new TextFormat('Arial',12,0x000000,true,null,null,null,null,TextFormatAlign.CENTER);
			_fieldStyle = Theme.CollectionDetailsFieldStyle///new TextFormat('BookAntiqua',12,0x000000,null,null,null,null,null,TextFormatAlign.CENTER);
			_collectionStyle = Theme.CollectionDetailsCollectionStyle;//new TextFormat('ChopinScript',24,0x000000,null,null,null,null,null,TextFormatAlign.CENTER);
			
			
			_collectionText = new TextField();
			_collectionText.defaultTextFormat = _collectionStyle;
			_collectionText.width=800;
			_collectionText.x = -100;
//			_collectionText.autoSize = TextFieldAutoSize.CENTER;
			_collectionText.mouseEnabled=_collectionText.selectable=false;
			
			_rightSide = new Sprite();
			_rightSide.x = 300;
			_rightSide.y = 45;

			_materialLabel 	= createLabel('MATERIAL:');
			_materialLabel.y= _materialLabelY;
			_materialLabel.x= _materialLabelX;
			
			_styleLabel 	= createLabel('STYLE:');
			_styleLabel.y	= _styleLabelY;
			_styleLabel.x	= _styleLabelX;
			
			_sizeLabel 		= createLabel('SIZE:');
			_sizeLabel.y	= _sizeLabelY;
			_sizeLabel.x	= _sizeLabelX;
			
			_titleLabel 	= createLabel('TITLE:');
			_titleLabel.y	= _titleLabelY;
			_titleLabel.x	= _titleLabelX;
			
			
			_titleText 		= createField();
			_titleText.y	= _titleTextY;
			_titleText.height = 15;
			
			_styleText 		= createField();
			_styleText.y	= _styleTextY;
			_styleText.height = 60;
			
				
			_sizeText 		= createField();
			_sizeText.y		= _sizeTextY;
			_sizeText.height = 60;
			
			_materialText 	= createField();
			_materialText.y = _materialTextY;
			_materialText.height = 60;
			
			_priceText		= createField();
			_priceText.y 	= _priceTextY;
			_priceText.x 	= _priceTextX;
			_priceText.height = 15;
			
			addChild(_rightSide)
			addChild(_collectionText);
			
			nextbtn = new NextButtonView();// NavigationButtonView('next');
			nextbtn.buttonMode = true;
			
			prevbtn = new PreviousButtonView();//NavigationButtonView('prev');
			
			prevbtn.buttonMode=true;
			prevbtn.x = -50
			nextbtn.x = 650;
			prevbtn.y = nextbtn.y = 200;
//			nextbtn
			
			
			
			
			_rightSide.addChild(_materialLabel);
			_rightSide.addChild(_styleLabel);
			_rightSide.addChild(_sizeLabel);
			_rightSide.addChild(_sizeLabel);
			_rightSide.addChild(_titleLabel);
			_rightSide.addChild(_titleText);
			_rightSide.addChild(_styleText);
			_rightSide.addChild(_sizeText);
			_rightSide.addChild(_materialText);
			_rightSide.addChild(_priceText);
			
			_image = new Loader();
			_image.y=70;
			_image.contentLoaderInfo.addEventListener(Event.COMPLETE,onImageLoaded);
			_image.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onImageFailedToLoad);
			_image.addEventListener(MouseEvent.CLICK,onImageClick)
			
				
			_imageZoom = new ImageZoom();
			_imageZoom.y = 40;
			
			_imageZoom.closeButton.addEventListener(MouseEvent.CLICK,onImageClick)
			_imageZoom.closeButton.buttonMode = true;
			_imageZoom.zoomInButton.buttonMode = true;
			_imageZoom.zoomOutButton.buttonMode = true;
			
				
				
			
			addChild(_image);
			addChild(_imageZoom);
			
			
			addChild(prevbtn);
			addChild(nextbtn);
			addChild(_imageZoom.closeButton);
			_imageZoom.closeButton.x = 650;
			initBuyBtn();
			
			
		}
		private function onImageClick(e:MouseEvent):void
		{
			if(e.currentTarget==_imageZoom.closeButton) dispatchEvent(new Event(COLLAPSE));
		}
		
		private function onImageLoaded(e:Event):void
		{
			AlignUtil.alignCenterX(this);
		}
		private function onImageFailedToLoad(e:IOErrorEvent):void
		{
			AlignUtil.alignCenterX(this);
		}
		
		public function populate(vo:CollectionItem):void
		{
			Debug.log(this+'populate: '+vo.id);
			_data = vo;
//			trace('details:'+vo.title)
			_titleText.text = _data.title;
//			_titleText.height = _titleText.textHeight+5;
			
			_styleText.text = _data.style;
//			_styleText.height = _styleText.textHeight+3;
			
			_sizeText.text = _data.size;
//			_sizeText.height = _sizeText.textHeight+3;
			
			_materialText.text = _data.material;
//			_materialText.height = _materialText.textHeight+3;
			
			_collectionText.text = _data.collection;
//			_collectionText.height = _collectionText.textHeight+3;
			
			_priceText.text = '$'+_data.price.toFixed(2);
			
		
//			_image.load(new URLRequest(_data.fullImage));
			_imageZoom.loadImages(_data.thumbImage,_data.fullImage);
			
//			trace("AVAILABILITY:"+_data.availability)
			
			if(_data.availability==0)
			{
				_available = false;
				_buyButton.visible = false;
				_soldButton.visible = true;
				
//				
//				_buyButton.label = 'SOLD OUT';
//				_buyButton.mouseEnabled = _buyButton.buttonMode = false;
//?				_buyButton.enabled = false;
//				_buyButton.outBgColor = Theme.BLACK;
//				_buyButton.overBgColor = Theme.BLACK;
//				_buyButton.outStyle = Theme.CartButtonSoldOutStyle;
//				_buyButton.overStyle = Theme.CartButtonSoldOutStyle;
				_buyButton.drawBackground();
			}
			else{
				_available = true;
				_buyButton.visible = true;
				_soldButton.visible = false;
//				_buyButton.label = 'PURCHASE NOW';
//				_buyButton.mouseEnabled = _buyButton.buttonMode = true;
//				_buyButton.enabled = true;
////				_buyButton.outBgColor = Theme.BLACK;
////				_buyButton.overBgColor = Theme.BLACK;
////				_buyButton.outStyle = Theme.CartButtonBuyNowStyle;
////				_buyButton.overStyle = Theme.CartButtonSoldOutStyle;
//				_buyButton.drawBackground();
			}
			
		}
		private function initBuyBtn():void
		{
			_buyButton = new NavigationButtonView('PURCHASE NOW');
			_buyButton.overBgColor = Theme.BLACK;
			_buyButton.outBgColor = Theme.BLACK;
			_buyButton.overStyle = buyOverSyle;
			_buyButton.outStyle = buyOutStyle
			_buyButton.drawBackground();
			_buyButton.y = 350
			_buyButton.x = 105;
			_buyButton.addEventListener(MouseEvent.CLICK,clickHandler);
			_rightSide.addChild(_buyButton);
			
			_soldButton = new NavigationButtonView("SOLD OUT");
			_soldButton.enabled = false;
			_soldButton.overBgColor = Theme.BLACK;
			_soldButton.outBgColor = Theme.BLACK;
			_soldButton.overStyle = soldStyle;
			_soldButton.outStyle = soldStyle;
			_soldButton.buttonMode = false;
			_soldButton.drawBackground();
			_soldButton.y = 350
			_soldButton.x = 125;
			_soldButton.addEventListener(MouseEvent.CLICK,clickHandler);
			_rightSide.addChild(_soldButton);
			
		}
		
		
		
		private function createField():TextField
		{
			var tf:TextField = new TextField();
			tf.defaultTextFormat = _fieldStyle;
			tf.multiline=tf.wordWrap=true;
			tf.backgroundColor = 0xff0000;
			tf.selectable = tf.mouseEnabled = false;
			tf.width = 320;
			return tf;
		}
		
		private function createLabel(text:String):TextField
		{
			var tf:TextField = new TextField();
			tf.defaultTextFormat = _labelStyle;
			tf.text = text;
			tf.multiline = tf.wordWrap=true;
			tf.selectable = tf.mouseEnabled = false;
			
			return tf;
		}
		private function clickHandler(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _buyButton:
					if(_available)GabeShuFacade.getInstance().sendNotification(GabeShuEvent.CART_ADD_ITEM,_data);
					break;
			}
		}
	}
}