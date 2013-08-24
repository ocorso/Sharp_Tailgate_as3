package sharp.views.windows.gallery
{
	import cfm.core.events.CFM_NavigationEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	
	import net.ored.events.ORedEvent;
	import net.ored.util.ORedStringUtils;
	import net.ored.util.URLShortener;
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Mediator;
	
	import sharp.events.CustomizeSettingsEvent;
	import sharp.events.GalleryEvent;
	import sharp.events.SharpWindowEvent;
	import sharp.events.TwitterEvent;
	import sharp.model.Model;
	import sharp.model.vo.Vo;
	import sharp.views.facebookModule.event.FacebookSessionEvent;
	import sharp.views.windows.buttons.LikeButton;
	import sharp.views.youtubeModule.event.YoutubeEvent;
	
	public class GalleryWindowMediator extends Mediator
	{
		
		[Inject]
		public var view:GalleryWindow;
		
		[Inject]
		public var _m:Model;
		

		private const __FACEBOOK:String = "https://www.facebook.com/sharer.php?u=";
		
		override public function onRegister():void{
			eventMap.mapListener(eventDispatcher, GalleryEvent.GOT_IMAGE_DETAIL_DATA, onImageDetailData, null, false, 0, true);
			eventMap.mapListener(view, GalleryEvent.LIKE_CLICKED, onLikeClicked, null, false, 0, true);
			eventMap.mapListener(view, CFM_NavigationEvent.BUTTON_CLICKED, onShareNavClicked, null, true, 0, true);
		}
		override public function onRemove():void{
			eventMap.unmapListener(eventDispatcher, GalleryEvent.GOT_IMAGE_DETAIL_DATA, onImageDetailData);
			eventMap.unmapListener(view, GalleryEvent.LIKE_CLICKED, onLikeClicked);
			eventMap.unmapListener(view, CFM_NavigationEvent.BUTTON_CLICKED, onShareNavClicked);
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
		private function onImageDetailData(e:GalleryEvent):void{
			view.roomImageUrl = _m.imageUrl + "rooms/" + _m.roomImageButtonData[_m.galleryDetailData.room_type].@id + "_background.jpg";
			view.forgroundImageUrl = _m.baseUrl + "images/gallery/large/" + _m.galleryDetailData.@id + ".png";
			
			view.updateWindow(_m.galleryDetailData, _m.facebook.userId, _m.facebook.authToken);
			
			var tvY:Number = _m.roomImageButtonData[_m.galleryDetailData.room_type].@tvY;
			var tvSize:Number = _m.tvButtonData[_m.galleryDetailData.tv_size].@scale;
			var roomType:String = _m.roomImageButtonData[_m.galleryDetailData.room_type].@type;
			var defaultImage:String = _m.roomImageButtonData[_m.galleryDetailData.room_type].defaultImage;
			
			view.buildTV(tvY, tvSize, roomType);
			
			//if(_m.galleryDetailData.media_id.toString() != " "){
				
				if(_m.galleryDetailData.media_id.@is_slideshow == "0"){
				
					view.buildYoutubePlayer();
					Vo.youtube.videoUrl = null;
					Vo.youtube.videoId = _m.galleryDetailData.media_id;
					Vo.customizeParams.tvContentWidth = view.tvClip.defaultImage.width;
					Vo.customizeParams.tvContentHeight = view.tvClip.defaultImage.height;
					
					dispatch(new CustomizeSettingsEvent(CustomizeSettingsEvent.CUSTOMIZE_SELECTED, Vo.customizeParams));
					dispatch(new YoutubeEvent(YoutubeEvent.SAVE_VIDEO_ID, Vo.youtube));
					dispatch(new YoutubeEvent(YoutubeEvent.GET_VIDEO_ID, Vo.youtube));
					
				}else{
					view.slideshowNumber = _m.galleryDetailData.slideshow.slide.length();
					view.buildSlideshowContainer();
					for(var i:int=0; i<_m.galleryDetailData.slideshow.slide.length(); i++){
						view.loadFacebookPhoto(_m.galleryDetailData.slideshow.slide[i].local);
						//Out.info(this, "is slideShow" +  _m.galleryDetailData.slideshow.slide[i].local);
					}
				} 
				
			//}
//			else{
//				view.showDefaultImage(defaultImage);
//			}
		}
		
		private function onLikeClicked(e:GalleryEvent):void{
			Out.status(this, "onLikeClicked");
			
			dispatch(new FacebookSessionEvent(FacebookSessionEvent.LIKE_BUTTON_CLICKED, e.params));
		}
		
		private function onShareNavClicked(e:CFM_NavigationEvent):void{
			Out.info(this, e.id);
			
			switch(e.id){
				case "facebook":
					var facebookUrl:String = __FACEBOOK + shareUrl;
					ExternalInterface.call("window.open",[facebookUrl]);
					_m.ga.trackShareWindow(_m.currentPageId, _m.currentWindowId, e.id);
					break;
				case "twitter":

					_m.ga.trackShareWindow(_m.currentPageId, _m.currentWindowId, e.id);
					dispatch(new TwitterEvent(TwitterEvent.TWEET, {shareUrl:shareUrl}));
					
					break;
				default:
					Vo.customizeParams.tailgateName = view.tailgateName;
					_m.tid = view.tid;
					dispatch(new CustomizeSettingsEvent(CustomizeSettingsEvent.CUSTOMIZE_SELECTED, Vo.customizeParams));
					dispatch(new SharpWindowEvent(SharpWindowEvent.OPEN_WINDOW, "email", {tid:view.tid, tailgateName:view.tailgateName}));
					_m.ga.trackShareWindow(_m.currentPageId, "gallery", e.id);
					break;
			}
			
			
		}
		
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		
		public function get shareUrl():String{
			return _m.baseUrl + "gallery/redirect/" + view.tid;
		}
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function GalleryWindowMediator()
		{
			super();
		}
	}
}