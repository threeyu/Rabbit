package app.base.core.cmd
{
	import flash.display.DisplayObject;
	
	import app.base.core.event.PPYEvent;
	import app.base.manager.LayerManager;
	import app.conf.constant.CommandID;
	import app.model.IGamePool;
	import app.model.vo.BGLayerModel;
	import app.model.vo.LoadLayerModel;
	import app.model.vo.PanelLayerModel;
	import app.model.vo.SceneLayerModel;
	import app.view.api.IView;
	
	import robotlegs.bender.bundles.mvcs.Command;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-10 下午3:56:11
	 **/
	public class ChangeLayerCmd extends Command
	{
		[Inject]
		public var evt : PPYEvent;
		
		[Inject]
		public var bgModel : BGLayerModel;
		
		[Inject]
		public var sceneModel : SceneLayerModel;
		
		[Inject]
		public var panelModel : PanelLayerModel;
		
		[Inject]
		public var loadModel : LoadLayerModel;
		
		[Inject]
		public var gamePool : IGamePool;
		
		private var _layerManager : LayerManager = LayerManager.getInstance();
		
		public function ChangeLayerCmd()
		{
		}
		
		override public function execute():void
		{
			switch(evt.type) {
				case CommandID.CHANGE_BG:        // 切换背景层
					changeBG();
					break;
				case CommandID.CHANGE_SCENE:     // 切换场景层
					changeScene();
					break;
				case CommandID.CHANGE_PANEL:     // 切换弹框
					changePanel();
					break;
				case CommandID.CHANGE_LOAD:      // 切换加载层
					changeLoad();
					break;
				case CommandID.EXTMODULE_START:  // 切换外部模块层
					extmoduleStart();
					break;
				default :
					break;
			}
		}
		// 切换背景层
		private function changeBG() : void
		{
			if(_layerManager.bgLayer.numChildren > 0) {
				var curView : IView = _layerManager.bgLayer.getChildAt(0) as IView;
				if(curView) {
					_layerManager.bgLayer.removeChild(curView as DisplayObject);
				}
			}
			
			var newView : DisplayObject = bgModel.getView(evt.info) as DisplayObject;
			_layerManager.bgLayer.addChild(newView);
		}
		// 切换场景层
		private function changeScene() : void
		{
			if(_layerManager.sceneLayer.numChildren > 0) {
				var curView : IView = _layerManager.sceneLayer.getChildAt(0) as IView;
				if(curView) {
					_layerManager.sceneLayer.removeChild(curView as DisplayObject);
				}
			}
			
			var newView : DisplayObject = sceneModel.getView(evt.info) as DisplayObject;
			_layerManager.sceneLayer.addChild(newView);
		}
		// 切换弹框
		private function changePanel() : void
		{
			if(_layerManager.panelLayer.numChildren > 0) {
				var curView : IView = _layerManager.panelLayer.getChildAt(0) as IView;
				if(curView) {
					_layerManager.panelLayer.removeChild(curView as DisplayObject);
				}
			}
			
			var newView : DisplayObject = panelModel.getView(evt.info) as DisplayObject;
			_layerManager.panelLayer.addChild(newView);
		}
		// 切换加载层
		private function changeLoad() : void
		{
			if(_layerManager.loadLayer.numChildren > 0) {
				var curView : IView = _layerManager.loadLayer.getChildAt(0) as IView;
				if(curView) {
					_layerManager.loadLayer.removeChild(curView as DisplayObject);
				}
			}
			
			var newView : DisplayObject = loadModel.getView(evt.info) as DisplayObject;
			_layerManager.loadLayer.addChild(newView);
		}
		// 切换外部模块层
		private function extmoduleStart() : void
		{
			if(_layerManager.gameLayer.numChildren > 0) {
				var curView : IView = _layerManager.gameLayer.getChildAt(0) as IView;
				if(curView) {
					_layerManager.gameLayer.removeChild(curView as DisplayObject);
				}
			}
			var newView : DisplayObject = gamePool.getView(evt.info) as DisplayObject;
			
			
			_layerManager.gameLayer.addChild(newView);
		}
	}
}