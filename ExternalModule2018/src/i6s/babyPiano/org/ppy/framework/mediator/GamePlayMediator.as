package i6s.babyPiano.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import i6s.babyPiano.org.ppy.framework.event.PPYEvent;
	import i6s.babyPiano.org.ppy.framework.model.IPlayInfoModel;
	import i6s.babyPiano.org.ppy.framework.model.SoundModel;
	import i6s.babyPiano.org.ppy.framework.util.SoundManager;
	import i6s.babyPiano.org.ppy.framework.view.GameMenuView;
	import i6s.babyPiano.org.ppy.framework.view.GamePlayView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-8-6 下午2:57:15
	 **/
	public class GamePlayMediator extends Mediator
	{
		[Inject]
		public var view : GamePlayView;
		
		[Inject]
		public var playInfo : IPlayInfoModel;
		
		[Inject]
		public var soundData : SoundModel;
		
		private var _firstSound : uint;
		private var _curLvl : uint;
		private var _stepId : uint;
		private var _isPlaying : Boolean;
		private var _canClick : Boolean;
		private var _clickArr : Array;
		
		private var BEATS : Object = {half : 0, nor : 1, long : 2};
		// 春天在哪里 竹蜻蜓 找朋友 粉刷匠 种太阳
		private var _sheetList : Array = [
			[6, 6, 6, 4, 1, 1, 6, 6, 6, 4, 6, 8, 8, 6, 4, 1, 1, 1, 1, 2, 3, 4, 6, 5, 6, 6, 6, 4, 1, 1, 6, 6, 6, 4, 6, 8, 9, 8, 9, 8, 7, 6, 5, 1, 6, 5, 4],
			[7, 9, 7, 9, 7, 9, 7, 6, 9, 7, 9, 7, 9, 7, 5, 9, 7, 9, 7, 9, 7, 6, 7, 9, 7, 5, 3, 5, 3, 5, 3, 5, 3, 2, 5, 3, 5, 3, 5, 3, 2, 5, 3, 5, 2, 5, 3, 5, 8, 7, 5, 5, 5, 6, 7, 6],
			[5, 6, 5, 6, 5, 6, 5, 5, 8, 7, 6, 5, 5, 3, 5, 5, 3, 5, 5, 3, 2, 5, 3, 2, 1, 2, 1],
			[5, 3, 5, 3, 5, 3, 1, 2, 4, 3, 2, 5, 5, 3, 5, 3, 5, 3, 1, 2, 4, 3, 2, 1, 2, 2, 4, 4, 3, 1, 5, 2, 4, 3, 1, 5, 5, 3, 5, 3, 5, 3, 1, 2, 4, 3, 2, 1],
			[2, 3, 2, 7, 5, 2, 3, 2, 7, 5, 11, 1, 2, 2, 5, 5, 11, 4, 3, 10, 11, 1, 6, 4, 10, 11, 1, 6, 4, 4, 3, 2, 3, 4, 5, 2, 3, 2, 1, 11]
		];
		
		private var _curSheetList : Array;
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		
		public function GamePlayMediator()
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
			_curLvl = _firstSound = playInfo.getLvl();
			_isPlaying = false;
			_canClick = false;
			
			
			
			view.mcRabbit().gotoAndStop(_curLvl + 1);
			view.mcRabbitMov().gotoAndStop(1);
			view.mcSong().gotoAndStop(_curLvl + 1);
			view.btnPlay().gotoAndStop(1);
			view.mcOver().visible = false;
			
			
			initSheet();
			stop();
			
			
			trace("sound: + 春天在哪里...");
			soundPlay(soundData.getEffect(_curLvl + 8));
			TweenLite.to(view.btnNext(), 2.5, {onComplete:function():void{
				_isPlaying = true;
				gameStart();
			}});
		}
		
		private function soundPlay(name : String) : void
		{
			if(!_soundManager.isPlaying(name))
			{
				_soundManager.stopSound();
				_soundManager.playSound(name);
			}
		}
		
		private function setup() : void
		{
			clearPool();
			var i : uint;
			for(i = 0; i < 11; ++i) {
				view.mcKey(i).gotoAndStop(1);
				view.mcKeyVal(i).gotoAndStop(1);
			}
			
			_stepId = 0;
			_clickArr = _sheetList[_curLvl].slice(0, _sheetList[_curLvl].length);
		}
		
		private function initSheet() : void
		{
			var i : uint;
			for(i = 0; i < _sheetList[0].length; ++i) {
				if(i == 10 || i == 23 || i == 34) {
					_sheetList[0][i] = {val : _sheetList[0][i], beats : BEATS.long};
				} else if(i == 4 || i == 5 || i == 28 || i == 29 || i == 43 || i == 44) {
					_sheetList[0][i] = {val : _sheetList[0][i], beats : BEATS.nor};
				} else {
					_sheetList[0][i] = {val : _sheetList[0][i], beats : BEATS.half};
				}
			}
			for(i = 0; i < _sheetList[1].length; ++i) {
				if(i == 6 || i == 13 || i == 20 || i == 32 || i == 39) {
					_sheetList[1][i] = {val : _sheetList[1][i], beats : BEATS.nor};
				} else if(i == 25) {
					_sheetList[1][i] = {val : _sheetList[1][i], beats : BEATS.long};
				} else {
					_sheetList[1][i] = {val : _sheetList[1][i], beats : BEATS.half};
				}
			}
			for(i = 0; i < _sheetList[2].length; ++i) {
				if(i == 6 || i == 13 || i == 16 || i == 19 || i == 26) {
					_sheetList[2][i] = {val : _sheetList[2][i], beats : BEATS.nor};
				} else {
					_sheetList[2][i] = {val : _sheetList[2][i], beats : BEATS.half};
				}
			}
			for(i = 0; i < _sheetList[3].length; ++i) {
				if(i == 6 || i == 18 || i == 30 || i == 42) {
					_sheetList[3][i] = {val : _sheetList[3][i], beats : BEATS.nor};
				} else if(i == 11 || i == 23 || i == 35 || i == 47) {
					_sheetList[3][i] = {val : _sheetList[3][i], beats : BEATS.long};
				} else {
					_sheetList[3][i] = {val : _sheetList[3][i], beats : BEATS.half};
				}
			}
			for(i = 0; i < _sheetList[4].length; ++i) {
				if(i == 2 || i == 3 || i == 4 || i == 7 || i == 8 || i == 9 || i == 12 || i == 13 || i == 15 || i == 17 || i == 21 || i == 22 || i == 23 || i == 26 || i == 27 || i == 28 || i == 31 || i == 34) {
					_sheetList[4][i] = {val : _sheetList[4][i], beats : BEATS.nor};
				} else if(i == 18 || i == 39) {
					_sheetList[4][i] = {val : _sheetList[4][i], beats : BEATS.long};
				} else {
					_sheetList[4][i] = {val : _sheetList[4][i], beats : BEATS.half};
				}
			}
		}
		
		private function gameStart() : void
		{
			_canClick = false;
			view.btnPlay().gotoAndStop(2);
			TweenLite.killTweensOf(view.btnNext());
			playSheet(_curLvl);
		}
		
		// 播放曲子 
		private function playSheet(id : uint) : void
		{
			_curSheetList = _sheetList[id].slice(0, _sheetList[id].length);
			play();
		}
		
		// 处理节拍
		private function handleBeats() : void
		{
			switch(_curSheetList[0].beats)
			{
				case BEATS.half:
					playFrame(view.mcKeyVal(_curSheetList[0].val - 1).totalFrames / 4 + 2);
					break;
				case BEATS.nor:
					playFrame(view.mcKeyVal(_curSheetList[0].val - 1).totalFrames / 2 + 2);
					break;
				case BEATS.long:
					playFrame(view.mcKeyVal(_curSheetList[0].val - 1).totalFrames);
					break;
			}
		}
		
		private function playFrame(totalFrames : uint) : void
		{
			//			trace(view.mcKeyVal(_curSheetList[0].val - 1).currentFrame);
			if(view.mcKeyVal(_curSheetList[0].val - 1).currentFrame == totalFrames)
			{
				var obj : Object = _curSheetList.shift();
				view.mcKey(obj.val - 1).gotoAndStop(1);
				view.mcKeyVal(obj.val - 1).gotoAndStop(1);
				view.mcRabbitMov().gotoAndStop(1);
				
				play();
			}
		}
		
		private function play() : void
		{
			if(_curSheetList.length > 0) {
				var id : uint = _curSheetList[0].val - 1;
				view.mcKey(id).gotoAndStop(2);
				view.mcKeyVal(id).gotoAndPlay(2);
				view.mcRabbitMov().gotoAndPlay(1);
				
				chooseInstrument(id);
			} else {
				_isPlaying = false;
				playOver();
			}
		}
		
		private function chooseInstrument(id : uint) : void
		{
			var mp3Str : String;
			switch(_firstSound) {
				case 0:
					mp3Str = soundData.getPianoKey(id);
					break;
				case 1:
					mp3Str = soundData.getErhuKey(id);
					break;
				case 2:
					mp3Str = soundData.getHarmonicaKey(id);
					break;
				case 3:
					mp3Str = soundData.getFluteKey(id);
					break;
				case 4:
					mp3Str = soundData.getXylophoneKey(id);
					break;
				default:
					break;
			}
			_soundManager.playSound(mp3Str);
		}
		
		private function playOver() : void
		{
			var id : uint = _clickArr[_stepId].val - 1;
			_canClick = true;
			view.btnPlay().gotoAndStop(1);
			view.mcKey(id).gotoAndStop(3);
			view.mcKeyVal(id).gotoAndStop(2);
		}
		
		private function stop() : void
		{
			setup();
			_soundManager.stopSound();
		}
		
		private function nextSong() : void
		{
			trace("sound: + 下一首...");
			_isPlaying = false;
			_canClick = false;
			
			stop();
			view.btnPlay().gotoAndStop(1);
			TweenLite.killTweensOf(view.btnNext());
			
			_curLvl++;
			if(_curLvl >= 5) {
				_curLvl = 0;
			}
			playInfo.setLvl(_curLvl);
			view.mcSong().gotoAndStop(_curLvl + 1);

			soundPlay(soundData.getEffect(13));
			TweenLite.to(view.btnNext(), 1.2, {onComplete:function():void{
				soundPlay(soundData.getEffect(_curLvl + 8));
				TweenLite.to(view.btnNext(), 2.5, {onComplete:function():void{
					_isPlaying = true;
					
					view.btnPlay().gotoAndStop(2);
					playSheet(_curLvl);
				}});
			}});
		}
		
		private function clearPool() : void
		{
			var i : uint, len : uint;
			if(_curSheetList) {
				len = _curSheetList.length;
				if(len > 0) {
					for(i = 0; i < len; ++i) {
						_curSheetList[i] = null;
					}
					_curSheetList.splice(0, len);
					_curSheetList = null;
				}
			}
			if(_clickArr) {
				len = _clickArr.length;
				if(len > 0) {
					for(i = 0; i < len; ++i) {
						_clickArr[i] = null;
					}
					_clickArr.splice(0, len);
					_clickArr = null;
				}
			}
		}
		
		private function onKeyDownHandler(e : MouseEvent) : void
		{
			if(!_canClick) 
				return;
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			var tarId : uint = _clickArr[_stepId].val - 1;
			
			view.mcKey(id).gotoAndStop(2);
			view.mcKeyVal(id).gotoAndPlay(2);
			view.mcRabbitMov().gotoAndPlay(1);
			chooseInstrument(id);
			
			if(id == tarId) {
				_stepId++;
				if(_stepId == _clickArr.length) {
					trace("sound: + 通关");
					_soundManager.playSound(soundData.getEffect(16));
					_soundManager.playSound(soundData.getEffect(17));
					_stepId = 0;
					view.mcOver().visible = true;
					return;
				}
			}
		}
		
		private function onKeyUpHandler(e : MouseEvent) : void
		{
			if(!_canClick) 
				return;
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			var tarId : uint = _clickArr[_stepId].val - 1;
			
			view.mcKey(id).gotoAndStop(1);
			view.mcRabbitMov().gotoAndStop(1);
			
			
			view.mcKey(tarId).gotoAndStop(3);
			view.mcKeyVal(tarId).gotoAndStop(2);
		}
		
		private function onFeatureHandler(e : MouseEvent) : void
		{
			var name : String = e.currentTarget.name;
			switch(name) {
				case "btnBack":
					_soundManager.stopSoundExpect(soundData.getBGM());
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameMenuView));
					break;
				case "btnNext":
					nextSong();
					break;
				case "playBtn":
					stop();
					_isPlaying = !_isPlaying;
					if(_isPlaying) {
						soundPlay(soundData.getEffect(14));
						gameStart();
					} else {
						soundPlay(soundData.getEffect(15));
						playOver();
					}
					break;
				default:
					break;
			}
		}
		
		private function onOverHandler(e : MouseEvent) : void
		{
			var name : String = e.currentTarget.name;
			view.mcOver().visible = false;
			switch(name) {
				case "btnAgain":
					soundPlay(soundData.getEffect(1));
					stop();
					_isPlaying = true;
					_canClick = false;
					view.btnPlay().gotoAndStop(2);
					TweenLite.killTweensOf(view.btnNext());
					playSheet(_curLvl);
					break;
				case "btnNext":
					nextSong();
					break;
				default:
					break;
			}
		}
		
		private function onMusicFrame(e : Event) : void
		{
			if(_curSheetList && _curSheetList.length > 0)
				handleBeats();
		}
		
		private function addEvent() : void
		{
			view.btnBack().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnNext().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnPlay().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnOverNext().addEventListener(MouseEvent.CLICK, onOverHandler);
			view.btnOverAgain().addEventListener(MouseEvent.CLICK, onOverHandler);
			for(var i : uint = 0; i < 11; ++i) {
				view.mcKey(i).addEventListener(MouseEvent.MOUSE_DOWN, onKeyDownHandler);
				view.mcKey(i).addEventListener(MouseEvent.MOUSE_UP, onKeyUpHandler);
				view.mcKey(i).addEventListener(MouseEvent.MOUSE_OUT, onKeyUpHandler);
			}
			view.addEventListener(Event.ENTER_FRAME, onMusicFrame);
		}
		
		private function removeEvent() : void
		{
			view.btnBack().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnNext().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnPlay().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnOverNext().removeEventListener(MouseEvent.CLICK, onOverHandler);
			view.btnOverAgain().removeEventListener(MouseEvent.CLICK, onOverHandler);
			for(var i : uint = 0; i < 11; ++i) {
				view.mcKey(i).removeEventListener(MouseEvent.MOUSE_DOWN, onKeyDownHandler);
				view.mcKey(i).removeEventListener(MouseEvent.MOUSE_UP, onKeyUpHandler);
				view.mcKey(i).removeEventListener(MouseEvent.MOUSE_OUT, onKeyUpHandler);
			}
			view.removeEventListener(Event.ENTER_FRAME, onMusicFrame);
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			clearPool();
			TweenLite.killTweensOf(view.btnNext());
			
			
			
			super.destroy();
		}
	}
}