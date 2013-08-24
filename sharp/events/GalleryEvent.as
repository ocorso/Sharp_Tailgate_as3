package sharp.events
{
	import flash.events.Event;
	
	public class GalleryEvent extends Event
	{
		public static const GET_IMAGES_DATA			:String = "get images data";
		public static const GOT_IMAGES_DATA			:String = "got images data";
		public static const GET_IMAGE_DETAIL_DATA	:String = "get image detail data";
		public static const GOT_IMAGE_DETAIL_DATA	:String = "got image detail data";
		public static const LIKE_CLICKED			:String = "like";
		
		private var _params						:Object;
		
		public function GalleryEvent(type:String, params:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_params = params;

		}

		override public function clone():Event{
			return new GalleryEvent(type, params);
		}

		public function get params():Object
		{
			return _params;
		}
	}
}