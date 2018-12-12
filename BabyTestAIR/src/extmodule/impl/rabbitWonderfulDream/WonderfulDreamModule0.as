package extmodule.impl.rabbitWonderfulDream
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	
	import extmodule.api.BaseExtModule;
	
	/**
	 * 美妙的梦境，第一关
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-11-9 下午5:36:30
	 **/
	public class WonderfulDreamModule0 extends BaseExtModule
	{
		[Inject]
		public var view : WonderfulDreamView0;
		
		private var _soundRoot : String = "resource/sound/rabbitWonderfulDream/";
		private var _bgm : String = "resource/sound/common/BGM_1.mp3";
		private var _url : String = "resource/extmodule/wonderfulDreamModule0UI.swf";
		
		
		
		private var wrongSoundArray:Array=["lvOneWrong","lvTwoWrong","lvThreeWrong","lvFourWrong"];
		private var rightSoundArray:Array=["lvOneRight","lvTwoRight","lvThreeRight","lvFourRight"];
		private var answeredNum:Number;
		private var questionNum:Number=4;
		private var answerTimes:Number=0;
		private var levelNum:Number=1;
		
		private var drawTempArray:Array;
		private var levelHuabanShape:Shape;
		
		
		private var _canvasArr : Array;
		
		
		public function WonderfulDreamModule0()
		{
			trace("----- 添加场景 -----");
			super(_url);
		}
		
		override protected function init():void
		{
			view.addToStage(_mainUI);
			
			
			
			_mainUI["mcTips"].visible = true;
			_mainUI["mcTips"].gotoAndStop(1);
			
			TweenLite.from(_mainUI["mcTips"]["mcLabel"], 2, {y:-400, ease:Back.easeOut});
			
//			trace("[sound]: 美妙的梦境");
			soundManager.playSound(_soundRoot + "titleSound.mp3");
			TweenLite.delayedCall(2.5, titleSoundCallback);
		}
		
		private function titleSoundCallback() : void
		{
			_mainUI["mcTips"].gotoAndStop(2);
			
			
//			trace("[sound]: 我经常跟。。。");
			soundManager.playSound(_soundRoot + "yindao.mp3");
			TweenLite.delayedCall(7, tipsSoundCallback);
		}
		private function tipsSoundCallback() : void
		{
			_mainUI["mcTips"].visible = false;
			_mainUI["mcTips"].gotoAndStop(1);
			
			
//			trace("[sound]: sound/question" + levelNum + ".mp3");
			soundManager.playSound(_soundRoot + "question" + levelNum + ".mp3");
			soundManager.playSound(_bgm);
			gameStart();
		}
		
		private function gameStart() : void
		{
			answeredNum=0; 
			
			
			for(var i:uint=0;i<questionNum;i++){
				_mainUI["wutiMc"+i].gotoAndStop(1);
				_mainUI["wutiMc"+i].typeNum=i;
				_mainUI["daanMc"+i].typeNum=i;
				_mainUI["wutiMc"+i].isRight=false;
				_mainUI["daanMc"+i].isRight=false;
			}
			
			
			clearPool();
			_canvasArr = [];
		}
		
		private function poolIn(displayObj : Shape) : void
		{
			_canvasArr.push(displayObj);
		}
		
		private function clearPool() : void
		{
			if(_canvasArr) {
				var len : uint = _canvasArr.length;
				for(var i : uint = 0; i < len; ++i) {
					(_canvasArr[i] as Shape).graphics.clear();
					(_canvasArr[i] as Shape).parent.removeChild(_canvasArr[i]);
					_canvasArr[i] = null;
				}
				_canvasArr.splice(0, len);
				_canvasArr = null;
			}
		}
		
		private function mouseUpOutFun():void
		{
			_mainUI["drawBoard"].removeEventListener(MouseEvent.MOUSE_MOVE,drawMouseMoveHandle);
			_mainUI["drawBoard"].removeEventListener(MouseEvent.MOUSE_UP,drawMouseUpHandle);
			_mainUI["drawBoard"].removeEventListener(MouseEvent.MOUSE_OUT,drawMouseOutHandle);
			if(drawTempArray.length>=2){
				if(drawTempArray[0].typeNum==drawTempArray[drawTempArray.length-1].typeNum){
					answeredNum++;
					for(var i:uint=0;i<drawTempArray.length;i++){
						drawTempArray[i].isRight=false;
					}
					drawTempArray[0].gotoAndStop(2);
					drawTempArray[drawTempArray.length-1].gotoAndStop(2);
					drawTempArray[0].isRight=true;
					drawTempArray[drawTempArray.length-1].isRight=true;
					
					
//					trace("[sound]: rightSoundArray[levelNum-1]+drawTempArray[0].typeNum.mp3。。。");
					soundManager.stopSoundExpect(_bgm);
					soundManager.playSound(_soundRoot + rightSoundArray[levelNum-1] + drawTempArray[0].typeNum + ".mp3");
					
					
					if(answeredNum==questionNum){
						_mainUI["drawBoard"].removeEventListener(MouseEvent.MOUSE_DOWN,drawMouseDownHandle);
						
						var score:Number=answerTimes-questionNum;
						var goldScoreNum:Number;
						if(score<=4){
							goldScoreNum=50;
						}else if(score>4&&score<=8){
							goldScoreNum=20;
						}else{
							goldScoreNum=10;
						}
						saveScore(goldScoreNum, 50);
						dispatch(new PPYEvent(CommandID.EXTMODULE_OVER));
					}
				}else{
					reset();
					for(var j:uint=0;j<questionNum;j++){
						if(drawTempArray.indexOf(_mainUI["wutiMc"+j])>=0){
							
//							trace("[sound]: sound/wrongSoundArray[levelNum-1]+_mainUI['wutiMc'+j].typeNum.mp3。。。");
							soundManager.stopSoundExpect(_bgm);
							soundManager.playSound(_soundRoot + wrongSoundArray[levelNum-1] + _mainUI['wutiMc'+j].typeNum + ".mp3");
							
						}
					}
				}
			}else{
				reset();
				
//				trace("[sound]: sound/noLine.mp3。。。");
				soundManager.stopSoundExpect(_bgm);
				soundManager.playSound(_soundRoot + "noLine.mp3");
			}
			answerTimes++;
			function reset():void{
				levelHuabanShape.graphics.clear();
				for(i=0;i<drawTempArray.length;i++){
					drawTempArray[i].isRight=false;
				}
			}
		}
		
		// 事件
		private function onClose(e : MouseEvent) : void
		{
			view.removeFromStage();
		}
		
		private function drawMouseDownHandle(e:MouseEvent):void
		{
			drawTempArray=[];
			levelHuabanShape=new Shape();
			_mainUI.addChild(levelHuabanShape);
			poolIn(levelHuabanShape);
			
			levelHuabanShape.graphics.clear();
			levelHuabanShape.graphics.lineStyle(5,0xCC0000);
			levelHuabanShape.graphics.moveTo(levelHuabanShape.mouseX,levelHuabanShape.mouseY);
			
			_mainUI["drawBoard"].addEventListener(MouseEvent.MOUSE_MOVE,drawMouseMoveHandle);
			_mainUI["drawBoard"].addEventListener(MouseEvent.MOUSE_UP,drawMouseUpHandle);
			_mainUI["drawBoard"].addEventListener(MouseEvent.MOUSE_OUT,drawMouseOutHandle);
		}
		
		private function drawMouseMoveHandle(e:MouseEvent):void
		{
			levelHuabanShape.graphics.lineTo(levelHuabanShape.mouseX,levelHuabanShape.mouseY);
			var tempX:Number=e.localX;
			var tempY:Number=e.localY;
			
			for(var i:uint=0;i<questionNum;i++){
				if(Math.abs(tempX-_mainUI["wutiMc"+i].x)<=67&&Math.abs(tempY-_mainUI["wutiMc"+i].y)<=67){
					if(!_mainUI["wutiMc"+i].isRight){
						_mainUI["wutiMc"+i].isRight=true;
						drawTempArray.push(_mainUI["wutiMc"+i]);
					}
				}
				if(Math.abs(tempX-_mainUI["daanMc"+i].x)<=17&&Math.abs(tempY-_mainUI["daanMc"+i].y)<=17){
					if(!_mainUI["daanMc"+i].isRight){
						_mainUI["daanMc"+i].isRight=true;
						drawTempArray.push(_mainUI["daanMc"+i]);
					}
				}
			}
		}
		
		private function drawMouseUpHandle(e:MouseEvent):void
		{
			mouseUpOutFun();
		}
		private function drawMouseOutHandle(e:MouseEvent):void
		{
			mouseUpOutFun();
		}
		
		private function onPlayTitleHandler(e : MouseEvent) : void
		{
			soundManager.stopSoundExpect(_bgm);
			soundManager.playSound(_soundRoot + "question" + levelNum + ".mp3");
		}
		
		override protected function addEvent():void
		{
			super.addEvent();
			_mainUI["btnClose"].addEventListener(MouseEvent.CLICK, onClose);
			_mainUI["btnOK"].addEventListener(MouseEvent.CLICK, onPlayTitleHandler);
			
			
			_mainUI["drawBoard"].addEventListener(MouseEvent.MOUSE_DOWN,drawMouseDownHandle);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_mainUI["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			_mainUI["btnOK"].removeEventListener(MouseEvent.CLICK, onPlayTitleHandler);
			
			
			_mainUI["drawBoard"].removeEventListener(MouseEvent.MOUSE_DOWN,drawMouseDownHandle);
			_mainUI["drawBoard"].removeEventListener(MouseEvent.MOUSE_MOVE,drawMouseMoveHandle);
			_mainUI["drawBoard"].removeEventListener(MouseEvent.MOUSE_UP,drawMouseUpHandle);
			_mainUI["drawBoard"].removeEventListener(MouseEvent.MOUSE_OUT,drawMouseOutHandle);
		}
		
		override public function destroy():void
		{
			
			clearPool();
			
			
			super.destroy();
			
			
			
			
			trace("----- 移除场景 -----");
		}
	}
}