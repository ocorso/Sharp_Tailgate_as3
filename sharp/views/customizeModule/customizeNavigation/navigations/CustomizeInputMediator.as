package sharp.views.customizeModule.customizeNavigation.navigations
{
	import cfm.core.events.CFM_DropdownMenuEvent;
	import cfm.core.events.CFM_NavigationEvent;
	import cfm.core.ui.CFM_DropdownMenu;
	
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Mediator;
	
	import sharp.events.CustomizeSettingsEvent;
	import sharp.events.FacebookPhotoEvent;
	import sharp.events.SharpButtonEvent;
	import sharp.events.SharpDropdownEvent;
	import sharp.events.SharpNavigationEvent;
	import sharp.events.SharpWindowEvent;
	import sharp.model.Model;
	import sharp.model.vo.Vo;
	import sharp.views.customizeModule.event.CustomizeEvent;
	import sharp.views.youtubeModule.event.YoutubeEvent;
	
	public class CustomizeInputMediator extends Mediator
	{
		[Inject]
		public var view:CustomizeInputNavigation;
		
		[Inject]
		public var _m:Model;
		
		private var facebookType			:String;
		
		override public function onRegister():void{
			view.roomItem = _m.themeParams.roomItem;
			eventMap.mapListener(view, SharpNavigationEvent.NAVIGATION_BUILD_COMPLETE, onBuildComplete, null, false, 0, true);
			eventMap.mapListener(view, SharpDropdownEvent.DROPDOWN_NAVIGATION_CLICKED, onDropdownNavigationClicked, null, false, 0, true);
			eventMap.mapListener(view, SharpButtonEvent.FACEBOOK_CHOOSE_CLICKED, onFacebookChooseClicked, null, false, 0, true);
			eventMap.mapListener(view, SharpButtonEvent.YOUTUBE_BROWSE_CLICKED, onYoutubeBrowseClicked, null, false, 0, true);
			eventMap.mapListener(view, CustomizeEvent.INPUT_FIELD_CHANGE, onInputFieldChange, null, false, 0, true);
			eventMap.mapListener(view, SharpButtonEvent.CLEAR_PHOTO_CLICKED, onFacebookClearClicked, null, false, 0, true);
			eventMap.mapListener(eventDispatcher, FacebookPhotoEvent.GET_PHOTO_URL, onGetPhotoUrl, null, false, 0, true);
			eventMap.mapListener(view, CustomizeEvent.CHECK_IS_SLIDESHOW, onCheckIsSlideshow, null, false, 0, true);
		}
		
		override public function onRemove():void{
			eventMap.unmapListener(view, SharpNavigationEvent.NAVIGATION_BUILD_COMPLETE, onBuildComplete);
			eventMap.unmapListener(view, SharpDropdownEvent.DROPDOWN_NAVIGATION_CLICKED, onDropdownNavigationClicked);
			eventMap.unmapListener(view, SharpButtonEvent.FACEBOOK_CHOOSE_CLICKED, onFacebookChooseClicked);
			eventMap.unmapListener(view, SharpButtonEvent.YOUTUBE_BROWSE_CLICKED, onYoutubeBrowseClicked);
			eventMap.unmapListener(view, CustomizeEvent.INPUT_FIELD_CHANGE, onInputFieldChange);
			eventMap.unmapListener(view, SharpButtonEvent.CLEAR_PHOTO_CLICKED, onFacebookClearClicked);
			eventMap.unmapListener(eventDispatcher, FacebookPhotoEvent.GET_PHOTO_URL, onGetPhotoUrl);
			eventMap.unmapListener(view, CustomizeEvent.CHECK_IS_SLIDESHOW, onCheckIsSlideshow);
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

		private function onBuildComplete(e:SharpNavigationEvent):void{
			Vo.customizeParams.teamName = Vo.DEFAULT_TEAM_NAME;
			Vo.customizeParams.tailgateName = Vo.DEFAULT_TAILGATE_NAME;
			
			dispatch(new CustomizeSettingsEvent(CustomizeSettingsEvent.CUSTOMIZE_SELECTED, Vo.customizeParams));
		}

		// Invoke when button pressed in Dropdown navigation
		private function onDropdownNavigationClicked(e:SharpDropdownEvent):void{			
			facebookType = e.itemValue;
			dispatch(new SharpDropdownEvent(SharpDropdownEvent.OK_SELECTED, e.menuIndex, view.id, e.itemIndex, view.inputValue));
		}
		
		private function onFacebookChooseClicked(e:SharpButtonEvent):void{
			dispatch(new SharpWindowEvent(SharpWindowEvent.OPEN_WINDOW, "facebook", {facebookType:facebookType}));
			
			_m.ga.trackFacebookWindow(_m.currentPageId + "_" + view.id, e.id);
		}
		
		private function onYoutubeBrowseClicked(e:SharpButtonEvent):void{
			_m.ga.track(_m.currentPageId, "", e.id);
		}
		
		private function onInputFieldChange(e:CustomizeEvent):void{
			
			switch(view.id){
				case "personalization":
					Vo.customizeParams.tailgateName = view.inputValue;
					dispatch(new CustomizeSettingsEvent(CustomizeSettingsEvent.CUSTOMIZE_SELECTED, Vo.customizeParams));
					break;
				case "name_your_tailgate":
					Vo.customizeParams.teamName = view.inputValue;
					dispatch(new CustomizeSettingsEvent(CustomizeSettingsEvent.CUSTOMIZE_SELECTED, Vo.customizeParams));

					break;
				case "enter_video":
					Vo.youtube.videoUrl = view.inputValue;
					dispatch(new YoutubeEvent(YoutubeEvent.SAVE_VIDEO_ID, Vo.youtube));
					break;
				case "enter_email":
					Vo.customizeParams.userEmail = view.inputValue;
					dispatch(new CustomizeSettingsEvent(CustomizeSettingsEvent.CUSTOMIZE_SELECTED, Vo.customizeParams));
					break;
			}
		}
		
		private function onGetPhotoUrl(e:FacebookPhotoEvent):void{
			view.showPhoto(_m.customizeParams.photoUrl);
		}
		
		private function onFacebookClearClicked(e:SharpButtonEvent):void{
			dispatch(new FacebookPhotoEvent(FacebookPhotoEvent.CLEAR_PHOTO));
			
			_m.ga.trackFacebookWindow(_m.currentPageId + "_" + view.id, e.id);
		}
		
		private function onCheckIsSlideshow(e:CustomizeEvent):void{
			_m.customizeParams.isSlideshow = e.isSlideshow;
			
			if(e.isSlideshow) {
				_m.youtube.videoUrl = null;
				_m.youtube.videoId = null;
				//dispatch(new YoutubeEvent(YoutubeEvent.SAVE_VIDEO_ID, Vo.youtube));
			}	
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

		public function CustomizeInputMediator()
		{
			super();
		}
	}
}