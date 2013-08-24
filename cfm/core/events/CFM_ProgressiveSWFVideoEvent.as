package cfm.core.events
{
	import flash.events.Event;
	
	public class CFM_ProgressiveSWFVideoEvent extends Event
	{
		public static const COMPLETE:String = "complete";
		public static const RENDERING:String = "rendering";
		public static const BUFFERING:String = "buffering";
		public static const PROGRESS:String = "progress";
		
		public var loadProgress:Number;
		public var currentFrame:Number;
		public var playProgress:Number;
		
		public function CFM_ProgressiveSWFVideoEvent(type:String, _loadProgress:Number, _currentFrame:Number, _playProgress:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			loadProgress = _loadProgress;
			currentFrame = _currentFrame;
			playProgress = _playProgress;
			
			super(type, bubbles, cancelable);
		}
	}
}