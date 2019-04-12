/**
 * 查看版本
 */
package 
{
	import flash.events.ContextMenuEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class MenuVersion
	{
		private const menuInfo:Array=[
		];
		
		public function MenuVersion(obj:Object)
		{
			var rightMenu:ContextMenu = new ContextMenu();
			//删除原始菜单状态!
			rightMenu.hideBuiltInItems();
			var cmi:ContextMenuItem =  new ContextMenuItem("By 斯樵工坊: http://www.sqstudio.com");
//			cmi.enabled = false;
			rightMenu.customItems.push(cmi);
			cmi.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,selectHandler);
			for (var i:int=menuInfo.length-1;i>=0;i--){
				var c:ContextMenuItem =  new ContextMenuItem(String(menuInfo[i]));
				
				c.separatorBefore = (i==menuInfo.length-1);
				
				c.enabled = false;
				rightMenu.customItems.push(c);
			}
			obj.contextMenu = rightMenu;
		}
		
		private  function selectHandler(e:ContextMenuEvent):void
		{
			navigateToURL(new URLRequest("http://www.sqstudio.com"),"_blank");
		}
		
	}
}