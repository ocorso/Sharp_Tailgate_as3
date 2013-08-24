package sharp.services
{

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Actor;
	
	import sharp.events.SharpAppServiceEvent;
	import sharp.interfaces.IService;
	import sharp.model.vo.Vo;
	
	public class AppService extends Actor implements IService
	{
		
		private var loader				:URLLoader;
		
		public function AppService()
		{
			loader = new URLLoader();
		}
		
		public function getAppData(_baseUrl:String):void
		{
			Out.status(this, "get data")
			var url:String = 	_baseUrl + Vo.APP_CONFIG_URL;
			Out.status(this, url); 
			var urlRequest:URLRequest = new URLRequest(url);
			addLoaderListeners();
			loader.load(urlRequest);
		}
		
		private function handleError(event:SecurityErrorEvent):void
		{
			removeLoaderListeners();
		}
		
		private function handleLoadComplete(event:Event):void
		{
			var appData:XML = XML(event.target.data);

			eventDispatcher.dispatchEvent(new SharpAppServiceEvent(SharpAppServiceEvent.APP_DATA_LOADED, appData));

			removeLoaderListeners();
		}
		
		private function addLoaderListeners():void
		{
			loader.addEventListener(IOErrorEvent.IO_ERROR, handleError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
			loader.addEventListener(Event.COMPLETE, handleLoadComplete);
		}
		
		private function removeLoaderListeners():void
		{
			loader.removeEventListener(IOErrorEvent.IO_ERROR, handleError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
			loader.removeEventListener(Event.COMPLETE, handleLoadComplete);
		}
	}
}