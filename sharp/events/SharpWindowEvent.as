package sharp.events
{
	import flash.events.Event;
	
	public class SharpWindowEvent extends Event
	{
		public static const OPEN_WINDOW										:String = "openWindow";
		public static const CLOSE_WINDOW									:String = "closeWindow";
		
		private var _windowId:String;
		private var _body:Object;
		
		public function SharpWindowEvent(type:String, windowId:String, body:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_windowId = windowId;
			_body = body;
		}
		
		override public function clone():Event{
			return new SharpWindowEvent(type, windowId, body);
		}
		
		public function get windowId():String{
			return _windowId;
		}
		
		public function get body():Object{
			return _body;
		}
	}
}