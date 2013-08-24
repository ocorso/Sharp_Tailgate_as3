package sharp.commands
{
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Command;
	
	import sharp.events.SharpPageEvent;
	import sharp.model.Model;
	import sharp.model.vo.Vo;
	import sharp.views.AppHome;
	
	public class ChangePageCommand extends Command
	{
		[Inject]
		public var event:SharpPageEvent;
		
		[Inject]
		public var _m:Model;
		
		public function ChangePageCommand()
		{
			super();
		}
		
		override public function execute():void{
			_m.currentPageId = event.pageId;
			Out.info(this, _m.currentPageId);
		}
	}
}