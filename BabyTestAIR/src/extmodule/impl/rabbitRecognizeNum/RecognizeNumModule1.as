package extmodule.impl.rabbitRecognizeNum
{
	import com.adobe.serialization.json.JSON;
	import com.booyue.l1flashandroidlib.EntryPoint;
	import com.booyue.l1flashandroidlib.KeyValueEvent;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	
	import extmodule.api.BaseExtModule;

	/**
	 * 火火兔看图识数，第二关
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-11-14 下午6:48:47
	 **/
	public class RecognizeNumModule1 extends BaseExtModule
	{
		[Inject]
		public var view : RecognizeNumView1;
		
		private var _soundRoot : String = "resource/sound/rabbitRecognizeNum/";
		private var _bgm : String = "resource/sound/common/BGM_2.mp3";
		private var _url : String = "resource/extmodule/recognizeNumModule1UI.swf";
		
		
		//答案的预设数组
		private var answerKeyArray:Array=[["六 个","六"],["五 只","五"],["两 只","二 只","两","二"],["四 条","四"],["一 只","一"],["两 只","二 只","两","二"],["水 杯","杯 子","玻 璃 杯"],["背 包","书 包"],["糖 果","糖"]];
		private var tipsArray:Array=["不 清 楚","不 知 道","我 不 知 道","我 不 清 楚"];
		
		private var levelNum:Number=2;
		private var wrongTimes:Number=0;
		private var answerMode:String="";
		private var answerTimes:Number=0;
		private var noanswerTimer:Timer;
		//需要更改的所有关卡数量
		private var allLevelNum:int=1;
		
		
		private var answerListener:EntryPoint=EntryPoint.getInstance();
		
		
		public function RecognizeNumModule1()
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
			
//			trace("[sound]: 火火兔看图识数");
			soundManager.playSound(_soundRoot + "titleSound.mp3");
			
			// 跳过引导动画
			TweenMax.delayedCall(4.5, tipsSoundCallback);
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
			_mainUI["msgTxt"].text="";
			wrongTimes=0;
			answerMode="";
			
			answerBtnOn();
		}
		
		private function answerBtnOn() : void
		{
			_mainUI["answerBtn"].gotoAndStop(1);
			_mainUI["answerBtn"].addEventListener(MouseEvent.CLICK,answerHandle);
		}
		
		private function answerBtnOff() : void
		{
			_mainUI["answerBtn"].gotoAndStop(2);
			_mainUI["answerBtn"].removeEventListener(MouseEvent.CLICK,answerHandle);
		}
		
		// 事件
		private function onClose(e : MouseEvent) : void
		{
			TweenMax.killAll(false, false, true);
			view.removeFromStage();
		}
		
		//点击了答题按钮
		private function answerHandle(e:MouseEvent):void
		{
			var file:File = File.applicationDirectory.resolvePath("/sys/class/switch/micdet/state");
			var bateArray:ByteArray=new ByteArray();
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			fileStream.readBytes(bateArray, 0, fileStream.bytesAvailable);
			// 49(1)正常使用，48(0)系统提示拔掉外接麦克风
			if(String(bateArray[0])=="48"){
//				soundManager.stopSoundExpect(_bgm);
//				soundManager.playSound(_soundRoot + "huatong.mp3");
			} else if(String(bateArray[0])=="49"){
				
				soundManager.stopSound();
				answerTimes++;
				answerBtnOff();
				
				noanswerTimer=new Timer(6000,1)
				noanswerTimer.addEventListener(TimerEvent.TIMER,noanswerTimerHandle);
				noanswerTimer.start();
				
				answerListener.addEventListener(KeyValueEvent.ASR_RESULT,chackAnswerHandle);
				answerListener.startRerod(3);
			}
			fileStream.close();
		}
		
		private function noanswerTimerHandle(e:TimerEvent):void
		{
			removeAnswerTimer();
			answerListener.removeEventListener(KeyValueEvent.ASR_RESULT,chackAnswerHandle);
			soundManager.stopSoundExpect(_bgm);
			soundManager.playSound(_soundRoot + "resaySound.mp3");
			TweenMax.delayedCall(5, function():void{
				answerBtnOn();
			});
		}
		
		//查看语音识别流程函数
		private function chackAnswerHandle(e:KeyValueEvent):void
		{
			if(e.value=="1"){
				//selectBlock.msgTxt.text="录音器停止";
				removeAnswerTimer();
				answerBtnOn();
				answerListener.removeEventListener(KeyValueEvent.ASR_RESULT,chackAnswerHandle);
			}else if(e.value=="2"){
				//selectBlock.msgTxt.text="请说话";
			}else if(e.value=="3"){
				//selectBlock.msgTxt.text="正在回答";
				removeAnswerTimer();
				noanswerTimer.reset();
				noanswerTimer.start();
			}else if(e.value=="4"){
				//selectBlock.msgTxt.text="答题结束";
				removeAnswerTimer();
			}else if(e.value=="6"){
				//selectBlock.msgTxt.text="无法识别";
				answerListener.removeEventListener(KeyValueEvent.ASR_RESULT,chackAnswerHandle);
				removeAnswerTimer();
				answerBtnOn();
			}else{
				//selectBlock.msgTxt.text="识别中";
				removeAnswerTimer();
				answerListener.removeEventListener(KeyValueEvent.ASR_RESULT,chackAnswerHandle);
				answerMode="huidale";
				var soundData:Object;
				soundData=com.adobe.serialization.json.JSON.decode(e.value);
				var answerStr:String;
				if(soundData.src=="cloud"){
					answerStr=soundData.result.input;
					chack();
				}else if(soundData.src=="native"){
					answerStr=soundData.result.rec;
					chack();
				}
				function chack():void{
					for(var i:uint=0;i<answerKeyArray[levelNum-1].length;i++){
						if(answerStr.indexOf(answerKeyArray[levelNum-1][i])>=0){
							answerMode="dadui";
							break;
						}
					}
					for(i=0;i<tipsArray.length;i++){
						if(answerStr.indexOf(tipsArray[i])>=0){
							answerMode="tips";
							break;
						}
					}
				}
				
				if(answerMode=="dadui"){
					//selectBlock.msgTxt.text="答对了";
					_mainUI["msgTxt"].text=answerKeyArray[levelNum-1][0];
					

					
					soundManager.stopSoundExpect(_bgm);
					soundManager.playSound(_soundRoot + "rightSoundyx.mp3");
					soundManager.playSound(_soundRoot + "rightSound.mp3");
					TweenMax.delayedCall(4, function():void{
						levelNum++;
						levelPass();
					});
				}else if(answerMode=="tips"){
					//selectBlock.msgTxt.text="再听题";
					
					
					soundManager.stopSoundExpect(_bgm);
					soundManager.playSound(_soundRoot + "zaidutiSound.mp3");
					TweenMax.delayedCall(5, function():void{
						soundManager.playSound(_soundRoot + "question" + levelNum + ".mp3");
						answerBtnOn();
					});
				}else if(answerMode=="huidale"){
					wrongTimes++;
					
					
					soundManager.stopSoundExpect(_bgm);
					soundManager.playSound(_soundRoot + "wrongSoundyx.mp3");
					if(wrongTimes<2){
						//回答错误两次以下
						soundManager.playSound(_soundRoot + "questionWrong" + levelNum + ".mp3");
						answerBtnOn();
					}else{
						//回答错了2次以上，直接提示答案，然后进入下一题
						_mainUI["msgTxt"].text=answerKeyArray[levelNum-1][0];
						
						soundManager.playSound(_soundRoot + "tipsSound" + levelNum + ".mp3");
						TweenMax.delayedCall(4, function():void{
							levelNum++;
							levelPass();
						});
					}
				}
			}
			
			function levelPass():void{
				var score:Number=answerTimes-allLevelNum;
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
		}
		
		private function removeAnswerTimer():void
		{
			if(noanswerTimer){
				noanswerTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,noanswerTimerHandle);
				noanswerTimer.stop();
				noanswerTimer=null;
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
			
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_mainUI["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			_mainUI["btnOK"].removeEventListener(MouseEvent.CLICK, onPlayTitleHandler);
			
			
			_mainUI["answerBtn"].removeEventListener(MouseEvent.CLICK,answerHandle);
			
			if(noanswerTimer){
				noanswerTimer.removeEventListener(TimerEvent.TIMER,noanswerTimerHandle);
			}
		}
		
		override public function destroy():void
		{
			if(noanswerTimer) {
				noanswerTimer.stop();
				noanswerTimer = null;
			}
			
			super.destroy();
			
			
			trace("----- 移除场景 -----");
		}
	}
}