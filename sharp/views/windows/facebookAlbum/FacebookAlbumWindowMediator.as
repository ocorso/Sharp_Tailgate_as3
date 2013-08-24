package sharp.views.windows.facebookAlbum
{
	import cfm.core.events.CFM_ButtonEvent;
	import cfm.core.events.CFM_NavigationEvent;
	import cfm.core.events.CFM_PageEvent;
	import cfm.core.graphics.CFM_Graphics;
	
	import com.greensock.TweenMax;
	
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Mediator;
	
	import sharp.events.CustomizeSettingsEvent;
	import sharp.events.FacebookAlbumSideNavEvent;
	import sharp.events.FacebookPhotoEvent;
	import sharp.events.SharpNavigationEvent;
	import sharp.events.SharpWindowEvent;
	import sharp.model.Model;
	import sharp.model.vo.Vo;
	import sharp.utils.FacebookUtils;
	import sharp.views.customizeModule.customizeNavigation.buttons.FacebookPhotoThumbnail;
	import sharp.views.windows.facebookAlbum.buttons.FacebookPhotoButton;
	import sharp.views.windows.facebookAlbum.buttons.FacebookSideNavThumbnail;
	
	public class FacebookAlbumWindowMediator extends Mediator
	{
		[Inject]
		public var view:FacebookAlbumWindow;
		
		[Inject]
		public var _m:Model;
		
		override public function onRegister():void{
			view.authToken = _m.facebook.authToken;
			view.albumList 	= FacebookUtils.parseAlbumDataToNavXML(_m.facebook.albums);
			
			eventMap.mapListener(view, CFM_NavigationEvent.BUTTON_SELECTED, onNavigationClicked, null, true, 0, true);
			eventMap.mapListener(view, CFM_NavigationEvent.BUTTON_CLICKED, onNavigationClicked, null, true, 0, true);
			eventMap.mapListener(view, CFM_ButtonEvent.CLICKED, onNavigationButtonClicked, null, true, 0, true);
			eventMap.mapListener(eventDispatcher, FacebookAlbumSideNavEvent.DESELECT_PHOTO , deselectPhotoButton, null, false, 0, true);
		}
		
		override public function onRemove():void{
			eventMap.unmapListener(view, CFM_NavigationEvent.BUTTON_SELECTED, onNavigationClicked);
			eventMap.unmapListener(view, CFM_NavigationEvent.BUTTON_CLICKED, onNavigationClicked);
			eventMap.unmapListener(view, CFM_ButtonEvent.CLICKED, onNavigationButtonClicked);
			eventMap.unmapListener(eventDispatcher, FacebookAlbumSideNavEvent.DESELECT_PHOTO , deselectPhotoButton);
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
			switch(e.target){
				case view.albumNav:
					view.albumId = e.value;
					view.swicthStatus("photo");
					_m.ga.trackFacebookWindow(view.id, "album_clicked");
					break;
				case view.photoNav:
					photoNavHandler(Vo.customizeParams.listId, e.index);
					
					break;
				case view.backButton:
					view.swicthStatus("album");
					Vo.customizeParams.photoUrl = "";
					dispatch(new CustomizeSettingsEvent(CustomizeSettingsEvent.CUSTOMIZE_SELECTED, Vo.customizeParams));
					_m.ga.trackFacebookWindow(view.id, "album");
					break;				
			}	
		}
		
		private function photoNavHandler(_id:String, idx:int):void{ 
			if((view.photoNav.buttonsVector[idx] as FacebookPhotoButton).photoUrl)
				Vo.customizeParams.photoUrl = (view.photoNav.buttonsVector[idx] as FacebookPhotoButton).photoUrl;
			
			if (view.multiSelect) {
				if (!view.sideNavOkBtn.visible)
					TweenMax.to(view.sideNavOkBtn, .4, {autoAlpha:1});
				
				var thumbUrl:String = (view.photoNav.buttonsVector[idx] as FacebookPhotoButton).thumbUrl;
				var photoId:String = (view.photoNav.buttonsVector[idx] as FacebookPhotoButton).photoId;
				
				var photoThumbnail:FacebookSideNavThumbnail = new FacebookSideNavThumbnail(thumbUrl, Vo.customizeParams.photoUrl, photoId);
				
				photoThumbnail.renderTo( view.sideNav.thumbContainer );
				TweenMax.to(photoThumbnail, .5, {alpha:1});

			}
			else {
				dispatch(new SharpWindowEvent(SharpWindowEvent.CLOSE_WINDOW,"",{}));				
				dispatch(new CustomizeSettingsEvent(CustomizeSettingsEvent.CUSTOMIZE_SELECTED, Vo.customizeParams));
				dispatch(new FacebookPhotoEvent(FacebookPhotoEvent.GET_PHOTO_URL));
				dispatch(new FacebookPhotoEvent(FacebookPhotoEvent.CLEAR_PHOTO));
			}
			
			_m.ga.trackFacebookWindow(view.id, "photo_clicked");
			
		}
		
		private function onNavigationButtonClicked(e:CFM_ButtonEvent):void{
			if (e.target == view.sideNavOkBtn){
				Vo.customizeParams.photoUrls = [];
				
				for (var i:int = 0; i < view.sideNav.thumbContainer.numChildren; i++){
					var item:FacebookSideNavThumbnail = view.sideNav.thumbContainer.getChildAt(i) as FacebookSideNavThumbnail;
					Vo.customizeParams.photoUrls.push(item.photoUrl);
				}
				
				dispatch(new SharpWindowEvent(SharpWindowEvent.CLOSE_WINDOW,"",{}));				
				dispatch(new CustomizeSettingsEvent(CustomizeSettingsEvent.CUSTOMIZE_SELECTED, Vo.customizeParams));
				dispatch(new FacebookPhotoEvent(FacebookPhotoEvent.GET_PHOTO_URL));
				
				_m.ga.track(_m.currentPageId, "", "slideshow_ok");
			}
		}
		
		private function deselectPhotoButton(e:FacebookAlbumSideNavEvent):void{
			for (var i:int = 0; i < view.photoNav.buttonContainer.numChildren; i++) {
				var btn:FacebookPhotoButton = (view.photoNav.buttonsVector[i] as FacebookPhotoButton);
				if (btn.photoId == e.photoId)
					btn.deselect(false);
			}
			
			// Hide ok button if sideNave has single image (*this image will be delected after this method)
			if(view.sideNav.thumbContainer.numChildren == 1)
				TweenMax.to(view.sideNavOkBtn, .4, {autoAlpha:0});
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

		public function FacebookAlbumWindowMediator()
		{
			super();
		}
	}
}