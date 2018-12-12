package i6s.babyFunnyDraw.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	import i6s.babyFunnyDraw.org.ppy.framework.event.PPYEvent;
	import i6s.babyFunnyDraw.org.ppy.framework.model.IPlayInfoModel;
	import i6s.babyFunnyDraw.org.ppy.framework.model.SoundModel;
	import i6s.babyFunnyDraw.org.ppy.framework.util.SoundManager;
	import i6s.babyFunnyDraw.org.ppy.framework.view.GameGateView_0;
	import i6s.babyFunnyDraw.org.ppy.framework.view.GameMenuView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-27 下午4:53:23
	 **/
	public class GameGateMediator_0 extends Mediator
	{
		[Inject]
		public var view : GameGateView_0;
		
		[Inject]
		public var playInfo : IPlayInfoModel;
		
		[Inject]
		public var soundData : SoundModel;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		private var _isClick : Boolean;
		private var _type : uint;
		
		private const ICON_NUM : uint = 9;
		private const PEN_NUM : uint = 14;
		private const MAX_COLOR : uint = 20;
		private const COLOR_ARR : Array = [
			0x000000, 0xABABAB, 0xFD878A, 0xFF4343, 0xFF69CB, 0xFFE600, 0xFF9100,
			0xFFFFFF, 0x2DC200, 0x268F00, 0x3BCBFF, 0x49A2FA, 0xC478FF, 0x74471E
		];
		
		private var _iconInfoArr : Array;
		private var _curIcon : uint = 999;
		private var _ctf : ColorTransform;
		
		private var _gameOverFlg : Boolean = false;
		
		public function GameGateMediator_0()
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
			_iconInfoArr = [];
			for(var i : uint = 0; i < ICON_NUM; ++i) {
				_iconInfoArr.push({
					x: view.mcIcon(i).x,
					y: view.mcIcon(i).y,
					scaleX: view.mcIcon(i).scaleX,
					scaleY: view.mcIcon(i).scaleY,
					type: setType(i)
				});
			}
			_ctf = new ColorTransform();
			_ctf.color = COLOR_ARR[0];
			
			hidePan();
			hideIcons(false);
			
			view.mcMov().gotoAndStop(1);
			view.mcMov().visible = false;
			
			_isClick = false;
			
		}
		
		private function soundPlay(name : String) : void
		{
			_soundManager.stopSoundExpect(soundData.getEffect(0));
			_soundManager.playSound(name);
		}
		private function setType(id : uint) : uint
		{
			if(id == 0) {// 跑一次
				_type = Math.floor(Math.random() * 3);
				soundPlay(soundData.getFesTypeTips(_type));
			}
			
			
			var result : uint;
			if(id == 0 || id == 3 || id == 6) {// 春节
				result = playInfo.getType().eazy;
			} else if(id == 2 || id == 5 || id == 8) {// 圣诞
				result = playInfo.getType().normal;
			} else {// 万圣
				result = playInfo.getType().hard;
			}
			return result;
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
			var len : uint = _iconInfoArr.length;
			var i : uint, j : uint;
			if(len > 0) {
				for(i = 0; i < len; ++i) {
					_iconInfoArr[i] = null;
				}
				_iconInfoArr.splice(0, len);
				_iconInfoArr = null;
			}
			
			
			_ctf.color = COLOR_ARR[7];
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
			if(_iconInfoArr[_curIcon].type == _type) {// 正确节日
				soundPlay(soundData.getEffect(6));
			} else {// 错误节日
				var rand : Number = Math.random();
				soundPlay(soundData.getEffect(rand<0.5?7:8));
				return;
			}
			
			
			var x : uint = 512, y : uint = 300;
			var sX : Number, sY : Number;
			var scaleArr : Array = [3, 3.5, 2.8, 3, 3, 3, 3, 3, 2.3];
			sX = sY = scaleArr[_curIcon];
			
			hidePan(false);
			hideIcons();
			view.mcIcon(_curIcon).visible = true;
			// 非背景mc
			view.mcIcon(_curIcon).x = x;
			view.mcIcon(_curIcon).y = y;
			view.mcIcon(_curIcon).scaleX = sX;
			view.mcIcon(_curIcon).scaleY = sY;
		}
		
		private function onFillColorHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			view.mcIcon(_curIcon)["color_" + id].transform.colorTransform = _ctf;
		}
		
		private function onPickColorHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			for(var i : uint = 0; i < PEN_NUM; ++i) {
				view.mcPen(i).gotoAndStop(1);
			}
			view.mcPen(id).gotoAndStop(2);
			_ctf.color = COLOR_ARR[id];
		}
		
		private function onPanHideHandler(e : MouseEvent) : void
		{
			if(_gameOverFlg)
				return;
			soundPlay(soundData.getEffect(5));
			_gameOverFlg = true;
			
			view.mcMov().visible = true;
			view.mcMov().gotoAndPlay(1);
			TweenLite.to(view.mcMov(), 1, {onComplete:function():void{
				_gameOverFlg = false;
				view.mcMov().visible = false;
				view.mcMov().gotoAndStop(1);
				
				hidePan();
				hideIcons(false);
				_curIcon = 999;
				for(var i : uint = 0 ; i < ICON_NUM; ++i) {
					if(view.mcIcon(i).x != _iconInfoArr[i].x) {
						view.mcIcon(i).x = _iconInfoArr[i].x;
						view.mcIcon(i).y = _iconInfoArr[i].y;
						view.mcIcon(i).scaleX = _iconInfoArr[i].scaleX;
						view.mcIcon(i).scaleY = _iconInfoArr[i].scaleY;
						break;
					}
				}				
			}});
		}
		
		private function onFeatureHandler(e : MouseEvent) : void
		{
			var name : String = e.currentTarget.name;
			switch(name) {
				case "btnBack":
					if(_isClick)
						return;
					_isClick = true;
					
					soundPlay(soundData.getEffect(2));
					TweenLite.to(view.mcMov(), 1.2, {onComplete:function():void{
						_soundManager.stopSoundExpect(soundData.getEffect(0));
						eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameMenuView));
					}});
					break;
				default:
					break;
			}
		}
		
		private function addEvent() : void
		{
			view.btnBack().addEventListener(MouseEvent.CLICK, onFeatureHandler);
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
			
			TweenLite.killTweensOf(view.mcMov());
			
			
			super.destroy();
		}
	}
}