package sharp.views.facebookModule.service
{

	import com.adobe.serialization.json.JSON;
	import com.carlcalderon.arthropod.Debug;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import net.ored.events.ORedEvent;
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Actor;
	
	import sharp.model.vo.SubmitGalleryItemParams;
	import sharp.model.vo.Vo;
	import sharp.views.facebookModule.event.FacebookSessionEvent;
	import sharp.views.facebookModule.vo.FacebookData;
	
	public class FacebookService extends Actor
	{
		private var __AUTH_PREFIX			:String = "https://graph.facebook.com/";
		
		public static const ADD_LIKE_COMPLETE		:String = "ADD_LIKE_COMPLETE";
		public static const REMOVE_LIKE_COMPLETE	:String = "REMOVE_LIKE_COMPLETE";
		
		private var _authToken				:String;
		private var _friendsList			:Vector.<FacebookData>;
		private var _albumsList				:Array = new Array();
		private var _userData				:FacebookData;
		
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		
		// =================================================
		// ================ Workers
		// =================================================
		
		private function _init():void{
			ExternalInterface.addCallback("onAuthorizationSuccess", onAuthorizationSuccess);
			ExternalInterface.addCallback("onAuthorizationFailed", onAuthorizationFailed);
			ExternalInterface.addCallback("onPostToWallFailed", onPostToWallFailed);
			ExternalInterface.addCallback("onPostToWallSuccess", onPostToWallSuccess);
			ExternalInterface.addCallback("onRemoveLikeSuccess", _onRemoveLikeComplete);
		}

		private function _checkForAuthToken():void{
			Out.status(this, "checkForAuthToken");
			
			if(ExternalInterface.available)	
				ExternalInterface.call("checkForAuthToken");
			else 
				Out.error(this, "ExternalInterface NOT Available");
		}
		
		public function getMyData():void{
			var loader:URLLoader = new URLLoader(new URLRequest(__AUTH_PREFIX + "me/?access_token=" + _authToken));
			
			loader.addEventListener(Event.COMPLETE, onGetMyDataComplete, false, 0, true);
		}
		
		public function getMyFriendsData():void{
			Out.debug(this,"Get My Friends Data");
			
			var loader:URLLoader = new URLLoader(new URLRequest("https://graph.facebook.com/me/friends?limit=0&access_token=" + _authToken));
			loader.addEventListener(Event.COMPLETE, onGetMyFriendsDataComplete, false, 0, true);
		}
		
		private function getMyAlbums():void{
			var url:String = "https://graph.facebook.com/" + _userData.userId + "/albums?limit=0&access_token=" + _authToken;
			
			Out.warning(this, url);
			
			var loader:URLLoader = new URLLoader(new URLRequest(url));
			
			loader.addEventListener(Event.COMPLETE, onGetMyAlbumsComplete, false, 0, true);
		}
		
		private function getFriendsIds():String{
			var s:String = _userData ? _userData.userId : "0";
			
			if(_friendsList){
				for each(var ud:FacebookData in _friendsList){
					s += (( ud.index > 0 || _userData ? "," : "" ) + ud.userId);
				}
			}
			
			return s;
		}
		
		// =================================================
		// ================ Handlers
		// =================================================
			
		private function onAuthorizationSuccess($authToken:String):void{
			Out.status(this,"::Authorization Success::" + $authToken);
						
			_authToken = $authToken;
			dispatch(new FacebookSessionEvent(FacebookSessionEvent.AUTORIZATION_SUCCESS,{authToken:$authToken}));
			getMyData();
		}
		
		
		private function onAuthorizationFailed():void{
			Out.error(this,"::Authorization Failed::");

			dispatch(new FacebookSessionEvent(FacebookSessionEvent.AUTORIZATION_FAILED,{error:"auth failed"}));
		}
		
		private function onGetMyDataComplete(e:Event):void{
			Out.status(this, "Get My Data Complete");
			
			var loader:URLLoader = URLLoader(e.currentTarget);
			loader.removeEventListener(Event.COMPLETE, onGetMyDataComplete);
			
			var data:Object = JSON.decode(loader.data);
			
			_userData = new FacebookData(0, data.id, data.username, data.name, "square", null)
			
			dispatch(new FacebookSessionEvent(FacebookSessionEvent.USERS_DATA_COMPLETE,{}));
			
			getMyFriendsData();
		}
		
		private function onGetMyFriendsDataComplete(e:Event):void{
			Out.status(this, "Get My Friends Data Complete");
			
			var loader:URLLoader = URLLoader(e.currentTarget);
			loader.removeEventListener(Event.COMPLETE, onGetMyFriendsDataComplete);
			
			var data:Object = JSON.decode(loader.data);
			
			_friendsList = new Vector.<FacebookData>();
			
			var i:Number = 0;
			for each(var friend:Object in data.data){
				_friendsList.push(new FacebookData(i, friend.id, friend.username, friend.name, "square", null));
				i++;
			}
			
			dispatch(new FacebookSessionEvent(FacebookSessionEvent.FRIENDS_DATA_COMPLETE, _friendsList));
			
			_userData.friends = _friendsList;
			
			getMyAlbums();
		}
		
		protected function onGetMyAlbumsComplete($e:Event):void
		{
			Out.status(this, "onGetMyAlbumsComplete");
			
			var loader:URLLoader = URLLoader($e.currentTarget);
			loader.removeEventListener(Event.COMPLETE, onGetMyDataComplete);
			
			var data:Object 	= JSON.decode(loader.data);
			
			_albumsList = _albumsList.concat(data.data);
			
			_userData.albums 	= _albumsList;
			_userData.authToken = _authToken;
			
			dispatch(new FacebookSessionEvent(FacebookSessionEvent.ALL_DATA_COMPLETE, _userData));
		}
		
		// =================================================
		// ================ Wall Post Handlers
		// =================================================
		
		public function postToWall($p:SubmitGalleryItemParams):void{
			Out.debug(this,"Init - Post To Wall");

			var url:String 		= $p.fbPostParams.linkUrl+$p.tid;
			var badge:String 	= String($p.fbPostParams.imageUrl + $p.tid + ".jpg").replace("https", "http");
			
			Out.info( this, url);
			
			Debug.log("badge: "+badge, Debug.LIGHT_BLUE);
			ExternalInterface.call("WallPost", url, $p.fbPostParams.linkName, $p.fbPostParams.description, badge, $p.fbPostParams.caption, $p.fbPostParams.message)
		}
		
		public function savePostId($p:SubmitGalleryItemParams):void{
			var url:String = $p.setPostIdRoute + $p.postid;
			
			Out.status(this, "savePostId: "+url);
			var ldr:URLLoader 	= new URLLoader();
			var req:URLRequest	= new URLRequest(url);
			req.method 			= URLRequestMethod.POST;
			req.data			= new URLVariables();
			req.data.tid		= $p.tid;
			ldr.addEventListener(Event.COMPLETE, _onSavePostIdComplete);
			ldr.load(req);
		}
		
		protected function _onSavePostIdComplete($e:Event):void
		{
			Out.status(this, "_onSavePostIdComplete");
			
			//oc: dispatch to the CustomizeMediator so that it can change status to FINISH
			dispatch(new FacebookSessionEvent(FacebookSessionEvent.SAVE_POST_ID_COMPLETE, {}));
		}
		private function onPostToWallSuccess(_postId:String):void{
			Out.warning(this,"Post To Wall Success: "+ _postId);
			
			dispatch(new FacebookSessionEvent(FacebookSessionEvent.POST_TO_WALL_SUCCESS, {postId:_postId}));
		}
		
		private function onPostToWallFailed():void{
			Out.debug(this,"Post To Wall Failed");
			
			dispatch(new FacebookSessionEvent(FacebookSessionEvent.POST_TO_WALL_FAILED,{response:"failed"}));
		}
		
		// =================================================
		// ================ Likes
		// =================================================
		
		public function like($o:Object):void{
			Out.status(this, "like: "+$o.isLiked);
			
			$o.isLiked ? addLikeByPostId( $o ) : removeLikeByPostId( $o );
		}
		
		private function _getTempObj():Object
		{
			var o:Object = new Object();
			o.accessToken 	= "AAAEcMYblHnwBAKT8sZC3YAxxFUtrkUzUiyIZAZBsfgwID9da7zJShvcV9uo9Rbckji5BquonH2qlk6WbeJfYRjZAqyViYnj2NvtlKQh0YdsqmTW0ZC4en";
			o.postId		= "100000107213186_430769826973732";
			o.tid			= "1344889540";
			
			return o;
		}
		
		public function addLikeByPostId(p:Object):void{
			Out.status(this, "addLikeByPostId: " + p.addRoute);
			
			var req:URLRequest	= new URLRequest(p.addRoute);
			req.method			= URLRequestMethod.POST;
			var vars:URLVariables	= new URLVariables();
			vars.access_token	= p.accessToken;
			req.data			= vars;
			var ldr:URLLoader	= new URLLoader();
			ldr.addEventListener(Event.COMPLETE, _onAddLikeComplete);
			ldr.load(req);
		}
		
		protected function _onAddLikeComplete($e:Event):void
		{
			var ldr:URLLoader = URLLoader($e.target);
			URLLoader($e.target).removeEventListener(Event.COMPLETE, _onAddLikeComplete);
			Out.status(this, "_onAddLikeComplete: "+ ldr.data);
			dispatch(new ORedEvent(ADD_LIKE_COMPLETE,{result:ldr.data}));
			
		}
		public function removeLikeByPostId(p:*):void{
			Out.status (this, "removeLikeByPostId: "+ p.removeRoute);
			
			var url:String 		= p.removeRoute;
			var req:URLRequest	= new URLRequest(url);
			req.method			= "POST";
			var vars:URLVariables = new URLVariables();
			vars.access_token	= p.accessToken;
			req.data			= vars;
			var ldr:URLLoader	= new URLLoader();
			ldr.addEventListener(Event.COMPLETE, _onRemoveLikeComplete);
			ldr.load(req);

		}
		
		protected function _onRemoveLikeComplete($e:Event):void
		{
			var ldr:URLLoader = URLLoader($e.target);
			Out.status(this, "_onRemoveLikeComplete: "+ ldr.data);
			ldr.removeEventListener(Event.COMPLETE, _onRemoveLikeComplete);
			
			dispatch(new ORedEvent(REMOVE_LIKE_COMPLETE,{result:ldr.data}));
		}
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		
		// =================================================
		// ================ Testes
		// =================================================

		
		// =================================================
		// ================ Callable
		// =================================================
		
		public function callData():void
		{
			Out.status(this, "callData()");
			
			_init();
			_checkForAuthToken();
		}
	}
}