package t6.rabbitMath.org.ppy.framework.mediator.sub
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import t6.rabbitMath.org.ppy.framework.util.ResData;
	import t6.rabbitMath.org.ppy.framework.util.SoundManager;

	/**
	 * 点击模块
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-12-7 下午3:03:13
	 **/
	public class ClickModule extends BaseCommonExtModule
	{
		private var _mcNum : uint;
		private var _tipsNum : uint;
		
		private var _soundManager : SoundManager;
		
		public function ClickModule(dis : DisplayObjectContainer)
		{
			super(dis);
		}
		
		override public function initData(cid:uint, pid:uint, type:uint):void
		{
			super.initData(cid, pid, type);
			
			_soundManager = SoundManager.getInstance();
			
			_mcNum = _tipsNum = 0;
			for(var i : uint = 0; i < _itemNum; ++i)
			{
				if(_mainUI.hasOwnProperty("mc_" + i))
				{
					if(_mainUI["mc_" + i].totalFrames == 2)
					{
						_mainUI["mc_" + i].gotoAndStop(1);
					}
					_mcNum++;
				}
				if(_mainUI.hasOwnProperty("mcTips_" + i))
				{
					_tipsNum++;
				}
			}
		}
		
		// 播放声音
		private function soundPlay(str : String) : void
		{
			if(!_soundManager.isPlaying(str))
			{
				_soundManager.stopSound();
				_soundManager.playSound(str);
			}
		}
		
		// 事件
		private function onClickHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
//			trace("--play soundClick: " + _type + " " + _cid + "_" + _pid + "_" + id + ".mp3");
			var str : String = _type == 0? ResData.ITEM_TITLE_SOUND[_cid][_pid][id] : ResData.ITEM_TRAIN_SOUND[_cid][_pid][id];
//			trace(str);
			soundPlay(str);
			
			if(_mainUI["mc_" + id].totalFrames == 2)
			{
				_mainUI["mc_" + id].gotoAndStop(2);
			}
		}
		
		private function onTipsHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			var str : String = _type == 0? ResData.TIPS_TITLE_SOUND[_cid][_pid][id] : ResData.TIPS_TRAIN_SOUND[_cid][_pid][id];
//			trace(str);
			soundPlay(str);
		}
		
		override protected function addEvent():void
		{
			super.addEvent();
			
			for(var i : uint = 0; i < _mcNum; ++i)
			{
				_mainUI["mc_" + i].addEventListener(MouseEvent.CLICK, onClickHandler);
			}
			for(i = 0; i < _tipsNum; ++i)
			{
				_mainUI["mcTips_" + i].addEventListener(MouseEvent.CLICK, onTipsHandler);
			}
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			
			for(var i : uint = 0; i < _mcNum; ++i)
			{
				_mainUI["mc_" + i].removeEventListener(MouseEvent.CLICK, onClickHandler);
			}
			for(i = 0; i < _tipsNum; ++i)
			{
				_mainUI["mcTips_" + i].removeEventListener(MouseEvent.CLICK, onTipsHandler);
			}
		}
		
		override public function destory():void
		{
			_soundManager.stopSound();
			
			
			super.destory();
			
			
			
		}
	}
}