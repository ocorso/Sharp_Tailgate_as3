package sharp.commands
{
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Command;
	
	import sharp.events.SharpAppEvent;
	import sharp.events.SharpAppServiceEvent;
	import sharp.interfaces.IService;
	import sharp.model.Model;
	import sharp.model.vo.Vo;
	import sharp.views.facebookModule.service.FacebookService;
	import sharp.views.youtubeModule.service.YouTubeService;
	
	public class StartUpCommand extends Command
	{
		
		[Inject]
		public var _m:Model;
		
		[Inject]
		public var service:IService;
		
		[Inject]
		public var fbService:FacebookService;
		
		[Inject]
		public var ytService:YouTubeService;
		
		[Inject]
		public var event:SharpAppEvent;
		
		public function StartUpCommand()
		{
			super();
		}
		
		override public function execute():void{
			Out.status(this, "execute");
			_m.likeStatus 	= event.likeStatus;
			_m.baseUrl 		= event.baseUrl;
			_m.tid 			= event.tid;
			service.getAppData(_m.baseUrl);
			fbService.callData();
			ytService.init();

			eventDispatcher.addEventListener(SharpAppServiceEvent.APP_DATA_LOADED, onDataLoaded);	
		}
		
		private function onDataLoaded(e:SharpAppServiceEvent):void {
			_m.appData= e.appData;
		}
	}
}