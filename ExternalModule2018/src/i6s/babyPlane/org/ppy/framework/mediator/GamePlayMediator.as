package i6s.babyPlane.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import i6s.babyPlane.org.ppy.framework.event.PPYEvent;
	import i6s.babyPlane.org.ppy.framework.model.SoundModel;
	import i6s.babyPlane.org.ppy.framework.util.SoundManager;
	import i6s.babyPlane.org.ppy.framework.view.GamePlayView;
	import i6s.babyPlane.org.ppy.framework.view.GameStartView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-23 下午7:03:34
	 **/
	public class GamePlayMediator extends Mediator
	{
		[Inject]
		public var view : GamePlayView;
		
		[Inject]
		public var soundData : SoundModel;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		private var _isClick : Boolean;
		
		private var _btnId : uint;
		private var _panelId : uint;
		private var _iconId : uint;
		
		private var _cpyMc : MovieClip;
		private var _pastryPool : Array = [];
		
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
			_btnId = 999;
			_panelId = _iconId = 0;
			
			for(var i : uint = 0; i < 6; ++i) {
				// 面板
				view.mcPanel(i).visible = false;
				view.mcPanel(i)["mc"].gotoAndStop(1);
				// 按钮
				view.btn(i).visible = true;
				// 飞机模型
				view.mcPlane(i).gotoAndStop(1);
				view.mcPlane(i)["mc"].gotoAndStop(1);
			}
			view.mcIconPanel().visible = false;
			
			// 功能按钮
			view.btnBack().visible = true;
			view.btnOK().visible = true;
			view.btnRevert().visible = true;
			view.btnIcon().visible = true;
			
			view.btnExit().visible = false;
			view.mcMov().gotoAndStop(1);
			view.mcMov().visible = false;
			
			clearPool();
			
			_isClick = false;
			soundPlay(soundData.getEffect(2));
		}
		
		private function soundPlay(name : String) : void
		{
			if(!_soundManager.isPlaying(name))
			{
				_soundManager.stopSoundExpect(soundData.getEffect(0));
				_soundManager.playSound(name);
			}
		}
		
		private function selfClone(target:DisplayObject, autoAdd:Boolean = false) : DisplayObject
		{
			var targetClass:Class = Object(target).constructor;
			var duplicate:DisplayObject = new targetClass();
			
			// duplicate properties
			duplicate.transform = target.transform;
			duplicate.filters = target.filters;
			duplicate.cacheAsBitmap = target.cacheAsBitmap;
			duplicate.opaqueBackground = target.opaqueBackground;
			
			if (target.scale9Grid) {
				var rect:Rectangle = target.scale9Grid;
				// Flash 9 bug where returned scale9Grid is 20x larger than assigned
				rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
				duplicate.scale9Grid = rect;
			}
			// add to target parent's display list
			// if autoAdd was provided as true
			if (autoAdd && target.parent) {
				target.parent.addChild(duplicate);
			}
			return duplicate;
		}
		
		private function clearPool() : void
		{
			var len : uint = _pastryPool.length;
			if(len > 0) {
				for(var i : uint = 0; i < len; ++i) {
					view.removeChild(_pastryPool[i]);
					_pastryPool[i] = null;
				}
				_pastryPool.splice(0, len);
			}
		}
		private function gameOver() : void
		{
			for(var i : uint = 0; i < 6; ++i) {
				// 面板
				view.mcPanel(i).visible = false;
				// 按钮
				view.btn(i).visible = false;
			}
			// icon 面板
			view.mcIconPanel().visible = false;
			
			// 功能按钮
			view.btnBack().visible = false;
			view.btnOK().visible = false;
			view.btnRevert().visible = false;
			view.btnIcon().visible = false;
			
			view.btnExit().visible = true;
			view.mcMov().gotoAndPlay(1);
			view.mcMov().visible = true;
			view.addChild(view.mcMov());
			
			
			var rand : Number = Math.random();
			soundPlay(soundData.getEffect(rand<0.5?5:6));
		}
		
		private function onFeatureHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			
			var name : String = e.currentTarget.name;
			switch(name) {
				case "tuichuBtn":
					_isClick = true;
					
					soundPlay(soundData.getEffect(3));
					TweenLite.to(view.btnBack(), 1.2, {onComplete:function():void{
						eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameStartView));
					}});
					break;
				case "exitBtn":
					_isClick = true;
					
					soundPlay(soundData.getEffect(3));
					TweenLite.to(view.btnBack(), 1.2, {onComplete:function():void{
						eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameStartView));
					}});
					break;
				case "chexiaoBtn":
					var len : uint = _pastryPool.length;
					if(len > 0) {
						view.removeChild(_pastryPool[len - 1]);
						var mc : MovieClip = _pastryPool.pop();
						mc = null;
					}
					break;
				case "wanchengBtn":
					gameOver();
					break;
				case "ziyou2Btn":
					view.mcIconPanel().visible = !view.mcIconPanel().visible;
					for(var i : uint = 0; i < 6; ++i) {
						view.mcPanel(i).visible = false;
					}
					break;
				default:
					break;
			}
		}
		
		private function onPanelHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			_panelId = id;
			_iconId = 0;
			view.mcPanel(_btnId)["mc"].gotoAndStop(id + 1);
			
			trace("1: " + _btnId + " 2: " + _panelId + " 3: " + _iconId);
			view.mcPlane(_btnId).gotoAndStop(id + 1);
			view.mcPlane(_btnId)["mc"].gotoAndStop(1);
		}
		
		private function onIconHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			_iconId = id;
			
			trace("1: " + _btnId + " 2: " + _panelId + " 3: " + _iconId);
			view.mcPlane(_btnId)["mc"].gotoAndStop(id + 1);
		}
		
		private function onBtnHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			view.mcIconPanel().visible = false;
			
			if(id == _btnId) {
				view.mcPanel(id).visible = false;
				_btnId = 999;
				return;
			}
			for(var i : uint = 0; i < 6; ++i) {
				view.mcPanel(i).visible = false;
			}
			view.mcPanel(id).visible = true;
			_btnId = id;
		}
		
		private function onAbcIconHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			var refMc : MovieClip = view.mcIconPanel()["mc_" + id];
			_cpyMc = selfClone(refMc) as MovieClip;
			_cpyMc.startDrag(true);
			_cpyMc.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			view.addChild(_cpyMc);
		}
		
		private function onMouseUp(e : MouseEvent) : void
		{
			_cpyMc.stopDrag();
			_cpyMc.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			if(view.mcPlane().hitTestObject(_cpyMc)) {
				_pastryPool.push(_cpyMc);
			} else {
				view.removeChild(_cpyMc);
				_cpyMc = null;
			}
		}
		
		private function addEvent() : void
		{
			view.btnBack().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnExit().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnRevert().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnOK().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnIcon().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			var i : uint;
			var j : uint
			for(i = 0; i < 18; ++i) {
				// 面板
				if(i < 6) {
					for(j = 0; j < 6; ++j) {
						view.mcPanel(i)["btn_" + j].addEventListener(MouseEvent.CLICK, onPanelHandler);
						view.mcPanel(i)["mc"]["btn_" + j].addEventListener(MouseEvent.CLICK, onIconHandler);
					}
					// 按钮
					view.btn(i).addEventListener(MouseEvent.CLICK, onBtnHandler);
				}
				// icon 按钮
				view.mcIconPanel()["mc_" + i].addEventListener(MouseEvent.MOUSE_DOWN, onAbcIconHandler);
			}
		}
		
		private function removeEvent() : void
		{
			view.btnBack().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnExit().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnRevert().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnOK().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnIcon().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			var i : uint;
			var j : uint
			for(i = 0; i < 18; ++i) {
				// 面板
				if(i < 6) {
					for(j = 0; j < 6; ++j) {
						view.mcPanel(i)["btn_" + j].removeEventListener(MouseEvent.CLICK, onPanelHandler);
						view.mcPanel(i)["mc"]["btn_" + j].removeEventListener(MouseEvent.CLICK, onIconHandler);
					}
					// 按钮
					view.btn(i).removeEventListener(MouseEvent.CLICK, onBtnHandler);
				}
				// icon 按钮
				view.mcIconPanel()["mc_" + i].removeEventListener(MouseEvent.MOUSE_DOWN, onAbcIconHandler);
			}
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			clearPool();
			
			TweenLite.killTweensOf(view.btnBack());
			
			
			super.destroy();
		}
	}
}