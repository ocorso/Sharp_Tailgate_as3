package sharp.views.customizeModule
{
	import cfm.core.events.CFM_NavigationEvent;
	
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Mediator;
	
	import sharp.events.CustomizeSettingsEvent;
	import sharp.events.FacebookPhotoEvent;
	import sharp.events.SharpDropdownEvent;
	import sharp.events.SharpNavigationEvent;
	import sharp.events.SharpPageEvent;
	import sharp.events.SharpWindowEvent;
	import sharp.events.SubmitGalleryItemEvent;
	import sharp.events.ThemeSettingsEvent;
	import sharp.model.Model;
	import sharp.model.vo.Vo;
	import sharp.views.customizeModule.event.CustomizeEvent;
	import sharp.views.facebookModule.event.FacebookSessionEvent;
	import sharp.views.youtubeModule.event.YoutubeEvent;
	
	public class CustomizeMediator extends Mediator
	{
		[Inject]
		public var view:CustomizePage;

		[Inject]
		public var _m:Model;
		
		override public function onRegister():void{
			dispatch(new SharpWindowEvent(SharpWindowEvent.OPEN_WINDOW, "loading", {}));
			eventMap.mapListener(view, SharpPageEvent.PAGE_BUILD_COMPLETE, buildComplete, null, false, 0, true);
			eventMap.mapListener(view, CFM_NavigationEvent.BUTTON_CLICKED, onNavigationClicked, null, false, 0, true);
			eventMap.mapListener(view, CustomizeEvent.ROOM_IMAGE_LOADED, onRoomImageLoaded, null, false, 0, true);
			eventMap.mapListener(view, CustomizeEvent.FURNITURE_IMAGE_LOADED, onFurnitureImageLoaded, null, false, 0, true);
			eventMap.mapListener(view, SharpNavigationEvent.SUB_PAGE_NAVIGATION_CLICKED, onSubNavigationClicked, null, false, 0, true);
			eventMap.mapListener(eventDispatcher, SharpDropdownEvent.DROPDOWN_SELECTED, onDropdownOpened, null, false, 0, true);
			eventMap.mapListener(eventDispatcher, SharpDropdownEvent.CUSTOMIZE_DROPDOWN_ITEM_SELECTED, onItemSelected, null, false, 0, true);
			eventMap.mapListener(eventDispatcher, SharpDropdownEvent.TEAMNAME_OK_SELECTED, onTeamNameOkSelected, null, false, 0, true);
			eventMap.mapListener(eventDispatcher, SharpDropdownEvent.EMAIL_OK_SELECTED, onEmailOkSelected, null, false, 0, true);
			eventMap.mapListener(eventDispatcher, YoutubeEvent.SAVE_VIDEO_ID, getVideoImageUrl, null, false, 0, true);
			eventMap.mapListener(eventDispatcher, FacebookPhotoEvent.GET_PHOTO_URL, getPhotoURL, null, false, 0, true);
			eventMap.mapListener(eventDispatcher, FacebookSessionEvent.SAVE_POST_ID_COMPLETE, switchToFinish, null, false, 0, true);
			eventMap.mapListener(eventDispatcher, SubmitGalleryItemEvent.DROP_IMAGE_COMPLETE, onPosttoWallFaile, null, false, 0, true);
			eventMap.mapListener(eventDispatcher, FacebookPhotoEvent.CLEAR_PHOTO, onClearPhoto, null, false, 0, true);
			eventMap.mapListener(eventDispatcher, SharpNavigationEvent.YES_CLICKED, onYesClicked, null, false, 0, true);
		}
		
		override public function onRemove():void{
			eventMap.unmapListener(view, SharpPageEvent.PAGE_BUILD_COMPLETE, buildComplete);
			eventMap.unmapListener(view, CFM_NavigationEvent.BUTTON_CLICKED, onNavigationClicked);
			eventMap.unmapListener(view, CustomizeEvent.ROOM_IMAGE_LOADED, onRoomImageLoaded);
			eventMap.unmapListener(view, CustomizeEvent.FURNITURE_IMAGE_LOADED, onFurnitureImageLoaded);
			eventMap.unmapListener(view, SharpNavigationEvent.SUB_PAGE_NAVIGATION_CLICKED, onSubNavigationClicked);
			eventMap.unmapListener(eventDispatcher, SharpDropdownEvent.DROPDOWN_SELECTED, onDropdownOpened);
			eventMap.unmapListener(eventDispatcher, SharpDropdownEvent.CUSTOMIZE_DROPDOWN_ITEM_SELECTED, onItemSelected);
			eventMap.unmapListener(eventDispatcher, SharpDropdownEvent.TEAMNAME_OK_SELECTED, onTeamNameOkSelected);
			eventMap.unmapListener(eventDispatcher, SharpDropdownEvent.EMAIL_OK_SELECTED, onEmailOkSelected);
			eventMap.unmapListener(eventDispatcher, YoutubeEvent.SAVE_VIDEO_ID, getVideoImageUrl);
			eventMap.unmapListener(eventDispatcher, FacebookPhotoEvent.GET_PHOTO_URL, getPhotoURL);
			eventMap.unmapListener(eventDispatcher, FacebookSessionEvent.SAVE_POST_ID_COMPLETE, switchToFinish);
			eventMap.unmapListener(eventDispatcher, SubmitGalleryItemEvent.DROP_IMAGE_COMPLETE, onPosttoWallFaile);
			eventMap.unmapListener(eventDispatcher, FacebookPhotoEvent.CLEAR_PHOTO, onClearPhoto);
			eventMap.unmapListener(eventDispatcher, SharpNavigationEvent.YES_CLICKED, onYesClicked);
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
		
		private function setThemeParams():void{
			Vo.themeParams.primaryColorIndex = undefined;
			Vo.themeParams.primaryColor = undefined;
			Vo.themeParams.secondaryColorIndex = undefined;
			Vo.themeParams.secondaryColor = undefined;
			Vo.themeParams.tvIndex = undefined;
			view.removeTV();
		}
		
		// =================================================
		// ================ Handlers
		// =================================================
		private function onRoomImageLoaded(e:CustomizeEvent):void{

			view.roomName = _m.themeParams.roomId;
			view.primaryColor = _m.themeParams.primaryColor;
			view.secondaryColor = _m.themeParams.secondaryColor;
			
			view.buildTV(_m.themeParams.tvY, _m.themeParams.tvSize, _m.themeParams.roomType, _m.themeParams.tvDefaultImage);

			view.buildForgroundHolder();
			view.buildBanner(_m.themeParams.roomBannerClass, _m.themeParams.roomBannerX, _m.themeParams.roomBannerY);
			view.buildPhotoHolder(_m.themeParams.photoClass, _m.themeParams.photoX, _m.themeParams.photoY);
			view.buildTooltip(_m.themeParams.photoX, _m.themeParams.photoY);
			view.buildItemCanvas();
			view.buildFurniture(_m.themeParams.roomFurnitureURL);
		}
		
		private function onFurnitureImageLoaded(e:CustomizeEvent):void{
			view.switchStatus(_m.customizeParams.pageStatus, false);
			dispatch(new SharpWindowEvent(SharpWindowEvent.CLOSE_WINDOW, "loading", {}));
		}
		
		private function buildComplete(e:SharpPageEvent):void
		{
			view.buildRoom(_m.themeParams.roomImageURL);

		}
		
		private function onPosttoWallFaile(e:SubmitGalleryItemEvent):void{
			dispatch(new SharpWindowEvent(SharpWindowEvent.OPEN_WINDOW, "response_warning", null));
		}
		
		private function onNavigationClicked(e:CFM_NavigationEvent):void{
			
			
			
			var trackId:String = _m.currentPageData.navigation.button[e.index].@track;
			_m.ga.track(_m.currentPageId, "", trackId);
			
			switch(e.id){
				case "theme":
					dispatch(new SharpWindowEvent(SharpWindowEvent.OPEN_WINDOW, "response_startover",  null));
					break;
				case "preview":
					Vo.customizeParams.pageStatus = e.id;
					dispatch(new CustomizeSettingsEvent(CustomizeSettingsEvent.CUSTOMIZE_SELECTED,Vo.customizeParams));
					view.switchStatus(e.id, false);
					break;
			}

		}
		
		private function onSubNavigationClicked(e:SharpNavigationEvent):void{
			
			var trackingData:XML;
			switch(e.id){
				case "finish":
					view.invisibleTooltip();
					view.previewPage.closePreviewDropdown();
					//oc: email not required in dec 2012 updates
					//if(_m.hasEmail){
					if(true){
						TweenMax.delayedCall(.1, saveImage);
						dispatch(new SharpWindowEvent(SharpWindowEvent.OPEN_WINDOW, "loading", null));
						_m.ga.trackSubPageNav(e.index, _m.currentPageData.preview);
						
					}else{
						view.previewPage.showTooltip();
					}

					break;
				case "customize":
					_m.ga.trackSubPageNav(e.index, _m.currentPageData.preview);
					
					Vo.customizeParams.pageStatus = e.id;
					dispatch(new CustomizeSettingsEvent(CustomizeSettingsEvent.CUSTOMIZE_SELECTED,Vo.customizeParams));
					view.switchStatus(e.id, false);
					break;
				case "gallery":
					_m.ga.trackSubPageNav(e.index, _m.currentPageData.finish);
					
					dispatch(new SharpPageEvent(SharpPageEvent.CHANGE_PAGE,e.id));
					break;
				case "share":
					_m.ga.trackSubPageNav(e.index, _m.currentPageData.finish);
					
					dispatch(new SharpWindowEvent(SharpWindowEvent.OPEN_WINDOW,"share",null));
					break;
			}

		}
		
		private function saveImage():void{
			
			Vo.customizeParams.roomBitmap 	= view.roomBitmap;
			Vo.customizeParams.forgroundBitmap = view.forgroundBitmap;
			view.tailgateName = _m.customizeParams.tailgateName;
			
			view.buildFinishRoom();
			dispatch(new CustomizeSettingsEvent(CustomizeSettingsEvent.CUSTOMIZE_SELECTED, Vo.customizeParams));
			dispatch(new SubmitGalleryItemEvent(SubmitGalleryItemEvent.SAVE_IMAGE_TO_GALLERY,_m.submitImageParams));
		}
		
		private function switchToFinish(e:FacebookSessionEvent):void{
			
			dispatch(new SharpWindowEvent(SharpWindowEvent.CLOSE_WINDOW, "", null));
			view.switchStatus("finish", _m.customizeParams.isSlideshow);
			
			Out.info(this, _m.customizeParams.isSlideshow);
			
			if(!_m.customizeParams.isSlideshow && _m.youtube.videoId){
				Vo.customizeParams.tvContentWidth = view.tvClip.contentMask.width;
				Vo.customizeParams.tvContentHeight = view.tvClip.contentMask.height;
				
				dispatch(new CustomizeSettingsEvent(CustomizeSettingsEvent.CUSTOMIZE_SELECTED, Vo.customizeParams));
				
				dispatch(new YoutubeEvent(YoutubeEvent.GET_VIDEO_ID, _m.youtube));
			}
		}
		
		private function onDropdownOpened(e:SharpDropdownEvent):void{
			view.checkDropdownOpen(e.menuIndex);
			view.previewPage.hideTooltip();
		}
		
		private function onItemSelected(e:SharpDropdownEvent):void{
			var color1:uint;
			var color2:uint;

			if(_m.customizeParams.itemColorType == "true") {
				color1 = _m.themeParams.primaryColor;
				color2 = _m.themeParams.secondaryColor;
				view.updateItemCanvas(color1, color2, _m.customizeParams.itemId, _m.customizeParams.itemColorType);
			}else{
				view.updateItemCanvas(color1, color2, _m.customizeParams.itemImageURL, _m.customizeParams.itemColorType);
			}
			
		}
		
		private function onTeamNameOkSelected(e:SharpDropdownEvent):void{

			view.updateTeamName(_m.customizeParams.teamName.toUpperCase(), _m.themeParams.bannerDifX, _m.themeParams.bannerDifY, _m.themeParams.bannerDifScale);	
			if(view.photoImage)view.showTooltip();
		}
		
		private function onEmailOkSelected(e:SharpDropdownEvent):void{
			view.previewPage.hideTooltip();
		}
		
		private function getVideoImageUrl(e:YoutubeEvent):void{
			if(_m.youtube.valid) view.buildVideoImage(_m.youtube.videoImageUrl);
		}
		
		private function getPhotoURL(e:FacebookPhotoEvent):void{
			switch(Vo.customizeParams.listId) {
				case "personalization":
					view.removePhoto();
					view.updatePhotoFrame(_m.customizeParams.photoUrl, _m.themeParams.photoWidth, _m.themeParams.photoContentX);
					break;
				
				case "enter_video":
					view.buildSlideImage(_m.customizeParams.photoUrls);
					break;
			}
		}
		
		private function onClearPhoto(e:FacebookPhotoEvent):void{
			view.removePhoto();
			view.hideTooltip();
		}
		
		private function onYesClicked(e:SharpNavigationEvent):void{
			setThemeParams();
			dispatch(new ThemeSettingsEvent(ThemeSettingsEvent.THEME_SELECTED,Vo.themeParams));
			dispatch(new SharpWindowEvent(SharpWindowEvent.CLOSE_WINDOW, "",  null));
			dispatch(new SharpPageEvent(SharpPageEvent.CHANGE_PAGE,"theme"));
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
		public function CustomizeMediator()
		{
			super();
		}

	}
}