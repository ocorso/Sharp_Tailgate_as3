package sharp.events
{
	import flash.events.Event;
	
	public class DataResponseEvent extends Event
	{
		public static var RESPONSE:String = "response";
		public var body:Object;
		
		public function DataResponseEvent(type:String, $body:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			body = $body;
		}
	}
}