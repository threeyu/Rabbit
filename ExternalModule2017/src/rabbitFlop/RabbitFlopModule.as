package rabbitFlop
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.fscommand;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import rabbitFlop.vo.Card;
	
	
	
	[SWF(backgroundColor="#000000", frameRate="30", width="1024", height="600")]
	public class RabbitFlopModule extends Sprite
	{
		private var _mainUI : MovieClip;
		private var _itemList : Array = [];
		private var _timer : Timer;
		private var _mode : uint;
		private const POS_X : Array = [350, 300, 220];
		private const POS_Y : Array = [220, 160, 75];
		
		private var _canClick : Boolean;
		private var _curItem : rabbitFlop.vo.Card;
		private var _preItem : Card;
		private var _score : int;
		
		private var _firstEnter : Boolean;
		
		public function RabbitFlopModule()
		{
			_mainUI = new RabbitFlopModuleUI();
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
			_mainUI["mcTips"].visible = false;
			_mainUI["mcTips"].gotoAndStop(1);
			
			
			for(var i : uint = 0; i < 20; i += 2)
			{
				_itemList[i] = new Card(i / 2 + 1);
				_itemList[i + 1] = new Card(i / 2 + 1);
			}
			
			_timer = new Timer(1000);
			
			_canClick = false;
			_firstEnter = false;
		}
		
		private function setup() : void
		{
			_timer.reset();
			_mainUI["startCanvas"].visible = false;
			_mainUI["overCanvas"].visible = false;
			updateScore(true, false);
			gameStart();
		}
		
		private function gameStart() : void
		{
			var cnt : uint = _mode == 0? 5 : _mode == 1? 10 : 15;
			_timer.repeatCount = cnt;
			_timer.start();
			
			showItem();
			_canClick = false;
		}
		
		private function showItem() : void
		{
			_mainUI["mcCanvas"].visible = true;
			var itemNum : uint = _mode == 0? 6 : _mode == 1? 12 : 20;
			var i : uint;
			var w : Number = _itemList[0].width + 8;
			var h : Number = _itemList[0].height + 8;
			var arr : Array = chaosSortByArr(_itemList, itemNum);
			
			switch(itemNum)
			{
				case 6:// 2 * 3
					for(i = 0; i < itemNum; ++i)
					{
						arr[i].x = i < 3? POS_X[_mode] + i * w : POS_X[_mode] + (i - 3) * w;
						arr[i].y = i < 3? POS_Y[_mode] : POS_Y[_mode] + h;
						arr[i].flop();
						arr[i].setMouseEnabled(true);
						_mainUI["mcCanvas"].addChild(arr[i]);
					}
					break;
				case 12:// 3 * 4
					for(i = 0; i < itemNum; ++i)
					{
						arr[i].x = i < 4? POS_X[_mode] + i * w : i < 8? POS_X[_mode] + (i - 4) * w : POS_X[_mode] + (i - 8) * w;
						arr[i].y = i < 4? POS_Y[_mode] : i < 8? POS_Y[_mode] + h : POS_Y[_mode] + 2 * h;
						arr[i].flop();
						arr[i].setMouseEnabled(true);
						_mainUI["mcCanvas"].addChild(arr[i]);
					}
					break;
				case 20:// 4 * 5
					for(i = 0; i < itemNum; ++i)
					{
						arr[i].x = i < 5? POS_X[_mode] + i * w : i < 10? POS_X[_mode] + (i - 5) * w : i < 15? POS_X[_mode] + (i - 10) * w : POS_X[_mode] + (i - 15) * w;
						arr[i].y = i < 5? POS_Y[_mode] : i < 10? POS_Y[_mode] + h : i < 15? POS_Y[_mode] + 2 * h : POS_Y[_mode] + 3 * h;
						arr[i].flop();
						arr[i].setMouseEnabled(true);
						_mainUI["mcCanvas"].addChild(arr[i]);
					}
					break;
			}
			
		}
		
		private function chaosSortByArr(arr : Array, len : uint) : Array
		{
			var result : Array = arr.slice(0, len);
			var temp : Card, id : uint;
			
			for(var i : uint = 0; i < result.length; ++i)
			{
				id = uint(Math.random() * result.length);
				temp = result[i];
				result[i] = result[id];
				result[id] = temp;
			}
			
			return result;
		}
		
		private function hideItem(isRemove : Boolean = false) : void
		{
			if(isRemove)
				_mainUI["mcCanvas"].visible = false;
			for(var i : uint = 0; i < _itemList.length; ++i)
			{
				if(_itemList[i].parent == _mainUI["mcCanvas"])
				{
					if(_itemList[i].isFore())
						_itemList[i].flop();
					if(isRemove)
						_mainUI["mcCanvas"].removeChild(_itemList[i]);
				}
			}
			
			_curItem = _preItem = null;
		}
		
		private function updateScore(isReset : Boolean, isAdd : Boolean) : void
		{
			if(isReset)
				_score = 0;
			else
			{
				isAdd? _score += 10 : _score -= 1;
				if(_score < 0)
					_score = 0;
			}
			_mainUI["mcCanvas"]["txtScore"].text = _score;
			_mainUI["overCanvas"]["txtScore"].text = _score;
		}
		
		private function checkWin() : void
		{
			var itemNum : uint = 0;
			var foreNum : uint = 0;
			for(var i : uint = 0; i < _itemList.length; ++i)
			{
				if(_itemList[i].parent == _mainUI["mcCanvas"])
				{
					itemNum++;
					if(_itemList[i].isFore())
						foreNum++;
				}
			}
			if(itemNum == foreNum)// foreNum 比 itemNum 少两个
			{
				_mainUI["overCanvas"].visible = true;
				_mainUI["overCanvas"].y = -(_mainUI["overCanvas"].height);
				TweenLite.to(_mainUI["overCanvas"], 0.5, {y : 0});
				hideItem(true);
			}
		}
		
		// 事件
		private function onChooseMode(e : MouseEvent) : void
		{
			_mode = uint(e.currentTarget.name.split("_")[1]);
			if(!_firstEnter)
			{
				_mainUI["startCanvas"].visible = false;
				_mainUI["mcCanvas"].visible = false;
				_mainUI["mcTips"].visible = true;
				_mainUI["mcTips"].gotoAndPlay(1);
			}
			else
				setup();
		}
		
		private function onTipsClose(e : MouseEvent) : void
		{
			_firstEnter = true;
			_mainUI["mcTips"].visible = false;
			_mainUI["mcTips"].gotoAndStop(1);
			setup();
		}
		
		private function onGameAgain(e : MouseEvent) : void
		{
			setup();
		}
		
		private function onGameOver(e : MouseEvent) : void
		{
			_mainUI["startCanvas"].visible = true;
			hideItem(true);
		}
		
		private function onTimeCom(e : TimerEvent) : void
		{
			_timer.reset();
			hideItem();
			_canClick = true;
		}
		
		private function onItemClick(e : MouseEvent) : void
		{
			if(!_canClick)
				return;
			
			var item : Card = e.currentTarget as Card;
			_curItem = item;
			if(_preItem && _preItem != _curItem)
			{
				_canClick = false;
				_preItem.flop();
				_curItem.flop();
				if(_preItem.cardId == _curItem.cardId)
				{
					_preItem.setMouseEnabled(false);
					_curItem.setMouseEnabled(false);
					_preItem = _curItem = null;
					_canClick = true;
					updateScore(false, true);
					setTimeout(checkWin, 500);
				}
				else
				{
					updateScore(false, false);
					setTimeout(function() : void
					{
						_preItem.flop();
						_curItem.flop();
						_preItem = _curItem = null;
						_canClick = true;
					}, 500);
				}
				return;
			}
			_preItem = _curItem;
		}
		
		
		private function addEvent() : void
		{
			for(var i : uint = 0; i < 3; ++i)
				_mainUI["startCanvas"]["btn_" + i].addEventListener(MouseEvent.CLICK, onChooseMode);
			
			_mainUI["mcCanvas"]["btnHome"].addEventListener(MouseEvent.CLICK, onGameOver);
			
			_mainUI["overCanvas"]["btnHome"].addEventListener(MouseEvent.CLICK, onGameOver);
			_mainUI["overCanvas"]["btnAgain"].addEventListener(MouseEvent.CLICK, onGameAgain);
			
			_mainUI["mcTips"]["btnClose"].addEventListener(MouseEvent.CLICK, onTipsClose);
			
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeCom);
			
			for(i = 0; i < _itemList.length; ++i)
				_itemList[i].addEventListener(MouseEvent.CLICK, onItemClick);
		}
		
		private function removeEvent() : void
		{
			for(var i : uint = 0; i < 3; ++i)
				_mainUI["startCanvas"]["btn_" + i].removeEventListener(MouseEvent.CLICK, onChooseMode);
			
			_mainUI["mcCanvas"]["btnHome"].removeEventListener(MouseEvent.CLICK, onGameOver);
			
			_mainUI["overCanvas"]["btnHome"].removeEventListener(MouseEvent.CLICK, onGameOver);
			_mainUI["overCanvas"]["btnAgain"].removeEventListener(MouseEvent.CLICK, onGameAgain);
			
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeCom);
			
			for(i = 0; i < _itemList.length; ++i)
				_itemList[i].removeEventListener(MouseEvent.CLICK, onItemClick);
		}
		
		private function destroy() : void
		{
			removeEvent();
			
			_mainUI = null;
		}
	}
}