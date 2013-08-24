package sharp.commands
{
	import org.robotlegs.mvcs.Command;
	
	import sharp.events.CustomizeSettingsEvent;
	import sharp.model.Model;
	import sharp.model.vo.CustomizeParams;
	
	public class CustomizeSettingsCommand extends Command
	{
		[Inject]
		public var event:CustomizeSettingsEvent;
		
		[Inject]
		public var _m:Model;
		
		public function CustomizeSettingsCommand()
		{
			super();
		}
		
		override public function execute():void{

			_m.customizeParams = event.customizeParams;
			
			//if(_m.customizeParams.roomBitmap) _m.setSubmitParams();
			//oc: might not need this.
			//if(_m.customizeParams.roomBitmap) _m.setSubmitParams();
		}
	}
}