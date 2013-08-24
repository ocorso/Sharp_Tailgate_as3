package sharp.views.youtubeModule.command
{
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Command;
	
	import sharp.model.Model;
	import sharp.views.youtubeModule.event.YoutubeEvent;
	
	public class YoutubeCommand extends Command
	{
		
		[Inject]
		public var event:YoutubeEvent;
		
		[Inject]
		public var _m:Model;
		
		public function YoutubeCommand()
		{
			super();
		}
		
		override public function execute():void{
			switch(event.type){
				case YoutubeEvent.INIT:
					_m.youtube = event.params;
					break;
				case YoutubeEvent.SAVE_VIDEO_ID:
					_m.youtube = event.params;
					break;
				case YoutubeEvent.GET_VIDEO_ID:
					_m.youtube = event.params;
					break;
			}
			
		}

	}
}