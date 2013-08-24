package sharp.events
{
	import flash.events.Event;
	
	import sharp.views.appTemplate.SharpPageTemplate;
	
	public class SharpAppEvent extends Event
	{
		public static const APP_STARTUP_COMPLETE			:String = "app start up complete";
		public static const APP_DATA_RECEIVED				:String = "app data received";

		private var _likeStatus								:Boolean;
		private var _baseUrl								:String;
		private var _tid									:String;
		
		public function SharpAppEvent(type:String, likeStatus:Boolean, baseUrl:String, tid:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_likeStatus = likeStatus;
			_baseUrl = baseUrl;
			_tid = tid;
		}
		
		override public function clone():Event{
			return new SharpAppEvent(type, likeStatus, baseUrl, tid);
		}
		
		public function get likeStatus():Boolean{
			return _likeStatus;
		}
		
		public function get baseUrl():String{
			return _baseUrl;
		}
		
		public function get tid():String{
			return _tid;
		}
	}
}