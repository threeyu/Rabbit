package rabbitXXL
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.fscommand;
	import flash.utils.setTimeout;
	
	import rabbitXXL.util.SoundManager;
	import rabbitXXL.vo.RectMC;
	import rabbitXXL.vo.RectMCManager;
	
	
	[SWF(backgroundColor="#000000", frameRate="30", width="1024", height="600")]
	public class RabbitXXLModule extends Sprite
	{
		private var _mainUI : MovieClip;
		private const COLS : uint = 9;
		private const ROWS : uint = 7;
		private const CELL_WIDTH : Number = 77.5;
		private const CELL_HEIGHT : Number = 77;
		private var _itemNum : uint;
		private var _score : uint;
		private var _curLvl : uint;
		private var _speed : uint;
		private var _spaceTime : uint;
		private var _doubleFlag : Boolean;
		private var _doubleTime : uint;
		private var _scoreBase : uint;
		
		private var _itemList : Array;
		private var _itemManager : RectMCManager;
		private var _curItem : RectMC;
		private var _preItem : RectMC;
		
		private var _timeCnt : uint;
		private var _isPause : Boolean;
		private var _isFirst : Boolean;
		
		// wrong tab right btn back bgm tips gameover gamestart
		private const SOUND_URL : Array = ["res/sound_1.mp3", "res/sound_2.mp3", "res/sound_3.mp3", "res/sound_4.mp3", "res/sound_5.mp3", "res/sound_6.mp3", "res/sound_7.mp3", "res/sound_8.mp3", "res/sound_9.mp3"];
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		public function RabbitXXLModule()
		{
			_mainUI = new RabbitXXLModuleUI();
			this.addChild(_mainUI);
			
			initData();
			addEvent();
			
			_soundManager.playSound(SOUND_URL[5]);
			_mainUI.addEventListener(Event.DEACTIVATE, onDeactivate);
		}
		private function onDeactivate(e : Event) : void
		{
			fscommand("quit");
		}
		
		private function initData() : void
		{
			_itemList = new Array(ROWS);
			for(var i : uint = 0; i < _itemList.length; ++i)
				_itemList[i] = new Array(COLS);
			
			_itemManager = RectMCManager.getInstance();
			
			_isFirst = true;
			_mainUI["tipsCanvas"].visible = false;
			_mainUI["tipsCanvas"].gotoAndStop(1);
			
			setup();
		}
		
		private function setup() : void
		{
			_isPause = true;
			
			_curItem = _preItem = null;
			
			_mainUI["startCanvas"].visible = true;
			_mainUI["mcMov"].gotoAndStop(1);
			_mainUI["mcMov"].visible = false;
			_mainUI["overCanvas"].visible = false;
			_mainUI["overCanvas"]["mcMov"].gotoAndStop(1);
			
			_itemNum = 0;
			_score = 0;
			_curLvl = 0;
			_speed = 2;
			_spaceTime = 75;
			_doubleFlag = false;
			
			_mainUI["txtScore"].text = _score;
			_mainUI["txtLvl"].text = _curLvl;
			
			// _itemList 清零
			for(var i : uint = 0; i < ROWS; ++i)
			{
				for(var j :uint = 0; j < COLS; ++j)
				{
					if(_itemList[i][j])
					{
						_mainUI["mcCanvas"].removeChild(_itemList[i][j]);
						_itemList[i][j] = null;
					}
				}
			}
			
			// 初始化最后一行 item
			var item : RectMC;
			for(j = 0; j < COLS; ++j)
			{
				item = _itemManager.pop(new RectMC());
				item.x = j * CELL_WIDTH;
				item.y = (ROWS - 1) * CELL_HEIGHT;
				item.posX = ROWS - 1;
				item.posY = j;
				item.num = getRandNum();
				item.isSelect = false;
				_mainUI["mcCanvas"].addChild(item);
				
				_itemList[ROWS - 1][j] = item;
				item.addEventListener(MouseEvent.CLICK, onItemClick);
			}
		}
		
		private function realStart() : void
		{
			if(_soundManager.isPlaying(SOUND_URL[6]))
				_soundManager.stopSound(SOUND_URL[6]);
			_soundManager.playSound(SOUND_URL[8]);
			
			_mainUI["startCanvas"].visible = false;
			
			_mainUI["mcMov"].visible = true;
			_mainUI["mcMov"].gotoAndPlay(1);
			_mainUI["mcMov"].addEventListener(Event.ENTER_FRAME, onGameStartFrame);
		}
		
		private function createItem() : void
		{
			var randCol : uint = getRandNum() - 1;
			if(_itemList[0][randCol] == null)
			{
				var item : RectMC = _itemManager.pop(new RectMC());
				item.x = randCol * CELL_WIDTH;
				item.y = -110;
				item.posX = 0;
				item.posY = randCol;
				item.num = getRandNum();
				item.isSelect = false;
				_mainUI["mcCanvas"].addChild(item);
				
				_itemList[0][randCol] = item;
				item.addEventListener(MouseEvent.CLICK, onItemClick);
				
				_itemNum++;
				updateLvl();
			}
			else
			{
				_soundManager.playSound(SOUND_URL[7]);
				_isPause = true;
				_mainUI["overCanvas"].visible = true;
				_mainUI["overCanvas"]["mcMov"].gotoAndPlay(1);
				_mainUI["overCanvas"]["mcMov"]["mc"]["txtScore"].text = _score;
			}
		}
		
		private function updateScore() : void
		{
			_doubleFlag = true;
			
			if(_doubleTime > 0)
				_scoreBase += 10;
			else
				_scoreBase = 10;
			
			_score += _scoreBase;
			_mainUI["txtScore"].text = _score;
			
			_doubleTime = 60;
		}
		
		private function updateLvl() : void
		{
			switch(_itemNum)
			{
				case 25:
					lvlFunc(1, 2, 60);
					break;
				case 50:
					lvlFunc(2, 4, 50);
					break;
				case 75:
					lvlFunc(3, 8, 30);
					break;
				case 125:
					lvlFunc(4, 16, 25);
					break;
			}
		}
		private function lvlFunc(lvl : uint, speed : uint, spaceTime : uint) : void
		{
			_curLvl = lvl;
			_mainUI["txtLvl"].text = _curLvl;
			_speed = speed;
			_spaceTime = spaceTime;
		}
		
		private function getRandNum(min : uint = 1, max : uint = 100) : uint
		{
			var num : uint = uint(Math.floor(Math.random() * (max - min + 1)) + min);
			return num % 9 + 1;// 随机返回1-9
		}
		
		// 数学判断
		private function calculaFunc(num1 : uint, num2 : uint) : Boolean
		{
			var sum : uint = num1 + num2;
			var dec : uint = uint(Math.abs(num1 - num2));
			if(sum == 5 || sum == 10 || dec == 5)
				return true;
			return false;
		}
		
		// 事件
		private function onGameStart(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[3]);
			if(_isFirst)
			{
				_soundManager.playSound(SOUND_URL[6]);
				_isFirst = false;
				_mainUI["startCanvas"].visible = false;
				_mainUI["tipsCanvas"].visible = true;
				_mainUI["tipsCanvas"].gotoAndPlay(1);
			}
			else
			{
				_mainUI["tipsCanvas"].visible = false;
				_mainUI["tipsCanvas"].gotoAndStop(1);
				realStart();
			}
		}
		
		private function onGameOver(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[3]);
			setup();
		}
		
		private function onAgain(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[3]);
			setup();
			realStart();
		}
		
		private function onHome(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[3]);
			setup();
		}
		
		private function onGameStartFrame(e : Event) : void
		{
			if(_mainUI["mcMov"].currentFrame == _mainUI["mcMov"].totalFrames)
			{
				_mainUI["mcMov"].removeEventListener(Event.ENTER_FRAME, onGameStartFrame);
				_mainUI["mcMov"].gotoAndStop(1);
				_mainUI["mcMov"].visible = false;
				
				_isPause = false;
			}
		}
		
		private function onItemClick(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[1]);
			var item : RectMC = e.currentTarget as RectMC;
			var i : uint, j : uint;
			
			_curItem = item;
			if(_preItem && _preItem != _curItem)
			{
				var preNum : uint = _preItem.num;
				var curNum : uint = _curItem.num;
				if(calculaFunc(curNum, preNum))// 可消除
				{
					_soundManager.playSound(SOUND_URL[2]);
					_preItem.bomb();
					_curItem.bomb();
					
					updateScore();
					
					setTimeout(function() : void
					{
						_curItem.isSelect = true;
						
						_itemManager.push(_preItem);
						_itemManager.push(_curItem);
						_mainUI["mcCanvas"].removeChild(_preItem);
						_mainUI["mcCanvas"].removeChild(_curItem);
						_itemList[_preItem.posX][_preItem.posY] = null;
						_itemList[_curItem.posX][_curItem.posY] = null;
						
						_preItem = _curItem = null;
						for(i = 0; i < ROWS; ++i)
							for(j = 0; j < COLS; ++j)
								if(_itemList[i][j])
									_itemList[i][j].isSelect = false;
					}, 200);
					return;
				}
			}
			_preItem = _curItem;
			
			for(i = 0; i < ROWS; ++i)
				for(j = 0; j < COLS; ++j)
					if(_itemList[i][j])
						_itemList[i][j].isSelect = false;
			item.isSelect = true;
		}
		
		private function onFrame(e : Event) : void
		{
			if(_isPause)
				return;
			
			_timeCnt++;
			if(_timeCnt >= _spaceTime)
			{
				_timeCnt = 0;
				createItem();
			}
			
			// 下落
			var i : uint;
			var j : uint;
			for(i = 1; i < ROWS; ++i)
			{
				for(j = 0; j < COLS; ++j)
				{
					if(_itemList[i][j] == null)
					{
						_itemList[i][j] = _itemList[i - 1][j];
						_itemList[i - 1][j] = null;
						if(_itemList[i][j])
							_itemList[i][j].posX++;
					}
				}
			}
			for(i = 0; i < ROWS; ++i)
			{
				for(j = 0; j < COLS; ++j)
				{
					if(_itemList[i][j])
					{
						if(_itemList[i][j].y < _itemList[i][j].posX * CELL_HEIGHT)
							_itemList[i][j].y += _speed;
						else
							_itemList[i][j].y = _itemList[i][j].posX * CELL_HEIGHT;
					}
				}
			}
			
			// 得分控制
			if(_doubleFlag)
			{
				_doubleTime--;
				if(_doubleTime <= 0)
				{
					_doubleTime = 0;
					_doubleFlag = false;
				}
			}
		}
		
		
		private function addEvent() : void
		{
			_mainUI["startCanvas"]["btnStart"].addEventListener(MouseEvent.CLICK, onGameStart);
			_mainUI["btnHome"].addEventListener(MouseEvent.CLICK, onGameOver);
			_mainUI["overCanvas"]["mcMov"]["mc"]["btnAgain"].addEventListener(MouseEvent.CLICK, onAgain);
			_mainUI["overCanvas"]["mcMov"]["mc"]["btnHome"].addEventListener(MouseEvent.CLICK, onHome);
			_mainUI["tipsCanvas"]["btnClose"].addEventListener(MouseEvent.CLICK, onGameStart);
			
			_mainUI.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function removeEvent() : void
		{
			_mainUI["startCanvas"]["btnStart"].removeEventListener(MouseEvent.CLICK, onGameStart);
			_mainUI["btnHome"].removeEventListener(MouseEvent.CLICK, onGameOver);
			_mainUI["overCanvas"]["mcMov"]["mc"]["btnHome"].removeEventListener(MouseEvent.CLICK, onHome);
			_mainUI["tipsCanvas"]["btnClose"].removeEventListener(MouseEvent.CLICK, onGameStart);
			
			_mainUI.removeEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function destroy() : void
		{
			removeEvent();
			
			
			_mainUI = null;
		}
	}
}