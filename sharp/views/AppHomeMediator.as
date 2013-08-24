package sharp.views
{
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Mediator;
	
	import sharp.events.CustomizeSettingsEvent;
	import sharp.events.GalleryEvent;
	import sharp.events.SharpAppEvent;
	import sharp.events.SharpPageEvent;
	import sharp.events.SharpWindowEvent;
	import sharp.events.ThemeSettingsEvent;
	import sharp.model.Model;
	import sharp.model.vo.CustomizeParams;
	import sharp.model.vo.SubmitGalleryItemParams;
	import sharp.model.vo.ThemeParams;
	import sharp.model.vo.Vo;
	import sharp.views.youtubeModule.event.YoutubeEvent;
	import sharp.views.youtubeModule.vo.YoutubeData;
	
	public class AppHomeMediator extends Mediator
	{
		
		[Inject]
		public var view:AppHome;
		
		[Inject]
		public var _m:Model;

		
		override public function onRegister():void
		{	
			eventMap.mapListener(eventDispatcher, SharpAppEvent.APP_DATA_RECEIVED, init, null, false, 0, true);
			eventMap.mapListener(eventDispatcher, SharpPageEvent.CHANGE_PAGE, onChangePage, null, false, 0, true);

			eventMap.mapListener(eventDispatcher, SharpWindowEvent.OPEN_WINDOW, onOpenWindow, null, false, 0, true);
			eventMap.mapListener(view, SharpWindowEvent.CLOSE_WINDOW, onInnerCloseWindow, null, true, 0, true);
			eventMap.mapListener(eventDispatcher, SharpWindowEvent.CLOSE_WINDOW, onOuterCloseWindow, null, false, 0, true);
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
		private function resetApp():void{
			
			Out.status(this, "APP RESET"); 
			
			Vo.themeParams = new ThemeParams();
			dispatch(new ThemeSettingsEvent(ThemeSettingsEvent.THEME_SELECTED, Vo.themeParams));
			Vo.customizeParams	= new CustomizeParams();
			dispatch(new CustomizeSettingsEvent(CustomizeSettingsEvent.CUSTOMIZE_SELECTED, Vo.customizeParams));
			
			_m.submitImageParams = new SubmitGalleryItemParams();

			Vo.youtube	= new YoutubeData();
			dispatch(new YoutubeEvent(YoutubeEvent.SAVE_VIDEO_ID, Vo.youtube));
			
			_m.hasEmail = false;

		}
		
		// =================================================
		// ================ Handlers
		// =================================================
		private function init(e:SharpAppEvent):void
		{
			Out.status(this, "init");
			view.buildLogos();
			view.buildContainers();
			
			Out.info(this, _m.tid);

			switch (_m.tid){
				case "1":
				case 1: Out.debug(this, "its supposed to go here.");
					dispatch(new SharpPageEvent(SharpPageEvent.CHANGE_PAGE, "gallery"));
					break;
				case "0":
					dispatch(new SharpPageEvent(SharpPageEvent.CHANGE_PAGE, Vo.FIRST_PAGE));
					//dispatch(new SharpPageEvent(SharpPageEvent.CHANGE_PAGE, "gallery"));
					break;
				default:
					dispatch(new SharpPageEvent(SharpPageEvent.CHANGE_PAGE, "gallery"));
					dispatch(new GalleryEvent(GalleryEvent.GET_IMAGE_DETAIL_DATA,{baseUrl:_m.baseUrl, tid:_m.tid}));
					dispatch(new SharpWindowEvent(SharpWindowEvent.OPEN_WINDOW,"gallery",{galleryData:_m.galleryData, tid:_m.tid}));
					break;
			}
		}
		
		private function onChangePage(e:SharpPageEvent):void{
			if(e.pageId == "theme") resetApp();
			view.changePage(_m.currentPageData);
		}

		private function onOpenWindow(e:SharpWindowEvent):void{
			var p:Object = e.body ? e.body : new Object();
			
			if(_m.submitImageParams){
				p["tid"] 			= _m.tid;
				p["tailgateName"] 	= _m.submitImageParams.title;
				Out.info(this, _m.tid, _m.submitImageParams.title);
			}
			
			view.changeWindow(_m.currentWindowData, p);
		}
		
		private function onInnerCloseWindow(e:SharpWindowEvent):void{
			Out.info(this, "close window");
			view.currentWindow.closeWindow();
			_m.ga.track(_m.currentPageId, "", _m.currentWindowId + "_close");
		}
		
		private function onOuterCloseWindow(e:SharpWindowEvent):void{
			Out.info(this, "close window");
			view.currentWindow.closeWindow();
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
		public function AppHomeMediator()
		{
			super();
		}

	}
}