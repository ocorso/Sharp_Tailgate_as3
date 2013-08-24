package sharp.events
{
	import flash.events.Event;
	
	public class FacebookPhotoEvent extends Event
	{
		
		public static const GET_PHOTO_URL					:String = "get photo url";
		public static const PHOTO_CLICKED					:String = "photoclicked";
		public static const CLEAR_PHOTO						:String = "clearPhoto";
		
		public function FacebookPhotoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}