package sharp.events
{
	import flash.events.Event;
	
	import sharp.model.vo.ThemeParams;
	
	public class ThemeSettingsEvent extends Event
	{
		
		public static const CAROUSEL_ARROW_CLICKED					:String = "arrow clicked";
		public static const CAROUSEL_BUTTON_SELECTED				:String = "button selected";
		
		public static const THEME_SELECTED							:String = "theme selected";
		public static const GET_ROOM								:String = "get room";
		
		
		private var _themeParams									:ThemeParams;
		
		
		public function ThemeSettingsEvent(type:String, themeParams:ThemeParams, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_themeParams = themeParams;
		}
		
		override public function clone():Event{
			return new ThemeSettingsEvent(type, themeParams);
		}
		

		public function get themeParams():ThemeParams{
			return _themeParams;
		}
	}
}