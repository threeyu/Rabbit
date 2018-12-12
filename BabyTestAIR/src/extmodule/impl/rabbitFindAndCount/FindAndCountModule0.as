package extmodule.impl.rabbitFindAndCount
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.events.MouseEvent;
	
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	
	import extmodule.api.BaseExtModule;

	/**
	 * 数一数，第一关
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-11-27 下午4:02:01
	 **/
	public class FindAndCountModule0 extends BaseExtModule
	{
		[Inject]
		public var view : FindAndCountView0;
		
		private var _soundRoot : String = "resource/sound/rabbitFindAndCount/";
		private var _bgm : String = "resource/sound/common/BGM_4.mp3";
		private var _url : String = "resource/extmodule/findAndCountModule0UI.swf";
		
		
		
		
		private const LVLNUM : uint = 1;
		private var _curLvl : uint;
		private var _curCnt : uint;
		private var _curPlayId : uint;
		private var _wrongCnt : uint;
		private var _mouseCnt : uint;
		private var _itemList : Array;
		
		
		
		public function FindAndCountModule0()
		{
			super(_url);
		}
		
		override protected function init():void
		{
			view.addToStage(_mainUI);
			
			
			
			_mainUI["mcTips"].visible = true;
			_mainUI["mcTips"].gotoAndStop(1);
			
			
			
			TweenLite.from(_mainUI["mcTips"]["mcLabel"], 2, {y:-400, ease:Back.easeOut});
			
			//			trace("[sound]: 寻找马戏团");
			soundManager.playSound(_soundRoot + "titleSound.mp3");
			TweenLite.delayedCall(6.5, titleSoundCallback);
		}
		
		private function titleSoundCallback() : void
		{
			_mainUI["mcTips"].visible = false;
			_mainUI["mcTips"].gotoAndStop(1);
			
			//			trace("[sound]: tips.mp3火火兔出门。。。");
			soundManager.playSound(_soundRoot + "soundTips_1.mp3");
			soundManager.playSound(_bgm);
			gameStart();
		}
		
		private function gameStart() : void
		{
			_curCnt = 0;
			_curLvl = 1;
			_mouseCnt = 0;
			
			
			clearPool(_itemList);
			_itemList = [];
			for(var i : uint = 0; i < LVLNUM; ++i)
			{
				_itemList[i] = [];
				for(var j : uint = 0; j < 3; ++j)
				{
					if(_mainUI["mcLvl_" + i].hasOwnProperty("mcItem_" + j))
					{
						_itemList[i][j] = {item : _mainUI["mcLvl_" + i]["mcItem_" + j], isSelected : false};
						_mainUI["mcLvl_" + i]["mcItem_" + j].gotoAndStop(1);
					}
				}
			}
			
			
			_mainUI["mcWrong"].visible = false;
			// 动画
			_mainUI["mcMov"]["mc"].gotoAndStop(1);
			_mainUI["mcMov"].gotoAndStop(1);
			_mainUI["mcMov"].visible = false;
		}
		
		private function checkWin() : void
		{
			if(_curCnt == _itemList[_curLvl - 1].length)
			{
				_mainUI["mcMov"].visible = true;
				_mainUI["mcMov"].gotoAndStop(uint(Math.random() * 3) + 1);
				_mainUI["mcMov"]["mc"].gotoAndPlay(1);
				
				gameOver();
			}
		}
		
		private function gameOver() : void
		{
			TweenLite.delayedCall(6, function():void{
				_mainUI["mcMov"]["mc"].gotoAndStop(1);
				_mainUI["mcMov"].gotoAndStop(1);
				_mainUI["mcMov"].visible = false;
				
				
				trace("gameWin");
				account();
				dispatch(new PPYEvent(CommandID.EXTMODULE_OVER));
			});
		}
		
		private function account() : void
		{
			var score : uint = 0;
			var perfectCnt : uint = 0;
			for(var i : uint = 0; i < _itemList.length; ++i)
				for(var j : uint = 0; j < _itemList[i].length; ++j)
					perfectCnt++;
			var result : uint = _mouseCnt - perfectCnt;
			if(result <= 1)// A
			{
				score = 100;
			}
			else if(result == 2)// B
			{
				score = 50;
			}
			else// C
			{
				score = 20;
			}
			saveScore(score, 100);
		}
		
		private function clearPool(arr : Array) : void
		{
			if(arr) {
				var len : uint = arr.length;
				for(var i : uint = 0; i < len; ++i) {
					arr[i] = null;
				}
				arr.splice(0, len);
				arr = null;
			}
		}
		
		// 事件
		private function onClose(e : MouseEvent) : void
		{
			view.removeFromStage();
		}
		
		private function onPlayTitleHandler(e : MouseEvent) : void
		{
			soundManager.stopSoundExpect(_bgm);
			soundManager.playSound(_soundRoot + "soundTips_1.mp3");
		}
		
		private function onWrongClick(e : MouseEvent) : void
		{
			if(_curCnt == _itemList[_curLvl - 1].length)
				return;
			
			soundManager.stopSoundExpect(_bgm);
			
			_wrongCnt++;
			var tmp : String = _wrongCnt == 1? "soundWrong.mp3" : "soundWrongAg.mp3";
			soundManager.playSound(_soundRoot + tmp);
			
			_mouseCnt++;
			_mainUI["mcWrong"].visible = true;
			_mainUI["mcWrong"].x = _mainUI.mouseX;
			_mainUI["mcWrong"].y = _mainUI.mouseY;
			TweenLite.to(_mainUI, 1, {onComplete : function() : void{
				_mainUI["mcWrong"].visible = false;
			}});
		}
		
		private function onItemClick(e : MouseEvent) : void
		{
			if(_curCnt == _itemList[_curLvl - 1].length)
				return;
			
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			if(_itemList[_curLvl - 1][id].isSelected == false)
			{
				var i : uint;
				var tmp : String = _wrongCnt == 1? "soundWrong.mp3" : "soundWrongAg.mp3";
				if(soundManager.isPlaying(_soundRoot + tmp))
					return;
				
				
				
				
				trace("选中");
				_wrongCnt = 0;
				_mouseCnt++;
				_curPlayId = id;
				_curCnt++;
				_itemList[_curLvl - 1][_curPlayId].isSelected = true;
				
				_mainUI["mcLvl_" + (_curLvl - 1)]["mcItem_" + _curPlayId].gotoAndStop(2);

				
				soundManager.stopSoundExpect(_bgm);
				soundManager.playSound(_soundRoot + "sound_" + (id + 1) + ".mp3");
				checkWin();
			}
		}
		
		override protected function addEvent():void
		{
			super.addEvent();
			_mainUI["btnClose"].addEventListener(MouseEvent.CLICK, onClose);
			_mainUI["btnOK"].addEventListener(MouseEvent.CLICK, onPlayTitleHandler);
			
			
			for(var i : uint = 0; i < LVLNUM; ++i)
			{
				_mainUI["mcLvl_" + i]["mcCanvas"].addEventListener(MouseEvent.CLICK, onWrongClick);
				for(var j : uint = 0; j < 3; ++j)
					_mainUI["mcLvl_" + i]["mcItem_" + j].addEventListener(MouseEvent.CLICK, onItemClick);
			}
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_mainUI["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			_mainUI["btnOK"].removeEventListener(MouseEvent.CLICK, onPlayTitleHandler);
			
			
			for(var i : uint = 0; i < LVLNUM; ++i)
			{
				_mainUI["mcLvl_" + i]["mcCanvas"].removeEventListener(MouseEvent.CLICK, onWrongClick);
				for(var j : uint = 0; j < 3; ++j)
					_mainUI["mcLvl_" + i]["mcItem_" + j].removeEventListener(MouseEvent.CLICK, onItemClick);
			}
		}
		
		override public function destroy():void
		{
			
			clearPool(_itemList);
			
			
			
			super.destroy();
			
			
			
			
		}
	}
}