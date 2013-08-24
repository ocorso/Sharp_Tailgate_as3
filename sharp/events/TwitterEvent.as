package sharp.events
{
	import flash.events.Event;
	
	public class TwitterEvent extends Event
	{
		public static const TWEET:String = "TWEET TWEET";
		
		public var payload:Object;
		
		public function TwitterEvent(type:String, $payload:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			payload = $payload;
		}
	}
}