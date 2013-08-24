package cfm.core.events
{
	import flash.events.Event;
	
	public class CornerPinClipEvent extends Event
	{
		public static const COMPLETE:String = "complete";
		public static const PROGRESS:String = "progress";
		
		public var progress:Number;
		
		public function CornerPinClipEvent(type:String, _progress:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			progress = _progress;
			
			super(type, bubbles, cancelable);
		}
	}
}