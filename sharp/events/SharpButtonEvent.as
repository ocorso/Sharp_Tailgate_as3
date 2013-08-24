package sharp.events
{
	import flash.events.Event;
	
	public class SharpButtonEvent extends Event
	{
		public static const FACEBOOK_CHOOSE_CLICKED				:String = "facebook choose clicked";
		public static const CLEAR_PHOTO_CLICKED					:String = "backClicked";
		public static const YOUTUBE_BROWSE_CLICKED				:String = "youtubeclicked";
		
		
		public var id:String;
		
		public function SharpButtonEvent(type:String, _id:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			id = _id;
		}
	}
}