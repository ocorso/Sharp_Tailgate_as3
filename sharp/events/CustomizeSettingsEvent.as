package sharp.events
{
	import flash.events.Event;
	
	import sharp.model.vo.CustomizeParams;
	
	public class CustomizeSettingsEvent extends Event
	{
		
		public static const CUSTOMIZE_SELECTED							:String = "customize selected";	
		
		private var _customizeParams									:CustomizeParams;
		
		public function CustomizeSettingsEvent(type:String, customizeParams:CustomizeParams, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_customizeParams = customizeParams;
		}
		
		
		
		override public function clone():Event{
			return new CustomizeSettingsEvent(type, customizeParams);
		}
		
		
		public function get customizeParams():CustomizeParams{
			return _customizeParams;
		}
	}
}