package sharp.events
{
	import flash.events.Event;
	
	import sharp.model.vo.SubmitGalleryItemParams;
	
	public class SubmitGalleryItemEvent extends Event
	{					
		public static const SAVE_IMAGE_TO_GALLERY						:String = "saveImageToGallery";
		public static const SAVE_IMAGE_COMPLETE							:String = "saveImageComplete";
		public static const DROP_IMAGE_FROM_GALLERY						:String = "dropImageFromGallery";
		public static const DROP_IMAGE_COMPLETE							:String = "dropImageComplete";
		
		
		private var _params												:Object;
		
		public function SubmitGalleryItemEvent(type:String, params:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_params = params;
		}
		
		override public function clone():Event{
			return new SubmitGalleryItemEvent(type, params);
		}
		
		public function get params():Object{
			return _params;
		}
	}
}