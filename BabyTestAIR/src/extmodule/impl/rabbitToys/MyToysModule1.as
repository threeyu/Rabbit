package extmodule.impl.rabbitToys
{
	import com.booyue.l1flashandroidlib.EntryPoint;
	import com.booyue.l1flashandroidlib.KeyValueEvent;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	
	import extmodule.api.BaseExtModule;

	/**
	 * 火火兔的玩具，第二关
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-11-12 上午9:59:39
	 **/
	public class MyToysModule1 extends BaseExtModule
	{
		[Inject]
		public var view : MyToysView1;
		
		private var _soundRoot : String = "resource/sound/rabbitToys/";
		private var _bgm : String = "resource/sound/common/BGM_0.mp3";
		private var _url : String = "resource/extmodule/myToysModule1UI.swf";
		
		
		public var answerTimes:Number;
		public var questionNum:uint=4;
		public var levelNum:uint=2;
		public var answeredNum:Number;
		public var answerListener:EntryPoint = EntryPoint.getInstance();
		
		public function MyToysModule1()
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
			TweenLite.delayedCall(2.5, titleSoundCallback);
		}
		
		private function titleSoundCallback() : void
		{
			_mainUI["mcTips"].gotoAndStop(2);
			
			
//			trace("[sound]: 哇哦，家里好多。。。");
			soundManager.playSound(_soundRoot + "yindao.mp3");
			TweenLite.delayedCall(8, tipsSoundCallback);
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
			
			answerTimes=0;
			answeredNum=0; 
			setSelectBlock();
		}
		
		private function setSelectBlock() : void
		{
			var colorArray:Array=[[318,316,314,317,310,309,311,315,313,312],[278,276,274,277,270,269,271,275,273,272],[308,306,304,307,300,299,301,305,303,302],[298,296,294,297,290,289,291,295,293,292]];
			var colorFrameArray:Array=[1,2,3,4,5,6,7,8,9,10];
			var randomArray:Array=[1,2,3,4];
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
		
		private function account() : void
		{
			var score:Number=answerTimes-questionNum;
			var goldScoreNum:Number;
			if(score<=(1 * questionNum)) {
				goldScoreNum = 50;
			} else if(score>(1 * questionNum)&&score<=(2 * questionNum)) {
				goldScoreNum=20;
			} else {
				goldScoreNum=10;
			}
			saveScore(goldScoreNum, 50);
		}
		
		// 事件
		private function onClose(e : MouseEvent) : void
		{
			view.removeFromStage();
		}
		
		private function keyDownHandle(e:KeyValueEvent/*e:KeyboardEvent*/) : void
		{
			if(uint(setStringToKeyValue(e.value)[1])!=1){
				
				answerTimes++;
				for(var i:uint=0;i<questionNum;i++){
					if(!_mainUI["xuanzeMc"+i].isRight){
						if(_mainUI["xuanzeMc"+i].rightNum==/*e.keyCode*/Number(setStringToKeyValue(e.value)[0])){
							var tempD:MovieClip=_mainUI["donghuaMc"+i];
							var tempX:MovieClip=_mainUI["daanMc"+_mainUI["xuanzeMc"+i].currentFrameNum];
							_mainUI["xuanzeMc"+i].isRight=true;
							_mainUI["xuanzeMc"+i].rightMc.visible=true;
							_mainUI["xuanzeMc"+i].isRightMc.gotoAndStop("right");
							_mainUI["donghuaMc"+i].visible=true;
							
							
//							trace("[sound]: 答对了！");
							soundManager.stopSoundExpect(_bgm);
							soundManager.playSound("resource/sound/common/rightSound.mp3");
							soundManager.playSound(_soundRoot + _mainUI["xuanzeMc"+i].rightSound);
							
							
							TweenLite.to(_mainUI["donghuaMc"+i],1.5,{x:_mainUI["daanMc"+_mainUI["xuanzeMc"+i].currentFrameNum].x,y:_mainUI["daanMc"+_mainUI["xuanzeMc"+i].currentFrameNum].y,scaleX:1.5,scaleY:1.5,onComplete:function():void{
								TweenLite.to(tempD,.8,{scaleX:1,scaleY:1,onComplete:function():void{
									tempD.visible=false;
									tempX.gotoAndStop(2);
									answeredNum++;
									
									if(answeredNum==questionNum){
										
										account();
										dispatch(new PPYEvent(CommandID.EXTMODULE_OVER));
									}
								}});
							}});
							break;
						}
						if(_mainUI["xuanzeMc"+i].wrongArray.indexOf(/*e.keyCode*/Number(setStringToKeyValue(e.value)[0]))>=0){
							_mainUI["xuanzeMc"+i].isRightMc.gotoAndStop("wrong");
							
							
//							trace("[sound]: 答错了。。。sound/wrongSound.mp3");
//							trace("[sound]: " + _mainUI["xuanzeMc"+i].wrongSound);
							soundManager.stopSoundExpect(_bgm);
							soundManager.playSound("resource/sound/common/wrongSound.mp3");
							soundManager.playSound(_soundRoot + _mainUI["xuanzeMc"+i].wrongSound);
							break;
						}
					}
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