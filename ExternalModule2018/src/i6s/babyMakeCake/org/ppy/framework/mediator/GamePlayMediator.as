package i6s.babyMakeCake.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import i6s.babyMakeCake.org.ppy.framework.event.PPYEvent;
	import i6s.babyMakeCake.org.ppy.framework.model.SoundModel;
	import i6s.babyMakeCake.org.ppy.framework.util.SoundManager;
	import i6s.babyMakeCake.org.ppy.framework.view.GamePlayView;
	import i6s.babyMakeCake.org.ppy.framework.view.GameStartView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-17 下午3:17:39
	 **/
	public class GamePlayMediator extends Mediator
	{
		[Inject]
		public var view : GamePlayView;
		
		[Inject]
		public var soundData : SoundModel;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		private var _isClick : Boolean;
		
		private var _curId : uint;
		private var _pastryArr : Array = [8, 12, 6, 11, 21, 8, 12, 7, 6];
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
			for(var i : uint = 0; i < 9; ++i) {
				view.mcIcon(i).gotoAndStop(1);
				view.mcIcon(i).visible = true;
			}
			view.mcCake().gotoAndStop(1);
			
			view.btnOK().visible = true;
			view.btnRevert().visible = true;
			view.movRabbit().gotoAndStop(1);
			view.movSuc().gotoAndStop(1);
			view.movSuc().visible = false;
			
			showPanel(false);
			
			_isClick = false;
			soundPlay(soundData.getEffect(4));
		}
		
		private function soundPlay(name : String) : void
		{
			if(!_soundManager.isPlaying(name))
			{
				_soundManager.stopSoundExpect(soundData.getEffect(0));
				_soundManager.playSound(name);
			}
		}
		
		private function showPanel(bl : Boolean, id : uint = 0) : void
		{
			var len : uint = _pastryArr.length;
			var i : uint;
			for(i = 0; i < len; ++i) {
				view.mcPastry(i).visible = false;
			}
			if(bl) {
				view.mcPastry(id).visible = true;
				view.mcPanel().visible = true;
			} else {
				view.mcPanel().visible = false;
			}
		}
		
		private function clickFun(id : uint) : void
		{
			if(_curId == 0) {
				view.mcCake().gotoAndStop(id + 2);
				clearPool();
			}
			if(view.mcCake().currentFrame == 1) {
				return;
			}
			
			if(_curId == 1) {
				view.mcCake()["mc"].gotoAndStop(id + 1);
			} else if(_curId == 2) {
				view.mcCake()["mc2"].gotoAndStop(id + 1);
			} else if(_curId == 8) {
				view.mcCake()["mc3"].gotoAndStop(id + 1);
			}
		}
		
		private function downFun(id : uint) : void
		{
			if(view.mcCake().currentFrame == 1) {
				return;
			}
			var refMc : MovieClip = view.mcPastry(_curId)["mc_" + id];
			
			_cpyMc = selfClone(refMc) as MovieClip;
			_cpyMc.startDrag(true);
			_cpyMc.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			view.addChild(_cpyMc);
		}
		
		private function onMouseUp(e : MouseEvent) : void
		{
			_cpyMc.stopDrag();
			_cpyMc.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			if(view.mcCake().hitTestObject(_cpyMc)) {
				_pastryPool.push(_cpyMc);
			} else {
				view.removeChild(_cpyMc);
				_cpyMc = null;
			}
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
		
		private function onSelectHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			switch(e.type) {
				case "click":
					soundPlay(soundData.getEffect(5));
					clickFun(id);
					break;
				case "mouseDown":
					downFun(id);
					break;
			}
		}
		
		private function onFeatureHandler(e : MouseEvent) : void
		{
			switch(e.currentTarget.name) {
				case "btnClose":
					if(_isClick)
						return;
					_isClick = true;
					
					
					soundPlay(soundData.getEffect(2));
					TweenLite.to(view.btnBack(), 1.2, {onComplete:function():void{
						eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameStartView));
					}});
					break;
				case "chexiaoBtn":
					soundPlay(soundData.getEffect(5));
					var len : uint = _pastryPool.length;
					if(len > 0) {
						view.removeChild(_pastryPool[len - 1]);
						var mc : MovieClip = _pastryPool.pop();
						mc = null;
					}
					break;
				case "wanchengBtn":
					if(view.mcCake().currentFrame != 1) {
						soundPlay(soundData.getEffect(6));
						for(var i : uint = 0; i < 9; ++i) {
							view.mcIcon(i).visible = false;
						}
						
						view.btnOK().visible = false;
						view.btnRevert().visible = false;
						view.movRabbit().gotoAndStop(2);
						view.movSuc().gotoAndPlay(1);
						view.movSuc().visible = true;
						
						showPanel(false);	
					}
					break;
				default:
					trace(e.currentTarget.name);
					break;
			}
		}
		
		private function onIconHandler(e : MouseEvent) : void
		{
			soundPlay(soundData.getEffect(5));
			_curId = uint(e.currentTarget.name.split("_")[1]);
			if(view.mcIcon(_curId).currentFrame == 1) {
				for(var i : uint = 0; i < 9; ++i) {
					view.mcIcon(i).gotoAndStop(1);
				}
				view.mcIcon(_curId).gotoAndStop(2);
				showPanel(true, _curId);
			} else {
				view.mcIcon(_curId).gotoAndStop(1);
				showPanel(false);
			}
		}
		
		private function addEvent() : void
		{
			var i : uint;
			view.btnBack().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnRevert().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnOK().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			for(i = 0; i < 9; ++i) {
				view.mcIcon(i).addEventListener(MouseEvent.CLICK, onIconHandler);
			}
			for(i = 0; i < _pastryArr.length; ++i) {
				for(var j : uint = 0; j < _pastryArr[i]; ++j) {
					if(i == 0 || i == 1 || i == 2 || i == 8) {
						view.mcPastry(i)["mc_" + j].addEventListener(MouseEvent.CLICK, onSelectHandler);
					} else {
						view.mcPastry(i)["mc_" + j].addEventListener(MouseEvent.MOUSE_DOWN, onSelectHandler);	
					}
				}
			}
		}
		
		private function removeEvent() : void
		{
			var i : uint;
			view.btnBack().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnRevert().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnOK().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			for(i = 0; i < 9; ++i) {
				view.mcIcon(i).removeEventListener(MouseEvent.CLICK, onIconHandler);
			}
			for(i = 0; i < _pastryArr.length; ++i) {
				for(var j : uint = 0; j < _pastryArr[i]; ++j) {
					if(i == 0 || i == 1 || i == 2 || i == 8) {
						view.mcPastry(i)["mc_" + j].removeEventListener(MouseEvent.CLICK, onSelectHandler);
					} else {
						view.mcPastry(i)["mc_" + j].removeEventListener(MouseEvent.MOUSE_DOWN, onSelectHandler);	
					}
				}
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