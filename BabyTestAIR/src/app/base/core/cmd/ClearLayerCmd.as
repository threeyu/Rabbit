package app.base.core.cmd
{
	import flash.display.DisplayObject;
	
	import app.base.core.event.PPYEvent;
	import app.base.manager.LayerManager;
	import app.conf.constant.CommandID;
	import app.model.vo.BGLayerModel;
	import app.model.vo.LoadLayerModel;
	import app.model.vo.SceneLayerModel;
	import app.view.api.IView;
	
	import robotlegs.bender.bundles.mvcs.Command;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-9-28 下午5:31:13
	 **/
	public class ClearLayerCmd extends Command
	{
		[Inject]
		public var evt : PPYEvent;
		
		[Inject]
		public var bgModel : BGLayerModel;
		
		[Inject]
		public var viewModel : SceneLayerModel;
		
		[Inject]
		public var loadModel : LoadLayerModel;
		
		[Inject]
		private var _layerManager : LayerManager = LayerManager.getInstance();
		
		public function ClearLayerCmd()
		{
		}
		
		override public function execute():void 
		{
			switch(evt.type) {
				case CommandID.CLEAR_BG:           // 清除背景层
					clearBG();
					break;
				case CommandID.CLEAR_SCENE:        // 清除场景层
					clearScene();
					break;
				case CommandID.CLEAR_PANEL:        // 清除弹框
					trace("change_panel");
					break;
				case CommandID.CLEAR_EFFECT:		// 清除效果层
					clearEffect();
					break;
				case CommandID.CLEAR_LOAD:         // 清除加载层
					clearLoad();
					break;
				case CommandID.CLEAR_GAME:    		// 清除外部模块层
					clearGame();
					break;
				default :
					break;
			}
		}
		
		private function clearBG() : void
		{
			if(_layerManager.bgLayer.numChildren > 0) {
				var curView : IView = _layerManager.bgLayer.getChildAt(0) as IView;
				if(curView) {
					_layerManager.bgLayer.removeChild(curView as DisplayObject);
				}
			}
		}
		
		private function clearScene() : void
		{
			if(_layerManager.sceneLayer.numChildren > 0) {
				var curView : IView = _layerManager.sceneLayer.getChildAt(0) as IView;
				if(curView) {
					_layerManager.sceneLayer.removeChild(curView as DisplayObject);
				}
			}
		}
		
		private function clearEffect() : void
		{
			if(_layerManager.effectLayer.numChildren > 0) {
				var curView : IView = _layerManager.effectLayer.getChildAt(0) as IView;
				if(curView) {
					_layerManager.effectLayer.removeChild(curView as DisplayObject);
				}
			}
		}
		
		private function clearLoad() : void
		{
			if(_layerManager.loadLayer.numChildren > 0) {
				var curView : IView = _layerManager.loadLayer.getChildAt(0) as IView;
				if(curView) {
					_layerManager.loadLayer.removeChild(curView as DisplayObject);
				}
			}
		}
		
		private function clearGame() : void
		{
			if(_layerManager.gameLayer.numChildren > 0) {
				var curView : IView = _layerManager.gameLayer.getChildAt(0) as IView;
				if(curView) {
					_layerManager.gameLayer.removeChild(curView as DisplayObject);
				}
			}
		}
	}
}