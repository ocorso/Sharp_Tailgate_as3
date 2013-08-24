package sharp.commands
{

	import org.robotlegs.mvcs.Command;
	
	import sharp.events.SharpWindowEvent;
	import sharp.model.Model;
	
	public class WindowCommand extends Command
	{
		
		[Inject]
		public var event:SharpWindowEvent;
		
		[Inject]
		public var _m:Model;
		
		public function WindowCommand()
		{
			super();
		}
		
		override public function execute():void{
			
			switch (event.type){
				case SharpWindowEvent.OPEN_WINDOW:
					_m.currentWindowId = event.windowId;
					break;
				case SharpWindowEvent.CLOSE_WINDOW:
					break		
			}
		}
	}
}