package cfm.facebook
{
	import cfm.core.objects.CFM_Object;
	import cfm.facebook.ui.WallPostWindow;
	import cfm.facebook.vo.WallPostParams;
	
	import com.carlcalderon.arthropod.Debug;
	
	public class FacebookUIManager extends CFM_Object
	{
		private var _session:FacebookSession;
		private var _window:WallPostWindow;
		
		private var _windowParams:WallPostParams;
		
		private var _waitingToShowPostWindow:Boolean = false;
		
		public function FacebookUIManager($session:FacebookSession, $windowParams:WallPostParams)
		{
			_session 		= $session;
			_windowParams 	= $windowParams;
			
			super("FacebookUI", true, true);
		}
		
		override protected function build():void{
			_session = new FacebookSession();
			
			_window = new WallPostWindow(_session, _windowParams);
			_window.renderTo(this);
			_window.setProperties({x:stage.stageWidth*.5, y:stage.stageHeight*.4});
		}
		
		public function showPostToWallWindow(_imageUrl:String, _newLinkUrl:String, _newLinkName:String, _userFacebookUI:Boolean = false):void{			
			_window.update(_imageUrl,_newLinkUrl,_newLinkName);
			
			if(_userFacebookUI){
				_session.postToWall(_newLinkUrl,"Denny's Photo-A-Day Contest","Share your Instagram photos tagged with the word of the day to win a $10 gift card!","http://dennyssocial.com/photoaday/public/img/75x75.jpg","http://www.facebook.com/dennys", _userFacebookUI);
			} else {
				if(_session.authorized){
					_waitingToShowPostWindow = false;
					_window.show();
				} else {
					_waitingToShowPostWindow = true;
					_window.hide();
					_session.init();
				}
			}
		}
		
		public function onFacebookSessionReady():void{			
			_window.updateSessionData();
			
			if(_waitingToShowPostWindow)
				_window.show();
			else
				_window.hide();
		}
		
		public function onPostToWallComplete():void{
			_window.hide();
		}
		
		public function get window():WallPostWindow{
			return _window;
		}
	}
}