package sharp.events
{
	import flash.events.Event;
	
	public class SharpAppServiceEvent extends Event
	{
		
		public static const APP_DATA_LOADED:String = "app data loaded";
		
		private var _appData:XML;
		
		public function SharpAppServiceEvent(type:String, appData:XML, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_appData = appData;
		}
		
		override public function clone():Event{
			return new SharpAppServiceEvent(type, appData)
		}
		
		public function get appData():XML{
			return _appData;
		}
	}
}