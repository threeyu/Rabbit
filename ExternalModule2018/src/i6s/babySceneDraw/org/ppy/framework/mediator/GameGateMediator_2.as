package i6s.babySceneDraw.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	import i6s.babySceneDraw.org.ppy.framework.event.PPYEvent;
	import i6s.babySceneDraw.org.ppy.framework.model.SoundModel;
	import i6s.babySceneDraw.org.ppy.framework.util.SoundManager;
	import i6s.babySceneDraw.org.ppy.framework.view.GameGateView_2;
	import i6s.babySceneDraw.org.ppy.framework.view.GameMenuView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-27 下午2:05:32
	 **/
	public class GameGateMediator_2 extends Mediator
	{
		[Inject]
		public var view : GameGateView_2;
		
		[Inject]
		public var soundData : SoundModel;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		private var _isClick : Boolean;
		
		private const ICON_NUM : uint = 6;
		private const PEN_NUM : uint = 14;
		private const MAX_COLOR : uint = 20;
		private const COLOR_ARR : Array = [
			0x138638, 0x4FC527, 0x2CD4F7, 0x26AEDF, 0x1A71B8, 0x442E6E, 0xFFFFFF,
			0x8E0F82, 0x392558, 0xDF3C71, 0xE95900, 0xF98F00, 0xFFB324, 0x754819
		];
		
		private var _skip : Boolean;
		private var _posArr : Array;
		private var _curIcon : uint = 999;
		private var _ctf : ColorTransform;
		
		public function GameGateMediator_2()
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
			_posArr = [];
			for(var i : uint = 0; i < ICON_NUM; ++i) {
				_posArr.push({
					x: view.mcIcon(i).x,
					y: view.mcIcon(i).y,
					scaleX: view.mcIcon(i).scaleX,
					scaleY: view.mcIcon(i).scaleY
				});
			}
			_ctf = new ColorTransform();
			_ctf.color = COLOR_ARR[0];
			_skip = false;
			
			view.mcPicture().visible = true;
			hidePan();
			hideIcons(false);
			
			
			_isClick = false;
			soundPlay(soundData.getEffect(5));
			TweenLite.to(view.mcPicture(), 4, {onComplete:function() : void {
				if(_skip)
					return;
				view.mcPicture().visible = false;
			}});
		}
		
		private function soundPlay(name : String) : void
		{
			_soundManager.stopSoundExpect(soundData.getEffect(0));
			_soundManager.playSound(name);
		}
		
		private function hideIcons(bl : Boolean = true) : void
		{
			for(var i : uint = 0; i < ICON_NUM; ++i) {
				view.mcIcon(i).visible = !bl;
				view.mcIcon(i)["btn"].visible = !bl;
			}
		}
		private function hidePan(bl : Boolean = true) : void
		{
			view.mcPan().visible = !bl;
			for(var i : uint = 0; i < PEN_NUM; ++i) {
				view.mcPen(i).gotoAndStop(1);
			}
			view.mcPen(0).gotoAndStop(bl?1:2);
			_ctf.color = COLOR_ARR[0];
		}
		
		private function clearPool() : void
		{
			var len : uint = _posArr.length;
			var i : uint, j : uint;
			if(len > 0) {
				for(i = 0; i < len; ++i) {
					_posArr[i] = null;
				}
				_posArr.splice(0, len);
				_posArr = null;
			}
			
			
			_ctf.color = COLOR_ARR[6];
			for(i = 0; i < ICON_NUM; ++i) {
				for(j = 0; j < MAX_COLOR; ++j) {
					if(view.mcIcon(i).hasOwnProperty("color_" + j)) {
						view.mcIcon(i)["color_" + j].transform.colorTransform = _ctf;
					}
				}
			}
		}
		
		private function onIconHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			
			_curIcon = uint((e.currentTarget as MovieClip).parent.name.split("_")[1]);
			var x : uint = 512, y : uint = 300;
			var sX : Number, sY : Number;
			var scaleArr : Array = [1, 2, 2, 1.6, 2.8, 2.4];
			sX = sY = scaleArr[_curIcon];
			
			hidePan(false);
			hideIcons();
			view.mcIcon(_curIcon).visible = true;
			if(_curIcon == 0) {// 背景mc
				
			} else {// 非背景mc
				view.mcIcon(_curIcon).x = x;
				view.mcIcon(_curIcon).y = y;
				view.mcIcon(_curIcon).scaleX = sX;
				view.mcIcon(_curIcon).scaleY = sY;
			}
		}
		
		private function onFillColorHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			view.mcIcon(_curIcon)["color_" + id].transform.colorTransform = _ctf;
		}
		
		private function onPickColorHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			for(var i : uint = 0; i < PEN_NUM; ++i) {
				view.mcPen(i).gotoAndStop(1);
			}
			view.mcPen(id).gotoAndStop(2);
			_ctf.color = COLOR_ARR[id];
		}
		
		private function onPanHideHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			
			hidePan();
			hideIcons(false);
			_curIcon = 999;
			for(var i : uint = 0 ; i < ICON_NUM; ++i) {
				if(view.mcIcon(i).x != _posArr[i].x) {
					view.mcIcon(i).x = _posArr[i].x;
					view.mcIcon(i).y = _posArr[i].y;
					view.mcIcon(i).scaleX = _posArr[i].scaleX;
					view.mcIcon(i).scaleY = _posArr[i].scaleY;
					break;
				}
			}
			
			var rand : Number = Math.random();
			soundPlay(soundData.getEffect(rand<0.5?7:8));
		}
		
		private function onSkipPicHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			
			_skip = true;
			if(view.mcPicture().visible)
				view.mcPicture().visible = false;
		}
		
		private function onFeatureHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			
			var name : String = e.currentTarget.name;
			switch(name) {
				case "btnBack":
					_isClick = true;
					
					soundPlay(soundData.getEffect(2));
					TweenLite.to(view.mcPicture(), 1.2, {onComplete:function():void{
						eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameMenuView));
					}});
					break;
				case "btnPicture":
					soundPlay(soundData.getEffect(6));
					view.mcPicture().visible = true;
					break;
				default:
					break;
			}
		}
		
		private function addEvent() : void
		{
			view.btnBack().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnPic().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.mcPicture().addEventListener(MouseEvent.CLICK, onSkipPicHandler);
			view.btnPanBack().addEventListener(MouseEvent.CLICK, onPanHideHandler);
			var i : uint, j : uint;
			for(i = 0; i < ICON_NUM; ++i) {
				view.mcIcon(i)["btn"].addEventListener(MouseEvent.CLICK, onIconHandler);
				for(j = 0; j < MAX_COLOR; ++j) {
					if(view.mcIcon(i).hasOwnProperty("color_" + j)) {
						view.mcIcon(i)["color_" + j].addEventListener(MouseEvent.CLICK, onFillColorHandler);
					}
				}
			}
			for(i = 0; i < PEN_NUM; ++i) {
				view.mcPen(i).addEventListener(MouseEvent.CLICK, onPickColorHandler);
			}
		}
		
		private function removeEvent() : void
		{
			view.btnBack().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnPic().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.mcPicture().removeEventListener(MouseEvent.CLICK, onSkipPicHandler);
			view.btnPanBack().removeEventListener(MouseEvent.CLICK, onPanHideHandler);
			var i : uint, j : uint;
			for(i = 0; i < ICON_NUM; ++i) {
				view.mcIcon(i)["btn"].removeEventListener(MouseEvent.CLICK, onIconHandler);
				for(j = 0; j < MAX_COLOR; ++j) {
					if(view.mcIcon(i).hasOwnProperty("color_" + j)) {
						view.mcIcon(i)["color_" + j].removeEventListener(MouseEvent.CLICK, onFillColorHandler);
					}
				}
			}
			for(i = 0; i < PEN_NUM; ++i) {
				view.mcPen(i).removeEventListener(MouseEvent.CLICK, onPickColorHandler);
			}
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			clearPool();
			_ctf = null;
			
			TweenLite.killTweensOf(view.mcPicture());
			
			
			super.destroy();
		}
	}
}