package rabbitRecogAnimal
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.fscommand;
	
	import rabbitRecogAnimal.util.SoundManager;
	
	[SWF(backgroundColor="#000000", frameRate="30", width="1024", height="600")]
	public class RabbitRecogAnimalModule extends Sprite
	{
		private var _mainUI : MovieClip;
		
		// 鹅 鸡 驴 马 牛 羊 猪 猫 猴 鼠 兔 狗 鸭 海龟 海豚 老虎 大象 熊猫 鸽子 长颈鹿
		private const ANS_LIST : Array = [
			[4], [8], [10], [11], [12], [18], [19], [16], [1], [2], [3], [5], [17], 
			[26, 6], [26, 7], [25, 9], [13, 14], [15, 16], [23, 24], 
			[20, 21, 22]
		];
		private const ANS_POS : Array = [
			[new Point(270, 535)],
			[new Point(210, 535), new Point(318, 535)],
			[new Point(162, 535), new Point(270, 535), new Point(378, 535)]
		];
		private const ITEM_POS : Array = [
			[610, 150], [700, 150], [790, 150], [880, 150],
			[610, 240], [700, 240], [790, 240], [880, 240],
			[610, 330], [700, 330], [790, 330], [880, 330],
			[610, 420], [700, 420], [790, 420], [880, 420]
		];
		private const MIN_PAGE : uint = 1;
		private const MAX_PAGE : uint = 20;
		
		private var _winCnt : uint;
		private var _finPos : Point;
		private var _curId : uint;
		private var _curPage : uint;
		private var _isFirstEnter : Boolean;
		private var _itemPosList : Array = new Array(16);
		private var _resultList : Array = new Array(16);
		private var _srcList : Array = new Array(26);
		
		// 前20个序列与 ANS_LIST 相同
		// 后4个 bgm btn tips great
		private const SOUND_URL : Array = [
			"res/sound_1.mp3", "res/sound_2.mp3", "res/sound_3.mp3", "res/sound_4.mp3", "res/sound_5.mp3", "res/sound_6.mp3", "res/sound_7.mp3", "res/sound_8.mp3", "res/sound_9.mp3", "res/sound_10.mp3",
			"res/sound_11.mp3", "res/sound_12.mp3", "res/sound_13.mp3", "res/sound_14.mp3", "res/sound_15.mp3", "res/sound_16.mp3", "res/sound_17.mp3", "res/sound_18.mp3", "res/sound_19.mp3", "res/sound_20.mp3", 
			"res/sound_21.mp3", "res/sound_22.mp3", "res/sound_23.mp3", "res/sound_24.mp3"
		];
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		public function RabbitRecogAnimalModule()
		{
			_mainUI = new RabbitRecogAnimalModuleUI();
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
			_mainUI["overCanvas"].visible = false;
			_mainUI["mcMov"].visible = false;
			_mainUI["mcMov"].gotoAndStop(1);
			_mainUI["mcTips"].visible = false;
			_mainUI["mcTips"].gotoAndStop(1);
			_isFirstEnter = true;
			
			var i : uint, pos : Point;
			for(i = 0; i < _srcList.length; ++i)
				_srcList[i] = i + 1;
			for(i = 0; i < _resultList.length; ++i)
			{
				setMouseMode(_mainUI["mcWords"]["mcItem_" + i], false);
				pos = new Point(_mainUI["mcWords"]["mcItem_" + i].x, _mainUI["mcWords"]["mcItem_" + i].y);
				_itemPosList[i] = pos;
			}
			
			setup();
			_soundManager.playSound(SOUND_URL[20]);
		}
		
		private function setup() : void
		{
			_curPage = 1;
			_mainUI["btnPre"].visible = false;
			show();
		}
		
		private function show() : void
		{
			_mainUI["mcPics"].gotoAndStop(_curPage);
			_mainUI["mcAns"].visible = false;
			_mainUI["mcAns"].gotoAndStop(_curPage);
			_winCnt = 0;
			setupWord();
		}
		
		private function gameStart() : void
		{
			_soundManager.playSound(SOUND_URL[21]);
			_mainUI["startCanvas"].visible = false;	
		}
		
		private function setupWord() : void
		{
			var i : uint, j : uint;
			var cnt : uint = 0;
			var ansLen : uint = ANS_LIST[_curPage - 1].length;
			
			_srcList = randArr(_srcList);
			
			for(i = 0; i < ansLen; ++i)
				_resultList[i] = ANS_LIST[_curPage - 1][i];
			for(; i < _resultList.length; ++i)
			{
				for(j = 0; j < ansLen; ++j)
				{
					if(ANS_LIST[_curPage - 1][j] == _srcList[cnt])
						cnt++;
				}
				_resultList[i] = _srcList[cnt++];
			}
			
			_resultList = randArr(_resultList);
			
			for(i = 0; i < _resultList.length; ++i)
			{
				_mainUI["mcWords"]["mcItem_" + i].x = ITEM_POS[i][0];
				_mainUI["mcWords"]["mcItem_" + i].y = ITEM_POS[i][1];
				_mainUI["mcWords"]["mcItem_" + i].gotoAndStop(_resultList[i]);
				if(_mainUI["mcWords"]["mcItem_" + i].buttonMode == false)
					setMouseMode(_mainUI["mcWords"]["mcItem_" + i], true);
				if(!_mainUI["mcWords"]["mcItem_" + i]["mcBG"].visible)
					_mainUI["mcWords"]["mcItem_" + i]["mcBG"].visible = true;
			}
		}
		
		private function randArr(arr : Array) : Array
		{
			var i : uint, temp : uint, id : uint;
			for(i = 0; i < arr.length; ++i)
			{
				id = uint(Math.random() * arr.length);
				temp = arr[i];
				arr[i] = arr[id];
				arr[id] = temp;
			}
			return arr;
		}
		
		private function setMouseMode(mc : MovieClip, flag : Boolean) : void
		{
			mc.buttonMode = flag;
			mc.mouseChildren = flag;
			mc.mouseEnabled = flag;
		}
		
		private function isRight() : Boolean
		{
			var result : Boolean = false;
			var index : uint = _curPage <= 13? 0 : _curPage <= 19? 1 : 2;
			var item : MovieClip = _mainUI["mcWords"]["mcItem_" + _curId];
			var ansArr : Array = ANS_LIST[_curPage - 1];
			var posArr : Array = ANS_POS[index];
			for(var i : uint = 0; i < ansArr.length; ++i)
			{
				for(var j : uint = 0; j < posArr.length; ++j)
				{
					if(item.currentFrame == ansArr[i] && rectHit(item, posArr[j]) && i == j)
					{
						_finPos = posArr[j];
						result = true;
						break;
					}
				}
			}
			
			return result;
		}
		
		private function rectHit(item : MovieClip, pos : Point) : Boolean
		{
			var result : Boolean = false;
			if(Math.abs(item.x - pos.x) < item.width / 2 && Math.abs(item.y - pos.y) < item.height / 2)
				result = true;
			
			return result;
		}
		
		// 事件
		private function onGameStart(e : MouseEvent) : void
		{
			gameStart();
			
			if(_isFirstEnter)
			{
				_soundManager.playSound(SOUND_URL[22]);
				
				_isFirstEnter = false;
				_mainUI["mcTips"].visible = true;
				_mainUI["mcTips"].gotoAndPlay(1);
			}
		}
		
		private function onGameOver(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[21]);
			_mainUI["startCanvas"].visible = true;
			_mainUI["overCanvas"].visible = false;
			setup();
		}
		
		private function onAnsSound(e : MouseEvent) : void
		{
			if(!_soundManager.isPlaying(SOUND_URL[_curPage - 1]))
				_soundManager.playSound(SOUND_URL[_curPage - 1]);
		}
		
		private function onTipsHide(e : MouseEvent) : void
		{
			_mainUI["mcTips"].visible = false;
			_mainUI["mcTips"].gotoAndStop(1);
			if(_soundManager.isPlaying(SOUND_URL[22]))
				_soundManager.stopSound(SOUND_URL[22]);
		}
		
		private function onPagePre(e : MouseEvent) : void
		{
			if(_curPage > MIN_PAGE)
			{
				_soundManager.playSound(SOUND_URL[21]);
				_curPage--;
				show();
				if(_curPage <= MIN_PAGE)
					_mainUI["btnPre"].visible = false;
			}
		}
		
		private function onPageNext(e : MouseEvent) : void
		{
			if(_curPage < MAX_PAGE)
			{
				_soundManager.playSound(SOUND_URL[21]);
				_curPage++;
				show();
				if(!_mainUI["btnPre"].visible)
					_mainUI["btnPre"].visible = true;
				if(_curPage >= MAX_PAGE)
					_mainUI["overCanvas"].visible = true;
			}
		}
		
		private function onItemDown(e : MouseEvent) : void
		{
			_curId = uint(e.currentTarget.name.split("_")[1]);
			_mainUI["mcWords"]["mcItem_" + _curId].startDrag();
			_mainUI["mcWords"]["mcItem_" + _curId]["mcBG"].visible = false;
			
			var max : uint = 0;
			var index : uint;
			for(var i : uint = 0; i < _resultList.length; ++i)
			{
				index = _mainUI["mcWords"].getChildIndex(_mainUI["mcWords"]["mcItem_" + i]);
				max = index > max? index : max;
			}
			_mainUI["mcWords"].setChildIndex(_mainUI["mcWords"]["mcItem_" + _curId], max);
		}
		
		private function onItemUp(e : MouseEvent) : void
		{
			_mainUI["mcWords"]["mcItem_" + _curId].stopDrag();
			if(isRight())
			{
				_mainUI["mcWords"]["mcItem_" + _curId].x = _finPos.x;
				_mainUI["mcWords"]["mcItem_" + _curId].y = _finPos.y;
				setMouseMode(_mainUI["mcWords"]["mcItem_" + _curId], false);
				
				_winCnt++;
				if(_winCnt >= ANS_LIST[_curPage - 1].length)
				{
					_soundManager.playSound(SOUND_URL[23]);
					_mainUI["mcMov"].visible = true;
					_mainUI["mcMov"].gotoAndPlay(1);
					_mainUI["mcMov"].addEventListener(Event.ENTER_FRAME, onMovFrame);
				}
			}
			else
			{
				_mainUI["mcWords"]["mcItem_" + _curId].x = _itemPosList[_curId].x;
				_mainUI["mcWords"]["mcItem_" + _curId].y = _itemPosList[_curId].y;
				_mainUI["mcWords"]["mcItem_" + _curId]["mcBG"].visible = true;
			}
		}
		
		private function onMovFrame(e : Event) : void
		{
			if(_mainUI["mcMov"].currentFrame == _mainUI["mcMov"].totalFrames)
			{
				_mainUI["mcMov"].removeEventListener(Event.ENTER_FRAME, onMovFrame);
				_mainUI["mcMov"].gotoAndStop(1);
				_mainUI["mcMov"].visible = false;
				
				_mainUI["mcAns"].visible = true;
				_soundManager.playSound(SOUND_URL[_curPage - 1]);
			}
		}
		
		private function addEvent() : void
		{
			_mainUI["startCanvas"]["btnStart"].addEventListener(MouseEvent.CLICK, onGameStart);
			_mainUI["btnHome"].addEventListener(MouseEvent.CLICK, onGameOver);
			_mainUI["btnPre"].addEventListener(MouseEvent.CLICK, onPagePre);
			_mainUI["btnNext"].addEventListener(MouseEvent.CLICK, onPageNext);
			_mainUI["overCanvas"]["btnOver"].addEventListener(MouseEvent.CLICK, onGameOver);
			_mainUI["mcAns"]["btnSound"].addEventListener(MouseEvent.CLICK, onAnsSound);
			_mainUI["mcTips"]["btnClose"].addEventListener(MouseEvent.CLICK, onTipsHide);
			
			for(var i : uint = 0; i < _resultList.length; ++i)
			{
				_mainUI["mcWords"]["mcItem_" + i].addEventListener(MouseEvent.MOUSE_DOWN, onItemDown);
				_mainUI["mcWords"]["mcItem_" + i].addEventListener(MouseEvent.MOUSE_UP, onItemUp);
			}
		}
		
		private function removeEvent() : void
		{
			_mainUI["startCanvas"]["btnStart"].removeEventListener(MouseEvent.CLICK, onGameStart);
			_mainUI["btnHome"].removeEventListener(MouseEvent.CLICK, onGameOver);
			_mainUI["btnPre"].removeEventListener(MouseEvent.CLICK, onPagePre);
			_mainUI["btnNext"].removeEventListener(MouseEvent.CLICK, onPageNext);
			_mainUI["overCanvas"]["btnOver"].removeEventListener(MouseEvent.CLICK, onGameOver);
			_mainUI["mcAns"]["btnSound"].removeEventListener(MouseEvent.CLICK, onAnsSound);
			_mainUI["mcTips"]["btnClose"].removeEventListener(MouseEvent.CLICK, onTipsHide);
			
			for(var i : uint = 0; i < _resultList.length; ++i)
			{
				_mainUI["mcWords"]["mcItem_" + i].removeEventListener(MouseEvent.MOUSE_DOWN, onItemDown);
				_mainUI["mcWords"]["mcItem_" + i].removeEventListener(MouseEvent.MOUSE_UP, onItemUp);
			}
		}
		
		private function destroy() : void
		{
			removeEvent();
			
			
			_mainUI = null;
		}
	}
}