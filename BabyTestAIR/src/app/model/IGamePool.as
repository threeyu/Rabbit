package app.model
{
	import app.view.api.IView;

	public interface IGamePool
	{
		function getView(val : *) : IView;
	}
}