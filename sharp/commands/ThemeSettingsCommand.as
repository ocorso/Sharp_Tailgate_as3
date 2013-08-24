package sharp.commands
{
	
	import org.robotlegs.mvcs.Command;
	
	import sharp.events.ThemeSettingsEvent;
	import sharp.model.Model;
	
	public class ThemeSettingsCommand extends Command
	{
		
		[Inject]
		public var appModel:Model;
		
		[Inject]
		public var event:ThemeSettingsEvent;
		
		public function ThemeSettingsCommand()
		{
			super();
		}
		
		override public function execute():void{
			appModel.themeParams = event.themeParams;
		}
	}
}