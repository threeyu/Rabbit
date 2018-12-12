package extmodule.impl.rabbitLikeDraw
{
	import com.booyue.l1flashandroidlib.EntryPoint;
	import com.booyue.l1flashandroidlib.KeyValueEvent;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	
	import extmodule.api.BaseExtModule;

	/**
	 * 火火兔爱涂鸦，第四关
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-11-9 下午3:14:05
	 **/
	public class LikeDrawModule3 extends BaseExtModule
	{
		[Inject]
		public var view : LikeDrawView3;
		
		private var _soundRoot : String = "resource/sound/rabbitLikeDraw/";
		private var _bgm : String = "resource/sound/common/BGM_1.mp3";
		private var _url : String = "resource/extmodule/likeDrawModule3UI.swf";
		
		
		
		//buttonVoleArray是每个颜色对应每个槽位的键值
		private var buttonVoleArray:Array=[
			[323,313,273,303,293,283],
			[321,311,271,301,291,281],
			[322,312,272,302,292,282],
			[328,318,278,308,298,288],
			[325,315,275,305,295,285],
			[326,316,276,306,296,286],
			[327,317,277,307,297,287],
			[324,314,274,304,294,284],
			[319,309,269,299,289,279],
			[320,310,270,300,290,280]
		];
		
		//colorArray是10种颜色的16进制的数值
		private var colorArray:Array=[0x0f1813,0x9d9d9d,0xf9f9f9,0xf40008,0xf27000,0xf1d300,0x6AD900,0x00C7F1,0xD503E8,0xFFB7D0];
		//colorSoundArray是颜色的音效名
		private var colorSoundArray:Array=["black","gray","white","red","orange","yellow","green","blue","purple","pink"];
		private var levelFourColorArray:Array=[colorArray,colorArray,colorArray,colorArray,[0x000000]];
		private var levelFourColorMcNum:Number=5;
		
		
		
		private var levelRightNum:Number;
		private var levelNeedRightNum:Number;
		
		private var firstColor:Number=0x0f1813;
		private var secondColor:Number=-1;
		private var levelNum:Number=4;
		
		private var answerTimes:Number=0;
		
		private var levelScene:Sprite;
		private var firstColorBtn:MovieClip;
		private var secondColorBtn:MovieClip;
		private var colorChange:ColorTransform=new ColorTransform();
		private var nowPickMode:String;
		
		
		public var answerListener:EntryPoint = EntryPoint.getInstance();
		
		public function LikeDrawModule3()
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
			
			
//			trace("[sound]: 火火兔爱涂鸦");
			soundManager.playSound(_soundRoot + "titleSound.mp3");
			TweenLite.delayedCall(3.5, titleSoundCallback);
		}
		
		private function titleSoundCallback() : void
		{
			_mainUI["mcTips"].gotoAndStop(2);
			
			
//			trace("[sound]: 今天是周末。。。");
			soundManager.playSound(_soundRoot + "yindao.mp3");
			TweenLite.delayedCall(10, tipsSoundCallback);
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
			for(var i:uint=0;i<10;i++){
				_mainUI["colorBtn"+i].gotoAndStop(1);
				_mainUI["colorBtn"+i].colorNum=colorArray[i];
				_mainUI["colorBtn"+i].colorSound="resource/sound/common/" + colorSoundArray[i] + ".mp3";
			}
			
			colorChange.color=0x0f1813;
			firstColorBtn=_mainUI["colorBtn0"];
			firstColorBtn.gotoAndStop(2);
			initFun(levelFourColorMcNum,levelFourColorArray);
		}
		
		private function initFun(colormc:Number,colorary:Array):void
		{
			levelRightNum=0;
			if(levelNum<4){
				levelNeedRightNum=colormc;
			}else{
				levelNeedRightNum=colormc-1;
			}
			levelScene=_mainUI;
			
			
			for(var j:uint=0;j<colormc;j++){
				levelScene["colorMc"+j].transform.colorTransform = new ColorTransform();
				levelScene["colorMc"+j].rightColorStr=colorary[j];
				levelScene["colorMc"+j].wrongSound="level"+levelNum+"Wrong4.mp3";
				levelScene["colorMc"+j].rightSound="level"+levelNum+"Right"+j+".mp3";
				levelScene["colorMc"+j].isRightColor=false;
			}
		}
		
		private function chackGame():void
		{
			account();
			dispatch(new PPYEvent(CommandID.EXTMODULE_OVER));
		}
		
		private function account() : void
		{
			var goldScoreNum:Number;
			if(answerTimes<=4){
				goldScoreNum = 50;
			}else if(answerTimes>4&&answerTimes<=8){
				goldScoreNum=20;
			} else {
				goldScoreNum=10;
			}
			saveScore(goldScoreNum, 50);
		}
		
		private function setStringToKeyValue(str : String) : Array
		{
			return str.split(",");
		}
		
		//颜色混合
		private function mixUpColor():void
		{
			if(firstColor==0xD503E8){
				if(secondColor==0xFFB7D0){
					colorChange.color=0xB97CE7;
				}else if(secondColor==0x9d9d9d){
					colorChange.color=0x625094;
				}else if(secondColor==0xf9f9f9){
					colorChange.color=0xb199f5;
				}else if(secondColor==0x0f1813){
					colorChange.color=0x221848;
				}else if(secondColor==0x00c7f1){
					colorChange.color=0x367dea;
				}else if(secondColor==0xf27000){
					colorChange.color=0xa95478;
				}else if(secondColor==0xf1d300){
					colorChange.color=0xa88378;
				}else if(secondColor==0x6ad900){
					colorChange.color=0x607b6e;
				}else if(secondColor==0xf40008){
					colorChange.color=0xab207d;
				}
			}else if(firstColor==0xFFB7D0){
				if(secondColor==0xD503E8){
					colorChange.color=0xB97CE7;
				}else if(secondColor==0x9d9d9d){
					colorChange.color=0xCEAAB6;
				}else if(secondColor==0xf9f9f9){
					colorChange.color=0xFCD8E4;
				}else if(secondColor==0x0f1813){
					colorChange.color=0x876872;
				}else if(secondColor==0x00c7f1){
					colorChange.color=0x80BFE0;
				}else if(secondColor==0xf27000){
					colorChange.color=0xF89468;
				}else if(secondColor==0xf1d300){
					colorChange.color=0xF8C568;
				}else if(secondColor==0x6ad900){
					colorChange.color=0xB4C868;
				}else if(secondColor==0xf40008){
					colorChange.color=0xFA5C6C;
				}
			}else if(firstColor==0x9d9d9d){
				if(secondColor==0xD503E8){
					colorChange.color=0x625094;
				}else if(secondColor==0xFFB7D0){
					colorChange.color=0xCEAAB6;
				}else if(secondColor==0xf9f9f9){
					colorChange.color=0xCBCBCB;
				}else if(secondColor==0x0f1813){
					colorChange.color=0x262827;
				}else if(secondColor==0x00c7f1){
					colorChange.color=0x377c8a;
				}else if(secondColor==0xf27000){
					colorChange.color=0x8b5e37;
				}else if(secondColor==0xf1d300){
					colorChange.color=0x8a8037;
				}else if(secondColor==0x6ad900){
					colorChange.color=0x567a33;
				}else if(secondColor==0xf40008){
					colorChange.color=0x8d373a;
				}
			}else if(firstColor==0xf9f9f9){
				if(secondColor==0xD503E8){
					colorChange.color=0xb199f5;
				}else if(secondColor==0xFFB7D0){
					colorChange.color=0xFCD8E4;
				}else if(secondColor==0x9d9d9d){
					colorChange.color=0xCBCBCB;
				}else if(secondColor==0x0f1813){
					colorChange.color=0x454746;
				}else if(secondColor==0x00c7f1){
					colorChange.color=0x73d0e3;
				}else if(secondColor==0xf27000){
					colorChange.color=0xe5a874;
				}else if(secondColor==0xf1d300){
					colorChange.color=0xe3d573;
				}else if(secondColor==0x6ad900){
					colorChange.color=0x97c76a;
				}else if(secondColor==0xf40008){
					colorChange.color=0xe77578;
				}
			}else if(firstColor==0x0f1813){
				if(secondColor==0xD503E8){
					colorChange.color=0x221848;
				}else if(secondColor==0xFFB7D0){
					colorChange.color=0x876872;
				}else if(secondColor==0x9d9d9d){
					colorChange.color=0x262827;
				}else if(secondColor==0xf9f9f9){
					colorChange.color=0x454746;
				}else if(secondColor==0x00c7f1){
					colorChange.color=0x043942;
				}else if(secondColor==0xf27000){
					colorChange.color=0x422305;
				}else if(secondColor==0xf1d300){
					colorChange.color=0x413c05;
				}else if(secondColor==0x6ad900){
					colorChange.color=0x1e3b05;
				}else if(secondColor==0xf40008){
					colorChange.color=0x430607;
				}
			}else if(firstColor==0x00c7f1){
				if(secondColor==0xD503E8){
					colorChange.color=0x367dea;
				}else if(secondColor==0xFFB7D0){
					colorChange.color=0x80BFE0;
				}else if(secondColor==0x9d9d9d){
					colorChange.color=0x377c8a;
				}else if(secondColor==0xf9f9f9){
					colorChange.color=0x73d0e3;
				}else if(secondColor==0x0f1813){
					colorChange.color=0x043942;
				}else if(secondColor==0xf27000){
					colorChange.color=0x6d8d6d;
				}else if(secondColor==0xf1d300){
					colorChange.color=0x6db96d;
				}else if(secondColor==0x6ad900){
					colorChange.color=0x2cad64;
				}else if(secondColor==0xf40008){
					colorChange.color=0x6f5b71;
				}
			}else if(firstColor==0xf27000){
				if(secondColor==0xD503E8){
					colorChange.color=0xa95478;
				}else if(secondColor==0xFFB7D0){
					colorChange.color=0xF89468;
				}else if(secondColor==0x9d9d9d){
					colorChange.color=0x8b5e37;
				}else if(secondColor==0xf9f9f9){
					colorChange.color=0xe5a874;
				}else if(secondColor==0x0f1813){
					colorChange.color=0x422305;
				}else if(secondColor==0x00c7f1){
					colorChange.color=0x6d8d6d;
				}else if(secondColor==0xf1d300){
					colorChange.color=0xda9200;
				}else if(secondColor==0x6ad900){
					colorChange.color=0x918900;
				}else if(secondColor==0xf40008){
					colorChange.color=0xde3304;
				}
			}else if(firstColor==0xf1d300){
				if(secondColor==0xD503E8){
					colorChange.color=0xa88378;
				}else if(secondColor==0xFFB7D0){
					colorChange.color=0xF8C568;
				}else if(secondColor==0x9d9d9d){
					colorChange.color=0x8a8037;
				}else if(secondColor==0xf9f9f9){
					colorChange.color=0xe3d573;
				}else if(secondColor==0x0f1813){
					colorChange.color=0x413c05;
				}else if(secondColor==0x00c7f1){
					colorChange.color=0x6db96d;
				}else if(secondColor==0xf27000){
					colorChange.color=0xda9200;
				}else if(secondColor==0x6ad900){
					colorChange.color=0x90b200;
				}else if(secondColor==0xf40008){
					colorChange.color=0xdd6004;
				}
			}else if(firstColor==0x6ad900){
				if(secondColor==0xD503E8){
					colorChange.color=0x607b6e;
				}else if(secondColor==0xFFB7D0){
					colorChange.color=0xB4C868;
				}else if(secondColor==0x9d9d9d){
					colorChange.color=0x567a33;
				}else if(secondColor==0xf9f9f9){
					colorChange.color=0x97c76a;
				}else if(secondColor==0x0f1813){
					colorChange.color=0x1e3b05;
				}else if(secondColor==0x00c7f1){
					colorChange.color=0x2cad64;
				}else if(secondColor==0xf27000){
					colorChange.color=0x918900;
				}else if(secondColor==0xf1d300){
					colorChange.color=0x90b200;
				}else if(secondColor==0xf40008){
					colorChange.color=0x935b03;
				}
			}else if(firstColor==0xf40008){
				if(secondColor==0xD503E8){
					colorChange.color=0xab207d;
				}else if(secondColor==0xFFB7D0){
					colorChange.color=0xFA5C6C;
				}else if(secondColor==0x9d9d9d){
					colorChange.color=0x8d373a;
				}else if(secondColor==0xf9f9f9){
					colorChange.color=0xe77578;
				}else if(secondColor==0x0f1813){
					colorChange.color=0x430607;
				}else if(secondColor==0x00c7f1){
					colorChange.color=0x6f5b71;
				}else if(secondColor==0xf27000){
					colorChange.color=0xde3304;
				}else if(secondColor==0xf1d300){
					colorChange.color=0xdd6004;
				}else if(secondColor==0x6ad900){
					colorChange.color=0x935b03;
				}
			}
		}
		
		// 事件
		private function onClose(e : MouseEvent) : void
		{
			view.removeFromStage();
		}
		
		//这是用滑块取色的函数
		private function buttonPickColor(e:KeyValueEvent):void
		{
			if(Number(setStringToKeyValue(e.value)[1])!=1){
				for(var i:uint=0;i<10;i++){
					if(buttonVoleArray[i].indexOf(Number(setStringToKeyValue(e.value)[0]))>=0){
						if(firstColor==-1){
							firstColorBtn=_mainUI["colorBtn"+i];
							firstColorBtn.gotoAndStop(2);
							colorChange.color=colorArray[i];
							firstColor=colorArray[i];
						}else{
							firstColorBtn.gotoAndStop(1);
							firstColorBtn=_mainUI["colorBtn"+i];
							firstColorBtn.gotoAndStop(2);
							colorChange.color=colorArray[i];
							firstColor=colorArray[i];
							if(secondColorBtn){
								secondColorBtn.gotoAndStop(1);
								secondColor=-1;
							}
							
							
//							trace("[sound]: sound/firstColorBtn.colorSound.mp3。。。");
							soundManager.stopSoundExpect(_bgm);
							soundManager.playSound(firstColorBtn.colorSound);
						}
						_mainUI["nowColorMc"].transform.colorTransform=colorChange;
					}
				}
				nowPickMode="huakuai";
			}
		}
		
		//手指点击取色函数
		private function pickColorHandle(e:MouseEvent):void
		{
			var temp:MovieClip=e.currentTarget as MovieClip;
			if(nowPickMode=="huakuai"){
				firstColorBtn.gotoAndStop(1);
				firstColor=-1;
				if(secondColorBtn){
					secondColorBtn.gotoAndStop(1);
					secondColor=-1;
				}
			}
			if(firstColor==-1){
				firstColorBtn=temp;
				firstColorBtn.gotoAndStop(2);
				colorChange.color=temp.colorNum;
				firstColor=temp.colorNum;
				
				
				
//				trace("[sound]: sound/temp.colorSound.mp3。。。");
				soundManager.stopSoundExpect(_bgm);
				soundManager.playSound(temp.colorSound);
			}else{
				if(secondColor==-1){
					secondColorBtn=temp;
					secondColor=temp.colorNum;
					if(firstColor!=secondColor){
						secondColorBtn.gotoAndStop(2);
						mixUpColor();
						
						
						
//						trace("[sound]: sound/temp.colorSound.mp3。。。");
						soundManager.stopSoundExpect(_bgm);
						soundManager.playSound(temp.colorSound);
						TweenLite.delayedCall(1, function():void{
//							trace("[sound]: sound/firstColorBtn.colorSound.mp3。。。");
							soundManager.playSound(firstColorBtn.colorSound);
							TweenLite.delayedCall(1, function():void{
//								trace("[sound]: sound/mixup.mp3。。。");
								soundManager.playSound("resource/sound/common/mixup.mp3");
							});
						});
						
					}else{
						secondColor=-1;
						secondColorBtn=null;
					}
				}else{
					firstColorBtn.gotoAndStop(1);
					secondColorBtn.gotoAndStop(1);
					firstColorBtn=temp;
					firstColorBtn.gotoAndStop(2);
					colorChange.color=temp.colorNum;
					firstColor=temp.colorNum;
					secondColor=-1;
					
					
//					trace("[sound]: sound/temp.colorSound.mp3。。。");
					soundManager.stopSoundExpect(_bgm);
					soundManager.playSound(temp.colorSound);
				}
			}
			_mainUI["nowColorMc"].transform.colorTransform=colorChange;
			nowPickMode="dianji";
		}
		
		//填色
		private function addColorHandle(e:MouseEvent):void
		{
			var temp:MovieClip=e.currentTarget as MovieClip;
			var nameId : String = temp.name.slice(-1);
			if(!temp.isRightColor){
				
				// 这里改需求最后一关错误的选项要上白色
				if(levelNum<4)
				{
					temp.transform.colorTransform=colorChange;
				}
				else
				{
					var tempColorTransform : ColorTransform = new ColorTransform();
					tempColorTransform.color = 0xffffff;
					temp.transform.colorTransform = (nameId == "4")? tempColorTransform : colorChange;
				}
				
				
				if(temp.rightColorStr.indexOf(colorChange.color)>=0){
					temp.removeEventListener(MouseEvent.CLICK,addColorHandle);
					temp.isRightColor=true;
					levelRightNum++;
					if(levelRightNum==levelNeedRightNum){
						
						
//						trace("[sound]: sound/rightSoundyx.mp3。。。");
//						TweenLite.delayedCall(3, function():void{
//							chackGame();
//						});
						soundManager.stopSoundExpect(_bgm);
						soundManager.playSound("resource/sound/common/rightSound.mp3");
						chackGame();
					}else{
						
//						trace("[sound]: sound/rightSoundyx.mp3。。。");
//						TweenLite.delayedCall(3, function():void{
//							trace("[sound]: temp.rightSound.mp3。。。");
//						});
						soundManager.stopSoundExpect(_bgm);
						soundManager.playSound("resource/sound/common/rightSound.mp3");
						soundManager.playSound(_soundRoot + temp.rightSound);
					}
				}else{
					
//					trace("[sound]: sound/wrongSoundyx.mp3。。。");
//					TweenLite.delayedCall(3, function():void{
//						trace("[sound]: temp.wrongSound.mp3。。。");
//					});
					soundManager.stopSoundExpect(_bgm);
					soundManager.playSound("resource/sound/common/wrongSound.mp3");
					soundManager.playSound(_soundRoot + temp.wrongSound);
					
					answerTimes++;
				}
			}
			nowPickMode="huakuai";
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
			
			
			for(var i:uint=0;i<10;i++){
				_mainUI["colorBtn"+i].addEventListener(MouseEvent.CLICK,pickColorHandle);
				if(i < levelFourColorMcNum) {
					_mainUI["colorMc"+i].addEventListener(MouseEvent.CLICK,addColorHandle);
				}
			}
			
			answerListener.addEventListener(KeyValueEvent.RESULT,buttonPickColor);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_mainUI["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			_mainUI["btnOK"].removeEventListener(MouseEvent.CLICK, onPlayTitleHandler);
			
			
			for(var i:uint=0;i<10;i++){
				_mainUI["colorBtn"+i].removeEventListener(MouseEvent.CLICK,pickColorHandle);
				if(i < levelFourColorMcNum) {
					_mainUI["colorMc"+i].removeEventListener(MouseEvent.CLICK,addColorHandle);
				}
			}
			
			answerListener.removeEventListener(KeyValueEvent.RESULT,buttonPickColor);
		}
		
		override public function destroy():void
		{
			
			
			
			
			super.destroy();
			
			
			
			
			trace("----- 移除场景 -----");
		}
	}
}