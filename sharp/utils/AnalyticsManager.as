package sharp.utils
{
	
	import flash.external.ExternalInterface;
	
	import net.ored.util.out.Out;
	
	import sharp.model.Model;
	

	public class AnalyticsManager
	{

		private var _m											:Model;

		
		public function track($pageId:String, $dropdownId:String, $buttonId:String):void{
			
			var $category:String = $pageId;
			var $action:String;
			
			($dropdownId=="") ? $action = $buttonId : $action = $dropdownId + "_" + $buttonId;

			//Out.status(this, "category::    " + $category + "      action::    " + $action);

			if(ExternalInterface.available){
				ExternalInterface.call("trackingController.track",$category, $action);
			}
		}
		
		public function trackSubPageNav(_index:int, _currentData:XMLList):void{
			var trackId:String = _currentData.navigation.button[_index].@track;
			track(_currentData.@id, "", trackId);
		}
		
		public function trackDropdown(_cate:String, _menuId:String):void{
			track(_cate, "", _menuId);
		}
		
		public function trackItemDropdown(_menuIndex:int, _itemIndex:int, _currentData:XMLList):void{
			var menuId:String = _currentData.selection[_menuIndex].@id;
			var trackId:String = _currentData.selection[_menuIndex].navigation.button[_itemIndex].@id;
			track(_currentData.@id, menuId, trackId);
		}
		
		public function trackInputOkDropdown(_menuIndex:int, _currentData:XMLList):void{
			var menuId:String = _currentData.selection[_menuIndex].@id;
			track(_currentData.@id, menuId, "ok");
		}
		
		public function trackFacebookWindow(_cate:String, _action:String):void{
			track(_cate, "", "facebook_window_" + _action);
		}
		
		public function trackShareWindow(_cate:String, _windowId:String, _shareId:String):void{
			track(_cate, "", _windowId + "_" + _shareId + "_share");
		}
		
		public function AnalyticsManager()
		{
		}
	}
}