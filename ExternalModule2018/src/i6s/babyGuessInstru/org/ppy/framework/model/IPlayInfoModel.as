package i6s.babyGuessInstru.org.ppy.framework.model
{
	public interface IPlayInfoModel
	{
		function getScore() : uint;
		
		function setScore(val : uint) : void;
		
		function getSuccess() : Boolean;
		
		function setSuccess(val : Boolean) : void;
	}
}