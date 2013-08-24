package cfm.core.events
{
	import flash.events.Event;

	public class CFM_NavigationEvent extends Event
	{
		public static const BUTTON_CLICKED:String = "buttonClicked";
		public static const BUTTON_SELECTED:String = "buttonSelected";
		public static const BUTTON_DESELECTED:String = "buttonDeSelected";
		public static const BUTTON_OVER:String = "buttonOver";
		public static const BUTTON_OUT:String = "buttonOut";
		
		public var index:Number;
		public var id:String;
		public var value:String;
		
		public function CFM_NavigationEvent(type:String, _index:Number, _id:String, _value:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			index = _index;
			id = _id;
			value = _value;
		}
	}
}