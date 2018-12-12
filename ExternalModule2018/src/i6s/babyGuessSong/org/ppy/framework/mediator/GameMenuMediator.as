package i6s.babyGuessSong.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	
	import i6s.babyGuessSong.org.ppy.framework.event.PPYEvent;
	import i6s.babyGuessSong.org.ppy.framework.model.SoundModel;
	import i6s.babyGuessSong.org.ppy.framework.util.SoundManager;
	import i6s.babyGuessSong.org.ppy.framework.view.GameMenuView;
	import i6s.babyGuessSong.org.ppy.framework.view.GameStartView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-25 下午4:54:24
	 **/
	public class GameMenuMediator extends Mediator
	{
		[Inject]
		public var view : GameMenuView;
		
		[Inject]
		public var soundData : SoundModel;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		private var _life : uint;
		
		private var _quesArr : Array;
		private var _curIdx : uint;
		private var _canGuess : Boolean;
		
		
		public function GameMenuMediator()
		{
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			initData();
			addEvent();
		}
		
		private function initData() : void
		{
			_canGuess = false;
			_life = 3;
			_curIdx = 0;
			
			
			view.mcLife().gotoAndStop(1);
			view.mcOver().visible = false;
			view.mcOver().gotoAndStop(1);

			
			trace("sound: 游戏开始...");
			setPiano();
			_canGuess = true;
		}
		
		private function soundPlay(name : String, loop : Boolean = false) : void
		{
			if(!_soundManager.isPlaying(name))
			{
				_soundManager.stopSound();
				if(loop)
					_soundManager.playSound(name, 0, 999);
				else
					_soundManager.playSound(name);
			}
		}
		
		private function setPiano() : void
		{
			var i : uint;
			for(i = 0; i < 4; ++i) {
				view.mcIconMov(i).gotoAndStop(1);
				view.mcIconWord(i).gotoAndStop(1);
				hideBtn(i);
			}
			view.mcNote().gotoAndPlay(1);
			
			_quesArr = nonRepeatRand(view.mcIconWord(0).totalFrames);
			
			var tmp : Array = _quesArr.concat();
			tmp.splice(_curIdx, 1);
			var arr : Array = chaosSortByArr(tmp, tmp.length);
			var randId : uint = uint(Math.floor(Math.random() * 4));
			trace("作弊，id: " + (randId + 1) + " val: " + _quesArr[_curIdx]);
			for(i = 0; i < 4; ++i) {
				view.mcIconWord(i).gotoAndStop(i == randId? _quesArr[_curIdx] : arr[i]);
			}
			
			soundPlay(soundData.getMusic(_quesArr[_curIdx] - 1), true);
		}
		
		/**
		 * 不重复随机数 
		 * @param arr
		 * @return 
		 * 
		 */		
		private function nonRepeatRand(num : uint) : Array
		{
			if(num <= 0)
				return null;
			
			var arr : Array = [];
			for(var i : uint = 1; i <= num; ++i)
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
		/**
		 * 乱序 
		 * @param len
		 * @return 
		 * 
		 */	
		private function chaosSortByArr(arr : Array, len : uint) : Array
		{
			var result : Array = arr.slice(0, len);
			var temp : uint;
			var id : uint;
			
			for(var i : uint = 0; i < result.length; ++i)
			{
				id = uint(Math.random() * result.length);
				temp = result[i];
				result[i] = result[id];
				result[id] = temp;
			}
			
			return result;
		}
		
		private function hideBtn(id : uint) : void
		{
			view.mcIcon(id).gotoAndStop(1);
			view.btnRight(id).visible = false;
			view.btnWrong(id).visible = false;
		}
		
		private function judge(id : uint) : void
		{
			_canGuess = false;
			if(view.mcIconWord(id).currentFrame == _quesArr[_curIdx]) {// 答对
				trace("sound: + 答对了...");
				_curIdx++;
				view.mcIconMov(id).gotoAndPlay(1);
				if(_curIdx == _quesArr.length) {
					soundPlay(soundData.getEffect(9));// 最后答对
					TweenLite.to(view.mcNote(), 1.5, {onComplete:function():void{
						checkOver();
					}});
				} else {
					soundPlay(soundData.getEffect(5));// 前面答对
					TweenLite.to(view.mcNote(), 4.5, {onComplete:function():void{
						checkOver();
					}});
				}
			} else {// 答错
				trace("sound: + 不对哦...");
				_life--;
				view.mcLife().gotoAndStop(4 - _life);
				if(_life == 0) {
					soundPlay(soundData.getEffect(8));// 最后答错
					TweenLite.to(view.mcNote(), 2, {onComplete:function():void{
						checkOver();
					}});
				} else {
					soundPlay(soundData.getEffect(4));// 前面答错
					TweenLite.to(view.mcNote(), 2.5, {onComplete:function():void{
						checkOver();
					}});
				}
			}
		}
		
		private function checkOver() : void
		{
			if(_life == 0) {
				trace("sound: + 游戏结束..");
				soundPlay(soundData.getEffect(6));
				view.mcOver().visible = true;
				view.mcOver().gotoAndStop(2);
				view.txtScore().text = _curIdx + 1 + "";
			} else if(_curIdx == _quesArr.length) {
				trace("sound: + 通关了...");
				soundPlay(soundData.getEffect(7));
				view.mcOver().visible = true;
				view.mcOver().gotoAndStop(1);
			} else {
				trace("sound: + 下一关...");
				setPiano();
				_canGuess = true;
			}
		}
		
		private function onFeatureHandler(e : MouseEvent) : void
		{
			var name : String = e.currentTarget.name;
			switch(name) {
				case "btnBack":
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameStartView));
					break;
				case "btnOver":
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameStartView));
					break;
				default:
					break;
			}
		}
		
		private function onShowBtnHandler(e : MouseEvent) : void
		{
			if(!_canGuess)
				return;
			
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			for(var i : uint = 0; i < 4; ++i) {
				if(i == id) {
					if(view.mcIcon(id).currentFrame == 1) {
						trace("sound: 暂停...");
						soundPlay(soundData.getName(view.mcIconWord(id).currentFrame - 1));
						view.mcNote().gotoAndStop(1);
						view.mcIcon(id).gotoAndStop(2);
						view.btnRight(id).visible = true;
						view.btnWrong(id).visible = true;
					} else {
						trace("sound: 继续...");
						soundPlay(soundData.getMusic(_quesArr[_curIdx] - 1), true);
						hideBtn(i);
						
						view.mcNote().gotoAndPlay(1);
					}
				} else {
					hideBtn(i);
				}
			}
		}
		
		private function onBtnHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.parent.name.split("_")[1]);
			var name : String = e.currentTarget.name;
			switch(name) {
				case "rightBtn":
					trace("sound: 判断...");
					hideBtn(id);
					view.mcIcon(id).gotoAndStop(2);
					judge(id);
					
					view.mcNote().gotoAndStop(1);
					break;
				case "wrongBtn":
					trace("sound: 继续...");
					soundPlay(soundData.getMusic(_quesArr[_curIdx] - 1), true);
					hideBtn(id);
					
					view.mcNote().gotoAndPlay(1);
					break;
				default:
					break;
			}
		}
		
		private function addEvent() : void
		{
			view.btnBack().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnOver().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			for(var i : uint = 0; i < 4; ++i) {
				view.mcIcon(i).addEventListener(MouseEvent.CLICK, onShowBtnHandler);
				view.btnRight(i).addEventListener(MouseEvent.CLICK, onBtnHandler);
				view.btnWrong(i).addEventListener(MouseEvent.CLICK, onBtnHandler);
			}
		}
		
		private function removeEvent() : void
		{
			view.btnBack().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnOver().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			for(var i : uint = 0; i < 4; ++i) {
				view.mcIcon(i).removeEventListener(MouseEvent.CLICK, onShowBtnHandler);
				view.btnRight(i).removeEventListener(MouseEvent.CLICK, onBtnHandler);
				view.btnWrong(i).removeEventListener(MouseEvent.CLICK, onBtnHandler);
			}
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			TweenLite.killTweensOf(view.mcNote());
			
			
			super.destroy();
		}
	}
}