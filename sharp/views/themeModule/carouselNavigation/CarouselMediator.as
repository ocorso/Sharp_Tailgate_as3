package sharp.views.themeModule.carouselNavigation
{
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Mediator;
	
	import sharp.events.SharpDropdownEvent;
	import sharp.events.SharpNavigationEvent;
	import sharp.events.SharpPageEvent;
	import sharp.events.ThemeSettingsEvent;
	import sharp.model.Model;
	import sharp.model.vo.Vo;
	import sharp.views.appTemplate.SharpPageTemplate;
	
	public class CarouselMediator extends Mediator
	{
		
		[Inject]
		public var view:CarouselView;
		
		[Inject]
		public var _m:Model;
		
		override public function onRegister():void{
			
			view.imageUrl = _m.imageUrl;
			view.tvList	= _m.tvButtonData;	
			
			eventMap.mapListener(view, SharpPageEvent.PAGE_BUILD_COMPLETE, onComplete, null, false, 0, true);
			eventMap.mapListener(eventDispatcher, ThemeSettingsEvent.GET_ROOM, onGetRoom, null, false, 0, true);
			eventMap.mapListener(eventDispatcher, SharpDropdownEvent.TV_SELECTED, onTVDropdownSeleced, null, false, 0, true);
			
		}
		
		override public function onRemove():void{
			eventMap.unmapListener(view, SharpPageEvent.PAGE_BUILD_COMPLETE, onComplete);
			eventMap.unmapListener(eventDispatcher, ThemeSettingsEvent.GET_ROOM, onGetRoom);
			eventMap.unmapListener(eventDispatcher, SharpDropdownEvent.TV_SELECTED, onTVDropdownSeleced);
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
		private function externalSelect(_index:int):void{
			view.currentImageIndex = _index;
			view.scrollCarousel();
			
			var menuId:String = _m.currentPageData.selection.(@id=="rooms").@id;
			var itemId:String = _m.currentPageData.selection[0].navigation.button[_index].@id
			_m.ga.track(_m.currentPageId, menuId, itemId);
			
		}
		
		// =================================================
		// ================ Handlers
		// =================================================
		private function onComplete(e:SharpPageEvent):void{
			//externalSelect(Vo.FIRST_ROOM);

			Vo.themeParams.paramsIndex = 0;
			Vo.themeParams.roomIndex = Vo.FIRST_ROOM;
			
			
			dispatch(new ThemeSettingsEvent(ThemeSettingsEvent.THEME_SELECTED,Vo.themeParams));
			
			//view.selectTV(1);
			view.updateDefaultImage(_m.themeParams.tvDefaultImage);
		}
		
		private function onGetRoom(e:ThemeSettingsEvent):void{
			view.direction = _m.themeParams.roomScrollDirection;
			externalSelect(_m.themeParams.roomIndex);
			view.updateDefaultImage(_m.themeParams.tvDefaultImage);
		}
		
		private function onTVDropdownSeleced(e:SharpDropdownEvent):void{

			view.selectTV(_m.themeParams.tvSize);
			
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

		public function CarouselMediator()
		{
			super();
		}
	}
}