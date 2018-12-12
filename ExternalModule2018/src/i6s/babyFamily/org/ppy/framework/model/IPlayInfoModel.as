package i6s.babyFamily.org.ppy.framework.model
{
	public interface IPlayInfoModel
	{
		function getLevel() : uint;
		function setLevel(val : uint) : void;
		
		function getMaleArr() : Array;
		function setMaleFId(id : uint, val : uint) : void;
		
		function getFemaleArr() : Array;
		function setFemaleFId(id : uint, val : uint) : void;
		
		function getDadFlg() : Boolean;
		function setDadFlg(val : Boolean) : void;
		
		function getMomFlg() : Boolean;
		function setMomFlg(val : Boolean) : void;
			
	}
}