package l1.zzl.rabbitDrawLine.common
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.fscommand;
	import flash.utils.Timer;

	/**
	 * 素材新建时 需要有_mainUI["startCanvas"](必须) 和 _mainUI["btnClose"](不必须) 
	 * @author Administrator
	 * 
	 */	
	public class BaseCommonExtModule extends Sprite
	{
		protected var _mainUI : DisplayObjectContainer;
		private var _startTimer : Timer;
		private const COUNT_NUM : uint = 5;
		
		public function BaseCommonExtModule(displayObjCon : DisplayObjectContainer)
		{
			_mainUI = displayObjCon;
			this.addChild(_mainUI);
			
			_startTimer = new Timer(1000, COUNT_NUM);
			
			initData();
			addEvent();
		}
		
		protected function initData() : void
		{
			_mainUI["startCanvas"]["txtCnt"].visible = false;
			
			_mainUI["mcRound"].gotoAndStop(1);// 第一关 第二关
			_mainUI["mcRound"].visible = false;
		}
		
		/** 显示第一关 第二关 **/
		public function showRound(id : uint, callBack : Function = null) : void
		{
			_mainUI["mcRound"].visible = true;
			_mainUI["mcRound"].gotoAndStop(id);
			TweenLite.to(_mainUI["mcRound"], 1, {onComplete : function() : void{
				_mainUI["mcRound"].visible = false;
				callBack();
			}});
		}
		
		/** 开始按钮倒计时 **/
		public function run() : void
		{
			_mainUI["startCanvas"]["txtCnt"].visible = true;
			_startTimer.start();
		}
		
		public function onClose(e : MouseEvent = null) : void
		{
			destroy();
			fscommand("quit");
//			NativeApplication.nativeApplication.exit();
		}
		
		public function onTitleSpeak(e : MouseEvent = null) : void
		{
			
		}
		
		public function onGameStart(e : MouseEvent = null) : void
		{
			_mainUI["startCanvas"].visible = false;
			_startTimer.stop();
		}
		
		private function onTimeTick(e : TimerEvent) : void
		{
			_mainUI["startCanvas"]["txtCnt"].text = "(" + (COUNT_NUM - _startTimer.currentCount) + ")";
		}
		
		private function onTimeOver(e : TimerEvent) : void
		{
			onGameStart();
		}
		
		protected function addEvent() : void
		{
			if(_mainUI.hasOwnProperty("btnClose") || _mainUI.hasOwnProperty("closeBtn"))
			{
				_mainUI["btnClose"].addEventListener(MouseEvent.CLICK, onClose);
			}
			_mainUI["btnSpeak"].addEventListener(MouseEvent.CLICK, onTitleSpeak);
			_mainUI["startCanvas"]["btnStart"].addEventListener(MouseEvent.CLICK, onGameStart);
			_startTimer.addEventListener(TimerEvent.TIMER, onTimeTick);
			_startTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeOver);
		}
		
		protected function removeEvent() : void
		{
			if(_mainUI.hasOwnProperty("btnClose") || _mainUI.hasOwnProperty("closeBtn"))
			{
				_mainUI["btnClose"].removeEventListener(MouseEvent.CLICK, onClose);
			}
			_mainUI["btnSpeak"].removeEventListener(MouseEvent.CLICK, onTitleSpeak);
			_mainUI["startCanvas"]["btnStart"].removeEventListener(MouseEvent.CLICK, onGameStart);
			_startTimer.removeEventListener(TimerEvent.TIMER, onTimeTick);
			_startTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeOver);
		}
		
		protected function destroy() : void
		{
			removeEvent();
			
			_startTimer = null;
			_mainUI = null;
		}
	}
}