package t6.rabbitMath.org.ppy.framework.mediator.sub
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import t6.rabbitMath.org.ppy.framework.util.ResData;
	import t6.rabbitMath.org.ppy.framework.util.SoundManager;
	
	/**
	 * 拖拽模块
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-12-7 下午3:41:01
	 **/
	public class DragModule extends BaseCommonExtModule
	{
		private var _itemPosList : Array;
		private var _uiList : Array;
		
		private var _mcNum : uint;			// 选择mc的数量
		private var _tarNum : uint;		// 目标mc的数量
		private var _tipsNum : uint;		// 提示mc的数量
		
		private var _soundManager : SoundManager;
		
		public function DragModule(dis : DisplayObjectContainer)
		{
			super(dis);
		}
		
		
		override public function initData(cid:uint, pid:uint, type:uint):void
		{
			super.initData(cid, pid, type);
			
			_soundManager = SoundManager.getInstance();
			
			_mcNum = _tarNum = _tipsNum = 0;
			_itemPosList ||= [];
			
			for(var i : uint = 0; i < _itemNum; ++i)
			{
				if(_mainUI.hasOwnProperty("mc_" + i))
				{
					_itemPosList[i] ||= new Point(_mainUI["mc_" + i].x, _mainUI["mc_" + i].y);
					_mainUI["mc_" + i].visible = true;
					_mcNum++;
				}
				if(_mainUI.hasOwnProperty("mcTar_" + i))
				{
					_mainUI["mcTar_" + i].gotoAndStop(1);
					_tarNum++;
				}
				if(_mainUI.hasOwnProperty("mcTips_" + i))
					_tipsNum++;
			}
		}
		
		/**
		 * 获取按钮ui 
		 * @param arr
		 */		
		public function setupUI(arr : Array) : void
		{
			_uiList = arr;
		}
		
		private function enableUI(val : Boolean) : void
		{
			for(var i : uint = 0; i < _uiList.length; ++i)
			{
				_uiList[i].mouseEnabled = val;
			}
		}
		
		private function clearPool() : void
		{
			var len : uint = _itemPosList.length;
			if(len > 0)
			{
				for(var i : uint = 0; i < len; ++i)
					_itemPosList[i] = null;
				_itemPosList.splice(0, len);
			}
		}
		
		// 碰撞检测（原点在顶部中间）
		private function hitTest(mc1 : MovieClip, mc2 : MovieClip) : Boolean
		{
			var r1 : Number = mc1.width < mc1.height? mc1.width : mc1.height;
			var r2 : Number = mc2.width < mc2.height? mc2.width : mc2.height;
			var x1 : Number = mc1.x;
			var y1 : Number = mc1.y + mc1.height * 0.5;
			var x2 : Number = mc2.x;
			var y2 : Number = mc2.y + mc2.height * 0.5;
			
			var dist : Number = Math.sqrt(Math.abs(x1 - x2) * Math.abs(x1 - x2) + Math.abs(y1 - y2) * Math.abs(y1 - y2));
			if(dist <= ((r1 + r2) * 0.5))
				return true;
			return false;
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
		private function onDownHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			_mainUI["mc_" + id].startDrag();
			_mainUI["mc_" + id].gotoAndStop(2);
			_mainUI.setChildIndex(_mainUI["mc_" + id], _mainUI.numChildren - 1);
			
			enableUI(false);
		}
		
		private function onUpHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			_mainUI["mc_" + id].stopDrag();
			_mainUI["mc_" + id].gotoAndStop(1);
			
			
			for(var i : uint = 0; i < _tarNum; ++i)
			{
				if(hitTest(_mainUI["mcTar_" + i], _mainUI["mc_" + id]))
				{
					if(i == id)// right
					{
						_mainUI["mcTar_" + i].gotoAndStop(2);
						_mainUI["mc_" + id].visible = false;
						
						var str : String = _type == 0? ResData.ITEM_TITLE_SOUND[_cid][_pid][id] : ResData.ITEM_TRAIN_SOUND[_cid][_pid][id];
//						trace(str);
						soundPlay(str);
					}
					else
					{
						trace("--play dragWrongSound");
					}
				}
			}
			// back pos
			_mainUI["mc_" + id].x = _itemPosList[id].x;
			_mainUI["mc_" + id].y = _itemPosList[id].y;
			
			enableUI(true);
		}
		
		private function onTipsHandler(e : MouseEvent) : void
		{
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
//			trace("--play: soundTips_" + _cid + "_" + _pid + "_" + id + ".mp3");
			var str : String = _type == 0? ResData.TIPS_TITLE_SOUND[_cid][_pid][id] : ResData.TIPS_TRAIN_SOUND[_cid][_pid][id];
//			trace(str);
			soundPlay(str);
		}
		
		override protected function addEvent():void
		{
			super.addEvent();
			
			for(var i : uint = 0; i < _mcNum; ++i)
			{
				_mainUI["mc_" + i].addEventListener(MouseEvent.MOUSE_DOWN, onDownHandler);
				_mainUI["mc_" + i].addEventListener(MouseEvent.MOUSE_UP, onUpHandler);
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
				_mainUI["mc_" + i].removeEventListener(MouseEvent.MOUSE_DOWN, onDownHandler);
				_mainUI["mc_" + i].removeEventListener(MouseEvent.MOUSE_UP, onUpHandler);
			}
			for(i = 0; i < _tipsNum; ++i)
			{
				_mainUI["mcTips_" + i].removeEventListener(MouseEvent.CLICK, onTipsHandler);
			}
		}
		
		override public function destory():void
		{
			clearPool();
			
			_soundManager.stopSound();
			
			super.destory();
			
			
			_itemPosList = null;
		}
	}
}