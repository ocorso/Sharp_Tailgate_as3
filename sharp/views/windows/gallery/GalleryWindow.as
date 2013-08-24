package sharp.views.windows.gallery
{
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.events.CFM_ButtonEvent;
	import cfm.core.events.CFM_PageEvent;
	import cfm.core.text.CFM_TextField;
	import cfm.core.vo.CFM_GraphicsParams;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import com.adobe.serialization.json.JSON;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.display.ContentDisplay;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import mx.preloaders.Preloader;
	
	import net.ored.util.ORedUtils;
	import net.ored.util.out.Out;
	
	import sharp.events.GalleryEvent;
	import sharp.model.vo.Vo;
	import sharp.views.appTemplate.SharpPageTemplate;
	import sharp.views.windows.SharpPopupWindowTemplate;
	import sharp.views.windows.buttons.LikeButton;
	import sharp.views.windows.buttons.WindowCloseButton;
	import sharp.views.windows.gallery.navigations.ShareNavigation;
	import sharp.views.youtubeModule.YouTubePlayer;

	public class GalleryWindow extends SharpPopupWindowTemplate
	{
		private const BACKGROUND_WIDTH 				:Number = 753;
		private const BACKGROUND_HEIGHT				:Number = 700;
		
		private var likeButton						:LikeButton;
		private var userNameField					:CFM_TextField;
		private var dateField						:CFM_TextField;
		private var data							:XML;
		private var rsvpField						:CFM_TextField;
		private var roomImage						:ContentDisplay;
		private var forgroundImage					:ContentDisplay;
		private var userImage						:ContentDisplay;
		private var likeNumberField					:CFM_TextField;
		private var closedButton					:WindowCloseButton;
		private var shareNav						:ShareNavigation;
		private var likeNumber 						:int;
		public var youtubePlayer					:YouTubePlayer;
		private var imagePreloader					:ImagePreloader;
		private var slideshowContainer				:CFM_ObjectContainer;
		private var userLike						:Boolean = false;
		private var roomHolder						:CFM_ObjectContainer;
		public var tvClip							:TV_Room;
		
		public var roomImageUrl						:String;
		public var forgroundImageUrl			    :String;
		
		private var slideShowTimer					:Timer;
		private var slideShowCount					:int;
		
		private const IMAGE_WIDTH					:Number = 658;
		private const IMAGE_HEIGHT					:Number = 521;
		private var SCALE_X							:Number;
		private var SCALE_Y							:Number;
		
		private var slideshowLoadCount				:int = 0;
		public var slideshowNumber					:int;
		private var slideshowPreloader				:ImagePreloader;
	
		// =================================================
		// ================ Callable
		// =================================================


		public function updateWindow(_data:XML, _userId:String, _access_token:String):void{
			Out.info(this, _data);
			data = _data;
			
			if(roomImage) {
				_content.removeChild(roomImage);
				roomImage = null;
			}
			if(userImage) {
				_content.removeChild(userImage);
				userImage = null;
			}
			buildImage();

			imagePreloader.visible = true;
			
			updateWindowText();
			
			//oc: move to like fetch
			_fetchLikes(data.likes.fetch + "/" + _userId);
		}
		
		public function showDefaultImage(_defaultImage:String):void{
			for(var i:int=0; i<tvClip.defaultImage.numChildren; i++){
				var defaultImageClip:MovieClip = MovieClip(tvClip.defaultImage.getChildAt(i));
				defaultImageClip.alpha = 0;
				defaultImageClip.visible = true;
				if(defaultImageClip.name == _defaultImage) 
					TweenMax.to(defaultImageClip, .3, {autoAlpha:1, ease:Cubic.easeOut});
				else
					TweenMax.to(defaultImageClip, .3, {autoAlpha:0, ease:Cubic.easeOut});
			}
		}
		
		
		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function build():void{
			super.build();
			
			heading.setProperties({x:-Vo.WINDOW_PADDING + 5});
			buildImagePreloader();
			buildRoomHolder();
			buildUserName();
			buildDate();
			buildRSVPText();
			buildLikeButton();
			buildLikeNumber();
			buildShareNavigation();

			_content.visible = false;
			_content.alpha = 0;
		}
		
		private function buildRoomHolder():void{
			roomHolder = new CFM_ObjectContainer();
			roomHolder.renderTo(_content);
		}
		
		private function buildLikeButton():void{
			likeButton = new LikeButton(0,"like","like","",0,0,true,false);
			likeButton.renderTo(_content);
			likeButton.addEventListener(CFM_ButtonEvent.SELECTED, likeClicked, false, 0, true);
			likeButton.addEventListener(CFM_ButtonEvent.DE_SELECTED, likeClicked, false, 0, true);
			likeButton.visible = false;
		};
		
		private function buildImage():void{
			var loader:ImageLoader = new ImageLoader(roomImageUrl, 
				{
					container:roomHolder,
					noCache:true,
					width:IMAGE_WIDTH,
					height:IMAGE_HEIGHT,
					onComplete:onImageLoad
				});
			loader.load();
		}
		
		private function buildForgroundImage():void{
			var loader:ImageLoader = new ImageLoader(forgroundImageUrl, 
				{
					container:roomHolder,
					noCache:true,
					onComplete:onForgroundImageLoad
				});
			loader.load();
		}
		
		public function buildTV(_tvY:Number, _tvSize:Number, _roomType:String):void{
			tvClip = new TV_Room();
			_tvY = _tvY*SCALE_Y;
			tvClip.scaleX = _tvSize*SCALE_X;
			tvClip.scaleY = _tvSize*SCALE_Y;
			roomHolder.addChild(tvClip);
			(_tvSize == .7 && _roomType == "wall") ? tvClip.y = _tvY - (20*tvClip.scaleY) : tvClip.y = _tvY;
			tvClip.x = (IMAGE_WIDTH - tvClip.width)*.5;
			tvClip.alpha = 0;

		}
		
		private function buildProfilePicture(_url:String):void{
			var loader:ImageLoader = new ImageLoader(_url, 
				{
					container:_content,
					noCache:true,
					onComplete:onProfileImageLoad
				});
			loader.load();

		}
		
		private function buildUserName():void{
			userNameField = new CFM_TextField("", userNameParams);
			userNameField.renderTo(_content);
			
		}
		
		private function buildDate():void{
			dateField = new CFM_TextField("", userNameParams);
			dateField.renderTo(_content);
			
		}
		
		private function buildRSVPText():void{
			rsvpField = new CFM_TextField("RSVP to this tailgate! ", rsvpParams);
			rsvpField.renderTo(_content);
			
		}
		
		private function buildLikeNumber():void{
			likeNumberField = new CFM_TextField("", rsvpParams);
			likeNumberField.renderTo(_content);
			
		}
		
		private function buildShareNavigation():void{
			shareNav = new ShareNavigation(xml.share_navigation.button);
			shareNav.renderTo(_content);
		}
		
		public function buildYoutubePlayer():void{
			youtubePlayer = new YouTubePlayer();
			youtubePlayer.renderTo(tvClip.contentHolder);
			youtubePlayer.alpha = 0;
			youtubePlayer.visible = false;
			TweenMax.to(youtubePlayer, .5, {autoAlpha:1});
			tvClip.defaultImage.visible = false;
		}
		
		private function buildImagePreloader():void{
			imagePreloader = new ImagePreloader();
			addChild(imagePreloader);
			imagePreloader.x = -10;
			imagePreloader.y = 0;
		}
		
		public function loadFacebookPhoto(_imageUrl:String):void{
			var imageLoader:ImageLoader = new ImageLoader(_imageUrl, 
				{
					container:slideshowContainer,
					noCache:true,
					width:tvClip.contentMask.width,
					height:tvClip.contentMask.height,
					scaleMode: "proportionalOutside",
					onComplete:onSlideshowImageLoad
				}	);
			
			imageLoader.load();
			tvClip.defaultImage.visible = false;
		}
		
		public function buildSlideshowContainer():void{
			slideshowContainer = new CFM_ObjectContainer();
			slideshowContainer.renderTo(tvClip.contentHolder);
			slideshowContainer.alpha = 0;
			slideshowContainer.visible =false;
			
			slideshowPreloader = new ImagePreloader();
			tvClip.contentHolder.addChild(slideshowPreloader);
			slideshowPreloader.x = (tvClip.contentMask.width - slideshowPreloader.width)*.5;
			slideshowPreloader.y = (tvClip.contentMask.height - slideshowPreloader.height)*.5;
		}
		
		private function addImageToSlideshowContainer(e:Event):void{
			var loader:URLLoader = URLLoader(e.currentTarget);
			
			loader.removeEventListener(Event.COMPLETE, buildSlideshowContainer);
			
			var data:Object = JSON.decode(loader.data);
			var imageData:Object = data;
			
			if(imageData) {
				var imageLoader:ImageLoader = new ImageLoader(imageData.source, 
					{
						container:slideshowContainer,
						noCache:true,
						width:tvClip.contentMask.width,
						height:tvClip.contentMask.height,
						scaleMode: "proportionalOutside",
						onComplete:onSlideshowImageLoad
					});
				imageLoader.load();
			}
		}
		
		// =================================================
		// ================ Workers
		// =================================================
		
		private function _fetchLikes($url:String):void{
			Out.status(this, "url: "+ $url);
			
			var ldr:URLLoader 	= new URLLoader();
			var req:URLRequest 	= new URLRequest($url);
			
			ldr.addEventListener(Event.COMPLETE, _onFetchLikes);
			ldr.load(req);
		}
		
		private function positionAssets():void{
			
			roomHolder.y = heading.y + heading.height + 10;
			userImage.y = 580;

			userNameField.setProperties({x:userImage.width + 10, y:userImage.y + userImage.height - (userNameField.height*2)});
			dateField.setProperties({x:userNameField.x, y:userNameField.y + userNameField.height});
			rsvpField.setProperties({x:280, y:userImage.y - 5});
			likeButton.setProperties({x:rsvpField.x + rsvpField.width + 10, y:rsvpField.y});
			likeNumberField.setProperties({x:likeButton.x + likeButton.width + 8, y:likeButton.y});
			shareNav.setProperties({x:380, y:rsvpField.y + rsvpField.height + 8});
			_content.setProperties({x:background.x + (background.width - _content.width)*.5, y:background.y + (background.height - _content.height)*.5});
		}
		
		private function updateWindowText():void{
			Out.warning(this, "numLikes: "+ data.likes); 
			userNameField.text 		= "by: " + data.full_name;
			dateField.text 			= data.created_at;
			(data.title) ? heading.text = String(data.title).toUpperCase() : heading.text = "MY TAILGATE";	
		}
		
		private function removeYoutube():void{
			if(youtubePlayer){
				youtubePlayer.remove();
				youtubePlayer = null;
			}
		}
		
		// =================================================
		// ================ Handlers
		// =================================================
		
		private function slideShowTimerTick(e:TimerEvent):void{
			if(slideshowContainer.numChildren == 0){
				Out.info(this, "SLIDESHOW STOPPED");
				slideShowTimer.stop();
				slideShowTimer.removeEventListener(TimerEvent.TIMER, slideShowTimerTick);
			}
			else{
				playSlideshow();
			}
		}
		
		private function playSlideshow():void{
			var previousIdx:int = slideShowCount;
			slideShowCount ++;
			slideShowCount %= slideshowContainer.numChildren;
			
			if (slideShowCount == 0){
				slideshowContainer.getChildAt(slideShowCount).alpha = 1;
				slideshowContainer.getChildAt(slideShowCount).visible = true;
				TweenMax.to(slideshowContainer.getChildAt(previousIdx), 1, {autoAlpha:0});
			}
			else{
				TweenMax.to(slideshowContainer.getChildAt(slideShowCount), 1, {autoAlpha:1});
				TweenMax.to(slideshowContainer.getChildAt(previousIdx), 0, {autoAlpha:0, delay:1});
			}
		}
		
		private function onImageLoad(event:LoaderEvent):void {
			roomImage = event.target.content;
			roomImage.alpha = 0;
			imagePreloader.visible = false;
			buildForgroundImage();
			buildProfilePicture(data.profile_pic);
		}
		
		private function onForgroundImageLoad(event:LoaderEvent):void {
			forgroundImage = event.target.content;
			forgroundImage.alpha = 0;

			forgroundImage.width = IMAGE_WIDTH;
			forgroundImage.height = IMAGE_HEIGHT;
			forgroundImage.mouseEnabled = false;
			
			TweenMax.to(roomImage, .3, {alpha:1});
			TweenMax.to(tvClip, .3, {delay:.2, alpha:1});
			TweenMax.to(forgroundImage, .3, {delay:.3, alpha:1});
		}
		
		protected function _onFetchLikes($e:Event):void
		{
			Out.status(this, "_onFetchLikes");
			
			var ldr:URLLoader = URLLoader($e.target);
			ldr.removeEventListener(Event.COMPLETE, _onFetchLikes);
			var likeInfo:Object = JSON.decode(ldr.data);
			
			//oc: use response...
			if(likeInfo.doesUserLike == "1") {
				userLike = true;
				likeButton.toSelect();
			}else{
				userLike = false;
				likeButton.toUnselect();
			}
			
			likeNumber = likeInfo.numLikes;
			_updateNumLikes();
			
			TweenMax.to(likeButton,.3,{autoAlpha:1});
		}
		private function onProfileImageLoad(event:LoaderEvent):void {
			userImage = event.target.content;
			positionAssets();

			TweenMax.to(_content, .3, {autoAlpha:1});
		}
		
		private function likeClicked(e:CFM_ButtonEvent):void{
			Out.debug(this, "likeClicked" +userLike);
			
			if(userLike){
				likeNumber = likeNumber - 1;
				likeButton.toUnselect();
				userLike = false;
			}else{
				likeNumber = likeNumber + 1;
				likeButton.toSelect();
				userLike = true;
			}
			
			_updateNumLikes();

			dispatchEvent(new GalleryEvent(GalleryEvent.LIKE_CLICKED, {isLiked:userLike}));
		}
		
		private function _updateNumLikes():void
		{
			likeNumberField.text = "|    RSVPs: " + likeNumber;
		}
		
		private function onSlideshowImageLoad(event:LoaderEvent):void {
			var image:ContentDisplay = event.target.content;
			image.alpha = 0;
			image.visible = false;
			
			if(slideshowLoadCount == slideshowNumber-1) {
				
				if(slideshowLoadCount == 0){
					slideshowPreloader.visible = false;
					TweenMax.to(slideshowContainer, .3, {autoAlpha:1});
					slideshowContainer.getChildAt(0).alpha = 1;
					slideshowContainer.getChildAt(0).visible = true;
				}else{
					buildSlideShow();
					TweenMax.to(slideshowContainer.getChildAt(0), 1, {autoAlpha:1});
				}
			}
			slideshowLoadCount++;
		}
		
		private function buildSlideShow():void{
			slideshowPreloader.visible = false;
			TweenMax.to(slideshowContainer, .3, {autoAlpha:1});
			slideShowCount = 0;
			slideShowTimer = new Timer(Vo.SLIDESHOW_SPEED);
			slideShowTimer.addEventListener(TimerEvent.TIMER, slideShowTimerTick, false, 0, true);
			slideShowTimer.start();
		}
		
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		
		private function get userNameParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.color = 0x646464;
			p.font = Vo.FONT_ARIAL;
			p.size = 12;
			return p;
		}
		
		private function get rsvpParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.color = Vo.BLACK;
			p.font = Vo.FONT_MEDIUM;
			p.size = 20;
			return p;
		}
		
		public function get tailgateName():String{
			return data.title;
		}
		
		public function get tid():String{
			return data.label;
		}
		
		override protected function get backgroundParams():CFM_GraphicsParams{
			var p:CFM_GraphicsParams = new CFM_GraphicsParams();
			p.width = BACKGROUND_WIDTH;
			p.height = BACKGROUND_HEIGHT;
			p.colors = [0xffffff];
			p.alphas = [1];
			return p;
		}
		
		override protected function get headingParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = new CFM_TextFieldParams();
			p.color = Vo.BLACK;
			p.size = 26;
			p.font = Vo.FONT_MEDIUM;
			return p;
		}

		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		
		override protected function onCloseClicked(e:CFM_ButtonEvent):void{
			super.onCloseClicked(e);
			removeYoutube();
		}

		// =================================================
		// ================ Constructor
		// =================================================

		public function GalleryWindow(_index:Number, _xml:XML, _params:Object)
		{
			super(_index, _xml, _params);
			
			_totalWidth	 = BACKGROUND_WIDTH;
			_totalHeight = BACKGROUND_HEIGHT;
			
			SCALE_X = IMAGE_WIDTH/Vo.ROOM_IMAGE_WIDTH;
			SCALE_Y = IMAGE_HEIGHT/Vo.ROOM_IMAGE_HEIGHT;
		}
	}
}