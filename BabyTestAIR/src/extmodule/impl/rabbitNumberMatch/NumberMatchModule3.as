package extmodule.impl.rabbitNumberMatch
{
	import com.booyue.l1flashandroidlib.EntryPoint;
	import com.booyue.l1flashandroidlib.KeyValueEvent;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.events.MouseEvent;
	
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	
	import extmodule.api.BaseExtModule;

	/**
	 * 数字的组合，第四关
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2019-2-19 下午4:50:16
	 **/
	public class NumberMatchModule3 extends BaseExtModule
	{
		[Inject]
		public var view : NumberMatchView3;
		
		private var _soundRoot : String = "resource/sound/rabbitNumberMatch/";
		private var _bgm : String = "resource/sound/common/BGM_3.mp3";
		private var _url : String = "resource/extmodule/numberMatchModule3UI.swf";
		
		
		
		public var questionNum:uint=6;
		public var levelNum:uint=4;
		public var rightCnt:Number;
		public var wrongCnt:Number;
		public var answerListener:EntryPoint = EntryPoint.getInstance();
		
		public function NumberMatchModule3()
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
			
			//			trace("[sound]: 火火兔的玩具");
			soundManager.playSound(_soundRoot + "titleSound.mp3");
			
			// 跳过引导动画
			TweenLite.delayedCall(3.5, tipsSoundCallback);
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
			for(var i : uint = 0; i < questionNum; i++) {
				_mainUI["xuanzeMc"+i].rightMc.visible=false;
				_mainUI["xuanzeMc"+i].isRightMc.gotoAndStop(1);
				_mainUI["donghuaMc"+i].visible = false;
				_mainUI["donghuaMc"+i].x = 280 + 156 * i;
				_mainUI["donghuaMc"+i].y = 552;
				//				_mainUI["donghuaMc"+i].scaleX = .35;
				//				_mainUI["donghuaMc"+i].scaleY = .35;
				_mainUI["daanMc"+i].gotoAndStop(1);
			}
			
			rightCnt=0;
			wrongCnt=0;
			setSelectBlock();
		}
		
		private function setSelectBlock() : void
		{
			var colorArray:Array=[[328,326,324,327,320,319,321,325,323,322],[318,316,314,317,310,309,311,315,313,312],[278,276,274,277,270,269,271,275,273,272],[308,306,304,307,300,299,301,305,303,302],[298,296,294,297,290,289,291,295,293,292],[288,286,284,287,280,279,281,285,283,282]];
			var colorFrameArray:Array=[1,2,3,4,5,6,7,8,9,10];
			var randomArray:Array=[1,2,3,4,5,6];
			for(var i:uint=0;i<questionNum;i++){
				var randomNum:Number=Math.floor(Math.random()*randomArray.length);
				var colorRandomNum:Number=Math.floor(Math.random()*colorFrameArray.length);
				_mainUI["xuanzeMc"+i].gotoAndStop(randomArray[randomNum]);
				_mainUI["donghuaMc"+i].gotoAndStop(randomArray[randomNum]);
				_mainUI["xuanzeMc"+i].currentFrameNum=randomArray[randomNum]-1;
				_mainUI["colorMc"+_mainUI["xuanzeMc"+i].currentFrameNum].gotoAndStop(colorFrameArray[colorRandomNum]);
				_mainUI["xuanzeMc"+i].rightNum=colorArray[i][colorFrameArray[colorRandomNum]-1];
				_mainUI["xuanzeMc"+i].isRight=false;
				colorArray[i].splice(colorFrameArray[colorRandomNum]-1,1);
				_mainUI["xuanzeMc"+i].wrongArray=colorArray[i];
				_mainUI["xuanzeMc"+i].wrongSound="level"+levelNum+"WrongSound"+(randomArray[randomNum]-1)+".mp3";
				_mainUI["xuanzeMc"+i].rightSound="level"+levelNum+"RightSound"+(randomArray[randomNum]-1)+".mp3";
				randomArray.splice(randomNum,1);
				colorFrameArray.splice(colorRandomNum,1);
			}
		}
		
		private function setStringToKeyValue(str : String) : Array
		{
			return str.split(",");
		}
		
		// 事件
		private function onClose(e : MouseEvent) : void
		{
			view.removeFromStage();
		}
		
		private function keyDownHandle(e:KeyValueEvent/*e:KeyboardEvent*/) : void
		{
			if(uint(setStringToKeyValue(e.value)[1])!=1){
				for(var i:uint=0;i<questionNum;i++){
					if(!_mainUI["xuanzeMc"+i].isRight){
						if(_mainUI["xuanzeMc"+i].rightNum==/*e.keyCode*/Number(setStringToKeyValue(e.value)[0])){
							
							soundManager.stopSoundExpect(_bgm);
							soundManager.playSound("resource/sound/common/rightSound.mp3");
							
							_mainUI["xuanzeMc"+i].isRight=true;
							rightCnt++;
							break;
						}
						if(_mainUI["xuanzeMc"+i].wrongArray.indexOf(/*e.keyCode*/Number(setStringToKeyValue(e.value)[0]))>=0){
							
							soundManager.stopSoundExpect(_bgm);
							soundManager.playSound("resource/sound/common/rightSound.mp3");
							
							_mainUI["xuanzeMc"+i].isRight=true;
							wrongCnt++;
							break;
						}
					}
				}
				
				if((rightCnt + wrongCnt)==questionNum){
					saveScore(rightCnt, questionNum);
					dispatch(new PPYEvent(CommandID.EXTMODULE_OVER));
				}
			}
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
			
			answerListener.addEventListener(KeyValueEvent.RESULT,keyDownHandle);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_mainUI["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			_mainUI["btnOK"].removeEventListener(MouseEvent.CLICK, onPlayTitleHandler);
			
			answerListener.removeEventListener(KeyValueEvent.RESULT,keyDownHandle);
		}
		
		override public function destroy():void
		{
			
			
			
			super.destroy();
			
			
			trace("----- 移除场景 -----");
		}
	}
}