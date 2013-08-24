package
{
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.mvcs.Context;
	
	import sharp.commands.ChangePageCommand;
	import sharp.commands.CustomizeSettingsCommand;
	import sharp.commands.GalleryCommand;
	import sharp.commands.StartUpCommand;
	import sharp.commands.SubmitGalleryItemCommand;
	import sharp.commands.ThemeSettingsCommand;
	import sharp.commands.TwitterCommand;
	import sharp.commands.WindowCommand;
	import sharp.events.CustomizeSettingsEvent;
	import sharp.events.GalleryEvent;
	import sharp.events.SharpAppEvent;
	import sharp.events.SharpPageEvent;
	import sharp.events.SharpWindowEvent;
	import sharp.events.SubmitGalleryItemEvent;
	import sharp.events.ThemeSettingsEvent;
	import sharp.events.TwitterEvent;
	import sharp.interfaces.IService;
	import sharp.model.Model;
	import sharp.services.AppService;
	import sharp.services.ExportBitmapService;
	import sharp.services.GalleryService;
	import sharp.services.TwitterService;
	import sharp.views.AppHome;
	import sharp.views.AppHomeMediator;
	import sharp.views.appTemplate.SharpNavigationTemplate;
	import sharp.views.customizeModule.CustomizeMediator;
	import sharp.views.customizeModule.CustomizePage;
	import sharp.views.customizeModule.customizeNavigation.CustomizeDropdownMediator;
	import sharp.views.customizeModule.customizeNavigation.CustomizeDropdownMenu;
	import sharp.views.customizeModule.customizeNavigation.navigations.CustomizeInputMediator;
	import sharp.views.customizeModule.customizeNavigation.navigations.CustomizeInputNavigation;
	import sharp.views.customizeModule.customizeNavigation.navigations.CustomizeThumbMediator;
	import sharp.views.customizeModule.customizeNavigation.navigations.CustomizeThumbNavigation;
	import sharp.views.facebookModule.command.FacebookActionsCommand;
	import sharp.views.facebookModule.command.FacebookGetDataCommand;
	import sharp.views.facebookModule.event.FacebookSessionEvent;
	import sharp.views.facebookModule.service.FacebookService;
	import sharp.views.galleryModule.GalleryMediator;
	import sharp.views.galleryModule.GalleryPage;
	import sharp.views.galleryModule.navigation.GalleryFilterDropdownMediator;
	import sharp.views.galleryModule.navigation.GalleryFilterDropdownMenu;
	import sharp.views.galleryModule.navigation.PaginationMediator;
	import sharp.views.galleryModule.navigation.PaginationNavigation;
	import sharp.views.themeModule.ThemeMediator;
	import sharp.views.themeModule.ThemePage;
	import sharp.views.themeModule.carouselNavigation.ArrowMediator;
	import sharp.views.themeModule.carouselNavigation.ArrowNavigation;
	import sharp.views.themeModule.carouselNavigation.CarouselMediator;
	import sharp.views.themeModule.carouselNavigation.CarouselView;
	import sharp.views.themeModule.dropdownNavigation.DropdownMenu;
	import sharp.views.themeModule.dropdownNavigation.DropdownMenuMediator;
	import sharp.views.windows.email.EmailWindow;
	import sharp.views.windows.email.EmailWindowMediator;
	import sharp.views.windows.facebookAlbum.FacebookAlbumWindow;
	import sharp.views.windows.facebookAlbum.FacebookAlbumWindowMediator;
	import sharp.views.windows.facebookAlbum.navigations.FacebookSelectedImageNavigation;
	import sharp.views.windows.facebookAlbum.navigations.FacebookSelectedImageNavigationMediator;
	import sharp.views.windows.gallery.GalleryWindow;
	import sharp.views.windows.gallery.GalleryWindowMediator;
	import sharp.views.windows.response.ResponseWindow;
	import sharp.views.windows.response.ResponseWindowMediator;
	import sharp.views.windows.share.ShareWindow;
	import sharp.views.windows.share.ShareWindowMediator;
	import sharp.views.youtubeModule.YouTubePlayer;
	import sharp.views.youtubeModule.YoutubePlayerMediator;
	import sharp.views.youtubeModule.command.YoutubeCommand;
	import sharp.views.youtubeModule.event.YoutubeEvent;
	import sharp.views.youtubeModule.service.YouTubeService;
	
	public class SharpContext extends Context
	{
		private var appContainer				:AppHome;
		
		public function SharpContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		
		override public function startup():void {
			injector.mapSingleton(AppService);
			injector.mapSingleton(FacebookService);
			injector.mapSingleton(YouTubeService);
			injector.mapSingleton(ExportBitmapService);
			injector.mapSingleton(GalleryService);
			injector.mapSingleton(Model);
			injector.mapSingleton(TwitterService);

			injector.mapSingletonOf(IService, AppService);
			
			commandMap.mapEvent(SharpAppEvent.APP_STARTUP_COMPLETE, StartUpCommand, SharpAppEvent);
			commandMap.mapEvent(SharpPageEvent.CHANGE_PAGE, ChangePageCommand, SharpPageEvent);
			commandMap.mapEvent(SharpWindowEvent.OPEN_WINDOW, WindowCommand, SharpWindowEvent);
			commandMap.mapEvent(SharpWindowEvent.CLOSE_WINDOW, WindowCommand, SharpWindowEvent);
			
			commandMap.mapEvent(SubmitGalleryItemEvent.SAVE_IMAGE_TO_GALLERY, SubmitGalleryItemCommand, SubmitGalleryItemEvent);
			commandMap.mapEvent(SubmitGalleryItemEvent.SAVE_IMAGE_COMPLETE, SubmitGalleryItemCommand, SubmitGalleryItemEvent);
			
			commandMap.mapEvent(TwitterEvent.TWEET, TwitterCommand, TwitterEvent);
			
			commandMap.mapEvent(FacebookSessionEvent.ALL_DATA_COMPLETE, FacebookGetDataCommand, FacebookSessionEvent);
			commandMap.mapEvent(FacebookSessionEvent.POST_TO_WALL, FacebookActionsCommand, FacebookSessionEvent);
			commandMap.mapEvent(FacebookSessionEvent.POST_TO_WALL_SUCCESS, FacebookActionsCommand, FacebookSessionEvent);
			commandMap.mapEvent(FacebookSessionEvent.POST_TO_WALL_FAILED, FacebookActionsCommand, FacebookSessionEvent);
			commandMap.mapEvent(FacebookSessionEvent.LIKE_BUTTON_CLICKED, FacebookActionsCommand, FacebookSessionEvent);
			
			commandMap.mapEvent(YoutubeEvent.INIT, YoutubeCommand, YoutubeEvent);
			commandMap.mapEvent(YoutubeEvent.SAVE_VIDEO_ID, YoutubeCommand, YoutubeEvent);
			commandMap.mapEvent(YoutubeEvent.GET_VIDEO_ID, YoutubeCommand, YoutubeEvent);
			
			commandMap.mapEvent(ThemeSettingsEvent.THEME_SELECTED, ThemeSettingsCommand, ThemeSettingsEvent);
			commandMap.mapEvent(CustomizeSettingsEvent.CUSTOMIZE_SELECTED, CustomizeSettingsCommand, CustomizeSettingsEvent);
			
			commandMap.mapEvent(GalleryEvent.GET_IMAGES_DATA, GalleryCommand, GalleryEvent);
			commandMap.mapEvent(GalleryEvent.GOT_IMAGES_DATA, GalleryCommand, GalleryEvent);
			commandMap.mapEvent(GalleryEvent.GET_IMAGE_DETAIL_DATA, GalleryCommand, GalleryEvent);
			commandMap.mapEvent(GalleryEvent.GOT_IMAGE_DETAIL_DATA, GalleryCommand, GalleryEvent);

			mediatorMap.mapView(AppHome, AppHomeMediator);
			mediatorMap.mapView(ThemePage, ThemeMediator);
			mediatorMap.mapView(CustomizePage, CustomizeMediator);
			mediatorMap.mapView(GalleryPage, GalleryMediator);
			mediatorMap.mapView(CarouselView, CarouselMediator);
			mediatorMap.mapView(ArrowNavigation, ArrowMediator);
			mediatorMap.mapView(DropdownMenu, DropdownMenuMediator);
			mediatorMap.mapView(CustomizeDropdownMenu, CustomizeDropdownMediator);
			mediatorMap.mapView(GalleryFilterDropdownMenu, GalleryFilterDropdownMediator);
			mediatorMap.mapView(CustomizeInputNavigation, CustomizeInputMediator);
			mediatorMap.mapView(CustomizeThumbNavigation, CustomizeThumbMediator);
			mediatorMap.mapView(YouTubePlayer, YoutubePlayerMediator);
			mediatorMap.mapView(FacebookAlbumWindow, FacebookAlbumWindowMediator);
			mediatorMap.mapView(FacebookSelectedImageNavigation, FacebookSelectedImageNavigationMediator);			
			mediatorMap.mapView(GalleryWindow, GalleryWindowMediator);
			mediatorMap.mapView(PaginationNavigation, PaginationMediator);
			mediatorMap.mapView(ShareWindow, ShareWindowMediator);
			mediatorMap.mapView(EmailWindow, EmailWindowMediator);
			mediatorMap.mapView(ResponseWindow, ResponseWindowMediator);

			contextView.addChild(new AppHome());
			
			super.startup();	
		}
		
	}
}