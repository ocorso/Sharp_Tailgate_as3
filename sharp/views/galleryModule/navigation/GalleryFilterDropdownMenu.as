package sharp.views.galleryModule.navigation
{
	import cfm.core.buttons.CFM_SimpleButton;
	import cfm.core.navigation.CFM_SimpleNavigation;
	import cfm.core.text.CFM_TextField;
	
	import net.ored.util.out.Out;
	
	import sharp.model.vo.Vo;
	import sharp.views.appMainButton.CustomizeSmallerButton;
	import sharp.views.customizeModule.customizeNavigation.CustomizeDropdownMenu;
	import sharp.views.themeModule.dropdownNavigation.navigations.DropdownListNavigation;
	
	public class GalleryFilterDropdownMenu extends CustomizeDropdownMenu
	{
		

		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		
		// =================================================
		// ================ Workers
		// =================================================
		
		// =================================================
		// ================ Handlers
		// =================================================
		
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		override protected function getButton():CFM_SimpleButton{
			return new CustomizeSmallerButton(0,id, value,labelText,30,5,true,true,"") as CFM_SimpleButton;
		}
		
		override protected function getNavigation(_buttonList:XMLList):CFM_SimpleNavigation{
			var nav:DropdownListNavigation = new DropdownListNavigation(buttonWidth + 25,_buttonList,false,false,"left");
			nav.scaleX = nav.scaleY = Vo.SMALL_PAGE_NAV_SCALE;
			return nav;
		}
		
		override protected function addListeners():void{
			super.addListeners();

			selectItemById(0, "all", true);
		}
		override public function updateSelection(_value:String):void{
			currentSelection = _value;
			button.updateLabel(_value,false);
			CustomizeSmallerButton(button).centerLabel();
		}
		// =================================================
		// ================ Constructor
		// =================================================

		public function GalleryFilterDropdownMenu(_dropdown:String, _index:Number, _id:String, _value:String, _labelText:String, _navigationList:XMLList, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			super(_dropdown, _index, _id, _value, _labelText, _navigationList, _autoInit, _autoDestroy);
		}
		
		
		
	}
}