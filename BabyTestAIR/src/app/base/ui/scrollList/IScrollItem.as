package app.base.ui.scrollList
{
	import flash.display.Bitmap;

	public interface IScrollItem
	{
		function get index() : uint;
		function set index(value : uint) : void;
		function get itemWidth() : Number;
		function set itemWidth(value : Number) : void;
		function get itemHeight() : Number;
		function set itemHeight(value : Number) : void;
		function set icon(value : Bitmap) : void;
		
		
		
		
	}
}