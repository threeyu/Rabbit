package i6s.babyDrwa.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	
	import i6s.babyDrwa.org.ppy.framework.event.PPYEvent;
	import i6s.babyDrwa.org.ppy.framework.model.GameConfig;
	import i6s.babyDrwa.org.ppy.framework.model.IPlayInfoModel;
	import i6s.babyDrwa.org.ppy.framework.model.SoundModel;
	import i6s.babyDrwa.org.ppy.framework.util.SoundManager;
	import i6s.babyDrwa.org.ppy.framework.util.drawTool.Brush;
	import i6s.babyDrwa.org.ppy.framework.util.drawTool.Graphic;
	import i6s.babyDrwa.org.ppy.framework.view.GameMenuView;
	import i6s.babyDrwa.org.ppy.framework.view.GamePlayView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-11 下午3:31:46
	 **/
	public class GamePlayMediator extends Mediator
	{
		[Inject]
		public var view : GamePlayView;
		
		[Inject]
		public var playInfo : IPlayInfoModel;
		
		[Inject]
		public var gameConfig : GameConfig; 
		
		[Inject]
		public var soundData : SoundModel;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		private var _isClick : Boolean;
		
		private const LINE_SIZE : Array = [2, 5, 10];
		private const ERASE_SIZE : Array = [10, 20, 30];
		private const LINE_COLOR : Array = [0x000000, 0xE4342C, 0xFBE449, 0xFBF0B2, 
			0xFFE0AA, 0xB08000, 0xFFB3A3, 0x74AA00, 
			0x31A444, 0x875900, 0xF68531, 0x97CDFF, 
			0x858FFF, 0x8AC6A2, 0x8D969E, 0x45545B];
		
		private var _lineSize : int;
		private var _lineColor : uint;
		private var _lineAlpha : Number;
		private var _pen : Graphic;
		private var _drawArr : Array;
		
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
			view.mcCanvas().mask = view.mcCanvas()["mcCanvasMask"];
			
			_lineSize = 2;
			_lineColor = 0x000000;
			_lineAlpha = 1;
			_drawArr = [];
			
			_pen = new Brush();
			_pen.lineSize = _lineSize;
			_pen.lineColor = _lineColor;
			_pen.lineAlpha = _lineAlpha;
			_pen.shapeSprite = view.mcCanvas();
			_pen.allShapeArr = _drawArr;
			view.addChild(_pen);
			
			view.mcIcon().gotoAndStop(playInfo.getLevel() + 1);
			for(var i : uint = 0; i < 16; ++i) {
				view.mcColor(i).gotoAndStop(1);
				if(i < 3) {
					view.mcPen(i)["selectMc"].visible = false;
					view.mcErase(i)["selectMc"].visible = false;
				}
			}
			view.mcColor(0).gotoAndStop(2);
			view.mcPen(0)["selectMc"].visible = true;
			
			
			_isClick = false;
			soundPlay(soundData.getEffect(5));
		}
		
		private function soundPlay(name : String) : void
		{
			if(!_soundManager.isPlaying(name))
			{
				_soundManager.stopSoundExpect(soundData.getEffect(0));
				_soundManager.playSound(name);
			}
		}
		
		private function onBack(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			_isClick = true;
			
			soundPlay(soundData.getEffect(2));
			TweenLite.to(view.btnBack(), 1.2, {onComplete:function():void{
				eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameMenuView));
			}});
		}
		
		private function onDel(e : MouseEvent) : void
		{
			soundPlay(soundData.getEffect(6));
			clearPool();
		}
		
		private function onColorHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			if(view.mcColor(id).currentFrame == 2)
				return;
			for(var i : uint = 0; i < 16; ++i) {
				view.mcColor(i).gotoAndStop(1);
			}
			view.mcColor(id).gotoAndStop(2);
			
			_lineColor = LINE_COLOR[id];
			_pen.lineColor = _lineColor;
		}
		
		private function onPenHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			if(view.mcPen(id)["selectMc"].visible)
				return;
			
			var i : uint;
			for(i = 0; i < 3; ++i) {
				view.mcPen(i)["selectMc"].visible = false;
				view.mcErase(i)["selectMc"].visible = false;
			}
			view.mcPen(id)["selectMc"].visible = true;
			for(i = 0; i < 16; ++i) {
				if(view.mcColor(i).currentFrame == 2)
					break;
			}
			
			_lineSize = LINE_SIZE[id];
			_lineColor = LINE_COLOR[i];
			_pen.lineSize = _lineSize;
			_pen.lineColor = _lineColor;
		}
		
		private function onEraseHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			if(view.mcErase(id)["selectMc"].visible)
				return;
			
			for(var i : uint = 0; i < 3; ++i) {
				view.mcPen(i)["selectMc"].visible = false;
				view.mcErase(i)["selectMc"].visible = false;
			}
			view.mcErase(id)["selectMc"].visible = true;
			
			_lineSize = ERASE_SIZE[id];
			_lineColor = gameConfig.getStageBG();
			_pen.lineSize = _lineSize;
			_pen.lineColor = _lineColor;
		}
		
		private function addEvent() : void 
		{
			view.btnBack().addEventListener(MouseEvent.CLICK, onBack);
			view.btnDel().addEventListener(MouseEvent.CLICK, onDel);
			for(var i : uint = 0; i < 16; ++i) {
				view.mcColor(i).addEventListener(MouseEvent.CLICK, onColorHandler);
				if(i < 3) {
					view.mcPen(i).addEventListener(MouseEvent.CLICK, onPenHandler);
					view.mcErase(i).addEventListener(MouseEvent.CLICK, onEraseHandler);
				}
			}
		}
		
		private function removeEvent() : void
		{
			view.btnBack().removeEventListener(MouseEvent.CLICK, onBack);
			view.btnDel().removeEventListener(MouseEvent.CLICK, onDel);
			for(var i : uint = 0; i < 16; ++i) {
				view.mcColor(i).removeEventListener(MouseEvent.CLICK, onColorHandler);
				if(i < 3) {
					view.mcPen(i).removeEventListener(MouseEvent.CLICK, onPenHandler);
					view.mcErase(i).removeEventListener(MouseEvent.CLICK, onEraseHandler);
				}
			}
			
			_pen.stopDraw();
		}
		
		private function clearPool() : void
		{
			var len : uint = _drawArr.length;
			if(len > 0) {
				for(var i : uint = 0; i < len; ++i) {
					view.mcCanvas().removeChild(_drawArr[i]);
					_drawArr[i] = null;
				}
				_drawArr.splice(0, len);
			}
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			clearPool();
			_pen = null;
			
			TweenLite.killTweensOf(view.btnBack());
			
			
			super.destroy();
		}
	}
}