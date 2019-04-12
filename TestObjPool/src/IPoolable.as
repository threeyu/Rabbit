package  
{
	
	public interface IPoolable 
	{
		function get destroyed():Boolean;
		
		function renew():void;
		function destroy():void;
	}
	
}