package sharp.views.galleryModule.navigation
{
	import cfm.core.events.CFM_DropdownMenuEvent;
	
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Mediator;
	
	import sharp.events.SharpDropdownEvent;
	import sharp.model.Model;
	import sharp.views.appMainButton.CustomizeSmallerButton;
	
	public class GalleryFilterDropdownMediator extends Mediator
	{
		
		[Inject]
		public var view:GalleryFilterDropdownMenu;
		
		[Inject]
		public var _m:Model;
		
		
		override public function onRegister():void{

			eventMap.mapListener(view, CFM_DropdownMenuEvent.ITEM_SELECTED, onItemSelected, null, false, 0, true);
			eventMap.mapListener(view, CFM_DropdownMenuEvent.OPEN_MENU, onOpenMenu, null, false, 0, true);
			eventMap.mapListener(view, CFM_DropdownMenuEvent.CLOSE_MENU, onCloseMenu, null, false, 0, true);

		}
		
		override public function onRemove():void{
			eventMap.unmapListener(view, CFM_DropdownMenuEvent.ITEM_SELECTED, onItemSelected);
			eventMap.unmapListener(view, CFM_DropdownMenuEvent.OPEN_MENU, onOpenMenu);
			eventMap.unmapListener(view, CFM_DropdownMenuEvent.CLOSE_MENU, onCloseMenu);
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
		private function onItemSelected(e:CFM_DropdownMenuEvent):void{
			view.closeMenu();
			dispatch(new SharpDropdownEvent(SharpDropdownEvent.FILTER_SELECTED, e.menuIndex, e.menuValue, e.itemIndex, e.itemValue));
		}
		
		private function onOpenMenu(e:CFM_DropdownMenuEvent):void{
			view.showMenu();
			(view.button as CustomizeSmallerButton).dropdownOpen();

		}
		
		private function onCloseMenu(e:CFM_DropdownMenuEvent):void{
			view.hideMenu();
			(view.button as CustomizeSmallerButton).dropdownClose();
		
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

		public function GalleryFilterDropdownMediator()
		{
			super();
		}
	}
}