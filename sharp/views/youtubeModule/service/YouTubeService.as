package sharp.views.youtubeModule.service
{
	import flash.system.Security;
	
	import org.robotlegs.mvcs.Actor;
	
	import sharp.interfaces.IService;
	import sharp.model.vo.Vo;
	import sharp.views.youtubeModule.event.YoutubeEvent;
	import sharp.views.youtubeModule.vo.YoutubeData;
	
	public class YouTubeService extends Actor
	{
		
		
		// =================================================
		// ================ Callable
		// =================================================
		public function init():void{
			
			Security.allowDomain("www.youtube.com");
			Security.allowDomain('www.youtube.com');  
			Security.allowDomain('youtube.com');  
			Security.allowDomain('s.ytimg.com');  
			Security.allowDomain('i.ytimg.com'); 
			Security.allowDomain('s0.2mdn.net');

		}
		
		// =================================================
		// ================ Create and Build
		// =================================================
		
		// =================================================
		// ================ Workers
		// =================================================
		
		// =================================================
		// ================ Handlers
		// =================================================
		
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function YouTubeService()
		{
			super();
		}
	}
}