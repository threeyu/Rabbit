package rabbitTidyRoom
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.fscommand;
	
	import rabbitTidyRoom.util.SoundManager;
	
	[SWF(backgroundColor="#000000", frameRate="30", width="1024", height="600")]
	public class RabbitTidyRoomModule extends Sprite
	{
		private var _mainUI : MovieClip;
		
		// 电脑 椅子 台灯 花瓶 相册 书籍 
		// 皇冠 喇叭 招财猫 帽子 糖果 小熊 急救箱
		private const POS_FIX : Array = [[95, 318], [170, 400], [170, 285], [764, 365], [741, 80], [237, 283]];
		private const POS_NON : Array = [[413, 135], [475, 100], [412, 253], [475, 228], [660, 171], [333, 412], [825, 220]];
		private const MAX_NUM : uint = 13;
		private var _curLvl : uint;
		private var _lvlCnt : uint;
		private var _itemList : Array = new Array(MAX_NUM);
		private var _numList : Array = [];
		
		private var _numFix : uint;
		private var _numNon : uint;
		private var _fixList : Array;
		private var _nonList : Array;
		
		private var _curItem : MovieClip;
		private var _curX : Number;
		private var _curY : Number;
		
		// right btn wrong good bgm tips
		private const SOUND_URL : Array = ["res/sound_1.mp3", "res/sound_2.mp3", "res/sound_3.mp3", "res/sound_4.mp3", "res/sound_5.mp3", "res/sound_6.mp3"];
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		public function RabbitTidyRoomModule()
		{
			_mainUI = new RabbitTidyRoomModuleUI();
			this.addChild(_mainUI);
			
			initData();
			addEvent();
			_soundManager.playSound(SOUND_URL[4]);
			_mainUI.addEventListener(Event.DEACTIVATE, onDeactivate);
		}
		private function onDeactivate(e : Event) : void
		{
			fscommand("quit");
		}
		
		private function initData() : void
		{
			setup();
			
			for(var i : uint = 0; i < MAX_NUM; ++i)
			{
				_itemList[i] = new FurnUI();
				_itemList[i].gotoAndStop(i + 1);
			}
			
			initPlan();
		}
		
		private function setup() : void
		{
			_curLvl = 2;
			_lvlCnt = 0;
			
			_mainUI["mcMov"].visible = false;
			_mainUI["mcMov"].gotoAndStop(1);
		}
		
		private function showItemByLvl() : void
		{
			_mainUI["mcMenu"].visible = true;
			
			var i : uint = _curLvl - 2;
			var j : uint = Math.floor((Math.random() * _numList[i].length));
			_numFix = _numList[i][j].numFix;
			_numNon = _numList[i][j].numNon;
			
			_fixList = chaosSortByArr(_itemList, 0, POS_FIX.length);
			_nonList = chaosSortByArr(_itemList, POS_FIX.length, _itemList.length);
			var id : uint;
			for(i = 0; i < _numFix; ++i)
			{
				id = _fixList[i].currentFrame - 1;
				_fixList[i].x = POS_FIX[id][0];
				_fixList[i].y = POS_FIX[id][1];
				_fixList[i]["arrow"].visible = true;
				setItemEnabled(_fixList[i], false);
				_mainUI["mcMenu"].addChild(_fixList[i]);
			}
			for(i = 0; i < _numNon; ++i)
			{
				id = _nonList[i].currentFrame - 1 - POS_FIX.length;
				_nonList[i].x = POS_NON[id][0];
				_nonList[i].y = POS_NON[id][1];
				_nonList[i]["arrow"].visible = true;
				setItemEnabled(_nonList[i], false);
				_mainUI["mcMenu"].addChild(_nonList[i]);
			}
		}
		
		private function removeItemFromMc(canvas : MovieClip) : void
		{
			for(var i : uint = 0; i < _itemList.length; ++i)
				if(_itemList[i].parent == canvas)
					canvas.removeChild(_itemList[i]);
		}
		
		private function setItemEnabled(mc : MovieClip, flag : Boolean) : void
		{
			mc.buttonMode = flag;
			mc.mouseChildren = flag;
			mc.mouseEnabled = flag;
		}
		
		private function chaosSortByArr(arr : Array, startIdx : uint, endIdx : uint) : Array
		{
			var result : Array = arr.slice(startIdx, endIdx);
			var temp : MovieClip, id : uint;
			
			for(var i : uint = 0; i < result.length; ++i)
			{
				id = uint(Math.random() * result.length);
				temp = result[i];
				result[i] = result[id];
				result[id] = temp;
			}
			
			return result;
		}
		
		// _mainUI 中排序
		private function sortItem() : void
		{
			var max : int = 0;
			var index : int;
			for(var i : uint = 0; i < MAX_NUM; ++i)
			{
				if(_itemList[i].parent)
				{
					index = _itemList[i].parent.getChildIndex(_itemList[i]);
					if(index > max)
						max = index;	
				}
			}
			_curItem.parent.setChildIndex(_curItem, max);
		}
		
		private function rectHit() : Boolean
		{
			var result : Boolean = false;
			var id : uint = _curItem.currentFrame < 7? _curItem.currentFrame - 1 : _curItem.currentFrame - POS_FIX.length - 1;
			var arr : Array = _curItem.currentFrame < 7? POS_FIX : POS_NON;
			
			if(Math.abs(_curItem.x - arr[id][0]) < _curItem.width / 2 && Math.abs(_curItem.y - arr[id][1]) < _curItem.height / 2)
				result = true;
			
			return result;
		}
		
		// 初始化所有方案情况
		private function initPlan() : void
		{
			var a : uint, b : uint;
			for(var i : uint = 2; i <= MAX_NUM; ++i)
			{
				a = i < 9? 1 : (i - 7);
				b = i - a;
				var obj : Object = new Object();
				var arr : Array = [];
				obj.numFix = a;
				obj.numNon = b;
				arr.push(obj);
				while(a <= i - 2 && a < 6)
				{
					a++;
					b = i - a;
					obj = new Object();
					obj.numFix = a;
					obj.numNon = b;
					arr.push(obj);
				}
				_numList.push(arr);
			}
		}
		
		// 事件
		private function onShowMenu(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[1]);
			if(_soundManager.isPlaying(SOUND_URL[4]))
				_soundManager.stopSound(SOUND_URL[4]);
			_soundManager.playSound(SOUND_URL[5]);
			
			_mainUI["startCanvas"].visible = false;
			
			// show menu and add item by lvl
			showItemByLvl();
		}
		
		private function onGameOver(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[1]);
			if(_soundManager.isPlaying(SOUND_URL[5]))
				_soundManager.stopSound(SOUND_URL[5]);
			
			_mainUI["startCanvas"].visible = true;
			
			// hide and remove item
			removeItemFromMc(_mainUI["mcMenu"]);
			removeItemFromMc(_mainUI["mcCanvas"]);
			setup();
		}
		
		private function onRefresh(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[1]);
			
			if(!_mainUI["mcMenu"].visible)
				setup();
			
			removeItemFromMc(_mainUI["mcMenu"]);
			removeItemFromMc(_mainUI["mcCanvas"]);
			showItemByLvl();
		}
		
		private function onGameStart(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[1]);
			if(_soundManager.isPlaying(SOUND_URL[5]))
				_soundManager.stopSound(SOUND_URL[5]);
			if(!_soundManager.isPlaying(SOUND_URL[4]))
				_soundManager.playSound(SOUND_URL[4], 0, 999);
			
			_mainUI["mcMenu"].visible = false;
			removeItemFromMc(_mainUI["mcMenu"]);
			
			// show item on _mainUI
			var i : uint, id : uint;
			for(i = 0; i < _numFix; ++i)
			{
				id = _fixList[i].currentFrame - 1;
				_fixList[i].x = 70 + _fixList[i].width / 2 + (i * 70);
				_fixList[i].y = 530;
				_fixList[i]["arrow"].visible = false;
				setItemEnabled(_fixList[i], true);
				_mainUI["mcCanvas"].addChild(_fixList[i]);
			}
			for(i = 0; i < _numNon; ++i)
			{
				id = _nonList[i].currentFrame - 1 - POS_FIX.length;
				_nonList[i].x = _fixList[_numFix - 1].x + ((i + 1) * 65);
				_nonList[i].y = 530;
				_nonList[i]["arrow"].visible = false;
				setItemEnabled(_nonList[i], true);
				_mainUI["mcCanvas"].addChild(_nonList[i]);
			}
		}
		
		private function onItemDown(e : MouseEvent) : void
		{
			_curItem = e.currentTarget as MovieClip;
			_curX = _curItem.x;
			_curY = _curItem.y;
			_curItem.startDrag();
			sortItem();
		}
		
		private function onItemUp(e : MouseEvent) : void
		{
			_curItem.stopDrag();
			
			var id : uint = _curItem.currentFrame < 7? _curItem.currentFrame - 1 : _curItem.currentFrame - POS_FIX.length - 1;
			var arr : Array = _curItem.currentFrame < 7? POS_FIX : POS_NON;
			
			if(rectHit())
			{
				_soundManager.playSound(SOUND_URL[0]);
				_curItem.x = arr[id][0];
				_curItem.y = arr[id][1];
				setItemEnabled(_curItem, false);
				_lvlCnt++;
				if(_lvlCnt == _curLvl)
				{
					_soundManager.playSound(SOUND_URL[3]);
					_curLvl < MAX_NUM? _curLvl++ : MAX_NUM;
					_lvlCnt = 0;
					
					_mainUI["mcMov"].visible = true;
					_mainUI["mcMov"].gotoAndPlay(1);
					_mainUI["mcMov"].addEventListener(Event.ENTER_FRAME, onMovFrame);
				}
			}
			else
			{
				_soundManager.playSound(SOUND_URL[2]);
				_curItem.x = _curX;
				_curItem.y = _curY;
			}
		}
		
		private function onMovFrame(e : Event) : void
		{
			if(_mainUI["mcMov"].currentFrame == _mainUI["mcMov"].totalFrames)
			{
				_mainUI["mcMov"].removeEventListener(Event.ENTER_FRAME, onMovFrame);
				_mainUI["mcMov"].gotoAndStop(1);
				_mainUI["mcMov"].visible = false;
				
				
				removeItemFromMc(_mainUI["mcCanvas"]);
				showItemByLvl();
			}
		}
		
		private function addEvent() : void
		{
			_mainUI["startCanvas"]["btnStart"].addEventListener(MouseEvent.CLICK, onShowMenu);
			_mainUI["btnHome"].addEventListener(MouseEvent.CLICK, onGameOver);
			_mainUI["btnRefrash"].addEventListener(MouseEvent.CLICK, onRefresh);
			_mainUI["mcMenu"]["btnStart"].addEventListener(MouseEvent.CLICK, onGameStart);
			
			for(var i : uint = 0; i < MAX_NUM; ++i)
			{
				_itemList[i].addEventListener(MouseEvent.MOUSE_DOWN, onItemDown);
				_itemList[i].addEventListener(MouseEvent.MOUSE_UP, onItemUp);
			}
		}
		
		private function removeEvent() : void
		{
			_mainUI["startCanvas"]["btnStart"].removeEventListener(MouseEvent.CLICK, onShowMenu);
			_mainUI["btnHome"].removeEventListener(MouseEvent.CLICK, onGameOver);
			_mainUI["btnRefrash"].removeEventListener(MouseEvent.CLICK, onRefresh);
			_mainUI["mcMenu"]["btnStart"].removeEventListener(MouseEvent.CLICK, onGameStart);
			
			for(var i : uint = 0; i < MAX_NUM; ++i)
			{
				_itemList[i].removeEventListener(MouseEvent.MOUSE_DOWN, onItemDown);
				_itemList[i].removeEventListener(MouseEvent.MOUSE_UP, onItemUp);
			}
		}
		
		private function destroy() : void
		{
			removeEvent();
			
			_mainUI = null;
		}
	}
}