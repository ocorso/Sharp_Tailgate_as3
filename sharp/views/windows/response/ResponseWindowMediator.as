package sharp.views.windows.response
{
	import cfm.core.events.CFM_NavigationEvent;
	import cfm.core.events.CFM_PageEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	import sharp.events.SharpNavigationEvent;
	import sharp.model.Model;
	
	public class ResponseWindowMediator extends Mediator
	{
		
		[Inject]
		public var view:ResponseWindow;
		
		[Inject]
		public var _m:Model;
		
		override public function onRegister():void{
			eventMap.mapListener(view, CFM_NavigationEvent.BUTTON_CLICKED, onNavigationClicked, null, false, 0, true);
		}
		override public function onRemove():void{
			eventMap.unmapListener(view, CFM_NavigationEvent.BUTTON_CLICKED, onNavigationClicked);
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
		private function onNavigationClicked(e:CFM_NavigationEvent):void{
			dispatch(new SharpNavigationEvent(SharpNavigationEvent.YES_CLICKED,e.index,e.id));
			
			_m.ga.track(_m.currentPageId, "", _m.currentWindowId + "_" + e.id);
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

		public function ResponseWindowMediator()
		{
			super();
		}
	}
}