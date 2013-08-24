package sharp.commands
{
	import org.robotlegs.mvcs.Command;
	
	import sharp.events.TwitterEvent;
	import sharp.model.Model;
	import sharp.services.TwitterService;
	
	public class TwitterCommand extends Command
	{
		[Inject]
		public var event:TwitterEvent;
		
		[Inject]
		public var service:TwitterService;
		
		[Inject]
		public var _m:Model;
		
		public function TwitterCommand()
		{
			super();
		}
		
		override public function execute():void{
			
			service.tweet(event.payload.shareUrl, _m.appData.environment.twitter);
			
		}
	}
}