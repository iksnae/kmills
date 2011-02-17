package com.wordhunt.control
{
	import com.wordhunt.model.GameConfig;
	import com.wordhunt.view.BoardView;
	import com.wordhunt.view.TileView;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	public class GameLogic
	{
		
		//////////////////////////
		////  INSTANTIATION
		//////////////////////////
		static private var _instance:GameLogic=null;
		static public function getInstance():GameLogic{
			if(_instance==null)_instance=new GameLogic(new GLSE())
			return _instance;
		}
		
		
		/////////////////////////
		////  CONSTRUCTOR
		/////////////////////////
		public function GameLogic(enforcer:GLSE)
		{
		}
		
		////////////////////////
		//// PRIVATE PROPERTIES
		////////////////////////
		private var _drawView:Sprite;
		private var _selectionView:Sprite;
		private var _drawTimer:Timer;
		private var _gameConfig:GameConfig;
		private var _gameView:BoardView;
		private var _wordList:Array;
		private var _chars:String='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
		private var _gameTimer:Timer = new Timer(500)
		private var _totalUsedWords:int
		
		private function onDrawTimer(te:TimerEvent):void{
			
		}
		public function startDrawing():void{
			_drawTimer.start()
		}
		public function stopDrawing():void{
			_drawTimer.stop()
		}
		public function set gameView(v:BoardView):void{
			_gameView = v;
		}
		public function inDiagnol():Boolean{
			return (Math.abs(_gameView.lastSelection.x - _gameView.firstSelection.x) == Math.abs(_gameView.lastSelection.y -_gameView.firstSelection.y));
		}
		public function inSameRow():Boolean{
			return (_gameView.firstSelection.row== _gameView.lastSelection.row)
		}
		public function inSameColumn():Boolean{
			return (_gameView.firstSelection.col == _gameView.lastSelection.col)
		}
		public function isSameTile():Boolean{
			return (_gameView.firstSelection==_gameView.lastSelection);
		}
		public function randomChar():String{
			return _chars.charAt(Math.round(Math.random()*(_chars.length-1)));
		}
		public function drawLine( startingPt:Point):void{
			_gameView.drawView.graphics.clear()
			_gameView.drawView.graphics.lineStyle(_gameView.config.tileSize,_gameView.config.hilightColor)
            _gameView.drawView.graphics.moveTo(startingPt.x, startingPt.y);
            _gameView.drawView.graphics.lineTo(_gameView.mouseX,_gameView.mouseY);
		}
		public function drawSelection( range:Array):void{
			_gameView.selectionView.graphics.moveTo(range[0].x,range[0].y)
			_gameView.selectionView.graphics.lineStyle(_gameView.config.tileSize*.8,_gameView.config.lineFillColor)
			_gameView.selectionView.graphics.lineTo(range[1].x,range[1].y);
			
		}
		
		public function calcStraightLine():Array{
			var arr:Array;
			var startPoint:Point=new Point();
			var endPoint:Point=new Point();
			var targ0:TileView = _gameView.firstSelection;
			var targ1:TileView = _gameView.lastSelection;
			
			//trace('targ0: '+targ0.x+','+targ0.y)
		//	trace('targ1: '+targ1.x+','+targ1.y)
			
			if(targ0.x < targ1.x){
				startPoint.x = targ0.x+(_gameView.config.tileSize/2);
				endPoint.x   = targ1.x+(_gameView.config.tileSize/2)
			}else if(targ0.x > targ1.x){
		
				startPoint.x = targ1.x+(_gameView.config.tileSize/2);
				endPoint.x   = targ0.x+(_gameView.config.tileSize/2);
			}else if(targ0.x == targ1.x){
				startPoint.x = targ0.x+(_gameView.config.tileSize/2);
				endPoint.x   = targ0.x+(_gameView.config.tileSize/2);
			}
			
			if(targ0.y < targ1.y){
				startPoint.y = targ0.y+(_gameView.config.tileSize/2);
				endPoint.y = targ1.y+(_gameView.config.tileSize/2);
			}else if(targ0.y > targ1.y){
				startPoint.y = targ1.y+(_gameView.config.tileSize/2);
				endPoint.y = targ0.y+(_gameView.config.tileSize/2);
			}else if(targ0.y == targ1.y){
				startPoint.y = targ0.y+(_gameView.config.tileSize/2);
				endPoint.y = targ0.y+(_gameView.config.tileSize/2);
			}
			
			
			arr = [startPoint,endPoint]
			return arr;
		}
		
		public function calcDiagnoleLine():Array{
			var arr:Array;
			var startPoint:Point=new Point();
			var endPoint:Point=new Point();
			var targ0:TileView=_gameView.firstSelection
			var targ1:TileView=_gameView.lastSelection;
			
			arr = [startPoint,endPoint]
			
			
			if(targ0.x < targ1.x){
				startPoint.x = targ0.x+(_gameView.config.tileSize/2);
				endPoint.x   = targ1.x+(_gameView.config.tileSize/2)
				if(targ0.y < targ1.y){
				//	trace('opt0')
					startPoint.y = targ0.y+(_gameView.config.tileSize/2);
					endPoint.y = targ1.y+(_gameView.config.tileSize/2);
				}else if(targ0.y > targ1.y){
				//	trace('opt1')
					startPoint.y = targ0.y+(_gameView.config.tileSize/2);
					endPoint.y = targ1.y+(_gameView.config.tileSize/2);
				}
			}else if(targ0.x > targ1.x){
				startPoint.x = targ0.x+(_gameView.config.tileSize/2);
				endPoint.x   = targ1.x+(_gameView.config.tileSize/2);
				if(targ0.y > targ1.y){
				//	trace('opt2')
					startPoint.y = targ0.y+(_gameView.config.tileSize/2);
					endPoint.y = targ1.y+(_gameView.config.tileSize/2);
					
				}else if(targ0.y < targ1.y){
				//	trace('opt3')
					startPoint.y = targ0.y+(_gameView.config.tileSize/2);
					endPoint.y = targ1.y+(_gameView.config.tileSize/2); 
					arr = [endPoint,startPoint]
				}
			}
			return arr;
		}
		
		public function build(words:Array):void{
			_wordList= words.concat();
			_gameView.addEventListener('ready', boardReadyHandler)
			
		}
		private function boardReadyHandler(e:Event):void{
			trace('Board Ready!')
			_totalUsedWords = _gameView.usedWords.length;
			_gameTimer.start()
			
		}
		
		private var maxAttempts:int = 1000;
		private var wordsCopy:Array;
		private var pos:int;
		public function get usedWords():Array{
			return _gameView.usedWords;
		}
		private function fillTheGaps():void{
			for each (var t:TileView in _gameView.tiles){
				if(!t.populated){
					t.char = randomChar()
				}
			}
		}
		
		
		
    
        private var numFound:int;
        
        public function get startPoint():TileView{
        	return _gameView.firstSelection
        }
		public function get endPoint():TileView{
            return _gameView.lastSelection
        }
        public function get grid():Array{
        	return _gameView.grid
        }
        
		
		// find selected letters based on start and end points
        public function getSelectedWord():String {
            
            // determine dx and dy of selection, and word length
            var drow:Number = endPoint.row-startPoint.row;
            var dcol:Number = endPoint.col-startPoint.col;
            var wordLength:Number = Math.max(Math.abs(drow),Math.abs(dcol))+1;
            
      //      trace('wordLength: '+wordLength);
            
            // get each character of selection
            var word:String = "";
            for(var i:int=0;i<wordLength;i++) {
                var row:Number = startPoint.row;
          //      trace('startPoint.row:'+startPoint.row)
                
                if (drow < 0) row -= i;
                if (drow > 0) row += i;
                var col:Number = startPoint.col;
          //      trace('startPoint.col:'+startPoint.col)
                if (dcol < 0) col -= i;
                if (dcol > 0) col += i;
                
                var tile:TileView= _gameView.tileView.getChildByName('Col'+col+'Row'+row) as TileView;
                word += tile.char;
            }
            return word;
        }
        // check word against word list
        public function checkWord(word:String):Boolean {
            trace('check word: '+word)
            var wasFound:Boolean;
            // loop through words
            for(var i:int=0;i<usedWords.length;i++) {
                
                // compare word
                if (word == usedWords[i].toUpperCase()) {
                    foundWord(word);
                    wasFound=true
                }
                
                // compare word reversed
                var reverseWord:String = word.split("").reverse().join("");
                if (reverseWord == usedWords[i].toUpperCase()) {
                    foundWord(reverseWord);
                    wasFound=true
                }
            }
            return wasFound;
        }
        // word found, remove from list, make outline permanent
        public function foundWord(word:String):void {
             trace('word found: '+word)
            // draw outline in permanent sprite
            drawLine(_gameView.calcCenter(_gameView.firstSelection));
            
            
            for(var i:int=0;i< _gameView.listView.numChildren;i++) {
                if (TextField(_gameView.listView.getChildAt(i)).text.toUpperCase() == word) {
                    TextField(_gameView.listView.getChildAt(i)).textColor = _gameView.config.lineFillColor;
                }
            }
            
            
            // see if all have been found
            numFound++;
            trace(numFound+' of '+_totalUsedWords+' found @ '+converTime(_gameTimer.currentCount))
            if (numFound == _totalUsedWords) {
                endGame();
            }
        }
        private function endGame():void{
        	_gameTimer.stop()
        	trace('game complete!')
        	trace("TIME: "+ converTime(_gameTimer.currentCount))
        	trace("WORDS: "+_totalUsedWords)
        	
        	
        }
        private function converTime(seconds:Number):String{
        	var part = String((seconds/60));
            var part2 = part.split(".");
            return part2[0] + ":" + (Math.round(part2[1]*6));
        	
        }
        
       
		
	
		        

	}
}
class GLSE {}