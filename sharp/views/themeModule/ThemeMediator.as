package sharp.views.themeModule
{
	import cfm.core.events.CFM_NavigationEvent;
	import cfm.core.events.CFM_PageEvent;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Mediator;
	
	import sharp.events.CustomizeSettingsEvent;
	import sharp.events.SharpAppEvent;
	import sharp.events.SharpDropdownEvent;
	import sharp.events.SharpPageEvent;
	import sharp.events.ThemeSettingsEvent;
	import sharp.model.Model;
	import sharp.model.vo.Vo;
	
	public class ThemeMediator extends Mediator
	{
		
		[Inject]
		public var view:ThemePage;
		
		[Inject]
		public var _m:Model;
		
		override public function onRegister():void{
			eventMap.mapListener(view, SharpPageEvent.PAGE_BUILD_COMPLETE, buildComplete, null, false, 0, true);
			eventMap.mapListener(view, CFM_NavigationEvent.BUTTON_CLICKED, onNavigationClicked, null, false, 0, true);
			eventMap.mapListener(eventDispatcher, SharpDropdownEvent.DROPDOWN_SELECTED, onDropdownOpened, null, false, 0, true);
		}
		
		override public function onRemove():void{
			eventMap.unmapListener(view, SharpPageEvent.PAGE_BUILD_COMPLETE, buildComplete);
			eventMap.unmapListener(view, CFM_NavigationEvent.BUTTON_CLICKED, onNavigationClicked);
			eventMap.unmapListener(eventDispatcher, SharpDropdownEvent.DROPDOWN_SELECTED, onDropdownOpened);
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
		private function buildComplete(e:SharpPageEvent):void{
			view.positionAssets();
		}
		
		private function onNavigationClicked(e:CFM_NavigationEvent):void{
			
			var trackId:String = _m.currentPageData.navigation.button[e.index].@track;
			_m.ga.track(_m.currentPageId, "", trackId);
			
			switch(e.id){
				case "go_home":
					var url:String = _m.baseUrl;
					var request:URLRequest = new URLRequest(url);
					try {
						navigateToURL(request, '_self');
					} catch (e:Error) {
						trace("Error occurred!");
					}
					break;

				default:
					
					dispatch(new SharpPageEvent(SharpPageEvent.CHANGE_PAGE,e.id));
					break;
			}
			
			
			Vo.customizeParams.pageStatus = e.value;
			dispatch(new CustomizeSettingsEvent(CustomizeSettingsEvent.CUSTOMIZE_SELECTED,Vo.customizeParams));
		}
		
		private function onDropdownOpened(e:SharpDropdownEvent):void{
			view.checkDropdownOpen(e.menuIndex);
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
		public function ThemeMediator()
		{
			super();
		}

	}
}