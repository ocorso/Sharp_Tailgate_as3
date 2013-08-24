package cfm.core.events
{
	import flash.events.Event;

	public class CFM_ButtonEvent extends Event
	{
		public static const CLICKED:String = "clicked";
		public static const SELECTED:String = "selected";
		public static const DE_SELECTED:String = "deSelected";
		public static const OVER:String = "over";
		public static const OUT:String = "out";
		
		public var index					:Number;
		public var id						:String;
		public var value					:String;
		public var selected					:Boolean;
		public var label					:String;
		
		public function CFM_ButtonEvent(type:String, _index:Number, _id:String, _value:String, _label:String, _selected:Boolean, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			index 							= _index;
			id 								= _id;
			value 							= _value;
			label							= _label;
			selected						= _selected;
		}
	}
}