package
{
	import com.sqstudio.study.qqbl.archer.ArcherStudy;
	
	import flash.display.Sprite;
	
	[SWF(width="500",height="400")]
	public class BezierStudy extends Sprite
	{
		public function BezierStudy()
		{
			addChild(new ArcherStudy());
			new MenuVersion(this);
		}
	}
}