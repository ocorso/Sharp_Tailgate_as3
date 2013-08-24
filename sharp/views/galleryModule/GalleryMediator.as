package sharp.views.galleryModule
{
	import cfm.core.events.CFM_NavigationEvent;
	import cfm.core.events.CFM_PageEvent;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Mediator;
	
	import sharp.events.GalleryEvent;
	import sharp.events.SharpDropdownEvent;
	import sharp.events.SharpNavigationEvent;
	import sharp.events.SharpPageEvent;
	import sharp.events.SharpWindowEvent;
	import sharp.model.Model;
	import sharp.model.vo.CustomizeParams;
	import sharp.model.vo.ThemeParams;
	import sharp.model.vo.Vo;
	import sharp.views.youtubeModule.vo.YoutubeData;
	
	public class GalleryMediator extends Mediator
	{
		[Inject]
		public var view:GalleryPage;
		
		[Inject]
		public var _m:Model;
		
		
		override public function onRegister():void{
			eventMap.mapListener(eventDispatcher, GalleryEvent.GOT_IMAGES_DATA, onGotGalleryData, null, false, 0, true);
			eventMap.mapListener(view, CFM_NavigationEvent.BUTTON_CLICKED, onNavigationClicked, null, false, 0, true);
			eventMap.mapListener(view, SharpNavigationEvent.GALLERY_CLICKED, onGalleryClicked, null, false, 0, true);
			eventMap.mapListener(eventDispatcher, SharpDropdownEvent.FILTER_SELECTED, onFilterSelected, null, false, 0, true);
			eventMap.mapListener(view, Event.COMPLETE, onFilterXMLComplete, null, false, 0, true);
		}
		
		override public function onRemove():void{
			eventMap.unmapListener(eventDispatcher, GalleryEvent.GOT_IMAGES_DATA, onGotGalleryData);
			eventMap.unmapListener(view, CFM_NavigationEvent.BUTTON_CLICKED, onNavigationClicked);
			eventMap.unmapListener(view, SharpNavigationEvent.GALLERY_CLICKED, onGalleryClicked);
			eventMap.unmapListener(eventDispatcher, SharpDropdownEvent.FILTER_SELECTED, onFilterSelected);
			eventMap.unmapListener(view, Event.COMPLETE, onFilterXMLComplete);
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
		
		private function onGotGalleryData(e:GalleryEvent):void{
			
			Out.info(this, "got gallery data");
			view.removeGallery();
			view.updateGallery(_m.galleryData);
		}
		
		private function onNavigationClicked(e:CFM_NavigationEvent):void{
			
			var trackId:String = _m.currentPageData.navigation.button[e.index].@track;
			
			
			switch(e.id){
				case "go_back":
					var url:String = _m.baseUrl;
					var request:URLRequest = new URLRequest(url);
					try {
						navigateToURL(request, '_self');
					} catch (e:Error) {
						trace("Error occurred!");
					}
					_m.ga.track(_m.currentPageId, "", trackId);
					break;
				default:
					_m.ga.track("gallery", "", trackId);
					dispatch(new SharpPageEvent(SharpPageEvent.CHANGE_PAGE,e.id));
					
					break;
			}
		}
		
		private function onGalleryClicked(e:SharpNavigationEvent):void{
			dispatch(new GalleryEvent(GalleryEvent.GET_IMAGE_DETAIL_DATA,{galleryData:_m.galleryData, tid:e.id}));
			dispatch(new SharpWindowEvent(SharpWindowEvent.OPEN_WINDOW,"gallery",{galleryData:_m.galleryData, tid:e.id}));
			
			_m.ga.track(_m.currentPageId, "", "gallery_button_click");
		}
		
		
		private function onFilterSelected(e:SharpDropdownEvent):void{
			var route:String = "";

			if(_m.facebook.userId){

				if (e.itemValue == "mine" || e.itemValue == "friends")
					route = _m.baseUrl + _m.appData.environment.routes.gallery.filtered + e.itemValue + "/"+_m.facebook.userId + "/"+_m.facebook.authToken;
				else	
					route = _m.baseUrl + _m.appData.environment.routes.gallery.filtered;
				
			}

			view.getFilterXML(route);
			
			view.removeGallery();

			_m.ga.track(_m.currentPageId, "", "filter_" + e.itemValue);
		}
		
		private function onFilterXMLComplete(e:Event):void{
			_m.galleryPageNumber = int(view.totalPage);
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
		public function GalleryMediator()
		{
			super();
		}

	}
}