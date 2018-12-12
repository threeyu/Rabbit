package i6s.babyDrawAndGuess.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	
	import i6s.babyDrawAndGuess.org.ppy.framework.event.PPYEvent;
	import i6s.babyDrawAndGuess.org.ppy.framework.model.GameConfig;
	import i6s.babyDrawAndGuess.org.ppy.framework.model.IPlayInfoModel;
	import i6s.babyDrawAndGuess.org.ppy.framework.model.SoundModel;
	import i6s.babyDrawAndGuess.org.ppy.framework.util.SoundManager;
	import i6s.babyDrawAndGuess.org.ppy.framework.util.drawTool.Brush;
	import i6s.babyDrawAndGuess.org.ppy.framework.util.drawTool.Graphic;
	import i6s.babyDrawAndGuess.org.ppy.framework.view.GamePlayView;
	import i6s.babyDrawAndGuess.org.ppy.framework.view.GameStartView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-12 下午5:33:50
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
		private var _tipsId : uint;
		
		private const LINE_SIZE : Array = [2, 5, 10];
		private const ERASE_SIZE : Array = [10, 20, 30];
		private const LINE_COLOR : Array = [0x000000, 0x33A7D8, 0x33B8A7, 0xA6FB3C, 
			0xF04950, 0xE965AE, 0xB868AD, 0x8869AD];
		
		private var _canDraw : Boolean;
		private var _lineSize : int;
		private var _lineColor : uint;
		private var _lineAlpha : Number;
		private var _pen : Graphic;
		private var _drawArr : Array;
		
		private var _mode : uint;
		private var _selID : uint;
		private var _guessID : uint;
		private const MODE_DRAW : uint = 1;
		private const MODE_GUESS : uint = 2;
		
		private var _firstEnter : Boolean = true;
		
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
			
			
			_pen = new Brush();
			view.addChild(_pen);
			
			setup();
			
			_isClick = false;
			
			
			if(playInfo.getFirst()) {
				showTips();
				playInfo.setFirst(false);
			} else {
				soundPlay(soundData.getEffect(4));
			}
		}
		
		private function showTips() : void
		{
			_tipsId = 0;
			view.movHelp().visible = true;
			tipsStep();
		}
		private function tipsStep() : void
		{
			if(_tipsId == 5) {
				view.movHelp().visible = false;
				soundPlay(soundData.getEffect(4));
				return;
			}
			var delayArr : Array = [3.4, 4.2, 3.2, 5.4, 2.4];
			soundPlay(soundData.getTips(_tipsId));
			view.movHelp().gotoAndStop(_tipsId + 1);
			TweenLite.to(view.btnBack(), delayArr[_tipsId++], {onComplete:tipsStep});
		}
		
		private function soundPlay(name : String) : void
		{
			if(!_soundManager.isPlaying(name))
			{
				_soundManager.stopSoundExpect(soundData.getEffect(0));
				_soundManager.playSound(name);
			}
		}
		
		private function setup() : void
		{
			_lineSize = 2;
			_lineColor = 0x000000;
			_lineAlpha = 1;
			_drawArr = [];
			
			_mode = 1;
			_selID = _guessID = 999;
			
			setupDraw(false);
			_pen.lineSize = _lineSize;
			_pen.lineColor = _lineColor;
			_pen.lineAlpha = _lineAlpha;
			_pen.shapeSprite = view.mcCanvas();
			_pen.allShapeArr = _drawArr;
			
			var rand : uint = uint(Math.random() * 2 + 1);
			var lvl : uint = playInfo.getLevel();
			for(var i : uint = 0; i < 4; ++i) {
				view.mcIcon(i).visible = true;
				view.mcIcon(i).gotoAndStop(lvl * 2 + rand);
			}
			view.mcPalette().gotoAndStop(1);
			view.mcOK().gotoAndStop(1);
			view.movRight().gotoAndStop(1);
			view.movWrong().gotoAndStop(1);
			view.movHelp().gotoAndStop(1);
			view.movRight().visible = false;
			view.movWrong().visible = false;
			view.movHelp().visible = false;
		}
		
		private function setupDraw(bl : Boolean) : void
		{
			_canDraw = bl;
			_pen.canDraw = _canDraw;
		}
		
		private function onIconHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			var i : uint;
			soundPlay(soundData.getEffect(5));
			if(_mode == MODE_DRAW) {
				if(_selID == 999) {// 如果没选择
					for(i = 0; i < 4; ++i) {
						view.mcIcon(i).visible = false;
					}
					view.mcIcon(id).visible = true;
					_selID = id;
					setupDraw(true);
				} else {
					for(i = 0; i < 4; ++i) {
						view.mcIcon(i).visible = true;
					}
					_selID = 999;
					setupDraw(false);
				}
			} else if(_mode == MODE_GUESS) {
				if(_guessID == 999) {// 如果没猜测
					for(i = 0; i < 4; ++i) {
						view.mcIcon(i).visible = false;
					}
					view.mcIcon(id).visible = true;
					_guessID = id;
				} else {
					for(i = 0; i < 4; ++i) {
						view.mcIcon(i).visible = true;
					}
					_guessID = 999;
				}
			}
		}
		
		private function onOKHandler(e : MouseEvent) : void
		{
			var id : uint = view.mcOK().currentFrame;
			var i : uint;
			soundPlay(soundData.getEffect(5));
			if(_mode == MODE_DRAW) {
				if(_selID == 999) {// 如果没选择
					return;
				} else {
					for(i = 0; i < 4; ++i) {
						view.mcIcon(i).visible = true;
					}
					setupDraw(false);
					view.mcOK().gotoAndStop(2);
					_mode = MODE_GUESS;
					
					soundPlay(soundData.getEffect(12));
				}
			} else if(_mode == MODE_GUESS) {
				if(_guessID == 999) {// 如果没猜测
					return;
				} else {
					if(_selID == _guessID) {
						view.movRight().visible = true;
						view.movRight().gotoAndPlay(1);
						
						soundPlay(soundData.getEffect(10));
					} else {
						view.movWrong().visible = true;
						view.movWrong().gotoAndPlay(1);
						
						soundPlay(soundData.getEffect(11));
					}
				}
			}
		}
		
		private function onDrawHandler(e : MouseEvent) : void
		{
			if(!_canDraw)
				return;
			
			var nameArr : Array = e.currentTarget.name.split("_");
			soundPlay(soundData.getEffect(5));
			switch(String(nameArr[0])) {
				case "color":
					var id : uint = uint(nameArr[1]);
					if(_lineColor == LINE_COLOR[id])
						return;
					
					_lineSize = LINE_SIZE[0];
					_lineColor = LINE_COLOR[id];
					_pen.lineSize = _lineSize;
					_pen.lineColor = _lineColor;
					view.mcPalette().gotoAndStop(id + 1);
					break;
				case "btnPen":
					if(_lineColor == LINE_COLOR[0])
						return;
					
					_lineSize = LINE_SIZE[0];
					_lineColor = LINE_COLOR[0];
					_pen.lineSize = _lineSize;
					_pen.lineColor = _lineColor;
					break;
				case "btnErase":
					if(_lineColor == gameConfig.getStageBG())
						return;
					
					_lineSize = ERASE_SIZE[2];
					_lineColor = gameConfig.getStageBG();
					_pen.lineSize = _lineSize;
					_pen.lineColor = _lineColor;
					break;
			}
		}
		
		private function onResultHandler(e : MouseEvent) : void
		{
			var name : String = String(e.currentTarget.name);
			soundPlay(soundData.getEffect(5));
			switch(name) {
				case "right":
					eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameStartView));
					break;
				case "wrong":
					clearPool();
					setup();
					break;
			}
		}
		
		private function onBackHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			_isClick = true;
			
			soundPlay(soundData.getEffect(2));
			TweenLite.to(view.btnBack(), 1.2, {onComplete:function():void{
				eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameStartView));
			}});
		}
		
		private function onDelHandler(e : MouseEvent) : void
		{
			if(!_canDraw)
				return;
			clearPool();
			soundPlay(soundData.getEffect(6));
		}
		
		private function addEvent() : void
		{
			view.btnBack().addEventListener(MouseEvent.CLICK, onBackHandler);
			view.mcOK().addEventListener(MouseEvent.CLICK, onOKHandler);
			view.btnDel().addEventListener(MouseEvent.CLICK, onDelHandler);
			view.btnPen().addEventListener(MouseEvent.CLICK, onDrawHandler);
			view.btnErase().addEventListener(MouseEvent.CLICK, onDrawHandler);
			for(var i : uint = 0; i < 8; ++i) {
				if(i < 4) {
					view.mcIcon(i).addEventListener(MouseEvent.CLICK, onIconHandler);
				}
				view.mcColor(i).addEventListener(MouseEvent.CLICK, onDrawHandler);
			}
			view.movRight()["right"].addEventListener(MouseEvent.CLICK, onResultHandler);
			view.movWrong()["wrong"].addEventListener(MouseEvent.CLICK, onResultHandler);
		}
		
		private function removeEvent() : void
		{
			view.btnBack().removeEventListener(MouseEvent.CLICK, onBackHandler);
			view.mcOK().removeEventListener(MouseEvent.CLICK, onOKHandler);
			view.btnDel().removeEventListener(MouseEvent.CLICK, onDelHandler);
			view.btnPen().removeEventListener(MouseEvent.CLICK, onDrawHandler);
			view.btnErase().removeEventListener(MouseEvent.CLICK, onDrawHandler);
			for(var i : uint = 0; i < 8; ++i) {
				if(i < 4) {
					view.mcIcon(i).removeEventListener(MouseEvent.CLICK, onIconHandler);
				}
				view.mcColor(i).removeEventListener(MouseEvent.CLICK, onDrawHandler);
			}
			view.movRight()["right"].removeEventListener(MouseEvent.CLICK, onResultHandler);
			view.movWrong()["wrong"].removeEventListener(MouseEvent.CLICK, onResultHandler);
			
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