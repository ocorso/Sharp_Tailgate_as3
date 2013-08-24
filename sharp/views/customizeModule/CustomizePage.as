package sharp.views.customizeModule
{
	import cfm.core.containers.CFM_ObjectContainer;
	import cfm.core.events.CFM_NavigationEvent;
	import cfm.core.graphics.CFM_Graphics;
	import cfm.core.navigation.CFM_SimpleNavigation;
	import cfm.core.text.CFM_TextField;
	import cfm.core.ui.CFM_DropdownMenu;
	import cfm.core.vo.CFM_TextFieldParams;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.events.LoaderEvent;
	import com.greensock.events.TransformEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.transform.TransformManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import net.ored.util.out.Out;
	
	import sharp.events.SharpAppEvent;
	import sharp.events.SharpNavigationEvent;
	import sharp.events.SharpPageEvent;
	import sharp.model.vo.Vo;
	import sharp.views.appMainButton.AppMainButton;
	import sharp.views.appMainButton.CustomizeSmallerButton;
	import sharp.views.appTemplate.SharpPageTemplate;
	import sharp.views.customizeModule.customizeNavigation.CustomizeDropdownMenu;
	import sharp.views.customizeModule.customizeNavigation.buttons.ToolTipView;
	import sharp.views.customizeModule.customizeNavigation.navigations.CustomizeThumbNavigation;
	import sharp.views.customizeModule.event.CustomizeEvent;
	import sharp.views.customizeModule.itemCanvas.DraggableItem;
	import sharp.views.customizeModule.itemCanvas.DraggableItemCanvas;
	import sharp.views.customizeModule.subPages.FinishPage;
	import sharp.views.customizeModule.subPages.PreviewPage;
	import sharp.views.youtubeModule.YouTubePlayer;
	
	public class CustomizePage extends SharpPageTemplate
	{

		public var previewPage							:PreviewPage;
		public var finishPage							:FinishPage;

		private var dropdownButton						:CustomizeDropdownMenu;
		private var customizeDropdownContainer			:CFM_ObjectContainer;
		private var customizeDropdownArray				:Array;

		private var roomHolder							:CFM_ObjectContainer;
		private var backgroundHolder					:CFM_ObjectContainer;
		private var forgroundHolder						:CFM_ObjectContainer;
		private var finishImageHolder					:CFM_ObjectContainer;
		private var roomImage							:ContentDisplay;
		private var furnitureImage						:ContentDisplay;
		private var videoImage							:ContentDisplay;
		private var slideContainer						:CFM_ObjectContainer;
		private var itemCanvas							:DraggableItemCanvas;
		private var youtubePlayer						:YouTubePlayer;
		private var bannerClip							:MovieClip;
		private var photoClip							:MovieClip;
		public var tvClip								:TV_Room;
		private var roomBitmapData						:BitmapData;
		private var backgroundBitmapData				:BitmapData;
		private var forgroundBitmapData					:BitmapData;
		public var photoImage							:ContentDisplay;
		
		private var _roomName							:String;
		private var _primaryColor						:uint;
		private var _secondaryColor						:uint;
		private var _roomBitmap							:Bitmap;
		private var _backgroundBitmap					:Bitmap;
		private var _forgroundBitmap					:Bitmap;
		private var _tailgateName						:String;
		private var _contentX							:Number;
		private var _contentY							:Number;
		private var _transformManager					:TransformManager;
		private var slideShowTimer						:Timer;
		private var slideShowCount						:int;
		private var tooltip								:ToolTipView;
		private var tooltipShow							:Boolean = false;
		
		public var currentPageData						:XML;
		
		// =================================================
		// ================ Callable
		// =================================================

		

		public function switchStatus(_page:String, _isSlideShow:Boolean):void{

			switch(_page){
				case "customize":
					showCustomizePage();
					break;
				case "preview":
					showPreviewPage();
					break;
				case "finish":
					showFinishPage(_isSlideShow);
					break;
			}
		}

		
		public function buildRoom(_imgUrl:String):void{
			var loader:ImageLoader = new ImageLoader(_imgUrl, 
				{
					//container:_content,
					noCache:true,
					onComplete:onImageLoad
				});
			loader.load();
		}
		
		public function buildFurniture(_imgUrl:String):void{
			var loader:ImageLoader = new ImageLoader(_imgUrl, 
				{
					//container:_content,
					noCache:true,
					onComplete:onFurnitureImageLoad
				});
			loader.load();
		}

		public function checkDropdownOpen(_index:int):void{
			for (var i:String in customizeDropdownArray){
				if(int(i) == _index) {
					if(customizeDropdownContainer.getChildIndex(customizeDropdownArray[i]) < customizeDropdownContainer.numChildren-1)
						customizeDropdownContainer.setChildIndex(customizeDropdownArray[i], customizeDropdownContainer.numChildren-1);
				}else{
					if((customizeDropdownArray[i] as CustomizeDropdownMenu).menuOpen) 
						(customizeDropdownArray[i] as CustomizeDropdownMenu).closeMenu();
				}	
			}
			
			previewPage.checkMenuOpen(_index);
		}
		
		public function updateItemCanvas(_color1:uint, _color2:uint, _imgUrl:String, _colorType:String):void{
 
			itemCanvas.updateItem(_color1, _color2, _imgUrl, _colorType);
		}
		
		public function updateTeamName(_teamName:String, _difX:Number, _difY:Number, _difScale:Number):void{
			bannerClip.team.teamName.text = _teamName;
			bannerClip.team.scaleX = bannerClip.team.scaleY = 1;			
			if(roomName == "backyard" || roomName == "living_room"){
				if(bannerClip.team.height > bannerClip.height - 50)
					bannerClip.team.scaleX = bannerClip.team.scaleY = (bannerClip.background.height/bannerClip.team.height)-_difScale;
			}else{
				if (bannerClip.team.width > bannerClip.background.width-30){
					bannerClip.team.scaleX = bannerClip.team.scaleY = (bannerClip.background.width/bannerClip.team.width) - _difScale;
				}
			}
			
			bannerClip.team.x = (bannerClip.background.width - bannerClip.team.width)*.5 + _difX;
			bannerClip.team.y = (bannerClip.background.height - bannerClip.team.height)*.5 + _difY;
				
		}

		
		public function buildFinishRoom():void{
			finishImageHolder.addChild(forgroundBitmap);
			finishImageHolder.visible = false;
			finishImageHolder.alpha = 0;
		}
		
		public function buildVideoImage(_imageUrl:String):void{
			Security.loadPolicyFile("http://s.ytimg.com/crossdomain.xml");
			
			if(videoImage){
				tvClip.contentHolder.removeChild(videoImage);
				videoImage = null;
			}
			var vImgloader:ImageLoader = new ImageLoader(_imageUrl, 
				{
					container:tvClip.contentHolder,
					width:tvClip.contentMask.width+10,
					height:tvClip.contentMask.height,
					scaleMode:"proportionalOutside",
					noCache:true,
					onComplete:onVideoImageLoad
				});
			vImgloader.load();
		}
		
		public function buildSlideImage(_imageUrls:Array):void{
			if(videoImage){
				tvClip.contentHolder.removeChild(videoImage);
				videoImage = null;
				trace("videoImage removed");
			}
			
			if (!slideContainer){
				trace("CREATE slideContainer");
				slideContainer = new CFM_ObjectContainer;
				tvClip.contentHolder.addChild(slideContainer);				
			}
			
			for (var i:int = 0; i < _imageUrls.length; i++){
				var vImgloader:ImageLoader = new ImageLoader(_imageUrls[i], 
					{
						width:tvClip.contentMask.width+10,
						height:tvClip.contentMask.height,
						scaleMode:"proportionalOutside",
						noCache:true,
						onComplete:onSlideImageLoad
					});
				
				
				var cd:ContentDisplay = new ContentDisplay(vImgloader);
				if (i > 0) cd.alpha = 0;
				slideContainer.addChild(cd);
				
				vImgloader.load();
			}
			if (slideContainer.numChildren > 1) buildSlideShow();
		}		
		
		
		public function updatePhotoFrame(_url:String, _width:Number, _contentX:Number):void{

			var photoloader:ImageLoader = new ImageLoader(_url, 
				{
					container:photoClip.imgHolder,
					width:_width,
					height:Vo.FACEBOOK_THUMB_HEIGHT,
					x:_contentX,
					scaleMode:"proportionalOutside",
					noCache:true,
					onComplete:onPhotoFrameImageLoad
				});
			photoloader.load();
		}
		
		public function removePhoto():void{
			
			switch(Vo.customizeParams.listId) {
				case "personalization":
					if(photoImage) {
						photoClip.imgHolder.removeChild(photoImage);
						photoImage = null;
					}		
					break;
				
				case "enter_video":
					trace("CLEAR enter video");
					if(videoImage){
						tvClip.contentHolder.removeChild(videoImage);
						videoImage = null;				
					}
					
					if (slideContainer.numChildren > 0)
						slideContainer.removeAllChildren();					
					break;
			}			
		}
		
		public function removeTV():void{
			if(tvClip){
				backgroundHolder.removeChild(tvClip);
				tvClip = null;
			}
		}
		
		public function showTooltip():void{
			
			if(!tooltipShow) tooltip.showTooltip();
			tooltipShow = true;
		}
		
		public function invisibleTooltip():void{
			if(tooltip.visible) tooltip.visible = false;
		}
		
		public function hideTooltip():void{
			tooltip.hideTooltip();
		}

		// =================================================
		// ================ Create and Build
		// =================================================
		override protected function build():void{
			
			super.build();
			pageNavigation.scaleX = pageNavigation.scaleY = Vo.LARGE_PAGE_NAV_SCALE;
			pageNavigation.setProperties({x:(stage.stageWidth - pageNavigation.width) - 80, y:Vo.PAGE_NAVIGATION_Y_TOP});
			buildCustomizeDropdownNavigation();
			buildImageHolder();
			buildPreviewPage();
			buildFinishPage();
			_transformManager = new TransformManager({allowDelete:false, hideCenterHandle:true});
			_transformManager.addEventListener(TransformEvent.MOVE, onItemTransform, false, 0, true);
		}
		
		private function buildImageHolder():void{
			roomHolder = new CFM_ObjectContainer();
			roomHolder.renderTo(_content);
			
			backgroundHolder = new CFM_ObjectContainer();
			backgroundHolder.renderTo(roomHolder);
			
			finishImageHolder = new CFM_ObjectContainer();
			finishImageHolder.renderTo(_content);
		}
		
		public function buildForgroundHolder():void{
			forgroundHolder = new CFM_ObjectContainer();
			forgroundHolder.renderTo(roomHolder);
			
		}

		private function buildPreviewPage():void{
			previewPage = new PreviewPage(0, xml.preview[0], null);
			previewPage.renderTo(_content);
			previewPage.alpha = 0;
			previewPage.visible = false;
			previewPage.y = -10;
		}
		
		private function buildFinishPage():void{
			finishPage = new FinishPage(0, xml.finish[0], null);
			finishPage.renderTo(_content);
			finishPage.alpha = 0;
			finishPage.visible = false;
			finishPage.y = -10;
		}
		
		private function buildCustomizeDropdownNavigation():void{
			
			customizeDropdownContainer = new CFM_ObjectContainer();
			customizeDropdownContainer.renderTo(this);
			customizeDropdownContainer.visible = false;
			customizeDropdownContainer.alpha = 0;
			customizeDropdownContainer.x = Vo.MARGIN_LEFT;
			customizeDropdownContainer.y = Vo.DROPDOWN_MENU_Y;

			var i:Number = 0;
			customizeDropdownArray = new Array();
			for each(var selectionItem:XML in xml.selection){
				if(selectionItem.@type == "dropdown"){
					dropdownButton = new CustomizeDropdownMenu(selectionItem.navigation.@type, i,selectionItem.@id,selectionItem.@id,selectionItem.@heading,selectionItem.navigation);	
				}else if(selectionItem.@type == "input"){
					dropdownButton = new CustomizeDropdownMenu(selectionItem.@type, i,selectionItem.@id,selectionItem.@id,selectionItem.@heading,selectionItem.(@id == "personalization"));
				}
				dropdownButton.alpha = 0;
				dropdownButton.visible = false;
				dropdownButton.renderTo(customizeDropdownContainer);
				customizeDropdownArray.push(dropdownButton);
				i++;
			}
			
			for(var j:int=0; j<customizeDropdownArray.length; j++){
				if(j!=0)customizeDropdownArray[j].x = customizeDropdownArray[j-1].x + CFM_DropdownMenu(customizeDropdownArray[j-1]).buttonWidth + Vo.MENU_BUTTON_SPACING;
			}
		}
		
		public function buildYoutubePlayer():void{
			youtubePlayer = new YouTubePlayer();
			youtubePlayer.renderTo(tvClip.contentHolder);
			youtubePlayer.visible = false;
			youtubePlayer.alpha = 0;
		}
		
		public function buildBanner(_class:String, _x:Number, _y:Number):void{
			TeamBannerBackyard, TeamBannerRooftop, TeamBannerGameRoom, TeamBannerLivingRoom,TeamBannerHomeTheater
			var BannerClass:Class = getDefinitionByName(_class) as Class;
			bannerClip = new BannerClass() as MovieClip;
			forgroundHolder.addChild(bannerClip);
			bannerClip.x = _x;
			bannerClip.y = _y;
			bannerClip.visible = false;
			bannerClip.alpha = 0;
			
			TweenMax.to(bannerClip.background, .1, {colorTransform:{tint:primaryColor, tintAmount:.9}});
			TweenMax.allTo([bannerClip.forground, bannerClip.team, bannerClip.outline], .1, {tint:secondaryColor});

			TextField(bannerClip.team.teamName).wordWrap = false;
			TextField(bannerClip.team.teamName).autoSize = TextFieldAutoSize.LEFT;
		}
		

		public function buildPhotoHolder(_class:String, _x:Number, _y:Number):void{

			PhotoHolderBackyard, PhotoHolderRooftop, PhotoHolderGameRoom, PhotoHolderLivingRoom, PhotoHolderHomeTheater
			var PhotoHolderClass:Class = getDefinitionByName(_class) as Class;
			photoClip = new PhotoHolderClass() as MovieClip;
			forgroundHolder.addChild(photoClip);
			photoClip.x = _x;
			photoClip.y = _y;
			photoClip.visible = false; 
			photoClip.alpha = 0;
		}
		
		public function buildTooltip(_x:Number, _y:Number):void{
			
			tooltip = new ToolTipView(xml.tooltip, 150, 55);
			tooltip.renderTo(roomHolder);
			tooltip.x = _x - tooltip.width*.5 + 33;
			tooltip.y = _y - tooltip.height - 8;
		}

		public function buildTV(_tvY:Number, _tvSize:Number, _roomType:String, _defaultImage:String):void{

			tvClip = new TV_Room();
			backgroundHolder.addChild(tvClip);
			tvClip.visible = false;
			tvClip.alpha = 0;
			tvClip.scaleX = tvClip.scaleY = _tvSize;
			(_tvSize == .7 && _roomType == "wall") ? tvClip.y = _tvY - 20 : tvClip.y = _tvY;
			tvClip.x = roomImage.x + (roomImage.width - tvClip.width)*.5;

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
		
		public function buildItemCanvas():void{
			itemCanvas = new DraggableItemCanvas();
			itemCanvas.renderTo(forgroundHolder);
		}

		
		private function buildSlideShow():void{
			slideShowCount = 0;
			slideShowTimer = new Timer(Vo.SLIDESHOW_SPEED);
			slideShowTimer.addEventListener(TimerEvent.TIMER, slideShowTimerTick, false, 0, true);
			slideShowTimer.start();
		}
		
		// =================================================
		// ================ Workers
		// =================================================
		private function showCustomizePage():void{
			
			TweenMax.killChildTweensOf(customizeDropdownContainer);
			TweenMax.killTweensOf(heading);
			TweenMax.killTweensOf(subHeading);
			
			TweenMax.allTo([bannerClip, photoClip, tvClip, pageNavigation, customizeDropdownContainer], .3, {autoAlpha:1});
			heading.alpha = 0;
			heading.visible = false;
			heading.x = -50;
			subHeading.alpha = 0;
			subHeading.visible = false;
			subHeading.x = -50;
			TweenMax.to(heading, .5, {delay:.1, autoAlpha:1, x:Vo.MARGIN_LEFT - 5, ease:Cubic.easeOut});
			TweenMax.to(subHeading, .5, {delay:.2, autoAlpha:1, x:Vo.MARGIN_LEFT - 2, ease:Cubic.easeOut});
			TweenMax.to(previewPage, .3, {autoAlpha:0});
			
			previewPage.hidePreviewDropdown();
			
			for (var j:String in customizeDropdownArray){
				customizeDropdownArray[j].x = customizeDropdownArray[j].x - 30
				TweenMax.to(customizeDropdownArray[j], .3, {autoAlpha:1, x:customizeDropdownArray[j].x + 30, delay:.2 + int(j)*.1, ease:Cubic.easeOut});
			}
		}
		
		private function showPreviewPage():void{
			
			TweenMax.killChildTweensOf(previewPage);
			
			TweenMax.allTo([pageNavigation, customizeDropdownContainer, heading, subHeading], .3, {autoAlpha:0});
			TweenMax.to(previewPage, .3, {autoAlpha:1});
			
			for (var i:String in customizeDropdownArray){
				if((customizeDropdownArray[i] as CustomizeDropdownMenu).menuOpen) (customizeDropdownArray[i] as CustomizeDropdownMenu).closeMenu();
				TweenMax.to(customizeDropdownArray[i], .3, {autoAlpha:0, delay:int(i)*.1});
			}
			
			previewPage.showPreviewDropdown();
		}
		
		private function showFinishPage(_isSlideshow:Boolean):void
		{
			// TODO Auto Generated method stub
			previewPage.hidePreviewDropdown();
			if(tailgateName) finishPage.updateHeading(tailgateName.toUpperCase());
			TweenMax.allTo([forgroundHolder, pageNavigation, customizeDropdownContainer, heading, previewPage], .3, {autoAlpha:0});
			TweenMax.allTo([finishPage,finishImageHolder], .3, {autoAlpha:1});
			finishImageHolder.mouseEnabled = false;
			if(!_isSlideshow) {
				buildYoutubePlayer();
				TweenMax.to(youtubePlayer, .3, {autoAlpha:1});
			}
		}
		
		// =================================================
		// ================ Handlers
		// =================================================
		private function onItemTransform(e:TransformEvent):void{
			hideTooltip();
		}
		private function onImageLoad(event:LoaderEvent):void {
			roomImage = event.target.content;
			backgroundHolder.addChildAt(roomImage, 0);
			TweenMax.from(roomImage, .3, {alpha:0});
			roomHolder.x = (stage.stageWidth - roomHolder.width)*.5;
			roomHolder.y = Vo.ROOM_Y;
			
			finishImageHolder.x = roomHolder.x;
			finishImageHolder.y = roomHolder.y;
			
			dispatchEvent(new CustomizeEvent(CustomizeEvent.ROOM_IMAGE_LOADED, false));

		}
		
		private function onFurnitureImageLoad(event:LoaderEvent):void{
			furnitureImage = event.target.content;
			forgroundHolder.addChild(furnitureImage);
			TweenMax.from(furnitureImage, .3, {alpha:0});
			furnitureImage.mouseEnabled = false;
			furnitureImage.y = Vo.ROOM_IMAGE_HEIGHT - furnitureImage.height;
			dispatchEvent(new CustomizeEvent(CustomizeEvent.FURNITURE_IMAGE_LOADED, false));
		}
		
		private function onVideoImageLoad(event:LoaderEvent):void{
		    videoImage = event.target.content;
		}
		
		private function onSlideImageLoad(event:LoaderEvent):void{
		}
		
		private function onPhotoFrameImageLoad(event:LoaderEvent):void{
			photoImage = event.target.content;
			_transformManager.removeItem(photoImage);
			_transformManager.addItem(photoImage);
		}
		
		private function slideShowTimerTick(e:TimerEvent):void{
			if(slideContainer.numChildren == 0){
				Out.info(this, "SLIDESHOW STOPPED");
				slideShowTimer.stop();
				slideShowTimer.removeEventListener(TimerEvent.TIMER, slideShowTimerTick);
			}
			else
				playSlideshow();
		}

		// =================================================
		// ================ Animation
		// =================================================
		private function playSlideshow():void{
			var previousIdx:int = slideShowCount;
			slideShowCount ++;
			slideShowCount %= slideContainer.numChildren;
			
			if (slideShowCount == 0){
				slideContainer.getChildAt(slideShowCount).alpha = 1;
				TweenMax.to(slideContainer.getChildAt(previousIdx), 1, {alpha:0});
			}
			else{
				TweenMax.to(slideContainer.getChildAt(slideShowCount), 1, {alpha:1});
				TweenMax.to(slideContainer.getChildAt(previousIdx), 0, {alpha:0, delay:1});
			}
		}
		
		// =================================================
		// ================ Getters / Setters
		// =================================================

		public function get secondaryColor():uint{return _secondaryColor;}
		public function set secondaryColor(value:uint):void{_secondaryColor = value;}
		
		public function get primaryColor():uint{return _primaryColor;}
		public function set primaryColor(value:uint):void{_primaryColor = value;}
		
		public function get tailgateName():String{return _tailgateName;}	
		public function set tailgateName(value:String):void{_tailgateName = value;}
		
		public function get contentY():Number{return _contentY;}
		public function set contentY(value:Number):void{_contentY = value;}
		
		public function get contentX():Number{return _contentX;}
		public function set contentX(value:Number):void{_contentX = value;}
		
		public function get roomName():String{return _roomName;}
		public function set roomName(value:String):void{_roomName = value;}
		
		private function get thankYouParams():CFM_TextFieldParams{
			var p:CFM_TextFieldParams = headingParams;
			p.size = 18;
			return p;
		}
	
		
		public function get roomBitmap():Bitmap{
			
			var matrix:Matrix = new Matrix();
			matrix.scale(Vo.GALLERY_THUMB_WIDTH/Vo.ROOM_IMAGE_WIDTH, Vo.GALLERY_THUMB_HEIGHT/Vo.ROOM_IMAGE_HEIGHT);
			
			roomBitmapData = new BitmapData(Vo.GALLERY_THUMB_WIDTH, Vo.GALLERY_THUMB_HEIGHT, false, 0xFFFFFFFF);
			roomBitmapData.draw(roomHolder, matrix, null, null, null, true);
			
			_roomBitmap = new Bitmap(roomBitmapData, PixelSnapping.NEVER, true);
			
			return _roomBitmap;
		}
		
		public function get forgroundBitmap():Bitmap{
			forgroundBitmapData = new BitmapData(Vo.ROOM_IMAGE_WIDTH,Vo.ROOM_IMAGE_HEIGHT,true,0x000000);
			forgroundBitmapData.draw(forgroundHolder);
			_forgroundBitmap = new Bitmap(forgroundBitmapData);
			return _forgroundBitmap;
		}
		
		// =================================================
		// ================ Core Handler
		// =================================================
		private function onSubPageNavClicked(e:CFM_NavigationEvent):void{
			dispatchEvent(new SharpNavigationEvent(SharpNavigationEvent.SUB_PAGE_NAVIGATION_CLICKED, e.index,e.id));
		}
		
		// =================================================
		// ================ Overrides
		// =================================================
		
		override protected function addListeners():void{
			super.addListeners();
			previewPage.addEventListener(CFM_NavigationEvent.BUTTON_CLICKED, onSubPageNavClicked, false, 0, true);
			finishPage.addEventListener(CFM_NavigationEvent.BUTTON_CLICKED, onSubPageNavClicked, false, 0, true);
		}
		
		
		override protected function removeListeners():void{
			super.removeListeners();
			previewPage.removeEventListener(CFM_NavigationEvent.BUTTON_CLICKED, onSubPageNavClicked);
			finishPage.removeEventListener(CFM_NavigationEvent.BUTTON_CLICKED, onSubPageNavClicked);
		}
		
		// =================================================
		// ================ Constructor
		// =================================================
		public function CustomizePage(_index:Number, _xml:XML, _params:Object)
		{
			super(_index, _xml, _params);
		}

	}
}