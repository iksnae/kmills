package com.gabe.view.component
{
	import com.gabe.control.event.GabeShuEvent;
	import com.gabe.model.IResizable;
	import com.gabe.model.proxy.AppDataProxy;
	import com.gabe.model.vo.CollectionItem;
	import com.gabe.util.AlignUtil;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	public class CollectionView extends Sprite implements IResizable
	{
		////////////////////////////////////////////////////////////////////////
		//	STATIC CONSTANTS
		////////////////////////////////////////////////////////////////////////
		
		static public const GRID_MODE	:String = "grid_mode";
		static public const PANNING_MODE:String = "panning_mode";
		static public const DETAIL_MODE	:String = "detail_mode";
		
		////////////////////////////////////////////////////////////////////////
		//	PRIVATE CONSTANTS
		////////////////////////////////////////////////////////////////////////
		
		private const _headerHeight		:Number = 130;
		private const _footerHeight		:Number = 30;
		private const _leftPadding		:Number = 30;
		private const _rightPadding		:Number = 30;
		private const _bgColor			:uint	= 0xffffff;
		
		////////////////////////////////////////////////////////////////////////
		//	PRIVATE PROPERTIES
		////////////////////////////////////////////////////////////////////////
		
		private var _appDataProxy		:AppDataProxy;
		
		private var _mode				:String = PANNING_MODE;
		private var _lastMode			:String = PANNING_MODE;
		private var _tileSpacing		:Number = 10;
		private var _populated			:Boolean;
		private var _gridHeight			:Number;
		private var _currentItem		:int = 0;

		private var _gridTileHolder		:Sprite; 
		private var _detailsPanelHolder	:Sprite;
		private var _panningTileHolder	:PanningCollectionView;
		private var _background			:Sprite;
		private var _detailsPanel		:CollectItemDetailedView;
		private var _modeChangeButton	:NavigationButtonView;
		
		
		private var _tiles				:Vector.<CollectionTile>;
		private var _collectionItems	:Vector.<CollectionItem>;
		
		private var _mouseArea			:Sprite = new Sprite();
		private var _scrollTimer		:Timer = new Timer(100);
		
	
		
		
		////////////////////////////////////////////////////////////////////////
		//	CONSTRUCTOR
		////////////////////////////////////////////////////////////////////////
		
		public function CollectionView()
		{
			super();
			
			_mouseArea.graphics.beginFill(0xff0000,0);
			_mouseArea.graphics.drawRect(0,0,1000,800);
			_mouseArea.graphics.endFill();
			_mouseArea.x = 100;
			_scrollTimer.addEventListener(TimerEvent.TIMER,onTimer);
			addChild(_mouseArea);
			
			// init tiles vector
			_tiles = new Vector.<CollectionTile>();
			
			// details panel
			_detailsPanel = new CollectItemDetailedView();
			_detailsPanel.name = 'detailsPanel';
			_detailsPanel.addEventListener(CollectItemDetailedView.COLLAPSE,onCollapseDetails)
			_detailsPanel.nextbtn.addEventListener(MouseEvent.CLICK,nextItem);
			_detailsPanel.prevbtn.addEventListener(MouseEvent.CLICK,prevItem);
			_detailsPanel.x = (AlignUtil.STAGEX*.5)-325;//(AlignUtil.NAV_WIDTH*.5);
			
			// background
			_background = new Sprite();
			_background.name = 'background';
			_background.graphics.beginFill(_bgColor);
			_background.graphics.drawRect(0,0,2000,450);
			_background.graphics.endFill();
			
			// tile grid holder
			_gridTileHolder = new Sprite();
			_gridTileHolder.name = 'gridHolder'
				
			_detailsPanelHolder = new Sprite();
			_detailsPanelHolder.name="detailHolder";
			_detailsPanelHolder.y = 10;
			_detailsPanelHolder.graphics.beginFill(_bgColor,0);
			_detailsPanelHolder.graphics.drawRect(0,0,1000,500);
			_detailsPanelHolder.graphics.endFill();
			
			// panning tile holder
			_panningTileHolder = new PanningCollectionView();
			_panningTileHolder.name = 'panningHolder';
			_panningTileHolder.y = 50;
			_panningTileHolder.graphics.beginFill(_bgColor,0);
			_panningTileHolder.graphics.drawRect(0,0,1000,500);
			_panningTileHolder.graphics.endFill();
			_panningTileHolder.addEventListener(MouseEvent.CLICK,onLargeTileSelected);
			
			// add views to stage
			addChild(_background);
			addChild(_detailsPanelHolder);
			addChild(_panningTileHolder);
			addChild(_gridTileHolder);
			
			_modeChangeButton = new NavigationButtonView('view all');
			_modeChangeButton.y = 400;
			_modeChangeButton.x = 800;
			_modeChangeButton.borderSize=5;
			_modeChangeButton.drawBackground();
			_modeChangeButton.addEventListener(MouseEvent.CLICK,clickHandler);
//			addChild(_modeChangeButton);
			_detailsPanelHolder.addChild(_detailsPanel);
			
			
			
		}
		
		////////////////////////////////////////////////////////////////////////
		//	PUBLIC METHODS
		////////////////////////////////////////////////////////////////////////
		
		private function showDetails(vo:CollectionItem):void
		{
			_detailsPanel.populate(vo);
//			_detailsPanel.x =  AlignUtil.STAGEX-(_detailsPanel.width);
			switchMode(DETAIL_MODE);
		}
		
		private function nextItem(e):void
		{
			trace("NEXT: "+_currentItem+" of "+_collectionItems.length)
			if(_currentItem < _collectionItems.length-1)
			{
				
				_currentItem++;
				trace('next++:'+_currentItem+" of "+_collectionItems.length)
				_detailsPanel.populate(_collectionItems[_currentItem]);
				
			}
			else if(_currentItem == _collectionItems.length-1)
			{
				trace('back to top')
				_currentItem=0;
				_detailsPanel.populate(_collectionItems[_currentItem]);
			}
			trace("next action complete. current item is "+_currentItem)
		}
		private function prevItem(e):void
		{
			trace("PREV: "+_currentItem+" of "+_collectionItems.length)
			if(_currentItem > 0)
			{
				_currentItem--;
				trace('prev--:'+_currentItem+" of "+_collectionItems.length)
				_detailsPanel.populate(_collectionItems[_currentItem]);
			}
			else
			{
				trace('back to bottom')
				_currentItem=_collectionItems.length-1;
				_detailsPanel.populate(_collectionItems[_currentItem]);
			}
		}
		
		/**
		 * transitions this (CollectionView) in
		 * 
		 */	
		public function show():void
		{
			trace('show collection');
			visible = true;
			TweenMax.to(this,.5,{alpha:1,delay:3});
			switchMode(_mode);			

		}
		/**
		 * transitions this (CollectionView) out
		 * 
		 */		
		public function hide():void
		{
			trace('hide collection');
			this.alpha=0;
			TweenMax.to(_panningTileHolder,0,{alpha:0});
			TweenMax.to(_gridTileHolder,0,{alpha:0});
			TweenMax.to(_detailsPanelHolder,0,{alpha:0});
			TweenMax.delayedCall(1,onHideComplete,[this]);
			_mode=_lastMode;
		}
		/**
		 * populated the _collectionItems property, then initiates the views. 
		 * @param coll
		 * 
		 */		
		public function populate(coll:Vector.<CollectionItem>):void
		{
			Debug.log('populate collection:'+coll.length);
			if(!_populated)
			{
				Debug.log('Collection Populated.')
				_collectionItems = coll;
				_populated = true;
				_panningTileHolder.populate(coll);
				initCollectionView();
			}
			else
			{
				Debug.log('Collection Already Populated.')
			}
		}
		
		public function switchMode(mode:String):void
		{
			_mode=mode;
			trace('show: '+_mode);
			switch(_mode)
			{
				case GRID_MODE:
					trace('revealing grid.')
					_modeChangeButton.y = _gridHeight;
					_gridTileHolder.visible = true;
					TweenMax.to(_panningTileHolder,.5,{alpha:0,onComplete:onHideComplete,onCompleteParams:[_panningTileHolder]});
					TweenMax.to(_gridTileHolder,.5,{alpha:1,delay:.5});
					TweenMax.to(_detailsPanelHolder,.5,{alpha:0,onComplete:onHideComplete,onCompleteParams:[_detailsPanelHolder]});
					_modeChangeButton.visible=true;
					GabeShuFacade.getInstance().sendNotification(GabeShuEvent.STAGE_RESIZE);
					break;
				case PANNING_MODE:
					_modeChangeButton.y = 400;
					_panningTileHolder.visible = true;
					TweenMax.to(_panningTileHolder,.5,{alpha:1,delay:.5});
					TweenMax.to(_gridTileHolder,.5,{alpha:0,onComplete:onHideComplete,onCompleteParams:[_gridTileHolder]});
					TweenMax.to(_detailsPanelHolder,.5,{alpha:0,onComplete:onHideComplete,onCompleteParams:[_detailsPanelHolder]});
					_modeChangeButton.visible=true;
					GabeShuFacade.getInstance().sendNotification(GabeShuEvent.STAGE_RESIZE);
					break;
				case DETAIL_MODE:
					_detailsPanelHolder.visible = true;
					TweenMax.to(_panningTileHolder,.5,{alpha:0,onComplete:onHideComplete,onCompleteParams:[_panningTileHolder]});
					TweenMax.to(_gridTileHolder,.5,{alpha:0,onComplete:onHideComplete,onCompleteParams:[_gridTileHolder]});
					TweenMax.to(_detailsPanelHolder,.5,{alpha:1,delay:.5});
					_modeChangeButton.visible=false;
					break;
				
			}
		}
		
		////////////////////////////////////////////////////////////////////////
		//	PRIVATE METHODS
		////////////////////////////////////////////////////////////////////////
		
		/**
		 * disables interaction , after hide transition is complete. 
		 * 
		 */		
		private function onHideComplete(view:DisplayObject):void
		{
//			trace('disabling: '+view.name)
			view.visible = false;
		}
		
		/**
		 * initiates the collection view, based on _collectionItems 
		 * 
		 */		
		private function initCollectionView():void
		{
			for(var i:int = 0;i<_collectionItems.length;i++)
			{
				var t:CollectionTile = new CollectionTile(_collectionItems[i]);
				t.addEventListener(MouseEvent.CLICK,onTileSelected);
//				trace('new tile...')
				_tiles.push(t);
				_gridTileHolder.addChild(t);
			}
			resize();
			_scrollTimer.start();
		}
		
		/**
		 * displays item details 
		 * @param e
		 * 
		 */		
		private function onTileSelected(e:MouseEvent):void
		{
			_lastMode = _mode
			var targ:CollectionTile = e.currentTarget as CollectionTile;
			showDetails(targ.data);
		}
		private function onTimer(e:TimerEvent):void
		{
			var speed:Number = 10;
			var percentage:Number = (_mouseArea.mouseX-x)/(_mouseArea.width);
			var mouseSpeed:Number = -(percentage);
			var newX:Number = Math.round((_panningTileHolder.width-_mouseArea.width) * mouseSpeed);
			
			_panningTileHolder.x += Math.ceil((newX-_panningTileHolder.x)*(speed/100));
			
			if(_panningTileHolder.width+_panningTileHolder.x < _mouseArea.x+_mouseArea.width) _panningTileHolder.x = ((_mouseArea.x+_mouseArea.width)-_panningTileHolder.width);
			if(_panningTileHolder.x > _mouseArea.x) _panningTileHolder.x=_mouseArea.x;
		}
		
		private function onLargeTileSelected(e:Event):void
		{
			_lastMode = _mode
			showDetails(_panningTileHolder.selectedItem.data);
			
		}
		private function clickHandler(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _modeChangeButton:
					if(_mode==GRID_MODE)
					{
						_mode=PANNING_MODE;
						_modeChangeButton.label = "VIEW ENTIRE COLLECTION"
						switchMode(_mode);
					}
					else if(_mode==PANNING_MODE)
					{
						_mode=GRID_MODE;
						_modeChangeButton.label = "SCROLL COLLECTION"
						switchMode(_mode);
					}
					
					break;
			}
		}
		private function onCollapseDetails(e:Event):void
		{
			switchMode(_lastMode);
		}
		/**
		 * redraws the grid based on new stage constraints 
		 * 
		 */		
		private function redrawGrid():void
		{
			var xMax:int = Math.ceil(_background.width/(CollectionTile.DEFAULTSIZE+(_tileSpacing*2)))-1;
			var row:int = 0;
			var col:int = 0;
			_gridHeight = CollectionTile.DEFAULTSIZE;
			for each(var tile:CollectionTile in _tiles)
			{
				tile.x = ((CollectionTile.DEFAULTSIZE+_tileSpacing)*col)+(_background.x+_tileSpacing);
				tile.y = ((CollectionTile.DEFAULTSIZE+_tileSpacing)*row)+(_background.y+_tileSpacing);
				
				if(col<xMax)
				{
					col++;
				}
				else
				{
					col=0;
					row++;
					_gridHeight+=CollectionTile.DEFAULTSIZE
				}
			}
			_modeChangeButton.y = _gridHeight;
		}
		
		
		
		
		/**
		 * handles resize for liquid layout 
		 * 
		 */		
		public function resize():void
		{
			_gridTileHolder.x = (AlignUtil.STAGEX*.5)-450
//			AlignUtil.alignBottom(_modeChangeButton);
//			_background.height = AlignUtil.STAGEY-(_headerHeight+_footerHeight);
//			_background.x = _leftPadding;
//			_background.y = _headerHeight;
			
			_detailsPanel.x = (AlignUtil.STAGEX*.5)-325;
			
			// check mode then redraw view...
			if(_mode==GRID_MODE) redrawGrid();
		}
		
	}
}