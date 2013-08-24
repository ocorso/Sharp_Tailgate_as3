package cfm.facebook
{
	import cfm.facebook.data.UserData;
	import cfm.facebook.events.FacebookSessionEvent;
	import cfm.facebook.vo.WallPostParams;
	
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Security;
	
	import net.ored.util.out.Out;
	
	[Event(name="authorizationSuccess", type="cfm.facebook.events.FacebookSessionEvent")]
	[Event(name="authorizationFailed", type="cfm.facebook.events.FacebookSessionEvent")]
	[Event(name="loginFailed", type="cfm.facebook.events.FacebookSessionEvent")]
	[Event(name="usersDataComplete", type="cfm.facebook.events.FacebookSessionEvent")]
	[Event(name="friendsDataComplete", type="cfm.facebook.events.FacebookSessionEvent")]
	[Event(name="postToWallComplete", type="cfm.facebook.events.FacebookSessionEvent")]
	
	public class FacebookSession extends EventDispatcher
	{
		private var _authToken					:String;
		
		private var _friendsList				:Vector.<UserData>;
		
		private var _userData					:UserData;
		
		private var _waitingForMyData			:Boolean = false;
		private var _waitingForMyFriendsData	:Boolean = false;
				
		public function FacebookSession(target:IEventDispatcher=null)
		{
			super(target);
			
			ExternalInterface.addCallback("onAuthorizationSuccess", onAuthorizationSuccess);
			ExternalInterface.addCallback("onAuthorizationFailed", onAuthorizationFailed);
			ExternalInterface.addCallback("onLoginFailed", onLoginFailed);
			ExternalInterface.addCallback("onPostToWallFailed", onPostToWallFailed);
			ExternalInterface.addCallback("onPostToWallSuccess", onPostToWallSuccess);
		}
		
		public function checkForAuthToken():void{
			Out.debug(this, "checkForAuthToken");
			ExternalInterface.call("checkForAuthToken");
		}
		
		private function onAuthorizationSuccess(__authToken:String):void{
			Out.debug(this,"::Authorization Success::" + __authToken);
			
			_authToken = __authToken;
			
			dispatchEvent(new FacebookSessionEvent(FacebookSessionEvent.AUTORIZATION_SUCCESS));
			
			if(_waitingForMyData)
				getMyData();
			else if(_waitingForMyFriendsData)
				getMyFriendsData();
		}
		
		private function onAuthorizationFailed():void{
			Out.debug(this,"::Authorization Failed::");
			
			_waitingForMyData = false;
			_waitingForMyFriendsData = false;
			
			dispatchEvent(new FacebookSessionEvent(FacebookSessionEvent.AUTORIZATION_FAILED));
		}
		
		private function onLoginFailed():void{
			Out.debug(this,"::Login Failed::");
			
			_waitingForMyData = false;
			_waitingForMyFriendsData = false;
			
			dispatchEvent(new FacebookSessionEvent(FacebookSessionEvent.LOGIN_FAILED));
		}
		
		public function get authorized():Boolean{			
			if(	_authToken && _authToken != "undefined" && _authToken != "null" )
				return true;
			else
				return false;
		}
		
		public function getMyData():void{
			Out.debug(this,"::Get My Data:: " + authorized);
		
			if(authorized){		
				Out.debug(this,"	-- User is authorized - fetching data");
				_waitingForMyData = false;
				
				var loader:URLLoader = new URLLoader(new URLRequest("https://graph.facebook.com/me/?access_token=" + _authToken));
				loader.addEventListener(Event.COMPLETE, onGetMyDataComplete, false, 0, true);
			}else{
				Out.debug(this,"	-- User is NOT authorized - logging in now...");
				
				_waitingForMyData = true;
				ExternalInterface.call("getAuthorization", "basic");
			}
		}
		
		public function getMyFriendsData():void{
			Out.debug(this,"Get My Friends Data");
			
			if(authorized){
				Out.debug(this,"	-- User is authorized");
				if(userData){
					Out.debug(this,"		-- User Data is here - fetching data");
					_waitingForMyFriendsData = false;
				
					var loader:URLLoader = new URLLoader(new URLRequest("https://graph.facebook.com/me/friends?access_token=" + _authToken));
					loader.addEventListener(Event.COMPLETE, onGetMyFriendsDataComplete, false, 0, true);
				} else {
					getMyData();
				}
			}else{
				Out.debug(this,"	-- User is NOT authorized - logging in now...");
				
				ExternalInterface.call("getAuthorization", "basic");
			}			
		}
		
		private function onGetMyDataComplete(e:Event):void{		
			Out.debug(this,"::Get My Data Complete::");
			
			var loader:URLLoader = URLLoader(e.currentTarget);
			loader.removeEventListener(Event.COMPLETE, onGetMyDataComplete);
			
			var data:Object = JSON.decode(loader.data);
			
			_userData = new UserData(0, data.id, data.username, data.name)
			
			dispatchEvent(new FacebookSessionEvent(FacebookSessionEvent.USERS_DATA_COMPLETE));
			
			if(_waitingForMyFriendsData){
				getMyFriendsData();
			}
		}
		
		private function onGetMyFriendsDataComplete(e:Event):void{
			Out.debug(this,"::Get My Friends Data Complete::");
			
			var loader:URLLoader = URLLoader(e.currentTarget);
			loader.removeEventListener(Event.COMPLETE, onGetMyFriendsDataComplete);
						
			var data:Object = JSON.decode(loader.data);
			
			_friendsList = new Vector.<UserData>();
			
			var i:Number = 0;
			for each(var friend:Object in data.data){
				_friendsList.push(new UserData(i, friend.id, friend.username, friend.name));
				i++;
			}
			
			dispatchEvent(new FacebookSessionEvent(FacebookSessionEvent.FRIENDS_DATA_COMPLETE));
		}
		
		public function postToWall($p:WallPostParams):void{
			Out.debug(this,"Init - Post To Wall");
			
			ExternalInterface.call("WallPost", $p.linkUrl, $p.linkName, $p.description, $p.imageUrl, $p.caption, $p.message)
		}
		
		private function onPostToWallSuccess(_postId:String):void{
			Out.debug(this,"Post To Wall Success");
			
			dispatchEvent(new FacebookSessionEvent(FacebookSessionEvent.POST_TO_WALL_SUCCESS));
		}
		
		private function onPostToWallFailed():void{
			Out.debug(this,"Post To Wall Failed");
			
			dispatchEvent(new FacebookSessionEvent(FacebookSessionEvent.POST_TO_WALL_FAILED));
		}
		
		public function get userData():UserData{
			return _userData;
		}
		
		private function getFriendsIds():String{
			var s:String = _userData ? _userData.userId : "0";
			
			if(_friendsList)
				for each(var ud:UserData in _friendsList)
				s += (( ud.index > 0 || _userData ? "," : "" ) + ud.userId);
			
			return s;
		}
	}
}