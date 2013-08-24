package sharp.views.galleryModule.navigation
{
	import cfm.core.events.CFM_NavigationEvent;
	
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Mediator;
	
	import sharp.events.GalleryEvent;
	import sharp.model.Model;
	
	public class PaginationMediator extends Mediator
	{
		[Inject]
		public var view						:PaginationNavigation;
		
		[Inject]
		public var _m						:Model;
		
		
		override public function onRegister():void{
			
			view.totalPageNumber = _m.galleryPageNumber;
			
			eventMap.mapListener(view, CFM_NavigationEvent.BUTTON_CLICKED, onPageClicked, null, false, 0, true);

		}
		
		override public function onRemove():void{
			eventMap.unmapListener(view, CFM_NavigationEvent.BUTTON_CLICKED, onPageClicked);
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
		private function onPageClicked(e:CFM_NavigationEvent):void{
			
			Out.info(this, "chnage page");
			
			switch(e.id){
				case "prev":
					view.currentPageNumber--;
					if(view.currentPageNumber <= 0) view.currentPageNumber = 0;
					break;
				case "next":
					Out.info(this, view.currentPageNumber);
					view.currentPageNumber++;
					if(view.currentPageNumber >= _m.galleryPageNumber-1) view.currentPageNumber = _m.galleryPageNumber-1;
					break;
			}

			view.update(view.currentPageNumber);
			
			var galleryDetailRoute:String = _m.appData.environment[0].routes[0].gallery.page + view.currentPageNumber;
			
			dispatch(new GalleryEvent(GalleryEvent.GET_IMAGES_DATA, {route:galleryDetailRoute}));
			
			_m.ga.track(_m.currentPageId,"","page_"+ String(view.currentPageNumber+1));
			
			//dispatch(new GalleryEvent(GalleryEvent.CHANGE_GALLERY_PAGE, {currentGalleryPage:view.currentPageNumber}));
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

		public function PaginationMediator()
		{
			super();
		}
	}
}