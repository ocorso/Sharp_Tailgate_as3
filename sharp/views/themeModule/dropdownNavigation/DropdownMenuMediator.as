package sharp.views.themeModule.dropdownNavigation
{
	import cfm.core.events.CFM_DropdownMenuEvent;
	import cfm.core.ui.CFM_DropdownMenu;
	
	import flash.filters.DropShadowFilter;
	
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Mediator;
	
	import sharp.events.SharpDropdownEvent;
	import sharp.events.SharpPageEvent;
	import sharp.events.ThemeSettingsEvent;
	import sharp.model.Model;
	import sharp.model.vo.ThemeParams;
	import sharp.model.vo.Vo;
	import sharp.views.appMainButton.AppMainButton;
	
	public class DropdownMenuMediator extends Mediator
	{
		[Inject]
		public var view:DropdownMenu;
		
		[Inject]
		public var _m:Model;


		override public function onRegister():void{
			eventMap.mapListener(view, CFM_DropdownMenuEvent.OPEN_MENU, onOpenMenu, null, false, 0, true);
			eventMap.mapListener(view, CFM_DropdownMenuEvent.CLOSE_MENU, onCloseMenu, null, false, 0, true);
			eventMap.mapListener(view, CFM_DropdownMenuEvent.ITEM_SELECTED, onItemSelected, null, false, 0, true);
		}
		
		override public function onRemove():void{
			eventMap.unmapListener(view, CFM_DropdownMenuEvent.OPEN_MENU, onOpenMenu);
			eventMap.unmapListener(view, CFM_DropdownMenuEvent.CLOSE_MENU, onCloseMenu);
			eventMap.unmapListener(view, CFM_DropdownMenuEvent.ITEM_SELECTED, onItemSelected);
		}

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
		private function onOpenMenu(e:CFM_DropdownMenuEvent):void{
			view.showMenu();
			(view.button as AppMainButton).dropdownOpen();
			
			dispatch(new SharpDropdownEvent(SharpDropdownEvent.DROPDOWN_SELECTED, e.menuIndex, e.menuValue, e.itemIndex, e.itemValue));
			
			_m.ga.trackDropdown(_m.currentPageId, e.menuValue);
			
		}
		
		private function onCloseMenu(e:CFM_DropdownMenuEvent):void{
			view.hideMenu();
			(view.button as AppMainButton).dropdownClose();

		}
		
		private function onItemSelected(e:CFM_DropdownMenuEvent):void{
			
			Vo.themeParams.paramsIndex = e.menuIndex;

			switch(e.menuIndex){
				case 2:
					Vo.themeParams.primaryColorIndex = e.itemIndex;
					Vo.themeParams.primaryColor = uint(e.itemValue);
					(view.button as AppMainButton).updateColor(uint(e.itemValue));
					itemId = _m.currentPageData.colors.navigation.button[e.itemIndex].@id;
					break;
				case 3:
					Vo.themeParams.secondaryColorIndex = e.itemIndex;
					Vo.themeParams.secondaryColor = uint(e.itemValue);
					(view.button as AppMainButton).updateColor(uint(e.itemValue));
					itemId = _m.currentPageData.colors.navigation.button[e.itemIndex].@id;
					break;
				case 1:
					Vo.themeParams.tvIndex = e.itemIndex;
					Vo.themeParams.tvSize = _m.tvButtonData[e.itemIndex].@scale;
					dispatch(new SharpDropdownEvent(SharpDropdownEvent.TV_SELECTED,e.menuIndex,e.menuValue, e.itemIndex, e.itemValue)); 
					itemId = _m.currentPageData.selection[e.menuIndex].navigation.button[e.itemIndex].@id;
					break;
			}
			dispatch(new ThemeSettingsEvent(ThemeSettingsEvent.THEME_SELECTED, Vo.themeParams)); 
			view.closeMenu();
			view.hideMenu();
			(view.button as AppMainButton).centerLabel();
			
			var menuId:String = _m.currentPageData.selection[e.menuIndex].@id;
			var itemId:String;
			_m.ga.track(_m.currentPageId, menuId, itemId);

		}
		
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
		
		// =================================================
		// ================ Constructor
		// =================================================
		public function DropdownMenuMediator()
		{
			super();
		}

	}
}