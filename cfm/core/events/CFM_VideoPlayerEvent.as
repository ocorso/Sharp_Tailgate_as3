package cfm.core.events{
	
	import flash.events.Event;
	
	public class CFM_VideoPlayerEvent extends Event {
		
		public static const PLAY_PAUSE:String = "playPause";
		public static const REWIND:String = "rewind";
		public static const PROGRESS:String = "progress";
		public static const COMPLETE:String = "complete";
		public static const READY:String = "ready";
		public static const CUEPOINT:String = "cuePoint";
		public static const SHOW_BUFFER:String = "showBuffer";
		public static const HIDE_BUFFER:String = "hideBuffer";
		public static const WAITING_FOR_CUEPOINT:String = "waitingForSkip";
		public static const WAITING_FOR_CUEPOINT_COMPLETE:String = "skipComplete";
		
		public var playPercent:Number;
		public var downloadPercent:Number;
		public var cuePoint:Object;
		
		public function CFM_VideoPlayerEvent( $type:String , $playPercent:Number = 0, $downloadPercent:Number = 0, _cuePoint:Object = null, $bubbles:Boolean = false, $cancelable:Boolean = false ) {
			super($type, $bubbles, $cancelable);
			
			playPercent = $playPercent;
			downloadPercent = $downloadPercent;
			cuePoint = _cuePoint;
		}
	}
}