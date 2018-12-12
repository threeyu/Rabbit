package rabbitDinner
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.fscommand;
	
	import rabbitDinner.util.SoundManager;
	
	[SWF(backgroundColor="#000000", frameRate="30", width="1024", height="600")]
	public class RabbitDinnerModule extends Sprite
	{
		private var _mainUI : MovieClip;
		
		// 酱油 盐 青椒 花菜 胡萝卜 洋葱 牛肉 南瓜 菌类 茄子 玉米
		private const ITEM_POS_X : Array = [78, 188, 308, 458, 558, 78, 228, 328, 458, 558, 513];
		private const ITEM_POS_Y : Array = [120, 120, 120, 121, 121, 231, 271, 271, 201, 201, 276];
		private var _itemList : Array = [];
		private var _menuList : Array;
		
		private var _touchId : uint;
		private var _curLvl : uint;
		private var _curStep : uint;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		private const SOUND_URL : Array = ["res/bgm.mp3", "res/great.mp3", "res/tab.mp3", "res/collect.mp3", "res/gameover.mp3", "res/good.mp3", "res/tips_1.mp3", "res/tips_2.mp3", "res/wrong.mp3"];
		
		public function RabbitDinnerModule()
		{
			_mainUI = new RabbitDinnerModuleUI();
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
			var item : DinnerItemUI;
			for(var i : uint = 0; i < 11; ++i)
			{
				item = new DinnerItemUI();
				item.buttonMode = true;
				item.mouseChildren = true;
				_itemList.push(item);
			}
			
			_mainUI["mcMov"].visible = false;
			_mainUI["mcMov"].gotoAndStop(1);
			
			setup();
		}
		
		private function setup() : void
		{
			_soundManager.stopSound(SOUND_URL[0]);
			_soundManager.playSound(SOUND_URL[0]);
			
			_curLvl = 3;
			hideItem();
		}
		
		private function hideItem() : void
		{
			for(var i : uint = 0; i < _itemList.length; ++i)
				if(_itemList[i].parent == _mainUI["canvas"])
					_mainUI["canvas"].removeChild(_itemList[i]);
			
			_mainUI["overCanvas"].visible = false;
			_mainUI["overCanvas"]["succeed"].visible = false;
			_mainUI["overCanvas"]["succeed"].gotoAndStop(1);
			_mainUI["overCanvas"]["failed"].visible = false;
			_mainUI["overCanvas"]["failed"].gotoAndStop(1);
		}
		
		private function showMenu(isAgain : Boolean = false) : void
		{
			_mainUI["menuCanvas"].visible = true;
			
			hideItem();
			
			if(!isAgain)
				//				_menuList = nonRepeatRand();
				_menuList = normalRand();
			
			for(var i : uint = 0; i < _curLvl; ++i)
			{
				_itemList[i].x = i < 6? 70 * (i + 1) : 70 * (i + 1) - 420;
				_itemList[i].y = i < 6? 70 : 220;
				_itemList[i].gotoAndStop(_menuList[i] + 1);
				_itemList[i]["mc"].gotoAndStop(1);
				_mainUI["menuCanvas"]["canvas"].addChild(_itemList[i]);
			}
		}
		
		private function hideMenu() : void
		{
			_mainUI["menuCanvas"].visible = false;
			
			for(var i : uint = 0; i < _curLvl; ++i)
				_mainUI["menuCanvas"]["canvas"].removeChild(_itemList[i]);
			for(i = 0; i < _itemList.length; ++i)
			{
				_itemList[i].x = ITEM_POS_X[i];
				_itemList[i].y = ITEM_POS_Y[i];
				_itemList[i].gotoAndStop(i + 1);
				_itemList[i]["mc"].gotoAndStop(1);
				_mainUI["canvas"].addChild(_itemList[i]);
			}
		}
		
		private function potHit(tarMC : MovieClip) : Boolean
		{
			var result : Boolean = false;
			if(Math.abs(_mainUI["mcPot"].x - tarMC.x) < (_mainUI["mcPot"].width / 2 + tarMC.width / 2)
				&& Math.abs(_mainUI["mcPot"].y - tarMC.y) < (_mainUI["mcPot"].height / 2 + tarMC.height / 2))
				result = true;
			
			return result;
		}
		
		private function nonRepeatRand() : Array
		{
			if(_curLvl <= 0)
				return null;
			
			var arr : Array = [];
			for(var i : uint = 0; i < _curLvl; ++i)
				arr.push(i);
			
			var result : Array = [];
			var index : uint;
			while(arr.length > 0)
			{
				index = uint(Math.floor(Math.random() * arr.length));
				result.push(arr[index]);
				arr.splice(index, 1);
			}
			
			return result;
		}
		
		private function normalRand() : Array
		{
			if(_curLvl <= 0)
				return null;
			
			var result : Array = [];
			for(var i : uint = 0; i < _curLvl; ++i)
				result.push(Math.floor(Math.random() * (_curLvl - 1)) % _itemList.length + 1);
			return result;
		}
		
		// 事件
		private function onShowMenu(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[2]);
			_soundManager.playSound(SOUND_URL[6]);
			
			_mainUI["startCanvas"].visible = false;
			showMenu();
		}
		
		private function onGameStart(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[2]);
			_soundManager.stopSound(SOUND_URL[6]);
			_soundManager.playSound(SOUND_URL[7]);
			
			hideMenu();
			_curStep = 0;
		}
		
		private function onGameOver(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[2]);
			_soundManager.stopSound(SOUND_URL[7]);
			
			_mainUI["startCanvas"].visible = true;
			setup();
		}
		
		private function onGameAgain(e : MouseEvent) : void
		{
			_soundManager.playSound(SOUND_URL[2]);
			_soundManager.stopSound(SOUND_URL[7]);
			
			hideItem();
			showMenu(true);
		}
		
		private function onMouseDown(e : MouseEvent) : void
		{
			_touchId = e.currentTarget.currentFrame - 1;
			_itemList[_touchId].startDrag();
			
			_itemList[_touchId].parent.setChildIndex(_itemList[_touchId], _itemList[_touchId].parent.numChildren - 1);
		}
		
		private function onMouseUp(e : MouseEvent) : void
		{
			_itemList[_touchId].stopDrag();
			if(potHit(_itemList[_touchId]) && _menuList[_curStep] == _touchId)
			{
				_soundManager.playSound(SOUND_URL[3]);
				
				_itemList[_touchId].x = _mainUI["mcPot"].x;
				_itemList[_touchId].y = _mainUI["mcPot"].y - 120;
				_itemList[_touchId]["mc"].gotoAndPlay(1);
				_itemList[_touchId]["mc"].addEventListener(Event.ENTER_FRAME, onItemFrame);
			}
			else if(potHit(_itemList[_touchId]) && _menuList[_curStep] != _touchId)
			{
				_soundManager.playSound(SOUND_URL[8]);
				
				hideItem();
				_mainUI["overCanvas"].visible = true;
				_mainUI["overCanvas"]["failed"].visible = true;
				_mainUI["overCanvas"]["failed"].gotoAndPlay(1);
				_mainUI["overCanvas"]["failed"]["mov"]["txtScore"].text = _curLvl - 3;
			}
			else
			{
				_itemList[_touchId].x = ITEM_POS_X[_touchId];
				_itemList[_touchId].y = ITEM_POS_Y[_touchId];
			}
		}
		
		private function onItemFrame(e : Event) : void
		{
			if(_itemList[_touchId]["mc"].currentFrame == _itemList[_touchId]["mc"].totalFrames)
			{
				_itemList[_touchId].x = ITEM_POS_X[_touchId];
				_itemList[_touchId].y = ITEM_POS_Y[_touchId];
				_itemList[_touchId]["mc"].gotoAndStop(1);
				_itemList[_touchId]["mc"].removeEventListener(Event.ENTER_FRAME, onItemFrame);
				
				if(_curStep < _curLvl - 1)
					_curStep++;
				else
				{
					if(_curLvl < _itemList.length)
					{
						_soundManager.playSound(SOUND_URL[5]);
						
						_curLvl++;
						_mainUI["mcMov"].visible = true;
						_mainUI["mcMov"].gotoAndPlay(1);
						_mainUI["mcMov"].addEventListener(Event.ENTER_FRAME, onMovFrame);
					}
					else// 胜利
					{
						_soundManager.playSound(SOUND_URL[1]);
						
						hideItem();
						_mainUI["overCanvas"].visible = true;
						_mainUI["overCanvas"]["succeed"].visible = true;
						_mainUI["overCanvas"]["succeed"].gotoAndPlay(1);
					}
				}
			}
		}
		
		private function onMovFrame(e : Event) : void
		{
			if(_mainUI["mcMov"].currentFrame == _mainUI["mcMov"].totalFrames)
			{
				_mainUI["mcMov"].removeEventListener(Event.ENTER_FRAME, onMovFrame);
				_mainUI["mcMov"].gotoAndStop(1);
				_mainUI["mcMov"].visible = false;
				
				showMenu();
			}
		}
		
		private function addEvent() : void
		{
			_mainUI["startCanvas"]["btnStart"].addEventListener(MouseEvent.CLICK, onShowMenu);
			_mainUI["menuCanvas"]["btnStart"].addEventListener(MouseEvent.CLICK, onGameStart);
			_mainUI["btnHome"].addEventListener(MouseEvent.CLICK, onGameOver);
			
			_mainUI["overCanvas"]["failed"]["mov"]["btnHome"].addEventListener(MouseEvent.CLICK, onGameOver);
			_mainUI["overCanvas"]["failed"]["mov"]["btnAgain"].addEventListener(MouseEvent.CLICK, onGameAgain);
			_mainUI["overCanvas"]["succeed"]["mov"]["btnHome"].addEventListener(MouseEvent.CLICK, onGameOver);
			_mainUI["overCanvas"]["succeed"]["mov"]["btnAgain"].addEventListener(MouseEvent.CLICK, onGameAgain);
			
			for(var i : uint = 0; i < _itemList.length; ++i)
			{
				_itemList[i].addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				_itemList[i].addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
		}
		
		private function removeEvent() : void
		{
			_mainUI["startCanvas"]["btnStart"].removeEventListener(MouseEvent.CLICK, onShowMenu);
			_mainUI["menuCanvas"]["btnStart"].removeEventListener(MouseEvent.CLICK, onGameStart);
			_mainUI["btnHome"].removeEventListener(MouseEvent.CLICK, onGameOver);
			
			_mainUI["overCanvas"]["failed"]["mov"]["btnHome"].removeEventListener(MouseEvent.CLICK, onGameOver);
			_mainUI["overCanvas"]["failed"]["mov"]["btnAgain"].removeEventListener(MouseEvent.CLICK, onGameAgain);
			_mainUI["overCanvas"]["succeed"]["mov"]["btnHome"].removeEventListener(MouseEvent.CLICK, onGameOver);
			_mainUI["overCanvas"]["succeed"]["mov"]["btnAgain"].removeEventListener(MouseEvent.CLICK, onGameAgain);
			
			for(var i : uint = 0; i < _itemList.length; ++i)
			{
				_itemList[i].removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				_itemList[i].removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
		}
		
		private function destroy() : void
		{
			removeEvent();
			
			
			_mainUI = null;
		}
	}
}