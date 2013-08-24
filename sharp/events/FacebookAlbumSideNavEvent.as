package sharp.events
{
	import flash.events.Event;
	
	public class FacebookAlbumSideNavEvent extends Event
	{
		
		public static const DELETE_PHOTO					:String = "delete photo";
		public static const DESELECT_PHOTO					:String = "deselect photo";
		
		public var photoId:String;
		
		public function FacebookAlbumSideNavEvent(type:String, _photoId:String="", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);			
			photoId = _photoId;
		}
		

		
	}
}