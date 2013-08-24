package sharp.views.youtubeModule.event{	import flash.events.Event;		import sharp.views.youtubeModule.vo.YoutubeData;
	public class YoutubeEvent extends Event {				public static const INIT							:String = "INIT";		public static const SAVE_VIDEO_ID					:String = "SAVE_VIDEO_ID";		public static const GET_VIDEO_ID					:String = "GET_VIDEO_ID";			public static const ON_IOERROR						:String = "ON_IOERROR";		public static const ON_CHANGE						:String = "ON_CHANGE";		public static const ON_ERROR						:String = "ON_ERROR";		public static const ON_READY						:String = "ON_READY";		public static const ON_QUALITY_CHANGED				:String = "ON_QUALITY_CHANGED";		public static const CONTROL_BUTTON_CLICKED			:String = "CONTROL_BUTTON_CLICKED";				private var _params									:YoutubeData;				public function YoutubeEvent(type:String, params:YoutubeData, bubbles:Boolean=false, cancelable:Boolean=false) {			super(type);						_params = params;					}				override public function clone():Event{			return new YoutubeEvent(type, params);		}		public function get params():YoutubeData
		{
			return _params;
		}		public function set params(value:YoutubeData):void
		{
			_params = value;
		}			}}