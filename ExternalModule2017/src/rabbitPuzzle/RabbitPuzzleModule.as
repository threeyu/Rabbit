package rabbitPuzzle
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.fscommand;
	
	import rabbitPuzzle.util.SoundManager;
	import rabbitPuzzle.vo.Piece;
	
	[SWF(backgroundColor="#000000", frameRate="30", width="1024", height="600")]
	public class RabbitPuzzleModule extends Sprite
	{
		private var _mainUI : MovieClip;
		
		private var _bmList : Array = new Array(12);
		private var _curLvl : uint;
		
		private const ROWS : uint = 3;
		private const COLS : uint = 3;
		private var _showGuid : Boolean = true;
		private var _showGuidCon : Sprite;
		private var _regularCon : Sprite;
		private var _pieceList : Array = [];
		private var _curId : uint;
		private var _curAnim : uint;
		private var _canClick : Boolean;
		
		// 鼠牛虎兔龙蛇马羊猴鸡狗猪
		// tab great right btn select tips bgm
		private const SOUND_URL : Array = [
			"res/sound_1.mp3", "res/sound_2.mp3", "res/sound_3.mp3", "res/sound_4.mp3", "res/sound_5.mp3", "res/sound_6.mp3", "res/sound_7.mp3", "res/sound_8.mp3", "res/sound_9.mp3", "res/sound_10.mp3", "res/sound_11.mp3", "res/sound_12.mp3",
			"res/sound_13.mp3", "res/sound_14.mp3", "res/sound_15.mp3", "res/sound_16.mp3", "res/sound_17.mp3", "res/sound_18.mp3", "res/sound_19.mp3"
		];
		private var _soundManeger : SoundManager = SoundManager.getInstance();
		
		public function RabbitPuzzleModule()
		{
			_mainUI = new RabbitPuzzleModuleUI();
			this.addChild(_mainUI);
			
			initData();
			addEvent();
			_mainUI.addEventListener(Event.DEACTIVATE, onDeactivate);
		}
		private function onDeactivate(e : Event) : void
		{
			fscommand("quit");
		}
		
		private function initData() : void
		{
			for(var i : uint = 0; i < _bmList.length; ++i)
			{
				_mainUI["mcCanvas"].gotoAndStop(i + 1);
				_bmList[i] = mc2Bitmap(_mainUI["mcCanvas"]["mcPic"]);
			}
			
			_soundManeger.playSound(SOUND_URL[18]);
		}
		
		private function checkWin() : void
		{
			if(_curLvl >= (ROWS * COLS))
			{
				if(_soundManeger.isPlaying(SOUND_URL[18]))
					_soundManeger.stopSound(SOUND_URL[18]);
				_soundManeger.playSound(SOUND_URL[13]);
				_soundManeger.playSound(SOUND_URL[_curAnim]);
				
				_mainUI["mcCanvas"]["mcName"].visible = true;
				clearPool();
				_showGuidCon.parent.removeChild(_showGuidCon);
				_showGuidCon = null;
				_regularCon.parent.removeChild(_regularCon);
				_regularCon = null;
			}
		}
		
		private function clearPool() : void
		{
			var len : uint = _pieceList.length;
			if(len > 0)
			{
				for(var i : uint = 0; i < len; ++i)
					_pieceList[i] = null;
				_pieceList.splice(0, len);
			}
		}
		
		private function mc2Bitmap(mc : MovieClip) : Bitmap
		{
			var bm : Bitmap;
			var bmd : BitmapData = new BitmapData(mc.width, mc.height);
			bmd.draw(mc);
			bm = new Bitmap(bmd);
			
			return bm;
		}
		
		private function showPuzzle(bm : Bitmap) : void
		{
			if(bm == null)
				return;
			
			clearPool();
			
			var bmW : Number = bm.width;
			var bmH : Number = bm.height;
			var pieceW : Number = Math.round(bmW / ROWS);
			var pieceH : Number = Math.round(bmH / COLS);
			var piecesArray : Array = [];
			var offset : uint = 400;
			
			if(_showGuid)
			{
				if(_showGuidCon)
				{
					_showGuidCon.parent.removeChild(_showGuidCon);
					_showGuidCon = null;
				}
				_showGuidCon = new Sprite
				_mainUI["mcCanvas"].addChild(_showGuidCon);
			}
			if(_regularCon)
			{
				_regularCon.parent.removeChild(_regularCon);
				_regularCon = null;
			}
			_regularCon = new Sprite
			_mainUI["mcCanvas"].addChild(_regularCon);
			for (var i:uint = 0; i < ROWS; i++)
			{
				piecesArray[i] = new Array();
				for (var j:uint = 0; j < COLS; j++)
				{
					piecesArray[i][j] = new Object();
					piecesArray[i][j].right = Math.floor(Math.random() * 2);
					piecesArray[i][j].down = Math.floor(Math.random() * 2);
					if (j > 0)
					{
						piecesArray[i][j].up = 1 - piecesArray[i][j - 1].down;
					}
					if (i > 0)
					{
						piecesArray[i][j].left = 1 - piecesArray[i - 1][j].right;
					}
					var n:Number = j + i * COLS;
					if (_showGuid)
					{
						var pieceGuid:Piece = new Piece();
						_showGuidCon.addChild(pieceGuid);
						pieceGuid.init({
							image: bm.bitmapData, 
							i: i, j: j, 
							tileObj: piecesArray[i][j], 
							horizontalPieces: ROWS, verticalPieces: COLS, 
							x: i * pieceW + i, y: j * pieceH + j, 
							width: pieceW, height: pieceH, draggable: false});
					}
					var piece:Piece = new Piece();
					_regularCon.addChild(piece);
					piece.init({
						image: bm.bitmapData, 
						i: i, j: j, 
						tileObj: piecesArray[i][j], 
						horizontalPieces: ROWS, verticalPieces: COLS, 
						x: i * pieceW + i, y: j * pieceH + j, 
						width: pieceW, height: pieceH, draggable: true});
					
					_pieceList.push(piece);
				}
			}
			
			pieceTween();
		}
		
		private function pieceTween() : void
		{
			if(_pieceList.length < 0)
				return;
			
			var obj : Object;
			for(var i : uint = 0; i < _pieceList.length; ++i)
			{
				_canClick = false;
				obj = _pieceList[i].obj;
				if(obj.draggable)
				{
					TweenMax.to(_pieceList[i], .5, {x: Math.round(Math.random() * (obj.image.width - obj.width)) + 350,
						y: Math.round(Math.random() * (obj.image.height - obj.height)),
						delay: 1 + Math.random(),
						ease: Back.easeInOut,
						onComplete : onTweenCom
					});
					
					_pieceList[i].buttonMode = true;
				}
				else
				{
					_pieceList[i].mouseEnabled = false;
					_pieceList[i].mouseChildren = false;
				}
				
				_pieceList[i].addEventListener(MouseEvent.MOUSE_DOWN, onMyMouseDown);
			}
		}
		
		// 事件
		private function onShowMenu(e : MouseEvent) : void
		{
			if(_soundManeger.isPlaying(SOUND_URL[_curAnim]))
				_soundManeger.stopSound(SOUND_URL[_curAnim]);
			if(_soundManeger.isPlaying(SOUND_URL[17]))
				_soundManeger.stopSound(SOUND_URL[17]);
			if(!_soundManeger.isPlaying(SOUND_URL[18]))
				_soundManeger.playSound(SOUND_URL[18]);
			_soundManeger.playSound(SOUND_URL[15]);
			_soundManeger.playSound(SOUND_URL[16]);
			
			_mainUI["startCanvas"].visible = false;
			_mainUI["menuCanvas"].visible = true;
		}
		
		private function onShowStart(e : MouseEvent) : void
		{
			_soundManeger.playSound(SOUND_URL[15]);
			
			_mainUI["startCanvas"].visible = true;
			_mainUI["menuCanvas"].visible = false;
		}
		
		private function onItemClick(e : MouseEvent) : void
		{
			_soundManeger.playSound(SOUND_URL[15]);
			_soundManeger.playSound(SOUND_URL[17]);
			
			_curAnim = uint(e.currentTarget.name.split("_")[1]);
			_mainUI["menuCanvas"].visible = false;
			_mainUI["mcCanvas"].gotoAndStop(_curAnim + 1);
			_mainUI["mcCanvas"]["mcName"].visible = false;
			
			_curLvl = 0;
			_mainUI["txtNum"].text = _curLvl + "/" + ROWS * COLS;
			
			showPuzzle(_bmList[_curAnim]);
		}
		
		private function onTweenCom() : void
		{
			_canClick = true;
		}
		
		private function onMyMouseDown(e : MouseEvent) : void
		{
			if(!_canClick)
				return;
			_soundManeger.playSound(SOUND_URL[12]);
			
			_curId = _pieceList.indexOf(e.currentTarget as Piece);
			_pieceList[_curId].startDrag();
			_pieceList[_curId].parent.setChildIndex(_pieceList[_curId], _pieceList[_curId].parent.numChildren - 1);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onMyMouseUp);
		}
		
		private function onMyMouseUp(e : MouseEvent) : void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMyMouseUp);
			_pieceList[_curId].stopDrag();
			_pieceList[_curId].x = Math.round(_pieceList[_curId].x);
			_pieceList[_curId].y = Math.round(_pieceList[_curId].y);
			
			if(_pieceList[_curId].x < _pieceList[_curId].obj.x + _pieceList[_curId].gap / 2
				&& _pieceList[_curId].x > _pieceList[_curId].obj.x - _pieceList[_curId].gap / 2
				&& _pieceList[_curId].y < _pieceList[_curId].obj.y + _pieceList[_curId].gap / 2
				&& _pieceList[_curId].y > _pieceList[_curId].obj.y - _pieceList[_curId].gap / 2)
			{
				_soundManeger.playSound(SOUND_URL[14]);
				
				_pieceList[_curId].x = _pieceList[_curId].obj.x;
				_pieceList[_curId].y = _pieceList[_curId].obj.y;
				_pieceList[_curId].mouseEnabled = false;
				_pieceList[_curId].mouseChildren = false;
				_pieceList[_curId].parent.setChildIndex(_pieceList[_curId], 0);
				
				_curLvl++;
				_mainUI["txtNum"].text = _curLvl + "/" + ROWS * COLS;
				checkWin();
			}
		}
		
		private function addEvent() : void
		{
			_mainUI["startCanvas"]["btnStart"].addEventListener(MouseEvent.CLICK, onShowMenu);
			_mainUI["menuCanvas"]["btnHome"].addEventListener(MouseEvent.CLICK, onShowStart);
			_mainUI["btnHome"].addEventListener(MouseEvent.CLICK, onShowMenu);
			
			for(var i : uint = 0; i < 12; ++i)
				_mainUI["menuCanvas"]["btn_" + i].addEventListener(MouseEvent.CLICK, onItemClick);
		}
		
		private function removeEvent() : void
		{
			
		}
		
		private function destroy() : void
		{
			removeEvent();
			
			_mainUI = null;
		}
	}
}