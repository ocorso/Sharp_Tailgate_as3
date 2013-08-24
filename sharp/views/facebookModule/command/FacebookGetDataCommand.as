package sharp.views.facebookModule.command
{
	import cfm.facebook.FacebookSession;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Command;
	
	import sharp.model.Model;
	import sharp.views.facebookModule.event.FacebookSessionEvent;
	import sharp.views.facebookModule.vo.FacebookData;
	
	public class FacebookGetDataCommand extends Command
	{
		
		[Inject]
		public var event:FacebookSessionEvent;
		
		[Inject]
		public var _m:Model;
		
		public function FacebookGetDataCommand()
		{
			super();
		}
		
		override public function execute():void{
			Out.status(this, "execute");
			
			switch(event.type){
				case FacebookSessionEvent.ALL_DATA_COMPLETE:
					_m.facebook = FacebookData(event.params);
					
					Out.info(this,"Data Complete: "+ _m.facebook.authToken);
					
					postMyFriendsLikesToTheDatabase();
					break;
			}
		}
		
		private function postMyFriendsLikesToTheDatabase():void{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, postMyFriendsLikesToTheDatabaseComplete);
			loader.load(new URLRequest(_m.baseUrl + "/likes/addfriendlikestomyposts/" + _m.facebook.userId + "/" + _m.facebook.authToken  ));
		}
		
		private function postMyFriendsLikesToTheDatabaseComplete(e:Event):void{
			Out.status(this, "postMyFriendsLikesToTheDatabaseComplete :: " + URLLoader(e.currentTarget).data);
		}
	}
}