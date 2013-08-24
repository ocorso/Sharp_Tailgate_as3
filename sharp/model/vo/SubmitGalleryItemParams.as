package sharp.model.vo
{
	import flash.display.Bitmap;
	
	import sharp.views.facebookModule.vo.WallPostParams;

	public class SubmitGalleryItemParams extends Object
	{
		
		private var _route								:String;
		private var _dropRoute							:String;
		private var _setPostIdRoute						:String;
		private var _userId								:String;
		private var _username							:String;
		private var _photoUrl							:String;
		private var _isSlideshow						:Boolean = false;
		private var _tid								:String = "";
		private var _roomBitmap							:Bitmap;
		private var _forgroundBitmap					:Bitmap;
		private var _mediaId							:String;
		private var _title								:String = "";
		private var _tvSize								:String = "90";
		private var _roomType							:String = "ManCave";
		private var _postId								:String;
		private var _appPostId							:String;
		private var _fbPostParams						:WallPostParams;
		private var _userEmail							:String;
		
		public function SubmitGalleryItemParams(_init:Object = null)
		{
			for(var p:String in _init) this[p] = _init[p];
		}

		public function get userEmail():String
		{
			return _userEmail;
		}

		public function set userEmail(value:String):void
		{
			_userEmail = value;
		}

		public function get dropRoute():String
		{
			return _dropRoute;
		}

		public function set dropRoute(value:String):void
		{
			_dropRoute = value;
		}

		public function get forgroundBitmap():Bitmap
		{
			return _forgroundBitmap;
		}

		public function set forgroundBitmap(value:Bitmap):void
		{
			_forgroundBitmap = value;
		}

		public function get roomType():String
		{
			return _roomType;
		}

		public function set roomType(value:String):void
		{
			_roomType = value;
		}

		public function get tvSize():String
		{
			return _tvSize;
		}

		public function set tvSize(value:String):void
		{
			_tvSize = value;
		}

		public function get postid():String
		{
			return _postId;
		}

		public function set postid(value:String):void
		{
			_postId = value;
		}

		public function get mediaId():String
		{
			return _mediaId;
		}

		public function set mediaId(value:String):void
		{
			_mediaId = value;
		}

		public function get roomBitmap():Bitmap
		{
			return _roomBitmap;
		}

		public function set roomBitmap(value:Bitmap):void
		{
			_roomBitmap = value;
		}

		public function get tid():String
		{
			return _tid;
		}

		public function set tid(value:String):void
		{
			_tid = value;
		}

		public function get isSlideshow():Boolean
		{
			return _isSlideshow;
		}

		public function set isSlideshow(value:Boolean):void
		{
			_isSlideshow = value;
		}

		public function get username():String
		{
			return _username;
		}

		public function set username(value:String):void
		{
			_username = value;
		}

		public function get userId():String
		{
			return _userId;
		}

		public function set userId(value:String):void
		{
			_userId = value;
		}

		public function get fbPostParams():WallPostParams
		{
			return _fbPostParams;
		}

		public function set fbPostParams(value:WallPostParams):void
		{
			_fbPostParams = value;
		}

		public function get route():String
		{
			return _route;
		}

		public function set route(value:String):void
		{
			_route = value;
		}

		public function get photoUrl():String
		{
			return _photoUrl;
		}

		public function set photoUrl(value:String):void
		{
			_photoUrl = value;
		}

		public function get title():String
		{
			return _title;
		}

		public function set title(value:String):void
		{
			_title = value;
		}

		public function get setPostIdRoute():String
		{
			return _setPostIdRoute;
		}

		public function set setPostIdRoute(value:String):void
		{
			_setPostIdRoute = value;
		}
	}
}