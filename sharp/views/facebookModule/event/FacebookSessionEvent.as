package sharp.views.facebookModule.event
{
	import flash.events.Event;
	
	public class FacebookSessionEvent extends Event
	{
		public static const AUTORIZATION_SUCCESS	:String = "authorizationSuccess";
		public static const AUTORIZATION_FAILED		:String = "authorizationFailed";
		public static const USERS_DATA_COMPLETE		:String = "usersDataComplete";
		public static const FRIENDS_DATA_COMPLETE	:String = "friendsDataComplete";
		public static const POST_TO_WALL_COMPLETE	:String = "postToWallComplete";
		public static const ALL_DATA_COMPLETE		:String = "allDataComplete";
		public static const ALBUMS_COMPLETE			:String = "albumsComplete";
		public static const CANCEL					:String = "cancel";
		public static const LOGIN_FAILED			:String = "loginFailed";
		public static const POST_TO_WALL_FAILED		:String = "postToWallFailed";
		public static const POST_TO_WALL_SUCCESS	:String = "postToWallComplete";
		public static const POST_TO_WALL			:String = "postToWall";
		public static const SAVE_POST_ID_COMPLETE	:String = "saveIdComplete";
		public static const LIKE_BUTTON_CLICKED		:String = "likebuttonclicked";
		
		public var scope							:String;
		private var _params							:Object;
		
		public function FacebookSessionEvent(type:String, params:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_params = params;
		}
		override public function clone():Event{
			return new FacebookSessionEvent(type, params);
		}
		
		public function get params():Object
		{
			return _params;
		}
	}
}