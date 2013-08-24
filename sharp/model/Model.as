package sharp.model
{
	import cfm.core.containers.CFM_ObjectContainer;
	
	import com.adobe.serialization.json.JSON;
	
	import flash.display.Bitmap;
	
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Actor;
	
	import sharp.events.GalleryEvent;
	import sharp.events.SharpAppEvent;
	import sharp.events.SharpPageEvent;
	import sharp.events.SubmitGalleryItemEvent;
	import sharp.events.ThemeSettingsEvent;
	import sharp.model.vo.CustomizeParams;
	import sharp.model.vo.SubmitGalleryItemParams;
	import sharp.model.vo.ThemeParams;
	import sharp.model.vo.Vo;
	import sharp.utils.AnalyticsManager;
	import sharp.utils.ValidationUtils;
	import sharp.views.appTemplate.SharpPageTemplate;
	import sharp.views.facebookModule.event.FacebookSessionEvent;
	import sharp.views.facebookModule.vo.FacebookData;
	import sharp.views.facebookModule.vo.WallPostParams;
	import sharp.views.youtubeModule.event.YoutubeEvent;
	import sharp.views.youtubeModule.vo.YoutubeData;

	public class Model extends Actor
	{
		private var _baseUrl						:String;
		private var _likeStatus						:Boolean;
		private var _appData						:XML;
		private var _currentPageId					:String;
		private var _currentPageData				:XML;
		private var _currentWindowId				:String;
		private var _currentWindowData				:XML;
		
		private var _themeParams					:ThemeParams;
		private var _customizeParams				:CustomizeParams;

		private var _facebook						:FacebookData;
		private var _youtube						:YoutubeData;
		
		private var _wallPostParams					:WallPostParams;
		private var _submitImageParams				:SubmitGalleryItemParams;
		
		private var _tid							:String = "-1";
		
		private var _galleryPageNumber				:int;
		private var _currentGalleryPage				:int;
		
		private var _galleryData					:XML;
		private var _galleryDetailData				:XML;
		
		private var _galleryRoute					:String;
		private var _galleryDetailRoute				:String;
		
		private var _hasEmail						:Boolean;
		
		private var _ga								:AnalyticsManager;
		
		public function Model()
		{
			_ga = new AnalyticsManager();
		}

		public function get ga():AnalyticsManager
		{
			return _ga;
		}

		public function set ga(value:AnalyticsManager):void
		{
			_ga = value;
		}

		public function get hasEmail():Boolean
		{
			return _hasEmail;
		}

		public function set hasEmail(value:Boolean):void
		{
			_hasEmail = value;
		}

		public function set appData(_data:XML):void{_appData = _data;}
		public function get appData():XML{return _appData;}
		
		public function get pageData():XMLList{return _appData.config.pages.page;}
		
		public function get windowData():XMLList{return _appData.config.windows.window;}
		
		public function get currentPageData():XML{return _currentPageData;}
		public function set currentPageData(value:XML):void{_currentPageData = value;}
		
		public function get currentWindowData():XML{return _currentWindowData;}
		public function set currentWindowData(value:XML):void{_currentWindowData = value;}
		
		public function get currentPageId():String{return _currentPageId;}
		public function set currentPageId(value:String):void
		{
			_currentPageId = value;
			currentPageData = XML(pageData.(@id == _currentPageId));
		}
		
		public function get currentWindowId():String{return _currentWindowId;}
		public function set currentWindowId(value:String):void
		{
			_currentWindowId = value;
			currentWindowData = XML(windowData.(@id == _currentWindowId));
		}
		
		public function get galleryData():XML{return _galleryData;}
		public function set galleryData(value:XML):void
		{
			_galleryData = value;
			galleryPageNumber = int(_galleryData.images.@total_pages);
		}
		
		public function get galleryDetailData():XML{return _galleryDetailData;}
		public function set galleryDetailData(value:XML):void{_galleryDetailData = value;}
		
		public function get galleryRoute():String
		{
			return appData.environment[0].routes[0].gallery.page;
		}
		
		public function get currentGalleryPage():int
		{
			return _currentGalleryPage;
		}
		
		public function set currentGalleryPage(value:int):void
		{
			_currentGalleryPage = value;
		}
		
		public function get galleryPageNumber():int
		{
			return _galleryPageNumber;
		}
		
		public function set galleryPageNumber(value:int):void
		{
			_galleryPageNumber = value;

		}
		
		public function get galleryDetailRoute():String
		{
			return _galleryDetailRoute;
		}
		
		public function set galleryDetailRoute(value:String):void
		{
			_galleryDetailRoute = value;
		}
		
		/////////////THEME PARAMS/////////////
		
		public function set themeParams(_params:ThemeParams):void{
			_themeParams = _params;
			
			_themeParams.paramsName = pageData.(@id == "theme").selection[_params.paramsIndex].@id;
			_themeParams.primaryColorName = colorButtonData[_params.primaryColorIndex].label;
			_themeParams.secondaryColorName = colorButtonData[_params.secondaryColorIndex].label;
			_themeParams.tvSizeName = tvButtonData[_params.tvIndex].label;
			_themeParams.tvSize = tvButtonData[_params.tvIndex].@scale;
			_themeParams.tvDefaultImage = roomImageButtonData[_params.roomIndex].defaultImage;
			_themeParams.roomId = roomImageButtonData[_params.roomIndex].@id;
			_themeParams.roomItem = roomImageButtonData[_params.roomIndex].@item;
			_themeParams.roomLength = roomImageButtonData.length();
			_themeParams.roomName = roomImageButtonData[_params.roomIndex].label;
			_themeParams.roomImageURL = imageUrl + "rooms/" + roomImageButtonData[_params.roomIndex].@id + "_background.jpg";
			_themeParams.roomFurnitureURL = imageUrl + "rooms/" + roomImageButtonData[_params.roomIndex].@id + "_furniture.png";
			_themeParams.roomBannerClass = roomImageButtonData[_params.roomIndex].banner;
			_themeParams.roomBannerX = roomImageButtonData[_params.roomIndex].banner.@posX;
			_themeParams.roomBannerY = roomImageButtonData[_params.roomIndex].banner.@posY;
			_themeParams.bannerDifX = roomImageButtonData[_params.roomIndex].banner.@difX;
			_themeParams.bannerDifY = roomImageButtonData[_params.roomIndex].banner.@difY;
			_themeParams.bannerDifScale = roomImageButtonData[_params.roomIndex].banner.@difScale;
			_themeParams.photoClass = roomImageButtonData[_params.roomIndex].photo;
			_themeParams.photoX = roomImageButtonData[_params.roomIndex].photo.@posX;
			_themeParams.photoY = roomImageButtonData[_params.roomIndex].photo.@posY;
			_themeParams.photoWidth = roomImageButtonData[_params.roomIndex].photo.@width;
			_themeParams.photoContentX = roomImageButtonData[_params.roomIndex].photo.@contentX;
			_themeParams.tvY = roomImageButtonData[_params.roomIndex].@tvY;
			
			_themeParams.roomType = roomImageButtonData[_params.roomIndex].@type;

			if(_themeParams.paramsName=="rooms") dispatch(new ThemeSettingsEvent(ThemeSettingsEvent.GET_ROOM, themeParams));
		}

		public function get themeParams():ThemeParams{
			return _themeParams;
		}
		
		public function get facebookPostParams():WallPostParams{
			
			var p:WallPostParams = new WallPostParams();
			
			p.linkUrl		= appData.environment[0].facebook[0].link;
			p.linkName		= appData.environment[0].facebook[0].title;
			p.caption		= appData.environment[0].facebook[0].caption;
			p.description	= appData.environment[0].facebook[0].description;
			p.imageUrl		= baseUrl + 'images/gallery/thumb/'; 

			return p;
		}
		/////////////CUSTOMIZE PARAMS/////////////
		
		public function set customizeParams(_params:CustomizeParams):void{
			_customizeParams = _params;

		}

		public function get submitImageParams():SubmitGalleryItemParams{
			Out.status(this, "submitImageParams");
				
			if(!_submitImageParams)
				_submitImageParams 				= new SubmitGalleryItemParams();
			
			_submitImageParams.route			= baseUrl + appData.environment[0].routes[0].upload;
			_submitImageParams.dropRoute		= baseUrl + appData.environment[0].routes[0].drop;
			_submitImageParams.setPostIdRoute	= baseUrl + appData.environment[0].routes[0].set_post_id;
			_submitImageParams.userId 			= facebook.userId;
			_submitImageParams.username 		= facebook.userName;
			_submitImageParams.photoUrl 		= facebook.photoUrl;
			_submitImageParams.isSlideshow 		= customizeParams.isSlideshow;
			_submitImageParams.roomBitmap 		= customizeParams.roomBitmap;
			_submitImageParams.forgroundBitmap 	= customizeParams.forgroundBitmap;
			_submitImageParams.userEmail		= customizeParams.userEmail;
			
			if(_submitImageParams.isSlideshow){
				Out.debug(this, "isSlideShow");
				var photoArray:Array = new Array();
				for(var i:int=0; i<customizeParams.photoUrls.length; i++){
					var obj:Object =  new Object();
					obj.photo_id = customizeParams.photoIds[i];
					obj.photo_url = customizeParams.photoUrls[i];
					photoArray.push(obj);
				}
				_submitImageParams.mediaId 			= JSON.encode(photoArray);
				
				//Out.error(this, "this should be a slideshow" + _submitImageParams.isSlideshow);
			}else{
				_submitImageParams.mediaId 			= youtube && youtube.videoId ? youtube.videoId : _appData.environment.youtube.video;
				Out.debug(this, "isVideo: "+_submitImageParams.mediaId);

			}
			
			_submitImageParams.title 			= customizeParams.tailgateName;
			_submitImageParams.fbPostParams		= facebookPostParams;
			if(themeParams) _submitImageParams.roomType			= String(themeParams.roomIndex);
			if(themeParams) _submitImageParams.tvSize			= String(themeParams.tvIndex);
			//dispatch(new SubmitGalleryItemEvent(SubmitGalleryItemEvent.SAVE_IMAGE_TO_GALLERY, submitImageParams));
			return _submitImageParams;
		}
		
		public function set submitImageParams(_value:SubmitGalleryItemParams):void
		{
			_submitImageParams = _value;
		}
		

		public function get customizeParams():CustomizeParams{
			if(!_customizeParams)
				_customizeParams = new CustomizeParams();
			
			return _customizeParams;
		}	
		
		public function get tvButtonData():XMLList{
			return pageData.(@id == "theme").selection.(@id == "tv_sizes").navigation.button;
		}
		
		public function get roomImageButtonData():XMLList{
			return pageData.(@id == "theme").selection.(@id == "rooms").navigation.(@id == "carousel_photo").button;
		}
		
		private function get colorButtonData():XMLList{
			return pageData.(@id == "theme").colors.navigation.button;
		}
		
		public function customizeNavigationId(_index:int):String{
			return pageData.(@id == "customize").selection[_index].@id;
		}
		
		public function customizeButtonId(_navIndex:int, _btnIndex:int):String{
			return pageData.(@id == "customize").selection[_navIndex].navigation.button[_btnIndex].@id;
		}
		
		public function customizeItemColor(_navIndex:int, _btnIndex:int):String{
			return pageData.(@id == "customize").selection[_navIndex].navigation.button[_btnIndex].@grayScale;
		}
		
		public function set likeStatus(_status:Boolean):void{
			_likeStatus = _status;
		}
		
		public function get likeStatus():Boolean{
			return _likeStatus;
		}	
		
		public function set baseUrl(_url:String):void{
			_baseUrl = _url;
		}
		
		public function get baseUrl():String{
			return _baseUrl;
		}
		
		public function get imageUrl():String{
			return baseUrl + Vo.IMAGES_URL;
		}

		public function get facebook():FacebookData
		{
			return _facebook;
		}

		public function set facebook(value:FacebookData):void
		{
			_facebook = value;
			dispatch(new SharpAppEvent(SharpAppEvent.APP_DATA_RECEIVED, likeStatus, baseUrl, tid));
		}
		
		public function get youtube():YoutubeData
		{
			return _youtube;
		}
		
		public function set youtube(value:YoutubeData):void
		{
			_youtube = value;
			
			
			if(_youtube.videoUrl) {
				
				if(_youtube.videoUrl.indexOf("?")!=-1){
					var videoId:String = String(ValidationUtils.validateYoutubeURL(_youtube.videoUrl)["v"])
					
					if(_youtube.videoUrl.indexOf("v=") == -1 || videoId.length != 11){
						_youtube.valid = false;
					}else{
						_youtube.valid = true;
						_youtube.videoId = videoId;
						_youtube.videoImageUrl = "http://i.ytimg.com/vi/" + youtube.videoId + "/0.jpg";
					}
				}
				
			}
		}

		public function get wallPostParams():WallPostParams
		{
			return _wallPostParams;
		}
		
		public function set wallPostParams(value:WallPostParams):void
		{
			_wallPostParams = value;
			
			dispatch(new FacebookSessionEvent(FacebookSessionEvent.POST_TO_WALL, wallPostParams));
			
		}

		public function get tid():String
		{
			return _tid;
		}

		public function set tid(value:String):void
		{
			_tid = value;
			
			if(_submitImageParams)
				_submitImageParams.tid = _tid;
		}
	}
}