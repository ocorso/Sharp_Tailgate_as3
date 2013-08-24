package sharp.views.themeModule.carouselNavigation
{
	import cfm.core.events.CFM_NavigationEvent;
	
	import com.greensock.TweenMax;
	
	import org.robotlegs.mvcs.Mediator;
	
	import sharp.events.ThemeSettingsEvent;
	import sharp.events.SharpNavigationEvent;
	import sharp.model.Model;
	import sharp.model.vo.ThemeParams;
	import sharp.model.vo.Vo;
	
	public class ArrowMediator extends Mediator
	{
		[Inject]
		public var view:ArrowNavigation;
		
		[Inject]
		public var _m:Model;
		
		override public function onRegister():void{
			eventMap.mapListener(view, SharpNavigationEvent.NAVIGATION_BUILD_COMPLETE, onComplete, null, false, 0, true);
			eventMap.mapListener(view, CFM_NavigationEvent.BUTTON_CLICKED, onNavigationClicked, null, false, 0, true);
			eventMap.mapListener(eventDispatcher, ThemeSettingsEvent.GET_ROOM, onCarouselClicked, null, false, 0, true);
		}
		
		override public function onRemove():void{
			eventMap.unmapListener(view, SharpNavigationEvent.NAVIGATION_BUILD_COMPLETE, onComplete);
			eventMap.unmapListener(view, CFM_NavigationEvent.BUTTON_CLICKED, onNavigationClicked);
			eventMap.unmapListener(eventDispatcher, ThemeSettingsEvent.GET_ROOM, onCarouselClicked);
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
		
		private function delayingButtonEnable():void{
			view.disableButtons();
			TweenMax.delayedCall(Vo.CAROUSEL_TRANSIT_TIME, view.enableButtons);
		}
		
		// =================================================
		// ================ Handlers
		// =================================================
		private function onComplete(e:SharpNavigationEvent):void{
			view.positionAssets();
			view._roomIndex = Vo.FIRST_ROOM;
		}
		
		private function onNavigationClicked(e:CFM_NavigationEvent):void{
			
			TweenMax.killDelayedCallsTo(view.enableButtons);
			delayingButtonEnable();

			switch(e.id){
				case "right":
					view._roomIndex++;
					if(view._roomIndex > _m.themeParams.roomLength-1) view._roomIndex = 0;
					break;
				case "left":
					view._roomIndex--;
					if(view._roomIndex < 0) view._roomIndex = _m.themeParams.roomLength-1;
					break;
			}
			Vo.themeParams.paramsIndex = 0;
			Vo.themeParams.roomIndex = view._roomIndex;
			Vo.themeParams.roomScrollDirection = e.id;
			Vo.themeParams.tvDefaultImage = _m.roomImageButtonData[view._roomIndex].defaultImage;
			
			dispatch(new ThemeSettingsEvent(ThemeSettingsEvent.THEME_SELECTED,Vo.themeParams));
		}
		
		private function onCarouselClicked(e:ThemeSettingsEvent):void{
			view._roomIndex = _m.themeParams.roomIndex;
			
			delayingButtonEnable();
			view.updateLabel(_m.themeParams.roomName);
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
		public function ArrowMediator()
		{
			super();
		}

	}
}