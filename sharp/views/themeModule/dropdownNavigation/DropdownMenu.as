package sharp.views.themeModule.dropdownNavigation
{
	import cfm.core.buttons.CFM_SimpleButton;
	import cfm.core.events.CFM_NavigationEvent;
	import cfm.core.navigation.CFM_SimpleNavigation;
	
	import com.greensock.TweenMax;
	
	import net.ored.util.out.Out;
	
	import sharp.model.vo.Vo;
	import sharp.views.appMainButton.AppMainButton;
	import sharp.views.appTemplate.SharpDropdownMenuTemplate;
	import sharp.views.themeModule.dropdownNavigation.navigations.DropdownListNavigation;
	import sharp.views.themeModule.dropdownNavigation.navigations.DropdownThumbNavigation;
	
	public class DropdownMenu extends SharpDropdownMenuTemplate
	{
		private var dropdownType				:String;
		private var colorValue					:uint;
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================

		override public function buildNavigations():void{
			super.buildNavigations();

			itemHolderMask.redraw(itemHolder.x + itemHolder.width+20, itemHolder.height + 20,0,0);
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
			TweenMax.to(this, .3, {dropShadowFilter:{blurX:4, blurY:4, alpha:.2, distance:2, color:0x000000, quality:3}});
		}
		
		public function hideMenu():void{
			TweenMax.to(this, .3, {dropShadowFilter:{remove:true}});
		}
		
		// =================================================
		// ================ Getters / Setters
		// =================================================

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
			var padding_h:Number;
			if(id=="tv_sizes")
				padding_h = 28;
			else
				padding_h = 20;
			
			return new AppMainButton(index,id, value,labelText,padding_h,7,true,true,"") as CFM_SimpleButton;
		}
		override protected function getNavigation(_buttonList:XMLList):CFM_SimpleNavigation{
			var nav:CFM_SimpleNavigation;
			
			if(dropdownType == "list")
				nav = new DropdownListNavigation(buttonWidth,_buttonList,false,true,"left") as CFM_SimpleNavigation;
			else if(dropdownType == "thumb")
				nav = new DropdownThumbNavigation(buttonWidth,_buttonList,false,true,null,true,true,250) as CFM_SimpleNavigation;
			
			return nav;
		}
		override protected function buildComplete():void{
			super.buildComplete();
			navigation.setProperties({x:-.5});
			itemHolderMask.setProperties({x:-.5});
			
			
		}
		override public function updateSelection(_value:String):void{
			currentSelection = _value;
			if(dropdownType == "list") 
			    button.updateLabel(_value,false);
		}
		
		override protected function addListeners():void{
			super.addListeners();
			
			if(dropdownType == "list") {
				selectItemById(0, navigationList.button[Vo.DEFAULT_TV].@id, true);
			}	else {
				if(index == 2){
					selectItemById(0, navigationList.button[4].@id, true);
				}else if(index == 3){
					selectItemById(0, navigationList.button[1].@id, true);
				}
				
			}
				
		}
		// =================================================
		// ================ Constructor
		// =================================================

		public function DropdownMenu(_dropdownType:String, _index:Number, _id:String, _value:String, _labelText:String, _navigationList:XMLList, _autoInit:Boolean=true, _autoDestroy:Boolean=true)
		{
			super(_index, _id, _value, _labelText, _navigationList, _autoInit, _autoDestroy);
			
			ITEM_HOLDER_MARGIN = 0;
			dropdownType = _dropdownType;
			if(currentSelection) currentSelection = null;

		}
	}
}