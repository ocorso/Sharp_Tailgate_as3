package sharp.events
{
	import cfm.core.events.CFM_DropdownMenuEvent;
	
	import flash.events.Event;
	
	public class SharpDropdownEvent extends CFM_DropdownMenuEvent
	{
		public static const DROPDOWN_SELECTED						:String = "dropdown menu selected";
		public static const CUSTOMIZE_DROPDOWN_ITEM_SELECTED		:String = "customize dropdown item selected";
		public static const TEAMNAME_OK_SELECTED					:String = "teamName ok seleced";
		public static const EMAIL_OK_SELECTED						:String = "email ok seleced";
		public static const OK_SELECTED								:String = "ok selected";
		public static const DROPDOWN_NAVIGATION_CLICKED				:String = "dropdownNavigationClicked";
		public static const TV_SELECTED								:String = "tv selected";
		public static const FILTER_SELECTED							:String = "filter selected";
		public static const ON_CLOSE_MENU							:String = "on close menu";
	
		
		public function SharpDropdownEvent(type:String, _menuIndex:Number, _menuValue:String, _itemIndex:Number,  _itemValue:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, _menuIndex, _menuValue, _itemIndex, _itemValue, bubbles, cancelable);
		}
	}
}