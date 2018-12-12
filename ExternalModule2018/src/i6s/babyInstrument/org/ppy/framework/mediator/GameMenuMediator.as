package i6s.babyInstrument.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import i6s.babyInstrument.org.ppy.framework.event.PPYEvent;
	import i6s.babyInstrument.org.ppy.framework.model.SoundModel;
	import i6s.babyInstrument.org.ppy.framework.util.SoundManager;
	import i6s.babyInstrument.org.ppy.framework.view.GameMenuView;
	import i6s.babyInstrument.org.ppy.framework.view.GameStartView;
	
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
		
		private const MIN_PAGE : uint = 1;
		private const MAX_PAGE : uint = 6;
		private var _pageArr : Array = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [9, 10, 11], [12, 13, 14], [15, 16]];
		private var _curPage : uint;
		private var _curId : uint;
		private var _isPlaying : Boolean;
		
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
			_isPlaying = false;
			_curId = 999;
			
			_curPage = MIN_PAGE;
			for(var i : uint = 0; i < _pageArr.length; ++i) {
				for(var j : uint = 0; j < _pageArr[i].length; ++j) {
					view.mcPanel(_pageArr[i][j]).gotoAndStop(1);
					view.mcPanel(_pageArr[i][j]).visible = i == (_curPage - 1)?true:false;
				}
			}
			setEnable(view.btnPre(), false);
			setEnable(view.btnNext(), true);
			
			view.mcNote().gotoAndStop(1);
			view.mcNote().visible = false;
			
			soundPlay(soundData.getEffect(2));
		}
		
		private function soundPlay(name : String) : void
		{
			if(!_soundManager.isPlaying(name))
			{
				_soundManager.stopSound();
				_soundManager.playSound(name);
			}
		}
		
		private function jumpPage(flg : String) : void
		{
			trace("jump");
			if(_isPlaying) {
				TweenLite.killTweensOf(view.mcPanel(_curId));
				stopPlay();
			}
			
			setEnable(view.btnNext(), true);
			setEnable(view.btnPre(), true);
			if(flg == "add") {
				_curPage++;
				if(_curPage >= MAX_PAGE) {
					_curPage = MAX_PAGE;
					setEnable(view.btnNext(), false);
				}
			} else if(flg == "del") {
				_curPage--;
				if(_curPage <= MIN_PAGE) {
					_curPage = MIN_PAGE;
					setEnable(view.btnPre(), false);
				}
			}
			for(var i : uint = 0; i < _pageArr.length; ++i) {
				for(var j : uint = 0; j < _pageArr[i].length; ++j) {
					view.mcPanel(_pageArr[i][j]).gotoAndStop(1);
					view.mcPanel(_pageArr[i][j]).visible = i == (_curPage - 1)?true:false;
				}
			}
		}
		
		private function setEnable(mc : MovieClip, bl : Boolean) : void
		{
			if(bl && mc.currentFrame == 1)
				return;
			if(!bl && mc.currentFrame == 2)
				return;
			mc.mouseChildren = bl;
			mc.mouseEnabled = bl;
			mc.gotoAndStop(bl? 1 : 2);
		}
		
		private function stopPlay() : void
		{
			_soundManager.stopSound();
			_isPlaying = false;
			
			view.mcPanel(_curId).gotoAndStop(1);
			view.mcNote().visible = false;
			view.mcNote().gotoAndStop(1);
			
			_curId = 999;
		}
		
		private function onFeatureHandler(e : MouseEvent) : void
		{
			var name : String = e.currentTarget.name;
			soundPlay(soundData.getEffect(1));
			switch(name) {
				case "btnBack":
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameStartView));
					break;
				case "rightBtn":
					if(_curPage == MAX_PAGE)
						return;
					jumpPage("add");
					break;
				case "leftBtn":
					if(_curPage == MIN_PAGE)
						return;
					jumpPage("del");
					break;
				default:
					break;
			}
		}
		
		private function onIconHandler(e : MouseEvent) : void
		{
			if(_isPlaying)
				return;
			
			_isPlaying = true;
			_curId = uint(e.currentTarget.name.split("_")[1]);
			
			view.mcPanel(_curId).gotoAndStop(2);
			view.mcNote().visible = true;
			view.mcNote().gotoAndPlay(1);
			soundPlay(soundData.getMusic(_curId));
			TweenLite.to(view.mcPanel(_curId), 8, {onComplete:function():void{
				stopPlay();
			}});
		}
		
		private function addEvent() : void
		{
			view.btnBack().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnPre().addEventListener(MouseEvent.MOUSE_DOWN, onFeatureHandler);
			view.btnNext().addEventListener(MouseEvent.MOUSE_DOWN, onFeatureHandler);
			for(var i : uint = 0; i < _pageArr.length; ++i) {
				for(var j : uint = 0; j < _pageArr[i].length; ++j) {
					view.mcPanel(_pageArr[i][j]).addEventListener(MouseEvent.CLICK, onIconHandler);
				}
			}
		}
		
		private function removeEvent() : void
		{
			view.btnBack().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnPre().removeEventListener(MouseEvent.MOUSE_DOWN, onFeatureHandler);
			view.btnNext().removeEventListener(MouseEvent.MOUSE_DOWN, onFeatureHandler);
			for(var i : uint = 0; i < _pageArr.length; ++i) {
				for(var j : uint = 0; j < _pageArr[i].length; ++j) {
					view.mcPanel(_pageArr[i][j]).removeEventListener(MouseEvent.CLICK, onIconHandler);
				}
			}
		}
		
		override public function destroy():void
		{
			removeEvent();
			TweenLite.killTweensOf(view.mcPanel(_curId));
			
			
			super.destroy();
		}
	}
}