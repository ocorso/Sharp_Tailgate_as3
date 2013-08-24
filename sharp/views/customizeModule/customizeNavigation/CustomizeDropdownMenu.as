package sharp.views.customizeModule.customizeNavigation
{
	import cfm.core.buttons.CFM_SimpleButton;
	import cfm.core.navigation.CFM_SimpleNavigation;
	
	import com.greensock.TweenMax;
	
	import sharp.events.SharpDropdownEvent;
	import sharp.views.appMainButton.CustomizeSmallerButton;
	import sharp.views.appTemplate.SharpDropdownMenuTemplate;
	import sharp.views.customizeModule.customizeNavigation.navigations.CustomizeInputNavigation;
	import sharp.views.customizeModule.customizeNavigation.navigations.CustomizeThumbNavigation;
	
	public class CustomizeDropdownMenu extends SharpDropdownMenuTemplate
	{
		private var dropdownType				:String;
		private var navId						:String;
		
		private var _imageUrl					:String;
		
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================

		override public function buildNavigations():void{
			super.buildNavigations();
			
			itemHolderMask.redraw(itemHolder.x + itemHolder.width+20, itemHolder.height + 40,0,0);
		}

		// =================================================
		// ================ Workers
		// =================================================
		
		// =================================================
		// ================ Handlers
		// =================================================
		
		// =================================================
		// ================ Animation
		// =================================================
		public function showMenu():void{
			TweenMax.to(this, .3, {dropShadowFilter:{blurX:4, blurY:4, alpha:.3, distance:2, color:0x000000, quality:3}});
		}
		
		public function hideMenu():void{
			TweenMax.to(this, .3, {dropShadowFilter:{remove:true}});
		}
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		public function get imageUrl():String
		{
			return _imageUrl;
		}
		
		public function set imageUrl(value:String):void
		{
			_imageUrl = value;
		}
		
		public function get menuIndex():int{
			return index;
		}
	
		// =================================================
		// ================ Interfaced
		// =================================================
		
		// =================================================
		// ================ Core Handler
		// =================================================

		// =================================================
		// ================ Overrides
		// =================================================
		override protected function getButton():CFM_SimpleButton{
			return new CustomizeSmallerButton(0,id, value,labelText,8,5,true,true,"") as CFM_SimpleButton;
		}
		override protected function getNavigation(_buttonList:XMLList):CFM_SimpleNavigation{
			var nav:CFM_SimpleNavigation;
			
			switch(dropdownType){
				case "input":
					nav = new CustomizeInputNavigation(buttonWidth,navigationList,false,false,"left") as CFM_SimpleNavigation;
					break;
				case "thumb":
					nav = new CustomizeThumbNavigation(imageUrl, buttonWidth,navId,_buttonList,true,true,null,false,false,300) as CFM_SimpleNavigation;
					break;
			}

			return nav;
		}
		
		override protected function buildComplete():void{
			super.buildComplete();
			navigation.setProperties({x:-.5, y:-1});
			
			switch(dropdownType){
				case "input":
				case "thumb":
				case "list":
					itemHolderMask.setProperties({x:-.5, y:-1});
					break;
			}
		}
		
		override public function updateSelection(_value:String):void{
			currentSelection = _value;
		}
		
		override public function closeMenu(_dispatch:Boolean = true):void{
			super.closeMenu(_dispatch);
			if(navigation is CustomizeInputNavigation && _dispatch) {
				var id:String = CustomizeInputNavigation(navigation).id;
				var inputValue:String = CustomizeInputNavigation(navigation).inputValue;
				dispatchEvent(new SharpDropdownEvent(SharpDropdownEvent.ON_CLOSE_MENU, index, id, 0, inputValue));
			}
		}
		

		// =================================================
		// ================ Constructor
		// =================================================

		public function CustomizeDropdownMenu(_dropdown:String, _index:Number, _id:String, _value:String, _labelText:String, _navigationList:XMLList, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			super(_index, _id, _value, _labelText, _navigationList, _autoInit, _autoDestroy);
			dropdownType = _dropdown;
			navId = _id;
		}
	}
}