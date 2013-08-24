package sharp.events
{

	import flash.events.Event;
	
	public class SharpNavigationEvent extends Event
	{
		public static const NAVIGATION_BUILD_COMPLETE				:String = "navigation build complete";
		public static const ROOM_SELECTED							:String = "room selected";
		public static const GALLERY_CLICKED							:String = "gallery clicked";
		public static const YES_CLICKED								:String = "yes clicked";
		public static const SUB_PAGE_NAVIGATION_CLICKED				:String = "sub page navigation clicked";
		public static const TRACK_GOOGLE_ANALYTICS					:String = "track google analytics"
		
		public var id												:String;
		public var index											:Number;
		
		public function SharpNavigationEvent(type:String, _index:Number, _id:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			id = _id;
			index = _index;

		}
	}
}