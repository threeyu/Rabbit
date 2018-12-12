package i6s.babyDrawAndGuess.org.ppy.framework.model
{
	public interface IPlayInfoModel
	{
		function getLevel() : uint;
		
		function setLevel(val : uint) : void;
		
		function getFirst() : Boolean;
		
		function setFirst(bl : Boolean) : void;
	}
}