package sharp.views.customizeModule.event
{
	import flash.events.Event;
	
	public class CustomizeEvent extends Event
	{
		
		public static const ROOM_IMAGE_LOADED					:String = "room image loaded";
		public static const FURNITURE_IMAGE_LOADED				:String = "furniture image loaded";
		public static const INPUT_FIELD_CHANGE					:String = "input field change";
		public static const CHECK_IS_SLIDESHOW					:String = "check if it's slideshow";
		
		public var isSlideshow								:Boolean;
		
		public function CustomizeEvent(type:String, _isSlideshow:Boolean, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			isSlideshow = _isSlideshow;
		}
	}
}