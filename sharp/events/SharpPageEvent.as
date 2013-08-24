package sharp.events
{
	import flash.events.Event;
	
	import sharp.views.appTemplate.SharpPageTemplate;
	
	public class SharpPageEvent extends Event
	{
		public static const PAGE_BUILD_COMPLETE				:String = "page built complete"
		public static const CHANGE_PAGE						:String = "change page";
		
		private var _pageId								:String;
		
		public function SharpPageEvent(type:String, pageId:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_pageId = pageId;
		}
		
		override public function clone():Event{
			return new SharpPageEvent(type, pageId)
		}
		
		public function get pageId():String{
			return _pageId;
		}
	}
}