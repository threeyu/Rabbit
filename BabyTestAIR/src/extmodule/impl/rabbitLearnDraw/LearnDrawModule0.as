package extmodule.impl.rabbitLearnDraw
{
	import com.booyue.l1flashandroidlib.EntryPoint;
	import com.booyue.l1flashandroidlib.KeyValueEvent;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.utils.Timer;
	
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	
	import extmodule.api.BaseExtModule;

	/**
	 * 学画画，第一关
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-11-8 上午11:41:01
	 **/
	public class LearnDrawModule0 extends BaseExtModule
	{
		[Inject]
		public var view : LearnDrawView0;
		
		private var _soundRoot : String = "resource/sound/rabbitLearnDraw/";
		private var _bgm : String = "resource/sound/common/BGM_1.mp3";
		private var _url : String = "resource/extmodule/learnDrawModule0UI.swf";
		
		
		
		public var buttonVoleArray:Array=[
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
		public var colorArray:Array=[0x0f1813,0x9d9d9d,0xf9f9f9,0xf40008,0xf27000,0xf1d300,0x6AD900,0x00C7F1,0xD503E8,0xFFB7D0];
		public var colorSoundArray:Array=["black","gray","white","red","orange","yellow","green","blue","purple","pink"];
		
		
		
		public var colorChange:ColorTransform=new ColorTransform();
		public var firstColorBtn:MovieClip;
		public var secondColorBtn:MovieClip;
		public var levelHuabanShape:Shape;
		public var levelScene:Sprite;
		public var cossPointNum:Number;
		public var levelOneColorMcNum:Number=7;
		public var levelRightNum:Number;
		public var levelNeedRightNum:Number;
		public var rightPointArray:Array;
		public var levelNum:Number=1;
		public var needCossPointNumAry:Array=[30,20,25,47];
		public var firstColor:Number=0x0f1813;
		public var secondColor:Number=-1;
		public var nowPickMode:String;
		
		public var answerListener:EntryPoint = EntryPoint.getInstance();
		
		
		private var _canvasArr : Array;
		
		
		public function LearnDrawModule0()
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
			
			
//			trace("[sound]: 学画画");
			soundManager.playSound(_soundRoot + "titleSound.mp3");
			TweenLite.delayedCall(2.5, titleSoundCallback);
		}
		
		private function titleSoundCallback() : void
		{
			_mainUI["mcTips"].gotoAndStop(2);
			
			
//			trace("[sound]: 妈妈给我。。。");
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
			_mainUI["mcFire"].gotoAndStop(1);
			_mainUI["mcFire"].visible = false;
			
			
			for(var i:uint=0;i<10;i++){
				_mainUI["colorBoardMc"]["colorBtn"+i].gotoAndStop(1);
				_mainUI["colorBoardMc"]["colorBtn"+i].colorNum=colorArray[i];
				_mainUI["colorBoardMc"]["colorBtn"+i].colorSound="resource/sound/common/" + colorSoundArray[i] + ".mp3";
			}
			
			colorChange.color=0x0f1813;
			firstColorBtn=_mainUI["colorBoardMc"]["colorBtn0"];
			firstColorBtn.gotoAndStop(2);
			initFun(levelOneColorMcNum);
			
			
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
		
		private function initFun(colormc:Number):void
		{
			view.addEventListener(Event.ENTER_FRAME,endGame);
			_mainUI["colorBoardMc"].visible=false;
			answerListener.removeEventListener(KeyValueEvent.RESULT,buttonPickColor);
			levelRightNum=0;
			levelNeedRightNum=colormc;
			levelScene=_mainUI;
			
			
			levelScene["bianMc"].mouseEnabled=false;
			levelScene["bianMc"].visible = false;
			for(var j:uint=0;j<colormc;j++){
				levelScene["colorMc"+j].visible=false;
				levelScene["colorMc"+j].mouseEnabled=false;
				levelScene["colorMc"+j].transform.colorTransform = new ColorTransform();
				levelScene["colorMc"+j].addEventListener(MouseEvent.CLICK,addColorHandle);
				levelScene["colorMc"+j].haveColor=false;
			}
			
			
			rightPointArray=[];
			for(var i:uint=0;i<needCossPointNumAry[levelNum-1];i++){
				levelScene["drawBoard"]["cossPoint"+i].mouseEnabled=false;
				rightPointArray.push([levelScene["drawBoard"]["cossPoint"+i].x,levelScene["drawBoard"]["cossPoint"+i].y,false,levelScene["drawBoard"]["cossPoint"+i]]);
			}
			
			levelScene["drawBoard"].addEventListener(MouseEvent.MOUSE_DOWN,drawMouseDownHandle);
		}
		
		private function playFire():void
		{
			_mainUI["mcFire"].visible = true;
			_mainUI["mcFire"].gotoAndPlay(1);
			
			
//			trace("[sound]: 烟花音效。。。");
			soundManager.stopSoundExpect(_bgm);
			soundManager.playSound(_soundRoot + "fireSound.mp3");
			TweenLite.delayedCall(3, function():void{
				_mainUI["mcFire"].gotoAndStop(1);
				_mainUI["mcFire"].visible = false;
				
				
				
				saveScore(20, 20);
				dispatch(new PPYEvent(CommandID.EXTMODULE_OVER));
			});
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
		
		private function endGame(e:Event):void
		{
			if(levelRightNum==levelNeedRightNum){
				view.removeEventListener(Event.ENTER_FRAME,endGame);
				
				playFire();
			}
		}
		
		private var chackIsAllCossTimer:Timer=new Timer(5000,1);
		private function drawMouseDownHandle(e:MouseEvent):void
		{
			chackIsAllCossTimer.stop();
			chackIsAllCossTimer.removeEventListener(TimerEvent.TIMER,chackTimerHandle);
			levelHuabanShape=new Shape();
			levelScene["drawBoard"].addChild(levelHuabanShape);
			poolIn(levelHuabanShape);
			
			levelHuabanShape.graphics.clear();
			levelHuabanShape.graphics.lineStyle(5,0xcc0000);
			levelHuabanShape.graphics.moveTo(levelHuabanShape.mouseX,levelHuabanShape.mouseY);
			
			levelScene["drawBoard"].addEventListener(MouseEvent.MOUSE_MOVE,drawMouseMoveHandle);
			levelScene["drawBoard"].addEventListener(MouseEvent.MOUSE_UP,drawMouseUpHandle);
			levelScene["drawBoard"].addEventListener(MouseEvent.MOUSE_OUT,drawMouseUpHandle);
		}
		
		private function drawMouseMoveHandle(e:MouseEvent):void
		{
			levelHuabanShape.graphics.lineTo(levelHuabanShape.mouseX,levelHuabanShape.mouseY);
			var tempX:Number=e.localX;
			var tempY:Number=e.localY;
			
			for(var i:uint=0;i<rightPointArray.length;i++){
				if(Math.abs(tempX-rightPointArray[i][0])<=25&&Math.abs(tempY-rightPointArray[i][1])<=25){
					rightPointArray[i][2]=true;
				}
			}
		}
		
		private function drawMouseUpHandle(e:MouseEvent):void
		{
			levelScene["drawBoard"].removeEventListener(MouseEvent.MOUSE_MOVE,drawMouseMoveHandle);
			levelScene["drawBoard"].removeEventListener(MouseEvent.MOUSE_UP,drawMouseUpHandle);
			levelScene["drawBoard"].removeEventListener(MouseEvent.MOUSE_OUT,drawMouseUpHandle);
			cossPointNum=0;
			for(var i:uint=0;i<rightPointArray.length;i++){
				if(rightPointArray[i][2]==true){
					cossPointNum++;
				}
			}
			
			if(cossPointNum==needCossPointNumAry[levelNum-1]){
				_mainUI["colorBoardMc"].visible=true;
				answerListener.addEventListener(KeyValueEvent.RESULT,buttonPickColor);
				levelScene["drawBoard"].removeEventListener(MouseEvent.MOUSE_DOWN,drawMouseDownHandle);
				levelScene["bianMc"].visible = true;
				clearPool();
				for(var j:uint=0;j<levelNeedRightNum;j++){
					levelScene["colorMc"+j].visible=true;
					levelScene["colorMc"+j].mouseEnabled=true;
				}
				

//				trace("[sound]: sound/lvMiaowan + levelNum.mp3。。。");
				soundManager.stopSoundExpect(_bgm);
				soundManager.playSound(_soundRoot + "lvMiaowan" + levelNum + ".mp3");
			}else{
				if(cossPointNum/needCossPointNumAry[levelNum-1]>.8){
					chackIsAllCossTimer.reset();
					chackIsAllCossTimer.start();
					chackIsAllCossTimer.addEventListener(TimerEvent.TIMER,chackTimerHandle);
				}
			}
		}
		
		private function chackTimerHandle(e:TimerEvent):void
		{
			chackIsAllCossTimer.removeEventListener(TimerEvent.TIMER,chackTimerHandle);
			for(var i:uint=0;i<rightPointArray.length;i++){
				if(!rightPointArray[i][2]){
					var tempTimeline:TimelineLite=new TimelineLite();
					tempTimeline.append( new TweenLite(rightPointArray[i][3],.5,{alpha:.5,scaleX:1.2, scaleY:1.2}));
					tempTimeline.append( new TweenLite(rightPointArray[i][3],.5,{alpha:0,scaleX:1.2, scaleY:1.2}));
					tempTimeline.append( new TweenLite(rightPointArray[i][3],.5,{alpha:.5,scaleX:1.2, scaleY:1.2}));
					tempTimeline.append( new TweenLite(rightPointArray[i][3],.5,{alpha:0,scaleX:1.2, scaleY:1.2}));
					tempTimeline.append( new TweenLite(rightPointArray[i][3],.5,{alpha:.5,scaleX:1.2, scaleY:1.2}));
					tempTimeline.append( new TweenLite(rightPointArray[i][3],.5,{alpha:0,scaleX:1.2, scaleY:1.2}));
				}
			}
		}
		
		//填色
		private function addColorHandle(e:MouseEvent):void
		{
			var temp:MovieClip=e.currentTarget as MovieClip;
			temp.transform.colorTransform=colorChange;
			
			
//			trace("[sound]: sound/rightSoundyx.mp3。。。");
			soundManager.stopSoundExpect(_bgm);
			soundManager.playSound("resource/sound/common/rightSound.mp3");
			
			
			if(!temp.haveColor){
				temp.haveColor=true;
				levelRightNum++;
			}
			nowPickMode="huakuai";
		}
		
		//拾取颜色
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
				
				
//				trace("[sound]: temp.colorSound.mp3。。。");
				soundManager.stopSoundExpect(_bgm);
				soundManager.playSound(temp.colorSound);
			}else{
				if(secondColor==-1){
					secondColorBtn=temp;
					secondColor=temp.colorNum;
					if(firstColor!=secondColor){
						secondColorBtn.gotoAndStop(2);
						mixUpColor();
						
						
//						trace("[sound]: temp.colorSound.mp3。。。");
						soundManager.stopSoundExpect(_bgm);
						soundManager.playSound(temp.colorSound);
						TweenLite.delayedCall(1, function():void{
//							trace("[sound]: firstColorBtn.colorSound.mp3。。。");
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
					
					
//					trace("[sound]: temp.colorSound.mp3。。。");
					soundManager.stopSoundExpect(_bgm);
					soundManager.playSound(temp.colorSound);
				}
			}
			_mainUI["colorBoardMc"]["nowColorMc"].transform.colorTransform=colorChange;
			nowPickMode="dianji";
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
		
		private function buttonPickColor(e:KeyValueEvent):void
		{
			if(Number(setStringToKeyValue(e.value)[1])!=1){
				for(var i:uint=0;i<10;i++){
					if(buttonVoleArray[i].indexOf(Number(setStringToKeyValue(e.value)[0]))>=0){
						if(firstColor==-1){
							firstColorBtn=_mainUI["colorBoardMc"]["colorBtn"+i];
							firstColorBtn.gotoAndStop(2);
							colorChange.color=colorArray[i];
							firstColor=colorArray[i];
						}else{
							firstColorBtn.gotoAndStop(1);
							firstColorBtn=_mainUI["colorBoardMc"]["colorBtn"+i];
							firstColorBtn.gotoAndStop(2);
							colorChange.color=colorArray[i];
							firstColor=colorArray[i];
							if(secondColorBtn){
								secondColorBtn.gotoAndStop(1);
								secondColor=-1;
							}
							
							
//							trace("[sound]: firstColorBtn.colorSound.mp3。。。");
							soundManager.stopSoundExpect(_bgm);
							soundManager.playSound(firstColorBtn.colorSound);
						}
						_mainUI["colorBoardMc"]["nowColorMc"].transform.colorTransform=colorChange;
					}
				}
				nowPickMode="huakuai";
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
			
			
			for(var i:uint=0;i<10;i++){
				_mainUI["colorBoardMc"]["colorBtn"+i].addEventListener(MouseEvent.CLICK,pickColorHandle);
			}
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_mainUI["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			_mainUI["btnOK"].removeEventListener(MouseEvent.CLICK, onPlayTitleHandler);
			
			
			for(var i:uint=0;i<10;i++){
				_mainUI["colorBoardMc"]["colorBtn"+i].removeEventListener(MouseEvent.CLICK,pickColorHandle);
				if(i < levelOneColorMcNum) {
					levelScene["colorMc"+i].removeEventListener(MouseEvent.CLICK,addColorHandle);
				}
			}
			answerListener.removeEventListener(KeyValueEvent.RESULT,buttonPickColor);
			levelScene["drawBoard"].removeEventListener(MouseEvent.MOUSE_DOWN,drawMouseDownHandle);
			levelScene["drawBoard"].removeEventListener(MouseEvent.MOUSE_MOVE,drawMouseMoveHandle);
			levelScene["drawBoard"].removeEventListener(MouseEvent.MOUSE_UP,drawMouseUpHandle);
			levelScene["drawBoard"].removeEventListener(MouseEvent.MOUSE_OUT,drawMouseUpHandle);
			
			chackIsAllCossTimer.removeEventListener(TimerEvent.TIMER,chackTimerHandle);
		}
		
		override public function destroy():void
		{
			chackIsAllCossTimer.stop();
			
			clearPool();
			
			super.destroy();
			
			
			chackIsAllCossTimer = null;
			
			
			trace("----- 移除场景 -----");
		}
	}
}